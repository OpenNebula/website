---
title: "Overview"
date: "2025-02-17"
description:
categories:
pageintoc: "82"
tags:
weight: "1"
---

<a id="guest-os-overview"></a>

<!--# Overview -->

This section details the necessary steps for preparing and deploying operating system images for virtual machines within an OpenNebula environment. It covers critical procedures for making VMs ready for production and ensuring compatibility and optimal performance.

The content is organized into the following key topics:

[Contextualization]({{% relref "kvm_contextualization" %}}): It focuses on the kvm_contextualization process, explaining how to inject configuration data (like network settings, SSH keys, or initialization scripts) into a VM instance during deployment, ensuring it is automatically configured upon boot.

[Creating Disk Images]({{% relref "creating_images" %}}): Provides instructions and best practices for generating compatible disk images to be used as base templates for VMs, covering the required file formats and image content preparation.

[Windows Best Practices]({{% relref "windows_best_practice" %}}): Offers specific guidelines and recommendations for running Microsoft Windows as a guest operating system, addressing common configuration challenges for optimal performance and integration.

[Operating System Profiles]({{% relref "os_profile" %}}): Describes the use and configuration of OS Profiles, which are used to define a set of default attributes for different operating systems to simplify template creation and ensure consistency across deployments.

## Hypervisor Compatibility

These guides are compatible with all hypervisors.
