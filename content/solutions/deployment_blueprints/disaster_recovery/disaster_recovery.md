---
title: "Disaster recovery"
description: "Complete guide for configuring DR with OpenNebula and Ceph"
---

## Overview

OpenNebula with Ceph RBD mirroring enables a reliable disaster recovery (DR) solution across two sites. Ceph asynchronously replicates VM disk images from the source site A to the target site B, ensuring up-to-date data copies. OpenNebula metadata is synchronized to deploy VMs quickly on site B during failover. In the event of a disaster at Site A, Site B can promote mirrored volumes and start VMs with minimal downtime. This setup ensures business continuity, data integrity, and faster recovery during outages.

## Architecture

Two OpenNebula clusters with independent Frontends  (site A and site B) connected to the same storage network.

![image](/assets/images/disaster_recovery.png)

### Site A (source):
- OpenNebula controller (Frontend)
  - OpenNebula 6.10.3 version
  - OS: Ubuntu 22.04
- Compute KVM Nodes with ceph (x3)
- Ceph cluster (one pool)
  - Squid 19.2.2 version
- VMs running production workloads
- Ceph RBD mirroring enabled (as primary)
  - rbd-mirroring service

### Site B (target):
- OpenNebula controller (Frontend)
  - OpenNebula 6.10.3 version
  - OS: Ubuntu 22.04
- Compute KVM Nodes with ceph (x3)
- Ceph cluster (one pool)
  - Squid 19.2.2 version
- Ceph receives mirrored RBD images
- Ceph RBD mirroring enabled (as replication)
  - rbd-mirroring service

The test environment has been configured used microenvs to deploy two seaparted OpenNebula clusters based on _kvm-ceph-ec#squid_ and _ubuntu2204_ template with standard shapes. Ssh public keys are added to all nodes on each opposite site.

## Configuration and Deployment

Setting up Ceph RBD mirroring between two sites for OpenNebula involves configuring asynchronous block-level replication to ensure VM disk images are synchronized. First, you deploy two independent Ceph clusters, one per site (Site A and Site B), with matching RBD pool names (one pool) intended for mirroring. Site B does not have any images in the same pool to avoid duplicate image names.
  
While site A is still available, you need to create a record of the VM image in the DB as persistent and also retrieve the metadata of the current VM at site B during the DR configuration stage for the current VM.

At the beginning, it required setup users. One on the source cluster (site A) with which the rbd-mirror daemon on the target cluster (site B) authenticates against site A. The second user is the one with which the rbd-mirror authenticates against the target cluster (site B).

1. Create the user in the source cluster (site A):

```default
root@site-a $ ceph auth get-or-create client.rbd-mirror-peer-a mon 'profile rbd' osd 'profile rbd' -o /etc/ceph/site-a.client.rbd-mirror-peer-a.keyring
```

2. We need to make this file available over at site B cluster. Copy the contents of the file manually to the following location on site B:

```default
root@site-a $ for host in node{0..3}-site-b; do echo $host;scp /etc/ceph/site-a.client.rbd-mirror-peer-a.keyring  root@$host:/etc/ceph/site-a.client.rbd-mirror-peer-a.keyring; done
root@site-a  $ for host in node{0..3}-site-b; do echo $host;ssh $host chown ceph:ceph /etc/ceph/site-a.client.rbd-mirror-peer-a.keyring; done
```

3. We need to create a local user for the _rbd-mirror_ daemon on the target cluster. We use _$(hostname)_ to match the unique ID to what is used for other Ceph services such as monitors.
You can restrict the permissions to a specific pool if you write _profile rbd pool=one_

```default
root@site-b $ ceph auth get-or-create client.rbd-mirror.$(hostname) mon 'profile rbd-mirror' osd 'profile rbd' -o /etc/ceph/ceph.client.rbd-mirror.$(hostname).keyring
```

4. In order for the _rbd-mirror_ to access the Ceph cluster on site A, we need to copy over the ceph.conf file from site A to site B and name it _site-a.conf_:

```default
root@site-a $ for host in node{0..3}-site-b; do echo $host;scp /etc/ceph/ceph.conf root@$host:/etc/ceph/site-a.conf; done
root@site-a $ for host in node{0..3}-site-b; do echo $host;ssh $host chown ceph:ceph /etc/ceph/site-a.conf; done
```

Make sure that the name of the config file matches the name used in the keyring that stores the authentication infos.

5. Run the following command on both clusters to enable mirroring, in case we want to mirror all images:

