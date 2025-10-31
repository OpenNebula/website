---
title: Overview
weight: 1
---

The AI transformation is underway, and OpenNebula provides the critical cloud solutions essential for successful large-scale deployment. Empower your enterprise AI Factory with a scalable, secure, and flexible private cloud solution, built on open-source technology for maximum customization and efficiency.

Configure and validate a high-performance AI infrastructure using OpenNebula. Here you will find all the details from foundational hardware planning to automated deployment and final performance validation. Following this guide you can:

1. Find about the minimum hardware and network infrastructure necessary for your AI Factory. It also serves as a critical reference for advanced users, noting that while OpenNebula supports specialized high-performance architectures like Infiniband, SpectrumX, NVLink, and Scaleway, deployment for these environments is not automated and requires customized configuration.
2. Follow comprehensive instructions for deploying your entire OpenNebula cloud using OneDeploy. This guide outlines the requirements and procedures for successful deployment across both local and general cloud environments.
3. Optionally, validate your deployment by applying the methodology for the formal acceptance of your new infrastructure. This guide, which builds upon the successful completion of the previous steps, focuses on validating the platform's performance capabilities using Large Language Model (LLM) inferencing. Specifically, validation requires running benchmarks on two distinct models and two different model sizes across both H100 and L40S GPUs to demonstrate guaranteed performance and functionality.


## Basic Outline

Configuring and validating a high-performance AI infrastructure using OpenNebula involves these steps:

1. Familiarize with **Architecture and Specifications**.
2. Explore [Configuration and Deployment]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/configuration_and_deployment" %}}).
3. Perform validation:  as a prerequisite, you must have followed the previous step in [Configuration and Deployment]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/configuration_and_deployment" %}}). To perform the validation, there are two alternatives:
    * **Validation with LLM Inferencing**: use 2 models and 2 sizes on H100 and L40S, and run benchmarking to show they work at performance.
    * [Validation with AI-Ready Kubernetes]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/ai_ready_k8s" %}}): use the H100 and L40S with the steps to start k8s and Dynamo on top. 


## Additional Information Resources

* [OpenNebula: Enterprise AI](https://opennebula.io/enterprise-ai/)
    * Find about all the reasons and benefits to trust OpenNebula for your AI deployment.
    * Contact our team of experts to explore and use OpenNebula's full potential for your AI infrastructure.
* [NVIDIA&reg; Dynamo](https://docs.nvidia.com/dynamo/latest/index.html)
* [Supported NVIDIA&reg; Data Center GPUs and Systems](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/24.9.2/platform-support.html#supported-nvidia-data-center-gpus-and-systems)
* [NVIDIA&reg; Container runtime](https://developer.nvidia.com/container-runtime)
* [DCGM](https://developer.nvidia.com/dcgm) based monitoring
