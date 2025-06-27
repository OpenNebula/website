---
title: "SAN Datastore"
date: "2025-02-17"
description:
categories:
pageintoc: "72"
tags:
weight: "6"
---

<a id="lvm-drivers"></a>

<!--# SAN Datastore -->

This storage configuration assumes that Hosts have access to storage devices (LUNs) exported by an
Storage Area Network (SAN) server using a suitable protocol like iSCSI or Fibre Channel. The Hosts
will interface the devices through the LVM abstraction layer. Virtual Machines run from an LV
(logical volume) device instead of plain files. This reduces the overhead of having a filesystem in
place and thus it may increase I/O performance.

Disk images are stored in file format in the Image Datastore and then dumped into an LV when a
Virtual Machine is created. The image files are transferred to the Host through the SSH protocol.
Additionally, [LVM Thin]({{% relref "#lvm-thin" %}}) can be enabled to support creating thin
snapshots of the VM disks.

## SAN Appliance Configuration

First of all, you need to configure your SAN appliance to export the LUN(s) where VMs will be
deployed. Depending on the manufacturer the process may be slightly different, so please refer to
the specific guides if your hardware is on the supported list, or your hardware vendor guides
otherwise:

- [NetApp specific guide]({{% relref "/solutions/certified_hw_platforms/san_appliances/netapp_-_lvm_thin_validation/" %}})
- [PureStorage specific guide]({{% relref "/solutions/certified_hw_platforms/san_appliances/purestorage_-_lvm-thin_validation/" %}})

<a id="hosts-configuration"></a>

## Hypervisor Configuration

First we need to configure hypervisors for LVM operations over the shared SAN storage.

### Hosts LVM Configuration

* LVM2 must be available on Hosts.
* `lvmetad` must be disabled. Set this parameter in `/etc/lvm/lvm.conf`: `use_lvmetad = 0`, and disable the `lvm2-lvmetad.service` if running.
* `oneadmin` needs to belong to the `disk` group.
* All the nodes need to have access to the same LUNs.

{{< alert title="Note" color="success" >}}
In case of the virtualization Host reboot, the volumes need to be activated to be available for the hypervisor again. If the [node package]({{% relref "kvm_node_installation#kvm-node" %}}) is installed, the activation is done automatically. If not, each volume device of the Virtual Machines running on the Host before the reboot needs to be activated manually by running `lvchange -ay $DEVICE` (or, activation script `/var/tmp/one/tm/fs_lvm/activate` from the remote scripts may be executed on the Host to do the job).
{{< /alert >}}

Virtual Machine disks are symbolic links to the block devices. However, additional VM files like checkpoints or deployment files are stored under `/var/lib/one/datastores/<id>`. Be sure that enough local space is present.

### Hosts SAN Configuration

In the end, the abstraction required to access LUNs is just block devices. This means that there are
several ways to set them up, although it will usually involve using a network block protocol such as
iSCSI or Fibre Channel, as well as some way to make it redundant, like DM Multipath.

Here is a sample session for setting up access via iSCSI and multipath:

```
# === ISCSI ===

TARGET_IP="192.168.1.100"                             # IP of SAN appliance
TARGET_IQN="iqn.2023-01.com.example:storage.target1"  # iSCSI Qualified Name

# === Install tools ===
# RedHat derivates:
sudo dnf install -y iscsi-initiator-utils
# Ubuntu/Debian:
sudo apt update && sudo apt install -y open-iscsi

# === Enable iSCSI services ===
# RedHat derivates:
sudo systemctl enable --now iscsid
# Ubuntu/Debian:
sudo systemctl enable --now open-iscsi

# === Discover targets ===
sudo iscsiadm -m discovery -t sendtargets -p "$TARGET_IP"

# === Log in to the target ===
sudo iscsiadm -m node -T "$TARGET_IQN" -p "$TARGET_IP" --login

# === Make login persistent across reboots ===
sudo iscsiadm -m node -T "$TARGET_IQN" -p "$TARGET_IP" \
     --op update -n node.startup -v automatic


# === MULTIPATH ===

# === Install tools ===
# RedHat derivates:
sudo dnf install -y device-mapper-multipath
# Ubuntu/Debian:
sudo apt update && sudo apt install -y multipath-tools

# === Enable multipath daemon ===
sudo systemctl enable --now multipathd

# === Create multipath config file ===
sudo tee /etc/multipath.conf > /dev/null <<EOF
defaults {
    user_friendly_names yes
    find_multipaths yes
}
# Optional: blacklist local boot disks if needed
# blacklist {
#     devnode "^sd[a-z]"
# }
EOF

# === Reload multipath ===
sudo multipath -F    # Flush existing config (safely if not in use)
sudo multipath       # Re-scan for multipath devices
sudo systemctl restart multipathd

# === Show current multipath devices ===
sudo multipath -ll
```

