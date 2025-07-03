---
title: "Failover Recovery"
weight: 4
---

## General Steps Overview

A common scenario is that the source cluster, in this guide "**Site A**", suffers a failure, and we want to fail over to the target cluster, **Site B**.

In a simplified scenario, the basic high-level steps are:

1. On Site A, export the VM image file for the VM that will run on Site B.
1. On Site B, create the VM image file from the export in the previous step.
1. On Site A, export the VM template for the VM that will run on Site B.
1. On Site B, promote the desired RBD images or the whole image pool.
1. On Site B, create the VM from the VM template .
1. On Site B, instantiate the VM.

This guide describes these steps in more detail, and provides additional steps such as for testing the failover procedure with both Ceph clusters active.


## Failover Procedure

The failover procedure begins by promoting the mirrored RBD images on Site B using `rbd mirror image promote`. This command makes the images writable, and thus makes it possible to power on Virtual Machines on the target Ceph cluster and run them without I/O errors. Once a Ceph image is promoted, a VM can be recreated based on its template metadata that is stored on the source Ceph image.

### Create Disk Images

Create a new image file for registering on Site B. This image file will be based on the information from the parent image at Site A and the Ceph virtual disk name. Note that the image file **must** be set as `persistent`.

For example:

```default
NAME="alpine-0-rep"
USER="oneadmin"
GROUP="oneadmin"
DATASTORE="default"
TYPE="OS"
PERSISTENT="yes"
SOURCE="one/one-0-0-0"
FORMAT="raw"
SIZE="256"
DEV_PREFIX="vd"
```

To register the image on Site B, as user `oneadmin` run:

```bash
oneimage create disk -d 1
```

{{< alert title="Note" color="success" >}}
When creating the image, ensure that no VM has any configuration that is specific only to the source cluster, such as an attached ISO image or storage for disk images with paths that are unavailable in the target cluster.
{{< /alert >}}

On Site B, check the mirroring status of the specific Ceph image, in this case `one/one-0-0-0`:

```bash
rbd mirror image status one/one-0-0-0
```

For example:

```default
site-b $ rbd mirror image status one/one-0-0-0
one-0-0-0:
  global_id:   f0523ef9-a784-420f-8725-c3f81ff5a302
  state:       up+replaying
  description: replaying, {"bytes_per_second":0.0,"entries_behind_primary":0,"entries_per_second":0.0,"non_primary_position":{"entry_tid":3,"object_number":3,"tag_tid":6},"primary_position":{"entry_tid":3,"object_number":3,"tag_tid":6}}
  service:     ubuntu2204-kvm-ceph-squid-6-10-cqyoo-0 on ubuntu2204-kvm-ceph-squid-6-10-cqyoo-0
  last_update: 2025-06-09 14:28:20
```

### Create VM Templates

Prepare a VM template file based on the desired VM from site A. Example information for the template:

```default
NAME="alpine-0-rep"
USER="oneadmin"
GROUP="oneadmin"
ARCH="x86_64"
CONTEXT=[
  DISK_ID="1",
  ETH0_DNS="",
  ETH0_EXTERNAL="",
  ETH0_GATEWAY="192.168.150.1",
  ETH0_IP="192.168.150.100",
  ETH0_IP6="",
  ETH0_IP6_GATEWAY="",
  ETH0_IP6_METHOD="",
  ETH0_IP6_METRIC="",
  ETH0_IP6_PREFIX_LENGTH="",
  ETH0_IP6_ULA="",
  ETH0_MAC="02:00:c0:a8:96:64",
  ETH0_MASK="",
  ETH0_METHOD="",
  ETH0_METRIC="",
  ETH0_MTU="",
  ETH0_NETWORK="",
  ETH0_SEARCH_DOMAIN="",
  ETH0_VLAN_ID="",
  ETH0_VROUTER_IP="",
  ETH0_VROUTER_IP6="",
  ETH0_VROUTER_MANAGEMENT="",
  NETWORK="YES",
  SSH_PUBLIC_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCYz+lkZoNyspRhrtXDKFN3cIEwN3w08mz0YGKpVDIiV0+/vgG8dAUQ70Irs3m83W9BHN+vNjKPgKcF+X+sSfxniOtavahxGCRjAhhs1IVm196C5ODbSgXVUWULdtmMHelXbLBJ8X340h/UO+eQ6eRLaRfslXUsgRqremVcvCCPz4LIuRiliGWiELAmqYcY+1zJLeg3QV2Pgn5vschM9e/A4AseKO+HnbGB/I5tnoeZT/Gc3FGfUZLNFVB2XsVGAEEzkqO8VI2msB7MCAZBHffIK6WfLIYgGP6Ha2JT1NWJU7Ncj9Xuql0ElF01VwWMDWzqc0DOiVSsTL89ugJKU6+h one",
  TARGET="hda" ]
CPU="0.1"
GRAPHICS=[
  LISTEN="0.0.0.0",
  PORT="5900",
  TYPE="vnc" ]
MEMORY="96"
NIC_DEFAULT=[
  MODEL="virtio" ]
OS=[
  UUID="417177d9-5765-44d7-9033-4f75572519a2" ]
TM_MAD_SYSTEM="ceph"
```

