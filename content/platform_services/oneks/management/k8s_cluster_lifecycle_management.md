---
title: "Kubernetes Cluster Lifecycle Management"
linkTitle: "Cluster Lifecycle Management"
date: "2026-05-12"
description:
categories:
tags:
weight: "1"
type: docs
---

This section describes the main lifecycle operations for OneKS clusters. It covers how to create, access, scale, upgrade, recover, and delete clusters.

A OneKS cluster lifecycle normally follows this sequence:

* **Create a cluster**: provision the control plane and required infrastructure.  
* **Access the cluster**: retrieve the kubeconfig and validate Kubernetes API access.  
* **Add or scale worker capacity**: create or resize node groups.  
* **Upgrade the cluster**: move the cluster to a supported Kubernetes version.  
* **Recover failed operations**: retry selected failed lifecycle actions.  
* **Delete the cluster**: deprovision the cluster and associated resources.

OneKS exposes these operations through the CLI, REST API, and Sunstone Web UI, depending on the deployment and user permissions.

## Creating a Cluster

Creating a cluster provisions the Kubernetes control plane and the supporting OpenNebula infrastructure required by the selected cluster profile.

Before creating a cluster, verify that:

* **OneKS service**: the OneKS service is configured and running.  
* **OneGate service**: OneGate is configured and reachable.  
* **Transparent proxy**: `tproxy` is configured for the required OneGate and OpenNebula XML-RPC ports.  
* **Networks**: the OpenNebula public and private virtual network IDs are known.  
* **Profiles**: the required family and flavour are available.  
* **Kubernetes version**: the target Kubernetes version is supported by the selected family.  
* **Images and templates**: required VM images, VM templates, and runtime dependencies are available.  
* **Permissions**: the user has permission to create and manage the required OneKS and OpenNebula resources.

For more detailed information refer to **Basic Configuration.**

### Create a Cluster Interactively with the CLI:**

Before creating a cluster with the CLI, identify the IDs of the OpenNebula public and private virtual networks. These networks are used to provide connectivity between OpenNebula, the virtual router, and the Kubernetes cluster, while preserving network isolation.

List the available virtual networks with:

```shell
onevnet list
```
```default
ID USER     GROUP    NAME         CLUSTERS   BRIDGE   STATE
 1 oneadmin oneadmin private      0          br1      rdy  
 0 oneadmin oneadmin public       0          br1      rdy  
```

Then launch the interactive cluster creation command:

```shell
oneks create cluster --wait
```

This starts an interactive cluster creation flow and waits until the operation completes or reaches a terminal state. You will be asked to provide the following parameters:

* **Cluster name**: the name used to identify the OneKS cluster.  
* **Kubernetes version**: the Kubernetes version to deploy.  
* **Cluster flavour**: the control-plane flavour, such as `standalone` or `ha`.  
* **Public network ID**: the OpenNebula public virtual network used by the cluster.  
* **Private network ID**: the OpenNebula private virtual network used by the cluster.

{{< image path="/images/oneks/light/k8s_cluster_create_cli.png" alt="K8s Cluster create CLI menu" align="center" width="90%" mb="20px" >}}

After the cluster is created, wait until its status changes from `PROVISIONING` to `RUNNING`.

You can then validate that the virtual router and control plane VM have been created:

```shell
onevm list
```

```default
ID USER     GROUP    NAME                     STAT   CPU  MEM    HOST
 1 oneadmin oneadmin test-cluster-qs97c       runn   2    4G     ubuntu2204-kvm-ssh-ks-7-3-kxu7a-1.test  
 0 oneadmin oneadmin vr-test-cluster-cp-0     runn   1    512M   ubuntu2204-kvm-ssh-ks-7-3-kxu7a-1.test   
```

You can also create a CLI cluster from a JSON specification:

```shell
oneks create cluster --file spec.json --wait
```

Example `spec.json`:

