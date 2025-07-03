---
title: "Configuration and Deployment"
#description: "Complete guide for configuring DR with OpenNebula and Ceph"
weight: 3
---

## Basic Configuration

To set up Ceph RBD mirroring between two OpenNebula sites, you need to configure asynchronous block-level replication of RBD images to ensure that Virtual Machine disk images are synchronized.

First, you deploy two independent Ceph clusters, one per site (**Site A** and **Site B**). These clusters must have matching RBD pool names (in this case, `one` pool). To avoid duplicate image names, Site B does not have any images in the same pool.

On Site A, you need to:

- Set the VM images as **persistent** in the OpenNebula database. This means that modifications you make to the image will be preserved after the VM is terminated. You can set a VM image as persistent when creating the image or later, using the `oneimage`. For details [Creating Images]({{% relref "images#creating-images" %}}) and [Changing the Persistent Mode]({{% relref "images#changing-the-persistent-mode" %}}) in the Images documentation.

On Site B, you need to:

- Retrieve the metadata for each VM, which you can do with `onevm show`. For details on this and other Virtual Machine operations, see [Virtual Machine Instances]({{% relref "vm_instances" %}}).

### Create Ceph Users

You will need to set up two users for the Ceph clusters, one for the `rbd-mirror` daemon on the source Ceph cluster (Site A) and one for the daemon on the target Ceph cluster (Site B). These users will enable the `rbd-mirror` daemon on each Ceph cluster to authenticate against each other.

To create the user in the source Ceph cluster (site A), run as `root`:

```bash
ceph auth get-or-create client.rbd-mirror-peer-a mon 'profile rbd' osd 'profile rbd' -o /etc/ceph/site-a.client.rbd-mirror-peer-a.keyring
```

The above creates a secret key for the user and outputs it to the file `/etc/ceph/site-a.client.rbd-mirror-peer-a.keyring`. You will need to copy this file to the Ceph cluster at Site B. To copy the contents to all host on Site B you can run a one-line script:

```bash
for host in node{0..3}-site-b; do echo $host; scp /etc/ceph/site-a.client.rbd-mirror-peer-a.keyring root@$host:/etc/ceph/site-a.client.rbd-mirror-peer-a.keyring; done
```

Then, change the ownership of the file to user `ceph`:

```bash
for host in node{0..3}-site-b; do echo $host;ssh $host chown ceph:ceph /etc/ceph/site-a.client.rbd-mirror-peer-a.keyring; done
```

On the target Ceph cluster (Site B), you will need to create a local user for the `rbd-mirror` daemon. Here we will use `$(hostname)` to match the unique ID to that used for other Ceph services such as monitors.

```default
root@site-b $ ceph auth get-or-create client.rbd-mirror.$(hostname) mon 'profile rbd-mirror' osd 'profile rbd' -o /etc/ceph/ceph.client.rbd-mirror.$(hostname).keyring
```

{{< alert title="Note" color="success" >}}
If you wish to restrict the user permissions to this specific pool, you can use `profile rdb pool=one`.
{{< /alert >}}

To enable the `rbd-mirror` daemon to access the Ceph cluster on Site A, we need to copy the `ceph.conf` file from Site A to Site B and name it `site-a.conf`:

```bash
for host in node{0..3}-site-b; do echo $host; scp /etc/ceph/ceph.conf root@$host:/etc/ceph/site-a.conf; done
root@site-a $ for host in node{0..3}-site-b; do echo $host; ssh $host chown ceph:ceph /etc/ceph/site-a.conf; done
```

Then, to change ownership of the file to system user `ceph`:

```bash
for host in node{0..3}-site-b; do echo $host; ssh $host chown ceph:ceph /etc/ceph/site-a.conf; done
```

Make sure that the name of the config file matches the name used in the keyring that stores the authentication infos.

## Enable Mirroring


