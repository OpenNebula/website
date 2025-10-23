---
title: "Overview"
date: "2025-02-17"
description:
categories:
pageintoc: "170"
tags:
weight: "1"
---

<a id="opennebula-installation-overview"></a>

<!--# Overview -->

The Front-end is the central part of an OpenNebula installation and is the very first thing that needs to be deployed (or upgraded). Typically it’s a Host where the OpenNebula server-side components are installed and which is responsible for the management of an entire virtualization stack. It can be a physical Host or a Virtual Machine (this decision is left up to the cloud administrator) as long as it matches the [requirements]({{% relref "platform_notes#uspng" %}}).

## How Should I Read This Chapter

Before reading this Chapter make sure you are familiar with the [Architecture Blueprint]({{% relref "../../../getting_started/understand_opennebula/cloud_architecture_and_design/index#architecture-blueprints" %}}), and the blueprint most appropriate to your needs.

The aim of this Chapter is to give you a quick-start guide to deploying OpenNebula. This is the simplest possible installation, but it is also the foundation for a more complex setup. First, you should go through the [Database Setup]({{% relref "database" %}}) section, especially if you expect to use OpenNebula for production. Then move on to the configuration of [OpenNebula Repositories]({{% relref "opennebula_repository_configuration" %}}), from which you’ll install the required components. And finally, proceed with the [Front-end Installation]({{% relref "front_end_installation" %}}) section. You’ll end up running a fully featured OpenNebula Front-end.

After reading this Chapter, you can go on to add the [KVM]({{% relref "kvm_node_installation" %}}) or [LXC]({{% relref "lxc_node_installation" %}}) hypervisor nodes.

To scale from a single-Host Front-end deployment to several Hosts for better performance or reliability (HA), continue to the following chapters on [Large-scale Deployment]({{% relref "../../../product/control_plane_configuration/large-scale_deployment/" %}}), [High Availability]({{% relref "../../../product/control_plane_configuration/high_availability/index" %}}) and [Data Center Federation]({{% relref "../../../product/control_plane_configuration/data_center_federation/index" %}}).

## Hypervisor Compatibility

This Chapter applies to all supported hypervisors.
