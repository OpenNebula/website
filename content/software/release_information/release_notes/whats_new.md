---
title: "What's New"
date: "2025-10-06"
description:
categories:
pageintoc: "244"
tags:
weight: "2"
---

<a id="whats-new"></a>

The OpenNebula team is excited to announce the availability of the **OpenNebula 7.2 "Dark Horse"** release! While our previous 7.0 “Phoenix” release focused on the transition from legacy virtualization, OpenNebula 7.2 is engineered for production at scale. This release marks a significant evolution, introducing deeper automation, hardware-rooted security, and the high-performance orchestration required to power modern Sovereign Clouds and AI Factories.

OpenNebula 7.2 is a high-performance engine designed to handle the most demanding enterprise workloads. Key highlights of this release include:

* Optimized infrastructure for AI with advanced orchestration for NVIDIA Fabric Manager (NVLink/NVSwitch), validation for Grace Blackwell (GB200/GB300) systems, and Spectrum-X networking to support large-scale AI training.

* A next-generation gRPC API providing a modern, low-latency API designed for high-throughput communication and improved responsiveness in massive, concurrent environments.

* Improvements in storage performance and efficiency with the introduction of Storage Live Migration between LVM and file-based datastores without downtime, plus a new native driver for Pure Storage FlashArray.

* Enhanced security for confidential computing via hardware-rooted trust and memory encryption in KVM and vTPM support ensuring workload integrity for regulated industries.

* The debut of the new OneForm service for automating unified, on-demand deployment and configuration of distributed OpenNebula Clusters across resources from both on-premises hardware and cloud providers.

* Broadened OS support with official support for the latest enterprise distributions, including AlmaLinux 10, RHEL 10, and Debian 13.

* And much more! Continue reading to find out more details...

