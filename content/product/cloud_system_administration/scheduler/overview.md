---
title: "Overview"

description:
categories:
pageintoc: ""
tags:
weight: "3"
---

<a id="scheduler-overview"></a>

<!--# Resource Scheduler Overview -->

The OpenNebula resource scheduler framework is a modular system that applies different scheduling algorithms to allocate three types of resources:

- **Hosts** – Determines the Hosts where VMs will run.
- **System Datastores** – Selects the storage location for VM virtual disk images.
- **Virtual Networks** – Assigns Virtual Networks for VM interfaces when set to auto mode.

This scheduling mechanism is used for the following cloud operations:

- **Initial VM placement** – Ensures efficient resource allocation based on capacity, compatibility, affinity rules, and placement constraints.
- **VM re-scheduling** - Administrators or high-level tools can request the re-schedule of a single VM.
- **Cluster-wide load balancing** – Dynamically generates optimization plans to distribute workloads evenly across hypervisor nodes, following custom-defined policies.

## Resource Requirements

### Virtual Machine Automatic Requirements

OpenNebula prevents incompatible resources from being used to run a VM. When a VM requires resources (such as Images or Virtual Networks) from a Cluster, OpenNebula automatically adds a [requirement]({{% relref "../../operation_references/configuration_references/template#template-placement-section" %}}) to the template:

```default
$ onevm show 0
[...]
AUTOMATIC_REQUIREMENTS="CLUSTER_ID = 100"
```

If resources from different Clusters are used together, VM creation will fail with an error message like:

```default
$ onetemplate instantiate 0
[TemplateInstantiate] Error allocating a new virtual machine. Incompatible cluster IDs.
DISK [0]: IMAGE [0] from DATASTORE [1] requires CLUSTER [101]
NIC [0]: NETWORK [1] requires CLUSTER [100]
```

These automatic requirements are combined with any additional requirements specified in the Virtual Machine template. Additionally, a resource must have sufficient capacity to accommodate the VM.

{{< alert title="Warning" color="warning" >}}
Every Host in a Cluster **must** have access to all System and Image Datastores defined in that Cluster.{{< /alert >}} 

### Host Requirements

You can specify VM allocation requirements with the `SCHED_REQUIREMENTS` attribute in the Virtual Machine Template. This attribute defines a boolean expression that determines whether a Host is suitable for deployment (i.e., the expression evaluates to `true`).

The `SCHED_REQUIREMENTS` expression can reference attributes from both the Host and its associated Cluster templates. Host attributes are regularly updated by monitoring probes that run on the nodes. Administrators can add custom attributes by either [creating a probe in the host]({{% relref "../../integration_references/infrastructure_drivers_development/devel-im#devel-im" %}}) or manually updating Host information using:

```default
onehost update
```

For example, if some Hosts offer Gold-level QoS and others offer Silver, you can check their attributes:

```default
$ onehost list
  ID NAME            CLUSTER   RVM      ALLOCATED_CPU      ALLOCATED_MEM STAT
   1 host01          cluster_a   0       0 / 200 (0%)     0K / 3.6G (0%) on
   2 host02          cluster_a   0       0 / 200 (0%)     0K / 3.6G (0%) on
   3 host03          cluster_b   0       0 / 200 (0%)     0K / 3.6G (0%) on

$ onecluster show cluster_a
CLUSTER TEMPLATE
QOS="GOLD"

$ onecluster show cluster_b
CLUSTER TEMPLATE
QOS="SILVER"
```

To ensure deployment only on a Host with Gold QoS, use:

```default
SCHED_REQUIREMENTS = "QOS = GOLD"
```

To exclude Gold QoS Hosts and target KVM hypervisors:

```default
SCHED_REQUIREMENTS = "QOS != GOLD & HYPERVISOR = kvm"
```

### Datastore Requirements

To optimize I/O performance across multiple disks, LUNs, or storage backends, OpenNebula allows multiple System Datastores per Cluster. Scheduling algorithms factor in VM disk requirements to select the best execution Host based on storage capacity and performance metrics.

Administrators can control which Datastores a VM uses via `SCHED_DS_REQUIREMENTS`, a boolean expression that evaluates to `true` for valid System Datastores.

For example, to prioritize Datastores labeled as *Production*:

```default
SCHED_DS_REQUIREMENTS="MODE=Production"
```

{{< alert title="Note" color="success" >}}
Administrators must manually assign `MODE` labels to Datastores.{{< /alert >}} 

### Virtual Networks Requirements

The scheduler can also automatically select Virtual Networks for VM NICs when `NETWORK_MODE = "auto"` is set. This process uses a `SCHED_REQUIREMENTS` expression to match NICs with compatible Virtual Networks.

For example, a VM template may contain:

```default
NIC = [ NETWORK_MODE = "auto", SCHED_REQUIREMENTS = "TRAFFIC_TYPE = \"public\"" ]
NIC = [ NETWORK_MODE = "auto", SCHED_REQUIREMENTS = "TRAFFIC_TYPE = \"private\"" ]
```

The first NIC will attach to a *public* network, while the second will connect to a *private* network.

{{< alert title="Note" color="success" >}}
Administrators must manually label Virtual Networks with `TRAFFIC_TYPE`.{{< /alert >}} 

## Resource Selection

### Initial Placement

When a VM is instantiated, OpenNebula determines the best Host for deployment based on available resources and placement constraints. By default, the [Rank Scheduler]({{% relref "rank_scheduler#scheduler-rank" %}}) algorithm is used, applying a *Matchmaking* approach:

- **Requirements** – Filters out resources that do not meet the VM’s specifications. See Section above.
- **Rank** – Sorts the remaining resources by priority, selecting the highest-ranked option.

Alternatively, the [OpenNebula Distributed Resource Scheduler]({{% relref "drs#scheduler-drs" %}}) (DRS) can be used for initial placement, considering real-time resource usage and workload distribution.

### VM Re-scheduling

When a Virtual Machine is in the `running` or `poweroff` state, it can be rescheduled to a different Host. By issuing the `onevm resched` command, the VM is labeled for rescheduling. In the next scheduling interval, the VM will be rescheduled to a different Host, if:

* There is a suitable Host for the VM.
* The VM is not already running on it.

This feature can be used by other components to trigger the rescheduling action when certain conditions are met.

### Cluster Workload Optimization

OpenNebula continuously optimizes cluster workload distribution using the [OpenNebula Distributed Resource Scheduler (DRS)]({{% relref "drs#scheduler-drs" %}}), which provides:

- **Optimization Recommendations** – Can be applied automatically or reviewed manually.
- **Customizable Metrics** – Allows weighting of CPU, memory, disk, and network for optimization.
- **Predictive Optimization** – Uses real-time and projected resource usage for smarter decisions.

## OpenNebula Scheduler Framework Architecture

The diagram below outlines the OpenNebula Scheduling Framework, showing key components for resource selection and workload optimization:

![scheduler_architecture](/images/scheduler_architecture.png)

Main components:

1. **Scheduler Manager** – Integrated with OpenNebula’s core daemon (`oned`), requesting placement and optimization plans.
2. **Scheduler Plan Manager** – Executes placement and optimization plans by deploying or migrating VMs.
3. **Schedulers** – External components generating placement and optimization plans using different policies.

OpenNebula includes two built-in schedulers:

- [Rank Scheduler]({{% relref "rank_scheduler#scheduler-rank" %}}) – Default option for initial VM placement.
- [OpenNebula Distributed Resource Scheduler]({{% relref "drs#scheduler-drs" %}}) – It can be used for the initial VM placement, and cluster workload optimization.