Prepare a text file with the information derived from the VM. This text file will be your VM template, which you will later use to create the Virtual Machine on Site B, as explained [below](#create-the-vm-at-site-b).

{{< alert title="Note" color="success" >}}
To ensure that the new VM obtains IP addresses from the range available at Site B, you many need to modify the template and remove the Network context, if at Site B other virtual networks overlap with the IP address ranges specified in the file.
{{< /alert >}}

### Testing Failover with Both Sites Available

If you are testing failover with both Site A and Site B available, you will need to take these additional actions:

#### Power Off Virtual Machines

In order to prevent data loss in VMs that will be deployed on Site B, first power them off on Site A:

```bash
onevm poweroff <VM ID>
```

### Demote Ceph Images or Pool on Site A

Before promoting the images on Site B, demote them on Site A. To demote an image, in this case `one/one-0-0-0`:

```bash
rbd mirror pool demote one/one-0-0-0
```

You can also demote all images in the pool, but note that this will take effect only for images which were previously flattened:

```bash
rbd mirror pool demote one
```

Then, on Site B you can proceed to promoting the Ceph images, explained below.

{{< alert title="Tip" >}}
For more details on image promotion and demotion see the [Ceph Documentation](https://docs.ceph.com/en/mimic/rbd/rbd-mirroring/#image-promotion-and-demotion).
{{< /alert >}}

### Promoting Ceph Images

By promoting an image or an image pool, we tell Ceph that the image or pool is now _primary_, and should be used with precedence over non-primary images. Promoting images makes them writeable, and is a necessary step to ensure proper VM operation.

As mentioned [above](#demote-ceph-images-or-pool-on-site-a), if Site A is available, images on Site A should be demoted before images on Site B are promoted.

{{< alert title="Warning" color="warning" >}}
If you start the VMs on Site B without promoting the image, the VM will start but will quickly begin to report I/O errors, since the target Ceph images are non-primary and non-writeable.
{{< /alert >}}

If Site A is available, to promote a specific image at Site B run:

```bash
rbd mirror image promote one/one-0-0-0
```

Or to promote the whole pool:

```bash
rbd mirror pool promote one
```

If Site A is unavailable, then to promote the image or pool you must run the command with the `--force` flag, for example:

```bash
rbd mirror pool promote one -–force
```

After promoting, check the status of the Ceph image:

```bash
rbd info <pool>/<image>
```

For example:

```default
root@site-b $ rbd info one/one-0-0-0
rbd image 'one-0-0-0':
	size 256 MiB in 64 objects
	order 22 (4 MiB objects)
	snapshot_count: 0
	id: 3905d476b862
	block_name_prefix: rbd_data.3905d476b862
	format: 2
	features: layering, exclusive-lock, journaling
	op_features:
	flags:
	create_timestamp: Mon Jun  9 14:21:20 2025
	access_timestamp: Fri Jun 13 13:49:41 2025
	modify_timestamp: Fri Jun 13 13:42:41 2025
	journal: 3905d476b862
	mirroring state: enabled
	mirroring mode: journal
	mirroring global id: f0523ef9-a784-420f-8725-c3f81ff5a302
	mirroring primary: true
```

### Create the VM at Site B

Once the Ceph images in the pool at Site B are promoted, it's time to create the VMs that will run on Site B. To create each VM, you can use the VM template file created [above](#create-vm-templates).

To create a VM from a template, at Site B run as user `oneadmin`:

```bash
onevm create <VM template file>
```

Then, you proceed to instantiate and operate the VM as normal.

### Failback

Once Site A is restored and operational, you can reverse the process to resynchronize data back or migrate services permanently.

1. First we need to demote the images on site A (only in case it was disaster failover):

```default
root@site-a $ rbd mirror pool demote one
```

2. The RBD mirror daemon on site A is up and running, the images need to be flagged for a resync. Until then, the RBD mirror daemon on site A will log problems. Run the following command for each image to sync

```default
root@site-a $ rbd mirror image resync one/one-0-0-0
```

3. After a short time, the images should be mirrored from site B to site A. You can verify it by running the following and by checking the _last_update_ line for required image:

```default
root@site-a $ rbd mirror image status one/one-0-0-0
one-0-0-0:
  global_id:   f0523ef9-a784-420f-8725-c3f81ff5a302
  state:   	up+replaying
  description: replaying, {"bytes_per_second":0.0,"entries_behind_primary":0,"entries_per_second":0.0,"non_primary_position":{"entry_tid":3,"object_number":3,"tag_tid":8},"primary_position":{"entry_tid":3,"object_number":3,"tag_tid":8}}
  service: 	ubuntu2204-kvm-ceph-squid-6-10-cxzjz-0 on ubuntu2204-kvm-ceph-squid-6-10-cxzjz-0
  last_update: 2025-06-17 17:26:11
```

4. Terminate the VM at site B and wait for another successful mirroring to site A.

```default
root@site-b $ onevm terminate 1
```

5. Once we are sure that the disk images have been mirrored after we have terminated the VM, we can demote the image on site B and promote them on site A.

```default
root@site-b $ rbd mirror image demote one/one-0-0-0
```

6. Or, demote all images in pool (only if all images are synced to site A):

```default
root@site-b $ rbd mirror pool demote one
```

7. Promote single image on site A:

```default
root@site-a $ rbd mirror image promote one/one-0-0-0
```

8. Or, alternatively, promote all images (only if all images are synced to site A, and all of them were demoted):

```default
root@site-b $ rbd mirror pool demote one
```

9. Now the image became primary on site A:

```default
root@site-a $ rbd mirror image status one/one-0-0-0
one-0-0-0:
  global_id:   f0523ef9-a784-420f-8725-c3f81ff5a302
  state:   	up+stopped
  description: local image is primary
  service: 	ubuntu2204-kvm-ceph-squid-6-10-cxzjz-0 on ubuntu2204-kvm-ceph-squid-6-10-cxzjz-0
  last_update: 2025-06-17 17:45:11
```
10. Check state for specific image:

```default
root@site-a $ rbd mirror image status one/one-0-0-0
```

11. Or, check states for all images:

```default
root@site-a $ rbd mirror pool status one --verbose
```

12. Finally, we can start the VM at site A:

```default
root@site-a $ onevm resume 0
```
