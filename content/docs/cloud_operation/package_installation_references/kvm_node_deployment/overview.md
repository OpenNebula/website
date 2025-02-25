---
title: "Overview"
date: "2025/02/17"
description:
categories:
pageintoc: "175"
tags:
weight: "1"
---

<a id="kvm-node-deployment-overview"></a>

<!--# Overview -->

[KVM](https://www.linux-kvm.org/) (Kernel-based Virtual Machine) is the main virtualization solution for Linux on x86 hardware that contains virtualization extensions (Intel VT or AMD-V). It consists of the loadable KVM kernel modules (one that provides the core virtualization infrastructure and several processor-specific modules), but the complete KVM virtualization stack usually also contains the user-space machine hardware emulator [QEMU](https://www.qemu.org) accelerated by the KVM and virtual machines management tool [libvirt](https://libvirt.org).

By using KVM, you can run multiple Virtual Machines with unmodified Linux or Windows images. Each Virtual Machine has private virtualized hardware - network card, disk, graphics adapter, etc.

## How Should I Read This Chapter

This chapter focuses on the configuration options for KVM-based Nodes. Read the [installation]({{% relref "kvm_node_installation#kvm-node" %}}) section to add a KVM Node to your OpenNebula cloud to start deploying VMs. Continue with the [driver]({{% relref "kvm_driver#kvmg" %}}) section to understand the specific requirements, functionalities, and limitations of the KVM driver.

You can then move on to the Open Cloud [Storage]({{% relref "../../cloud_clusters_infrastructure_configuration/storage_system_configuration/overview#storage" %}}) and [Networking]({{% relref "../../cloud_clusters_infrastructure_configuration/networking_system_configuration/overview#nm" %}}) chapters to be able to deploy Virtual Machines on your KVM nodes and access them remotely over the network.

## Hypervisor Compatibility

This chapter applies only to KVM.