<a id="frontend-configuration"></a>

## Front-end Configuration

The Front-end needs access to the shared SAN server in order to perform LVM operations. It can
either access it directly, or using some host(s) as proxy/bridge.

For direct access, **the Front-end will need to be configured in the same way as hosts** (following
the [previous section]({{% relref "#hosts-configuration" %}})), and no further configuration will
be needed. Example for illustration purposes:

```
-------------
| Front-end | ---- /dev/mapper/mpath* ------+
-------------     (iSCSI + multipath)       |
                                            v
  ---------                              --------------
  | host2 | ---- /dev/mapper/mpath* ---> | SAN server |
  ---------     (iSCSI + multipath)      --------------
                                            ^
                                            |
  ---------                                 |
  | hostN | ---- /dev/mapper/mpath* --------+
  ---------     (iSCSI + multipath)
```

Otherwise, one or several hosts can be used to perform the required operations by **defining the
`BRIDGE_LIST` attribute** on the Image Datastore later:

```
BRIDGE_LIST=host2

-------------
| Front-end |
-------------
      |
      | use as proxy for operations
      |
      v
  ---------                              --------------
  | host2 | ---- /dev/mapper/mpath* ---> | SAN server |
  ---------     (iSCSI + multipath)      --------------
                                            ^
                                            |
  ---------                                 |
  | hostN | ---- /dev/mapper/mpath* --------+
  ---------     (iSCSI + multipath)
```

## OpenNebula Configuration

First, we need to create the two required OpenNebula datastores: Image and System. Both of them will
use the `fs_lvm_ssh` transfer driver (TM_MAD).

### Create System Datastore

To create a new SAN/LVM System Datastore, you need to set the following (template) parameters:

| Attribute     | Description                       |
|---------------|-----------------------------------|
| `NAME`        | Name of Datastore                 |
| `TYPE`        | `SYSTEM_DS`                       |
| `TM_MAD`      | `fs_lvm_ssh`                      |
| `DISK_TYPE`   | `BLOCK` (used for volatile disks) |

For example:

```default
> cat ds_system.conf
NAME   = lvm_system
TM_MAD = fs_lvm_ssh
TYPE   = SYSTEM_DS
DISK_TYPE = BLOCK

> onedatastore create ds_system.conf
ID: 100
```

Afterwards, a **LVM VG needs to be created** in the shared LUNs for the system datastore **with the
following name: `vg-one-<system_ds_id>`**. This step just needs to be done once, either in one host,
or the front-end if it has access. This VG is where the actual VM images will be located at runtime,
and OpenNebula will take care of creating the LVs (one for each VM disk). For example, assuming
`/dev/mpatha` is the LUN (iSCSI/multipath) block device:

```
# pvcreate /dev/mpatha
# vgcreate vg-one-100 /dev/mpatha
```

### Create Image Datastore

To create a new LVM Image Datastore, you need to set following (template) parameters:

| Attribute         | Description                                                                                                 |
| ----------------- | ----------------------------------------------------------------------------------------------------------- |
| `NAME`            | Name of Datastore                                                                                           |
| `TYPE`            | `IMAGE_DS`                                                                                                  |
| `DS_MAD`          | `fs`                                                                                                        |
| `TM_MAD`          | `fs_lvm_ssh`                                                                                                |
| `DISK_TYPE`       | `BLOCK`                                                                                                     |
| `BRIDGE_LIST`     | List of Hosts with access to the file system where image files are stored before dumping to logical volumes |
| `LVM_THIN_ENABLE` | (default: `NO`) `YES` to enable [LVM Thin]({{% relref "#lvm-thin" %}}) functionality (RECOMMENDED).         |

The following example illustrates the creation of an LVM Image Datastore. In this case we will use the nodes `node1` and `node2` as our OpenNebula LVM-enabled Hosts.

```default
> cat ds_image.conf
NAME = lvm_image
DS_MAD = fs
TM_MAD = fs_lvm_ssh
DISK_TYPE = "BLOCK"
TYPE = IMAGE_DS
BRIDGE_LIST = "node1 node2"
LVM_THIN_ENABLE = yes
SAFE_DIRS="/var/tmp /tmp"

> onedatastore create ds_image.conf
ID: 101
```

