---
title: "Overview"
date: "2026-03-06"
description:
categories:
tags:
weight: "1"
---

OneForm is OpenNebula's automated cloud provisioning tool. It serves as an automated "cloud-on-demand" engine, allowing you to treat remote bare-metal and public cloud providers as if they were local hardware, instantiating clusters through the Sunstone user interface, the CLI or the API.

This documentation covers 3 different provisioning topics:

### Cloud Cluster Providers

* Definition: Providers represent your credentials and endpoints for third-party cloud services (e.g., AWS, Equinix, Scaleway) or on-premises environments.

* Key Function: It acts as an abstraction layer. Instead of managing complex API keys and connection strings every time you need a new host, you define a Provider once.

* Automation Integration: This layer uses Provider Drivers to communicate with external APIs, ensuring that OpenNebula knows how to talk to the specific underlying hardware or virtual resources. 

### Cloud Cluster Provisions
This is the Deployment & Template phase. Once you have a provider, you need a blueprint for the cluster itself.

* Definition: A "Provision" is a specific instance of a cluster defined by a Provision Template.

* Key Function: It defines the *what* and *how many*. For example, a provision might specify 5 bare-metal servers, a specific virtual router, and the networking configuration required to connect them back to your OpenNebula Front-end.

* One-Click Workflow: OneForm uses Terraform under the hood to orchestrate the infrastructure and Ansible (via OneDeploy) to configure the OS and OpenNebula services on those new nodes.

### Cloud Cluster Operations
This section covers the Lifecycle Management of clusters once they are live.

* Definition: Operations involving the day-to-day management of your existing provisions.

* Key Function: Operations such as scaling the cluster (adding or removing hosts), monitoring the health of the provisioned nodes, and updating configurations.

* Sunstone Integration: These operations are fully integrated into the Sunstone GUI, allowing you to perform tasks such as decommissioning a faulty host or upgrading a cluster's capacity without needing to manually run CLI scripts.