---
title: "Automatic Cluster Provisioning with OneForm"
linkTitle: "Automatic - OneForm"
date: "2026-04-15"
description:
categories:
pageintoc: "26"
tags: [OneForm, cluster, deployment, automatic]
weight: "1"
---

OneForm is OpenNebula’s automated cloud provisioning tool. It serves as an automated “cloud-on-demand” engine, allowing you to provision resources on-premises, on remote bare-metal, or public cloud providers through a simple, streamlined workflow. You can provision Clusters through the Sunstone user interface, the CLI, or the API.

The OneForm provisioning documentation demonstrates how to provision and manage clusters automatically with OneForm. The OneForm documentation is divided into three separate concepts:

* **Providers**: OpenNebula entities that abstract the handling of configuration and credentials for bare-metal or cloud hardware or virtual resources.
* **Provisions**: Provisions are Cluster instances deployed by OneForm through the provisioning process.
* **Operations**: Tasks executed on Clusters after provisioning, such as scaling, monitoring, maintenance and deprovisioning.

Please refer to the [OneForm documentation]({{% relref "product/cluster_provisioning/" %}}) for details on how to create and use Providers and automatically provision Clusters.

In order to use OneForm, you should first install an OpenNebula Front-end using one of the different deployment options available, refer to the [Front-end Installation Guides]({{% relref "software/installation_process/frontend_installation/" %}}) for details. 