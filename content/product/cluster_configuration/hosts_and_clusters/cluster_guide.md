---
title: "Clusters"
date: "2025-02-17"
description:
categories:
pageintoc: "54"
tags:
weight: "3"
---

<a id="cluster-guide"></a>

<!--# Clusters -->

Clusters group together Hosts, datastores, and virtual networks that are configured to work together. A cluster is used to:

> * Ensure that VMs use resources that are compatible.
> * Assign resources to user groups by creating Virtual Private Clouds.

Clusters should contain homogeneous resources. Note that some operations like live migrations are restricted to Hosts in the same cluster.

The requirements for live migrating VMs between Hosts of the same cluster are that no differences occur in the following areas of the hypervisors:

* CPU model
* Firmware settings
* Microcode version
* BIOS version
* BIOS settings
* Libvirt version
* QEMU version
* Kernel version

## Cluster Management

Clusters are managed with the `onecluster` command. To create new clusters, use `onecluster create <name>`. Existing clusters can be inspected with the `onecluster list` and `show` commands.

```default
$ onecluster list
  ID NAME            HOSTS NETS  DATASTORES

$ onecluster create production
ID: 100

$ onecluster list
  ID NAME            HOSTS NETS  DATASTORES
 100 production      0     0     0

$ onecluster show production
CLUSTER 100 INFORMATION
ID             : 100
NAME           : production

HOSTS

VNETS

DATASTORES
```

### Add Hosts to a Cluster

Every Host must belong to a cluster, so if no cluster is specified it will be assigned to the `default` cluster by default. Hosts can be created directly in a different cluster by using the `--cluster` option of `onehost create`, or be added at any time with the command `onecluster addhost`. Hosts can be in **only one cluster** at a time.

To delete a Host from a cluster, the command `onecluster delhost` must be used.

In the following example, we will add Host 0 to the cluster we created before. You will notice that the `onecluster show` command will list the Host ID 0 as part of the cluster.

```default
$ onehost list
  ID NAME         CLUSTER     RVM   TCPU   FCPU   ACPU   TMEM   FMEM   AMEM STAT
   0 host01       -             7    400    290    400   3.7G   2.2G   3.7G   on

$ onecluster addhost production host01

$ onehost list
  ID NAME         CLUSTER     RVM   TCPU   FCPU   ACPU   TMEM   FMEM   AMEM STAT
   0 host01       producti      7    400    290    400   3.7G   2.2G   3.7G   on

$ onecluster show production
CLUSTER 100 INFORMATION
ID             : 100
NAME           : production

HOSTS
0

VNETS

DATASTORES
```

### Add Resources to Clusters

Datastores and virtual networks can be added to multiple clusters. This means that any Host in those clusters is properly configured to run VMs using images from those datastores, or is using leases from those virtual networks.

For instance, if you have several Hosts configured to use a given Open vSwitch network, you would group them in the same cluster. The [Scheduler]({{% relref "../../cloud_system_administration/scheduler" %}}) will know that VMs using these resources can be deployed in any of the Hosts of the cluster.

These operations can be done with the `onecluster` `addvnet/delvnet` and `adddatastore/deldatastore`, respectively:

```default
$ onecluster addvnet production priv-ovswitch

$ onecluster adddatastore production iscsi

$ onecluster list
  ID NAME            HOSTS NETS  DATASTORES
 100 production      1     1     1

$ onecluster show 100
CLUSTER 100 INFORMATION
ID             : 100
NAME           : production

CLUSTER TEMPLATE

HOSTS
0

VNETS
1

DATASTORES
100
```

### The System Datastore for a Cluster

In order to create a complete environment where the scheduler can deploy VMs, your clusters need to have at least one System Datastore.

You can add the default System Datastore (ID: 0) or create a new one to improve its performance (e.g., balance VM I/O between different servers) or to use different System Datastore types (e.g., `shared` and `local`).

To use a specific System Datastore with your cluster instead of the default one, just create it and associate it just like any other datastore (`onecluster adddatastore`).

## Managing Clusters in Sunstone

The [Sunstone UI interface]({{% relref "../../control_plane_configuration/graphical_user_interface/fireedge_sunstone#fireedge-sunstone" %}}) offers an easy way to manage clusters and the resources within them. You will find the cluster sub-menu under the infrastructure menu. From there you will be able to:

- Create new clusters selecting the resources you want to include in this cluster.

![create_cluster](/images/sunstone_cluster_create.png)

- See the list of current clusters, from which you can update or delete existing ones.

![dashboard_cluster](/images/sunstone_cluster_dashboard.png)

- See cluster details and update overcommitment.

![details_cluster](/images/sunstone_cluster_details.png)

## Enhanced VM Compatibility (EVC)

The Enhanced VM Compatibility (EVC) feature facilitates the management of heterogeneous OpenNebula clusters by masking host CPU capabilities to enforce a unified base model. Using a lowest-common-denominator approach ensures CPU compatibility across hosts and enables seamless live migration of Virtual Machines between hosts with different processor generations.

EVC is configured at the cluster level. This simplifies management and improves scalability by allowing administrators to add newer hardware to existing clusters without preventing VM migration due to CPU differences.

### Using EVC with the CLI

1. Inspect the cluster to view the current template and attributes:

```bash
$ onecluster show default
```

Look for the `CLUSTER TEMPLATE` section. If `EVC_MODE` is not present, it has not been configured for the cluster.

2. Set the `EVC_MODE` attribute on a cluster using `onecluster update`. For example, to set a Sandy Bridge baseline:

```bash
$ onecluster update default"
```

Then add the `EVC_MODE` attribute to the list:

```bash
...
EVC_MODE="sandybridge"
...
```

The exact CPU model string depends on the hypervisor's supported CPU map. You can view the supported cpu models of a given host with the following command under the `KVM_CPU_MODELS` key:

```bash
$ onehost show <host-id> -j
```

Make sure to select a cpu model available in all hosts in the cluster, otherwise you may fail to deploy VMs on unsupported hosts.


3. To revert or remove EVC, update the cluster template to remove the `EVC_MODE` attribute (for example by setting it to an empty string or re-applying a template without the attribute).

### Using EVC with Sunstone

The Fireedge / Sunstone web UI provides a convenient way to enable and change EVC without editing templates directly.

1. Open the Infrastructure → Clusters view and select the cluster you want to configure.

2. Click the Update button and go to the Select Hosts tabs, there you will see the EVC Mode section. To enable EVC, choose a model from the droplist. Afterwards you can click Finish.

![Update cluster EVC mode](/images/sunstone_cluster_evc_update.png)

3. Once the EVC mode is set, you can see it listed in the cluster attributes the same way as if the CLI had been used.

![EVC set in cluster attributes](/images/sunstone_cluster_evc_attributes.png)
