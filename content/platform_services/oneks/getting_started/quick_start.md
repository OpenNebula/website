---
title: "Quick Start"
linkTitle: "Quick Start"
date: "2026-05-12"
description:
categories:
tags:
weight: "3"
type: docs
---

This section provides a short first-use workflow for deploying a OneKS Cluster. From the left-hand navigation menu in Sunstone, go to **Kubernetes -> K8S Clusters**:

{{< image path="/images/oneks/light/create_k8s_cluster_1.png" alt="OneKS create Cluster step 1" align="center" width="90%" mb="20px" >}}

Click **Create** to start the Cluster creation wizard.

The wizard guides you through the required configuration steps:

* **General**: Cluster name and optional description.  
* **Select a Public Virtual Network**: Public network used for external connectivity and bootstrap paths.  
* **Select a Private Virtual Network**: Private network used for internal Cluster communication.  
* **Kubernetes Version**: Kubernetes version to deploy.  
* **Flavours**: Control-plane flavour to use.  
* **User inputs**: Remaining values required by the selected profile and flavour.

In the **General** step, provide the basic Cluster information. Enter a Cluster name and, optionally, a description.

{{< image path="/images/oneks/light/create_k8s_cluster_2.png" alt="OneKS create Cluster general" align="center" width="90%" mb="20px" >}}

In **Select a Public Virtual Network**, select the public Virtual Network that will provide external connectivity for the Cluster. The public network acts as the gateway to the Internet and is used by the Cluster to expose external access where required.

{{< image path="/images/oneks/light/create_k8s_cluster_3.png" alt="OneKS create Cluster public network" align="center" width="90%" mb="20px" >}}

In **Select a Private Virtual Network**, select the private Virtual Network that will be used for internal Cluster communication. This network provides isolation from the public Internet and is used for communication between the Cluster nodes.

{{< image path="/images/oneks/light/create_k8s_cluster_4.png" alt="OneKS create Cluster private network" align="center" width="90%" mb="20px" >}}

In **Kubernetes Version**, select the Kubernetes version you intend to deploy. Only the versions available in the environment are shown.

{{< image path="/images/oneks/light/create_k8s_cluster_version.png" alt="OneKS create Cluster choose k8s version" align="center" width="90%" mb="20px" >}}

In **Flavours**, select the control-plane flavour for the Cluster. The flavour defines the control-plane deployment model and the resources used by the control-plane nodes.

Available options include:

* **Single-Node Control Plane**: Deploys one control-plane node. Suitable for development, evaluation, and non-critical workloads.  
* **Highly Available Control Plane**: Deploys three control-plane nodes with built-in redundancy. Suitable for production or environments that require higher availability.

{{< image path="/images/oneks/light/create_k8s_cluster_flavours.png" alt="OneKS create Cluster choose k8s version" align="center" width="90%" mb="20px" >}}

In **User Inputs**, review the remaining user input parameters required by the selected Cluster configuration.

After completing the required fields, finish the wizard to start Cluster creation. You will be redirected to the **Kubernetes Logs** view, where you can monitor the provisioning process.

During provisioning, the Cluster initially appears with a `CREATING` or `PROVISIONING` status. The control-plane nodes are provisioned according to the selected flavour. This process typically takes several minutes.

{{< image path="/images/oneks/light/k8s_logs_creating.png" alt="OneKS create Cluster choose k8s version" align="center" width="90%" mb="20px" >}}

Wait until the Cluster reaches the `RUNNING` state.

{{< image path="/images/oneks/light/create_k8s_logs_running.png" alt="OneKS create Cluster choose k8s version" align="center" width="90%" mb="20px" >}}

## Retrieve the Kubeconfig

After the Cluster reaches the `RUNNING` state, you can retrieve its kubeconfig from the Sunstone Web UI. 

From **Kubernetes -> K8S Clusters**, open the target Cluster. In the Cluster detail view, select the **Kubeconfig** tab.

{{< image path="/images/oneks/light/k8s_kubeconfig.png" alt="OneKS create Cluster choose k8s version" align="center" width="90%" mb="20px" >}}

The kubeconfig content is displayed in the text area. Use the copy button to copy it, then save it locally as a file named `kubeconfig`.

Use the kubeconfig with standard Kubernetes commands:

```shell
KUBECONFIG=./kubeconfig kubectl get nodes
```

## Add Worker Capacity

