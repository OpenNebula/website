---
title: "Hardware Specification and Architecture"
description:
categories:
pageintoc: ""
tags:
weight: 2
---


This section describes the cloud architecture used in this guide, and provides the specification of hardware and software resources for the reference OpenNebula deployment on IONOS cloud.

## Architecture

The target high-level cloud architecture overview is shown below. Two hosts are deployed: the first for hosting the OpenNebula Front-end services and VMs, the second for hosting VMs only. Both machines should have a public IP, which is used to manage the nodes. Additional public IPs are required to access running Virtual Machines. The proposed model connects VMs internally using VXLAN networks, with at least one VM assigned a public IP to act as a gateway, NATing traffic to and from the internal network.

![><][high-level]

[high-level]: /images/solutions/ionos/high-level-architecture.png

## Hardware Specification

### Front-end Requirements

| FRONT-END  |
| :---- | :---- |
| Number of Zones | 1 |
| Cloud Manager | OpenNebula {{< release >}} |
| Server Specs | IONOS “Dedicated Core Server”, Intel Skylake, 2 Cores,  8GB RAM |
| Operating System | Debian 12 |
| High Availability | No (1 Front-end) |
| Authorization | Builtin |


### Host Requirements

| VIRTUALIZATION HOSTS  |
| :---- | :---- |
| Number of Nodes | 1 |
| Server Specs | IONOS "Dedicated Core Server", Intel Skylake, 2 Cores,  8GB RAM |
| Operating System | Debian 12 |
| Hypervisor | KVM |
| Special Devices | None |

### Storage Specification

| STORAGE   |
| :---- | :---- |
| Type | SSH drivers using local disks |
| Capacity | Full size of servers local disks |


### Network Requirements

| NETWORK   |
| :---- | :---- |
| Networking | VXLAN, Public routed network |
| Number of Networks | 2 networks: VXLAN  Public routed network, with each host machine having a NIC and a public IP |
