---
title: "How to finetune an LLM on a Slurm worker"
linkTitle: "Finetune LLM on Slurm"
weight: 8
---

<a id="finetuning_on_slurm_worker"></a>

This tutorial shows how to run LLM finetuning (Unsloth) on a **Slurm worker** appliance in OpenNebula.

You will learn how to:

* Install Slurm (controller and workers) from the OpenNebula marketplace.
* Configure the Slurm worker template (GPU and a start script that creates a folder, downloads the model, and installs dependencies at boot).
* Submit a finetuning job from the **Slurm controller** with a single command.

{{< alert title="Note" color="success" >}}
This guide uses an **NVIDIA H100L** and `nvidia-driver-570` as an example. If you use a different GPU, select the correct PCI device in Sunstone and install a compatible NVIDIA driver version.
{{< /alert >}}

---

## Install Slurm (controller and worker)

You need a running **OneGate** server so the controller can share the Munge key with workers. This is a hard requirements for the Slurm Controller node to be able to share the cluster Munge key. This server must be reachable by the Slurm Controller VM.

### Step 1: Deploy the Slurm Controller

1. **Import the Slurm Controller appliance** from the OpenNebula Marketplace. This downloads the VM template and disk image.

   ```shell
   onemarketapp export 'Service SlurmController' SlurmController --datastore default
   ```

2. **Adjust the SlurmController template** as needed (CPU, memory, disk size, network). Resource needs depend on cluster size (number of workers and jobs).

3. **Instantiate the Slurm Controller**:

   ```shell
   onetemplate instantiate SlurmController
   ```

4. **Wait for the controller to be ready:** SSH into the new SlurmController VM. The terminal will show configuration progress. When finished, you should see: **"All set and ready to serve 8)"**.

5. **Get the controller Munge key.** This key must be shared with all worker nodes for Slurm authentication:

   ```shell
   onevm show <VM-ID> | grep MUNGE
   ```

   Replace `<VM-ID>` with the ID of your SlurmController VM. Save the Munge key (base64) and the **Slurm Controller IP address**; you will need both when deploying workers.

### Step 2: Deploy the Slurm Worker(s)

1. **Import the Slurm Worker appliance** from the OpenNebula Marketplace.

   ```shell
   onemarketapp export 'Service SlurmWorker' SlurmWorker --datastore default
   ```

2. **Adjust the SlurmWorker template** as needed (CPU, memory, disk size, network). You will add GPU and other options later in this tutorial.

3. **Instantiate the Slurm Worker(s)** via the OpenNebula Sunstone web interface:
   * Set the **number of instances** (e.g. how many worker nodes you want).
   * Click **Next**.
   * When prompted, enter:
     * **Slurm Controller IP address** (the VM you deployed in Step 1). Ensure workers can reach this IP.
     * **Slurm Controller Munge key** (base64), from the `onevm show ... | grep MUNGE` output.

4. **Verify workers joined the cluster.** After a few minutes, on the **Slurm Controller** VM run:

   ```shell
   scontrol show nodes
   ```

   You should see your worker node(s) listed. You can then proceed to configure the worker template for finetuning (next section).

---

## Configure the Slurm worker template

This section adds GPU passthrough and a start script that, at boot, creates a folder, downloads the model, installs the NVIDIA driver and Python dependencies, and creates a sample finetuning script.

### Attach GPU to the worker

Add the GPU as a PCI device from **Sunstone**: **Templates** → **VM Templates** → **Update** the Slurm worker template → **Advanced options** → **PCI devices** tab. OpenNebula will insert the correct PCI class, device and vendor into the template.

<!-- Image: Sunstone PCI devices tab → img/sunstone-pci.png -->

### Add start script (create dir, download model, install dependencies)

Add the **start script** from **Sunstone**: **Templates** → **VM Templates** → **Update** the Slurm worker template → **Context** tab → paste the following into the **Start script** text field. 

The script creates `/opt/ai_model`, downloads the model and installs dependencies at boot. You can copy and paste it as-is; change the model ID or path if needed.

