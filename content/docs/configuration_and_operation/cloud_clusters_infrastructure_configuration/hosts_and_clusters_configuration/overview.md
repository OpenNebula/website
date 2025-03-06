---
title: "Overview"
date: "2025/02/17"
description:
categories:
pageintoc: "52"
tags:
weight: "1"
---

<a id="hostsubsystem"></a>

<!--# Overview -->

A **Host** is a server that has the ability to run Virtual Machines and that is connected to OpenNebula’s Front-end server. To learn how to prepare the Hosts, you can read the [Installation]({{% relref "/docs/releases/installation" %}}) guide. Hosts are usually grouped in **Clusters**.

## How Should I Read This Chapter

In this chapter there are four guides describing these objects.

* **Host Management**: Host management is achieved through the `onehost` CLI command or through the Sunstone GUI. You can read about Host Management in more detail in the [Managing Hosts]({{% relref "hosts#hosts-guide" %}}) guide.
* **Cluster Management**: Hosts can be grouped in clusters. These clusters are managed with the `onecluster` CLI command or through the Sunstone GUI. You can read about Cluster Management in more detail in the [Managing Clusters]({{% relref "cluster_guide#cluster-guide" %}}) guide.

You should read all the guides in this chapter to familiarize yourself with these objects. For small and homogeneous clouds you may not need to create new clusters.

## Hypervisor Compatibility

These guides are compatible with all hypervisors.
