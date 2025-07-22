---
title: "What's New"
date: "2025-02-17"
description:
categories:
pageintoc: "244"
tags:
weight: "2"
---

<a id="whats-new"></a>

<!--# What’s New in 7.0 -->

We’re excited to introduce **OpenNebula 7.0 “Phoenix”** as the first major release in the new 7.x series, marking a significant evolution of the platform. Just like the mythological bird rising from its ashes, this release symbolizes resilience and transformation—a fitting name for a platform reinventing itself in the face of emerging trends in AI and multi-cloud. With 7.0, OpenNebula takes a giant leap forward to help organizations modernize their infrastructure, embrace next-generation workloads, and break free from legacy virtualization platforms like VMware.

> ![image](/images/cloud-view-dashboard-rns.png)

A key highlight of OpenNebula 7.0 is the inclusion of migration packages in the Community Edition, making it easier for community users to stay up to date and take full advantage of the latest innovations.

Another big plus of 7.0 is the introduction of [OpenNebula Distributed Resource Scheduler (OneDRS)](../../../product/cloud_system_administration/scheduler/drs), delivering predictive scheduling, customizable policies, and automated VM migrations to ensure optimal resource utilization across your infrastructure. OneDRS analyzes historical and real-time metrics to anticipate demand spikes and proactively balance workloads—minimizing contention and maximizing performance.

OpenNebula 7.0 is designed for modern workloads, with enhancements to support:

- GPU passthrough and PCI device hotplugging
- Improved OneFlow for AI workflows and batch deployments
- OVA Import
- Better integration with Ceph, LVM, and containerized applications
- Integration with Veeam, allowing policy-based backup and restore operations
- Native drivers for NetApp
- NUMA-aware PCIe topology
- … and many more, check below.

OpenNebula 7.0 continues the effort to streamline the platform by removing or deprecating legacy and little-used components, simplifying the architecture, and ensuring the long-term maintainability of the platform. The FireEdge-based Sunstone UI is now the standard web interface, with a growing list of UI components and dashboards.

| Component         | Status   | Replacement / Notes           |
|------------------|----------|-------------------------------|
| Ruby Sunstone     | Removed  | Fully replaced by FireEdge UI |
| vCenter driver    | Legacy   | Use KVM migration tools        |
| LXD & Docker drivers | Removed  | OneKE & LXC                    |

