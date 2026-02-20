---
title: "VirtioFS Datastore"
linkTitle: "Filesystem Storage"
date: "2026-02-18"
description:
categories:
pageintoc: "76"
tags:
weight: "10"
---

<a id="virtiofs-ds"></a>

<!--# VirtioFS Datastores -->

The VirtioFS Datastore allows you to define a shared filesystem on the hypervisor hosts that is mounted directly inside Virtual Machines (VMs) using Virtio-FS.

## Requirements

Before creating and using a VirtioFS Datastore, ensure the following:

- The filesystem to be mounted must already exist and be available at the same path on each compute host where VMs will be deployed.
- The `virtiofsd` daemon and libvirt/QEMU with VirtioFS support must be installed on each hypervisor node.
- No additional transfer mechanism (`TM_MAD`) is required since the filesystems are already present on the hosts. However, a `TM_MAD` must still be defined in the datastore template (even if OpenNebula ignores it).

{{< alert title="Note" color="success" >}}
OpenNebula requires that `IMAGES_DS` share the same `TM_MAD` as `SYSTEM_DS`. Therefore, ensure that the `TM_MAD` for the VirtioFS Datastore matches the one configured for your `SYSTEM_DS`. {{< /alert >}}

## Creating a VirtioFS Datastore

To create a new System Datastore, set the following template parameters:

| Attribute   | Description       |
| ----------- | ----------------- |
| `NAME`      | Name of datastore |
| `TYPE`      | `IMAGE_DS`        |
| `DISK_TYPE` | `FILESYSTEM`      |
| `DS_MAD`    | `virtiofs`        |
| `TM_MAD`    | `local`           |

This can be done either in Sunstone or through the CLI. For example:

```default
$ cat systemds.txt
NAME      = fs_system
TYPE      = IMAGE_DS
DISK_TYPE = FILESYSTEM
DS_MAD    = virtiofs
TM_MAD    = local


$ onedatastore create virtiofs_ds.txt
ID: 101
```

#### Configuration Attributes for VirtioFS Datastores

| Attribute   | Values                  | Description                                |
| ----------- | ----------------------- | -------------------------------------------|
| `NAME`      |                         | Name of datastore                          |
| `TYPE`      | `IMAGE_DS`              | OpenNebula Datastore type                  |
| `DS_MAD`    | `virtiofs`              | Datastore driver to use                    |
| `TM_MAD`    | `any`                   | Transfer driver, must match your SYSTEM_DS |
| `DISK_TYPE` | `FILESYSTEM`            | Specifies the disk type for this datastore |


## Limitations and Considerations

VirtioFS Datastore behaves slightly different than other OpenNebula datastores:

- It does not support traditional VM disk operations such as `snapshots`, `disk-attach` or `save-as`.
- There is no image transfer and it does not support image clonning.
- Unlike other OpenNebula datastores, this datastore does not store VM disk images. Instead, it stores image metadata only.
