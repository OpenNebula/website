---
title: "OneKS Cluster Lifecycle Management"
linkTitle: "Cluster Lifecycle Management"
date: "2026-05-12"
description:
categories:
tags:
weight: "1"
type: docs
---

This section describes the main lifecycle operations for OneKS Clusters. It covers how to create, access, scale, upgrade, recover, and delete Clusters.

A OneKS Cluster lifecycle normally follows this sequence:

* **Create a Cluster**: Provision the control plane and required infrastructure.  
* **Access the Cluster**: Retrieve the kubeconfig and validate Kubernetes API access.  
* **Add or Scale Worker Capacity**: Create or resize node groups.  
* **Upgrade the Cluster**: Move the Cluster to a supported Kubernetes version.  
* **Recover Failed Operations**: Retry selected failed lifecycle actions.  
* **Delete the Cluster**: Deprovision the Cluster and associated resources.

OneKS exposes these operations through the CLI, REST API, and Sunstone Web UI, depending on the deployment and user permissions.

## Creating a Cluster

Creating a Cluster provisions the Kubernetes control plane and the supporting OpenNebula infrastructure required by the selected Cluster profile.

Before creating a Cluster, verify that:

* **OneKS Service**: The OneKS service is configured and running.  
* **OneGate Service**: OneGate is configured and reachable.  
* **Transparent Proxy**: `tproxy` is configured for the required OneGate and OpenNebula XML-RPC ports.  
* **Networks**: The OpenNebula public and private Virtual Network IDs are known.  
* **Profiles**: The required family and flavour are available.  
* **Kubernetes Version**: The target Kubernetes version is supported by the selected family.  
* **Images and Templates**: Required VM images, VM templates, and runtime dependencies are available.  
* **Permissions**: The user has permission to create and manage the required OneKS and OpenNebula resources.

For more detailed information refer to the [Basic Configuration Guide]({{% relref "platform_services/oneks/getting_started/basic_configuration" %}}).

### Create a Cluster Interactively with the CLI

Before creating a Cluster with the CLI, identify the IDs of the OpenNebula public and private Virtual Networks. These networks are used to provide connectivity between OpenNebula, the virtual router, and the Kubernetes Cluster, while preserving network isolation.

List the available Virtual Networks with:

```shell
onevnet list
```
```default
ID USER     GROUP    NAME         CLUSTERS   BRIDGE   STATE
 1 oneadmin oneadmin private      0          br1      rdy  
 0 oneadmin oneadmin public       0          br1      rdy  
```

Then launch the interactive Cluster creation command:

```shell
oneks create cluster --wait
```

This starts an interactive Cluster creation flow and waits until the operation completes or reaches a terminal state. You will be asked to provide the following parameters:

* **Cluster Name**: The name used to identify the OneKS Cluster.  
* **Kubernetes Version**: The Kubernetes version to deploy.  
* **Cluster Flavour**: The control-plane flavour, such as `standalone` or `ha`.  
* **Public Network ID**: The OpenNebula public Virtual Network used by the Cluster.  
* **Private Network ID**: The OpenNebula private Virtual Network used by the Cluster.

{{< image path="/images/oneks/light/k8s_cluster_create_cli.png" alt="K8s Cluster create CLI menu" align="center" width="60%" mb="20px" >}}

After the Cluster is created, wait until its status changes from `PROVISIONING` to `RUNNING`.

You can then validate that the virtual router and control plane VM have been created:

```shell
onevm list
```

```default
ID USER     GROUP    NAME                     STAT   CPU  MEM    HOST
 1 oneadmin oneadmin test-cluster-qs97c       runn   2    4G     ubuntu2204-kvm-ssh-ks-7-3-kxu7a-1.test  
 0 oneadmin oneadmin vr-test-cluster-cp-0     runn   1    512M   ubuntu2204-kvm-ssh-ks-7-3-kxu7a-1.test   
```