```json
{
  "name": "prod-west",
  "description": "Production Kubernetes cluster",
  "kubernetes_version": "v1.32.9",
  "public_network": 12,   
  "private_network": 34,
  "spec": {
    "family": "general",
    "flavour": "ha",
    "user_inputs_values": {}
  }
}
```

### Create a Cluster with the API

```
POST /api/v1/clusters
```

Example request body:

```json
{
 "name": "prod-west",
 "description": "Production Kubernetes cluster",
 "kubernetes_version": "v1.32.9",
 "public_network": 12,
 "private_network": 34,
 "spec": {
   "family": "general",
   "flavour": "ha",
   "user_inputs_values": {}
 }
}
```

Required fields:

* `name`: Cluster name.  
* `kubernetes_version`: Kubernetes version to deploy.  
* `public_network`: OpenNebula public virtual network ID.  
* `private_network`: OpenNebula private virtual network ID.  
* `spec.flavour`: selected control-plane flavour.

Optional fields:

* `description`: cluster description.  
* `spec.name`: control-plane group name.  
* `spec.description`: control-plane group description.  
* `spec.family`: profile family. If omitted, the default family is used.  
* `spec.user_inputs_values`: user-provided input values.

The `spec` object selects the family and flavour used for the control-plane group. Flavour defaults are combined with any provided user input values according to the profile override rules.

### Create a Cluster with the Sunstone Web UI  

For the Sunstone Web UI, use the cluster creation wizard described in **Getting Started**.

## Accessing a Cluster

After the cluster reaches the `RUNNING` state, retrieve its kubeconfig. The kubeconfig contains the Kubernetes API endpoint and credentials required to access the cluster.

**Retrieve the kubeconfig with the CLI**:

```shell
oneks show cluster <cluster_id> --kubeconfig > kubeconfig
```

Use the kubeconfig with standard Kubernetes commands:

```shell
KUBECONFIG=./kubeconfig kubectl get nodes
```

**Retrieve the kubeconfig with the API and save it locally**:

```shell
curl -u "$(cat /var/lib/one/.one/one_auth)" http://<oneks-server>:10780/api/v1/clusters/2/kubeconfig | jq -r '.kubeconfig' > kubeconfig
```

Use the saved kubeconfig with `kubectl`.

**Retrieve the kubeconfig with the Sunstone Web UI**:

* **Cluster detail view**: open the target cluster.  
* **Kubeconfig tab**: copy the kubeconfig content.  
* **Local file**: save it as `kubeconfig`.

**![][image18]**

**Cluster validation**: run `kubectl get nodes` with the retrieved kubeconfig.

Example output in all cases:

```shell
NAME                         STATUS   ROLES           AGE   VERSION
test-cluster-control-plane   Ready    control-plane   3m   v1.31.4
```

The command should show the control-plane nodes in a `Ready` state.

## Scaling Worker Capacity

Scaling worker capacity is done by creating or resizing node groups.

Node groups are the main operational unit for managing worker capacity in OneKS. Scaling should be performed against node groups, not directly against the cluster control plane.

### Create a Node Group with the CLI

```shell
oneks create nodegroup --cluster-id <cluster_id>
```

The command starts an interactive creation flow. You will be asked to provide:

* **Nodegroup name**: the name used to identify the worker node group.  
* **Flavour**: the worker node size profile to use.  
* **Count**: the number of worker nodes to create.

{{< image path="/images/oneks/light/oneks_create_nodegroup_cli.png" alt="OneKS create nodegroup CLI" align="center" width="90%" mb="20px" >}}

Available flavours include:

* **Small Worker Nodes**: lightweight workloads. Example defaults: 2 CPU, 2 vCPU, 4 GB RAM, 16 GB storage.  
* **Medium Worker Nodes**: balanced workloads. Example defaults: 4 CPU, 4 vCPU, 8 GB RAM, 32 GB storage.  
* **Large Worker Nodes**: demanding workloads. Example defaults: 8 CPU, 8 vCPU, 16 GB RAM, 64 GB storage.

