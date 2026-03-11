---
title: "StorPool Datastore"
weight: "2"
---

StorPool is a distributed, software-defined block storage platform that transforms standard x86 servers into enterprise-grade shared storage. Native integration with OpenNebula enables full VM disk lifecycle management -- provisioning, cloning, snapshots, live migration, and cleanup -- with the performance, reliability, and operational simplicity that production clouds demand.

With StorPool, OpenNebula clouds gain storage that scales linearly, eliminates single points of failure, and delivers consistent sub-millisecond latency regardless of load, all managed through the familiar OpenNebula interface without manual storage operations.

## Why StorPool + OpenNebula

* **Ultra-Low Latency**: Sub-millisecond in-VM response times with custom networking protocols designed for maximum throughput
* **Enterprise Reliability**: Distributed shared-nothing architecture with no single point of failure and three-way synchronous replication
* **Proven Scale**: 13+ million IOPS demonstrated on production clusters; linear scaling as you add nodes
* **Operational Simplicity**: In-service upgrades, online configuration changes, and automatic failure recovery

## StorPool Capabilities

When you deploy StorPool with OpenNebula, your infrastructure benefits from the following enterprise-grade storage capabilities:

### Reliability and Data Protection

* **End-to-end data integrity**:  Proprietary 64-bit checksums protect against silent data corruption, phantom writes, and bit rot across the full data lifecycle
* **Three-way synchronous replication**:  Configurable per-volume; system continues operating even during simultaneous drive failures
* **Automatic recovery**:  The self-healing cluster detects failures and recovers automatically, reducing operational burden
* **Fault sets**:  Isolate failure domains to ensure copies are distributed across physical boundaries

### Performance and Efficiency

* **Erasure Coding**:  Massive capacity savings with near-zero performance impact; per-volume policy management
* **NVMe and multi-core optimization**:  Direct NVMe drivers bypass kernel overhead
* **Thin provisioning and zero detection**:  Provision more than physical capacity; empty blocks consume no space
* **Instant snapshots and clones**:  Copy-on-write technology for space-efficient, high-performance copies

### Flexible Deployment

* **Hyper-converged or dedicated**:  Run storage alongside compute, or on dedicated storage nodes
* **Data tiering and storage pools**:  Multiple performance profiles within a single cluster with no data migration
* **10/25/40/100 GbE support**:  Scale network bandwidth to match your requirements

### Operations and Integration

* **RESTful JSON API**:  Full automation and integration with existing management systems
* **In-service upgrades**:  Rolling updates without service interruption
* **Storage QoS**:  Per-volume IOPS and bandwidth limits ensure SLA compliance
* **iSCSI and NVMe/TCP**:  Connect systems that don't support the native StorPool driver