You can also create a Cluster from a JSON specification with the CLI:

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

You can create a Cluster with the API using the following command:

```shell
curl -u "$(cat /var/lib/one/.one/one_auth)" \
  -X POST http://127.0.0.1:10780/api/v1/clusters \
  -H "Content-Type: application/json" \
  -d '{
    "name": "prod-west",
    "description": "Production Kubernetes cluster",
    "kubernetes_version": "v1.32.9",
    "public_network": 0,
    "private_network": 1,
    "spec": {
      "family": "general",
      "flavour": "ha",
      "user_inputs_values": {}
    }
  }'
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
* `public_network`: OpenNebula public Virtual Network ID.  
* `private_network`: OpenNebula private Virtual Network ID.  
* `spec.flavour`: Selected control-plane flavour.

Optional fields:

* `description`: Cluster description.  
* `spec.name`: Control-plane group name.  
* `spec.description`: Control-plane group description.  
* `spec.family`: Profile family. If omitted, the default family is used.  
* `spec.user_inputs_values`: User-provided input values.

The `spec` object selects the family and flavour used for the control-plane group. Flavour defaults are combined with any provided user input values according to the profile override rules.

### Create a Cluster with the Sunstone Web UI  

For the Sunstone Web UI, use the Cluster creation wizard described in the [Getting Started with OneKS Quick-start Guide]({{% relref "platform_services/oneks/getting_started/quick_start/" %}}).

## Accessing a Cluster

After the Cluster reaches the `RUNNING` state, retrieve its kubeconfig. The kubeconfig contains the Kubernetes API endpoint and credentials required to access the Cluster.

### Retrieve the kubeconfig with the CLI

```shell
oneks show cluster <cluster_id> --kubeconfig > kubeconfig
```

Use the kubeconfig with standard Kubernetes commands:

```shell
KUBECONFIG=./kubeconfig kubectl get nodes
```

### Retrieve the kubeconfig with the API and Save it Locally

```shell
curl -u "$(cat /var/lib/one/.one/one_auth)" http://<oneks-server>:10780/api/v1/clusters/2/kubeconfig | jq -r '.kubeconfig' > kubeconfig
```

Use the saved kubeconfig with `kubectl`.

### Retrieve the kubeconfig with the Sunstone Web UI

* **Cluster Detail View**: Open the target Cluster.  
* **Kubeconfig Tab**: Copy the kubeconfig content.  
* **Local File**: Save it as `kubeconfig`.

{{< image path="/images/oneks/light/k8s_kubeconfig.png" alt="OneKS create Cluster choose k8s version" align="center" width="90%" mb="20px" >}}

**Cluster validation**: run `kubectl get nodes` with the retrieved kubeconfig.

Example output in all cases:

```shell
NAME                         STATUS   ROLES           AGE   VERSION
test-cluster-control-plane   Ready    control-plane   3m   v1.31.4
```

The command should show the control-plane nodes in a `Ready` state.

## Scaling Worker Capacity

Scaling worker capacity is done by creating or resizing node groups.

Node groups are the main operational unit for managing worker capacity in OneKS. Scaling should be performed against node groups, not directly against the Cluster control plane.

### Create a Node Group with the CLI

```shell
oneks create nodegroup --cluster-id <cluster_id>
```

The command starts an interactive creation flow. You will be asked to provide:

* **Nodegroup Name**: The name used to identify the worker node group.  
* **Flavour**: The worker node size profile to use.  
* **Count**: The number of worker nodes to create.

{{< image path="/images/oneks/light/oneks_create_nodegroup_cli.png" alt="OneKS create nodegroup CLI" align="center" width="60%" mb="20px" >}}

Available flavours include:

* **Small Worker Nodes**: Lightweight workloads. Example defaults: 2 CPU, 2 vCPU, 4 GB RAM, 16 GB storage.  
* **Medium Worker Nodes**: Balanced workloads. Example defaults: 4 CPU, 4 vCPU, 8 GB RAM, 32 GB storage.  
* **Large Worker Nodes**: Demanding workloads. Example defaults: 8 CPU, 8 vCPU, 16 GB RAM, 64 GB storage.

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

From the OpenNebula Front-end machine terminal, verify the new number of worker nodes with:

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

## Upgrading a Cluster

OneKS supports Kubernetes version upgrades for versions supported by the selected profile family.

Before upgrading, verify that:

* **Target Version**: The target Kubernetes version is supported by the selected family.  
* **Cluster State**: The Cluster is in a suitable operational state.  
* **Profiles**: The selected profiles support the target version.  
* **Workloads**: Running workloads have been reviewed according to the user’s upgrade policy.  
* **Backups**: Any required backups or recovery procedures have been completed.

### Upgrade a Cluster with the CLI

```shell
oneks upgrade cluster <cluster_id> --k8s-version <version>
```

Example:

```shell
oneks upgrade cluster 42 --k8s-version v1.32.9
```

After the upgrade starts, inspect the Cluster state:

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

Use OneKS to check whether the Cluster and groups are healthy:

```shell
oneks show cluster <cluster_id>
oneks list nodegroups
```

Then validate the Kubernetes Cluster directly:

```shell
KUBECONFIG=./kubeconfig kubectl get nodes -o wide
```

A successful node-group creation or scale operation should result in the node group reaching `RUNNING` in OneKS and the expected worker nodes appearing as `Ready` in Kubernetes.

If the Kubernetes nodes are `Ready` but the OneKS Cluster is in `WARNING`, inspect the failed group state and Cluster logs:

```shell
oneks show cluster <cluster_id>
oneks logs cluster <cluster_id>
```

A `WARNING` state means one or more underlying groups are degraded or failed, even if the Kubernetes API remains reachable.

### Upgrade a Cluster with Sunstone

In the **K8S Clusters** view, select the Cluster you want to upgrade. Open the **Info** tab and scroll to the **Kubernetes Version** field.

Use the dropdown menu to select the target Kubernetes version, then confirm the upgrade.

The selected version must be supported by the Cluster profile. After starting the upgrade, monitor the Cluster state and logs until the Cluster returns to `RUNNING`.

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

In the **K8S Clusters** view, select the Cluster that contains the affected node group. Open the **NodeGroup** tab and locate the node group you want to recover. Click the **Recover Node Group** action button on the node group row.

The recovery action retries the last failed lifecycle operation where possible. It is intended for node groups in a warning or failure state, such as `PROVISIONING_FAILURE`, `SCALING_FAILURE`, or `WARNING`. After starting the recovery, monitor the Cluster logs and node group state until the node group returns to `RUNNING`.

{{< image path="/images/oneks/light/k8s_recover_nodegroup_sunstone.png" alt="OneKS recover nodegroup Sunstone" align="center" width="90%" mb="20px" >}}

After recovery, inspect the affected resource and review logs:

```shell
oneks show cluster <cluster_id>
oneks show nodegroup <nodegroup_id>
oneks logs cluster <cluster_id>
``` 

## Deleting a Cluster

Deleting a Cluster deprovisions the OneKS Cluster and its managed resources.

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

In the **K8S Clusters** view, select the Cluster you want to delete. Click the red **Delete** button next to the **Create** button.

The deletion operation deprovisions the OneKS Cluster and its managed resources, including the control plane and managed node groups. Referenced infrastructure, such as the public and private Virtual Networks selected during Cluster creation, is not normally deleted by OneKS.

After deletion, verify that the Cluster no longer appears in OneKS:

```shell
oneks list clusters
```

User-level validation may also include:

```shell
onevm list
onevrouter list
onetemplate list
```

If deletion fails, inspect the Cluster logs:

```shell
oneks logs cluster <cluster_id>
```
