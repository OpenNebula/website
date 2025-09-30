---
title: "Resolved Issues in 7.0.1"
---

<a id="resolved-issues-701"></a>

<!--# Resolved Issues 7.0.1 -->

A complete list of solved issues for 7.0.1 can be found in the [project development portal](https://github.com/OpenNebula/one/milestone/72).

The following new features have been backported to 7.0.1:

- [Add multi-tier caching system for local drivers](../../../product/cluster_configuration/storage_system/local_ds#distributed-cache)
- [Add support for `BRIDGE_LIST` for Backup Datastores (Restic and rsync) and Ceph drivers](../../../product/cluster_configuration/backup_system/restic#bridge-list)
- [Add support for incremental backup with LVM Thin](../../../product/cluster_configuration/backup_system/overview/#hypervisor--storage-compatibility)
- [Add support for incremental backup flatten using Ceph](../../../product/cluster_configuration/backup_system/overview/#hypervisor--storage-compatibility)
- [Add support for internal snapshots in UEFI VMs](../../../product/operation_references/hypervisor_configuration/kvm_driver.md/#firmware)
- [Add support for GPU monitoring and forecasting](../../../product/cloud_system_administration/resource_monitoring/metrics.md)
- [Add support for virtual TPM devices for KVM virtual machines](../../../product/virtual_machines_operation/virtual_machine_definitions/vm_templates.md#tpm)
- [Add better onecfg error messages](../../../software/upgrade_process/configuration_management_ee/overview.md)

The following issues has been solved in 7.0.1:

- Fix rename 'Edit' button to 'Rename' to change a VM disk snapshot name [#6803](https://github.com/OpenNebula/one/issues/6803)
- Fix validation issue during Group + Group Admin creation at the same time [#6873](https://github.com/OpenNebula/one/issues/6873)
- Fix removes sensitive information from FireEdge logs [#7106](https://github.com/OpenNebula/one/issues/7106)
- Fix netApp: Implemented volume autogrow/shrink so if snapshots exceed their reserve percentage, the volume is expanded
- Fix netApp: Volumes are expanded by snapshot reserve percentage to avoid space issues
- Fix opennebula-ovirtapi: Adds the ability to backup volatile disks [#7148](https://github.com/OpenNebula/one/issues/7148)
- Fix opennebula-ovirtapi: Keeps VM ownership after restore [#7147](https://github.com/OpenNebula/one/issues/7147)
- Fix opennebula-ovirtapi: Add support for multi-process running [#7220](https://github.com/OpenNebula/one/issues/7220)
- Fix Windows Optimized OS Profile [#7146](https://github.com/OpenNebula/one/issues/7146)
- Fix select image validation message [#7139](https://github.com/OpenNebula/one/issues/7139)
- Fix OneDRS for non-consistent input parameters and weights [#7161](https://github.com/OpenNebula/one/issues/7161)
- Fix listing of CPU models for KVM hosts to only list supported models [#7081](https://github.com/OpenNebula/one/issues/7081)
- Fix timeout for datastore actions (honor -w DS_MAD option) [#7076](https://github.com/OpenNebula/one/issues/7076)
- Fix 'Download Default Virtual Router Image' modal [#7138](https://github.com/OpenNebula/one/issues/7138)
- Fix user_inputs order not considered when instantiating a template through the CLI [#7041](https://github.com/OpenNebula/one/issues/7041)
- Fix the `kvmrc` configuration file parser that was preventing more than one parameter [#7069](https://github.com/OpenNebula/one/issues/7069)
- Fix react crash when accessing increments sub tab for a backup image [#7173](https://github.com/OpenNebula/one/issues/7173)
- Fix Sunstone should prioritize user views [#7082](https://github.com/OpenNebula/one/issues/7082)
- Fix OpenvSwitch.rb VXLAN failure add-port already exists on bridge [#7059] (https://github.com/OpenNebula/one/issues/7059)
- Fix Extend details tab [#7152](https://github.com/OpenNebula/one/issues/7152)
- Fix Don't let add the ssh key more than one time [#7140](https://github.com/OpenNebula/one/issues/7140)
- Fix Datastore handling by DRS scheduler in some scenarios [#7176](https://github.com/OpenNebula/one/issues/7176)
- Fix Sunstone Update VM Configuration wizard doesn't scale correctly [#7062](https://github.com/OpenNebula/one/issues/7062)
- Fix Style bug with Disable animations switch [#7136](https://github.com/OpenNebula/one/issues/7136)
- Fix OneDRS storage requirements computation for VMs without history records [#7194](https://github.com/OpenNebula/one/issues/7194)
- Fix VIRTIO_QUEUES not applying to hot plugged virtio NICs [#7195](https://github.com/OpenNebula/one/issues/7195)
- Fix upgrade for iconoir-react library [#6422](https://github.com/OpenNebula/one/issues/6422)
- Fix performance issue in DRS scheduler [#7211](https://github.com/OpenNebula/one/issues/7211)
- Fix race condition when monitor probes update VM status [#7058](https://github.com/OpenNebula/one/issues/7058)
- Fix way back to tables when creating and updating resources [#7131](https://github.com/OpenNebula/one/issues/7131)
- Fix iptables flags to not use unsupported options (based on iptables version) [#7215](https://github.com/OpenNebula/one/issues/7215)
- Fix Ethernet text on Address Ranges when create VMs [#6955](https://github.com/OpenNebula/one/issues/6955)
- Fix `Host not permitted` error on Sinatra server when is behind from NGINX proxy [#7231](https://github.com/OpenNebula/one/issues/7231)
- Fix ownership issue when instantiate VM as a different user [#7013](https://github.com/OpenNebula/one/issues/7013)
- Fix re-arrange time orders when adding a scheduled action in Creating VMs [#7031](https://github.com/OpenNebula/one/issues/7031)
- Fix translation text when creating VMs [#7222](https://github.com/OpenNebula/one/issues/7222)
- Fix duplicated NICs during OneFlow service creation [#7192](https://github.com/OpenNebula/one/issues/7192)
- Fix opennebula-ovirtapi: Add LVM-thin incremental backup to the Veeam integration [#7236](https://github.com/OpenNebula/one/issues/7236)
- Fix fsck to update history ETIME using EETIME or RETIME [#7250](https://github.com/OpenNebula/one/issues/7250)
- Fix VM placement expression parsing in Sunstone [#7158](https://github.com/OpenNebula/one/issues/7158)
- Fix physical CPU tooltip in Sunstone [#6867](https://github.com/OpenNebula/one/issues/6867)
- Fix update a VM configuration removes some attributes [#6987](https://github.com/OpenNebula/one/issues/6987)
- Fix remove tmp files after creating Image [#7252](https://github.com/OpenNebula/one/issues/7252)
- Fix prometheus patch_datasources.rb ipv6 addresses handling [#7107](https://github.com/OpenNebula/one/issues/7107)
- Fix OneGate server error output [#7251](https://github.com/OpenNebula/one/issues/7251)
