---
title: "OneKS Overview"
linkTitle: "Overview"
date: "2026-05-12"
categories:
pageintoc: "168"
tags:
weight: "1"
type: docs
---

OneKS provides Elastic Kubernetes as a Service on OpenNebula. It offers a structured way to create, access, operate, upgrade, recover, and deprovision Kubernetes Clusters by combining a user-facing service layer with Cluster API-based infrastructure provisioning through CAPONE, the Cluster API provider for OpenNebula.

OneKS is designed for teams that need a simple and repeatable way to consume Kubernetes inside OpenNebula. Typical use cases include development and test environments, self-service Kubernetes delivery in private cloud environments, and standardized Cluster offerings for different sizes and topologies.

OneKS builds on CAPONE to expose a Cluster-centric lifecycle model for users and users. Users interact mainly with OneKS Clusters and node groups, while lower-level OpenNebula, Cluster API, and dependency-management details are handled underneath.

## Interfaces

OneKS can be accessed through the following interfaces:

* **OneKS CLI**: Used for manual Cluster and node-group operations from the command line.  
* **OneKS REST API**: Exposed under `/api/v1` for automation and programmatic integration.  
* **Sunstone Web UI**: Provides graphical workflows for creating, accessing, and managing OneKS Clusters.

## What OneKS Manages

OneKS manages Kubernetes Clusters as top-level resources. A Cluster owns or coordinates:

* **Control Plane**: One logical control-plane group, containing one or more control-plane nodes depending on the selected control-plane flavour.  
* **Node Groups**: Zero or more worker-capacity groups attached to the Cluster.  
* **Supporting Infrastructure**: Networks, images, VM templates, temporary seed VMs, virtual routers, and related OpenNebula resources.  
* **Lifecycle State**: The current operational state of the Cluster and its groups.  
* **Historical Events**: Lifecycle actions and state transitions.  
* **Access Information**: kubeconfig retrieval for Kubernetes API access.  
* **Logs:** Cluster-level and group-level lifecycle logs.

OneKS users interact primarily with the Cluster and node-group domains. Lower-level OpenNebula, CAPONE, and Cluster API resources are orchestrated beneath those abstractions.

## Related Components

OneKS should be understood together with the following adjacent components:

* [**CAPONE**]({{% relref "product/integration_references/kubernetes/kubernetes_cluster_api/" %}}): The Cluster API provider for OpenNebula. It provides the lower-level declarative lifecycle integration between Kubernetes Cluster API and OpenNebula infrastructure.  
* [**OpenNebula Cloud Resources**]({{% relref "product/virtual_machines_operation/" %}}): VM templates, networks, images, virtual routers, and related infrastructure resources used to provision and operate the Cluster.  
* [**RKE2**](https://docs.rke2.io/): The Kubernetes distribution used by the current OneKS implementation.  
* [**OneKS API**]({{% relref "platform_services/oneks/references/oneks_api/" %}}): The programmatic interface for Cluster and node-group lifecycle operations.  
* [**Kubernetes Cloud Provider**]({{% relref "product/integration_references/kubernetes/kubernetes_cloud_provider/" %}}): The in-cluster integration layer for OpenNebula infrastructure behavior.  
* [**OneGate**]({{% relref "product/operation_references/opennebula_services_configuration/onegate/" %}}): The OpenNebula service used by Virtual Machines to communicate with OpenNebula during bootstrap and runtime configuration. In a OneKS deployment, OneGate must be configured and reachable so the Cluster bootstrap process can complete successfully.  
* [**Transparent Proxy**]({{% relref "product/virtual_machines_operation/virtual_machines_networking/tproxy/" %}}) `tproxy`: The OpenNebula networking configuration used to expose required OpenNebula services, such as OneGate and the XML-RPC API, through the public network gateway. OneKS deployments require tproxy rules for ports **5030** and **2633**.  
* [**Cluster API References**]({{% relref "product/integration_references/kubernetes/kubernetes_cluster_api/" %}}): Useful when understanding the lower-level declarative lifecycle and CAPONE integration details.

### Supported Versions

OneKS supports the Kubernetes versions exposed by the configured Cluster profiles.

In the default profiles described in this document, the supported Kubernetes versions are: **v1.31.4** and **v1.32.9**. This section provides a first-use workflow for deploying a OneKS Cluster. This quick start guide uses the Sunstone Web UI. CLI and API workflows are covered in [Cluster Lifecycle Management]({{% relref "k8s_cluster_lifecycle_management" %}}).

Quick Start workflow:

* **Prepare the Environment**: Verify the minimum OneKS, OneGate, networking, profile, and permission requirements.  
* **Create the Cluster**: Use the Sunstone Web UI Cluster creation wizard.  
* **Wait for the Cluster**: Wait until the Cluster reaches the `RUNNING` state.  
* **Retrieve kubeconfig**: Copy the kubeconfig from the Cluster detail view.  
* **Validate Kubernetes Access**: Run `kubectl get nodes` using the retrieved kubeconfig.  
* **Add Worker Capacity**: Create a node group if worker nodes are required.  
* **Validate Workload Deployment**: Deploy a simple NGINX workload and test in-cluster service connectivity.