After creation, the command returns the node group ID. Scale a node group by specifying its ID and the desired number of worker nodes:

```shell
oneks scale nodegroup 7 --target 3
```

This changes node group `7` to contain three worker nodes. 

### Create a Node Group with the API

```shell
curl -u "$(cat /var/lib/one/.one/one_auth)" -X POST http://<oneks-server>:10780/api/v1/clusters/<cluster_id>/nodegroups \
  -H "Content-Type: application/json" \
  -d '{
    "name": "workers",
    "family": "general",
    "flavour": "small",
    "user_inputs_values": {
      "count": 2
    }
  }'
```

Then verify the node group:

```shell
oneks show nodegroup <nodegroup_id>
```

Or validate from Kubernetes:

```shell
KUBECONFIG=./kubeconfig kubectl get nodes
```

### Scale a Node Group with the API

```shell
curl -u "$(cat /var/lib/one/.one/one_auth)" -X POST http://<oneks-server>:10780/api/v1/clusters/<cluster_id>/nodegroups/<nodegroup_id>/scale \
  -H "Content-Type: application/json" \
  -d '{
    "target": 3
  }'
```

From the OpenNebula front-end machine terminal, verify the new number of worker nodes with:

```shell
KUBECONFIG=./kubeconfig kubectl get nodes
```

### Scale a Node Group with the Sunstone Web UI

Use the **NodeGroup** tab described in **Getting Started**.

After creating or scaling a node group, validate the Kubernetes node list:

```shell
KUBECONFIG=./kubeconfig kubectl get nodes
```

Example output:

```shell
NAME                         STATUS   ROLES           AGE   VERSION
test-cluster-control-plane   Ready    control-plane   9m    v1.31.4
test-cluster-worker-1        Ready    <none>          2m    v1.31.4
test-cluster-worker-2        Ready    <none>          2m    v1.31.4
test-cluster-worker-3        Ready    <none>          2m    v1.31.4
```

## Upgrading a cluster

OneKS supports Kubernetes version upgrades for versions supported by the selected profile family.

Before upgrading, verify that:

* **Target version**: the target Kubernetes version is supported by the selected family.  
* **Cluster state**: the cluster is in a suitable operational state.  
* **Profiles**: the selected profiles support the target version.  
* **Workloads**: running workloads have been reviewed according to the user’s upgrade policy.  
* **Backups**: any required backups or recovery procedures have been completed.

### Upgrade a Cluster with the CLI

```shell
oneks upgrade cluster <cluster_id> --k8s-version <version>
```

Example:

```shell
oneks upgrade cluster 42 --k8s-version v1.32.9
```

After the upgrade starts, inspect the cluster state:

```shell
oneks show cluster 42
```

Validate the Kubernetes nodes:

```shell
KUBECONFIG=./kubeconfig kubectl get nodes -o wide
```

### Upgrade a Cluster with the API

```shell
curl -u "$(cat /var/lib/one/.one/one_auth)" \
  -X POST http://<oneks-server>:10780/api/v1/clusters/<cluster_id>/upgrade \
  -H "Content-Type: application/json" \
  -d '{
    "kubernetes_version": "v1.32.9"
  }'
```

The request must include the target Kubernetes version according to the API schema supported by the deployment.

After a lifecycle operation, validate both OneKS state and Kubernetes state.

Use OneKS to check whether the cluster and groups are healthy:

```shell
oneks show cluster <cluster_id>
oneks list nodegroups
```

Then validate the Kubernetes cluster directly:

```shell
KUBECONFIG=./kubeconfig kubectl get nodes -o wide
```

A successful node-group creation or scale operation should result in the node group reaching `RUNNING` in OneKS and the expected worker nodes appearing as `Ready` in Kubernetes.

If the Kubernetes nodes are `Ready` but the OneKS cluster is in `WARNING`, inspect the failed group state and cluster logs:

```shell
oneks show cluster <cluster_id>
oneks logs cluster <cluster_id>
```

