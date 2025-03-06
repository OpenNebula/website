---
title: "Overview"
date: "2025/02/17"
description:
categories:
pageintoc: "170"
tags:
weight: "1"
---

<a id="opennebula-installation-overview"></a>

<!--# Overview -->

The Front-end is the central part of an OpenNebula installation and is the very first thing that needs to be deployed (or upgraded). Typically it’s a host where the OpenNebula server-side components are installed and which is responsible for the management of an entire virtualization stack. It can be a physical host or a virtual machine (this decision is left up to the cloud administrator) as long as it matches the [requirements]({{% relref "platform_notes#uspng" %}}).

## How Should I Read This Chapter

Before reading this chapter make sure you are familiar with the [Architecture Blueprint]({{% relref "/docs/quick_start/understand_opennebula/cloud_architecture_and_design/index#architecture-blueprints" %}}), and the blueprint most appropriate to your needs.

The aim of this chapter is to give you a quick-start guide to deploying OpenNebula. This is the simplest possible installation, but it is also the foundation for a more complex setup. First, you should go through the [Database Setup]({{% relref "database#database-setup" %}}) section, especially if you expect to use OpenNebula for production. Then move on to the configuration of [OpenNebula Repositories]({{% relref "opennebula_repository_configuration#repositories" %}}), from which you’ll install the required components. And finally, proceed with the [Front-end Installation]({{% relref "install#frontend-installation" %}}) section. You’ll end up running a fully featured OpenNebula Front-end.

After reading this chapter, you can go on to add the [KVM]({{% relref "kvm_node_installation#kvm-node" %}}) or [LXC]({{% relref "lxc_node_installation#lxc-node" %}}) hypervisor nodes.

To scale from a single-host Front-end deployment to several hosts for better performance or reliability (HA), continue to the following chapters on [Large-scale Deployment]({{% relref "/docs/configuration_and_operation/control_plane_configuration/large-scale_deployment/" %}}), [High Availability]({{% relref "/docs/configuration_and_operation/control_plane_configuration/high_availability/index#ha" %}}) and [Data Center Federation]({{% relref "/docs/configuration_and_operation/control_plane_configuration/data_center_federation/index#federation-section" %}}).

## Hypervisor Compatibility

This chapter applies to all supported hypervisors.

<!-- FROM HERE ON CONTENT OF KVM NODE DEPLOYMENT's overview.md: -->

<a id="kvm-node-deployment-overview"></a>

<!--# Overview -->

[KVM](https://www.linux-kvm.org/) (Kernel-based Virtual Machine) is the main virtualization solution for Linux on x86 hardware that contains virtualization extensions (Intel VT or AMD-V). It consists of the loadable KVM kernel modules (one that provides the core virtualization infrastructure and several processor-specific modules), but the complete KVM virtualization stack usually also contains the user-space machine hardware emulator [QEMU](https://www.qemu.org) accelerated by the KVM and virtual machines management tool [libvirt](https://libvirt.org).

By using KVM, you can run multiple Virtual Machines with unmodified Linux or Windows images. Each Virtual Machine has private virtualized hardware - network card, disk, graphics adapter, etc.

## How Should I Read This Chapter

This chapter focuses on the configuration options for KVM-based Nodes. Read the [installation]({{% relref "kvm_node_installation#kvm-node" %}}) section to add a KVM Node to your OpenNebula cloud to start deploying VMs. Continue with the [driver]({{% relref "kvm_driver#kvmg" %}}) section to understand the specific requirements, functionalities, and limitations of the KVM driver.

You can then move on to the Open Cloud [Storage]({{% relref "/docs/configuration_and_operation/cloud_clusters_infrastructure_configuration/storage_system_configuration/overview#storage" %}}) and [Networking]({{% relref "/docs/configuration_and_operation/cloud_clusters_infrastructure_configuration/networking_system_configuration/overview#nm" %}}) chapters to be able to deploy Virtual Machines on your KVM nodes and access them remotely over the network.

## Hypervisor Compatibility

This chapter applies only to KVM.

<!-- FROM HERE ON CONTENT OF LXC NODE DEPLOYMENT's overview.md: -->

<a id="lxc-node-deployment-overview"></a>

<!--# Overview -->

[LXC](https://linuxcontainers.org/lxc/introduction/) is a Linux technology which allows us to create and manage system and application containers. The containers are computing environments running on a particular hypervisor Node alongside other containers or Host services, but secured and isolated in their own namespaces (user, process, network).

From the perspective of a hypervisor Node, such a container environment is just an additional process tree among other hypervisor processes. Inside of the environment, it looks like a standard Linux installation that sees only its own resources but shares the host kernel.

## How Should I Read This Chapter

This chapter focuses on the configuration options for LXC-based Nodes. Read the [installation]({{% relref "lxc_node_installation#lxc-node" %}}) section to add an LXC Node to your OpenNebula cloud to start deploying containers. Continue with the [driver]({{% relref "lxc_driver#lxcmg" %}}) section in order to understand the specific requirements, functionalities, and limitations of the LXC driver.

You can then move on to look at the Open Cloud [Storage]({{% relref "/docs/configuration_and_operation/cloud_clusters_infrastructure_configuration/storage_system_configuration/overview#storage" %}}) and [Networking]({{% relref "/docs/configuration_and_operation/cloud_clusters_infrastructure_configuration/networking_system_configuration/overview#nm" %}}) chapters to be able to deploy your containers on your LXC Nodes and access them remotely over the network.

## Hypervisor Compatibility

This chapter applies only to LXC.