OpenNebula 7.0 is named after the [Phoenix Nebula](https://www.instagram.com/p/Cz66tq7yo6J/), a spectacular cosmic structure located in the [constellation](https://en.wikipedia.org/wiki/Phoenix_(constellation)) of the same name. This nebula is a dynamic region of gas and dust shaped by intense stellar winds and supernova activity—an evocative symbol of transformation, power, and renewal. Like the Phoenix Nebula rising from the remnants of massive stars, OpenNebula 7.0 rises as a robust, flexible, and modern open source cloud platform ready for the AI-driven future.

OpenNebula 7.0 “Phoenix” is a stable, production-ready release, available to all users. We encourage you to:
- Review the [Known Issues]({{% relref "known_issues" %}}) before upgrading
- Join our [community forums](https://forum.opennebula.io/) and [GitHub](https://github.com/OpenNebula/one).

We’d like to thank our global community and partners who have helped shape this release, and specailly to those that [support the project]({{% relref "acknowledgements" %}}). OpenNebula is what it is because of your support—keep being awesome!

## OpenNebula Core

- The ability to import wild VMs into OpenNebula has been removed from code to provide a more coherent management experience across all interfaces and APIs.
- Added option [CONTEXT_ALLOW_ETH_UPDATES to oned.conf](../../../product/operation_references/opennebula_services_configuration/oned) to enable updates of VM context `ETH*` values.
- The `enforce` parameter has been restored for the `resize` operation. In this context, it only manages capacity enforcement checks (memory and CPU), while the NUMA topology is always verified independently.
- [Cluster-level quotas](../../../product/cloud_system_administration/capacity_planning/quotas/#compute-quotas), define per-user or per-group resource limits across clusters—especially useful in distributed edge environments. Allow setting per-user or per-group resource limits at the cluster level, enabling precise control over resource consumption across different locations—particularly valuable in distributed edge deployments.
- [Generic quota definitions](../../../product/cloud_system_administration/capacity_planning/quotas/#compute-quotas), track and control usage of custom resources such as vGPUs, licenses, or any administrator-defined metrics.
- [Improve database search queries and performance](https://github.com/OpenNebula/one/issues/5861)
- The Community Edition now includes the `opennebula-migration` package with migrator tools for upgrading from previous versions: [`onedb`]({{% relref "upgrading_single/#step-8-upgrade-the-database-version" %}}) for upgrading the database, [`onecfg`]({{% relref "configuration_management_ee" %}}) for configuration files.


## Monitoring

- [Resource Usage Forecast](../../../product/cloud_system_administration/resource_monitoring/forecast/): Introduces predictive analytics for Host and VM resource consumption, enabling proactive infrastructure management. By analyzing trends in CPU, memory, disk, and network usage, OpenNebula 7.0 supports improved capacity planning, optimized workload scheduling, and early detection of performance bottlenecks.

## Scheduler

- OpenNebula 7.0.0 features a [complete re-write of the scheduling framework](../../../product/cloud_system_administration/scheduler/overview/#opennebula-scheduler-framework-architecture) to easily support multiple scheduling algorithms, and more responsive and reliable execution of scheduling plans.
- [Intelligent DRS](../../../product/cloud_system_administration/scheduler/drs), a full-featured alternative to VMware DRS, including predictive scheduling, customizable policies, and automated VM migrations.

## Storage & Backups

- [Integrated NFS life cycle setup](../../../product/cluster_configuration/storage_system/nas_ds.md#automatic-nfs-setup): simplify the configuration and management of SAN/NFS in shared storage scenarios.
- [Local datastore enhancements](../../../product/cluster_configuration/storage_system/local_ds): streamlined operations for qcow2-based VM disks, featuring a complete backend rewrite for improved maintainability and performance.
- [LVM backend improvements](../../../product/cluster_configuration/storage_system/lvm_drivers/#lvm-thin): introduces support for snapshots, full backups, and various performance optimizations. These enhancements leverage LVM Thin and provide significant improvements over the original LVM-based management.
- [NetApp iSCSI driver](../../../integrations/storage_extensions/netapp): leverages NetApp’s native API for LUN management to deliver maximum performance and optimize operations for VM disks management.
- [Veeam integration](../../../integrations/backup_extensions/veeam/): allows policy-based backup and restore operations directly for OpenNebula-managed VMs through the Veeam console.
- [Full backup support for LVM](../../../product/cluster_configuration/backup_system/overview): adds native data protection options for traditional environments. Enables full backups using native LVM mechanisms. Incremental backup support is planned for a future release to further enhance backup efficiency.

## Sunstone

- Dynamic Tabs to be able to add third party section in Sunstone in an easy way. Learn how in the [Sunstone Development](../../../software/installation_process/build_from_source_code/sunstone_dev.md#sunstone-dev") guide.
- Guacamole VDI over SSH tunnel, described in the [Remote connections guide](../../../product/control_plane_configuration/graphical_user_interface/fireedge_sunstone.md#fireedge-remote-connections).
- Redesigned part of the Sunstone UI, featuring improved accessibility, streamlined navigation, and new data visualization options.
- New cloud view for end users: a dashboard with real-time metrics and quick access to common actions.
- Support for VM Template Profiles with pre-defined deployment settings.
- Add support for labels in Sunstone, including the labels that were set in the old Sunstone UI. See the [Compatibility guide](../compatibility#compatibility-guide-labels).
- New way to render and group user inputs when instantiating an appliance. Check [User Inputs in Sunstone](product/virtual_machines_operation/virtual_machine_definitions/vm_templates/#vm-guide-user-inputs-sunstone).

## API and CLI

- [The `onedb purge-history` command now removes history records only within the specified `–start`, `–end` range for the `–id`, instead of deleting all records](https://github.com/OpenNebula/one/issues/6699).
- The output of `onemarketapp list` list now contains 2 extra columns displaying **HYPERVISOR** and **ARCHITECTURE**.

## KVM & Networking

- [Transparent proxying](../../../product/virtual_machines_operation/virtual_machines_networking/tproxy) allows VMs to access external services like OneGate without requiring complex networking setup.
- [ARM architecture support](../../../product/operation_references/hypervisor_configuration/kvm_driver/#arm64-specifics), including OpenNebula packages and Marketplace appliances for aarch64.
- [OVA import](../../../software/migration_from_vmware/import_ova): a new CLI command, `oneswap`, allows you to ingest VMs in OVA format which were exported directly from VMware vCenter. Stay tuned for Sunstone support!
- Add support for the `SERIAL` disk attribute. This allows you to specify a `SERIAL` value in [Image](../../../product/operation_references/configuration_references/img_template.md) and [VM Templates](../../../product/operation_references/configuration_references/template.md), including support for automatic generation (`auto`).
- Add support for automatic [UEFI firmware selection](../../../product/operation_references/configuration_references/template.md).
- Generate [NUMA-aware PCIe topology](../../../product/cluster_configuration/hosts_and_clusters/numa.md#pci-passthrough) for NUMA pinned virtual machines (``q35`` chipset).


## OpenNebula Flow

- [Oneflow clients include content-type header to make them work with Sinatra 4.0.0](https://github.com/OpenNebula/one/issues/6508).
- [Support for defining Virtual Routers as app roles, simplifying multi-tier deployments](../../../product/virtual_machines_operation/multi-vm_workflows/appflow_use_cli/#defining-the-roles-of-a-service).

## Marketplace

- The [public marketplaces](../../../product/apps-marketplace/public_marketplaces/overview#-overview) appliances generate [scheduling requirements](../../../product/cloud_system_administration/scheduler/overview.md#host-requirements) and [OS configurations](../../../product/operation_references/hypervisor_configuration/kvm_driver#arm64specifics) based on the architecture.


## Features Backported to 6.10.x

Additionally, the following functionalities are present that were not in OpenNebula 6.10.0, although they debuted in subsequent maintenance releases of the 6.10.x series:

- [Add human-readable text for schedule actions to describe the recurring intervals](https://github.com/OpenNebula/one/issues/6410).
- [Added new cli command `onevm snapshot-list`](https://github.com/OpenNebula/one/issues/6623).
- [Add a `disk-snapshot-list` option to `onevm` cli command](../../../product/operation_references/configuration_references/cli.md).
- [Optimize handling of VM history records, greatly improving perfomance of all VM operations for VMs with many history records](https://github.com/OpenNebula/one/issues/2111).
- [Add support for incremental backups in Ceph](https://github.com/OpenNebula/one/issues/6411).
- [New Transparent Proxies for VMs to simplify access to external services (e.g., OneGate)](../../../product/virtual_machines_operation/virtual_machines_networking/tproxy).
- [Add support for VLAN filtering to the Linux bridge drivers](https://github.com/OpenNebula/one/issues/6669). This allows you to limit the VLANs in trunk mode as well as in QinQ mode. For more information check the [bridge driver](../../../product/cluster_configuration/networking_system/bridged) and the [802.1Q VLAN driver](../../../product/cluster_configuration/networking_system/vlan) documentation guides.
- Added support for the new NVIDIA mediated devices framework introduced in Ubuntu 24.04. The legacy method remains unaffected by this new feature. For more details, see the [NVIDIA vGPU documentation](../../../product/cluster_configuration/hosts_and_clusters/vgpu).
- [Added capability to change CPU_MODEL/FEATURES with one.vm.updateconf request](https://github.com/OpenNebula/one/issues/6636).
- [Added support for auto keywork to set NIC virtio queues, same as DISK attribute](https://github.com/OpenNebula/one/issues/6435).
- [Increment_flatten operation is executed using qemu-img commit instead of qemu-img convert](https://github.com/OpenNebula/one/issues/6547).
- [Add support of using defined timezone by oneacct utility with flag `-t`/`--timezone`](https://github.com/OpenNebula/one/issues/821).
- [Limit password size for each authentication driver to prevent DoS attacks](https://github.com/OpenNebula/one/issues/6892).
- [Disable `KEEP_LAST` for incremental backups on CEPH datastores. Support for `KEEP_LAST` will be addressed in future releases](https://github.com/OpenNebula/one/issues/6857).

## Other Issues Solved

- [Fix de-selecting hidden datatable entries](https://github.com/OpenNebula/one/issues/6781).
- [Fix Filter datastore type when deploying a VM](https://github.com/OpenNebula/one/issues/6927).
- [Fix show more labels in cards](https://github.com/OpenNebula/one/issues/6643).
- [Fix host tab does not validate Enable/Disable button states](https://github.com/OpenNebula/one/issues/6792).
- [Fix add qcow2 format support for volatile disk type “swap”](https://github.com/OpenNebula/one/issues/6622).
- [Fix duplicit Scheduled Actions](https://github.com/OpenNebula/one/issues/6996).
- [Fix resource names to not allow special characters `\t`, `\n`, `\v`, `\f`, `\r`](https://github.com/OpenNebula/one/issues/6950).
- [Fix filter flag G exposing resources of other group members for ‘list’ and ‘top’ commands](https://github.com/OpenNebula/one/issues/6952).
- [Fix a bug when Restic passwords include quotes](https://github.com/OpenNebula/one/issues/6666/).
- [Fix onevrouter instantiate command prompts for user input unnecessarily](https://github.com/OpenNebula/one/issues/6948/).
- [Fix user-input option for CLI to support values containing commas and equal signs ](https://github.com/OpenNebula/one/issues/6975/).
- [Fix VM migration not executed on vCenter when src host ID is 0](https://github.com/OpenNebula/one/issues/6997/).
- [Fix VNet instance doesn't update BRIDGE_TYPE, when VN_MAD is updated](https://github.com/OpenNebula/one/issues/6858/).
- [Fix oneacl rules not being cleaned up after removing a group admin](https://github.com/OpenNebula/one/issues/6993/).
- [Fix ability to add and remove existing users to existing groups and change main group from a user](https://github.com/OpenNebula/one/issues/6980/).
- [Fix vGPU profile monitoring for legacy mode](https://github.com/OpenNebula/one/issues/7012/).
- [Fix README.md links to old paths](https://github.com/OpenNebula/one/issues/7032).
- [Fix Restic backup driver when the server is not deployed together with the Front-end](https://github.com/OpenNebula/one/issues/7054).
- [Fix HA in case of wrong SQL query](https://github.com/OpenNebula/one/issues/7025).
- [Fix an issue with `fs_lvm_ssh` not honoring BRIDGE_LIST in the image datastore](https://github.com/OpenNebula/one/issues/7070).
- [Fix cdrom DISK_TYPE=BLOCK during attach](https://github.com/OpenNebula/one/issues/6688).
