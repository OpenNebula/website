---
title: "Secondary Platforms"
date: "2025-02-17"
description:
categories:
pageintoc: "246"
tags:
weight: "4"
---

<a id="secondary"></a>

<!--# Secondary Platforms -->

**Secondary Platforms** are experimental OpenNebula builds for bleeding edge operating systems and software versions, a completely new platform which hasn’t gained mature support in OpenNebula yet, or for non-mainstream CPU architectures. Continuity of support is not guaranteed. Builds for the **Secondary Platforms** are provided with only limited testing coverage and without any commercial support options.

{{< alert title="Important" color="success" >}}
**Secondary Platforms** are not recommended for production environments, nor officially supported by OpenNebula Systems.{{< /alert >}} 

## Front-End Components

| Component   | Version                  | More information                                                                                                                        |
|-------------|--------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|
| Fedora      | 32 (x86-64), 33 (x86-64) | [Front-End Installation]({{% relref "front_end_installation" %}}) |

## KVM Nodes

| Component   | Version                  | More information                                                                                           |
|-------------|--------------------------|------------------------------------------------------------------------------------------------------------|
| Fedora      | 32 (x86-64), 33 (x86-64) | [KVM Driver]({{% relref "kvm_driver#kvmg" %}}) |

## Nodes Platform Notes

### Fedora 32

[Live migration](https://github.com/OpenNebula/one/issues/4695) with KVM virtual machines doesn’t work.
