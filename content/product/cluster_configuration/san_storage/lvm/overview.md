---
title: "Overview"
date: "2025-02-17"
description:
categories:
pageintoc: "72"
tags:
weight: "1"
---

This storage configuration assumes that Hosts have access to storage devices (LUNs) exported by an
Storage Area Network (SAN) server using a suitable protocol like iSCSI or Fibre Channel. The Hosts
will interface the devices through the LVM abstraction layer. Virtual Machines run from an LV
(logical volume) device instead of plain files. This reduces the overhead of having a filesystem in
place and thus it may increase I/O performance.

## SAN Appliance Setup

Before performing the configuration of the LVM, you must configure your SAN appliance to export the LUN(s) where
VMs will be deployed. Depending on the manufacturer the process may be slightly different; hence,
refer to the specific guides if your hardware is on the supported list, or the generic guide
otherwise:

- [NetApp specific guide]({{% relref "netapp_guide" %}})
- [PureStorage specific guide]({{% relref "purestorage_guide" %}})
- [Generic guide]({{% relref "generic_guide" %}})

## LVM Datastore options

OpenNebula offers two main ways to leverage LVM technology as a way to exploit SAN storage in a
vendor-independent way. Refer to the corresponding section for the specific configuration.
Also, for a technical comparison and supported features of each option, refer to the [Storage
portfolio]({{% relref "../../storage_system/overview#storage-portfolio" %}}).

Datastore guides:

- [LVM]({{% relref "lvm" %}}) (EE only): images stored as LVs in a SAN, activated directly.
- [FS+LVM Hybrid]({{% relref "filemode" %}}): images stored in front-end, transferred to hosts via SSH, and copied to the SAN on instantiation.