[See all StorPool features](https://storpool.com/features)

## OpenNebula Integration Features

### Standard Datastore Operations

StorPool supports all standard OpenNebula datastore features (see [Datastores]({{% relref "../../../product/cluster_configuration/storage_system/datastores" %}})), including image provisioning, VM disk management, live migration, snapshots, and cloning operations. For limitations and exceptions, see the [Compatibility Notes]({{% relref "./storpool#compatibility-notes" %}}) section below.

### Extra Features

| Feature | Supported | Details |
| :---- | :---- | :---- |
| Delayed disk termination | Yes | Deleted VM disks are preserved for 48 hours (configurable), allowing recovery from accidental deletions |
| StorPool VolumeCare tags | Yes | [Automated snapshot policies per VM](https://kb.storpool.com/integrations/OpenNebula/docs/volumecare.html) |
| StorPool QoS Class tags | Yes | [Per-VM performance policies](https://kb.storpool.com/integrations/OpenNebula/docs/qosclass.html) |
| Multiple StorPool clusters | Yes | Different clusters as separate datastores |
| StorPool MultiCluster | Preview | [Introduction to multi-cluster mode](https://kb.storpool.com/admin-guide/multi/multi-cluster-introduction.html) |
| Multiple OpenNebula instances | Yes | Multiple controllers sharing a single StorPool cluster |
| CDROM hotplug | Yes | Attach/detach CD images to running VMs |


### Optional Features

| Feature | Supported | Details |
| :---- | :---- | :---- |
| VM disk snapshots limit | Optional | Disk snapshot limits with configurable thresholds |
| Remote snapshot transfer | Optional | Optionally send a StorPool snapshot of VM disk or Image data to a secondary StorPool cluster when deleted from OpenNebula (for example, for regulatory compliance or law enforcement requirements) |
| Domain XML deploy tweaks | Optional | Additional libvirt customizations via deploy scripts (for options not yet exposed in OpenNebula templates); see [Deployment tweaks](https://kb.storpool.com/integrations/OpenNebula/docs/deploy_tweaks.html) |
| VM checkpoint on StorPool | Optional | Option to keep the VM checkpoint files on StorPool block devices |
| Atomic VM disk snapshots | Optional | Replace the default VM snapshot interface in OpenNebula with a custom VM snapshot interface manageable to do atomic disk snapshots |

### Compatibility Notes

| Item | Status |
| :---- | :---- |
| VM State Snapshots | Not supported related to libvirt limitation with RAW disks. Alternative: reconfigure OpenNebula's 'VM snapshot' interface to perform atomic disk-only snapshots via StorPool. |
| [OpenNebula Backups]({{% relref "../../../product/virtual_machines_operation/virtual_machine_backups/operations" %}}) | Only FULL backup mode is supported. Incremental backups are not available. Also requires temporary space on the hosts before transferring to the backup backend. |
| Persistent [Image Attributes]({{% relref "../../../product/operation_references/configuration_references/img_template" %}}) | Persistent images with SHAREABLE or IMMUTABLE attributes are not supported. |
| Tested Platforms | KVM hypervisor on current Alma Linux and Ubuntu, and other StorPool-supported Linux distributions. For details, see OpenNebula's [Release Information]({{% relref "../../../software/release_information" %}}) and StorPool's [System Requirements](https://storpool.com/latest/StorPool-System-Requirements-latest.pdf). |
| [vTPM]({{% relref "../../../product/virtual_machines_operation/virtual_machines/vm_templates#tpm" %}}) support | Limited compatibility due to the current upstream design/implementation -- the vault is stored on file, so it is not compatible with StorPool snapshots and extra functionalities like ``VolumeCare`` and Disaster Recovery Engine. |

For current known issues, see [Known Issues](https://kb.storpool.com/integrations/OpenNebula/docs/known_issues.html).

## Architecture Overview

At a high level, the integration works as follows:

* StorPool Cluster

  A set of Linux servers run the StorPool distributed storage software. Their local drives are aggregated into a single pool of shared block storage with synchronous replication and linear scaling of capacity and performance.

* OpenNebula Front-end

  The OpenNebula [front-end]({{% relref "../../../product/control_plane_configuration" %}}) runs the StorPool datastore (DS_MAD) and transfer manager (TM_MAD) drivers. It communicates with the StorPool API management interface to create, clone, rename, and delete volumes corresponding to OpenNebula images and VM disks. The controller is running on a Highly Available VM managed by ``storpool_havm`` service.
  
* OpenNebula Nodes (Hypervisors)

  KVM hypervisor nodes run the ``storpool_block`` initiator driver to access StorPool volumes as block devices. In Hyper-Converged Infrastructure (HCI) deployments, these nodes run both compute workloads and the StorPool storage service on the same physical hardware. VM disks are attached directly from StorPool to the hypervisors, with OpenNebula orchestrating which volumes attach to which hosts.

When a VM is created, scaled, migrated, or terminated in OpenNebula, the driver translates these operations into volume and snapshot operations on StorPool. This keeps VM lifecycle management in OpenNebula while StorPool ensures the underlying storage is fast, resilient, and efficiently utilized.

For a deeper architectural description and reference designs, see the [Hyperconverged Cloud Architecture with OpenNebula and StorPool](https://cloud.storpool.com/hubfs/content-downloads/Hyperconverged-Cloud-Reference-Architecture-StorPool-and-OpenNebula.pdf) white paper.

## Requirements

For detailed installation requirements, compatibility information, and version-specific prerequisites, see the [addon-storpool](https://github.com/OpenNebula/addon-storpool) GitHub repository.

### Getting Started

* [Installation and Upgrade](https://kb.storpool.com/storpool_integrations/OpenNebula/docs/installation.html): Step-by-step guide to installing the storpool_block initiator and driver components
* [OpenNebula Configuration](https://kb.storpool.com/integrations/OpenNebula/docs/one_configuration.html): Required settings for [oned.conf]({{% relref "../../../product/operation_references/opennebula_services_configuration/oned#oned-conf" %}}), TM_MAD, DS_MAD, and Datastore templates
* [Support Life Cycles](https://kb.storpool.com/integrations/OpenNebula/support_lifecycle.html): Supported OpenNebula versions, compatibility matrix, and EOL dates

### Advanced Features

* [Advanced Configuration Variables](https://kb.storpool.com/integrations/OpenNebula/docs/advanced_configuration.html): All variables exposed via ``addon-storpoolrc``: QoS, tags, monitoring, Multi-Cluster
* [QoS Class Configuration](https://kb.storpool.com/integrations/OpenNebula/docs/qosclass.html): How to configure and apply Performance Tiers to your VMs
* [VolumeCare](https://kb.storpool.com/integrations/OpenNebula/docs/volumecare.html): Setting up automated snapshot policies and retention tags
* [Deployment Tweaks](https://kb.storpool.com/integrations/OpenNebula/docs/deploy_tweaks.html): Optimizing KVM/Libvirt XML for maximum storage performance (iothreads, queues)

### Operations and Troubleshooting

* [StorPool Naming Convention](https://kb.storpool.com/integrations/OpenNebula/docs/naming_convention.html): Understanding how OpenNebula images map to StorPool volumes
* [Revert Volume from Snapshot](https://kb.storpool.com/integrations/OpenNebula/revert-volume.html): Procedures for rolling back data at the storage level
* [Copying a VM Between Clusters](https://kb.storpool.com/integrations/OpenNebula/copying-vm-between-clusters.html): Workflows for moving workloads across StorPool clusters
* [Live Resizing CPU and Memory](https://kb.storpool.com/integrations/OpenNebula/docs/resizeCpuMem.html): Recommended procedures and storage-related caveats
* [Tips](https://kb.storpool.com/integrations/OpenNebula/docs/tips.html): Operational best practices for performance, troubleshooting, and day-to-day use
* [Known Issues](https://kb.storpool.com/integrations/OpenNebula/docs/known_issues.html): Continuously updated list of driver and integration issues with workarounds

### Development and Support

* GitHub Repository: [addon-storpool](https://github.com/OpenNebula/addon-storpool)
* Community: [OpenNebula Forum](https://forum.opennebula.io/c/integration/33)
* Lead Developer: Anton Todorov ([a.todorov@storpool.com](mailto:a.todorov@storpool.com))

For the latest documentation and updates, visit the [StorPool Knowledge Base](https://kb.storpool.com/integrations/OpenNebula/index.html).
