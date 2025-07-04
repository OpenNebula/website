---
title: "Storage Driver"
date: "2025-02-17"
description:
categories:
pageintoc: "293"
tags:
weight: "3"
---

<a id="sd"></a>

<!--# Storage Driver -->

The Storage subsystem is highly modular. These drivers are separated into two logical sets:

- **DS**: Datastore drivers. They serve the purpose of managing images: register, delete, and create empty datablocks.
- **TM**: Transfer Manager drivers. They manage images associated with instantiated VMs.

## Datastore Drivers Structure

Located under `/var/lib/one/remotes/datastore/<ds_mad>`

- **cp**: copies/dumps the image to the datastore
  - **ARGUMENTS**: `image_id`
  - **STDIN**: `datastore_image_dump`
  - **RETURNS**: `image_source image_format`
  - `datastore_image_dump` is an XML dump of the driver action encoded in Base 64. See a decoded [example]({{% relref "#sd-dump" %}}).
  - `image_source` is the image source which will be later sent to the transfer manager.
- **mkfs**: creates a new empty image in the datastore
  - **ARGUMENTS**: `image_id`
  - **STDIN**: `datastore_image_dump`
  - **RETURNS**: `image_source`
  - `datastore_image_dump` is an XML dump of the driver action encoded in Base 64. See a decoded [example]({{% relref "#sd-dump" %}}).
  - `image_source` is the image source which will be later sent to the transfer manager.
- **rm**: removes an image from the datastore
  - **ARGUMENTS**: `image_id`
  - **STDIN**: `datastore_image_dump`
  - **RETURNS**: `-`
  - `datastore_image_dump` is an XML dump of the driver action encoded in Base 64. See a decoded [example]({{% relref "#sd-dump" %}}).
- **stat**: returns the size of an image in Mb
  - **ARGUMENTS**: `image_id`
  - **STDIN**: `datastore_image_dump`
  - **RETURNS**: `size`
  - `datastore_image_dump` is an XML dump of the driver action encoded in Base 64. See a decoded [example]({{% relref "#sd-dump" %}}).
  - `size` the size of the image in Mb.

<a id="clone"></a>
- **clone**: clones an image
  - **ARGUMENTS**: `image_id`
  - **STDIN**: `datastore_image_dump`
  - **RETURNS**: `source`
  - `datastore_image_dump` is an XML dump of the driver action encoded in Base 64. See a decoded [example]({{% relref "#sd-dump" %}}).
  - `source` the new `source` for the image.
- **monitor**: monitors a datastore
  - **ARGUMENTS**: `image_id`
  - **STDIN**: `datastore_image_dump`
  - **RETURNS**: `monitor data`
  - `datastore_image_dump` is an XML dump of the driver action encoded in Base 64. See a decoded [example]({{% relref "#sd-dump" %}}).
  - `monitor data` The monitoring information of the datastore, namely “USED_MB=…\\nTOTAL_MB=…\\nFREE_MB=…” which are the used size of the datastore in MB, the total capacity of the datastore in MB and the available space in the datastore in MB, respectively.
- **snap_delete**: Deletes a snapshot of a persistent image
  - **ARGUMENTS**: `image_id`
  - **STDIN**: `datastore_image_dump`
  - **RETURNS**: `-`
  - `datastore_image_dump` is an XML dump of the driver action encoded in Base 64. See a decoded [example]({{% relref "#sd-dump" %}}). This dump, in addition to the elements in the example, contains a ROOT element: `TARGET_SNAPSHOT`, with the ID of the snapshot.
- **snap_flatten**: Flattens a snapshot. The operation results in an image without snapshots, with the contents of the selected snapshot.
  - **ARGUMENTS**: `image_id`
  - **STDIN**: `datastore_image_dump`
  - **RETURNS**: `-`
  - `datastore_image_dump` is an XML dump of the driver action encoded in Base 64. See a decoded [example]({{% relref "#sd-dump" %}}). This dump, in addition to the elements in the example, contains a ROOT element: `TARGET_SNAPSHOT`, with the ID of the snapshot.
- **snap_revert**: Overwrites the contents of the image by the selected snapshot (discarding any unsaved changes)
  - **ARGUMENTS**: `image_id`
  - **STDIN**: `datastore_image_dump`
  - **RETURNS**: `-`
  - `datastore_image_dump` is an XML dump of the driver action encoded in Base 64. See a decoded [example]({{% relref "#sd-dump" %}}). This dump, in addition to the elements in the example, contains a ROOT element: `TARGET_SNAPSHOT`, with the ID of the snapshot.
- **increment_flatten**: Flattens one or several snapshots. The operation results in a shortened chain of snapshots, committing from the beginning to only preserve the amount specified by KEEP_LAST
  - **ARGUMENTS**: `image_id`
  - **STDIN**: `datastore_image_dump`
  - **RETURNS**: `size chain`
  - `datastore_image_dump` is an XML dump of the driver action encoded in Base 64. See a decoded [example]({{% relref "#sd-dump" %}}). This dump, in addition to the elements in the example, contains a ROOT element: `TARGET_SNAPSHOT`, with the ID of the snapshot.
  - `size` the size in MB.
  - `chain` chain spec in format <base_id>:<base_hash>[,<inc_id>:<inc_hash>]\*.