{{< alert title="Note" color="success" >}}
When RBD mirroring is enabled for the entire pool, all newly-created images will inherit the `journal` and `exclusive-lock` attributes. However, only template images that do not need to be synchronized will be automatically synchronized to the opposite site, and VM images will not be synchronized even if they inherit the `journal` and `exclusive-lock` attributes, because that requires _flattening_.

Site A can be configured with mirroring in `image` mode, but Site B always needs to use mirroring in `pool` mode.
{{< /alert >}}

The below commands illustrate how to enable mirroring on the source and target Ceph clusters.

### Enable Mirroring on Site A

On Site A, you can enable mirroring in `pool` or `image` mode. To enable it in `pool` mode, run:

```bash
rbd mirror pool enable one pool
```

If you wish to enable mirroring with `image` mode, skip the above command and follow the steps [below](#enable-mirroring-on-site-a-in-image-mode), then come back to this section to enable mirroring in Site B.

### Enable Mirroring on Site B

On Site B, mirroring must always use `pool` mode. To enable it, run:

```bash
rbd mirror pool enable one pool
```

To verify mirroring:

```bash
rbd mirror pool info one
```

Next, we need to tell the pool on site B which keyring and Ceph config file it should use to connect to the peer (Site A).

```bash
rbd mirror pool peer add one client.rbd-mirror-peer-a@site-a
```

You can check the settings by running:

```bash
rbd mirror pool info one
```

For example:

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

The direction should be `rx-tx` and the client should be set correctly to match the keyring file. The name should also be shown correctly (`site-a`).

### Install the `rbd-mirror` Daemon on Site B

To install the daemon, run:

```bash
apt install rbd-mirror
```

Then, enable and modify the `systemd` unit file for `rbd-mirror`:

```bash
systemctl enable ceph-rbd-mirror.target
```

```bash
cp /usr/lib/systemd/system/ceph-rbd-mirror@.service /etc/systemd/system/ceph-rbd-mirror@.service
```

Next, we need to create and start the mirroring service. Make sure to call it as we named the local user for the target cluster that we created earlier, otherwise the daemon won't be able to authenticate against the target cluster.

```bash
systemctl enable --now ceph-rbd-mirror@rbd-mirror.$(hostname).service
```

If we check the status and logs of the `ceph-rbd-mirror@rbd-mirror.<hostname>.service_` service, we should see that it comes up and does not log any authentication errors.

To check the status, run:

```bash
systemctl status ceph-rbd-mirror@rbd-mirror.ubuntu2204-kvm-ceph-squid-6-10-cqyoo-0.service
```

For example:

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

At this point, mirroring should be configured from Site A to Site B, with direction `tx-only`. To verify the mirroring, see below.

### Verify Mirroring

On Site A, run:

```bash
rbd mirror pool info one
```

Output should similar to:

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

To obtain detailed information about the mirroring, run:

```bash
rbd mirror pool status one --verbose
```

For example:

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
### Enable Mirroring on Site A in `image` mode

If you want to use `image` mode for Site A mirroring, you will need to define which images should be mirrored, and enable the `exclusive-lock` and `journal` features for the images.

To enable journal-based mirroring for an image, run the command:

```bash
rbd mirror image enable one/one-0-0-0 exclusive-lock,journal
```

Then, verify the image:

```bash
rbd image 'one-0-0-0':
```

For example:

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

Next, since VM disks are just the snapshots based on the image, we will need to flatten the required image:

```bash
rbd flatten one/one-0-0-0
```

After performing these steps, to enable mirroring on Site B go back to the section [above](#enable-mirroring-on-site-b).

### Enable Two-way Mirroring for Failback

In order to failback Virtual Machines to Site A when it becomes available after disaster, you will need to set up the `rbd-mirror` daemon on Site A, which will connect to Site B. On Site A, install the `rbd-mirror` daemon and enable the service by following the same steps as when [installing `rbd-mirror` on Site B](#install-the-rbd-mirror-daemon-on-site-b).
