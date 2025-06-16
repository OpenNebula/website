---
title: "Overview"
weight: "1"
---

Virtual Machines are defined in templates. In basic terms, a VM template describes a Virtual Machine as resources, components, and attributes -- for example, CPU and memory, disk images, network interfaces, context, and operational parameters.

You can create a VM template from zero, or you can download, modify or clone an existing template.

To run a Virtual Machine, you _instantiate_ the template for that Virtual Machine. This operation creates the Virtual Machine, which goes through a series of steps, each defined by a specific [state]({{% relref "vm_states" %}}), such as `INIT`, `PENDING` or `BOOT`. The VM will go through different states in varying order, according to the operations performed on it. Some VM states, such as `PROLOG`, `BOOT` or `RUNNING` are visible to end users and serve to perform VM operations; others are used for system internals.

A VM template can be instantiated any number of times, sequentially or concurrently, that is to say a single template can be used to instantiate a number of VMs. Cloud admins or authorized users can instantiate and operate on VMs through the [Sunstone web interface]({{% relref "../../../product/control_plane_configuration/graphical_user_interface/overview" %}}) or the `onetemplate` and `onevm` commands.

## How Should I Read this Chapter

[Virtual Machine Templates]({{% relref "vm_templates" %}}) is a complete guide for creating and modifying VM templates, with examples for VM disks, capacities, networking, attributes and instantiation.

[Virtual Machine Instances]({{% relref "vm_instances" %}}) details how to instantiate templates and operate on Virtual Machines, including a list of VM states, example commands, and explanations of the steps to instantiate a template.

The [Configuration References]({{% relref "../../../product/operation_references/configuration_references/" %}}) section contains the complete references for [Virtual Machine Template]({{% relref "../../../product/operation_references/configuration_references/template" %}}) and [Virtual Machine States]({{% relref "../../../product/operation_references/configuration_references/vm_states" %}}).

## Hypervisor Compatibility

These guides are compatible with all hypervisors.