- **export**: Generates an XML file required to export an image from a datastore. This script represents only the first part of the export process, it only generates metadata (an xml). The information returned by this script is then fed to `downloader.sh` which completes the export process
  - **ARGUMENTS**: `image_id`
  - **STDIN**: `datastore_image_dump`
  - **RETURNS**: `export_xml`
  - `datastore_image_dump` is an XML dump of the driver action encoded in Base 64. See a decoded [example]({{% relref "#sd-dump" %}}). This dump, in addition to the elements in the example, contains a ROOT element: `TARGET_SNAPSHOT`, with the ID of the snapshot.
  - `export_xml`: The XML response should follow [this]({{% relref "#sd-export" %}}) structure. The variables that appear within are the following:
    > - `<src>`: The SOURCE of the image (path to the image in the datastore)
    > - `<md5>`: The MD5 of the image
    > - `<format>`: The format of the image, e.g.: `qcow2`, `raw`, `vmdk`, `unknown`…
    > - `<dispose>`: Can be either `YES` or `NO`. Dispose will remove the image from the reported path after the image has been successfully exported. This is regularly not necessary if the `downloader.sh` script can access the path to the image directly in the datastore (`src`).

{{< alert title="Note" color="success" >}}
`image_source` has to be dynamically generated by the `cp` and `mkfs` script. It will be passed later on to the transfer manager, so it should provide all the information the transfer manager needs to locate the image.{{< /alert >}} 

### Backup Datastore Operations

The backup datastore drivers are responsible for storing the generate `backup` folder into the backup system and for restoring disk images from existing backups. Two specific operations need to be implemented for this datastore type:

- **backup**: Uploads the contents of the `remote_system_ds/<vm_id>/backup` folder to the backup storage
  - **ARGUMENTS**: `host:remote_system_ds disks deploy_id vm_id ds_id`
  - `remote_system_ds_dir` is the path for the VM directory in the system datastore in the Host
  - `host` is the target Host where the VM is running
  - `disks` List (‘:’ separated) of disk_ids  of disks that needs backup (e.g., “0:1:”)
  - `deploy_id` ID of the VM in the hypervisor
  - `backupjob_id` if defined ‘-’ otherwise
  - `vm_id` is the id of the VM
  - `ds_id` is the target datastore (the system datastore)
  - **STDIN**: `datastore_backup_dump` See an [example]({{% relref "#ds-backup-dump" %}}).
  - **RETURNS**: `backup_id size_mb format`
  - `backup_id` driver reference for the backup
  - `size_mb` size that the backup takes
  - `format` value of the backup image’s FORMAT attribute (values: raw, rbd)
- **restore**: Restore the OpenNebula objects (VM Template and Images). Note that the actual download of the images will be made by the Image Datastore using the reference uri. The specific mechanism for download images of a given protocol is coded in the `downloader.sh` script. The pseudo-URL takes the form: `<backup_proto>://<datastore_id>/<backup_job_id>/<driver_snapshot_id_chain>/<disk filename>` (example: `restic://100/23/0:25f4b298,1:6968545c//var/lib/one/datastores/0/0/backup/disk.0`, the backup job id can be empty):
  - **ARGUMENTS**: `datastore_action_dump image_id`
  - **RETURNS**: `Template_ID Image_ID1 Image_ID2 ...`
- **ls**: Lists the disk backups included in a given backup together with a downloader URL. The action receives the increment ID as a parameter and the information of the backup image, datastore and VM as XML through standard input.
  - **ARGUMENTS**: `-i <increment_id>` to select a specific increment to restore use -1 for last increment or full backups
  - **STDIN**: An XML document with the VM, backup Image and Datastore object information, in the form:

```default
<DS_DRIVER_ACTION_DATA>
  <VM>...</VM>
  <DATASTORE>...</DATASTORE>
  <IMAGE>...</IMAGE>
</DS_DRIVER_ACTION_DATA>
```

- **RETURNS**: A JSON document that includes for each disk a downloader URL. This URL is then used by the restore scripts to get the VM disk backups:

```default
{
  "0": "rsync://102//0:0e6658/var/lib/one/datastores/102/21/0e6658/disk.0.0"
}
```

The following actions also need to be implemented (see above):

- **monitor**: Returns the storage space of the backup system.
- **rm**: To remove existing backups from the repository.
- **stat**: Should return the size a disk image will take once restored from the backup.

<a id="sd-tm"></a>

## TM Drivers Structure

This is a list of the TM drivers and their actions. Note that they don’t return anything. If the exit code is not `0`, the driver failed.

Located under `/var/lib/one/remotes/tm/<tm_mad>`. There are two types of action scripts: the first group applies to general image datastores and includes (`clone`, `ln`, `mv` and `mvds`); the second one is only used in conjunction with the system datastore.

Action scripts for generic image datastores:

- **clone**: clones the image from the datastore (non-persistent images)
  - **ARGUMENTS**: `fe:SOURCE host:remote_system_ds/disk.i vm_id ds_id`
  - `fe` is the Front-end hostname
  - `SOURCE` is the path of the disk image in the form DS_BASE_PATH/disk
  - `host` is the target Host to deploy the VM
  - `remote_system_ds` is the path for the system datastore in the Host
  - `vm_id` is the id of the VM
  - `ds_id` is the source datastore (the images datastore)
- **ln**: Links the image from the datastore (persistent images)
  - **ARGUMENTS**: `fe:SOURCE host:remote_system_ds/disk.i vm_id ds_id`
  - `fe` is the Front-end hostname
  - `SOURCE` is the path of the disk image in the form DS_BASE_PATH/disk
  - `host` is the target Host to deploy the VM
  - `remote_system_ds` is the path for the system datastore in the Host
  - `vm_id` is the id of the VM
  - `ds_id` is the source datastore (the images datastore)
- **mvds**: moves an image back to its datastore (persistent images)
  - **ARGUMENTS**: `host:remote_system_ds/disk.i fe:SOURCE vm_id ds_id`
  - `fe` is the Front-end hostname
  - `SOURCE` is the path of the disk image in the form DS_BASE_PATH/disk
  - `host` is the target Host to deploy the VM
  - `remote_system_ds` is the path for the system datastore in the Host
  - `vm_id` is the id of the VM
  - `ds_id` is the target datastore (the original datastore for the image)
