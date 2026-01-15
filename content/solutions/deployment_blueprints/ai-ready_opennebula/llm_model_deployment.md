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

This guide describes an end-to-end workflow to deploy an LLM model with `vllm-engine` on OpenNebula v7.

## Requirements

- An HFHUB marketplace already exists (see the [HuggingFace Hub Marketplace guide]({{% relref "product/apps-marketplace/public_marketplaces/hfhub#market-hfhub" %}}) if you need to set it up).
- The `vllm-engine` appliance is already available. If not, you can find it on the [OpenNebula Marketplace](https://marketplace.opennebula.io).


{{< alert title="Note" color="success" >}}
This is a one-time preparation step for the cluster: import the `vllm-engine` appliance once, and import each model once. When a model Image becomes **READY** (`rdy`), you can reuse it by attaching it as a data disk to any number of `vllm-engine` VMs.
{{< /alert >}}

## Steps

### 1. Import a model from the Hugging Face Marketplace
   1. In Sunstone, open the HF Hub marketplace, choose a model, and import it into an Image Datastore.

   ![Import model from Hugging Face Marketplace](/images/solutions/deployment_blueprints/how-to-deploy-llm-models/import_model.png)

   2. What happens after import:
      - OpenNebula downloads the model artifacts from Hugging Face Marketplace.
      - The datastore driver stores the model in the Image Datastore and creates an OpenNebula **Image** resource.
      - When the Image becomes **READY** (`rdy`), it can be attached to a VM as a data disk.

### 2. Instantiate the vLLM engine VM
   1. Create a VM from the `vllm-engine` appliance.
   2. Attach the imported model Image as a **data disk**.

   ![Attach the model image to the VM](/images/solutions/deployment_blueprints/how-to-deploy-llm-models/attach_disk.png)

### 3. Verification and Validation
Once the VM is running, the appliance automatically detects and mounts the model disk, starting the vLLM engine. You can then validate the service from any machine that has network access to the VM on port `8000`.

**Check Model Availability**<br>
First, verify that the vLLM engine has loaded the model correctly. This command lists all models currently served by the API.
```bash
curl -sS http://<VM_IP>:8000/v1/models
```
You should receive a JSON response containing the model ID (e.g., `meta-llama/Llama-3-8B`). Use this ID in the next step.

**Test Model Inference**<br>
Send a prompt to the model to verify it can generate responses. This uses the OpenAI-compatible completions endpoint.
```bash
curl -sS http://<VM_IP>:8000/v1/completions
  -H 'Content-Type: application/json'
  -d '{
    "model": "<MODEL_ID>",
    "prompt": "Hello! :)",
  }'
```
You should receive a JSON response with the model's completion, confirming that the end-to-end deployment is functional.

If import fails, the model does not appear as an Image, or you need HF token / QCOW2 prerequisites, follow the [HuggingFace Hub Marketplace guide]({{% relref "product/apps-marketplace/public_marketplaces/hfhub#market-hfhub" %}}).