A `WARNING` state means one or more underlying groups are degraded or failed, even if the Kubernetes API remains reachable.

### Upgrade a Cluster with Sunstone

In the **K8S Clusters** view, select the cluster you want to upgrade. Open the **Info** tab and scroll to the **Kubernetes Version** field.

Use the dropdown menu to select the target Kubernetes version, then confirm the upgrade.

The selected version must be supported by the cluster profile. After starting the upgrade, monitor the cluster state and logs until the cluster returns to `RUNNING`.

{{< image path="/images/oneks/light/k8s_upgrade_cluster_sunstone.png" alt="OneKS upgrade cluster Sunstone" align="center" width="90%" mb="20px" >}}

## Recovering a Cluster or Node Group

OneKS includes recovery actions for selected failure and warning states.

Recovery retries the failed lifecycle operation where possible. It may also retry failed dependency actions.

Recovery is not a general rollback mechanism. It should not be assumed to fix every infrastructure, dependency, or Kubernetes-level failure.

### Recover a Cluster with the CLI

```shell
oneks recover cluster <cluster_id>
```

### Recover a Node Group with the CLI

```shell
oneks recover nodegroup <nodegroup_id>
```

### Recover a Cluster with the API

```shell
curl -u "$(cat /var/lib/one/.one/one_auth)" \
  -X POST http://<oneks-server>:10780/api/v1/clusters/<cluster_id>/recover
```

### Recover a Node Group with the API

```shell
curl -u "$(cat /var/lib/one/.one/one_auth)" \
 -X POST http://<oneks-server>:10780/api/v1/clusters/<cluster_id>/nodegroups/<nodegroup_id>/recover
```

Then verify the recovery result:

```shell
oneks show cluster <cluster_id>
oneks show nodegroup <nodegroup_id>
oneks logs cluster <cluster_id>
```

### Recover a Node group with Sunstone

In the **K8S Clusters** view, select the cluster that contains the affected node group. Open the **NodeGroup** tab and locate the node group you want to recover. Click the **Recover Node Group** action button on the node group row.

The recovery action retries the last failed lifecycle operation where possible. It is intended for node groups in a warning or failure state, such as `PROVISIONING_FAILURE`, `SCALING_FAILURE`, or `WARNING`. After starting the recovery, monitor the cluster logs and node group state until the node group returns to `RUNNING`.

{{< image path="/images/oneks/light/k8s_recover_nodegroup_sunstone.png" alt="OneKS recover nodegroup Sunstone" align="center" width="90%" mb="20px" >}}

After recovery, inspect the affected resource and review logs:

```shell
oneks show cluster <cluster_id>
oneks show nodegroup <nodegroup_id>
oneks logs cluster <cluster_id>
``` 

## Deleting a Cluster

Deleting a cluster deprovisions the OneKS cluster and its managed resources.

### Delete a Cluster with the CLI

```shell
oneks delete cluster <cluster_id>
```

Force deletion, if required:

```shell
oneks delete cluster <cluster_id> --force
```

Use force deletion cautiously. It may skip parts of the normal deprovisioning workflow and can leave infrastructure that requires manual cleanup.

### Delete a Cluster with the API

```shell
curl -u "$(cat /var/lib/one/.one/one_auth)" \
-X DELETE "http://<oneks-server>:10780/api/v1/clusters/<cluster_id>?force=true"
```

### Delete a Cluster with Sunstone

In the **K8S Clusters** view, select the cluster you want to delete. Click the red **Delete** button next to the **Create** button.

The deletion operation deprovisions the OneKS cluster and its managed resources, including the control plane and managed node groups. Referenced infrastructure, such as the public and private virtual networks selected during cluster creation, is not normally deleted by OneKS.

After deletion, verify that the cluster no longer appears in OneKS:

```shell
oneks list clusters
```

User-level validation may also include:

```shell
onevm list
onevrouter list
onetemplate list
```

If deletion fails, inspect the cluster logs:

```shell
oneks logs cluster <cluster_id>
```