- **cpds**: copies an image back to its datastore (executed for the saveas operation)
  - **ARGUMENTS**: `host:remote_system_ds/disk.i fe:SOURCE snap_id vm_id ds_id`
  - `fe` is the Front-end hostname
  - `SOURCE` is the path of the disk image in the form DS_BASE_PATH/disk
  - `host` is the target Host to deploy the VM
  - `remote_system_ds` is the path for the system datastore in the Host
  - `snap_id` the ID of the snapshot to save. If the ID is -1 it saves the current state and not a snapshot.
  - `vm_id` is the id of the VM
  - `ds_id` is the target datastore (the original datastore for the image)
- **mv**: moves images/directories across system_ds in different Hosts. When used for the system datastore the script will receive the directory ARGUMENT. This script will be also called for the image TM for each disk to perform setup tasks on the target node.
  - **ARGUMENTS**: `hostA:system_ds/disk.i|hostB:system_ds/disk.i vm_id ds_id` OR `hostA:system_ds/|hostB:system_ds/ vm_id ds_id`
  - `hostA` is the Host the VM is in.
  - `hostB` is the target Host to deploy the VM
  - `system_ds` is the path for the system datastore in the host
  - `vm_id` is the id of the VM
  - `ds_id` is the target datastore (the system datastore)

{{< alert title="Note" color="success" >}}
You only need to implement one `mv` script, but consider the arguments received when the TM is used for the system datastore, a regular image datastore, or both.{{< /alert >}} 

- **premigrate**: It is executed before a livemigration operation is issued to the hypervisor. Note that **only the premigrate script from the system datastore will be used**. Any customization must be done for the premigrate script of the system datastore, although you will probably add operations for other backends than that used by the system datastore.
  - Base64 encoded VM XML is sent via stdin.
  - **ARGUMENTS**: `source_host dst_host remote_system_dir vmid dsid`
  - `src_host` is the Host the VM is in.
  - `dst_host` is the target Host to migrate the VM to
  - `remote_system_ds_dir` is the path for the VM directory in the system datastore in the Host
  - `vmid` is the id of the VM
  - `dsid` is the target datastore
- **failmigrate**: It is executed after a failure in the livemigration operation. Note that **save the postmigrate script from the system datastore will be used**. This action should revert any operation made by the premigrate script, for example removing any file transferred to the destination as it will not be used. The default operation does not perform any action and should be adjust accordingly to the custom premigrate operation.
  - Base64 encoded VM XML is sent via stdin.
  - **ARGUMENTS**: `source_host dst_host remote_system_dir vmid dsid`
  - see `premigrate` description.
- **postmigrate**: It is executed after a livemigration operation. Note that **only the postmigrate script from the system datastore will be used**. Any customization must be done for the postmigrate script of the system datastore, although you will probably add operations for other backends than that used by the system datastore. Base64 encoded VM XML is sent via stdin.
  - Base64 encoded VM XML is sent via stdin.
  - **ARGUMENTS**: `source_host dst_host remote_system_dir vmid dsid`
  - see `premigrate` description.
- **snap_create**: Creates a disk snapshot of the selected disk
  - **ARGUMENTS**: `host:remote_system_ds/disk.i snapshot_id vm_id ds_id`
  - `remote_system_ds_dir` is the path for the VM directory in the system datastore in the Host
  - `host` is the target Host where the VM is running
  - `snapshot_id` the id of the snapshot to be created/reverted to/deleted
  - `vm_id` is the id of the VM
  - `ds_id` is the target datastore (the system datastore)
- **snap_create_live**: Creates a disk snapshot of the selected disk while the VM is running in the hypervisor. This is a hypervisor operation.
  - **ARGUMENTS**: `host:remote_system_ds/disk.i snapshot_id vm_id ds_id`
  - `remote_system_ds_dir` is the path for the VM directory in the system datastore in the Host
  - `host` is the target Host where the VM is running
  - `snapshot_id` the id of the snapshot to be created/reverted to/deleted
  - `vm_id` is the id of the VM
  - `ds_id` is the target datastore (the system datastore)
- **snap_delete**: Deletes a disk snapshot
  - **ARGUMENTS**: `host:remote_system_ds/disk.i snapshot_id vm_id ds_id`
  - see `snap_create` description.
- **snap_revert**: Reverts to the selected snapshot (and discards any changes to the current disk)
  - **ARGUMENTS**:  `host:remote_system_ds/disk.i snapshot_id vm_id ds_id`
  - see `snap_create` description.

Action scripts needed when the TM is used for the system datastore:

- **context**: creates an ISO that contains all the files passed as an argument.
  - **ARGUMENTS**: `file1 file2 ... fileN host:remote_system_ds/disk.i vm_id ds_id`
  - `host` is the target Host to deploy the VM
  - `remote_system_ds` is the path for the system datastore in the Host
  - `vm_id` is the id of the VM
  - `ds_id` is the target datastore (the system datastore)
- **delete**: removes the either system datastore’s directory of the VM or a disk itself.
  - **ARGUMENTS**: `host:remote_system_ds/disk.i|host:remote_system_ds/ vm_id ds_id`
  - `host` is the target Host to deploy the VM
  - `remote_system_ds` is the path for the system datastore in the Host
  - `vm_id` is the id of the VM
  - `ds_id` is the source datastore (the images datastore) for normal disks or target datastore (the system datastore) for volatile disks
- **mkimage**: creates an image on-the-fly bypassing the datastore/image workflow
  - **ARGUMENTS**: `size format host:remote_system_ds/disk.i vm_id ds_id`
  - `size` size in MB of the image
  - `format` format for the image
  - `host` is the target Host to deploy the VM
  - `remote_system_ds` is the path for the system datastore in the Host
  - `vm_id` is the id of the VM
  - `ds_id` is the target datastore (the system datastore)