{{< alert title="Note" color="success" >}}
When _rbd-mirroring_ is enabled for the entire pool, all newly created images will inherit the _journal_ and _exclusive-lock_ attributes. However, only template images that do not need to be synchronized will be automatically synchronized to the opposite site, and VM's images will not be synchronized even if they inherit the _journal_ and _exclusive-lock_ attributes because it requires _flattering_. For site B we always need to use pool based mirroring.
{{< /alert >}}

  - Enable mirroring on site-a pool (skip this step if the image based mirroring will be configured later at steps 14-17):

  ```default
  root@site-a $ rbd mirror pool enable one pool
  ```

  - Enable mirroring on site-b pool:

  ```default
  root@site-b $ rbd mirror pool enable one pool
  ```

6. It can be verified by command:

```default
$ rbd mirror pool info one
```

7. Next we need to tell the pool on site B which keyring and Ceph config file it should use to connect to the peer (site A).

```default
root@site-b $ rbd mirror pool peer add one client.rbd-mirror-peer-a@site-a
```

8. You can check the settings by running:

```default
root@site-b $ rbd mirror pool info one
Mode: pool
Site Name: 16c707cc-a764-47d4-b308-eefa06ff1205
Peer Sites: 
UUID: 164f8358-70a3-4f2d-a727-8729fa186b88
Name: site-a
Mirror UUID: 
Direction: rx-tx
Client: client.rbd-mirror-peer-a
```

The direction should be _rx-tx_ and the client should be set correctly to match the keyring file. The name should also be shown correctly (site A).

9. Install the rbd-mirror at Site B:

```default
root@site-b $ apt install rbd-mirror
```

10. Enable and modify the systemd unit file for the rbd-mirror:

```default
root@site-b $ systemctl enable ceph-rbd-mirror.target
root@site-b $ cp /usr/lib/systemd/system/ceph-rbd-mirror@.service /etc/systemd/system/ceph-rbd-mirror@.service
```

11. Next, we need to create and start the service. Make sure to call it as we named the local user for the target cluster that we created earlier, otherwise the daemon won't be able to authenticate against the target cluster (site B).

```default
root@site-b $ systemctl enable --now ceph-rbd-mirror@rbd-mirror.$(hostname).service
```

12. If we check the status and logs of the _ceph-rbd-mirror@rbd-mirror.<hostname>.service_ service, we should see that it comes up and does not log any authentication errors.

```default
root@site-b $ systemctl status ceph-rbd-mirror@rbd-mirror.ubuntu2204-kvm-ceph-squid-6-10-cqyoo-0.service
● ceph-rbd-mirror@rbd-mirror.ubuntu2204-kvm-ceph-squid-6-10-cqyoo-0.service - Ceph rbd mirror daemon
 	Loaded: loaded (/etc/systemd/system/ceph-rbd-mirror@.service; enabled; vendor preset: enabled)
 	Active: active (running) since Mon 2025-06-09 12:04:50 UTC; 6 days ago
   Main PID: 17234 (rbd-mirror)
  	Tasks: 51
 	Memory: 55.5M
    	CPU: 21min 42.097s
 	CGroup: /system.slice/system-ceph\x2drbd\x2dmirror.slice/ceph-rbd-mirror@rbd-mirror.ubuntu2204-kvm-ceph-squid-6-10-cqyoo-0.service
         	└─17234 /usr/bin/rbd-mirror -f --cluster ceph --id rbd-mirror.ubuntu2204-kvm-ceph-squid-6-10-cqyoo-0 --setuser root --setgroup root
```

13. The source cluster (site A) should now have a peer configured and direction will be _tx-only_:

```default
root@site-a $ rbd mirror pool info one
Mode: pool
Site Name: 277ddb4b-1323-425f-bf28-fa8c58c0137e

Peer Sites: 

UUID: 0ab31017-3e80-470d-b80d-1ba04d606b13
Name: 258816cf-14fb-4237-981a-e84b35c7b0b9
Mirror UUID: 5218ea1d-fcb7-404e-82f0-e48a77a05935
Direction: tx-only
```

14. Before we can start mirroring the images (In case we don’t enable mirroring on a pool basis for site A ), we need to define which images should be mirrored. Journal based mirroring needs the _exclusive-lock_ and _journal_ features enabled for the images. To enable journal based mirroring for an image, run the command:

```default
root@site-a $ rbd mirror image enable one/one-0-0-0 exclusive-lock,journal
```

15. Verify the image  image after applying:

```default
root@site-a $ rbd image 'one-0-0-0':
	size 256 MiB in 64 objects
	order 22 (4 MiB objects)
	snapshot_count: 0
	id: 39b66a80b833
	block_name_prefix: rbd_data.39b66a80b833
	format: 2
	features: layering, exclusive-lock, journaling
	op_features: 
	flags: 
	create_timestamp: Wed Jun  4 10:31:42 2025
	access_timestamp: Mon Jun  9 12:08:11 2025
	modify_timestamp: Mon Jun  9 12:08:05 2025
	parent: one/one-0@snap
	overlap: 256 MiB
	journal: 39b66a80b833
	mirroring state: enabled
	mirroring mode: journal
	mirroring global id: f0523ef9-a784-420f-8725-c3f81ff5a302
	mirroring primary: true
```

