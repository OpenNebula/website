---
title: "Cloud Cluster Provisioning Overview"
linkTitle: "Overview"
date: "2026-03-06"
description:
categories:
tags:
weight: "1"
---

**OneForm** is OpenNebula's automated cloud provisioning tool. It serves as an automated "cloud-on-demand" engine, allowing you to provision resources on-premises, on remote bare-metal, or public cloud providers through a simple, streamlined workflow. You can provision Clusters through the Sunstone user interface, the CLI, or the API.

This documentation covers three topics that outline the process of provisioning Clusters with OneForm. The provisioning workflow takes the following order:

* Create a Cluster [Provider](#cloud-cluster-providers)
* [Provision](#cloud-cluster-provisions) a Cluster using a Cluster Provider
* Manage the Cluster using Cluster [Operations](#cloud-cluster-operations)

## Interfaces

OneForm offers three interfaces to perform Cluster management and provisioning:

* **Sunstone**: A Graphical User Interface used through a web browser.
* **Command Line Interface**: Three command line tools for provisioning:
    * `oneform`: Management and synchronization of cloud drivers.
    * `oneprovider`: Creation and management of Providers.
    * `oneprovision`: Deployment and management of Provisions, including scaling and deprovisioning.
* **API**: A REST API for controlling OneForm from separate software or code.

Each of the guides in this Cluster provisioning documentation demonstrates how to perform each task with all three interfaces.

## [Cloud Cluster Providers]({{% relref "product/cloud_cluster_provisioning/cloud_cluster_providers/" %}})

* **Definition**: Providers represent your credentials and endpoints for third-party cloud services (e.g., AWS, Equinix, Scaleway) or on-premises environments.

* **Key Function**: Acts as an abstraction layer. Instead of managing complex API keys and connection strings every time you need a new Host, you define a Provider only once.

* **Automation Integration**: This layer uses Provider drivers to communicate with external IaaS APIs or on-premise bare-metal resources, ensuring that OpenNebula knows how to talk to the specific underlying hardware or virtual resources. 

## [Cloud Cluster Provisions]({{% relref "product/cloud_cluster_provisioning/cloud_cluster_provisions/" %}})
This is the Deployment and Template phase. Once you have defined a Provider, you need a blueprint for the Cluster deployment itself.

* **Definition**: A "Provision" is a specific instance of a Cluster defined by a Provision Template.

* **Key Function**: Defines the *what* and *how many*. For example, a provision might specify five bare-metal servers, a specific virtual router, and the networking configuration required to connect them back to your OpenNebula Front-end.

* **One-Click Workflow**: OneForm uses Terraform under the hood to orchestrate the infrastructure and Ansible (via OneDeploy) to configure the OS and OpenNebula services on the newly provisioned nodes.

## [Cloud Cluster Operations]({{% relref "product/cloud_cluster_provisioning/cloud_cluster_operations/" %}})
Cluster operations handle the lifecycle management of Clusters once they are live.

* **Definition**: Operations involving the day-to-day management of your existing provisions.

* **Key Function**: Tasks such as scaling the Cluster (adding or removing Hosts), monitoring the health of the provisioned nodes, and updating configurations.

* **Sunstone Integration**: These operations are fully integrated into the Sunstone GUI, allowing you to perform tasks such as decommissioning a faulty Host or upgrading a Cluster's capacity without needing to manually run CLI scripts.

## Configuration

OneForm can be configured for your specific use-case, please consult the [OneForm Configuration Reference]({{% relref "/product/operation_references/opennebula_services_configuration/oneform/" %}}) for details.

