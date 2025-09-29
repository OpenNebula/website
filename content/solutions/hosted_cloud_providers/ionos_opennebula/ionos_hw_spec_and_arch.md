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

The target high-level cloud architecture overview is shown below. Two hosts are deployed: the first for hosting the OpenNebula Front-end services and VMs, the second for hosting VMs only. Both machines should have a public IP, which is used to manage the nodes. Additional public IPs are required to access running Virtual Machines. For internal networking between the VMs a VXLAN network is used, that is isolated from the public traffic.

![><][high-level]

[high-level]: /images/solutions/ionos/high-level-architecture.png

## Hardware Specification

### Front-end Requirements

| FRONT-END  |
| :---- | :---- |
| Number of Zones | 1 |
| Cloud Manager | OpenNebula {{< release >}} |
| Server Specs | IONOS server with 2 dedicated cores and 8GB RAM (CPU model depends on the selected location) |
| Operating System | Debian 12 |
| High Availability | No (1 Front-end) |
| Authorization | Builtin |


### Host Requirements

| VIRTUALIZATION HOSTS  |
| :---- | :---- |
| Number of Nodes | 1 |
| Server Specs | IONOS server with 2 dedicated cores and 8GB RAM (CPU model depends on the selected location) |
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
| Number of Networks | 2 networks: VXLAN  internal network, public network for external access |
