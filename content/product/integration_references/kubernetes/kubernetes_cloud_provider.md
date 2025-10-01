---
title: "Kubernetes Cloud Provider"
linkTitle: "Cloud Provider"
date: "2025-05-19"
description:
categories:
pageintoc: "269"
tags:
weight: "3"
---

<a id="k8s-cloud-provider"></a>

<!--# Kubernetes Cloud Provider -->

The [Kubernetes Cloud-Provider Interface](https://github.com/kubernetes/kubernetes/tree/master/staging/src/k8s.io/cloud-provider) allows Kubernetes to interact with the underlying cloud infrastructure through the cluster-provider controller. This allows Kubernetes to manage cloud resources like nodes, load-balancers, etc.

OpenNebula offers its own Kubernetes cloud-provider implementation for providing nodes and load-balancers to Kubernetes clusters. You can find more information in the [OpenNebula Cloud-Provider documentation](https://github.com/OpenNebula/cloud-provider-opennebula/wiki).