Node groups are the main operational unit for managing worker capacity in OneKS. After the Cluster is running, you can add worker capacity by creating a node group from the Sunstone Web UI.

From **Kubernetes -> K8S Clusters**, open the target Cluster. Select the **NodeGroup** tab, then click **Add Node Group**.

{{< image path="/images/oneks/light/k8s_add_node_group.png" alt="OneKS create Cluster choose k8s version" align="center" width="90%" mb="20px" >}}

The node group creation wizard guides you through the required configuration steps:

* **General**: Node group name and optional description.  
* **Flavours**: Worker node flavour.  
* **User inputs**: Node count and remaining values required by the selected flavour.

In the **General** step, provide the basic node group information. Enter a node group name and, optionally, a description.

{{< image path="/images/oneks/light/k8s_node_group_name.png" alt="OneKS create Cluster choose k8s version" align="center" width="90%" mb="20px" >}}

In **Flavours**, select the worker node flavour. The flavour defines the resource profile that will be used to deploy the worker nodes in this node group.

Available options include:

* **Small Worker Nodes**: Suitable for lightweight workloads.  
* **Medium Worker Nodes**: Suitable for balanced workloads.  
* **Large Worker Nodes**: Suitable for demanding workloads.

Each flavour shows its default resource configuration, such as CPU, memory, and disk size.

{{< image path="/images/oneks/light/k8s_choose_flavours.png" alt="OneKS create Cluster choose k8s version" align="center" width="90%" mb="20px" >}}

In **User Inputs**, set the number of worker nodes to create. For example, set **Count** to `2` to create two worker nodes. The remaining fields, such as **CPU**, **Virtual CPU**, **Memory**, and **Disk Size**, are populated from the selected flavour.

{{< image path="/images/oneks/light/k8s_user_inputs.png" alt="OneKS create Cluster choose k8s version" align="center" width="90%" mb="20px" >}}

After finishing the wizard, you will be redirected to the **Kubernetes Logs** view, where you can monitor the node group provisioning process.

Wait until the node group reaches the `RUNNING` state and the Cluster returns to `RUNNING`.

{{< image path="/images/oneks/light/k8s_logs_adding_node_group.png" alt="OneKS create Cluster choose k8s version" align="center" width="90%" mb="20px" >}}

From the OpenNebula Front-end machine command line, verify the new worker nodes with:

```shell
KUBECONFIG=./kubeconfig kubectl get nodes
```

Example output:

```default
NAME                         STATUS   ROLES           AGE   VERSION
test-cluster-control-plane   Ready    control-plane   15m   v1.31.4
test-cluster-worker-1        Ready    <none>          3m    v1.31.4
test-cluster-worker-2        Ready    <none>          3m    v1.31.4
``` 

## Validate Workload Deployment and Service Connectivity

After the Cluster nodes are in the `Ready` state, you can deploy a simple workload to verify that the Cluster is functioning correctly.

Create a test `NGINX` pod:

```shell
KUBECONFIG=./kubeconfig kubectl run nginx-test --image=nginx:stable --restart=Never
```

Expected output:

```default
pod/nginx-test created
```

Check the pod status:

```shell
KUBECONFIG=./kubeconfig kubectl get pod nginx-test -o wide
```

Expected output:

```default
NAME         READY   STATUS    RESTARTS   AGE   IP            NODE     
nginx-test   1/1     Running   0          27s   10.244.5.46   worker01 
```

This confirms that the Cluster can schedule and start a workload on a worker node.

Expose the pod as a service:

```shell
KUBECONFIG=./kubeconfig kubectl expose pod nginx-test --port=80 --target-port=80 --name=nginx-test
```

Create a temporary curl pod to test in-cluster service connectivity:

```shell
KUBECONFIG=./kubeconfig kubectl run curl-test --image=curlimages/curl:latest \
           --rm -it --restart=Never -- curl -I http://nginx-test
```

Expected output:

```default
HTTP/1.1 200 OK
Server: nginx/1.30.0
Date: Wed, 06 May 2026 08:56:45 GMT
Content-Type: text/html
Content-Length: 896
Last-Modified: Tue, 14 Apr 2026 13:10:11 GMT
Connection: keep-alive
ETag: "69de3cb3-380"
Accept-Ranges: bytes

pod "curl-test" deleted from default namespace
```

A `200` `OK` response confirms that the NGINX pod is running and reachable through the Kubernetes service. This test validates that basic workload scheduling, pod networking, DNS-based service discovery, and in-cluster connectivity are all working.
