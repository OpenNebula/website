---
title: Overview
weight: 1
---

The AI transformation is underway, and OpenNebula provides the critical cloud solutions essential for successful large-scale deployment. Empower your enterprise AI Factory with a scalable, secure, and flexible private cloud solution, built on open-source technology for maximum customization and efficiency.

Configure and validate a high-performance AI infrastructure using OpenNebula, relying on an infrastructure optimized for speed, efficiency, and scale necessary for demanding AI operations. In this guide you will learn about the details from foundational hardware planning to automated deployment, as well as final performance validation. More specifically, you will discover aspects such as: 

1. Identifying the minimum hardware and network infrastructure necessary for your AI Factory. These requirements  also serve as an essential reference for advanced users. While OpenNebula supports specialized high-performance architectures like Infiniband, SpectrumX, NVLink, and Scaleway, deployment for these environments is not automated and requires customized configuration.
2. Following comprehensive instructions for deploying your entire OpenNebula cloud using OneDeploy. This guide outlines the requirements and procedures for successful deployment across both local and general cloud environments.
3. Optionally, validating your deployment by applying the methodology for the formal acceptance of your new infrastructure. These instructions, which build upon the successful completion of the previous steps, focuses on validating the platform's performance capabilities using Large Language Model (LLM) inferencing, as well as  AI-ready Kubernetes and NVIDIA&reg; Dynamo. 


## Basic Outline

Configuring and validating a high-performance AI infrastructure using OpenNebula involves these steps:

1. Familiarize with **Architecture and Specifications**.
2. Explore [Configuration and Deployment]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/configuration_and_deployment" %}}).
3. Perform validation:  as a prerequisite, you must have followed the steps in [Configuration and Deployment]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/configuration_and_deployment" %}}). To perform the validation, there are two alternatives:
    * [Validation with LLM Inferencing]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/llm_inference_certification" %}}) : relies on two distinct models and two different model sizes across both H100 and L40S GPUs.
    * [Validation with AI-Ready Kubernetes]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/ai_ready_k8s" %}}): uses H100 and L40S to start Kubernetes and NVIDIA Dynamo on top. 


## Additional Information Resources

* [OpenNebula: Enterprise AI](https://opennebula.io/enterprise-ai/)
    * Find about all the reasons and benefits to trust OpenNebula for your AI deployment.
    * Contact our team of experts to explore and use OpenNebula's full potential for your AI infrastructure.
* [NVIDIA&reg; Dynamo](https://docs.nvidia.com/dynamo/latest/index.html)
* [Supported NVIDIA&reg; Data Center GPUs and Systems](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/24.9.2/platform-support.html#supported-nvidia-data-center-gpus-and-systems)
* [NVIDIA&reg; Container runtime](https://developer.nvidia.com/container-runtime)
* [DCGM](https://developer.nvidia.com/dcgm) based monitoring
