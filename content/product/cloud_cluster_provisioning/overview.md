---
title: "Overview"
date: "2026-03-06"
description:
categories:
tags:
weight: "1"
---

**OneForm** is OpenNebula's automated cloud provisioning tool. It serves as an automated "cloud-on-demand" engine, allowing you to treat remote bare-metal and public cloud providers as if they were local hardware, instantiating Clusters through the Sunstone user interface, the CLI or the API.

This documentation covers three topics that outline the process of provisioning Clusters. The provisioning workflow takes the following order:

* Create a Cluster Provider
* Provision a Cluster using a Cluster Provider
* Manage the Cluster using Cluster Operations

### [Cloud Cluster Providers]({{% relref "product/cloud_cluster_provisioning/cloud_cluster_providers/" %}})

* **Definition**: Providers represent your credentials and endpoints for third-party cloud services (e.g., AWS, Equinix, Scaleway) or on-premises environments.

* **Key Function**: Acts as an abstraction layer. Instead of managing complex API keys and connection strings every time you need a new host, you define a Provider only once.

* **Automation Integration**: This layer uses Provider Drivers to communicate with external IaaS APIs or on-premise bare-metal resources, ensuring that OpenNebula knows how to talk to the specific underlying hardware or virtual resources. 

### [Cloud Cluster Provisions]({{% relref "product/cloud_cluster_provisioning/cloud_cluster_provisions/" %}})
This is the Deployment and Template phase. Once you have a provider, you need a blueprint for the Cluster itself.

* **Definition**: A "Provision" is a specific instance of a Cluster defined by a Provision Template.

* **Key Function**: Defines the *what* and *how many*. For example, a provision might specify five bare-metal servers, a specific virtual router, and the networking configuration required to connect them back to your OpenNebula Front-end.

* **One-Click Workflow**: OneForm uses Terraform under the hood to orchestrate the infrastructure and Ansible (via OneDeploy) to configure the OS and OpenNebula services on the newly provisioned nodes.

### [Cloud Cluster Operations]({{% relref "product/cloud_cluster_provisioning/cloud_cluster_operations/" %}})
This section covers the Lifecycle Management of Clusters once they are live.

* **Definition**: Operations involving the day-to-day management of your existing provisions.

* **Key Function**: Operations such as scaling the Cluster (adding or removing hosts), monitoring the health of the provisioned nodes, and updating configurations.

* **Sunstone Integration**: These operations are fully integrated into the Sunstone GUI, allowing you to perform tasks such as decommissioning a faulty host or upgrading a Cluster's capacity without needing to manually run CLI scripts.