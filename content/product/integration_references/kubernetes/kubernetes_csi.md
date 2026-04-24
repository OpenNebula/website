---
title: "Kubernetes Container Storage Interface"
linkTitle: "Container Storage Interface"
date: "2026-04-23"
description:
categories:
pageintoc: "268"
tags:
weight: "4"
---

<a id="k8s-container-storage-interface"></a>

The [**Container Storage Interface (CSI)**](https://kubernetes.io/blog/2019/01/15/container-storage-interface-ga/) is a standard designed to provide a uniform way for Container Orchestration (CO) systems like Kubernetes to expose arbitrary storage systems to their containerized workloads.

By de-coupling the storage plugin development from the core Kubernetes codebase, CSI allows storage vendors to develop, build, and deploy plugins as out-of-tree components, enabling faster innovation and easier maintenance without requiring upstream changes to the orchestrator itself.

## CSI in OpenNebula

OpenNebula provides its own CSI Driver to allow Kubernetes Clusters running on OpenNebula resources to dynamically provision and manage persistent storage. This driver leverages OpenNebula's native storage capabilities, enabling users to:

* Dynamically Provision Volumes: Automatically create OpenNebula images and attach them to Virtual Machines acting as Kubernetes nodes.

* Persistent Data Management: Ensure that data remains intact even if a pod is rescheduled to a different node within an OpenNebula-managed cloud.

Find more information about the [OpenNebula CSI Driver](https://github.com/OpenNebula/storage-provider-opennebula) in the [Storage Provider Repository Wiki](https://github.com/OpenNebula/storage-provider-opennebula/wiki). 