---
title: "Overview"
date: "2025-02-17"
description:
categories:
pageintoc: "59"
tags:
weight: "1"
---

<a id="nm"></a>

<!--# Overview -->

When a new Virtual Machine is launched, OpenNebula will connect its virtual network interfaces (defined by `NIC` attributes) to hypervisor network link devices as defined in the corresponding [Virtual Network]({{% relref "manage_vnets#manage-vnets" %}}). This will allow the VM to have access to public and private networks.

OpenNebula supports the following networking modes:

* [Bridged]({{% relref "bridged#bridged" %}}). The VM NIC is added to a Linux bridge on the Host. This mode can be configured to use Security Groups and network isolation.
* [802.1Q VLAN]({{% relref "vlan#hm-vlan" %}}). The VM NIC is added to a Linux bridge on the Host and the Virtual Network is configured to handle 802.1Q VLAN isolation.
* [VXLAN]({{% relref "vxlan#vxlan" %}}). The VM NIC is added to a Linux bridge on the Host and the Virtual Network implements isolation using the VXLAN encapsulation.
* [Open vSwitch]({{% relref "openvswitch#openvswitch" %}}). The VM NIC is added to a Open vSwitch bridge on the Host and the Virtual Network optionally handles 802.1Q VLAN isolation.
* [Open vSwitch on VXLAN]({{% relref "openvswitch#openvswitch-vxlan" %}}). The VM NIC is added to a Open vSwitch bridge on the Host and the Virtual Network is configured to provide both isolation with VXLAN encapsulation and optionally 802.1Q VLAN.

The attribute `VN_MAD` of a Virtual Network determines which of the above networking modes is used.

{{< alert title="Note" color="success" >}}
Security Groups are not supported in the Open vSwitch modes.{{< /alert >}} 

## How Should I Read This Chapter

Before reading this Chapter make sure you are familiar with the [Open Cloud Storage]({{% relref "../storage_system/overview#storage" %}}). It’s necessary to be aware of requirements for your selected storage solution in order to be able to design the network architecture of your hypervisor nodes.

Read the common [Node Setup]({{% relref "node#networking-node" %}}) section to learn how to configure your Hosts, and then proceed to the specific section for the networking mode that you are interested in.

Additionally, if you are interested in optional integration with the IP Address Manager (IPAM), the external mechanism that allocates and assigns the IP addresses for the Virtual Machines, you can consult [IPAM driver]({{% relref "../../../product/integration_references/infrastructure_drivers_development/devel-ipam" %}}) in the [Integration References]({{% relref "integration_references" %}}).

## Hypervisor Compatibility

This Chapter applies to KVM and LXC.
