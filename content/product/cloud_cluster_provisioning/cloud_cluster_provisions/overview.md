---
title: "Cloud Cluster Provisions Overview"
linkTitle: "Overview"
date: "2025-02-17"
description:
categories:
pageintoc: "210"
tags:
weight: "1"
---

<!--# Overview -->

Edge Clusters provide the tools to dynamically grow your cloud infrastructure with physical or virtual resources running on remote cloud service Providers. Edge Clusters support two main use cases:

* **Edge Cloud Computing**: To transition from centralized clouds to distributed edge-like cloud environments. You can grow your on-premises cloud with resources at edge data center locations to meet the latency, bandwidth or data regulation needs of your workload.
* **Hybrid Cloud Computing**: To address peaks of demand and additional computing power by dynamically growing the underlying physical infrastructure.

Edge Clusters are based on open-source storage and networking technologies. They feature a selection of light-weight components specifically designed for edge locations.

## Basic Outline

These guides describe how to automatically provision Edge Cluster instances on different Providers:

- [On-premises Edge Cluster with SSH]({{% relref "onprem_ssh_cluster" %}})
- [On-premises Edge Cluster with NFS]({{% relref "onprem_nfs_cluster" %}})
- [Equinix Edge Clusters]({{% relref "equinix_cluster#equinix-cluster" %}})
- [Amazon AWS Edge Clusters]({{% relref "aws_cluster#aws-cluster" %}})
- [Scaleway Edge Cluster]({{% relref "scaleway_cluster" %}})

## Hypervisor Compatibility

Edge Clusters are compatible with KVM hypervisors. Compatibility with additional hypervisors, such as LXC, will be added in the future.
