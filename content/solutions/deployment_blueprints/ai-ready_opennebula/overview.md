---
title: Overview
weight: 1
---

The purpose of the AI Factory collection is to provide a step-by-step process for setting up a simple AI Factory system and getting it up and running quickly, including:

* Identify the minimum hardware and networking requirements for your AI Factory. These baseline specifications also serve as a reference for more advanced deployments. OpenNebula supports high-performance architectures such as InfiniBand, Spectrum-X, and NVLink, although these setups are not automated and require custom configuration.
* Follow the step-by-step deployment instructions using OneDeploy to build your AI Factory, with options for both on-premises installations and cloud-based deployments.
* Optionally validate your setup using the same methodology we apply during formal infrastructure acceptance. This validation focuses on using AI-ready Kubernetes with NVIDIA Dynamo&reg; or NVIDIA KAI Scheduler&reg;.


## Basic Outline

Configuring, deploying and validating a high-performance AI infrastructure using OpenNebula involves these steps:

1. Familiarize with **Architecture and Specifications**.
2. Deploy and configure your AI Factory with one of these alternatives:
    * [On-premises AI Factory Deployment]({{% relref "/solutions/deployment_blueprints/ai-ready_opennebula/cd_on-premises" %}}): using OneDeploy for on-prem environments.
    * [On-cloud AI Factory Deployment]({{% relref "/solutions/deployment_blueprints/ai-ready_opennebula/cd_cloud" %}}): using OneDeply on Scaleway for cloud environments.
3. Perform Validation:  as a prerequisite, you must have an AI Factory ready to be validated. These are the options to validate your AI Factory:
    * [Validation with LLM Inferencing]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/llm_inference_certification" %}}) : using vLLM with two different models and two model sizes, running across both H100 and L40S GPUs
    * [Validation with AI-Ready Kubernetes]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/ai_ready_k8s" %}}): using H100 and L40S deployment to run Kubernetes. Once the AI-ready Kubernetes cluster is up, additional validation steps can be carried out, including::
        * [Validation with NVIDIA Dynamo]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/nvidia_dynamo" %}}): integrating the GPU-powered Kubernetes cluster with the NVIDIA Dynamo Cloud Platform to provision and manage AI workloads through the Dynamo framework for your AI workloads on top of the NVIDIA Dynamo framework. 
        * [Validation with NVIDIA KAI Scheduler]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/nvidia_kai_scheduler" %}}): using the NVIDIA KAI Scheduler to share GPU resources across different workloads within the AI-ready Kubernetes cluster.
    * [Finetune an LLM on a Slurm worker]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/finetuning_on_slurm_worker" %}}): run LLM finetuning on a Slurm worker appliance with virtiofs and GPU, and submit jobs from the Slurm controller.