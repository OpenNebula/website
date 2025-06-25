---
title: "Hardware and Software Specification"
description:
categories:
pageintoc: ""
tags:
weight: 2
---

This section contains the specification of the used Ampere hardware and software resources for the reference OpenNebula deployment.

The tables below detail the characteristics for the Front-end, virtualization host, storage, networking and provisioning model.


### Table 1: Front-end Requirements

Two identical servers where used. One of them acts as Front-end and both of them acts as hosts.

| FRONT-END  |
| :---- | :---- |
| Number of Zones | 1 |
| Cloud Manager | OpenNebula {{< release >}} |
| Server Specs | Ampere(R) Altra(R), details in the [table below](#table-6-server-specifications) |
| Operating System | Ubuntu 24.04.2 LTS |
| High Availability | No (1 Front-end) |
| Authorization | Builtin |


### Table 2: Host Requirements

| VIRTUALIZATION HOSTS  |
| :---- | :---- |
| Number of Nodes | 2 |
| Server Specs | Ampere(R) Altra(R), details in the [table below](#table-6-server-specifications) |
| Operating System | Ubuntu 24.04.2 LTS |
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
| Networking | VXLAN |
| Number of Networks | 1 networks: VXLAN |

### Table 5: Provisioning Model

| PROVISIONING MODEL  |
| :---- | :---- |
| Manual on-prem | The two servers have been manually provisioned and configured on-prem. |


### Table 6: Server Specifications

| Parameter                | Ampere Server                                                                              |
|--------------------------|-------------------------------------------------------------------------------------------|
| **Architecture**         | aarch64 (ARM 64-bit)                                                                      |
| **CPU Model**            | Ampere(R) Altra(R) Processor Q80-30 CPU @ 3.0GHz (Neoverse-N1)                            |
| **CPU Vendor**           | Ampere(R)                                                                                 |
| **CPU Cores**            | 160 (2 sockets × 80 cores, 1 thread per core)                                             |
| **CPU Frequency**        | 1000 MHz (min), 3000 MHz (max)                                                            |
| **NUMA Nodes**           | 2 (Node0: CPUs 0-79, Node1: CPUs 80-159)                                                  |
| **L1d Cache**            | 10 MiB (160 × 64 KiB)                                                                     |
| **L1i Cache**            | 10 MiB (160 × 64 KiB)                                                                     |
| **L2 Cache**             | 160 MiB (160 × 1 MiB)                                                                     |
| **Vulnerabilities**      | All major mitigated or not affected                                                        |
| **BIOS Vendor**          | Ampere(R)                                                                                 |
| **BIOS Version**         | 0ACOD014 (SCP: 2.10.20230126)                                                             |
| **BIOS Release Date**    | 12/12/2023                                                                                |
| **BIOS Revision**        | 5.15                                                                                      |
| **Firmware Revision**    | 2.10                                                                                      |
| **ROM Size**             | 7936 kB                                                                                   |
| **Boot Mode**            | UEFI, ACPI supported                                                                      |
| **Disks**                | 1 × NVMe (Samsung SM981/PM981/PM983, 894.3G)                                              |
| **Partitions**           | /boot/efi (1G), /boot (2G), LVM root (891.2G)                                             |
| **Network**              | 2 × Intel I350 Gigabit Ethernet                                                           |
| **USB Controllers**      | Hitachi, Renesas uPD720201 USB 3.0, Linux Foundation root hubs                            |
| **VGA Controller**       | ASPEED Technology, Inc. ASPEED Graphics Family (server management, not for computation)    |
| **PCI Devices**          | Multiple Ampere PCIe root complexes, bridges, and controllers                             |
| **RAM**                  | 32 GiB                                                                                   |
| **Other**                | No high-performance GPU detected                                                          |