---
title: "Ceph Datastore"
date: "2025-02-17"
description:
categories:
pageintoc: "71"
tags:
weight: "5"
---

<a id="ceph-ds"></a>

<!--# Ceph Datastore -->

The Ceph Datastore driver allows the use of Ceph storage for images and disks of Virtual Machines.

{{< alert title="Warning" color="warning" >}}
This driver requires the OpenNebula nodes using the Ceph driver to be Ceph clients of a running Ceph Cluster. More information in [Ceph documentation](https://docs.ceph.com/en/latest/).{{< /alert >}} 

## Ceph Cluster Setup

This guide assumes that you already have a functional Ceph Cluster in place. Additionally you need to:

* Create a pool for the OpenNebula Datastores. Write down the name of the pool to include it in the datastore definitions.

```default
$ ceph osd pool create one 128
$ ceph osd pool application enable one rbd
$ rbd pool init -p one
$ ceph osd lspools
0 data,1 metadata,2 rbd,6 one,
```

* Define a Ceph user to access the datastore pool; this user will also be used by libvirt to access the disk images. For example, create the user `libvirt`:

On the **Ceph Jewel** (v10.2.x and earlier):

```default
$ ceph auth get-or-create client.libvirt \
      mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=one'
```

On the **Ceph Luminous** (v12.2.x and later):

```default
$ ceph auth get-or-create client.libvirt \
      mon 'profile rbd' osd 'profile rbd pool=one'
```

{{< alert title="Warning" color="warning" >}}
Ceph Luminous release comes with simplified RBD capabilities (more information about user management and authorization capabilities is in the Ceph [documentation](https://docs.ceph.com/en/latest/rados/operations/user-management/#authorization-capabilities)). When **upgrading existing Ceph deployment to the Luminous and later**, please ensure the selected user has the proper new capabilities. For example, for the above user `libvirt` you can do this by running:

```default
$ ceph auth caps client.libvirt \
      mon 'profile rbd' osd 'profile rbd pool=one'{{< /alert >}}  
```

* Get a copy of the key of this user to distribute it later to the OpenNebula Nodes.

```default
$ ceph auth get-key client.libvirt | tee client.libvirt.key

$ ceph auth get client.libvirt -o ceph.client.libvirt.keyring
```

* Although RBD format 1 is supported it is strongly recommended to use Format 2. Check that `ceph.conf` includes:

```default
[global]
rbd_default_format = 2
```

* Pick a set of client nodes of the cluster to act as storage bridges. These nodes will be used to import images into the Ceph Cluster from OpenNebula. These nodes must have the `qemu-img` command installed.

{{< alert title="Note" color="success" >}}
For production environments it is recommended to **not collocate** Ceph services (monitor, osds) with OpenNebula Nodes or the Front-end{{< /alert >}} 

## Front-end and Hosts Setup

In order to use the Ceph Cluster the Hosts need to be configured as follows:

* The Ceph client tools must be available in the machine.
* The `mon` daemon must be defined in the `ceph.conf` for all the nodes, so `hostname` and `port` doesn’t need to be specified explicitly in any Ceph command.
* Copy the Ceph user keyring (`ceph.client.libvirt.keyring`) to the nodes under `/etc/ceph`, and the user key (`client.libvirt.key`) to the oneadmin home.

```default
$ scp ceph.client.libvirt.keyring root@node:/etc/ceph

$ scp client.libvirt.key oneadmin@node:
```

## Hosts Setup

Hosts need extra steps to set up credentials in libvirt:

* Generate a secret for the Ceph user and copy it to the nodes under oneadmin home. Write down the `UUID` for later use:

```default
$ UUID=`uuidgen`; echo $UUID
c7bdeabf-5f2a-4094-9413-58c6a9590980

$ cat > secret.xml <<EOF
<secret ephemeral='no' private='no'>
  <uuid>$UUID</uuid>
  <usage type='ceph'>
          <name>client.libvirt secret</name>
  </usage>
</secret>
EOF

$ scp secret.xml oneadmin@node:
```

* Define a libvirt secret and remove key files in the nodes:

```default
$ virsh -c qemu:///system secret-define secret.xml

$ virsh -c qemu:///system secret-set-value --secret $UUID --base64 $(cat client.libvirt.key)

$ rm client.libvirt.key
```

* The `oneadmin` account needs to access the Ceph Cluster using the `libvirt` Ceph user defined above. This requires access to the Ceph user keyring. Test that the Ceph client is properly configured in the node:

```default
$ ssh oneadmin@node

$ rbd ls -p one --id libvirt
```

You can read more information about this in the Ceph guide [Using libvirt with Ceph](https://docs.ceph.com/en/latest/rbd/libvirt/).

* Ancillary Virtual Machine files like context disks, deployment, and checkpoint files are created on the nodes under `/var/lib/one/datastores/`. Make sure that enough storage for these files is provisioned on the nodes.
* If you are going to use the SSH mode, you have to take into account the space needed for the System Datastore `/var/lib/one/datastores/<ds_id>` where `ds_id` is the ID of the System Datastore.

<a id="ceph-ds-templates"></a>

### LXC Hosts

The `rbd-nbd` utility must be installed on LXC hosts. Check the [LXC Node Installation]({{% relref "lxc_node_installation#lxc-node" %}}).

## OpenNebula Configuration

To use your Ceph Cluster with the OpenNebula, you need to define both System and Image Datastores. Each Image/System Datastore pair will share the following same Ceph configuration attributes:

| Attribute      | Description                                                                                | Mandatory   |
|----------------|--------------------------------------------------------------------------------------------|-------------|
| `NAME`         | Name of datastore                                                                          | **YES**     |
| `POOL_NAME`    | The Ceph pool name, by default `one`                                                       | NO          |
| `CEPH_USER`    | The Ceph user name, used by libvirt and rbd commands.                                      | **YES**     |
| `CEPH_KEY`     | Key file for user, if not set default locations are<br/>used                               | NO          |
| `CEPH_CONF`    | Non-default Ceph configuration file if needed.                                             | NO          |
| `RBD_FORMAT`   | By default RBD Format 2 will be used.                                                      | NO          |
| `BRIDGE_LIST`  | List of storage bridges to access the Ceph Cluster                                         | **YES**     |
| `CEPH_HOST`    | Space-separated list of Ceph monitors. Example: `host1<br/>host2:port2 host3 host4:port4`. | **YES**     |
| `CEPH_SECRET`  | The UUID of the libvirt secret.                                                            | **YES**     |
| `EC_POOL_NAME` | Name of Ceph erasure coded pool                                                            | NO          |
| `CEPH_TRASH`   | Enables trash feature on given datastore (Luminous+),<br/>values: yes|no                   | NO          |

{{< alert title="Note" color="success" >}}
You may add another Image and System Datastore pointing to other pools with different allocation/replication policies in Ceph.{{< /alert >}} 

{{< alert title="Note" color="success" >}}
Ceph Luminous release allows use of erasure coding for `RBD` images. In general, erasure-coded images take up less space but have worse I/O performance. Erasure coding can be enabled on Image and/or System Datastores by configuring `EC_POOL_NAME` with the name of the erasure-coded data pool. Regular replicated Ceph pool `POOL_NAME` is still required for image metadata. More information in [Ceph documentation](https://docs.ceph.com/en/latest/rados/operations/erasure-code/#erasure-coding-with-overwrites).{{< /alert >}} 

{{< alert title="Warning" color="warning" >}}
In order to place the `ceph.conf` file in a non-default location (i.e., other than `/etc/ceph/ceph.conf`), please perform the following steps.

1. On all nodes listed in `BRIDGE_LIST` configuration attribute of ceph-based DS, move the `ceph.conf` file into the desired location:

```default
$ sudo mv /etc/ceph/ceph.conf /etc/ceph/ceph1.conf
```

Extract and save the Ceph key into a separate file (it has to contain only the key, nothing else):

```default
$ sudo grep -o -P '(?<=key = ).*(?=)' /etc/ceph/ceph.client.oneadmin.keyring >> /etc/ceph/ceph.client.oneadmin.key
```

2. Add two configuration attributes:
   > - `CEPH_CONF` configuration attribute with absolute path to the custom location of `ceph.conf` file.
   > - `CEPH_KEY` configuration attribute with absolute path to the location of the ceph key file saved in the previous step.

```default
$ onedatastore update <DS_ID>
CEPH_CONF="/etc/ceph/ceph1.conf"
CEPH_KEY="/etc/ceph/ceph.client.oneadmin.key"
```

None of the services need to be restarted.
{{< /alert >}}

### Create System Datastore

System Datastore also requires these attributes:

| Attribute                                           | Description                                            | Mandatory   |
|-----------------------------------------------------|--------------------------------------------------------|-------------|
| `TYPE`                                              | `SYSTEM_DS`                                            | **YES**     |
| `TM_MAD`                                            | `ceph`  to use the full Ceph mode, see Ceph mode below | **YES**     |
| `ssh` to use local Host storage, see SSH mode below |                                                        |             |
| `DISK_TYPE`                                         | `RBD` (used for volatile disks)                        | **NO**      |

Create a System Datastore in Sunstone or through the CLI, for example:

```default
$ cat systemds.txt
NAME    = ceph_system
TM_MAD  = ceph
TYPE    = SYSTEM_DS
DISK_TYPE = RBD

POOL_NAME   = one
CEPH_HOST   = "host1 host2:port2"
CEPH_USER   = libvirt
CEPH_SECRET = "6f88b54b-5dae-41fe-a43e-b2763f601cfc"

BRIDGE_LIST = cephfrontend

$ onedatastore create systemds.txt
ID: 101
```

{{< alert title="Note" color="success" >}}
When different System Datastores are available the `TM_MAD_SYSTEM` attribute will be set after picking the datastore.{{< /alert >}} 

### Create  Image Datastore

Apart from the previous attributes, which need to be the same as the associated System Datastore, the following can be set for an Image Datastore:

| Attribute     | Description                                      | Mandatory   |
|---------------|--------------------------------------------------|-------------|
| `NAME`        | Name of datastore                                | **YES**     |
| `DS_MAD`      | `ceph`                                           | **YES**     |
| `TM_MAD`      | `ceph`                                           | **YES**     |
| `DISK_TYPE`   | `RBD`                                            | **YES**     |
| `STAGING_DIR` | Default path for image operations in the bridges | NO          |

An example of datastore:

```default
> cat ds.conf
NAME = "cephds"
DS_MAD = ceph
TM_MAD = ceph

DISK_TYPE = RBD

POOL_NAME   = one
CEPH_HOST   = "host1 host2:port2"
CEPH_USER   = libvirt
CEPH_SECRET = "6f88b54b-5dae-41fe-a43e-b2763f601cfc"

BRIDGE_LIST = cephfrontend

> onedatastore create ds.conf
ID: 101
```

{{< alert title="Warning" color="warning" >}}
If you are going to use the `TM_MAD_SYSTEM` attribute with **SSH** mode, you need to have an [SSH type System Datastore]({{% relref "local_ds#local-ds" %}}) configured.{{< /alert >}} 

### Additional Configuration

Default values for the Ceph drivers can be set in `/var/lib/one/remotes/etc/datastore/ceph/ceph.conf`:

* `POOL_NAME`: Default volume group.
* `STAGING_DIR`: Default path for image operations in the storage bridges.
* `RBD_FORMAT`: Default format for RBD volumes.
* `DD_BLOCK_SIZE`: Block size for dd operations (default: 64kB).
* `SUPPORTED_FS`: Comma-separated list with every file system supported for creating formatted datablocks. Can be set in `/var/lib/one/remotes/etc/datastore/datastore.conf`.
* `FS_OPTS_<FS>`: Options for creating the file system for formatted datablocks. Can be set in `/var/lib/one/remotes/etc/datastore/datastore.conf` for each file system type.

{{< alert title="Warning" color="warning" >}}
Before adding a new file system to the `SUPPORTED_FS` list, make sure that the corresponding `mkfs.<fs_name>` command is available in all nodes including Front-end and hypervisor nodes. If an unsupported FS is used by the user the default one will be used.{{< /alert >}} 

### Using different modes

When creating a VM Template you can choose to deploy the disks using the default Ceph mode or the SSH one. Note that the same mode will be used for all disks of the VM. To set the deployment mode, add the following attribute to the VM template:

* `TM_MAD_SYSTEM="ssh"`

When using Sunstone, the deployment mode needs to be set in the Storage tab.

## Datastore Internals

Images are stored in a Ceph pool, named after its OpenNebula ID `one-<IMAGE ID>`. Virtual Machine disks are stored by default in the same pool (Ceph Mode). You can also choose to export the Image rbd to the hypervisor local storage using the SSH Mode.

{{< alert title="Important" color="success" >}}
It is necessary to register each image only once, then it can be deployed using any mode (**ceph** or **SSH**).{{< /alert >}} 

### Ceph Mode (Default)

In this mode, Virtual Machines will use the same Image rbd volumes for their disks (persistent images), or a new snapshots of the image created in the form `one-<IMAGE ID>-<VM ID>-<DISK ID>` (non-persistent images).

For example, consider a system using an Image and System Datastore backed by a Ceph pool named `one`. The pool with one Image (ID `0`) and two Virtual Machines `14` and `15` using this Image as virtual disk `0` would be similar to:

```default
$ rbd ls -l -p one --id libvirt
NAME         SIZE PARENT         FMT PROT LOCK
one-0      10240M                  2
one-0@snap 10240M                  2 yes
one-0-14-0 10240M one/one-0@snap   2
one-0-15-0 10240M one/one-0@snap   2
```

{{< alert title="Note" color="success" >}}
In this case, context disk and auxiliary files (deployment description and checkpoints) are stored locally in the nodes.{{< /alert >}} 

<a id="ceph-ssh-mode"></a>

### SSH Mode

In this mode, the associated rbd file for each disk is exported to a file and stored in the local file system of the hypervisor.

For instance, in the previous example, if the VM `14` is set to be deployed in an SSH System Datastore (e.g., `100`), the layout of the datastore in the hypervisor would be similar to:

```default
$ ls -l /var/lib/one/datastores/100/14
total 609228
-rw-rw-r-- 1 oneadmin oneadmin        1020 Dec 20 14:41 deployment.0
-rw-r--r-- 1 oneadmin oneadmin 10737418240 Dec 20 15:19 disk.0
-rw-rw-r-- 1 oneadmin oneadmin      372736 Dec 20 14:41 disk.1
```

{{< alert title="Note" color="success" >}}
In this case disk.0 is generated with a command similar to `rbd export one/one-0@snap disk.0`{{< /alert >}} 

{{< alert title="Warning" color="warning" >}}
In this mode there are some inherent limitations:

* disk snapshots are not supported
* VM disk cannot be saved when located on the Front-end (undeployed or stopped VM){{< /alert >}}  
