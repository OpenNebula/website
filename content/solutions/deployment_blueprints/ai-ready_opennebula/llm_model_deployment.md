---
title: "How to Deploy an LLM Model in OpenNebula"
linkTitle: "Deploy an LLM Model"
date: "2026-01-15"
description:
categories:
pageintoc: "188"
tags:
weight: "10"
---

This guide describes how to deploy an LLM inference service on OpenNebula in a few simple steps using the `vllm-engine` appliance.

## Prerequisites

Before you begin, ensure you have:

- **HF Hub marketplace configured** in your OpenNebula cluster. If you need to set this up, see the [HuggingFace Hub Marketplace guide]({{% relref "product/apps-marketplace/public_marketplaces/hfhub#market-hfhub" %}}).
- **`vllm-engine` appliance imported**. When you import an appliance from the marketplace, OpenNebula automatically imports both the **template** and the **image**. Both must be available in your cluster:
  - The **template** is used to instantiate VMs
  - The **image** contains the appliance's base disk
  - If the appliance is not yet imported, search for `vllm-engine` on the [OpenNebula Marketplace](https://marketplace.opennebula.io) and import it into your cluster.
- **GPU setup (optional)**. The `vllm-engine` appliance works with both CPU and GPU. For GPU acceleration, ensure GPUs are configured in your cluster. You can attach a GPU (PCI device) to the VM during instantiation. For GPU setup guides, see:
  - [NVIDIA vGPU/MIG configuration](https://docs.opennebula.io/7.0/product/cluster_configuration/hosts_and_clusters/vgpu/)
  - [NVIDIA GPU Passthrough](https://docs.opennebula.io/7.0/product/cluster_configuration/hosts_and_clusters/nvidia_gpu_passthrough/)

## Deployment Steps

### Step 1: Import Your Model

1. In Sunstone, navigate to the **HF Hub marketplace**.
2. Browse and select the model you want to deploy.
3. Click **Import** and choose an Image Datastore.

   ![Import model from Hugging Face Marketplace](/images/solutions/deployment_blueprints/how-to-deploy-llm-models/import_model.png)

**What happens next:**
- OpenNebula automatically downloads the model artifacts from Hugging Face.
- The model is stored in your Image Datastore and appears as an OpenNebula **Image** resource.
- Wait for the Image status to show **READY** (`rdy`)—this indicates the model is fully downloaded and ready to use.

{{< alert title="Tip" color="success" >}}
You can check the Image status in Sunstone's Images view. Large models may take some time to download, but you only need to do this once per model.
{{< /alert >}}

### Step 2: Create and Configure the VM

1. Instantiate a new VM from the **`vllm-engine` template**.
2. During VM creation:
   - Attach your imported model Image as a **data disk**.
   - **(Optional)** For GPU acceleration, attach a GPU device (PCI device). The `vllm-engine` appliance automatically detects and uses the GPU if available; otherwise, it runs on CPU.

   ![Attach the model image to the VM](/images/solutions/deployment_blueprints/how-to-deploy-llm-models/attach_disk.png)

Once the VM starts running, the `vllm-engine` appliance automatically:
- Detects the attached model disk
- Mounts the model files
- Detects and configures GPU resources
- Starts the vLLM inference server on port `8000`

No manual configuration needed.

## Verify Your Deployment

Once your VM is running, verify that everything is working correctly.

### Check Model Availability

First, verify that the vLLM engine has loaded your model. Replace `<VM_IP>` with your VM's IP address (visible in Sunstone's VM details).

```bash
curl -sS http://<VM_IP>:8000/v1/models
```

**Expected response:** A JSON object listing your model. Look for the model ID (e.g., `meta-llama/Llama-3-8B`). Copy this MODEL_ID for the next step.

### Test Model Inference

Send a test prompt to verify the model can generate responses:

```bash
curl -sS http://<VM_IP>:8000/v1/completions \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "<MODEL_ID>",
    "prompt": "Hello! :)"
  }'
```

**Expected response:** A JSON response containing the model's generated completion, confirming your deployment is fully functional.

## Troubleshooting

- **Model import fails or doesn't appear**: Check the [HuggingFace Hub Marketplace guide]({{% relref "product/apps-marketplace/public_marketplaces/hfhub#market-hfhub" %}}) for prerequisites like HF tokens or QCOW2 requirements.