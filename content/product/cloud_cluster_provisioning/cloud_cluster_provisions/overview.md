---
title: "Overview"
date: "2025-02-17"
description:
categories:
pageintoc: "210"
tags:
weight: "1"
---

<!--# Overview -->

Edge Clusters provide the tools to dynamically grow your cloud infrastructure with physical or virtual resources running on remote cloud providers. Edge Clusters support two main use cases:

* **Edge Cloud Computing**: to transition from centralized clouds to distributed edge-like cloud environments. You will be able to grow your on-premises cloud with resources at edge data center locations to meet the latency, bandwidth or data regulation needs of your workload.
* **Hybrid Cloud Computing**: to address peaks of demand and additional computing power by dynamically growing the underlying physical infrastructure.

Edge Clusters are based on open source storage and networking technologies. They feature a selection of light-weight components specially suited for edge locations.

## Basic Outline

This guide describes how to automatically provision Edge Clusters instances on different providers:

- [On-Premises Edge Clusters]({{% relref "onprem_cluster" %}})
- [Equinix Edge Clusters]({{% relref "equinix_cluster#equinix-cluster" %}})
- [Amazon AWS Edge Clusters]({{% relref "aws_cluster#aws-cluster" %}})
- [Scaleway Edge Cluster]({{% relref "scaleway_cluster" %}})

## Hypervisor Compatibility

Edge Clusters are compatible with the KVM and LXC hypervisors.