```bash
set -e
AI_DIR=/opt/ai_model

# Network: may not be required if DHCP/context already set resolv.conf and default route
echo "nameserver 8.8.8.8" > /etc/resolv.conf
ip route add default via 10.0.1.1

# Create dir for model, venv, and demo script
mkdir -p "$AI_DIR"

# System packages: NVIDIA driver + Python build deps and venv
apt update && apt install -y nvidia-driver-570 python3-pip python3-venv python3-dev build-essential
pip3 install --break-system-packages huggingface_hub
python3 -c "from huggingface_hub import snapshot_download; snapshot_download(repo_id='Qwen/Qwen2.5-1.5B-Instruct', local_dir='$AI_DIR')"
python3 -m venv "$AI_DIR/venv"
"$AI_DIR/venv/bin/pip" install --upgrade pip
"$AI_DIR/venv/bin/pip" install "numpy<2.4.0"
"$AI_DIR/venv/bin/pip" install unsloth datasets trl transformers

# Write Unsloth demo finetuning script
cat > "$AI_DIR/demo_finetune.py" << 'PYEOF'
#!/usr/bin/env python3
import os
from datasets import Dataset
from unsloth import FastLanguageModel
from trl import SFTTrainer
from transformers import TrainingArguments

MODEL_PATH = "/opt/ai_model"
OUTPUT_DIR = os.path.join(MODEL_PATH, "output")

alpaca = [
    {"instruction": "What is 2+2?", "input": "", "output": "4."},
    {"instruction": "Say hello in one word.", "input": "", "output": "Hello."},
    {"instruction": "Complete: The sky is", "input": "", "output": " blue."},
]

def fmt(e):
    return {"text": "### Instruction:\n{instruction}\n\n### Input:\n{input}\n\n### Response:\n{output}".format(**e)}

dataset = Dataset.from_list(alpaca)
dataset = dataset.map(fmt, remove_columns=dataset.column_names)

model, tokenizer = FastLanguageModel.from_pretrained(MODEL_PATH, max_seq_length=2048, dtype=None, load_in_4bit=True, local_files_only=True)
model = FastLanguageModel.get_peft_model(model, r=8, target_modules=["q_proj", "k_proj", "v_proj", "o_proj", "gate_proj", "up_proj", "down_proj"], lora_alpha=16, lora_dropout=0, bias="none", use_gradient_checkpointing="unsloth")

trainer = SFTTrainer(model=model, tokenizer=tokenizer, train_dataset=dataset, dataset_text_field="text", max_seq_length=2048, dataset_num_proc=1, packing=False, args=TrainingArguments(per_device_train_batch_size=2, gradient_accumulation_steps=2, max_steps=10, learning_rate=2e-4, bf16=True, output_dir=OUTPUT_DIR, report_to="none"))
os.makedirs(OUTPUT_DIR, exist_ok=True)
trainer.train()
model.save_pretrained_merged(OUTPUT_DIR, tokenizer, save_method="merged_16bit")
tokenizer.save_pretrained(OUTPUT_DIR)
print("Saved to", OUTPUT_DIR)
PYEOF

chmod +x "$AI_DIR/demo_finetune.py"
```

<!-- Image: Sunstone Context tab, Start script field → img/sunstone-context.png -->

Reboot the Slurm worker after the first driver install if required.

**Verify GPU on the Slurm worker:** Inside the Slurm worker VM, run these commands to confirm the NVIDIA driver is installed and the GPU is recognized:

```shell
lspci | grep -i nvidia
lspci -v -s 01:00.0
nvidia-smi
```

(Adapt the PCI address in `lspci -v -s 01:00.0` if your GPU is on a different bus.)

---

## Run the finetuning job from the Slurm controller

Before running the job:

* Check that the Slurm controller sees the Slurm worker (e.g. `sinfo` or `scontrol show nodes`).
* If you need to add or verify worker nodes, see the [Slurm Quick Start](https://github.com/OpenNebula/one-apps/wiki/slurm_quick).

<!-- Image: Slurm controller terminal (sinfo/srun, training output) → img/slurm-srun.png -->

On the **Slurm controller** VM, run the following command to start the finetuning on a Slurm worker (the start script has already created `/opt/ai_model` and the demo script there):

```shell
srun --job-name=demo_finetune -N1 -n1 /opt/ai_model/venv/bin/python /opt/ai_model/demo_finetune.py
```

Output goes to the terminal. To save it to a file: add `> demo_finetune.out 2>&1` at the end.

If everything goes well, you should see output similar to:

```
{'train_runtime': 5.067, 'train_samples_per_second': 7.894, 'train_steps_per_second': 1.974, 'train_loss': 1.8984880447387695, 'epoch': 10.0}
Saved to /opt/ai_model/output
```

---

## Summary

This tutorial showed how to run finetuning on a **Slurm worker** appliance in OpenNebula:

* Install Slurm (controller and workers) from the OpenNebula marketplace.
* Configure the Slurm worker template (PCI for GPU, start script that creates `/opt/ai_model`, downloads the model, installs driver and dependencies, and creates the demo script).
* Submit the job from the **Slurm controller** with a single `srun` command.

{{< alert title="Tip" color="success" >}}
After running finetuning on a Slurm worker, you may choose to validate your AI Factory with [Validation with LLM Inferencing]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/llm_inference_certification" %}}) or [Validation with AI-Ready Kubernetes]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/ai_ready_k8s" %}}).
{{< /alert >}}
