---
title: "Kubernetes Cluster API Integration"
date: "2025-02-17"
description:
categories:
pageintoc: "268"
tags:
weight: "3"
---

<a id="k8s-cluster-api"></a>

<!--# Kubernetes Cluster API -->

Kubernetes provides the Cluster API, a set of declarative APIs and tooling for simplifying and automating the provisioning, upgrade, delete and operation of multiple Kubernetes clusters in a declarative and extensible way, like if they were workloads of a management Kubernetes Cluster.

OpenNebula provides its own implementation of the Cluster API (CAPONE) to easily provision and operate Kubernetes clusters. It interacts with OpenNebula for provision dedicated VMs (through the [OpenNebula Cloud Provider](./kubernetes_cloud_provider.md)) and build the Kubernetes workload cluster, including the control plane nodes. More information on the [OpenNebula Cluster Api Provider wiki](https://github.com/OpenNebula/cluster-api-provider-opennebula/wiki).
