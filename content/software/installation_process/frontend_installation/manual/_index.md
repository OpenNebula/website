---
title: "Manual Installation with System Packages"
linkTitle: "Manual - Packages"
date: "2025-02-17"
description: "Manually install the Front-end and hypervisors from the OpenNebula packages."
categories:
pageintoc: "168"
tags:
no_list: true
weight: "2"
---

<a id="manual-installation-packages"></a>

The **OpenNebula Front-end** serves as the control plane for your entire cloud infrastructure. It is the central orchestrator responsible for deploying and managing the lifecycle of Cluster nodes, Virtual Machines (VMs), Virtual Networks, and storage datastores. The Front-end hosts the core OpenNebula services and provides the interfaces — a REST API, a CLI and the Sunstone user interface — through which administrators and users interact with the cloud. 

The Front-end can be deployed onto an on-premises server or a Virtual Machine or bare-metal instance from a cloud provider such as AWS or Scaleway. This decision is governed by the intended cloud architecture and available resources. Ensure that the virtual or physical machine on which you intend to deploy the Front-end meets the minimum [requirements given below](#requirements). 

Once you have deployed an OpenNebula Front-end, you can deploy and manage Cluster nodes for handling cloud workloads including Kubernetes Clusters and Virtual Machines. The server on which you deploy the Front-end can also be used as a workload Cluster node simultaneously, if the hardware specification is adequate.

This section details installing the OpenNebula Front-end manually using the system packages. There are three parts to the process:

1. [**Database Setup**]({{% relref "software/installation_process/frontend_installation/manual/database/" %}}): Install a database for OpenNebula to keep a persistent record of the state of the cloud deployment.
2. **Set up the OpenNebula Repositories**: The packaging tools on your server must have access to the OpenNebula package repositories, there are two repositories:
    * [**OpenNebula Repositories for OpenNebula Community Edition**]({{% relref "software/installation_process/frontend_installation/manual/opennebula_repository_configuration_ce/" %}})
    * [**OpenNebula Repositories for OpenNebula Enterprise Edition**]({{% relref "software/installation_process/frontend_installation/manual/opennebula_repository_configuration_ee/" %}})
3. [**Install the Front-end**]({{% relref "software/installation_process/frontend_installation/manual/frontend_install/" %}})

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
