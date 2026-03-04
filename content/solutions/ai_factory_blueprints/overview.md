---
title: Overview
weight: 1
description: "Overview of AI factory deployment and validation"
---

The purpose of the AI Factory collection is to provide a step-by-step process for setting up a simple AI Factory system and getting it up and running quickly, including:

* Identifing the minimum hardware and networking requirements for your AI Factory. These baseline specifications also serve as a reference for more advanced deployments. OpenNebula supports high-performance architectures such as InfiniBand, Spectrum-X, and NVLink, although these setups are not automated and require custom configuration.
<br>

* Follow the step-by-step deployment instructions using OneDeploy to build your AI Factory, with options for both on-premises installations and cloud-based deployments.
<br>

* Optionally validate your setup using the same methodology we apply during formal infrastructure acceptance. This validation focuses on using AI-ready Kubernetes with NVIDIA Dynamo&reg; or NVIDIA KAI Scheduler&reg;.


## Basic Outline

Configuring, deploying and validating a high-performance AI infrastructure using OpenNebula involves these steps:

1. Familiarize yourself with **Architecture and Specifications**. We recommend to consult the [guide on GPU PCI-passthrough]({{% relref "product/cluster_configuration/hosts_and_clusters/nvidia_gpu_passthrough" %}}) for details relating to your GPU hardware and IOMMU.
<br>

2. Deploy and configure your AI Factory with one of these alternatives:
    * [On-premises AI Factory Deployment]({{% relref "/solutions/ai_factory_blueprints/deployment/cd_on-premises" %}}): Set up an AI Factory sing OneDeploy for on-prem environments.
    * [On-cloud AI Factory Deployment]({{% relref "/solutions/ai_factory_blueprints/deployment/cd_cloud" %}}): Set up an AI Factory using OneDeply on Scaleway for cloud environments.
<br>
<br>

3. Perform Validation: As a prerequisite, you must have an AI Factory ready to be validated after completing the above installation procedures. These are the options to validate your AI Factory:
    
    * [Validation with direct AI execution]({{% relref "solutions/ai_factory_blueprints/direct_ai_execution" %}}):
        * [Validation with LLM Inferencing]({{% relref "solutions/ai_factory_blueprints/direct_ai_execution/llm_inference_certification" %}}): Using vLLM with two different models and two model sizes, running across both H100 and L40S GPUs.
        * [Validation with NVIDIA Slurm]({{% relref "solutions/ai_factory_blueprints/direct_ai_execution/nvidia_slurm" %}}): Finetuning an AI model using the OpenNebula NVIDIA Slurm appliance.
<br>
<br>

    * [Validation with AI-Ready Kubernetes]({{% relref "solutions/ai_factory_blueprints/containerized_ai_execution/ai_ready_k8s" %}}): Use H100 and L40S deployment to run Kubernetes. Once the AI-ready Kubernetes cluster is up, additional validation steps can be carried out, including:
        * [Validation with NVIDIA Dynamo]({{% relref "solutions/ai_factory_blueprints/containerized_ai_execution/nvidia_dynamo" %}}): Integrating the GPU-powered Kubernetes cluster with the NVIDIA Dynamo Cloud Platform to provision and manage AI workloads through the Dynamo framework for your AI workloads on top of the NVIDIA Dynamo framework. 
        * [Validation with NVIDIA KAI Scheduler]({{% relref "solutions/ai_factory_blueprints/containerized_ai_execution/nvidia_kai_scheduler" %}}): Use the NVIDIA KAI Scheduler to share GPU resources across different workloads within the AI-ready Kubernetes cluster.