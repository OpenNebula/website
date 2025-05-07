---
title: "Virtual Machines Operation"
date: "2025-02-17"
description: "Define, instantiate and manage Virtual Machines and multi-VM workflows"
categories:
pageintoc: "80"
tags:
weight: "4"
---

<a id="virtual-machines-operation"></a>

<!--# Virtual Machines Operation -->

<a id="vm-management-overview"></a>

<!--# Overview -->

This chapter contains documentation on how to create and manage Virtual Machines and their associated objects.

{{< alert title="Important" color="success" >}}
Through these guides Virtual Machine or VM is used as a generic abstraction that may represents real VMs, micro-VMs or system containers.{{< /alert >}} 

## How Should I Read This Chapter

Before reading this chapter, you should have already installed your [Front-end]({{% relref "../../software/installation_process/manual_installation/front_end_installation.md" %}}), the [KVM Hosts]({{% relref "../../software/installation_process/manual_installation/kvm_node_installation.md" %}}) or [LXC Hosts]({{% relref "../../software/installation_process/manual_installation/kvm_node_installation.md" %}}) and have an OpenNebula cloud up and running with at least one virtualization node.

## Hypervisor Compatibility

These guides are compatible with all hypervisors, except for the VMware vCenter Section.
