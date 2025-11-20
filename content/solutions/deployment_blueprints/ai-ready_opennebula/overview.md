---
title: Overview
weight: 1
---

The AI transformation is underway, and OpenNebula provides the critical cloud solutions essential for successful large-scale deployment. Empower your enterprise AI Factory with a scalable, secure, and flexible private cloud solution, built on open-source technology for maximum customization and efficiency.

Configure and validate a high-performance AI infrastructure using OpenNebula, relying on an infrastructure optimized for speed, efficiency, and scale necessary for demanding AI operations. In this guide you will learn about the details from foundational hardware planning to automated deployment, as well as final performance validation. More specifically, you will discover aspects such as: 

1. Identifying the minimum hardware and network infrastructure necessary for your AI Factory. These requirements  also serve as an essential reference for advanced users. While OpenNebula supports specialized high-performance architectures like Infiniband, SpectrumX, and NVLink, deployment for these environments is not automated and requires customized configuration.
2. Comprehensive instructions to configure an AI Factory with two alternatives: OneDeploy for on-premises, and Scaleway for cloud deployments.
3. Optionally, validating your deployment by applying the methodology for the formal acceptance of your new infrastructure. These instructions, which build upon the successful completion of the previous steps, focuses on validating the platform's performance capabilities using Large Language Model (LLM) inferencing, AI-ready Kubernetes, NVIDIA&reg; Dynamo and NVIDIA&reg; KAI Scheduler. 


## Basic Outline

Configuring, deploying and validating a high-performance AI infrastructure using OpenNebula involves these steps:

1. Familiarize with **Architecture and Specifications**.
2. Configure your AI Factory with one of these alternatives:
    * [On-premises AI Factory Deployment]({{% relref "/solutions/deployment_blueprints/ai-ready_opennebula/cd_on-premises" %}}): uses OneDeploy for on-prem environments.
    * [AI Factory Deployment on Scaleway Cloud]({{% relref "/solutions/deployment_blueprints/ai-ready_opennebula/cd_cloud" %}}): relies on Scaleway for cloud environments.
3. Perform validation:  as a prerequisite, you must have an AI Factory ready to be validated. These are the options to validate your AI Factory:
    * [Validation with LLM Inferencing]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/llm_inference_certification" %}}) : works with two distinct models and two different model sizes across both H100 and L40S GPUs.
    * [Validation with AI-Ready Kubernetes]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/ai_ready_k8s" %}}): uses H100 and L40S to start Kubernetes on top powered by the OpenNebula cloud platform. Once you have your AI-ready Kubernetes cluster, it is possible to perform additional validations such as:
        * [Validation with NVIDIA Dynamo]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/nvidia_dynamo" %}}): combine the GPU powered Kubernetes cluster with the NVIDIA Dynamo Cloud Platform to provision a solution for your AI workloads on top of the NVIDIA Dynamo framework. 
        * [Validation with NVIDIA KAI Scheduler]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/nvidia_kai_scheduler" %}}): share GPU resources among different workloads using NVIDIA KAI Scheduler in an AI-Ready Kubernetes cluster. 


## Additional Information Resources

* [OpenNebula: Enterprise AI](https://opennebula.io/enterprise-ai/)
    * Find about all the reasons and benefits to trust OpenNebula for your AI deployment.
    * Contact our team of experts to explore and use OpenNebula's full potential for your AI infrastructure.
* [NVIDIA&reg; Dynamo](https://docs.nvidia.com/dynamo/latest/index.html)
* [Supported NVIDIA&reg; Data Center GPUs and Systems](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/24.9.2/platform-support.html#supported-nvidia-data-center-gpus-and-systems)
* [NVIDIA&reg; Container runtime](https://developer.nvidia.com/container-runtime)
* [DCGM](https://developer.nvidia.com/dcgm) based monitoring
