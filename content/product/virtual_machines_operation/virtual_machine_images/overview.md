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

This section provides guides on creating and managing disk [Images]({{% relref "images" %}}) and [Virtual Machine Templates]({{% relref "vm_templates" %}}).

VM templates are _instantiated_ to become Virtual Machine instances. For information on VM instances, please refer to the [Virtual Machine Instances]({{% relref "vm_instances" %}}) section.

## Hypervisor Compatibility

These guides are compatible with all hypervisors.
