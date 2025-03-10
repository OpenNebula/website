---
title: "Overview"
date: "2025-02-17"
description:
categories:
pageintoc: "138"
tags:
weight: "1"
---

<a id="capacity-overview-2"></a>

<!--# Overview -->

## How Should I Read This Chapter

This Chapter shows different mechanism available to administrators to control the capacity assigned to Virtual Machines as well as that available to the users:

> - First you can control the apparent capacity of [Hosts configuring its overcommitment]({{% relref "../capacity_planning/overcommitment#overcommitment" %}}).
> - Also you can fine tune [the scheduling policies]({{% relref "scheduling#scheduling" %}}) that controls how resources from Hosts, Datastores, and Virtual Networks are allocated to Virtual Machines.
> - Similarly, you can limit the resources that are made available to [users with the quota system]({{% relref "../capacity_planning/quotas#quota-auth" %}}).
> - Finally, some workloads may require that you co-allocate or coordinate the capacity assigned to a group of Virtual Machines. [Affinity and placement rules can be set for VM groups]({{% relref "affinity#vmgroups" %}}).

This chapter also includes a description on how to extend the scheduling component by configuring external modules, [see the external scheduler API section for more details]({{% relref "external#external-scheduler" %}}).

## Hypervisor Compatibility

These guides are compatible with all hypervisors.
