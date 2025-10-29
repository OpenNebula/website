---
title: "Overview"
date: "2025-02-17"
description:
categories:
pageintoc: "67"
tags:
weight: "1"
---

<a id="sm"></a>

<a id="storage"></a>

<!--# Overview -->

## How Should I Read This Chapter

Before reading this Chapter make sure you are familiar with Node Deployment from the [Installation]({{% relref "../../../software/installation_process" %}}) guide.

After that, proceed with the specific Datastore documentation you might be interested in.

## Datastore Types

Storage in OpenNebula is designed around the concept of datastores. A datastore is any storage medium to store disk images. OpenNebula distinguishes between three different datastore types:

* **Images Datastore**, which stores the base operating system images, persistent data volumes, CD-ROMs.
* **System Datastore** holds disks of running Virtual Machines. Disk are moved from/to the Images when the VMs are deployed/terminated.
* **Files & Kernels Datastore** to store plain files (not disk images), e.g. kernels, ramdisks, or contextualization files. [See details here]({{% relref "file_ds#file-ds" %}}).

![image0](/images/datastoreoverview.png)

## Driver Types



## Storage portfolio

| Use case                                                                | Description                                                                                        | Shared | Disk Format                    | Disk snapshots | VM snapshots | Live migration | Fault tolerance | HV      | Availability |
| --                                                                      | --                                                                                                 | --     | --                             | --             | --           | --             | --              | --      | --           |
| [Local storage]({{% relref "local_ds" %}})                              | Images stored in frontend* and transferred to hosts via<br/>SSH on instantiation.                      | no     | raw/qcow2                      | yes            | yes          | yes            | yes             | KVM/LXC | EE/CE        |
| [NFS/NAS]({{% relref "nas_ds" %}})                                      | Images stored in a NFS share, activated directly.                                                  | yes    | raw/qcow2                      | yes            | yes          | yes            | no              | KVM/LXC | EE/CE        |
| [Ceph]({{% relref "ceph_ds" %}})                                        | Images stored in a Ceph pool, activated directly.                                                  | yes    | raw (RBD)                      | yes            | no           | yes            | yes             | KVM/LXC | EE/CE        |
| [SAN - LVM]({{% relref "../san_storage/lvm/lvm" %}})                    | Images stored as LVs in a SAN, activated directly.                                                 | yes    | raw (LV)                       | yes            | no           | yes            | yes             | KVM     | **EE only**  |
| [SAN - LVM<br/>(File Mode)]({{% relref "../san_storage/lvm/filemode" %}}) | Images stored in frontend\*, transferred to hosts via SSH,<br/>and copied to the SAN on instantiation. | yes    | raw (LV)<br/>Images: raw/qcow2 | yes**          | no           | yes            | yes             | KVM     | EE/CE        |
| [SAN - NetApp]({{% relref "../san_storage/netapp" %}})                  | Images stored in a NetApp cabin, activated directly.                                               | yes    | raw (LUN)                      | yes            | no           | yes            | yes             | KVM     | **EE only**  |

<sup>\*</sup> Additional options available by mounting remote filesystems in the frontend.

<sup>\*\*</sup> Only with LVM Thin mode enabled.

### Other storage options

There are some storage options whose usage should be restricted to administrators, as they give low-level access to hosts and could become a serious security risk. Please read carefully the corresponding documentation before using them:

| Use case                                      | Description                                           | Shared | Disk Format  | Disk snapshots | VM snapshots | Live migration | Fault tolerance | HV  | Availability |
| --                                            | --                                                    | --     | --           | --             | --           | --             | --              | --  | --           |
| [Raw Device Mapping]({{% relref "dev_ds" %}}) | Images accessed as block devices directly from hosts. | yes    | raw (block)  | yes            | no           | yes            | no              | KVM | EE/CE        |
| [SAN - iSCSI]({{% relref "iscsi_ds" %}})      | Images accessed as iSCSI LUNs directly from hosts.    | yes    | raw (volume) | yes            | no           | yes            | yes             | KVM | EE/CE        |

