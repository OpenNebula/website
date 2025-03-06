---
title: "Overview"
date: "2025/02/17"
description:
categories:
pageintoc: "82"
tags:
weight: "1"
---

<a id="storage-overview"></a>

<!--# Overview -->

## How Should I Read This Chapter

In OpenNenbula there are two main places where VM disk images are stored:

<!-- TMP FIX (modified s/marketplaces/apps-marketplace/): -->
* [Marketplaces]({{% relref "../../../apps-marketplace/index#apps-marketplace" %}}), these are shared locations across multiple OpenNebula clouds. They can be public or for private use. Marketplaces store [Marketplace Applications]({{% relref "../../../apps-marketplace/marketplace_appliances/marketapps#marketapp" %}}) (or Appliances), that includes the application definition together with the disk images.
* [Datastores]({{% relref "../../cloud_clusters_infrastructure_configuration/storage_system_configuration/datastores#datastores" %}}), these are the local storage areas of a cloud. They typically refer to storage clusters or hypervisor disks and are mainly devoted to store disk [images]({{% relref "images#images" %}}).

In these chapter you will learn how to operate effectively these entities.

## Hypervisor Compatibility

These guides are compatible with all hypervisors.
