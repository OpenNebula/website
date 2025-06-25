---
#title: "Hardware and Software Specification"
title: "Hardware Specification and Architecture"
description:
categories:
pageintoc: ""
tags:
weight: 2
---


This section describes the cloud architecture used in this guide, and provides the specification of hardware and software resources for the reference OpenNebula deployment on IONOS cloud.

## Architecture

The target high-level cloud architecture overview is shown below. Two hosts are deployed: the first for hosting the OpenNebula Front-end services and VMs, the second for hosting VMs only. Both machines should have a public IP, which is used to manage the nodes. The figure below also shows the target reference VMs to be deployed for testing purposes. At least one VM must be accessible to configure with a public IP, and all of them shall be connected to the VXLAN network.

![><][high-level]

[high-level]: /images/solutions/ionos/high-level-architecture.png

## Hardware Specification

The tables below detail the characteristics for the Front-end, virtualization host, storage, networking and provisioning model.

### Table 1: Front-end Requirements

| FRONT-END  |
| :---- | :---- |
| Number of Zones | 1 |
| Cloud Manager | OpenNebula {{< release >}} |
| Server Specs | IONOS “Dedicated Core Server”, Intel Skylake, 2 Cores,  8GB RAM |
| Operating System | Debian 12 |
| High Availability | No (1 Front-end) |
| Authorization | Builtin |


### Table 2: Host Requirements

| VIRTUALIZATION HOSTS  |
| :---- | :---- |
| Number of Nodes | 1 |
| Server Specs | IONOS "Dedicated Core Server", Intel Skylake, 2 Cores,  8GB RAM |
| Operating System | Debian 12 |
| Hypervisor | KVM |
| Special Devices | None |

### Table 3: Storage Specification

| STORAGE   |
| :---- | :---- |
| Type | Local disk |
| Capacity | 1 Datastore |


### Table 4: Network Requirements

| NETWORK   |
| :---- | :---- |
| Networking | VXLAN, Public routed network |
| Number of Networks | 2 networks: VXLAN  Public routed network, with each host machine having a NIC and a public IP |

### Table 5: Provisioning Model

| PROVISIONING MODEL  |
| :---- | :---- |
| VDCs | 1 VDC with 1 cluster (2 nodes). Users will be able to provision and manage VMs via the OpenNebula web interface, using the public IP of the Front-end node. |
