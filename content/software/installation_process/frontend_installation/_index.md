---
title: "Front-end Installation"
date: "2026-04-15"
description: "Install the OpenNebula Front-end via one of several options."
categories:
pageintoc: "168"
tags:
weight: "1"
---

<a id="frontend-installation"></a>

The **OpenNebula Front-end** serves as the control plane for your entire cloud infrastructure. It is the central orchestrator responsible for deploying and managing the lifecycle of Cluster nodes, Virtual Machines (VMs), Virtual Networks, and storage datastores. The Front-end hosts the core OpenNebula services and provides the interfaces — a REST API, a CLI and the Sunstone user interface — through which administrators and users interact with the cloud. 

The Front-end can be deployed onto an on-premises server or a Virtual Machine or bare-metal instance from a cloud provider such as AWS or Scaleway. This decision is governed by the intended cloud architecture and available resources. Ensure that the virtual or physical machine on which you intend to deploy the Front-end meets the minimum [requirements given below](#requirements). 

Once you have deployed an OpenNebula Front-end, you can deploy and manage Cluster nodes for handling cloud workloads including Kubernetes Clusters and Virtual Machines. The server on which you deploy the Front-end can also be used as a workload Cluster node simultaneously, if the hardware specification is adequate.

## Installation Methods

Depending on your environment (testing vs. production) and your preference for automation, there are two primary ways to set up your Front-end covered in this section:

### 1. Automated Installation via miniONE

The miniONE tool is the fastest way to get an OpenNebula cloud up and running. It is a lightweight installation script designed for deploying an OpenNebula cloud configuration specialized for evaluation, testing, and development environments.  

* **Best for**: Rapid prototyping, sandboxes, and learning.  

* **Workflow**: A single command installs the Front-end and, optionally, a local KVM or LXD hypervisor on the same host.

* **Environment**: Typically used on a fresh Linux installation (Ubuntu or AlmaLinux).

Refer to the [Automatic Installation with miniONE]({{% relref "software/installation_process/frontend_installation/automated/" %}}) documentation for more details.

### 2. Manual Installation with System Packages

For users who require granular control over an OpenNebula deployment, the manual method involves installing OpenNebula directly from official system repositories.  

* **Best for**: Custom production architectures, specific security hardening, or integration with existing databases.

* **Workflow**: 
    1.  Configure the official OpenNebula repositories
    2.  Install the opennebula, opennebula-sunstone, and opennebula-gate packages
    3.  Manually configure the database (SQLite by default, or MySQL/MariaDB for production)
    4.  Initialize the services and administrative credentials

* **Environment**: Recommended with a fresh Linux installation (Ubuntu or AlmaLinux), this can also work on existing infrastructure with appropriate configuration.

Refer to the [Manual Installation with System Packages Documentation](software/installation_process/frontend_installation/manual/) for more details.

### Alternative: Advanced Deployment with OneDeploy

OneDeploy is an Ansible-based automation toolset intended for complex, production-ready, or High Availability (HA) deployments. If you are looking to automate a multi-node production environment across various infrastructure providers, please refer to the [Advanced Installation with OneDeploy]({{% relref "software/installation_process/advanced_installation_with_onedeploy/" %}}) section of the documentation.  

## Cluster Installation 

After completing the installation of an OpenNebula Front-end, you can then proceed to manually install or automatically provision Clusters to handle cloud workloads. Refer to the [Cluster Installation Documentation]({{% relref "software/installation_process/cluster_installation/" %}}).

## Requirements

Regardless of the method chosen, you must ensure that your host meets the minimum hardware requirements and has a clean operating system installation to avoid dependency conflicts. 

**Supported operating systems:**
* Ubuntu 22.04 or 24.04
* See the [Platform Release Notes]({{% relref "software/release_information/release_notes/platform_notes.md" %}}) for other compatible operating systems

**Minimum hardware:**

Hardware requirements for the Front-end machine differ if you intend the target machine to be used solely for the Front-end control plane or for the machine to be used for both the Front-end and Cluster workloads.

**Front-end only**:
* 16 GiB RAM
* 80 GiB free disk space

**Kubernetes**:
* Bare-metal instance recommended
* 64 GiB RAM
* 120 GiB free disk space
<br> 

**AI Factory**:
* Bare-metal instance recommended
* 128 GiB RAM
* 512 GiB free disk space
* NVIDIA L40S or H100 GPU

