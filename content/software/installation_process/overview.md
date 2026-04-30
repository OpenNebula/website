---
title: "Installation Overview"
linkTitle: "Overview"
date: "2026-04-29"
description: "Installation Overview."
categories:
pageintoc: "168"
tags:
show_card: false
weight: "1"
---

<a id="package-installation-references"></a>

This section contains details on deploying an OpenNebula-managed cloud through several different methods that serve different purposes. There are two principal components of an OpenNebula cloud deployment:

* **OpenNebula Front-end**: This is the control plane of an OpenNebula cloud deployment. The Front-end enables the deployment of Cluster nodes for handling and monitoring cloud workloads, the deployment and management of Virtual Machines, Virtual Networks, Kubernetes Clusters and user and security management.

* **Edge Clusters**: OpenNebula Edge Clusters or nodes are Virtual Machines or bare-metal servers that provide the compute resources for the deployment of Virtual Machines or Kubernetes Clusters for handling cloud workloads, orchestrated by one or more OpenNebula Front-end instances. An OpenNebula Front-end can dynamically deploy and undeploy  new Edge Clusters (provisioning) to scale cloud compute capacity.

## Front-end deployment

The first step in deploying an OpenNebula cloud is installing the OpenNebula Front-end. There are three options:

* [Automatic Deployment with miniONE]({{% relref "software/installation_process/frontend_installation/automated/" %}})
* [Manual Deployment with System Packages]({{% relref "software/installation_process/frontend_installation/manual/" %}})
* [Advanced Deployment with OneDeploy]({{% relref "software/installation_process/advanced_installation_with_onedeploy/" %}})

## Cluster deployment

Once you have successfully deployed an OpenNebula Front-end, you can proceed to create (provision) Cluster nodes to handle cloud workloads. There are three options:

* [Automated Cluster Provisioning with OneForm]({{% relref "software/installation_process/cluster_installation/automated/" %}})
* [Manual Cluster Installation with KVM]({{% relref "software/installation_process/cluster_installation/kvm_node_installation/" %}})
* [Manual Cluster Installation with LXC]({{% relref "software/installation_process/cluster_installation/lxc_node_installation/" %}})

OneDeploy can also be used to deploy Cluster nodes (independently or simultaneously with Front-end deployment). Please refer to the [Advanced Installation with OneDeploy]({{% relref "software/installation_process/advanced_installation_with_onedeploy/" %}}) documentation.

## Configuration

The complete references for configuring OpenNebula services, templates, and hypervisor nodes may be found in [Operation References]({{% relref "../../../product/operation_references/" %}}).
