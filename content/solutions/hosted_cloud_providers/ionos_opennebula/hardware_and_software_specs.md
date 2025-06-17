---
title: "Hardware and Software Specification"
description:
categories:
pageintoc: ""
tags:
weight: 2
---


This section contains the specification of the used hardware and software resources for the reference OpenNebula deployment on IONOS cloud. The characteristics are detailed in the tables below for the front-end, virtualization host, storage, networking and provisioning model.

| FRONT-END  |
| :---- | :---- |
| Number of Zones | 1 |
| Cloud Manager | OpenNebula 6.99.85 |
| Server Specs | IONOS “Dedicated Core Server”, Intel Skylake, 2 Cores,  8GB RAM |
| Operating System | Debian 12 |
| High Availability | No (1 frontend) |
| Authorization | Builtin |


| VIRTUALIZATION HOSTS  |
| :---- | :---- |
| Number of Nodes | 1 |
| Server Specs | IONOS “Dedicated Core Server”, Intel Skylake, 2 Cores,  8GB RAM |
| Operating System | Debian 12 |
| Hypervisor | KVM |
| Special Devices | None |


| STORAGE   |
| :---- | :---- |
| Type | Local disk |
| Capacity | 1 Datastore |


| NETWORK   |
| :---- | :---- |
| Networking | VXLAN, Public routed network |
| Number of Networks | 2 networks: VXLAN  Public routed network, with each host machine having a NIC and a public IP |


| PROVISIONING MODEL  |
| :---- | :---- |
| VDCs | 1 VDC with 1 cluster (2 nodes)   Users will be able to provision and manage VMs via OpenNebula Web Interface, on the Frontend node’s public IP. |
