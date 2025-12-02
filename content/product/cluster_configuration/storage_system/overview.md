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

## Datastore Types

Storage in OpenNebula is designed around the concept of datastores. A datastore is any storage medium to store disk images. OpenNebula distinguishes between three different datastore types:

* **Images Datastore**, which stores the base operating system images, persistent data volumes, CD-ROMs.
* **System Datastore** holds disks of running Virtual Machines. Disk are moved from/to the Images when the VMs are deployed/terminated.
* **Files & Kernels Datastore** to store plain files (not disk images), e.g. kernels, ramdisks, or contextualization files. [See details here]({{% relref "file_ds#file-ds" %}}).

![image0](/images/datastoreoverview.png)

### Image Datastores

There are different Image Datastores depending on how the images are stored on the underlying storage technology:

: - [NFS/NAS]({{% relref "nas_ds#nas-ds" %}})
  - [Local Storage]({{% relref "local_ds#local-ds" %}})
  - [Ceph]({{% relref "ceph_ds#ceph-ds" %}})
  - [SAN]({{% relref "../san_storage/lvm_drivers#lvm-drivers" %}})
  - [Raw Device Mapping]({{% relref "dev_ds#dev-ds" %}})
  - [iSCSI - Libvirt]({{% relref "iscsi_ds#iscsi-ds" %}}), to access iSCSI devices through the built-in QEMU support
  - [NetApp]({{% relref "netapp" %}}) - Datastore to register a NetApp SAN appliance, provided as an Enterprise Extension
  - [SharedFS (virtiofs)]({{% relref "sharedfs_ds#sharedfs-ds" %}}) for zero-copy access to shared folders on HPC/NAS storage

### System Datastores

Each datastore supports different features, here is a basic overview:

|                                                                                                                 | [NFS/NAS]({{% relref "nas_ds#nas-ds" %}}) | [Local]({{% relref "local_ds#local-ds" %}}) | [Ceph]({{% relref "ceph_ds#ceph-ds" %}}) | [SAN]({{% relref "../san_storage/lvm_drivers#lvm-drivers" %}}) | [iSCSI]({{% relref "iscsi_ds#iscsi-ds" %}}) |
| ------------------------------------------------------------------------------------------------                | ----------------------------              | ------------------------------              | ---------------------------              | ----------------------------------              | ------------------------------              |
| Disk snapshots                                                                                                  | yes                                       | yes                                         | yes                                      | yes (LVM Thin only)                             | yes                                         |
| VM snapshots                                                                                                    | yes                                       | yes                                         | no                                       | no                                              | no                                          |
| Live migration                                                                                                  | yes                                       | yes                                         | yes                                      | yes                                             | yes                                         |
| Fault tolerance<br/>([VM HA]({{% relref "../../control_plane_configuration/high_availability/vm_ha#vm-ha" %}})) | yes                                       | no                                          | yes                                      | yes                                             | yes                                         |

{{< alert title="NetApp SAN Datastore (EE)" >}}

The NetApp SAN Datastore is provided as an Enterprise Extension. Its basic features are listed below.

| Feature                                                                                                     | Supported |
| ----------------------------------------------------------------------------------------------------------- | --------- |
| Disk snapshots                                                                                              | yes       |
| VM snapshots                                                                                                | no        |
| Live migration                                                                                              | yes       |
| Fault tolerance ([VM HA]({{% relref "../../control_plane_configuration/high_availability/vm_ha#vm-ha" %}})) | yes       |

{{< /alert >}}

## How Should I Read This Chapter

Before reading this Chapter make sure you are familiar with Node Deployment from the [Installation]({{% relref "../../../software/installation_process" %}}) guide.

After that, proceed with the specific Datastore documentation you might be interested in.

## Hypervisor Compatibility

This Chapter applies to KVM and LXC.

{{< alert title="Warning" color="warning" >}}
Hypervisor limitations:

- **LXC** nodes only support [NFS/NAS]({{% relref "nas_ds#nas-ds" %}}), [Local Storage]({{% relref "local_ds#local-ds" %}}) and [Ceph]({{% relref "ceph_ds#ceph-ds" %}}) datastores.{{< /alert >}}
