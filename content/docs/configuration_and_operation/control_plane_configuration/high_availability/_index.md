---
title: "High Availability"
date: "2025-02-17"
description:
categories:
pageintoc: "31"
tags:
weight: "1"
---

<a id="high-availability"></a>

<a id="ha"></a>

<!--# High Availability -->

* [Overview]({{% relref "overview" %}})
  * [How Should I Read This Chapter]({{% relref "overview#how-should-i-read-this-chapter" %}})
  * [Hypervisor Compatibility]({{% relref "overview#hypervisor-compatibility" %}})
* [Frontend HA]({{% relref "frontend_ha" %}})
  * [Raft Overview]({{% relref "frontend_ha#raft-overview" %}})
  * [Requirements and Architecture]({{% relref "frontend_ha#requirements-and-architecture" %}})
  * [Bootstrapping the HA cluster]({{% relref "frontend_ha#bootstrapping-the-ha-cluster" %}})
  * [Checking Cluster Health]({{% relref "frontend_ha#checking-cluster-health" %}})
  * [Adding and Removing Servers]({{% relref "frontend_ha#adding-and-removing-servers" %}})
  * [Recovering servers]({{% relref "frontend_ha#recovering-servers" %}})
  * [Enable/Disable a Zone]({{% relref "frontend_ha#enable-disable-a-zone" %}})
  * [Shared data between HA nodes]({{% relref "frontend_ha#shared-data-between-ha-nodes" %}})
  * [FireEdge]({{% relref "frontend_ha#fireedge" %}})
  * [Raft Configuration Attributes]({{% relref "frontend_ha#raft-configuration-attributes" %}})
  * [Compatibility with the earlier HA]({{% relref "frontend_ha#compatibility-with-the-earlier-ha" %}})
  * [Synchronize configuration files across servers]({{% relref "frontend_ha#synchronize-configuration-files-across-servers" %}})
* [VM HA]({{% relref "vm_ha" %}})
  * [Host Failures]({{% relref "vm_ha#host-failures" %}})
  * [Tuning HA responsiveness]({{% relref "vm_ha#tuning-ha-responsiveness" %}})
  * [Enabling Fencing]({{% relref "vm_ha#enabling-fencing" %}})
