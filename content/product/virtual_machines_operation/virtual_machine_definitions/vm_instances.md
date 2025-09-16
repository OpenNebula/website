---
title: "Virtual Machine Instances"
date: "2025-02-17"
description:
categories:
pageintoc: "93"
tags:
weight: "3"
---

<a id="vm-guide-2"></a>

<a id="vm-instances"></a>

<!--# Managing Virtual Machines Instances -->

This guide may be considered a continuation of the [Virtual Machines Templates]({{% relref "../virtual_machine_definitions/vm_templates" %}}) guide. Once a Template is instantiated to a Virtual Machine, there are a number of operations that can be performed using the `onevm` command.

<a id="vm-life-cycle-and-states"></a>

## Virtual Machine States

The life-cycle of a Virtual Machine within OpenNebula includes the following stages:

{{< alert title="Note" color="success" >}}
Note that this is a simplified version. If you are a developer you may want to take a look at the complete diagram referenced in the [Virtual Machines States Reference guide]({{% relref "../../operation_references/configuration_references/vm_states#vm-states" %}}).{{< /alert >}} 

| Short state   | State              | Meaning                                                                                                                                                                                                                                                                                                  |
|---------------|--------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `pend`        | `Pending`          | By default a VM starts in the pending state, waiting for a resource to run on. It will stay in this state until the scheduler decides to deploy it, or the user deploys it using the `onevm deploy` command.                                                                                             |
| `hold`        | `Hold`             | The owner has held the VM and it will not be scheduled until it is released. It can be deployed manually, however.                                                                                                                                                                                      |
| `clon`        | `Cloning`          | The VM is waiting for one or more disk images to finish the initial copy to the repository (image state still in `lock`).                                                                                                                                                                                 |
| `prol`        | `Prolog`           | The system is transferring the VM files (disk images and the recovery file) to the Host in which the Virtual Machine will be running.                                                                                                                                                                    |
| `boot`        | `Boot`             | OpenNebula is waiting for the hypervisor to create the VM.                                                                                                                                                                                                                                               |
| `runn`        | `Running`          | The VM is running (note that this stage includes the internal virtualized machine booting and shutting down phases). In this state, the virtualization driver will periodically monitor it.                                                                                                              |
| `migr`        | `Migrate`          | The VM is migrating from one resource to another. This can be a life migration or cold migration (the VM is saved, powered off or powered off hard and VM files are transferred to the new resource).                                                                                                    |
| `hotp`        | `Hotplug`          | A disk attach/detach, nic attach/detach, save as or resize operation is in process.                                                                                                                                                                                                                       |
| `snap`        | `Snapshot`         | A system snapshot is being taken.                                                                                                                                                                                                                                                                        |
| `save`        | `Save`             | The system is saving the VM files after a migration, stop, or suspend operation.                                                                                                                                                                                                                          |
| `epil`        | `Epilog`           | In this phase the system cleans up the Host used to virtualize the VM, and additionally disk images to be saved are copied back to the system datastore.                                                                                                                                                 |
| `shut`        | `Shutdown`         | OpenNebula has sent the VM the shutdown ACPI signal and is waiting for it to complete the shutdown process. If after a timeout period the VM does not disappear, OpenNebula will assume that the guest OS ignored the ACPI signal and the VM state will be changed to **running** instead of **done**. |
| `stop`        | `Stopped`          | The VM is stopped. VM state has been saved and it has been transferred back along with the disk images to the system datastore.                                                                                                                                                                          |
| `susp`        | `Suspended`        | Same as stopped, but the files are left in the Host to later resume the VM there (i.e., there is no need to reschedule the VM).                                                                                                                                                                          |
| `poff`        | `PowerOff`         | Same as suspended, but no checkpoint file is generated. Note that the files are left in the Host to later boot the VM there.<br/><br/>When the VM guest is shut down, OpenNebula will put the VM in this state.                                                                                           |
| `unde`        | `Undeployed`       | The VM is shut down. The VM disks are transferred to the system datastore. The VM can be resumed later.                                                                                                                                                                                                   |
| `drsz`        | `Disk Resize`      | The VM disk resize is in progress.                                                                                                                                                                                                                                                                        |
| `back`        | `Backup`           | The VM backup is in progress.                                                                                                                                                                                                                                                                             |
| `rest`        | `Restore`          | The VM disks are restored from backup image.                                                                                                                                                                                                                                                              |
| `fail`        | `Failed`           | The VM failed.                                                                                                                                                                                                                                                                                           |
| `unkn`        | `Unknown`          | The VM couldn’t be reached, it is in an unknown state.                                                                                                                                                                                                                                                   |
| `clea`        | `Cleanup-resubmit` | The VM is waiting for the drivers to clean the Host after a `onevm recover --recreate` action.                                                                                                                                                                                                            |
| `done`        | `Done`             | The VM is done. VMs in this state won’t be shown with `onevm list` but are kept in the database for accounting purposes. You can still get their information with the `onevm show` command.                                                                                                              |

## Create and List Virtual Machines

{{< alert title="Note" color="success" >}}
Read the [Creating Virtual Machines guide]({{% relref "../virtual_machine_definitions/vm_templates#vm-guide" %}}) for more information on how to manage and instantiate VM templates.{{< /alert >}} 

{{< alert title="Note" color="success" >}}
Read the complete reference for [Virtual Machine templates]({{% relref "../../operation_references/configuration_references/template#template" %}}).{{< /alert >}} 

Assuming we have a VM template registered called **vm-example** with ID 6, then we can instantiate the VM by issuing a:

```default
$ onetemplate list
  ID USER     GROUP    NAME                         REGTIME
   6 oneadmin oneadmin vm_example            09/28 06:44:07

$ onetemplate instantiate vm-example --name my_vm
VM ID: 0
```

If the template has [USER INPUTS]({{% relref "../virtual_machine_definitions/vm_templates#vm-guide-user-inputs" %}}) defined, the CLI will prompt the user for these values:

```default
$ onetemplate instantiate vm-example --name my_vm
There are some parameters that require user input.
  * (BLOG_TITLE) Blog Title: <my_title>
  * (DB_PASSWORD) Database Password:
VM ID: 0
```

Afterwards, the VM can be listed with the `onevm list` command. You can also use the `onevm top` command to list VMs continuously.

