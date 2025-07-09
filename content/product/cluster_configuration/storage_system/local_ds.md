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
Make sure all the Hosts, including the Front-end, can SSH to any other Host (including themselves), otherwise migrations will not work.{{< /alert >}} 

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

## Distributed Cache

To improve the speed of VM provisioning and reduce bandwidth consumption when using Local Storage Datastores, OpenNebula supports a two-tier distributed cache mechanism. This section describes how to enable and use the cache, and the benefits it provides.

### What is the Distributed Cache?

The distributed cache maintains VM disk images in two levels:

1. **Local Cache (per Host)**: Each compute host keeps a small cache of the images it has already retrieved.

2. **Central (Upstream) Cache**: One or more “central” cache nodes (typically the hosts with the most resources) maintain a larger pool of images shared by the entire cluster.

When a VM is instantiated, the Host first checks its *local cache* for the needed image. If missing, it then checks the *central cache*. Only if the image is not found in either cache does the Host request it from the Image Datastore on the Front-end. Once retrieved from the Front-end, the image is stored in both caches for future reuse.

![><](/images/local_ds_cache.png)

## How to Enable and Configure the Cache

The Cache is configured per **Image Datastore**. In other words, each Image Datastore in OpenNebula that uses the local TM driver defines its own cache settings. The cache settings are described in the next table:


| Attribute         | Description                                                                                                                                                           | Deault value         |
|-------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------|
| `ENABLE_CACHE`    | Set to `yes` to enable the distributed cache for this Image Datastore, or `no` to disable it.                                                                         | `NO`                 |
| `CACHE_PATH`      | Absolute directory where cached images will be stored (e.g., `/var/lib/one/cache`).                                                                                   | `/var/lib/one/cache` |
| `CACHE_MAX_SIZE`  | Maximum percentage (integer value) of the local filesystem (where `CACHE_PATH` resides) allocated for caching. For example, "10" means 10 % of that disk may be used. | `10`                 |
| `CACHE_UPSTREAMS` | Comma-separated list of one or more “central” cache hostnames or IPs (e.g., `'hostname0,hostname1'`). Leave empty (`''`) to disable central caches.                   | `''` (no upstreams)  |
| `CACHE_MIN_AGE`   | Minimum age in seconds before a cached image can be evicted. For example, "3600" means that any image used within the last hour cannot be removed from cache.         | `0`                  |


For example, to configure a Distributed Cache update the image datastore template with the following parameters:

```default
ENABLE_CACHE    = "YES"
CACHE_PATH      = "/var/lib/one/cache"
CACHE_MAX_SIZE  = "10"
CACHE_UPSTREAMS = "hostname0,hostname2"
CACHE_MIN_AGE   = "3600"
```

{{< alert title="Note" color="success" >}}
For the distributed cache to work, the `oneadmin` user (see [Node installation]({{% relref "../../../product/operation_references/hypervisor_configuration" %}})) must have SSH passwordless authentication configured on all Hosts.{{< /alert >}}

## Using the Cache

When a VM is launched or migrated, the cache manager performs the following three steps:

1. **Local Cache Check:** The cache manager checks the local cache for the image. If it is found and still valid (modtime matches the one in the Image Datastore), it returns the local path.

2. **Upstream Cache Check:** If missing locally (or invalid), the cache manager iterates through each `CACHE_UPSTREAMS`. If an image is found on an upstream Host, it stores a copy locally and returns that path.

3. **Fallback to Front-End:** If not found in any cache, it falls back to retrieving the image from the Image Datastore on the Front-end, then stores it both locally and on the central cache.

In each Host's cache path (e.g. `/var/lib/one/cache/`) cached images appear as two files:

```default
/var/lib/one/cache/1/
├── c3af91e2b1d2ab9f64a25d99f9a2fbd2
└── c3af91e2b1d2ab9f64a25d99f9a2fbd2-metadata
```

The metadata is a YAML file which contains:

```default
last_used: "2025-05-30T14:22:10Z"       # ISO 8601 timestamp of the most recent cache hit
modtime:   "1725552553"                 # Last OpenNebula image modification time
```

## Eviction Policy.

When the total size of cached files exceeds the `CACHE_MAX_SIZE` threshold, the cache manager automatically removes the Least-Recently-Used (LRU) entries until there is enough room for the incoming image. If after evicting all eligible entries there is still insufficient space to store a new image, the caching operation fails and the VM instantiation proceeds by fetching directly from the Front-end without caching.

{{< alert title="Warning" color="warning" >}}
Images used within the last `CACHE_MIN_AGE` seconds are exempt from eviction.{{< /alert >}}

