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

The Front-end is the central part of an OpenNebula installation and is the very first thing that needs to be deployed (or upgraded). Typically it’s a host where the OpenNebula server-side components are installed and which is responsible for the management of an entire virtualization stack. It can be a physical host or a virtual machine (this decision is left up to the cloud administrator) as long as it matches the [requirements]({{% relref "../../../releases/release_information/release_notes/platform_notes#uspng" %}}).

## How Should I Read This Chapter

Before reading this chapter make sure you are familiar with the [Architecture Blueprint]({{% relref "../../../cloud_installation/understand_opennebula/cloud_architecture_and_design/index#architecture-blueprints" %}}), and the blueprint most appropriate to your needs.

The aim of this chapter is to give you a quick-start guide to deploying OpenNebula. This is the simplest possible installation, but it is also the foundation for a more complex setup. First, you should go through the [Database Setup]({{% relref "database#database-setup" %}}) section, especially if you expect to use OpenNebula for production. Then move on to the configuration of [OpenNebula Repositories]({{% relref "opennebula_repository_configuration#repositories" %}}), from which you’ll install the required components. And finally, proceed with the [Front-end Installation]({{% relref "install#frontend-installation" %}}) section. You’ll end up running a fully featured OpenNebula Front-end.

After reading this chapter, you can go on to add the [KVM]({{% relref "../kvm_node_deployment/kvm_node_installation#kvm-node" %}}) or [LXC]({{% relref "../lxc_node_deployment/lxc_node_installation#lxc-node" %}}) hypervisor nodes.

To scale from a single-host Front-end deployment to several hosts for better performance or reliability (HA), continue to the following chapters on [Large-scale Deployment]({{% relref "../../control_plane_configuration/large-scale_deployment/index#large-scale-deployment" %}}), [High Availability]({{% relref "../../control_plane_configuration/high_availability/index#ha" %}}) and [Data Center Federation]({{% relref "../../control_plane_configuration/data_center_federation/index#federation-section" %}}).

## Hypervisor Compatibility

This chapter applies to all supported hypervisors.