- **mkswap**: creates a swap image
  - **ARGUMENTS**: `size host:remote_system_ds/disk.i vm_id ds_id`
  - `size` size in MB of the image
  - `host` is the target Host to deploy the VM
  - `remote_system_ds` is the path for the system datastore in the Host
  - `vm_id` is the id of the VM
  - `ds_id` is the target datastore (the system datastore)
- **monitor**: monitors a **shared** system datastore. Sends `monitor VMs data` to Monitor Daemon. Non-shared system datastores are monitored through `monitor_ds` script.
  - **ARGUMENTS**: `image_id`
  - **STDIN**: `datastore_image_dump`
  - **RETURNS**: `monitor data`
  - `datastore_image_dump` is an XML dump of the driver action encoded in Base 64. See a decoded [example]({{% relref "#sd-dump" %}}).
  - `monitor data` The monitoring information of the datastore, namely “USED_MB=…\\nTOTAL_MB=…\\nFREE_MB=…” which are respectively the used size of the datastore in MB, the total capacity of the datastore in MB and the available space in the datastore in MB.
  - `monitor VMs data` For each VM the size of each disk and any snapshot on those disks. This data is sent by UDP to Monitor Daemon. The MONITOR parameter is encoded in base64 format. Decoded example:

```default
VM = [ ID = ${vm_id}, MONITOR = "\
    DISK_SIZE=[ID=${disk_id},SIZE=${disk_size}]
    ...
    SNAPSHOT_SIZE=[ID=${snap},DISK_ID=${disk_id},SIZE=${snap_size}]
    ...
    "
]
...
```

- **monitor_ds**: monitors a **local-like** system datastore. Distributed system datastores should `exit 0` on the previous monitor script. Arguments and return values are the same as the monitor script.
- **pre_backup** and **pre_backup_live**: These actions needs to generate disk backup images, as well as the VM XML representation in the folder `remote_system_ds/backup`. Each disk is created in the form `disk.<disk_id>.<increment_id>`. The VM representation is stored in a file named `vm.xml`. The live version needs to pause/snapshot the VM to create consistent backup images.
  - **ARGUMENTS**: `host:remote_system_ds disks deploy_id vm_id ds_id`
  - `remote_system_ds_dir` is the path for the VM directory in the system datastore in the Host
  - `host` is the target Host where the VM is running
  - `disks` List (‘:’ separated) of disk_ids  of disks that needs backup (e.g. “0:1:”)
  - `deploy_id` ID of the VM in the hypervisor
  - `backupjob_id` is the id of the Backup job (‘-’ if undefined)
  - `vm_id` is the id of the VM
  - `ds_id` is the target datastore (the system datastore)
- **post_backup** and **post_backup_live**: These actions performs cleanup operations of any tmp folder as well as the `backup` folder. The live version also needs to commit or pivot VMs disks to the original ones.
  - **ARGUMENTS**: `host:remote_system_ds disks deploy_id vm_id ds_id`
  - `remote_system_ds_dir` is the path for the VM directory in the system datastore in the Host
  - `host` is the target Host where the VM is running
  - `disks` List (‘:’ separated) of disk_ids  of disks that needs backup (e.g. “0:1:”)
  - `deploy_id` ID of the VM in the hypervisor
  - `backupjob_id` is the id of the Backup job (‘-’ if undefined)
  - `vm_id` is the id of the VM
  - `ds_id` is the target datastore (the system datastore)
- **restore**: Restores VM disks from a backup. This script will access the `ls` operation of the associated datastore to get a list of VM disks and their downloader pseudo-URLs. The downloader script is then used to get the disk images from the backup and replace the VM disks. The VM is in poweroff state.
  > - **ARGUMENTS**: `host:remote_system_ds vm_id img_id inc_id disk_id`
  > - `remote_system_ds_dir` is the path for the VM directory in the system datastore in the Host
  > - `host` is the target Host where the VM is running
  > - `vm_id` is the id of the VM
  > - `img_id` is the id of the image backup to restore
  > - `inc_id` ID of the increment to use, -1 will select the last increment or for full backups
  > - `disk_id` is the id of the disk to restore, -1 will restore all available disks

{{< alert title="Note" color="success" >}}
If the TM is only for regular images you only need to implement the first group.{{< /alert >}} 

<a id="ds-monitor"></a>

## Tuning OpenNebula Core and Driver Integration

The behavior of OpenNebula can be adapted depending on how the storage performs the underlying operations. For example quotas are computed on the original image datastore depending on the CLONE attribute. In particular, you may want to set two configuration attributes for your drivers: `DS_MAD_CONF` and `TM_MAD_CONF`. See [the OpenNebula configuration reference]({{% relref "../../../product/operation_references/opennebula_services_configuration/oned#oned-conf-transfer-driver" %}}) for details.

## The Monitoring Process

### Image Datastores

The information is obtained periodically using the Datastore driver monitor script

### Shared System Datastores

These datastores are monitored from a single point once (either the Front-end or one of the storage bridges in `BRIDGE_LIST`). This will prevent overloading the storage by all the nodes querying it at the same time.

The driver plugin `<tm_mad>/monitor` will report the information for two things:

- Total storage metrics for the datastore (`USED_MB` `FREE_MB` `TOTAL_MB`)
- Disk usage metrics (all disks: volatile, persistent, and non-persistent)

### Local System Datastores (SSH-like)

Local datastores are labeled by including a `.monitor` file in the datastore directory in any of the clone or ln operations. Only those datastores are monitored remotely by the monitor_ds.sh probe. The datastore is monitored with `<tm_mad>/monitor_ds`, but `tm_mad` is obtained by the probes reading from the .monitor file.

The plugins <tm_mad>/monitor_ds + kvm-probes.d/monitor_ds.sh will report the information for two things:

- Total storage metrics for the datastore (`USED_MB` `FREE_MB` `TOTAL_MB`)
- Disk usage metrics (all disks volatile, persistent, and non-persistent)

