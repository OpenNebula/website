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

The following issues has been solved in 7.0.1:

- Fix rename 'Edit' button to 'Rename' to change a VM disk snapshot name [#6803](https://github.com/OpenNebula/one/issues/6803)
- Fix validation issue during Group + Group Admin creation at the same time [#6873](https://github.com/OpenNebula/one/issues/6873)
- Fix removes sensitive information from FireEdge logs [#7106](https://github.com/OpenNebula/one/issues/7106)
- Fix netApp: Implemented volume autogrow/shrink so if snapshots exceed their reserve percentage, the volume is expanded
- Fix netApp: Volumes are expanded by snapshot reserve percentage to avoid space issues
- Fix opennebula-ovirtapi: Adds the ability to backup volatile disks [#7148](https://github.com/OpenNebula/one/issues/7148)
- Fix opennebula-ovirtapi: Keeps VM ownership after restore [#7147](https://github.com/OpenNebula/one/issues/7147)
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
- Fix Datastore handling by DRS scheduler in some scenarios [#7176](https://github.com/OpenNebula/one/issues/7176)