{{% if-version is="7.1" %}}
**Please note**: As a beta release, this version is intended for testing and validation purposes only; we do not recommend it for production use at this stage. We encourage you to dive into the new features and help us stabilize the final release by reporting any bugs via [GitHub](https://github.com/OpenNebula/one). We also suggest reviewing the [Known Issues]({{% relref "software/release_information/release_notes/known_issues" %}}) before upgrading.
{{% /if-version %}}

Thank you to our incredible community and partners for your continued support in building the future of open-source cloud orchestration!

## OpenNebula Core
- Introduction of a next-generation [gRPC API]({{% relref "/product/control_plane_configuration/large-scale_deployment/grpc/" %}}) that provides a modern, low-latency communication layer, allowing the platform to handle larger infrastructures and more concurrent operations with ease.
- New [monitor message `EXEC_VM`]({{% relref "/product/cloud_system_administration/resource_monitoring/monitoring_system.md" %}}) to retrieve the result of commands executed inside a Virtual Machine.

## AI Factories
- Integration of the [NVIDIA Fabric Manager (EE)]({{% relref "/product/cluster_configuration/hosts_and_clusters/one_fabricmanager/" %}}) for advanced orchestration for NVSwitch and NVLink high-speed GPU interconnects ensures optimal multi-GPU topologies for AI training and HPC workloads.
- [GPU enhancements]({{% relref "/product/cluster_configuration/hosts_and_clusters/nvidia_gpu_passthrough/" %}}) with official validation on NVIDIA Grace Blackwell GB200 systems, including NVLink/NVSwitch topologies, ensuring seamless orchestration of next-generation GPU-accelerated infrastructure.
- Validated compatibility with NVIDIA Spectrum-X networking platforms, enabling high-performance, low-latency Ethernet fabrics optimized for large-scale AI Clusters.
- Validated integration with NVIDIA BlueField DPUs, enabling network offloading, hardware-level isolation, and enhanced multi-tenant segmentation.

## Storage & Backups
- New redesigned version of [LVM Storage Subsystem (EE)]({{% relref "product/cluster_configuration/lvm/lvm.md" %}}) with native thin-provisioning, unified image and VM disk management, and simplified configuration. The new driver improves performance, reduces deployment complexity, and enables more efficient use of SAN-backed storage by eliminating the need for hybrid file-based setups.
- [Storage Live Migration for LVM & file-based datastores]({{% relref "product/cluster_configuration/storage_system/overview/#storage-portfolio" %}}) with ability to perform live migrations of Virtual Machines across LVM and file-based datastores (both shared, local and lvm thin).
- [NetApp Incremental Backup Support]({{% relref "product/cluster_configuration/san_storage/netapp/" %}}) with improved efficiency for NetApp users with new incremental backup capabilities that reduce backup windows and storage consumption by only saving changed data blocks.
- [Support for Everpure FlashArray]({{% relref "product/cluster_configuration/san_storage/everpure/" %}}) with a native storage driver for managing the full block storage lifecycle directly through the FlashArray REST API.
- [VirtioFS]({{% relref "product/cluster_configuration/storage_system/virtiofs_ds.md" %}}) datastores enable Virtual Machines to directly access Host filesystems, providing fast, low-latency shared file access. This simplifies data sharing across VMs while improving performance for data-intensive workloads.

## Sunstone
- Integrated VM Logs in Sunstone provide real-time VM execution logs directly through the Sunstone GUI, enabling faster troubleshooting without CLI access.
- Backups, images and files tabs added by default in the groupadmin view and a Services Tab has been added by default in the user view.
- [Enforced Two-Factor Authentication (2FA) in Sunstone]({{% relref "/product/cloud_system_administration/authentication_configuration/sunstone_auth/#enforce-globally" %}}) strengthens your cloud security posture by mandating 2FA for all users within the Sunstone GUI through a global security policy.

## API and CLI
- [New API calls]({{% relref "/product/virtual_machines_operation/virtual_machines/vm_instances.md#execute-commands-inside-the-virtual-machine" %}}) (`one.vm.exec`, `one.vm.retryexec` and `one.vm.cancelexec`) to execute commands on a Virtual Machine.
- [Add automatic VM index for multiple persistent VM instantiation]({{% relref "/product/virtual_machines_operation/virtual_machines/vm_instances.md#instantiate-to-persistent" %}}).

## KVM & Networking
- [Virtual Machine memory encryption]({{% relref "/product/virtual_machines_operation/virtual_machines/vm_templates#memory-encryption" %}}) allows VM workloads whose memory cannot be read by the hypervisor.
- [Shared Address Ranges]({{% relref "product/cluster_configuration/networking_system/manage_vnets.md#shared-address-ranges-shared-ar-for-virtual-ips" %}}) with [NIC Alias support]({{% relref "product/cluster_configuration/networking_system/manage_vnets.md#using-virtual-ips" %}}) to enable the assignment of Virtual IPs that can be shared across multiple VMs.
- DPDK `dpdkvhostuserclient` NICs can now be [Hot-plugged]({{% relref "/product/virtual_machines_operation/virtual_machines/vm_instances.md#nic-hot-plugging" %}}).
- `vhost` unix sockets are now created in a dedicated directory - `/var/lib/one/vhost-sockets`.

## LXC
- NIC Hot-plugging, recontextualization and NIC PCI passthrough are now available  as [driver features]({{% relref "/product/operation_references/hypervisor_configuration/lxc_driver.md" %}}).
- [LXC Disk Snapshots]({{% relref "/product/operation_references/hypervisor_configuration/lxc_driver.md" %}}) are now available for the following storage backends: LVM, LVM thin, Ceph RBD, and raw file images.

## OpenNebula Form
- [OneForm Automated Cluster Provisioning]({{% relref "product/cluster_provisioning/overview/" %}}) is a new service designed to automate the creation of OpenNebula Clusters across on-premises environments and cloud providers, simplifying hybrid cloud strategies through unified, on-demand deployment.

## Packaging
- Expanded Operating System Support with official compatibility for SUSE Linux distributions.
- Support for the latest operating systems, including AlmaLinux 10, SUSE Linux Enterprise 16, OpenSUSE, RHEL 10, and Debian 13.
- Sunstone no longer relies on the system-provided Node.js packages, which often varied significantly across supported platforms. OpenNebula now standardizes on Node.js 20 from NodeSource. The required `nodejs` RPM/DEB packages are shipped directly in the OpenNebula repository, eliminating the need for users to configure external NodeSource repositories.

## OpenNebula Apps 7.2.0
The OpenNebula 7.2 release is accompanied by a new version of OneApps. This companion release introduces refreshed base operating systems, improved contextualization packages, and updates across all service appliances to the latest versions. Some of the new features introduced in OpenNebula 7.2 require this OneApps release to ensure full integration. See the [OneApps 7.2.0 release notes for more details](https://github.com/OpenNebula/one-apps/releases/tag/v7.2.0).

## Features Backported to 7.0.x
Additionally, the following functionalities are present that were not included in OpenNebula 7.0.0, although they debuted in subsequent maintenance releases of the 7.0.x series:

- [Add multi-tier caching system for local drivers]({{% relref "product/cluster_configuration/storage_system/local_ds#distributed-cache" %}}).
- [Add support for `BRIDGE_LIST` for Backup Datastores (Restic and rsync) and Ceph drivers]({{% relref "product/cluster_configuration/backup_system/restic#bridge-list" %}}).
- [Add support for incremental backup with LVM Thin]({{% relref "product/cluster_configuration/backup_system/overview/#hypervisor--storage-compatibility" %}}).
- [Add support for incremental backup flatten using Ceph]({{% relref "product/cluster_configuration/backup_system/overview/#hypervisor--storage-compatibility" %}}).
- [Add support for internal snapshots in UEFI VMs]({{% relref "product/operation_references/hypervisor_configuration/kvm_driver.md/#firmware" %}}).
- [Add support for GPU monitoring and forecasting]({{% relref "product/cloud_system_administration/resource_monitoring/metrics.md" %}}).
- [Add support for virtual TPM devices for KVM Virtual Machines]({{% relref "product/virtual_machines_operation/virtual_machines/vm_templates.md#tpm" %}}).
- [Add better onecfg error messages]({{% relref "software/upgrade_process/configuration_management_ee/overview.md" %}}).
- [Add SAML authentication support]({{% relref "product/cloud_system_administration/authentication_configuration/saml.md" %}}). Make sure to follow the [SAML configuration guide]({{% relref "product/cloud_system_administration/authentication_configuration/saml.md#configuration" %}}) and modify the `/etc/one/oned.conf` file, because SAML is not enabled by default in 7.0.1.
- [Add LVM-thin incremental backup to the Veeam integration]({{% relref "product/cluster_configuration/backup_system/veeam.md#compatibility" %}}).
- [Add clearer names for imported marketplace VM images]({{% relref "product/apps-marketplace/managing_marketplaces/marketapps.md#downloading-a-marketplace-appliance-into-your-cloud-or-desktop" %}}).
- [Veeam - ovirtapi server improvements](https://github.com/OpenNebula/one/issues/7356).
- [Add incremental backup support for NetApp driver]({{% relref "product/cluster_configuration/san_storage/netapp/#datastore-internals" %}}).
- [Enhanced VM Compatibility]({{% relref "product/cluster_configuration/hosts_and_clusters/cluster_guide/#enhanced-vm-compatibility-evc" %}}).
- [Expanded OS support for RHEL 10, AlmaLinux 10, and Debian 13](https://docs.opennebula.io/7.0/software/release_information/release_notes_70/platform_notes/).


## Other Issues Solved

- [Fix oned exits with exit(1) on malformed/prematurely closed XML-RPC TCP connection](https://github.com/OpenNebula/one/issues/7476).
- [Fix Sunstone is not able to connect to a vm via SSH](https://github.com/OpenNebula/one/issues/7421).
- [Fix Sunstone PCI selector change to SHORT_ADDRESS](https://github.com/OpenNebula/one/issues/7420).
- [Fix Veeam LVM restore bug](https://github.com/OpenNebula/one/issues/7418).
- [Fix The headers in the tables are not translated in list mode](https://github.com/OpenNebula/one/issues/7357).
- [Fix group names to not allow space in group name](https://github.com/OpenNebula/one/issues/7355).
- [Fix Veeam Incorrect vCPU on appliance](https://github.com/OpenNebula/one/issues/7346).
- [Fix Improve error management on Host detection](https://github.com/OpenNebula/one/issues/7341).
- [Fix Improve error management on missing rbvmomi objects](https://github.com/OpenNebula/one/issues/7340).
- [Fix Prevent from creating incompatible PCIe topologies](https://github.com/OpenNebula/one/issues/7323).
- [Fix quota output for commands `onegroup list` and `oneuser list`](https://github.com/OpenNebula/one/issues/7254).
- [Fix Fireedge not refreshing actions on VM state change](https://github.com/OpenNebula/one/issues/7172).
- [Fix Fireedge fullViewMode can't be enabled by default](https://github.com/OpenNebula/one/issues/7154).
- [Fix Fireedge fullViewMode can't be enabled by default](https://github.com/OpenNebula/one/issues/7348).
- [Fix high CPU utilization caused by prediction](https://github.com/OpenNebula/one/issues/7396).
- [Fix WHMCS client Login action](https://github.com/OpenNebula/one/issues/6879).
- [Fix PCI device assignment mapping to the correct physical NUMA node when pinning is used](https://github.com/OpenNebula/one/issues/7408).
- [Fix missing ETHx_ROUTES attribute in the VM context section](https://github.com/OpenNebula/one/issues/7348).
- [Fix LVM backups not working in Veeam](https://github.com/OpenNebula/one/issues/7418).
- [Fix Update AR not working with the CLI](https://github.com/OpenNebula/one/issues/7455).
- [Fix parsing of group names to not allow spaces](https://github.com/OpenNebula/one/issues/7355).
- [Fix `onedb fsck` for Virtual Router leases](https://github.com/OpenNebula/one/issues/7428).
- [Fix quota output for commands `onegroup list` and `oneuser list`](https://github.com/OpenNebula/one/issues/7254).
- [Fix Veeam only working with default datastore path](https://github.com/OpenNebula/one/issues/7470).
- [Fix `onedb fsck` returns non-zero exit code in case of issues in DB](https://github.com/OpenNebula/one/issues/6995).
- [Fix `onedb fsck` for Virtual Router leases](https://github.com/OpenNebula/one/issues/7428).
- [Fix Improve Scheduler log message when a VM is not scheduled](https://github.com/OpenNebula/one/issues/7494).
- [Fix FQDN support in Prometheus datasource script](https://github.com/OpenNebula/one/issues/7512).
- [Fix OneDRS scheduler for VMs with resched flag](https://github.com/OpenNebula/one/issues/7503).
- [Fix Conversion failed with message Unable to find Host, Cluster, and Datacenter of VM](https://github.com/OpenNebula/one/issues/7533).
- [Fix `BRIDGE_LIST` in backup datastores.](https://github.com/OpenNebula/one/issues/7532)
- [USER_INPUT variable expansion not applied in SCHED_REQUIREMENTS when instantiating via FireEdge.](https://github.com/OpenNebula/one/issues/7491)