16. Since VM’s disks are just the snapshots based on the image we need flatter required image:

```default
root@ste-a $ rbd flatten one/one-0-0-0
```

17. Once the rbd-mirror is up and running, you should see a peer configured in the source cluster (site A):

```default
root@site-a $ rbd mirror pool info one
Mode: pool
Site Name: 277ddb4b-1323-425f-bf28-fa8c58c0137e

Peer Sites: 

UUID: 0ab31017-3e80-470d-b80d-1ba04d606b13
Name: 258816cf-14fb-4237-981a-e84b35c7b0b9
Mirror UUID: 5218ea1d-fcb7-404e-82f0-e48a77a05935
Direction: tx-only
```

18. You can get detailed information about the mirroring by running:

```default
root@site-b $ rbd mirror pool status one --verbose
health: OK
daemon health: OK
image health: OK
images: 0 total

DAEMONS
service 14595:
  instance_id: 14597
  client_id: ubuntu2204-kvm-ceph-squid-6-10-cqyoo-0
  hostname: ubuntu2204-kvm-ceph-squid-6-10-cqyoo-0
  version: 19.2.2
  leader: true
  health: OK
```

19. We need to set up an RBD mirror daemon on site A that connects to site B (two-way mirror) to be able to failback VMs to site A when it becomes available after disaster and failback. The steps are the same, but in reverse order (1-14).

## Usage: Recover Procedures

### Failover Recovery

In the event of a failure at Site A, the failover procedure begins by promoting the mirrored RBD images on Site B using rbd mirror image promote, making them writable. Once promoted, recreating VM can be scheduled based on template metadata  with  existing image. A common scenario is that the source cluster, site A in this guide, will have some kind of failure, and we want to fail over to the other cluster, site B.

1. Based on the parent image from site A and ceph virtual disk name, we need to prepare the new image file for registering  at OpenNebula site B as _persistent_:

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

2. Register the image:

```default
root@site-b $ $ oneimage create disk -d 1
```

3. Make sure that no guest has anything configured that is specific to only the source cluster, like an ISO image or a storage used for the disk images.

4. If you would just try to start the guests on the remaining secondary cluster (site B), a VM could start, but will report IO errors very quickly. This is due to the fact that the target images are marked as such (non-primary) and won't allow writing to them from our guests.

5. We need to check the status of mirroring specific image:

```default
site-b $ rbd mirror image status one/one-0-0-0
one-0-0-0:
  global_id:   f0523ef9-a784-420f-8725-c3f81ff5a302
  state:       up+replaying
  description: replaying, {"bytes_per_second":0.0,"entries_behind_primary":0,"entries_per_second":0.0,"non_primary_position":{"entry_tid":3,"object_number":3,"tag_tid":6},"primary_position":{"entry_tid":3,"object_number":3,"tag_tid":6}}
  service:     ubuntu2204-kvm-ceph-squid-6-10-cqyoo-0 on ubuntu2204-kvm-ceph-squid-6-10-cqyoo-0
  last_update: 2025-06-09 14:28:20
```

6. Prepare template file based on VM from site A:

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

{{< alert title="Note" color="success" >}}
However, in case at site B another Vnets presented template should be modified and Network context should be removed to get IP address from available range.
{{< /alert >}}

7. Stop original VM at source cluster (in case of testing Failover/Failback, but the site A is available 7-11), to avoid possible data loss:

```default
root@site-a $ onevm poweroff 0
```

{{< alert title="Note" color="success" >}}
By promoting an image or all images in a pool, we can tell Ceph that they are now the primary ones to be used. In a planned failover, we would first demote the images on site A before we promote the images on site B. In a recovery situation with site A down, we need to _--force_ the promotion.
{{< /alert >}}

8. If you want to test the scenario where both clusters are healthy, do not use the _--force_ flag, but demote the image on site-a first:

```default
root@site-a $ rbd mirror image demote one/one-0-0-0
```

9. You can also demote all images, but it will take into account only images which were flatteren before:

```default
root@site-a $ rbd mirror pool demote one
```

10. Promote particular image at site-b:

```default
root@site-b $ rbd mirror image promote one/one-0-0-0
```

11. Or promote the whole pool:

```default
root@site-b $ rbd mirror pool promote one
```

12. In case, the site A is unavailable (skip 7-11 steps) promote pool/images with flag _–force_:

```default
root@site-b $ rbd mirror pool promote one –force
```

13. Check the status of the ceph image

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

14. Build the VM at site B using pre-defined file:

```default
root@site-b $ onevm create vm-template
```

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
