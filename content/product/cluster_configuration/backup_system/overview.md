---
title: "Overview"
date: "2025-02-17"
description:
categories:
pageintoc: "77"
tags:
weight: "1"
---

<a id="vm-backups-overview"></a>

<!--# Overview -->

This Chapter contains documentation on how to configure the available backends for [Virtual Machine Backups](../../virtual_machines_operation/virtual_machine_backups/). Backups are managed through the datastore and image abstractions, so all of the concepts that apply to these objects (such as access control or quotas) also apply to backups.

Backup Datastores can be defined using two backends (datastore drivers):

> - restic, based on the [restic backup tool](https://restic.net/)
> - rsync, that uses the [rsync utility](https://rsync.samba.org/) to transfer backup files.

## How Should I Read This Chapter

Before reading this Chapter, you should have already installed your [Frontend]({{% relref "front_end_installation" %}}), the [KVM Hosts]({{% relref "kvm_node_installation#kvm-node" %}}) and have an OpenNebula cloud up and running with at least one virtualization node.

For configuring your backup system, you can first learn how to setup a datastore to save your VM backups, [for the restic backend]({{% relref "restic#vm-backups-restic" %}}) and [for the rsync datastore]({{% relref "rsync#vm-backups-rsync" %}}).

Then, consult the [Virtual Machines Operation]({{% relref "../../virtual_machines_operation/virtual_machine_backups/operations" %}}) section to find out how to perform, schedule and restore VM backups.

Finally, if you need to backup a large number of VMs you can manage them [effectively through Backup Jobs]({{% relref "../../virtual_machines_operation/virtual_machine_backups/backup_jobs" %}}).

## Hypervisor & Storage Compatibility

Performing a VM backup may require some support from the hypervisor or the disk image formats. The following table summarizes the backup modes supported for each hypervisor and storage system.

<!-- Markdown doesn't support merged cells in tables, so as a temporary workaround these are inserted in HTML -->

<table class="docutils align-default">
<thead>
<tr class="row-odd"><th class="head" rowspan="2"><p>Hypervisor</p></th>
<th class="head" rowspan="2"><p>Storage</p></th>
<th class="head" colspan="2"><p>Full</p></th>
<th class="head" colspan="2"><p>Incremental</p></th>
</tr>
<tr class="row-even"><th class="head"><p>Live</p></th>
<th class="head"><p>Power off</p></th>
<th class="head"><p>Live</p></th>
<th class="head"><p>Power off</p></th>
</tr>
</thead>
<tbody>
<tr class="row-odd"><td rowspan="4"><p>KVM</p></td>
<td><p>File<sup>*</sup> (qcow2)</p></td>
<td><p>Yes</p></td>
<td><p>Yes</p></td>
<td><p>Yes</p></td>
<td><p>Yes</p></td>
</tr>
<tr class="row-even"><td><p>File<sup>*</sup> (raw)</p></td>
<td><p>Yes</p></td>
<td><p>Yes</p></td>
<td><p>No</p></td>
<td><p>No</p></td>
</tr>
<tr class="row-odd"><td><p>Ceph</p></td>
<td><p>Yes<sup>†</sup></p></td>
<td><p>Yes<sup>†</sup>
<td><p>Yes<sup>†</sup>
<td><p>Yes<sup>†</sup>
</tr>
<tr class="row-even"><td><p>LVM</p></td>
<td><p>Yes<sup>‡</sup></p></td>
<td><p>Yes</p></td>
<td><p>No</p></td>
<td><p>No</p></td>
</tr>
<tr class="row-odd"><td rowspan="3"><p>LXC</p></td>
<td><p>File (any format)</p></td>
<td><p>No</p></td>
<td><p>Yes</p></td>
<td><p>No</p></td>
<td><p>No</p></td>
</tr>
<tr class="row-even"><td><p>Ceph</p></td>
<td><p>No</p></td>
<td><p>Yes</p></td>
<td><p>No</p></td>
<td><p>No</p></td>
</tr>
<tr class="row-odd"><td><p>LVM</p></td>
<td><p>Yes<sup>‡</sup></p></td>
<td><p>Yes</p></td>
<td><p>No</p></td>
<td><p>No</p></td>
</tr>
</tbody>
</table>

<sup>\*</sup> Any datastore based on files with the given format, i.e. NFS/SAN or Local.

<sup>\*\*</sup> Ceph full/incremental backups are currently stored in a different way, see [backup types]({{% relref "../../virtual_machines_operation/virtual_machine_backups/operations#vm-backups-operations" %}}) for more details.

<sup>†</sup> Live LVM backups only supported in [thin mode]({{% relref "../../../product/cluster_configuration/storage_system/lvm_drivers/#lvm-thin" %}}).
