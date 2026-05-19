---
title: "OneKS Service Architecture"
linkTitle: "Service Architecture"
date: "2026-05-12"
description:
categories:
tags:
weight: "5"
type: docs
---

This section describes the architecture of OneKS, the OpenNebula Kubernetes Service. OneKS provides a Kubernetes-as-a-Service layer on top of OpenNebula, enabling Kubernetes Clusters to be deployed and operated across cloud and edge environments.

OneKS simplifies the creation, operation, scaling, upgrade, recovery, and deprovisioning of Kubernetes Clusters in OpenNebula-based infrastructures. It exposes Kubernetes Clusters as high-level OpenNebula-managed resources, while infrastructure provisioning, dependency management, and lifecycle orchestration are handled by the service.

## Service Architecture

The OneKS architecture follows a layered orchestration model. At the highest level, users interact with a OneKS K8s Cluster resource. Beneath the Cluster, OneKS manages one logical control-plane group, zero or more node groups, and supporting dependencies such as the Seed VM and the K8s Cluster Router.

{{< image path="/images/oneks/oneks_service_architecture.svg" alt="OneKS Service Architecture" align="center" width="60%" mb="20px" border="false" shadow="false">}}

The service sits between the Kubernetes Cluster layer and the OpenNebula infrastructure layer. CAPONE connects Kubernetes Cluster API resources with OpenNebula primitives, while OneKS acts as the service gateway and lifecycle orchestrator.

## Deployed Infrastructure Architecture

From an infrastructure perspective, a Kubernetes workload Cluster deployed by OneKS is composed of three main components:

| **Component**        | **Purpose** |
|------------------|---------|
| Virtual Router   | Provides connectivity between the Kubernetes Cluster, the internal OpenNebula network, and external networks. |
| Control Plane    | Hosts the Kubernetes management services and exposes the Kubernetes API. |
| Worker Nodes     | Provide compute capacity where application containers are executed. |

Each component is implemented through one or more OpenNebula VMs. The Virtual Router is attached to both the public and private networks and acts as the network entry point for the K8s Cluster. The control-plane VM is attached to the private network and provides the Kubernetes API and management services. Worker nodes are also attached to the private network and run the application workloads scheduled by Kubernetes.

{{< image path="/images/oneks/oneks_deployed_architecture.svg" alt="OneKS Deployed Architecture" align="center" width="60%" mb="20px" >}}

In this model, the public network provides external access through the Virtual Router, while the private network interconnects the control-plane and worker-node VMs. From the OpenNebula perspective, the resulting K8s Cluster appears as a set of managed resources, including one virtual router, one or more control-plane machines, and one or more worker machines provisioned by CAPONE.

## Domain Architecture

From a domain-oriented perspective, OneKS is organized into three main layers:

{{< image path="/images/oneks/oneks_domain_architecture.svg" alt="OneKS Domain Architecture" align="center" width="80%" mb="20px" >}}

| **Domain**                          | **Description** |
|---------------------------------|-------------|
| Kubernetes Cluster domain       | Highest-level domain and the one users interact with directly. A OneKS K8s Cluster represents a Kubernetes Cluster deployed on OpenNebula and stores the main information required to manage it, including metadata, Kubernetes information, network references, lifecycle state, and related groups. |
| Kubernetes Group domain         | Represents logical sets of Kubernetes nodes. OneKS provides two group implementations: the control-plane group and the worker node group. Both follow a common group interface, allowing them to be orchestrated consistently as part of the K8s Cluster lifecycle. |
| Kubernetes Group Dependency domain | Contains auxiliary resources required by each group implementation. In the control-plane implementation, these dependencies include the Seed VM and the K8s Cluster Router. Dependencies report their state to the group that orchestrates them. |

These domains form a hierarchical orchestration model. Each domain orchestrates the domain immediately below it, while lower-level domains report state changes and errors upwards. Users interact primarily with the OneKS K8s Cluster, while groups and dependencies remain internal modular resources managed as part of the K8s Cluster lifecycle.