```default
$ onevm list
    ID USER     GROUP    NAME         STAT CPU     MEM        HOSTNAME        TIME
     0 oneadmin oneadmin my_vm        pend   0      0K                 00 00:00:03
```

The scheduler will automatically deploy the VM in one of the Hosts with enough resources available. The deployment can also be forced by oneadmin using `onevm deploy`:

```default
$ onehost list
  ID NAME               RVM   TCPU   FCPU   ACPU   TMEM   FMEM   AMEM   STAT
   2 testbed              0    800    800    800    16G    16G    16G     on

$ onevm deploy 0 2

$ onevm list
    ID USER     GROUP    NAME         STAT CPU     MEM        HOSTNAME        TIME
     0 oneadmin oneadmin my_vm        runn   0      0K         testbed 00 00:02:40
```

and details about it can be obtained with `show`:

```default
$ onevm show 0
VIRTUAL MACHINE 0 INFORMATION
ID                  : 0
NAME                : my_vm
USER                : oneadmin
GROUP               : oneadmin
STATE               : ACTIVE
LCM_STATE           : RUNNING
START TIME          : 04/14 09:00:24
END TIME            : -
DEPLOY ID:          : one-0

PERMISSIONS
OWNER          : um-
GROUP          : ---
OTHER          : ---

VIRTUAL MACHINE MONITORING
NET_TX              : 13.05
NET_RX              : 0
USED MEMORY         : 512
USED CPU            : 0

VIRTUAL MACHINE TEMPLATE
...

VIRTUAL MACHINE HISTORY
 SEQ        HOSTNAME REASON           START        TIME       PTIME
   0         testbed   none  09/28 06:48:18 00 00:07:23 00 00:00:00
```

<a id="vm-search"></a>

### Searching for VM Instances

You can search for VM instances by using the `--search` option of the `onevm list` command. This is especially useful on large environments with many VMs. The filter must be in a `VM.KEY1=VALUE1&VM.KEY2=VALUE2` format and will return all the VMs which fit the filter. The `&` works as logical AND. You can use `*=VALUE` to search the full VM body or `VM.TEMPLATE=VALUE` to search whole template.

