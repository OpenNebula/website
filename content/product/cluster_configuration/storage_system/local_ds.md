---
title: "Local Storage Datastore"
date: "2025-02-17"
description:
categories:
pageintoc: "70"
tags:
weight: "4"
---

<a id="local-ds"></a>

<!--# Local Storage Datastore -->

This storage configuration uses the local storage area of each Host to run VMs. Additionally you’ll need a storage area for the VM disk image repository. Disk images are transferred from the repository to the Hosts using the SSH protocol.

## Front-end Setup

The Front-end needs to prepare the storage area for:

* **Image Datastores** to store the image repository.
* **System Datastores** to hold temporary disks and files for VMs `stopped` and `undeployed`.

Simply make sure that there is enough space under `/var/lib/one/datastores` to store images and the disks of the `stopped` and `undeployed` Virtual Machines. Note that `/var/lib/one/datastores` **can be mounted from any NAS/SAN server in your network**.

## Host Setup

Just make sure that there is enough space under `/var/lib/one/datastores` to store the disks of running VMs on that Host.

{{< alert title="Warning" color="warning" >}}
Local datastore requires that:
- The **Frontend hostnames are resolvable** from all Hosts.
- Every Host (including the Front-end) can **SSH to every other Host**, including themselves.

Otherwise, migrations and image transfers may fail.{{< /alert >}}  

## OpenNebula Configuration

Once the Hosts and Front-end storage is set up, configuring OpenNebula comprises the creation of an Image and System Datastores.

### Create System Datastore

To create a new System Datastore, you need to set the following (template) parameters:

| Attribute   | Description       |
|-------------|-------------------|
| `NAME`      | Name of datastore |
| `TYPE`      | `SYSTEM_DS`       |
| `TM_MAD`    | `local`           |

You can do this either in Sunstone or through the CLI; for example, to create a local System Datastore simply enter:

```default
$ cat systemds.txt
NAME    = local_system
TM_MAD  = local
TYPE    = SYSTEM_DS

$ onedatastore create systemds.txt
ID: 101
```

{{< alert title="Note" color="success" >}}
When different System Datastores are available, the `TM_MAD_SYSTEM` attribute will be set after selecting the Datastore.{{< /alert >}} 

### Create Image Datastore

To create a new Image Datastore, you need to set the following (template) parameters:

| Attribute   | Description                                              |
|-------------|----------------------------------------------------------|
| `NAME`      | Name of datastore                                        |
| `DS_MAD`    | `fs`                                                     |
| `TM_MAD`    | `local`                                                  |
| `CONVERT`   | `yes` (default) or `no`. Change Image format to `DRIVER` |

For example, the following illustrates the creation of a Local Datastore:

```default
$ cat ds.conf
NAME   = local_images
DS_MAD = fs
TM_MAD = local

$ onedatastore create ds.conf
ID: 100
```

Also note that there are additional attributes that can be set. Check the [datastore template attributes]({{% relref "datastores#datastore-common" %}}).

{{< alert title="Warning" color="warning" >}}
Be sure to use the same `TM_MAD` for both the System and Image datastores. When combining different transfer modes, check the section below.{{< /alert >}} 

### Additional Configuration

* `DD_BLOCK_SIZE`: Block size for dd operations (default: 64kB). Can be set in `/var/lib/one/remotes/etc/datastore/fs/fs.conf`.
* `SUPPORTED_FS`: Comma-separated list of every filesystem supported for creating formatted datablocks. Can be set in `/var/lib/one/remotes/etc/datastore/datastore.conf`.
* `FS_OPTS_<FS>`: Options for creating the filesystem for formatted datablocks. Can be set in `/var/lib/one/remotes/etc/datastore/datastore.conf` for each filesystem type.
* `SPARSE`: If set to `NO` the images and disks in the image and system Datastore, respectively, will not be sparsed (i.e. the files will use all assigned space on the Datastore filesystem).

{{< alert title="Warning" color="warning" >}}
Before adding a new filesystem to the `SUPPORTED_FS` list make sure that the corresponding `mkfs.<fs_name>` command is available in the Front-end and hypervisor Hosts. If an unsupported FS is used by the user the default one will be used.{{< /alert >}}

{{< alert title="Note" color="success" >}}
When using a Local Storage Datastore the `QCOW2_OPTIONS` attribute is ignored since the cloning script uses the `tar` command instead of `qemu-img`.{{< /alert >}} 

## Datastore Drivers

<a id="local-ds-drivers"></a>

There are currently two Local transfer drivers:

- **local**: reference Local driver since OpenNebula 6.10.2, used by default for newly-created datastores. Supports operations such as thin provisioning for images in qcow2 format.
- **ssh**: legacy but still supported for compatibility reasons. Unable to leverage advanced qcow2 features.

## Datastore Internals

Images are saved into the corresponding datastore directory (`/var/lib/one/datastores/<DATASTORE ID>`). Also, for each running Virtual Machine there is a directory (named after the `VM ID`) in the corresponding System Datastore. These directories contain the VM disks and additional files, e.g., checkpoint or snapshots.

For example, a system with an Image Datastore (`1`) with three images and three Virtual Machines (VMs 0 and 2 running, and VM 7 stopped) running from System Datastore `0` would present the following layout:

```default
/var/lib/one/datastores
|-- 0/
|   |-- 0/
|   |   |-- disk.0
|   |   `-- disk.1
|   |-- 2/
|   |   `-- disk.0
|   `-- 7/
|       |-- checkpoint
|       `-- disk.0
`-- 1
    |-- 05a38ae85311b9dbb4eb15a2010f11ce
    |-- 2bbec245b382fd833be35b0b0683ed09
    `-- d0e0df1fb8cfa88311ea54dfbcfc4b0c
```

{{< alert title="Note" color="success" >}}
The canonical path for `/var/lib/one/datastores` can be changed in [/etc/one/oned.conf]({{% relref "../../operation_references/opennebula_services_configuration/oned#oned-conf" %}}) by modifying the `DATASTORE_LOCATION` configuration attribute.{{< /alert >}}

In this case, the System Datastore is distributed among the Hosts. The **local** transfer driver uses the Hosts' local storage to place the images of running Virtual Machines. All of the operations are then performed locally, but images still need to be copied to the Hosts, which can be a very resource-demanding operation.

![><](/images/fs_ssh.png)

