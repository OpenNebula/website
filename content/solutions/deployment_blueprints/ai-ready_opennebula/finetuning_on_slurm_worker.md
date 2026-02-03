---
title: "How to finetune an LLM on a Slurm worker"
linkTitle: "Finetune LLM on Slurm"
weight: 8
---

<a id="finetuning_on_slurm_worker"></a>

{{< alert title="Important" color="success" >}}
To run finetuning on a Slurm worker, you must have the **Service Slurm Worker** and **Service Slurm Controller** appliances deployed. Download them from the OpenNebula marketplace and follow the [Slurm Quick Start](https://github.com/OpenNebula/one-apps/wiki/slurm_quick) tutorial.
{{< /alert >}}

This tutorial shows how to run LLM finetuning (Unsloth) on a **Slurm worker** appliance in OpenNebula.

You will learn how to:

* Prepare a folder with the model and finetuning script.
* Configure the Slurm worker template (virtiofs, GPU, and a start script so the worker gets the model and dependencies at boot).
* Submit a finetuning job from the **Slurm controller** with a single command.

{{< alert title="Note" color="success" >}}
This guide uses an **NVIDIA H100L** and `nvidia-driver-570` as an example. If you use a different GPU, select the correct PCI device in Sunstone and install a compatible NVIDIA driver version.
{{< /alert >}}

<!-- Image: overview diagram (host folder → controller → worker with virtiofs) → img/overview.png -->

---

## Prepare the shared folder on the OpenNebula frontend

On the **OpenNebula frontend** that runs the Slurm worker VM:

* Create a folder (e.g. `/tmp/ai_model_files`).
* Put there the **model files** and **`demo_finetune.py`**.

**Download the model** (e.g. Qwen2.5-1.5B-Instruct) into that folder. There are many ways to do it. A simple one is to install `huggingface_hub` and run:

```shell
pip install huggingface_hub
huggingface-cli download Qwen/Qwen2.5-1.5B-Instruct --local-dir /tmp/ai_model_files
```

Adapt the model ID and path if needed.

**Create the finetuning script**

* Create the file in the **same folder** as the model (e.g. `/tmp/ai_model_files/demo_finetune.py`).
* In the script, `MODEL_PATH` is set to `/mnt/ai_model` (the path inside the worker VM). If you used a different mount path in the start script, change `MODEL_PATH` in the script to match.

The script below is a **sample** that shows how to use Unsloth for a small demo finetune.

```python
#!/usr/bin/env python3
import os
from datasets import Dataset
from unsloth import FastLanguageModel
from trl import SFTTrainer
from transformers import TrainingArguments

MODEL_PATH = "/mnt/ai_model"


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
trainer.save_model(OUTPUT_DIR)
tokenizer.save_pretrained(OUTPUT_DIR)
print("Saved to", OUTPUT_DIR)
```

---

## Configure the Slurm worker template

This section adds virtiofs support, GPU passthrough, and a start script so the worker mounts the model folder and installs dependencies at boot.

### Add RAW sections for virtiofs

Add the following to the **Slurm worker** VM template. Replace `/tmp/ai_model_files` with the path on the OpenNebula frontend where you will put the model and script (the same path you use in [Prepare the shared folder on the OpenNebula frontend](#prepare-the-shared-folder-on-the-opennebula-frontend)). Then update the template:

```shell
onetemplate update <id_slurm_worker_template>
```

Append this to the template:

```
RAW=[
  DATA="<memoryBacking><source type='memfd'/><access mode='shared'/></memoryBacking>",
  TYPE="kvm",
  VALIDATE="no" ]
RAW=[
  DATA="<devices><filesystem type='mount' accessmode='passthrough'><driver type='virtiofs'/><source dir='/tmp/ai_model_files'/><target dir='ai_model'/></filesystem></devices>",
  TYPE="kvm",
  VALIDATE="no" ]
```

The Slurm worker will see the **`/tmp/ai_model_files`** folder as **`/mnt/ai_model`** once the Slurm worker start script has run (see [Configure the Slurm worker template](#configure-the-slurm-worker-template)).

### Attach GPU to the worker

Add the GPU as a PCI device from **Sunstone**: **Templates** → **VM Templates** → **Update** the Slurm worker template → **Advanced options** → **PCI devices** tab. OpenNebula will insert the correct PCI class, device and vendor into the template.

<!-- Image: Sunstone PCI devices tab → img/sunstone-pci.png -->

### Add start script for mount and dependencies

Add the **start script** from **Sunstone**: **Templates** → **VM Templates** → **Update** the Slurm worker template → **Context** tab → paste the following into the **Start script** text field:

```bash
mkdir -p /mnt/ai_model
mount -t virtiofs ai_model /mnt/ai_model
apt update && apt install -y nvidia-driver-570
python3 -m venv /mnt/ai_model/venv
/mnt/ai_model/venv/bin/pip install --upgrade pip
/mnt/ai_model/venv/bin/pip install unsloth datasets trl transformers
```

<!-- Image: Sunstone Context tab, Start script field → img/sunstone-context.png -->

What the start script does:

* At boot, the start script mounts the folder (e.g. `/tmp/ai_model_files`) inside the worker VM at **`/mnt/ai_model`**, so the worker sees the same model and script files at that path. The target name `ai_model` must match the `<target dir='ai_model'/>` in the RAW section.
* The NVIDIA driver lets the VM use the host GPU.
* The venv and pip install provide the dependencies for `demo_finetune.py`.

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

On the **Slurm controller** VM, run the following command to start the finetuning of the AI model on the Slurm worker that has `/mnt/ai_model` mounted:

```shell
srun --job-name=demo_finetune -N1 -n1 /mnt/ai_model/venv/bin/python /mnt/ai_model/demo_finetune.py
```

Output goes to the terminal. To save it to a file: add `> demo_finetune.out 2>&1` at the end.

If everything goes well, you should see output similar to:

```
{'train_runtime': 5.067, 'train_samples_per_second': 7.894, 'train_steps_per_second': 1.974, 'train_loss': 1.8984880447387695, 'epoch': 10.0}
Saved to /mnt/ai_model/output
```

---

## Summary

This tutorial showed how to run finetuning on a **Slurm worker** appliance in OpenNebula:

* Prepare the folder with the model and `demo_finetune.py`.
* Configure the Slurm worker template (RAW sections for virtiofs, PCI for GPU, start script for mount and dependencies).
* Submit the job from the **Slurm controller** with a single `srun` command.

{{< alert title="Tip" color="success" >}}
After running finetuning on a Slurm worker, you may choose to validate your AI Factory with [Validation with LLM Inferencing]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/llm_inference_certification" %}}) or [Validation with AI-Ready Kubernetes]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/ai_ready_k8s" %}}).
{{< /alert >}}
