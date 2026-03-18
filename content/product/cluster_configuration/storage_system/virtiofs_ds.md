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

## Overview

OpenNebula supports sharing host directories with Virtual Machines using virtiofs. This enables high-performance, low-latency file sharing between the host and guests. The feature is exposed through a dedicated datastore configured to provide directory-based disks, which are attached to VMs and exported via virtiofs.

Unlike traditional block-based disks, these disks represent host directories. This makes them suitable for:

- Shared data volumes across VMs
- HPC / AI workloads requiring fast POSIX access
- Container-like storage semantics inside VMs
  
## Requirements

Before creating and using a VirtioFS Datastore, ensure the following:

- The filesystem to be mounted must already exist and be available at the same path on each compute host in the cluster where VMs will be deployed.
- The `virtiofsd` daemon and libvirt/QEMU with VirtioFS support must be installed on each hypervisor node.
- No additional transfer mechanism (`TM_MAD`) is required since the filesystems are already present on the hosts. However, a `TM_MAD` must still be defined in the datastore template (even if OpenNebula does not use it).

{{< alert title="Note" color="success" >}}
OpenNebula requires that `IMAGE_DS` share the same `TM_MAD` as `SYSTEM_DS`. Ensure that the `TM_MAD` for the VirtioFS Datastore matches the one configured for your `SYSTEM_DS`.
{{< /alert >}}

## Creating a VirtioFS Datastore


To create a new Image Datastore, define the following template parameters:

| Attribute   | Values           | Description                                       |
| ----------- | ---------------- | --------------------------------------------------|
| `NAME`      |                  | Name of the datastore                             |
| `TYPE`      | `IMAGE_DS`       | OpenNebula datastore type                         |
| `DS_MAD`    | `virtiofs`       | Datastore driver                                  |
| `TM_MAD`    | `any existing`   | Transfer driver, must match a `SYSTEM_DS`         |
| `DISK_TYPE` | `FILESYSTEM`     | Directory-based disk type                         |

This can be done either in Sunstone or through the CLI. For example:

```default
$ cat fs_datastore.txt
NAME      = fs_datastore
TYPE      = IMAGE_DS
DISK_TYPE = FILESYSTEM
DS_MAD    = virtiofs
TM_MAD    = local

$ onedatastore create fs_datastore.txt
ID: 101
```

## Usage
Once the Image Datastore is created, register an image that represents a host directory. Typically, only the path needs to be defined.
```
oneimage create --name fs_data --datastore fs_datastore --persistent --path /mnt/data
```

For use cases where the same directory must be shared across multiple VMs simultaneously, create the image as non-persistent and set `READONLY="YES"`.

After the image is registered, it can be used as any other disk by adding it to the VM template using the `DISK` attribute.
```
DISK= [ IMAGE = "fs_data" ]
```

By default, OpenNebula generates:

- A mount point (`MOUNT_POINT`), in the form `/mnt/one-fs-<image_id>`
- A mount tag (`MOUNT_TAG`), in the form `one-<image_id>`

Context packages use these values to automatically mount the filesystem inside the VM via virtiofs. These values can be overridden in the `DISK` attribute to define a custom mount point (and tag) inside the guest.
```
DISK= [ IMAGE = "fs_data", MOUNT_POINT="/srv/data" ]
```

## Considerations

The VirtioFS Datastore behaves differently from other OpenNebula datastores:

- It does not support disk operations such as `snapshots`, `disk-attach`, `resize` or `save-as`.
- There is no image transfer and no support for image cloning.
- The datastore does not store VM disk data. It only stores image metadata. Reported datastore capacity (free, used, total) is always 0.
- Image size reflects the size of the directory, as reported by the `du` command.
- If the VM is configured with Hugepages, they are used as the `MemoryBacking` source with `shared` mode. Otherwise, a `memfd` source is used.
- The same image cannot be attached more than once to the same VM, nor reused with the same mount tag.

{{< alert title="Note" color="success" >}}
Access to the host directory is mapped (`UID`/`GID`) to the `oneadmin` user and group. This mapping can be adjusted globally in `vmm_exec_kvm.conf`, or per host or cluster using the same attributes defined in `vmm_exec_kvm.conf`, for example (`DISK = [ UID_MAP = "1000", GID_MAP = "1000" ]`).
{{< /alert >}}