{{< alert title="Note" color="success" >}}
`.monitor` will only be present in Local datastores to be monitored in the nodes.  System Datastores that need to be monitored in the nodes will need to provide a `monitor_ds` script and not the `monitor` one. This is to prevent errors and not to invoke the shared mechanism for local datastores.{{< /alert >}} 

### The monitor_ds script.

The monitor_ds.sh probe from the IM, if the `.monitor` file is present (e.g., `/var/lib/one/datastores/100/.monitor`), will execute its contents in the form `/var/tmp/one/remotes/tm/$(cat .monitor)/monitor_ds /var/lib/one/datastores/100/`. Note that the argument is the datastore path and not the VM or VM disk.

The script is responsible for getting the information from all disks of all VMs in the datastore in that node.

<a id="mixed-tm-modes"></a>

## Mixed Transfer modes

Certain types of TM can be used in so called *mixed mode* and allow different types of image and system datastore drivers to work together.

The following combinations are supported by default:

- **CEPH** + **SSH** described in [Ceph SSH mode]({{% relref "../../../product/cluster_configuration/storage_system/ceph_ds#ceph-ssh-mode" %}})
- **Qcow2/shared** + **SSH** described in [Qcow2/shared SSH mode]({{% relref "../../../product/cluster_configuration/storage_system/nas_ds#shared-ssh-mode" %}})

The support in oned is generic, in a *mixed mode* every TM action (such as `clone` or `delete`) is suffixed with the driver name of the system DS in use. For example, an action like `clone.ssh` is actually invoked in CEPH + SSH mode. The driver first tries to find the complete action script, including the system DS suffix (e.g., `ceph/clone.ssh`), and only if that does not exist falls back to the default (`ceph/clone`).

In this way other combinations can be easily added.

## An Example VM

Consider a VM with two disks:

```default
NAME   = vm01
CPU    = 0.1
MEMORY = 64

DISK   = [ IMAGE_ID = 0 ] # non-persistent disk
DISK   = [ IMAGE_ID = 1 ] # persistent disk
```

This a list of TM actions that will be called upon the events listed:

**CREATE**

```default
<tm_mad>/clone <frontend>:<non_pers_image_source> <host01>:<ds_path>/<vm_id>/disk.0
<tm_mad>/ln <frontend>:<pers_image_source> <host01>:<ds_path>/<vm_id>/disk.1
```

**STOP**

```default
<tm_mad>/mv <host01>:<ds_path>/<vm_id>/disk.0 <frontend>:<ds_path>/<vm_id>/disk.0
<tm_mad>/mv <host01>:<ds_path>/<vm_id>/disk.1 <frontend>:<ds_path>/<vm_id>/disk.1
<tm_mad_sysds>/mv <host01>:<ds_path>/<vm_id> <frontend>:<ds_path>/<vm_id>
```

**RESUME**

```default
<tm_mad>/mv <frontend>:<ds_path>/<vm_id>/disk.0 <host01>:<ds_path>/<vm_id>/disk.0
<tm_mad>/mv <frontend>:<ds_path>/<vm_id>/disk.1 <host01>:<ds_path>/<vm_id>/disk.1
<tm_mad_sysds>/mv <frontend>:<ds_path>/<vm_id> <host01>:<ds_path>/<vm_id>
```

**MIGRATE host01 → host02**

```default
<tm_mad>/mv <host01>:<ds_path>/<vm_id>/disk.0 <host02>:<ds_path>/<vm_id>/disk.0
<tm_mad>/mv <host01>:<ds_path>/<vm_id>/disk.1 <host02>:<ds_path>/<vm_id>/disk.1
<tm_mad_sysds>/mv <host01>:<ds_path>/<vm_id> <host02>:<ds_path>/<vm_id>
```

**SHUTDOWN**

```default
<tm_mad>/delete <host02>:<ds_path>/<vm_id>/disk.0
<tm_mad>/mvds <host02>:<ds_path>/<vm_id>/disk.1 <pers_image_source>
<tm_mad_sysds>/delete <host02>:<ds_path>/<vm_id>
```

- `non_pers_image_source`: Source of the non-persistent image.
- `pers_image_source` : Source of the persistent image.
- `frontend`: hostname of the Front-end
- `host01`: hostname of Host01
- `host02`: hostname of Host02
- `tm_mad`: TM driver of the datastore where the image is registered
- `tm_mad_sysds`: TM driver of the system datastore

## Helper Scripts

There is a helper shell script with some functions defined to do some common tasks. It is located in `/var/lib/one/remotes/scripts_common.sh`

Here is the description of those functions.

- **log**: Takes one parameter that is a message that will be logged into the VM log file.

```default
log "Creating directory $DST_DIR"
```

- **error_message**: sends an exit message to oned surrounding it by separators, used to send the error message when a command fails.

```default
error_message "File '$FILE' not found"
```

- **arg_host**: gets the hostname part from a parameter

```default
SRC_HOST=`arg_host $SRC`
```

- **arg_path**: gets the path part from a parameter

```default
SRC_PATH=`arg_path $SRC`
```

- **exec_and_log**: executes a command and logs its execution. If the command fails the error message is sent to oned and the script ends

```default
exec_and_log "chmod g+w $DST_PATH"
```

- **ssh_exec_and_log**: This function executes $2 at $1 host and report error $3

```default
ssh_exec_and_log "$HOST" "chmod g+w $DST_PATH" "Error message"
```

- **timeout_exec_and_log**: like `exec_and_log` but takes as first parameter the max number of seconds the command can run

```default
timeout_exec_and_log 15 "cp $SRC_PATH $DST_PATH"
```

There are additional minor helper functions, please read the `scripts_common.sh` to see them.

## Decoded Example

