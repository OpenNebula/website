---
title: Overview
weight: 1
---

Artificial Intelligence (AI) is here, and OpenNebula is ready to provide the solutions required for your cloud deployment. Here you find the guidance through the process of establishing and validating a high-performance AI infrastructure using OpenNebula. All details cover everything from foundational hardware planning to automated deployment and final performance validation.

Following this guide you can:

1. Find about the minimum hardware and network infrastructure necessary for your AI Factory. It also serves as a critical reference for advanced users, noting that while OpenNebula supports specialized high-performance architectures like Infiniband, SpectrumX, NVLink, and Scaleway, deployment for these environments is not automated and requires customized configuration.
2. Follow comprehensive instructions for deploying your entire OpenNebula cloud using OneDeploy. This guide outlines the requirements and procedures for successful deployment across both local and general cloud environments.
3. Optionally, validate your deployment by applying the methodology for the formal acceptance of your new infrastructure. This guide, which builds upon the successful completion of the previous steps, focuses on validating the platform's performance capabilities using Large Language Model (LLM) inferencing. Specifically, validation requires running benchmarks on two distinct models and two different model sizes across both H100 and L40S GPUs to demonstrate guaranteed performance and functionality.


## Basic Outline

Configuring and validating a high-performance AI infrastructure using OpenNebula involves these steps:

1. Familiarize with “Architecture and Specifications”: this reference guide includes a brief description of minimum hardware and infrastucture required to build your AI Factory. OpenNebula also supports Infiniband, SpectrumX, NVLink and Scaleway but deployments are not automated because these architectures require a customized high performance infrastructure.
2. Explore “Configuration and Deployment”: this deployment guide outlines the requirements and procedures to use OneDeploy in a local environment and in a cloud environment. 
3. Perform validation:  as a prerequisite, you must have followed the previous step in "Configuration and Deployment". In this step, there are two alternatives for validation:
* “Validation with LLM Inferencing”: use 2 models and 2 sizes on H100 and L40S, and run benchmarking to show they work at performance.
* Validation with AI-Ready Kubernetes”: use the H100 and L40S with the steps to start k8s and Dynamo on top. 


## Additional Information Resources

* [NVIDIA&reg; Dynamo](https://docs.nvidia.com/dynamo/latest/index.html)
* [Supported NVIDIA&reg; Data Center GPUs and Systems](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/24.9.2/platform-support.html#supported-nvidia-data-center-gpus-and-systems)
* [NVIDIA&reg; Container runtime](https://developer.nvidia.com/container-runtime)
* [DCGM](https://developer.nvidia.com/dcgm) based monitoring
