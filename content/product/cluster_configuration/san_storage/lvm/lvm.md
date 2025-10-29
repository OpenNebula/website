---
title: "LVM SAN Datastore (EE)"
linktitle: "LVM (EE)"
date: "2025-02-17"
description:
categories:
pageintoc: "72"
tags:
weight: "2"
---

With LVM SAN Datastore (EE), both disks images and actual VM drives are stored as Logical Volumes (LVs) in the SAN
storage. This allows for fast and efficient VM instantiation, as no data needs to be copied or
moved.

This is the recommended driver to be used when a high-end SAN is available, and there is not a
specific driver available for it (e.g., [NetApp]({{% relref "netapp" %}})). The same LUN can be
exported to all the Hosts while Virtual Machines will be able to run directly from the SAN.

## How Should I Read This Chapter

Before performing the operations outlined in this chapter, you must configure access to the SAN following one of the setup guides in the [LVM Overview]({{% relref "overview#san-appliance-setup" %}}) section.

## Hypervisor Configuration

In this first step, you will configure hypervisors for LVM operations over the shared SAN storage.

### Hosts LVM Configuration
Prerequisites: 
* LVM2 must be available on Hosts.
* `lvmetad` must be disabled. Set this parameter in `/etc/lvm/lvm.conf`: `use_lvmetad = 0`, and disable the `lvm2-lvmetad.service` if running.
* `oneadmin` needs to belong to the `disk` group.
* All the nodes need to have access to the same LUNs.

{{< alert title="Note" color="success" >}}
The LVM Datastore does not need CLVM configured in your cluster. The drivers refresh LVM metadata each time an image is needed on another Host.
{{< /alert >}}

{{< alert title="Note" color="success" >}}
In case of the virtualization Host reboot, the volumes need to be activated to be available for the hypervisor again. If the [node package]({{% relref "kvm_node_installation#kvm-node" %}}) is installed, the activation is done automatically. If not, each volume device of the Virtual Machines running on the Host before the reboot needs to be activated manually by running `lvchange -ay $DEVICE` (or, activation script `/var/tmp/one/tm/fs_lvm_ssh/activate` from the remote scripts may be executed on the Host to do the job).
{{< /alert >}}

Virtual Machine disks are symbolic links to the block devices. However, additional VM files like checkpoints or deployment files are stored under `/var/lib/one/datastores/<id>`. Be sure that enough local space is present.


## OpenNebula Configuration

In this step you configure OpenNebula to interface with the SAN. For this purpose, create the two required OpenNebula datastores: Image and System. Both of them use the `lvm` transfer driver (TM_MAD).

### Create System Datastore

To create a new SAN/LVM System Datastore, set the following template parameters:

| Attribute     | Description                                                  |
|---------------|--------------------------------------------------------------|
| `NAME`        | Name of the Datastore                                        |
| `TYPE`        | `SYSTEM_DS`                                                  |
| `TM_MAD`      | `lvm`                                                        |
| `DISK_TYPE`   | `BLOCK` (used for volatile disks)                            |
| `BRIDGE_LIST` | Front-end will use hosts in the list to proxy SAN operations |

For example:

```default
> cat ds_system.conf
NAME   = lvm_system
TM_MAD = lvm
TYPE   = SYSTEM_DS
DISK_TYPE = BLOCK

> onedatastore create ds_system.conf
ID: 100
```

### Create Image Datastore

To create a new LVM Image Datastore, set following template parameters:

| Attribute         | Description                                                                                                 |
| ----------------- | ----------------------------------------------------------------------------------------------------------- |
| `NAME`            | Name of Datastore                                                                                           |
| `TYPE`            | `IMAGE_DS`                                                                                                  |
| `DS_MAD`          | `lvm`                                                                                                       |
| `TM_MAD`          | `lvm`                                                                                                       |
| `DISK_TYPE`       | `BLOCK`                                                                                                     |
| `LVM_THIN_ENABLE` | (default: `NO`) `YES` to enable [LVM Thin]({{% relref "#lvm-thin" %}}) functionality (RECOMMENDED).         |

The example below illustrates the creation of an LVM Image Datastore:

```default
> cat ds_image.conf
NAME = lvm_image
DS_MAD = lvm
TM_MAD = lvm
DISK_TYPE = "BLOCK"
TYPE = IMAGE_DS
LVM_THIN_ENABLE = yes
SAFE_DIRS="/var/tmp /tmp"

> onedatastore create ds_image.conf
ID: 101
```

Afterwards, create an LVM VG in the shared LUN for the image datastore **with the
following name: `vg-one-<image_ds_id>`**. This step is performed once, either in one host,
or the front-end if it has access. This VG is where both images and VM disks will be located, and
OpenNebula will take care of creating and managing the LVs for each of them.

For example, assuming `/dev/mapper/mpatha` is the LUN (iSCSI/multipath) block device:

```
# pvcreate /dev/mapper/mpatha
# vgcreate vg-one-101 /dev/mapper/mpatha
```

