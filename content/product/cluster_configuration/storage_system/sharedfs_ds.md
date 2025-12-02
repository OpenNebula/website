---
title: "SharedFS Datastore"
linktitle: "SharedFS"
date: "2025-12-02"
description: "Directory-based datastore that exposes shared folders to VMs via virtiofs."
categories:
pageintoc: "10"
tags:
weight: "10"
---

<a id="sharedfs-ds"></a>

The **SharedFS Datastore** stores directory-based “images” (datasets, AI model folders, etc.) located on a shared filesystem. Instead of cloning data into the System Datastore, disk entries are exposed directly to guest VMs using the `virtiofs` device, providing **zero-copy access** from the VM to the shared storage.

This datastore is intended for KVM hosts that have access to the same high-performance filesystem (NFS, Lustre, Vast, Weka, …) where the directories live. Each directory registered as an OpenNebula image is mounted inside the guest VM as a `virtiofs` filesystem.

## Configuration

The [common datastore attributes]({{% relref "datastores#datastore-common" %}}) also apply to SharedFS. The specific attributes are:

| Attribute      | Value / Description                                                                                         |
|----------------|-------------------------------------------------------------------------------------------------------------|
| `TYPE`         | `IMAGE_DS`                                                                                                  |
| `DS_MAD`       | `sharedfs`                                                                                                  |
| `TM_MAD`       | `dummy` (no file transfers are executed; disks are already shared)                                         |
| `DISK_TYPE`    | `SHAREDFS` (required so that the KVM driver generates `<filesystem type='mount'>` entries)                  |
| `CLONE_TARGET` | `SYSTEM` (preserves unique directories when the image is cloned)                                            |
| `LN_TARGET`    | `NONE` (no hard links)                                                                                      |
| `CLONE_TARGET_LOCAL` / `LN_TARGET_LOCAL` / `DISK_TYPE_LOCAL` | Needed when the System datastore uses `local`/`dummy` drivers so OpenNebula knows this Image DS is compatible. Typical values: `SYSTEM`, `NONE`, `FILE`. |
| `ALLOW_ORPHANS`| `NO` is recommended because each directory is tracked by OpenNebula                                         |

Only directory sources are supported. `sharedfs/cp` can register:

* Local directories or tarballs (stored as directories inside `BASE_PATH`)
* Hugging Face URIs through the `hf://` scheme (the helper downloads the model directly into the datastore). Other schemes (`http://`, `s3://`, etc.) are rejected.

### Example

```default
NAME      = "AI Models Shared"
TYPE      = "IMAGE_DS"
DS_MAD    = "sharedfs"
TM_MAD    = "dummy"
DISK_TYPE = "SHAREDFS"
CLONE_TARGET        = "SYSTEM"
LN_TARGET           = "NONE"
CLONE_TARGET_LOCAL  = "SYSTEM"
LN_TARGET_LOCAL     = "NONE"
DISK_TYPE_LOCAL     = "FILE"
SAFE_DIRS           = "/var/tmp"
RESTRICTED_DIRS     = "/,/boot,/etc"
```

```
$ onedatastore create sharedfs.conf
ID: 100

$ onedatastore show 100
...
DS_MAD         : sharedfs
TM_MAD         : dummy
DISK_TYPE      : SHAREDFS
BASE PATH      : /var/lib/one/datastores/100
STATE          : READY
```

## Host Requirements

* All KVM hosts **and** the Front-end must mount the same shared filesystem at the path specified by `BASE_PATH`. The mount must be writable by the `oneadmin` user.


## Guest Requirements

Virtual Machines must:

* Run a kernel with `virtiofs` support (Linux 5.4+).
* Include `fuse3` or equivalent userspace utilities.
* Mount the filesystem inside the guest:

```
# mkdir -p /mnt/disk1
# mount -t virtiofs disk1 /mnt/disk1
```

The `<tag>` matches the `TARGET` generated for the disk (e.g., `disk1`). You can provide helper scripts in the VM template context to mount automatically.

## Image Operations

* `oneimage create --path /data/models/llama --d <datastore>` registers the directory as a SharedFS image (format `dir`, disk type `SHAREDFS`).
* `oneimage create --path hf://meta-llama/Llama-3-8B -d <datastore>` downloads the model directory from Hugging Face into the datastore.
* `oneimage clone` duplicates directories within the shared filesystem.
* `oneimage delete` removes the directory from the shared filesystem.

No qcow2/raw disk files are created; each image remains a directory tree.

## VM Templates

Use the image like any other disk:

```default
DISK = [
  IMAGE_ID = "123",
]
```

When the VM is instantiated, the following block is added to the VM deployment file:

```xml
<filesystem type='mount' accessmode='passthrough'>
  <driver type='virtiofs' cache='always' queue='1024'/>
  <source dir='/var/lib/one/datastores/100/4c9c...'/>
  <target dir='sda'/>
</filesystem>
<memoryBacking>
  <source type='memfd'/>
  <access mode='shared'/>
</memoryBacking>
```

No data transfer happens during deployment and multiple VMs can mount the same directory concurrently. Changes performed from one VM are immediately visible from the others (subject to filesystem semantics).

## Limitations & Tips

* Only directory-based images are supported. ISO/qcow2 files must remain in traditional datastores.
* `hf://` is currently the only remote import protocol. For other sources, copy the directory locally and register it.
* Because storage is shared, quota enforcement depends on the external filesystem. Use `sharedfs/stat` to track consumption.
* Combine SharedFS with [marketplaces]({{% relref "../../product/apps-marketplace/managing_marketplaces/overview" %}}) to catalogue large model libraries (e.g., Hugging Face) without duplicating content.