{{< alert title="Warning" color="success" >}}
Please adapt this example to your case, in particular the [`BRIDGE_LIST`]({{% relref
"lvm_drivers#frontend-configuration" %}}) attribute, as discussed previously.
{{< /alert >}}

#### Front-end setup (Image Datastore)

The OpenNebula Front-end will keep the images used in the newly created Image Datastore in its
`/var/lib/one/datastores/<datastore_id>/` directory. The simplest case will just use the local
storage in the Front-end, but you can mount any storage medium in that directory to support more
advanced scenarios, such as sharing it via NFS in a [Front-end HA setup]({{% relref
"/product/control_plane_configuration/high_availability/frontend_ha/" %}}) or even using another LUN
in the same SAN to keep everything in the same place. Here are some (non-exhaustive) examples of
typical setups for the image datastore:

Option 1: image datastore local to frontend. Assuming the image datastore has ID 100:

```
# mkdir -p /var/lib/one/datastores/100/
# chown oneadmin:oneadmin /var/lib/one/datastores/100/
```

Option 2: image datastore in NFS. Assuming the image datastore has ID 100, and `nfs-server` exposes
a share `/srv/path_to_share`:

```
# echo "nfs-server:/srv/path_to_share /var/lib/one/datastores/100/ nfs4 defaults 0 2" >> /etc/fstab
# mount /var/lib/one/datastores/100/
# chown oneadmin:oneadmin /var/lib/one/datastores/100/
```

Option 3: image datastore in LVM. Assuming the image datastore has ID 100, and `/dev/sdb` contains
some block device (either local to frontend, or SAN):

```
# pvcreate /dev/sdb
# vgcreate image-vg /dev/sdb
# lvcreate -l 100%FREE -n image-lv image-vg
# mkfs.ext4 /dev/image-vg/image-lv
# mkdir -p /var/lib/one/datastores/100/
# echo "/dev/image-vg/image-lv /var/lib/one/datastores/100/ ext4 defaults 0 2" >> /etc/fstab
# mount /var/lib/one/datastores/100/
# chown oneadmin:oneadmin /var/lib/one/datastores/100/
```

{{< alert title="Note" color="success" >}}
Keep in mind that this last setup, from the OpenNebula point of view, is no different from the other
two. So, for example, no extra `vg-one-<dsid>` will need to be created for the image datastore,
that's only required for the system one.
{{< /alert >}}

<a id="lvm-thin"></a>

### LVM Thin

You have the option to toggle the LVM Thin functionality with the `LVM_THIN_ENABLE` attribute in the
**Image** Datastore. It is recommended that you enable this mode, as it allows some operations that
are not possible to do in the standard, non-thin mode:

- Creation of thin snapshots
- Consistent live backups

{{< alert title="Note" color="success" >}}
The `LVM_THIN_ENABLE` attribute can only be modified while there are no images on the datastore.
{{< /alert >}}

You can take a look at the [Datastore Internals]({{% relref "#datastore-internals" %}}) section for
more info about the differences in thin and non-thin operation.

<a id="lvm-driver-conf"></a>

### Driver Configuration

By default the LVM driver will zero any LVM volume so that VM data cannot leak to other instances. However, this process takes some time and may delay the deployment of a VM. The behavior of the driver can be configured in the file `/var/lib/one/remotes/etc/fs_lvm/fs_lvm.conf`, in particular:

| Attribute            | Description                                    |
|----------------------|------------------------------------------------|
| `ZERO_LVM_ON_CREATE` | Zero LVM volumes when they are created/resized |
| `ZERO_LVM_ON_DELETE` | Zero LVM volumes when VM disks are deleted     |
| `DD_BLOCK_SIZE`      | Block size for dd operations (default: 64kB)   |

Example:

```default
#  Zero LVM volumes on creation or resizing
ZERO_LVM_ON_CREATE=no

#  Zero LVM volumes on delete, when the VM disks are disposed
ZERO_LVM_ON_DELETE=yes

#  Block size for the dd commands
DD_BLOCK_SIZE=32M
```

The following attribute can be set for every datastore type:

* `SUPPORTED_FS`: Comma-separated list with every filesystem supported for creating formatted datablocks. Can be set in `/var/lib/one/remotes/etc/datastore/datastore.conf`.
* `FS_OPTS_<FS>`: Options for creating the filesystem for formatted datablocks. Can be set in `/var/lib/one/remotes/etc/datastore/datastore.conf` for each filesystem type.

{{< alert title="Warning" color="warning" >}}
Before adding a new filesystem to the `SUPPORTED_FS` list make sure that the corresponding `mkfs.<fs_name>` command is available in all Hosts including Front-end and hypervisors. If an unsupported FS is used by the user the default one will be used.{{< /alert >}}

