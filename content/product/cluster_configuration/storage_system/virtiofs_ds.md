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

## Creating a VirtioFS Datastore

To create a new Image Datastore, define the following template parameters:

| Attribute   | Values           | Description                                       |
| ----------- | ---------------- | --------------------------------------------------|
| `NAME`      |                  | Name of the datastore                             |
| `TYPE`      | `IMAGE_DS`       | OpenNebula datastore type                         |
| `DS_MAD`    | `virtiofs`       | Datastore driver                                  |
| `TM_MAD`    | `virtiofs`       | Transger manager driver                           |

This can be done either in Sunstone or through the CLI. For example:

```default
$ cat ds.conf
NAME      = fs_datastore
TYPE      = IMAGE_DS
DS_MAD    = virtiofs
TM_MAD    = virtiofs

$ onedatastore create ds.conf
ID: 100
```

## Usage
Once the Image Datastore is created, register an image that represents a host directory. Typically, only the path and image type needs to be defined.
```
oneimage create --name fs_data --datastore fs_datastore --persistent --path /mnt/data --type filesystem
```

For use cases where the same directory must be shared across multiple VMs simultaneously, create the image as non-persistent and set `READONLY="YES"`.

After the image is registered, it can be used as any other disk by adding it to the VM template using the `DISK` attribute.
```
DISK= [ IMAGE = "fs_data" ]
```

By default, OpenNebula generates:

- A mount point (`MOUNT_POINT`), in the form `/mnt/one-fs-<image_id>`
- A mount tag (`MOUNT_TAG`), in the form `one-<image_id>`

Context packages use these values to automatically mount the filesystem inside the VM via virtiofs. These values can be overridden in the `DISK` or `IMAGE` attributes to define a custom mount point (and tag) inside the guest.

For example, overriding it in a `DISK`:
```
DISK= [ IMAGE = "fs_data", MOUNT_POINT="/srv/data", MOUNT_TAG="one-tag" ]
```

Or overriding it in an `IMAGE`:
```
$ cat update_image.conf
MOUNT_POINT="/srv/data"
MOUNT_TAG="one-tag"

oneimage update 0 update_image.conf
```

If both are specified, the `DISK` attributes are prioritized.

## Considerations

The VirtioFS Datastore behaves differently from other OpenNebula datastores:

- It does not support disk operations such as `snapshots`, `backups`, `disk-attach`, `resize` or `save-as`.
- The datastore does not store VM disk data. It only stores image metadata. Reported datastore capacity (free, used, total) is always 0.
- It doesn't transfer any images (since it does not use images, only metadata) and has no support for image cloning.
- Image size reflects the size of the directory, as reported by the `du` command, if it is available to the Frontend or hosts listed in `BRIDGE_LIST`
- If the VM is configured with Hugepages, they are used as the `MemoryBacking` source with `shared` mode. Otherwise, a `memfd` source is used.
- The same image cannot be attached more than once to the same VM.
- Two different images cannot share the same `MOUNT_TAG`.

### User and Group ID mapping

OpenNebula configures virtiofs UID/GID mapping using a subordinate ID range starting at `100000` with a size of `65536` for the `oneadmin` user. If `/etc/subuid` or `/etc/subgid` already contain an entry for oneadmin, it will be respected and not modified. These entries are created on hosts during the installation of the `opennebula-node-kvm` package.

Access to the host directory is performed through this mapping, meaning guest user and group IDs are translated into the configured subordinate range on the host. The mapping can be adjusted globally in vmm_exec_kvm.conf, or per host or cluster using the same attributes defined there. For example:

```
DISK = [ UID_MAP = "1000", GID_MAP = "1000" ]
```

When customizing these values, ensure that the subordinate ID range configured for oneadmin in `/etc/subuid` and `/etc/subgid` matches the virtiofs `<idmap>` settings. Mismatched configurations may result in permission errors or unexpected ownership on the shared filesystem.
