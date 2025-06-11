---
title: "Overview"
date: "2025-02-17"
description:
categories:
pageintoc: "82"
tags:
weight: "1"
---

<a id="storage-overview"></a>

<!--# Overview -->

In OpenNenbula there are two main places where VM disk images are stored:

* [Marketplaces]({{% relref "../../../product/apps-marketplace" %}}), which are shared locations across multiple OpenNebula clouds. They can be public or for private use. Marketplaces store [Marketplace Applications]({{% relref "../../apps-marketplace/managing_marketplaces/marketapps.md#marketapp" %}}) (or Appliances), that includes the application definition together with the disk images.
* [Datastores]({{% relref "../../cluster_configuration/storage_system/datastores#datastores" %}}), which are the local storage areas of a cloud. They typically refer to storage clusters or hypervisor disks and are mainly devoted to store disk images.

## How Should I Read This Chapter

This section describes how to create and manage disk [Images]({{% relref "images" %}}).

After reading this section, you can consult [Virtual Machine Definitions]({{% relref "../virtual_machine_definitions/overview" %}}). Here you will find descriptions of how VMs are defined in [Virtual Machine Templates]({{% relref "vm_templates" %}}), which are _instantiated_ to become Virtual Machines, i.e. [Virtual Machine Instances]({{% relref "vm_instances" %}}).

## Hypervisor Compatibility

These guides are compatible with all hypervisors.