<a id="sd-dump"></a>
```xml
<DS_DRIVER_ACTION_DATA>
    <IMAGE>
        <ID>0</ID>
        <UID>0</UID>
        <GID>0</GID>
        <UNAME>oneadmin</UNAME>
        <GNAME>oneadmin</GNAME>
        <NAME>ttylinux</NAME>
        <PERMISSIONS>
            <OWNER_U>1</OWNER_U>
            <OWNER_M>1</OWNER_M>
            <OWNER_A>0</OWNER_A>
            <GROUP_U>0</GROUP_U>
            <GROUP_M>0</GROUP_M>
            <GROUP_A>0</GROUP_A>
            <OTHER_U>0</OTHER_U>
            <OTHER_M>0</OTHER_M>
            <OTHER_A>0</OTHER_A>
        </PERMISSIONS>
        <TYPE>0</TYPE>
        <DISK_TYPE>0</DISK_TYPE>
        <PERSISTENT>0</PERSISTENT>
        <REGTIME>1385145541</REGTIME>
        <SOURCE/>
        <PATH>/tmp/ttylinux.img</PATH>
        <FSTYPE/>
        <SIZE>40</SIZE>
        <STATE>4</STATE>
        <RUNNING_VMS>0</RUNNING_VMS>
        <CLONING_OPS>0</CLONING_OPS>
        <CLONING_ID>-1</CLONING_ID>
        <DATASTORE_ID>1</DATASTORE_ID>
        <DATASTORE>default</DATASTORE>
        <VMS/>
        <CLONES/>
        <TEMPLATE>
            <DEV_PREFIX><![CDATA[hd]]></DEV_PREFIX>
            <PUBLIC><![CDATA[YES]]></PUBLIC>
        </TEMPLATE>
    </IMAGE>
    <DATASTORE>
        <ID>1</ID>
        <UID>0</UID>
        <GID>0</GID>
        <UNAME>oneadmin</UNAME>
        <GNAME>oneadmin</GNAME>
        <NAME>default</NAME>
        <PERMISSIONS>
            <OWNER_U>1</OWNER_U>
            <OWNER_M>1</OWNER_M>
            <OWNER_A>0</OWNER_A>
            <GROUP_U>1</GROUP_U>
            <GROUP_M>0</GROUP_M>
            <GROUP_A>0</GROUP_A>
            <OTHER_U>1</OTHER_U>
            <OTHER_M>0</OTHER_M>
            <OTHER_A>0</OTHER_A>
        </PERMISSIONS>
        <DS_MAD>fs</DS_MAD>
        <TM_MAD>shared</TM_MAD>
        <TYPE>0</TYPE>
        <DISK_TYPE>0</DISK_TYPE>
        <CLUSTER_ID>-1</CLUSTER_ID>
        <CLUSTER/>
        <TOTAL_MB>86845</TOTAL_MB>
        <FREE_MB>20777</FREE_MB>
        <USED_MB>1000</USED_MB>
        <IMAGES/>
        <TEMPLATE>
            <CLONE_TARGET><![CDATA[SYSTEM]]></CLONE_TARGET>
            <DISK_TYPE><![CDATA[FILE]]></DISK_TYPE>
            <DS_MAD><![CDATA[fs]]></DS_MAD>
            <LN_TARGET><![CDATA[NONE]]></LN_TARGET>
            <TM_MAD><![CDATA[shared]]></TM_MAD>
            <TYPE><![CDATA[IMAGE_DS]]></TYPE>
        </TEMPLATE>
    </DATASTORE>
</DS_DRIVER_ACTION_DATA>

<DS_DRIVER_ACTION_DATA>
    <DATASTORE>
        <ID>0</ID>
        <UID>0</UID>
        <GID>0</GID>
        <UNAME>oneadmin</UNAME>
        <GNAME>oneadmin</GNAME>
        <NAME>system</NAME>
        <PERMISSIONS>
            <OWNER_U>1</OWNER_U>
            <OWNER_M>1</OWNER_M>
            <OWNER_A>0</OWNER_A>
            <GROUP_U>1</GROUP_U>
            <GROUP_M>0</GROUP_M>
            <GROUP_A>0</GROUP_A>
            <OTHER_U>0</OTHER_U>
            <OTHER_M>0</OTHER_M>
            <OTHER_A>0</OTHER_A>
        </PERMISSIONS>
        <DS_MAD><![CDATA[-]]></DS_MAD>
        <TM_MAD><![CDATA[qcow2]]></TM_MAD>
        <BASE_PATH><![CDATA[/var/lib/one//datastores/0]]></BASE_PATH>
        <TYPE>1</TYPE>
        <DISK_TYPE>0</DISK_TYPE>
        <STATE>0</STATE>
        <CLUSTERS>
            <ID>0</ID>
        </CLUSTERS>
        <TOTAL_MB>31998</TOTAL_MB>
        <FREE_MB>12650</FREE_MB>
        <USED_MB>17694</USED_MB>
        <IMAGES></IMAGES>
        <TEMPLATE>
            <ALLOW_ORPHANS><![CDATA[NO]]></ALLOW_ORPHANS>
            <DS_MIGRATE><![CDATA[YES]]></DS_MIGRATE>
            <SHARED><![CDATA[YES]]></SHARED>
            <TM_MAD><![CDATA[qcow2]]></TM_MAD>
            <TYPE><![CDATA[SYSTEM_DS]]></TYPE>
        </TEMPLATE>
    </DATASTORE>
    <DATASTORE_LOCATION>/var/lib/one//datastores</DATASTORE_LOCATION>
    <MONITOR_VM_DISKS>1</MONITOR_VM_DISKS>
</DS_DRIVER_ACTION_DATA>
```

## Datastore Backup STDIN Example

