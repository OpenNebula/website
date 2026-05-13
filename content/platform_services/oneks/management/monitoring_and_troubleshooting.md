---
title: "OneKS Cluster Monitoring and Troubleshooting"
linkTitle: "Monitoring and Troubleshooting"
date: "2026-05-12"
description:
categories:
tags:
weight: "2"
type: docs
---

OneKS uses event-based monitoring to follow VM provisioning, deprovisioning, and lifecycle changes. Its current visibility model is centered on lifecycle state, events, and logs.

Event-driven monitoring is implemented through OpenNebula VM and dependency event watchers. It tracks VM allocation and state changes, seed VM state changes, and dependency lifecycle changes.

## Cluster States

OneKS exposes the following cluster states:

* `PENDING`: a cluster document has been created.  
* `PROVISIONING`: control-plane provisioning has started.  
* `RUNNING`: all expected groups are running.  
* `SCALING`: a node group is being added, removed, or resized.  
* `UPGRADING`: the cluster version is being upgraded.  
* `DEPROVISIONING`: the cluster resources are being deleted.  
* `WARNING`: one or more groups are inconsistent or degraded.  
* `DONE`: cluster deprovisioning has completed.  
* `PROVISIONING_FAILURE`: provisioning failed.  
* `SCALING_FAILURE`: scaling failed.  
* `UPGRADING_FAILURE`: upgrade failed.  
* `DEPROVISIONING_FAILURE`: deprovisioning failed.

A cluster reaches the `RUNNING` state when all expected groups are running. A cluster receives a `WARNING` state when one or more groups are warned or failed while the cluster resource itself is otherwise still present. During deprovisioning, when managed groups have been removed, the cluster reaches `DONE` and is deleted from storage by the action code.

During control-plane bootstrap, seed VM failures can surface as `BOOTSTRAPPING_FAILURE` on the control-plane group. The cluster is then notified of the group failure according to the normal reconciliation behavior.

## Node Group States

OneKS exposes the following group states:

* `PENDING`: the group document exists.  
* `BOOTSTRAPPING`: dependencies are being prepared.  
* `PROVISIONING`: Kubernetes resources or VMs are being created.  
* `RUNNING`: expected VMs exist and are running.  
* `SCALING`: target size is changing.  
* `UPGRADING`: the group is being upgraded.  
* `DEPROVISIONING`: group resources are being removed.  
* `WARNING`: one or more associated VMs or dependencies are degraded.  
* `DONE`: group deprovisioning has completed.  
* `BOOTSTRAPPING_FAILURE`: dependency preparation failed.  
* `PROVISIONING_FAILURE`: provisioning failed.  
* `SCALING_FAILURE`: scaling failed.  
* `UPGRADING_FAILURE`: upgrade failed.  
* `DEPROVISIONING_FAILURE`: deprovisioning failed.

A node-group warning may indicate that one or more associated VMs or dependencies are degraded or inconsistent.

## Reconciliation Rules

OneKS reconciliation follows these general rules:

* **Cluster running condition**: if all expected groups are `RUNNING`, the cluster reconciles to `RUNNING`.  
* **Group degradation**: group-level warnings or failures may surface at cluster level as `WARNING` when the cluster resource itself is still present but one or more underlying groups are degraded.  
* **Action-specific failures**: group failures may map to cluster failure states depending on the cluster action in progress.  
* **Deprovisioning completion**: during deprovisioning, when managed groups have been removed, the cluster reaches `DONE`.  
* **Terminal state**: `DONE` is a terminal lifecycle state reached during deprovisioning.  
* **Node group creation**: node groups can be added only when the cluster is in an appropriate operational state and the control plane is running.  
* **Control-plane scaling**: the control plane does not support scale operations through the OneKS scale command.

## Troubleshooting Logs

OneKS provides several log surfaces on the OpenNebula Front-end Host.

Service logs:

```
/var/log/one/oneks.log
/var/log/one/oneks.error
```

Per-cluster lifecycle logs:

```
/var/log/one/oneks/<cluster_id>.log
```

CLI examples:

```shell
oneks logs cluster 42
oneks logs cluster 42 --follow
```

API:

```
GET /api/v1/clusters/42/logs
```

Service logs are useful for troubleshooting the OneKS daemon. Per-cluster logs are useful for troubleshooting lifecycle operations for a specific cluster. CLI and API log retrieval provide user-facing paths for inspecting cluster lifecycle logs.

## Basic Kubernetes Troubleshooting 

Kubernetes-level checks are cluster-specific. Start by retrieving the kubeconfig for the target cluster:

```shell
oneks show cluster <cluster_id> --kubeconfig > kubeconfig
```

Then verify the Kubernetes node state:

```shell
KUBECONFIG=./kubeconfig kubectl get nodes -o wide
```

A healthy cluster should show the expected control-plane and worker nodes in a `Ready` state.

If one or more nodes are `NotReady`, identify the affected OneKS group and OpenNebula VM: 

```shell
oneks show cluster <cluster_id>
oneks list nodegroups
oneks show nodegroup <nodegroup_id>
```

The OneKS output shows the VM IDs associated with the control-plane and each node group.

The OpenNebula front-end cannot reach the Kubernetes node private network directly, connect through the cluster virtual router.

Identify the virtual router VM:

```shell
onevm list
```

Inspect the virtual router VM and identify its public-side virtual router IP:

```shell
onevm show <router_vm_id>
```

Use the public-side virtual router IP as the SSH jump host and the node private IP as the final destination:

```shell
ssh -J root@<router_public_ip> root@<node_private_ip>
```

After connecting to the affected Kubernetes node VM, inspect the RKE2 service.

On a control-plane node:

```shell
systemctl status rke2-server --no-pager
journalctl -u rke2-server -n 200 --no-pager
```

On a worker node:

```shell
systemctl status rke2-agent --no-pager
journalctl -u rke2-agent -n 200 --no-pager
```

Run the `systemctl` and `journalctl` commands inside the affected Kubernetes node VM, not on the OpenNebula front-end.