Searching is performed using JSON on the whole body of the VM. You can use the MySQL JSON path without the leading `$.`, information about the path structure can be found in the [MySQL Documentation](https://dev.mysql.com/doc/refman/5.7/en/json.html#json-path-syntax) or [MariaDB Documentation](https://mariadb.com/kb/en/jsonpath-expressions/).  Currently, the value is wrapped in `%` for the query, so it will match if it contains the value provided.

The `VALUE` part of a search query can utilize special characters to create flexible matching patterns:

* `%`: Matches any string, allowing for wildcard searches. For example, `a%a%a` matches names containing three “a”s in any position, with any number of characters between them.
* `_`: Matches any single character, enabling precise pattern matching. For instance, `a_a_a` matches names with three “a”s, each separated by exactly one character.
* `&`: Cannot be used in the `VALUE` part of the search query, as it is always interpreted as logical AND operator and does not support escaping.

To search for strings that contain `%` or `_` literally, escape these characters with a backslash `\`. For example:

* `a\%a` will search for “a%a” as an exact sequence.
* `a\_a` will match “a_a” without interpreting `_` as a single-character wildcard.

For example, for to search for a VM with a specific MAC address:

```default
$ onevm list --search 'VM.TEMPLATE.NIC[*].MAC=02:00:0c:00:4c:dd'
 ID    USER     GROUP    NAME    STAT UCPU UMEM HOST TIME
 21005 oneadmin oneadmin test-vm pend    0   0K      1d 23h11
```

Equivalently, if there is more than one VM instance that matches the result they will be shown. For example, VM's NAME containing a pattern and owned by oneadmin:

```default
$ onevm list --search 'VM.NAME=test-vm&VM.UNAME=oneadmin'
 ID    USER     GROUP    NAME     STAT UCPU UMEM HOST TIME
 21005 oneadmin oneadmin test-vm  pend    0   0K       1d 23h13
 2100  oneadmin oneadmin test-vm2 pend    0   0K      12d 17h59
```

{{< alert title="Warning" color="warning" >}}
This feature is only available for **MySQL** backend with version **5.6** or later.{{< /alert >}} 

## Basic Virtual Machine Operations

### Terminating VM Instances

You can terminate an instance with the `onevm terminate` command, from any state. It will shut down (if needed) and delete the VM. This operation will free the resources (images, networks, etc.) used by the VM.

If the instance is running, there is a `--hard` option that has the following meaning:

* `terminate`: Gracefully shuts down and deletes a running VM, sending the ACPI signal. Once the VM is shut down the Host is cleaned and persistent and deferred-snapshot disk will be moved to the associated datastore. If after a given time the VM is still running (e.g., guest ignoring ACPI signals), OpenNebula will return the VM to the `RUNNING` state.
* `terminate --hard`: Same as above but the VM is immediately destroyed. Use this action instead of `terminate` when the VM doesn’t have ACPI support.

### Pausing VM Instances

There are two different ways to temporarily stop the execution of a VM: *short* and *long* term pauses. A **short term** pause keeps all the VM resources allocated to the Hosts so it resumes its operation in the same Hosts quickly. Use the following `onevm` commands or Sunstone actions:

* `suspend`: the VM state is saved in the running Host. When a suspended VM is resumed, it is immediately deployed in the same Host by restoring its saved state.
* `poweroff`: Gracefully powers off a running VM by sending the ACPI signal. It is similar to suspend but without saving the VM state. When the VM is resumed it will boot immediately in the same Host.
* `poweroff --hard`: Same as above but the VM is immediately powered off. Use this action when the VM doesn’t have ACPI support.

{{< alert title="Note" color="success" >}}
When the guest is shut down from within the VM, OpenNebula will put the VM in the `poweroff` state.{{< /alert >}} 

You can also plan a **long term pause**. The Host resources used by the VM are freed and the Host is cleaned. VM disk state is saved in the system datastore. The following actions are useful if you want to preserve network and storage allocations (e.g., IPs, persistent disk images):

* `undeploy`: Gracefully shuts down a running VM, sending the ACPI signal. The Virtual Machine disks are transferred back to the system datastore. When an undeployed VM is resumed it is moved to the pending state and the scheduler will choose where to re-deploy it.
* `undeploy --hard`: Same as above but the running VM is immediately destroyed.
* `stop`: Same as `undeploy` but also the VM state is saved to resume it later.

When the VM is successfully paused you can resume its execution with:

* `resume`: Resumes the execution of VMs in the stopped, suspended, undeployed, and poweroff states.

### Rebooting VM Instances

Use the following commands to reboot a VM:

* `reboot`: Gracefully reboots a running VM, sending the ACPI signal.
* `reboot --hard`: Performs a ‘hard’ reboot.

### Delaying VM Instances

The deployment of a PENDING VM (e.g., after creating or resuming it) can be delayed with:

* `hold`: Sets the VM to hold state. The scheduler will not deploy VMs in the `hold` state. Please note that VMs can be created directly on hold by using ‘onetemplate instantiate –hold’ or ‘onevm create –hold’.

Then you can resume it with:

* `release`: Releases a VM from hold state, setting it to pending. Note that you can automatically release a VM by scheduling the operation as explained below.

<a id="disk-hotplugging"></a>

## Hotplug Devices to a Virtual Machine

{{< alert title="Warning" color="warning" >}}
Hotplugging might not be available for every supported hypervisor. Please check the limitations of the specific virtualization driver you’re using to ensure this feature is available before using it.{{< /alert >}} 

### Disk Hot-plugging

New disks can be hot-plugged to running VMs with the `onevm`, `disk-attach`, and `disk-detach` commands. For example, to attach the Image named **storage** to a running VM:

```default
$ onevm disk-attach one-5 --image storage
```

To detach a disk from a running VM, find the disk ID of the Image you want to detach using the `onevm show` command, and then simply execute `onevm detach vm_id disk_id`:

```default
$ onevm show one-5
...
DISK=[
  DISK_ID="1",
...
  ]
...

$ onevm disk-detach one-5 1
```

<a id="vm-guide2-nic-hotplugging"></a>

### NIC Hot-plugging

You can hot-plug network interfaces to VMs in the `RUNNING`, `POWEROFF`, or `SUSPENDED` states. Simply specify the network where the new interface should be attached, for example:

```default
$ onevm show 2

VIRTUAL MACHINE 2 INFORMATION
ID                  : 2
NAME                : centos-server
STATE               : ACTIVE
LCM_STATE           : RUNNING

...

VM NICS
ID NETWORK      VLAN BRIDGE   IP              MAC
 0 net_172        no vbr0     172.16.1.201    02:00:ac:10:0

...

$ onevm nic-attach 2 --network net_172
```

After the operation you should see two NICs, 0 and 1:

```default
$ onevm show 2
VIRTUAL MACHINE 2 INFORMATION
ID                  : 2
NAME                : centos-server
STATE               : ACTIVE
LCM_STATE           : RUNNING

...


VM NICS
ID NETWORK      VLAN BRIDGE   IP              MAC
 0 net_172        no vbr0     172.16.1.201    02:00:ac:10:00:c9
                              fe80::400:acff:fe10:c9
 1 net_172        no vbr0     172.16.1.202    02:00:ac:10:00:ca
                              fe80::400:acff:fe10:ca
...
```

It is possible to attach (and live-attach) PCI and SR-IOV interfaces. Simply select the device by its address, id, vendor, or class.

```default
$ onevm nic-attach 2 --network net_172 onevm nic-attach 2 --network net_172 --pci '00:06.1'
```

**Important**, predictable PCI addresses for guests will be only generated if PCI bus 1 is present in the Virtual Machine as PCI bridges cannot be hot-plugged.

You can also detach a NIC by its ID. If you want to detach interface 1 (MAC `02:00:ac:10:00:ca`), execute:

```default
$ onevm nic-detach 2 1
```

<a id="nic-update"></a>

### NIC Update

Qos attributes can be updated by the command `onevm nic-update`. If the Virtual Machine is running, the action triggers the driver action to live-update the network parameters.

```default
$ cat update_nic.txt
NIC = [
    INBOUND_AVG_BW = "512",
    INBOUND_PEAK_BW = "1024"
]

$ onevm nic-update 0 0 update_nic.txt
```

<a id="vm-guide2-sg-hotplugging"></a>

### Security Group Hot-plugging

You can live attach or detach security groups to VMs. Simply specify the VM, network interface, and security group to attach, for example:

```default
$ onevm sg-attach centos-server 0 101
```

Similarly to detach a security group execute:.

```default
$ onevm sg-detach centos-server 0 101
```

On Sunstone, you can attach and detach security groups to an NIC on a running or powered off VM by going to the Network tab.

![sunstone_sg_main_view](/images/sunstone_sg_main_view.png)

To attach a new security group, you need to click on the shield on the NIC row. A dialog will be displayed where you can find all the security groups that do not belong to the selected network.

![sunstone_sg_attach](/images/sunstone_sg_attach.png)

To detach the security group, you must click on the Trash button next to the security group. A confirm dialog will be displayed to ensure that you want to detach the security group.

<a id="vm-guide2-pci"></a>

### PCI Devices

You can attach or detach a PCI to/from a Virtual Machine in the `POWEROFF` and `UNDEPLOYED` state. For example:

```default
$ onevm pci-attach alpine01 --pci_class 0c03 --pci_device 0015 --pci_vendor 1912
$ onevm pci-detach alpine01 0
```

<a id="vm-guide2-snapshotting"></a>

## Virtual Machine System Snapshots

{{< alert title="Warning" color="warning" >}}
Snapshotting might not be available for every supported hypervisor. Please check the limitations of the specific virtualization driver you’re using to ensure this feature is available before using it.

A system snapshot will contain the current disks and memory state. You can create, delete, and restore snapshots for running VMs.{{< /alert >}}  

```default
$ onevm snapshot-create 4 "just in case"

$ onevm show 4
...
SNAPSHOTS
  ID         TIME NAME                                           HYPERVISOR_ID
   0  02/21 16:05 just in case                                   onesnap-0

$ onevm snapshot-revert 4 0 --verbose
VM 4: snapshot reverted
```

{{< alert title="Warning" color="warning" >}}
For snapshots for VMs running under the **KVM hypervisor** you should consider the following limitations:

- Snapshots are only available if all the VM disks use the [qcow2 driver]({{% relref "../../operation_references/configuration_references/img_template#img-template" %}}).{{< /alert >}}  

<a id="vm-guide-2-disk-snapshots"></a>

## Virtual Machine Disk Snapshots

There are two kinds of operations related to disk snapshots:

* `disk-snapshot-create`, `disk-snapshot-revert`, `disk-snapshot-delete`, `disk-snapshot-rename`: Allows the user to take snapshots of the disk states and return to them during the VM life-cycle. It is also possible to rename or delete snapshots.
* `disk-saveas`: Exports VM disk (or a previously created snapshot) to an Image in an OpenNebula Datastore. This is a live action.

{{< alert title="Warning" color="warning" >}}
Disk snapshots might have different limitations depending on the hypervisor. Please check the limitations of the specific virtualization driver you’re using to ensure this feature is available before using it.{{< /alert >}} 

<a id="vm-guide-2-disk-snapshots-managing"></a>

### Managing Disk Snapshots

A user can take snapshots of VM disks to create a checkpoint of the state of a specific disk at any time. Depending on the storage backend, these snapshots can be organized:

- In a tree-like structure, meaning that every snapshot has a parent, except for the first snapshot whose parent is `-1`. The active snapshot, the one the user has last reverted to or taken, will act as the parent of the next snapshot. It’s possible to delete snapshots that are not active and that have no children.
- Flat structure, without parent/child relationship. In that case, snapshots can be freely removed.

Disk snapshots are managed with the following commands:

- `disk-snapshot-create <vmid> <diskid> <name>`: Creates a new snapshot of the specified disk.
- `disk-snapshot-revert <vmid> <diskid> <snapshot_id>`: Reverts to the specified snapshot. The snapshots are immutable, therefore users can revert to the same snapshot as many times as they want; the disk will always return to the state of the snapshot at the time it was taken.
- `disk-snapshot-delete <vmid> <diskid> <snapshot_id>`: Deletes a snapshot if it has no children and is not active.

`disk-snapshot-create` can take place when the VM is in `RUNNING` state, provided that the drivers support it, while `disk-snapshot-revert` requires the VM to be in `POWEROFF` or `SUSPENDED`. Live snapshots are only supported for some hypervisors and storage drivers:

- Hypervisor `VM_MAD=kvm` combined with `TM_MAD=qcow2` datastores. In this case OpenNebula will request that the hypervisor executes `virsh snapshot-create`.
- Hypervisor `VM_MAD=kvm` with Ceph datastores (`TM_MAD=ceph`). In this case OpenNebula will initially create the snapshots as Ceph snapshots in the current volume.

With these combinations (CEPH and qcow2 datastores, and KVM hypervisor) you can [enable QEMU Guest Agent]({{% relref "../../operation_references/hypervisor_configuration/kvm_driver#enabling-qemu-guest-agent" %}}). With this agent enabled the filesystem will be frozen while the snapshot is being taken.

{{< alert title="Warning" color="warning" >}}
OpenNebula will not automatically handle live `disk-snapshot-create` and `disk-snapshot-revert` operations for VMs in `RUNNING` state if the virtualization driver does not support it (check the limitations of the corresponding virtualization driver guide to know if this feature is available for your hypervisor). In this case the user needs to suspend or power off the VM before creating the snapshot.{{< /alert >}} 

See the [Storage Driver]({{% relref "../../../product/integration_references/infrastructure_drivers_development/sd#sd-tm" %}}) guide for a reference on the driver actions invoked to perform live and non-live snapshots.

{{< alert title="Warning" color="warning" >}}
Depending on the `DISK/CACHE` attribute the live snapshot may or may not work correctly. To be sure, you can use `CACHE=writethrough`, although this delivers the slowest performance.{{< /alert >}} 

### Persistent Images and Disk Snapshots

These actions are available for both persistent and non-persistent Images. In the case of persistent Images the snapshots **will** be preserved upon VM termination and will be able to be used by other VMs using that Image. See the [snapshots]({{% relref "../virtual_machine_images/images#images-snapshots" %}}) section in the Images guide for more information.

<a id="disk-save-as-action"></a>

### Saving a VM Disk to an Image (`disk-saveas`)

Any VM disk can be saved to a new Image (if the VM is in `RUNNING`, `POWEROFF`, `SUSPENDED`, `UNDEPLOYED`, or `STOPPED` states). This is a live operation that happens immediately. This operation accepts `--snapshot <snapshot_id>` as an optional argument, which specifies a disk snapshot to use as base of the new Image, instead of the current disk state (value by default).

{{< alert title="Warning" color="warning" >}}
This action is not in sync with the hypervisor. If the VM is in `RUNNING` state make sure the disk is unmounted (preferred), synced, or quiesced in some way or another before doing the `disk-saveas` operation.{{< /alert >}} 

<a id="vm-guide2-resizing-a-vm"></a>

## Resizing VM Resources

You may resize the capacity assigned to a Virtual Machine in terms of the virtual CPUs, memory, and CPU allocated. VM resizing can be done in any of the following states:
POWEROFF, UNDEPLOYED and, with some limitations, also live in RUNNING state.

If you have created a Virtual Machine and you need more resources, the following procedure is recommended:

- Perform any operation needed to prepare your Virtual Machine for shutting down, e.g., you may want to manually stop some services
- Power off the Virtual Machine
- Resize the VM
- Resume the Virtual Machine using the new capacity

Note that using this procedure the VM will preserve any resource assigned by OpenNebula, such as IP leases.

The following is an example of the previous procedure from the command line:

```default
$ onevm poweroff web_vm
$ onevm resize web_vm --memory 2G --vcpu 2
$ onevm resume web_vm
```

### Live Resize of Capacity

If you need to resize the capacity in the RUNNING state you have to set up some extra attributes in the VM template. These attributes **must be set before the VM is started**. These attributes are driver-specific, more info for [KVM]({{% relref "../../operation_references/hypervisor_configuration/kvm_driver#kvm-live-resize" %}}).

{{< alert title="Warning" color="warning" >}}
Hotplug is only implemented for KVM. Added CPUs will be in offline state after the resize. Enable them with `echo 1 > /sys/devices/system/cpu/cpu<ID>/online`{{< /alert >}} 

<a id="vm-guide2-resize-disk"></a>

### Resizing VM Disks

If the disks assigned to a Virtual Machine need more size, this can achieved at instantiation time of the VM. The SIZE parameter of the disk can be adjusted and, if it is bigger than the original size of the Image, OpenNebula will:

- Increase the size of the disk container prior to launching the VM
- Using the [contextualization packages]({{% relref "../virtual_machine_definitions/vm_templates#context-overview" %}}), at boot time the VM will grow the filesystem to adjust to the new size.

You can override the size of a `DISK` in a VM template at instantiation:

```default
$ onetemplate instantiate <template> --disk u2104:size=20000 # Image u2104 will be resized to 2 GB
```

You can also resize VM disks for both RUNNING and POWEROFF VMs:

```default
$ onevm disk-resize <vm_id> <disk_id> <new_size> # <new_size> must be greater than current disk size
```

This will make the VM disk grow on the hypervisor node. Then the contextualization service running inside the guest OS will expand the filesystem with the newly available free space. The support for this filesystem expansion depends on the Guest OS.

{{< alert title="Important" color="success" >}}
In FreeBSD the resize of the root filesystem inside the guest OS is not performed automatically by the Contextualization Service. This leads to [filesystem corruption](https://github.com/OpenNebula/addon-context-linux/issues/298) and permanent data loss. This only applies to the partition mounted on `/` , partitions with other mountpoints will be resized.{{< /alert >}} 

<a id="vm-updateconf"></a>

## Updating the Virtual Machine Configuration

Some of the VM configuration attributes defined in the VM template can be updated after the VM is created. The `onevm updateconf` command will allow you to change the following attributes:

| Attribute       | Sub-attributes                                                                                                           |
|-----------------|--------------------------------------------------------------------------------------------------------------------------|
| `OS`            | `ARCH`, `MACHINE`, `KERNEL`, `INITRD`, `BOOTLOADER`, `BOOT`,<br/>`KERNEL_CMD`, `ROOT`, `SD_DISK_BUS`, `UUID`, `FIRMWARE`, `FIRMWARE_FORMAT` |
| `FEATURES`      | `ACPI`, `PAE`, `APIC`, `LOCALTIME`, `HYPERV`, `GUEST_AGENT`,<br/>`VIRTIO_SCSI_QUEUES`, `VIRTIO_BLK_QUEUES`, `IOTHREADS`  |
| `INPUT`         | `TYPE`, `BUS`                                                                                                            |
| `GRAPHICS`      | `TYPE`, `LISTEN`, `PASSWD`, `KEYMAP`, `COMMAND`                                                                          |
| `VIDEO`         | `TYPE`, `IOMMU`, `ATS`, `VRAM`, `RESOLUTION`                                                                             |
| `RAW`           | `DATA`, `DATA_VMX`, `TYPE`, `VALIDATE`                                                                                   |
| `CPU_MODEL`     | `MODEL`, `FEATURES`                                                                                                      |
| `BACKUP_CONFIG` | `FS_FREEZE`, `KEEP_LAST`, `BACKUP_VOLATILE`, `MODE`,<br/>`INCREMENT_MODE`                                                |
| `CONTEXT`       | Any value, except `ETH*`. **Variable substitution will be made**                                                         |

Visit the [Virtual Machine Template reference]({{% relref "../../operation_references/configuration_references/template#template" %}}) for a complete description of each attribute.

{{< alert title="Warning" color="warning" >}}
This action might not be supported for `RUNNING` VMs depending on the hypervisor. Please check the limitation section of the specific virtualization driver.{{< /alert >}} 

{{< alert title="Note" color="success" >}}
In running state only changes in CONTEXT take effect immediately, other values may need a VM restart. Also, the action may fail and the context will not be changed if the VM is running. You can try to manually trigger the action again.{{< /alert >}} 

<a id="vm-guide2-clone-vm"></a>

## Cloning a Virtual Machine

A VM template or VM instance can be copied to a new VM template. This copy will preserve the changes made to the VM disks after the instance is terminated. The template is private and will only be listed to the owner user.

There are two ways to create a persistent private copy of a VM:

- Instantiate a VM template with the *to persistent* option.
- Save an existing VM instance with `onevm save`.

### Instantiate to Persistent

When **instantiating to persistent** the template is cloned recursively (a private persistent clone of each disk Image is created), and that new template is instantiated.

To “instantiate to persistent” use the `--persistent` option:

```default
$ onetemplate instantiate web_vm --persistent --name my_vm
VM ID: 31

$ onetemplate list
  ID USER            GROUP           NAME                                REGTIME
   7 oneadmin        oneadmin        web_vm                       05/12 14:53:11
   8 oneadmin        oneadmin        my_vm                        05/12 14:53:38

$ oneimage list
  ID USER       GROUP      NAME            DATASTORE     SIZE TYPE PER STAT RVMS
   7 oneadmin   oneadmin   web-img         default       200M OS   Yes used    1
   8 oneadmin   oneadmin   my_vm-disk-0    default       200M OS   Yes used    1
```

Equivalently, in Sunstone activate the “Persistent” switch next to the Create button.

Please bear in mind the following `ontemplate instantiate --persistent` limitation: volatile disks cannot be persistent. The contents of the disks will be lost when the VM is terminated. The cloned VM template will contain the definition for an empty volatile disk.

### Save a VM Instance

Alternatively, a VM that was not created as persistent can be **saved** before it is destroyed. To do so, the user has to `poweroff` the VM first and then use the `save` operation.

This action clones the VM source template, replacing the disks with copies of the current disks (see the disk-snapshot action). If the VM instance was resized, the current capacity is also used. The new cloned Images can be made persistent with the `--persistent` option. NIC interfaces are also overwritten with the ones from the VM instance, to preserve any attach/detach action.

```default
$ onevm save web_vm copy_of_web_vm --persistent
Template ID: 26
```

Please bear in mind the following `onevm save` limitations:

- The VM’s source template will be used. If this template was updated since the VM was instantiated, the new contents will be used.
- Volatile disks cannot be saved and the current contents will be lost. The cloned VM template will contain the definition for an empty volatile disk.
- Disks and NICs will only contain the target Image/Network NAME and UNAME if defined. If your template requires extra configuration, you will need to update the new template.

<a id="vm-guide2-scheduling-actions"></a>

## Scheduled Actions for Virtual Machines

Scheduled actions lets you program operations over a VM to be performed in the future, e.g., *Shutdown the VM after 5 hours*. OpenNebula supports two types of schedule actions:

- punctual, that can be also periodic.
- relative actions.

### One-Time Punctual Actions

Most of the onevm commands accept the `--schedule` option, allowing users to delay the actions until a given date and time.

Here is an usage example:

```default
$ onevm suspend 0 --schedule "09/20"
VM 0: suspend scheduled at 2016-09-20 00:00:00 +0200

$ onevm resume 0 --schedule "09/23 14:15"
VM 0: resume scheduled at 2016-09-23 14:15:00 +0200

$ onevm show 0
VIRTUAL MACHINE 0 INFORMATION
ID                  : 0
NAME                : one-0

[...]

SCHEDULED ACTIONS
ID    ACTION  ARGS   SCHEDULED REPEAT   END STATUS
 0   suspend     - 09/20 00:00              Next in 12.08 days
 1    resume     - 09/23 14:15              Next in 15.67 days
```

These actions can be deleted or edited using the `onevm sched-delete` and `onevm sched-update` command. The time attributes use Unix time internally.

```default
$ onevm sched-update 0 0

ID="0"
PARENT_ID="0"
TYPE="VM"
ACTION="suspend"
TIME="1703164454"
REPEAT="-1"
END_TYPE="-1"
END_VALUE="-1"
DONE="-1"
```

{{< alert title="Note" color="success" >}}
The attributes `ID`, `PARENT_ID` and `TYPE` are OpenNebula system attributes and can’t be modified. For more details about the attributes which can be modified, see [Scheduled Action Template]({{% relref "../../operation_references/configuration_references/template#template-schedule-actions" %}}){{< /alert >}} 

### Periodic Punctual Actions

To schedule periodic actions you can also use the option –schedule. However this command also needs more options to define the periodicity of the action:

> - `--weekly`: defines a weekly periodicity, so the action will be executed every week on the days that the user defines.
> - `--monthly`: defines a monthly periodicity, so the action will be executed every month, on the days that the user defines.
> - `--yearly`: defines a yearly periodicity, so the action will be executed every year, on the days that the user defines.
> - `--hourly`: defines an hourly periodicity, so the action will be executed each ‘x’ hours.
> - `--end`: defines when you want the relative action to finish.

The option `--weekly`, `--monthly`, and `--yearly` need the index of the days that the users wants to execute the action.

> - `--weekly`: days separated with commas between 0 (Sunday) and 6 (Saturday). [0,6]
> - `--monthly`: days separated with commas between 1 and 31. [1,31]
> - `--yearly`: days separated with commas between 0 and 365. [0,365]

The option `--hourly` needs a number with the number of hours. [0,168] (1 week)

The option `--end` can be a number or a date:

> - Number: defines the number of repetitions.
> - Date: defines the date that the user wants to finish the action.

Here is a usage example:

```default
$ onevm suspend 0 --schedule "09/20" --weekly "1,5" --end 5
VM 0: suspend scheduled at 2018-09-20 00:00:00 +0200

$ onevm resume 0 --schedule "09/23 14:15" --weekly "2,6" --end 5
VM 0: resume scheduled at 2018-09-23 14:15:00 +0200

$ onevm snapshot-create 0 snap-01 --schedule "09/23" --hourly 5 --end "12/25"
VM 0: snapshot-create scheduled at 2018-09-23 14:15:00 +0200

$ onevm show 0
VIRTUAL MACHINE 0 INFORMATION
ID                  : 0
NAME                : one-0

[...]

SCHEDULED ACTIONS
ID           ACTION     ARGS    SCHEDULED        REPEAT            END  STATUS
 0          suspend        -  09/20 00:00    Weekly 1,5  After 5 times  Next in 1.08 days
 1           resume        -  09/23 14:15    Weekly 2,6  After 5 times  Next in 4.67 days
 2  snapshot-create  snap-01  09/19 21:16  Each 5 hours    On 12/25/18  Next in 4.78 hours
```

These actions can be deleted or edited using the `onevm sched-delete` and `onevm sched-update` command. The time attributes use Unix time internally.

```default
$ onevm sched-update 0 2

ID="2"
PARENT_ID="0"
TYPE="VM"
ACTION="snapshot-create"
ARGS="snap-01"
TIME="1701998190"
REPEAT="3"
DAYS="5"
END_TYPE="2"
END_VALUE="1893452400"
DONE="1701980968"
```

### Relative Actions

Scheduled actions can be also relative to the Start Time of the VM. That is, it can be set on a VM Template and apply to the number of seconds after the VM is instantiated.

For instance, a VM Template with the following SCHED_ACTION will spawn VMs that will automatically shut down after 1 hour of being instantiated:

```default
$ onetemplate update 0

SCHED_ACTION=[
   ACTION="terminate",
   ID="0",
   TIME="+3600" ]
```

This functionality is present graphically in Sunstone in the VM template creation and update wizard, on the second step Advanced options, under Schedule Action tab.

<a id="schedule-actions"></a>

The following table summarizes the actions that can be scheduled. Note that some of the above actions need some parameters to run (e.g., a disk ID or a snapshot name).

| Action                 | Arguments           |
|------------------------|---------------------|
| `terminate [--hard]`   |                     |
| `undeploy [--hard]`    |                     |
| `hold`                 |                     |
| `release`              |                     |
| `stop`                 |                     |
| `suspend`              |                     |
| `resume`               |                     |
| `reboot [--hard]`      |                     |
| `poweroff [--hard]`    |                     |
| `snapshot-create`      | name                |
| `snapshot-revert`      | snap ID             |
| `snapshot-delete`      | snap ID             |
| `disk-snapshot-create` | disk ID, name       |
| `disk-snapshot-revert` | disk ID, snap ID    |
| `disk-snapshot-delete` | disk ID, snap ID    |
| `backup`               | datastore ID, reset |

You can pass arguments to the scheduled actions by using the parameter `ARGS` in the action definition. For example:

```default
$ onevm sched-update 0 0

ID="2"
PARENT_ID="0"
TYPE="VM"
ACTION="disk-snapshot-create",
ARGS="0, disksnap_example",
DAYS="1,5",
END_TYPE="1",
END_VALUE="5",
ID="0",
REPEAT="0",
TIME="1537653600"
```

In this example, the first argument would be the disk and the second the snapshot name.

{{< alert title="Note" color="success" >}}
The arguments are mandatory. If you use the CLI or Sunstone they are generated automatically for the actions.{{< /alert >}} 

<a id="vm-charter"></a>

## Virtual Machine Charters

This functionality automatically adds scheduling actions in VM templates. To enable the creation of Charters in Sunstone, you only need to add the following to the `vm-tab.yaml` file in the corresponding [Sunstone view]({{% relref "../../control_plane_configuration/graphical_user_interface/fireedge_sunstone#fireedge-sunstone-views" %}}):

```default
info-tabs:
  sched_actions:
    enabled: true
    actions:
      charter_create: true
```

![sunstone_vm_charter](/images/sunstone_vm_charter.png)

After enabling the creation of Charters, you have to define the schedule actions that have a Charter. To do that, you only need to modify the file `sunstone-server.conf` in the [FireEdge configuration]({{% relref "../../operation_references/opennebula_services_configuration/fireedge#fireedge-conf" %}}).

To explain this, we'll use an example:

```default
leases:
  terminate:
    edit: false
    execute_after_weeks: 3
  poweroff:
    edit: true
    execute_after_minutes: 5
```

The previous example will create two schedule actions:

- The Virtual Machine will be terminated 3 weeks after it was instantiated and you cannot edit this action before creating it.
- The Virtual Machine will be powered off after 5 minutes after it was instantiated and you can edit the action before creating it.

So, when the user clicks on the Charter button, the following info will appear:

![sunstone_charter_info](/images/sunstone_charter_info.png)

The first action cannot be edited but in the second one, you can change the action and the time. Also, you can tune the definition of a Charter:

| edit                                                      | If the action could be edited or not. Allow values: true, false                                                                                                                                                                                                                                                                                                                                               |
|-----------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| execute_after_<period_type><br/><br/><br/><br/><br/><br/> | Execute the action after the time that is defined. <period_type> allow values: years, months, weeks, days, hours, minutes.<br/><br/><br/>e.g., execute_after_years: 2 -> The action will be executed 2 years after the Virtual Machine was instantiated.<br/><br/><br/>e.g., execute_after_months: 3 -> The action will be executed 3 months after the Virtual Machine was instantiated.<br/><br/> |

This functionality is also available in the CLI through the following commands:

- onevm create-chart
- onevm sched-update
- onevm sched-delete

The Charters can be added into the `onevm` configuration file `/etc/one/cli/onevm.yaml`:

```default
:charters:
  :suspend:
    :time: "+1209600"
    :warning:
        :time: "+1123200"
  :terminate:
    :time: "+1209600"
    :warning:
        :time: "+1123200"
```

The information about the Charters can be checked with the command `onevm show`, the `*` in front of the ID indicates that the warning time passed:

```default
SCHEDULED ACTIONS
ID     ACTION     ARGS    SCHEDULED        REPEAT            END  STATUS
*0  suspend          -  01/01 03:00                               Next in 1.25 hours
 1  terminate        -  15/01 03:00                               Next in 14 days
```

<a id="vm-guide2-user-defined-data"></a>

## User-defined Data

Custom attributes can be added to a VM to store metadata related to this specific VM instance. To add custom attributes simply use the `onevm update` command:

```default
$ onevm show 0
...

VIRTUAL MACHINE TEMPLATE
...
VMID="0"

$ onevm update 0
ROOT_GENERATED_PASSWORD="1234"
~
~

$ onevm show 0
...

VIRTUAL MACHINE TEMPLATE
...
VMID="0"

USER TEMPLATE
ROOT_GENERATED_PASSWORD="1234"
```

## Virtual Machine VM Permissions

OpenNebula comes with an advanced [ACL rules permission mechanism]({{% relref "../../cloud_system_administration/multitenancy/chmod#manage-acl" %}}) intended for administrators, but each VM object has also [implicit permissions]({{% relref "../../cloud_system_administration/multitenancy/chmod#chmod" %}}) that can be managed by the VM owner. To share a VM instance with other users or to allow them to list and show its information, use the `onevm chmod` command:

```default
$ onevm show 0
...
PERMISSIONS
OWNER          : um-
GROUP          : ---
OTHER          : ---

$ onevm chmod 0 640

$ onevm show 0
...
PERMISSIONS
OWNER          : um-
GROUP          : u--
OTHER          : ---
```

Administrators can also change the VM’s group and owner with the `chgrp` and `chown` commands.

<a id="life-cycle-ops-for-admins"></a>

## Advanced Operations for Administrators

There are some `onevm` commands operations meant for cloud administrators:

**Scheduling:**

- `resched`: Sets the reschedule flag for the VM. The Scheduler will migrate (or live-migrate, depending on the [Scheduler configuration]({{% relref "../../../product/cloud_system_administration/scheduler/configuration" %}})) the VM in the next monitorization cycle to a Host that better matches the requirements and rank restrictions. Read more in the [Scheduler documentation]({{% relref "../../../product/cloud_system_administration/scheduler/" %}}).

- `unresched`: Clears the reschedule flag for the VM, canceling the rescheduling operation.

**Deployment:**

- `deploy`: Starts an existing VM in a specific Host.
- `migrate --live`: The Virtual Machine is transferred between Hosts with no noticeable downtime. The VM storage cannot be migrated to other system datastores.
- `migrate`: The VM is stopped and resumed in the target Host. In an infrastructure with multiple system datastores, VM storage can also be migrated (by specifying the datastore ID).

Note: By default, the above operations do not check the target Host capacity. You can use the `--enforce` option to be sure that the Host capacity is not overcommitted.

**Troubleshooting:**

- `recover`: If the VM is stuck in any other state (or the boot operation does not work), you can recover the VM with the following options. Read the [Virtual Machine Failures guide]({{% relref "../../operation_references/opennebula_services_configuration/troubleshooting#ftguide-virtual-machine-failures" %}}) for more information.
  - `--success`: simulates the success of the missing driver action
  - `--failure`: simulates the failure of the missing driver action
  - `--retry`: tries to perform the current driver action again. Optionally the `--interactive` can be combined if it's a Transfer Manager problem
  - `--delete`: Deletes the VM, moving it to the DONE state immediately
  - `--recreate`: Deletes the VM and moves it to the PENDING state
- `migrate` or `resched`: A VM in the UNKNOWN state can be booted in a different Host manually (`migrate`) or automatically by the scheduler (`resched`). This action must be performed only if the storage is shared, or manually transferred by the administrator. OpenNebula will not perform any action on the storage for this migration.

<a id="remote-access-sunstone"></a>

## Accessing VM Console and Desktop

Sunstone provides several different methods to access your VM console and desktop: VNC, RDP, and SSH. If configured in the VM, these methods can be used to access the VM console through Sunstone. This section shows how these different technologies can be configured and what each requirement is.

[FireEdge]({{% relref "../../operation_references/opennebula_services_configuration/fireedge#fireedge-configuration" %}}) automatically installs dependencies for Guacamole connections which are necessary to use VNC, RDP, and SSH.

{{< alert title="Important" color="success" >}}
The [FireEdge]({{% relref "../../operation_references/opennebula_services_configuration/fireedge#fireedge-conf" %}}) server must be running to get Guacamole connections working.{{< /alert >}} 

<a id="requirements-remote-access-sunstone"></a>

<a id="vnc-sunstone"></a>

### Configuring Your VM for VNC

VNC is a graphical console with wide support among many hypervisors and clients.

To enable the VNC console service you must have a `GRAPHICS` section in the VM template,
as stated in the documentation. Make sure the attribute `IP` is set correctly (`0.0.0.0` to allow
connections from everywhere), otherwise no connections will be allowed from the outside.

For example, to configure this in the Virtual Machine template:

```none
GRAPHICS=[
    LISTEN="0.0.0.0",
    TYPE="vnc"
]
```

**Your browser must support websockets**, and have them enabled.

To configure it via Sunstone, you need to update the VM template. In the second step, Advanced options, under the Input/Output tab,
you can see the graphics section where you can add the IP, the port, a connection password,
or define your keymap.

![sunstone_guac_vnc](/images/sunstone_guac_vnc.png)

<a id="rdp-sunstone"></a>

### Configure VM for RDP

Short for **Remote Desktop Protocol**, it allows one computer to connect to another computer
over a network in order to use it remotely.

<a id="requirements-guacamole-rdp-sunstone"></a>

To enable RDP connections to the VM, you must have one `NIC`
with `RDP` attribute equal to `YES` in the template.

Via Sunstone, you need to enable an RDP connection on one of the VM template networks, **after or
before its instantiation**.

![sunstone_guac_nic_1](/images/sunstone_guac_nic_1.png)
![sunstone_guac_nic_2](/images/sunstone_guac_nic_2.png)

To configure this in the Virtual Machine template in **advanced mode**:

```none
NIC=[
    ...
    RDP = "YES"
]
```

Once the VM is instantiated, users will be able to **connect via browser**.

![sunstone_guac_rdp](/images/sunstone_guac_rdp.png)

RDP connection permits users to **choose the screen resolution** from Sunstone interface.

![sunstone_guac_rdp_interface](/images/sunstone_guac_rdp_interface.png)

{{< alert title="Important" color="success" >}}
**The RDP connection is only allowed to activate on a single NIC**. In any case, the connection will only contain the IP of the first NIC with this property enabled.
The RDP connection will work the **same way for NIC ALIASES**.{{< /alert >}}  

If the VM template has a `PASSWORD` and `USERNAME` set in the contextualization section, this will be reflected in the RDP connection. You can read about them in the [Virtual Machine Definition File reference section]({{% relref "../../operation_references/configuration_references/template#template-context" %}}).

{{< alert title="Note" color="success" >}}
If your Windows VM has a firewall enabled, you can set the following in the start script of the VM (in the Context section of the VM Template):

```
netsh advfirewall firewall set rule group="Remotedesktop" new enable=yes
```
{{< /alert >}} 

<a id="requirements-guacamole-ssh-sunstone"></a>

### Configure VM for SSH

Unlike VNC or RDP,
SSH is a text protocol. SSH connections require a hostname or IP address to define
the destination machine. As with the [RDP]({{% relref "#requirements-guacamole-rdp-sunstone" %}}) connections,
you need to enable the SSH connection on one of the VM template networks.

For example, to configure this in the Virtual Machine template in **advanced mode**:

```none
NIC=[
    ...
    SSH = "YES"
]
```

SSH is standardized to use port 22 and this will be the proper value in most cases. You only
need to specify the **SSH port in the contextualization section as** `SSH_PORT` if you are
not using the standard port.

{{< alert title="Note" color="success" >}}
If the VM template has a `PASSWORD` and `USERNAME` set in the contextualization section, this will be reflected in the SSH connection. You can read about them in the [Virtual Machine Definition File reference section]({{% relref "../../operation_references/configuration_references/template#template-context" %}}).{{< /alert >}} 

For example, to allow connection by username and password to a guest VM, first make sure you
have SSH root access to the VM, check more info [here]({{% relref "../../control_plane_configuration/graphical_user_interface/cloud_view#cloudview-ssh-keys" %}}).

After that you can access the VM and configure the SSH service:

```default
oneadmin@frontend:~$ ssh root@<guest-vm>

# Allow authentication with password: PasswordAuthentication yes
root@<guest-VM>:~$ vi /etc/ssh/sshd_config

# Restart SSH service
root@<guest-VM>:~$ service sshd restart

# Add user: username/password
root@<guest-VM>:~$ adduser <username>
```

![fireedge_sunstone_ssh_list](/images/fireedge_sunstone_ssh_list.png) ![fireedge_sunstone_ssh_console](/images/fireedge_sunstone_ssh_console.png)

{{< alert title="Note" color="success" >}}
Guacamole SSH uses RSA encryption. Make sure the VM SSH accepts RSA, otherwise you need to explicitly enable it in the VM SSH configuration (HostkeyAlgorithms and PubkeyAcceptedAlgorithms set as ‘+ssh-rsa){{< /alert >}} 
