---
title: "Overview"
date: "2025/02/17"
description:
categories:
pageintoc: "32"
tags:
weight: "1"
---

<!--# Overview -->

No host or service is absolutely reliable; we experience failures across various areas every day. To avoid the down-time and the consequent damages, we try to avoid a single point of failure by running several instances of the same service. Failure of one instance doesn’t mean complete service unavailability, as there are other instances that can handle the workload. Such deployment is **highly available** and resilient to partial failure.

OpenNebula provides high availability mechanisms both for the Front-end and for the Virtual Machines.

## How Should I Read This Chapter

Before starting, you need to have [OpenNebula Front-end]({{% relref "front_end_installation" %}}) running.

Read the section [Front-end HA Setup]({{% relref "frontend_ha#frontend-ha-setup" %}}) to learn how to set up a highly available (HA) OpenNebula Front-end. Continue with [Virtual Machines High Availability]({{% relref "vm_ha#ftguide" %}}) if you are interested in a way to provide high availability to your Virtual Machines.

## Hypervisor Compatibility

| Section                                       | Compatibility                             |
|-----------------------------------------------|-------------------------------------------|
| [Front-end HA]({{% relref "frontend_ha#frontend-ha-setup" %}}) | This section applies to all hypervisors.  |
| [Virtual Machines HA]({{% relref "vm_ha#ftguide" %}})          | This section applies only to KVM and LXC. |
