---
title: "Hardware and Software Specification"
description:
categories:
pageintoc: ""
tags:
weight: 2
---


This section contains the specification of the used hardware and software resources for the reference OpenNebula deployment on IONOS cloud.

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