<a id="datastore-internals"></a>

## Datastore Internals

Images are stored as regular files (under the usual path: `/var/lib/one/datastores/<id>`) in the Image Datastore, but they will be dumped into a Logical Volumes (LV) upon Virtual Machine creation. The Virtual Machines will run from Logical Volumes in the Host.

![image0](/images/fs_lvm_datastore.png)

{{< alert title="Note" color="success" >}}
Files are dumped directly from the Front-end to the LVs in the Host, using the SSH protocol.{{< /alert >}}

This is the recommended driver to be used when a high-end SAN is available. The same LUN can be exported to all the Hosts while Virtual Machines will be able to run directly from the SAN.

{{< alert title="Note" color="success" >}}
The LVM Datastore does **not** need CLVM configured in your cluster. The drivers refresh LVM metadata each time an image is needed on another Host.{{< /alert >}}

For example, consider a system with two Virtual Machines (`9` and `10`) using a disk, running in an LVM Datastore, with ID `0`. The Hosts have configured a shared LUN and created a volume group named `vg-one-0`. The layout of the Datastore would be:

```default
# lvs
  LV          VG       Attr       LSize Pool Origin Data%  Meta%  Move
  lv-one-10-0 vg-one-0 -wi------- 2.20g
  lv-one-9-0  vg-one-0 -wi------- 2.20g
```

### LVM Thin Internals

In this mode, every launched VM will allocate a dedicated **Thin Pool**, containing one **Thin LV** per disk. So, a VM (with id 11) with two disks would be instantiated as follows:

```default
# lvs
  LV              VG       Attr       LSize   Pool            Origin Data%  Meta%  Move Log Cpy%Sync Convert
  lv-one-11-0     vg-one-0 Vwi-aotz-- 256.00m lv-one-11-pool         48.44
  lv-one-11-1     vg-one-0 Vwi-aotz-- 256.00m lv-one-11-pool         48.46
  lv-one-11-pool  vg-one-0 twi---tz-- 512.00m                        48.45  12.60
```

The pool would be the equivalent to a typical LV, and it detracts its total size from the VG. On the other hand, per-disk Thin LVs are thinly provisioned and blocks are allocated in their associated pool.

{{< alert title="Note" color="success" >}}
This model makes over-provisioning easy, by having pools smaller than the sum of its LVs. The current version of this driver does not allow such cases to happen though, as the pool grows dynamically to be always able to fit all of its Thin LVs even if they were full.{{< /alert >}}

Thin LVM snapshots are just a special case of Thin LV, and can be created from a base Thin LV instantly and consuming no extra data, as all of their blocks are shared with its parent. From that moment, changed data on the active parent will be written in new blocks on the pool and so will start requiring extra space as the “old” blocks referenced by previous snapshots are kept unchanged.

Let’s create a couple of snapshots over the first disk of the previous VM. As you can see, snapshots are no different from Thin LVs at the LVM level:

```default
# lvs
  LV              VG       Attr       LSize   Pool            Origin       Data%  Meta%  Move Log Cpy%Sync Convert
  lv-one-11-0     vg-one-0 Vwi-aotz-- 256.00m lv-one-11-pool               48.44
  lv-one-11-0_s0  vg-one-0 Vwi---tz-k 256.00m lv-one-11-pool  lv-one-11-0
  lv-one-11-0_s1  vg-one-0 Vwi---tz-k 256.00m lv-one-11-pool  lv-one-11-0
  lv-one-11-1     vg-one-0 Vwi-aotz-- 256.00m lv-one-11-pool               48.46
  lv-one-11-pool  vg-one-0 twi---tz--   1.00g                              24.22  12.70
```

For more details about the inner workings of LVM, please refer to the [lvmthin(7)](https://man7.org/linux/man-pages/man7/lvmthin.7.html) main page.


## Troubleshooting

### LVM Devices File

**Problem:** LVM does not show my iSCSI/multipath devices (with e.g., `pvs`), although I can see them
with `multipath -ll` or `lsblk`.

**Possible solution:**

The LVM version in some operating systems or Linux distributions, by default,
doesn't scan the whole `/dev` directory for possible disks. Instead, you need to explicitly
**whitelist** them in `/etc/lvm/devices/system.devices`. You can check whether that's your case by
running:

```
lvmconfig --type full devices/use_devicesfile
```

If it returns `devices/use_devicesfile=1`, then the devices file is being used and enforced. In that
case, just add the device path to the whitelist and check again:

```
# echo /dev/mapper/mpatha >> /etc/lvm/devices/system.devices
# pvs
```
