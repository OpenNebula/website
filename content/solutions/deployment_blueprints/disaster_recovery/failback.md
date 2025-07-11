---
title: "Failback"
weight: 5
---

This page covers **failback**, the process of moving business operations back to Site A, after Site A's normal operation has been restored. This process involves resynchronizing data back to the source Ceph cluster.

## High-level Steps for Failback

1. On Site A, demote the image pool and flag images for resync.
1. On Site B, terminate each VM and wait for its image to mirror successfully to Site A.
1. On Site B, demote the images in the pool.
1. On Site A, promote the images in the pool.
1. On Site A, start each VM.

## Failback Procedure

### Demote and Flag Images on Site A

If recovering from a disaster on Site A, then most probably the images on Site A were not demoted. In this case, the first step is to demote them. 

{{< alert title="Note" color="success" >}}
If you are performing failback as part of a Disaster Recovery test, then you should have demoted the images in the source cluster at Site A (as described in [Failover]({{% relref "failover#demote-ceph-images-or-pool-on-site-a" %}})), and should skip the below step.
{{< /alert >}}

On Site A, demote the image pool with:

```bash
rbd mirror pool demote one
```
When the `rbd-mirror` daemon on Site A is up and running, the images will need to be flagged for a resync. (Until the resync operation is performed, the `rbd-mirror` daemon on Site A will log problems.) For each image, resync it by running, on Site A:

```bash
rbd mirror image resync one/one-0-0-0
```

After a short time the images should be mirrored from Site B to Site A. You can verify this by running the below command on Site A for each image, and checking the `last_update` line in the output:

```bash
rbd mirror image status <pool>/<image>
```

For example:

```default
root@site-a $ rbd mirror image status one/one-0-0-0
one-0-0-0:
  global_id:   f0523ef9-a784-420f-8725-c3f81ff5a302
  state:   	up+replaying
  description: replaying, {"bytes_per_second":0.0,"entries_behind_primary":0,"entries_per_second":0.0,"non_primary_position":{"entry_tid":3,"object_number":3,"tag_tid":8},"primary_position":{"entry_tid":3,"object_number":3,"tag_tid":8}}
  service: 	ubuntu2204-kvm-ceph-squid-6-10-cxzjz-0 on ubuntu2204-kvm-ceph-squid-6-10-cxzjz-0
  last_update: 2025-06-17 17:26:11
```

### Terminate Virtual Machines on Site B

After successfully checking mirroring status, terminate the VM at Site B. To terminate the VM, at Site B run as user `oneadmin`:

```bash
onevm terminate <VM ID>
```

Then, wait for the image to mirror successfully to Site A. To ensure that an image has been mirrored successfully to Site A, run `rbd mirror image status` for the image. Once the mirroring is complete, you can demote the image on Site B and promote it on Site A.

To demote the image on Site B:

```bash
rbd mirror image demote one/one-0-0-0
```

Alternatively, after all images are synced to Site A you can demote all images in the pool:

```bash
rbd mirror pool demote one
```

Then you will need to promote the images on Site A.

### Promote Ceph Images or Pool on Site A

To promote a single image on site A:

```bash
rbd mirror image promote one/one-0-0-0
```

Alternatively, if all images were demoted and all of them are already synced, you can promote the whole pool:

```bash
rbd mirror pool promote one
```

Now the image is primary on site A:

```default
root@site-a $ rbd mirror image status one/one-0-0-0
one-0-0-0:
  global_id:   f0523ef9-a784-420f-8725-c3f81ff5a302
  state:   	up+stopped
  description: local image is primary
  service: 	ubuntu2204-kvm-ceph-squid-6-10-cxzjz-0 on ubuntu2204-kvm-ceph-squid-6-10-cxzjz-0
  last_update: 2025-06-17 17:45:11
```
To check the state for a specific image, on Site A run:

```bash
rbd mirror image status one/one-0-0-0
```

Or to check the state for all images:

```bash
rbd mirror pool status one --verbose
```

Finally, we can start the VM at site A:

```bash
onevm resume <VM ID>
```
