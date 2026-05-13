---
title: "OneKS CLI Reference"
linkTitle: "CLI"
date: "2026-05-12"
description:
categories:
tags:
weight: "2"
type: docs
---

The OneKS CLI is provided by the `oneks` binary.

General form:

```shell
oneks <command> <resource> [<args>] [<options>]
```

Product-facing resources are:

* `cluster`: OneKS cluster resource.  
* `nodegroup`: worker-capacity group attached to a cluster.

The CLI may also expose plural forms:

* `clusters`: list or top cluster resources.  
* `nodegroups`: list or top node-group resources.

Important command naming note:

Some builds may expose node groups through the lower-level `group` resource in CLI help. Before publication, align this section with the exact shipped CLI behavior. If the shipped CLI uses `group`, the examples must use `group` consistently. If the product-facing resource is `nodegroup`, the CLI help should expose `nodegroup` consistently.

## Common commands

* `oneks list clusters`: list clusters.  
* `oneks list nodegroups`: list node groups.  
* `oneks top clusters`: continuously display cluster status.  
* `oneks top nodegroups`: continuously display node-group status.  
* `oneks show cluster <cluster_id>`: show detailed cluster information.  
* `oneks show nodegroup <nodegroup_id>`: show detailed node-group information.  
* `oneks create cluster`: create a cluster.  
* `oneks create nodegroup --cluster-id <cluster_id>`: create a node group.  
* `oneks recover cluster <cluster_id>`: recover a cluster from selected failure states.  
* `oneks recover nodegroup <nodegroup_id>`: recover a node group from selected failure states.  
* `oneks delete cluster <cluster_id>`: delete a cluster.  
* `oneks delete nodegroup <nodegroup_id>`: delete a node group.  
* `oneks logs cluster <cluster_id>`: show cluster logs.  
* `oneks upgrade cluster <cluster_id> --k8s-version <version>`: upgrade a cluster version.  
* `oneks scale nodegroup <nodegroup_id> --target <count>`: scale a node group.  
* `oneks chgrp cluster <cluster_id> <group_id>`: change cluster group ownership.  
* `oneks chown cluster <cluster_id> <user_id> <group_id>`: change cluster owner and group.  
* `oneks chmod cluster <cluster_id> <octet>`: change cluster permissions.

## Common examples



Create and access a cluster:

```shell
oneks create cluster --wait
oneks create cluster --file spec.json --wait
oneks show cluster 42 --kubeconfig > kubeconfig
KUBECONFIG=./kubeconfig kubectl get nodes
```

List and inspect resources:

```shell
oneks list clusters
oneks top clusters
oneks show cluster 42
oneks list nodegroups
oneks show nodegroup 7
```

Manage worker capacity:

```shell
oneks create nodegroup --cluster-id 42
oneks scale nodegroup 7 --target 3
```

Upgrade a cluster:

```shell
oneks upgrade cluster 42 --k8s-version v1.32.9
```

Recover a cluster or node group:

```shell
oneks recover cluster 42
oneks recover nodegroup 7
```

Inspect logs:

```shell
oneks logs cluster 42
oneks logs cluster 42 --follow
```

Delete a cluster:

```shell
oneks delete cluster 42
oneks delete cluster 42 --force
```

Administrative cluster operations:

```shell
oneks rename cluster 42 new-name
oneks chgrp cluster 42 100
oneks chown cluster 42 10 100
oneks chmod cluster 42 640
```