<a id="ds-backup-dump"></a>
```xml
<DS_DRIVER_ACTION_DATA>
  <DATASTORE>
    <ID>100</ID>
    <UID>0</UID>
    <GID>0</GID>
    <UNAME>oneadmin</UNAME>
    <GNAME>oneadmin</GNAME>
    <NAME>rsync</NAME>
    <PERMISSIONS>
      <OWNER_U>1</OWNER_U>
      <OWNER_M>1</OWNER_M>
      <OWNER_A>0</OWNER_A>
      <GROUP_U>1</GROUP_U>
      <GROUP_M>0</GROUP_M>
      <GROUP_A>0</GROUP_A>
      <OTHER_U>0</OTHER_U>
      <OTHER_M>0</OTHER_M>
      <OTHER_A>0</OTHER_A>
    </PERMISSIONS>
    <DS_MAD>rsync</DS_MAD>
    <TM_MAD>-</TM_MAD>
    <BASE_PATH>/var/lib/one//datastores/100</BASE_PATH>
    <TYPE>3</TYPE>
    <DISK_TYPE>0</DISK_TYPE>
    <STATE>0</STATE>
    <CLUSTERS>
      <ID>0</ID>
    </CLUSTERS>
    <TOTAL_MB>19663</TOTAL_MB>
    <FREE_MB>6457</FREE_MB>
    <USED_MB>13191</USED_MB>
    <IMAGES/>
    <TEMPLATE>
      <DS_MAD>rsync</DS_MAD>
      <RESTRICTED_DIRS>/</RESTRICTED_DIRS>
      <RSYNC_HOST>192.168.150.1</RSYNC_HOST>
      <RSYNC_USER>oneadmin</RSYNC_USER>
      <SAFE_DIRS>/var/tmp</SAFE_DIRS>
      <TM_MAD>-</TM_MAD>
      <TYPE>BACKUP_DS</TYPE>
    </TEMPLATE>
  </DATASTORE>
  <VM>
    <ID>800</ID>
    <UID>0</UID>
    <GID>0</GID>
    <UNAME>oneadmin</UNAME>
    <GNAME>oneadmin</GNAME>
    <NAME>alpine-800</NAME>
    <PERMISSIONS>
      <OWNER_U>1</OWNER_U>
      <OWNER_M>1</OWNER_M>
      <OWNER_A>0</OWNER_A>
      <GROUP_U>0</GROUP_U>
      <GROUP_M>0</GROUP_M>
      <GROUP_A>0</GROUP_A>
      <OTHER_U>0</OTHER_U>
      <OTHER_M>0</OTHER_M>
      <OTHER_A>0</OTHER_A>
    </PERMISSIONS>
    <LAST_POLL>0</LAST_POLL>
    <STATE>3</STATE>
    <LCM_STATE>69</LCM_STATE>
    <PREV_STATE>3</PREV_STATE>
    <PREV_LCM_STATE>69</PREV_LCM_STATE>
    <RESCHED>0</RESCHED>
    <STIME>1727952499</STIME>
    <ETIME>0</ETIME>
    <DEPLOY_ID>7c657ee7-166b-46d3-bf5f-53886f0b77dd</DEPLOY_ID>
    <MONITORING/>
    <SCHED_ACTIONS/>
    <TEMPLATE>
      <AUTOMATIC_DS_REQUIREMENTS>("CLUSTERS/ID" @> 0)</AUTOMATIC_DS_REQUIREMENTS>
      <AUTOMATIC_NIC_REQUIREMENTS>("CLUSTERS/ID" @> 0)</AUTOMATIC_NIC_REQUIREMENTS>
      <AUTOMATIC_REQUIREMENTS>(CLUSTER_ID = 0)</AUTOMATIC_REQUIREMENTS>
      <CONTEXT>
        <DISK_ID>1</DISK_ID>
        <ETH0_DNS/>
        <ETH0_EXTERNAL/>
        <ETH0_GATEWAY>192.168.150.1</ETH0_GATEWAY>
        <ETH0_IP>192.168.150.100</ETH0_IP>
        <ETH0_IP6/>
        <ETH0_IP6_GATEWAY/>
        <ETH0_IP6_METHOD/>
        <ETH0_IP6_METRIC/>
        <ETH0_IP6_PREFIX_LENGTH/>
        <ETH0_IP6_ULA/>
        <ETH0_MAC>02:00:c0:a8:96:64</ETH0_MAC>
        <ETH0_MASK/>
        <ETH0_METHOD/>
        <ETH0_METRIC/>
        <ETH0_MTU/>
        <ETH0_NETWORK/>
        <ETH0_SEARCH_DOMAIN/>
        <ETH0_VLAN_ID/>
        <ETH0_VROUTER_IP/>
        <ETH0_VROUTER_IP6/>
        <ETH0_VROUTER_MANAGEMENT/>
        <NETWORK>YES</NETWORK>
        <SSH_PUBLIC_KEY>ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCYz+lkZoNyspRhrtXDKFN3cIEwN3w08mz0YGKpVDIiV0+/vgG8dAUQ70Irs3m83W9BHN+vNjKPgKcF+X+sSfxniOtavahxGCRjAhhs1IVm196C5ODbSgXVUWULdtmMHelXbLBJ8X340h/UO+eQ6eRLaRfslXUsgRqremVcvCCPz4LIuRiliGWiELAmqYcY+1zJLeg3QV2Pgn5vschM9e/A4AseKO+HnbGB/I5tnoeZT/Gc3FGfUZLNFVB2XsVGAEEzkqO8VI2msB7MCAZBHffIK6WfLIYgGP6Ha2JT1NWJU7Ncj9Xuql0ElF01VwWMDWzqc0DOiVSsTL89ugJKU6+h one</SSH_PUBLIC_KEY>
        <TARGET>hda</TARGET>
      </CONTEXT>
      <CPU>0.1</CPU>
      <DISK>
        <ALLOW_ORPHANS>mixed</ALLOW_ORPHANS>
        <CEPH_HOST>ubuntu2204-kvm-ceph-quincy-6-99-0c08-0.test</CEPH_HOST>
        <CEPH_SECRET>7ebb2445-e96e-44c6-b7c7-07dc7a50f311</CEPH_SECRET>
        <CEPH_USER>oneadmin</CEPH_USER>
        <CLONE>YES</CLONE>
        <CLONE_TARGET>SELF</CLONE_TARGET>
        <CLUSTER_ID>0</CLUSTER_ID>
        <DATASTORE>default</DATASTORE>
        <DATASTORE_ID>1</DATASTORE_ID>
        <DEV_PREFIX>vd</DEV_PREFIX>
        <DISK_ID>0</DISK_ID>
        <DISK_SNAPSHOT_TOTAL_SIZE>0</DISK_SNAPSHOT_TOTAL_SIZE>
        <DISK_TYPE>RBD</DISK_TYPE>
        <DRIVER>raw</DRIVER>
        <FORMAT>raw</FORMAT>
        <IMAGE>alpine</IMAGE>
        <IMAGE_ID>0</IMAGE_ID>
        <IMAGE_STATE>2</IMAGE_STATE>
        <LN_TARGET>NONE</LN_TARGET>
        <ORIGINAL_SIZE>256</ORIGINAL_SIZE>
        <POOL_NAME>one</POOL_NAME>
        <READONLY>NO</READONLY>
        <SAVE>NO</SAVE>
        <SIZE>256</SIZE>
        <SOURCE>one/one-0</SOURCE>
        <TARGET>vda</TARGET>
        <TM_MAD>ceph</TM_MAD>
        <TYPE>RBD</TYPE>
      </DISK>
      <GRAPHICS>
        <LISTEN>0.0.0.0</LISTEN>
        <PORT>6700</PORT>
        <TYPE>vnc</TYPE>
      </GRAPHICS>
      <MEMORY>96</MEMORY>
      <NIC>
        <AR_ID>0</AR_ID>
        <BRIDGE>br0</BRIDGE>
        <BRIDGE_TYPE>linux</BRIDGE_TYPE>
        <CLUSTER_ID>0</CLUSTER_ID>
        <GATEWAY>192.168.150.1</GATEWAY>
        <IP>192.168.150.100</IP>
        <MAC>02:00:c0:a8:96:64</MAC>
        <MODEL>virtio</MODEL>
        <NAME>NIC0</NAME>
        <NETWORK>public</NETWORK>
        <NETWORK_ID>0</NETWORK_ID>
        <NIC_ID>0</NIC_ID>
        <SECURITY_GROUPS>0</SECURITY_GROUPS>
        <TARGET>one-800-0</TARGET>
        <VN_MAD>dummy</VN_MAD>
      </NIC>
      <NIC_DEFAULT>
        <MODEL>virtio</MODEL>
      </NIC_DEFAULT>
      <OS>
        <UUID>7c657ee7-166b-46d3-bf5f-53886f0b77dd</UUID>
      </OS>
      <SECURITY_GROUP_RULE>
        <PROTOCOL>ALL</PROTOCOL>
        <RULE_TYPE>OUTBOUND</RULE_TYPE>
        <SECURITY_GROUP_ID>0</SECURITY_GROUP_ID>
        <SECURITY_GROUP_NAME>default</SECURITY_GROUP_NAME>
      </SECURITY_GROUP_RULE>
      <SECURITY_GROUP_RULE>
        <PROTOCOL>ALL</PROTOCOL>
        <RULE_TYPE>INBOUND</RULE_TYPE>
        <SECURITY_GROUP_ID>0</SECURITY_GROUP_ID>
        <SECURITY_GROUP_NAME>default</SECURITY_GROUP_NAME>
      </SECURITY_GROUP_RULE>
      <TEMPLATE_ID>0</TEMPLATE_ID>
      <TM_MAD_SYSTEM>ceph</TM_MAD_SYSTEM>
      <VMID>800</VMID>
    </TEMPLATE>
    <USER_TEMPLATE>
      <ARCH>x86_64</ARCH>
    </USER_TEMPLATE>
    <HISTORY_RECORDS>
      <HISTORY>
        <OID>800</OID>
        <SEQ>1</SEQ>
        <HOSTNAME>ubuntu2204-kvm-ceph-quincy-6-99-0c08-2.test</HOSTNAME>
        <HID>62</HID>
        <CID>0</CID>
        <STIME>1727952516</STIME>
        <ETIME>0</ETIME>
        <VM_MAD>kvm</VM_MAD>
        <TM_MAD>ceph</TM_MAD>
        <DS_ID>0</DS_ID>
        <PSTIME>0</PSTIME>
        <PETIME>0</PETIME>
        <RSTIME>1727952516</RSTIME>
        <RETIME>0</RETIME>
        <ESTIME>0</ESTIME>
        <EETIME>0</EETIME>
        <ACTION>0</ACTION>
        <UID>-1</UID>
        <GID>-1</GID>
        <REQUEST_ID>-1</REQUEST_ID>
      </HISTORY>
    </HISTORY_RECORDS>
    <BACKUPS>
      <BACKUP_CONFIG>
        <LAST_DATASTORE_ID>100</LAST_DATASTORE_ID>
      </BACKUP_CONFIG>
      <BACKUP_IDS/>
    </BACKUPS>
  </VM>
</DS_DRIVER_ACTION_DATA>
```

## Export XML

<a id="sd-export"></a>
```xml
<IMPORT_INFO>
   <IMPORT_SOURCE><![CDATA[<src>]]></IMPORT_SOURCE>
   <MD5><![CDATA[<md5sum>]]></MD5>
   <SIZE><![CDATA[<size>]]></SIZE>
   <FORMAT><![CDATA[<format>]></FORMAT>
   <DISPOSE><dispose></DISPOSE>
   <DISPOSE_CMD><<![CDATA[<dispose command>]]>/DISPOSE_CMD>
</IMPORT_INFO>
```