<a id="lvm-driver-conf"></a>

### Driver Configuration

The following attribute can be set for every datastore type:

* `SUPPORTED_FS`: Comma-separated list with every filesystem supported for creating formatted datablocks. Can be set in `/var/lib/one/remotes/etc/datastore/datastore.conf`.
* `FS_OPTS_<FS>`: Options for creating the filesystem for formatted datablocks. Can be set in `/var/lib/one/remotes/etc/datastore/datastore.conf` for each filesystem type.

{{< alert title="Warning" color="warning" >}}
Before adding a new filesystem to the `SUPPORTED_FS` list, verify that the corresponding `mkfs.<fs_name>` command is available in all Hosts including the front-end and hypervisors. The system will revert to the default filesystem if an unsupported one is detected.
{{< /alert >}}

<a id="datastore-internals"></a>

## Datastore Internals

To benefit from LVM Thin Provisioning, both images and disks are stored on the same VG
which is the one associated to the OpenNebula **Image Datastore**. So, there is not a direct mapping
from the System Datastore to any VG; VM disks instantiated from a given image are located at the
same VG/LUN as the image they came from.

![image0](/images/lvm_datastore.svg)

Images are stored in a different format depending on whether they are persistent or not.

- Persistent images are stored as a Thin Pool called `img-one-<imgid>-pool`, containing at least
a Thin Volume called `img-one-<imgid>`. Example for image ID 162:

```default
# lvs
  LV               VG         Attr       LSize   Pool
  img-one-162      vg-one-101 Vwi---tz-k 512.00m img-one-162-pool
  img-one-162-pool vg-one-101 twi---tz-k 512.00m
```

The images are automatically activated when a VM runs them. After activation, volume looks like this from the
host. Include the `-a` flag to see also the hidden pool data/metadata LVs:

```default
# lvs -a
  LV                       VG         Attr       LSize   Pool             Data%  Meta%
  img-one-162              vg-one-101 Vwi-aotz-k 512.00m img-one-162-pool 42.41
  img-one-162-pool         vg-one-101 twi---tz-k 512.00m                  42.41  12.30
  [img-one-162-pool_tdata] vg-one-101 Twi-ao---- 512.00m
  [img-one-162-pool_tmeta] vg-one-101 ewi-ao----   4.00m
```

Note the **a**ctive state and the **o**pen device bits both in the Thin Volume and both Pool LVs.
Additionally, the output of the command displays usage statistics.

Disk snapshots made during the VM lifetyme are created within the Pool, and preserved across VM
instantiations. Here is the situation after creating a couple of snapshots and then terminating the
VM following the previous example:

```default
# lvs
  LV               VG         Attr       LSize   Pool             Origin
  img-one-162      vg-one-101 Vwi---tz-k 512.00m img-one-162-pool
  img-one-162-pool vg-one-101 twi---tz-k 512.00m
  img-one-162_s0   vg-one-101 Vwi---tz-k 512.00m img-one-162-pool img-one-162
  img-one-162_s1   vg-one-101 Vwi---tz-k 512.00m img-one-162-pool img-one-162
```

Upon image deletion, the Thin Pool and all its Thin Volumes like disks and snapshots are deleted.

- Non-persistent images are stored as a regular LV called `img-one-<imgid>`. Example for image ID
 27:

```default
# lvs
  LV               VG         Attr       LSize   Pool
  img-one-27       vg-one-101 -ri------k 512.00m
```

They are activated by creating a **Thin Snapshot** of each, named `vm-one-<vmid>-<diskid>`, inside a
per-VM Thin Pool called `vm-one-<vmid>-pool`. For example, launching a VM containing the previous
image as a disk, results in the following:

```default
# lvs
  LV               VG         Attr       LSize   Pool             Origin     Data%  Meta%
  img-one-27       vg-one-101 ori------k 512.00m
  vm-one-228-0     vg-one-101 Vwi-aotz-k 512.00m vm-one-228-pool  img-one-27 1.03
  vm-one-228-pool  vg-one-101 twi---tz-k 512.00m                             1.03   10.94
```

Note the **o**rigin flag now being set on the base image, as it is now used as `vm-one-228-0`'s
origin. As it's also set to **r**ead-only, the same image can be used as the origin of several
disks. The disk volume (`vm-one-228-0`) is a thinly provisioned copy-on-write read-write volume that
only stores the changed blocks from its origin.

When the disk is not needed anymore (e.g., VM terminated or disk detached) the volume is deleted as
well as its snapshots (if any).

{{< alert title="Note" color="success" >}}
This model makes over-provisioning easy, by having pools smaller than the sum of its LVs. The current version of this driver does not allow such cases to happen though, as the pool grows dynamically to be always able to fit all of its Thin LVs even if they were full.{{< /alert >}}

For more details about the inner workings of LVM Thin Provisioning, please refer to the [lvmthin(7)](https://man7.org/linux/man-pages/man7/lvmthin.7.html) man page.
