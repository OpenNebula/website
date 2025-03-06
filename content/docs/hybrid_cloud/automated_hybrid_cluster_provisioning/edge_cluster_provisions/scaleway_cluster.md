---
title: "Scaleway Edge Cluster"
date: "2025/02/17"
description:
categories:
pageintoc: "213"
tags:
weight: "4"
---

<a id="scaleway-cluster"></a>

<!--# Scaleway Edge Cluster -->

## Edge Cluster Types

Equinix supports **metal** edge clusters that use bare-metal instances to create OpenNebula Hosts. Metal provisions can run the **LXC** or **KVM** hypervisors.

## Scaleway Edge Cluster Implementation

An Edge Cluster in Scaleway creates the following resources:

* **Scaleway Elastic Metal Device**: Host to run virtual machines.
* **Scaleway VPC**: it creates an isolated virtual network for all the deployed resources.
* **Scaleway private subnet**: it allows communication between VMs that are running in the provisioned Hosts.
* **Scaleway internet public gateway**: it allows VMs to have public connectivity over Internet.

The network model is implemented in the following way:

* **Public Networking**: this is implemented using elastic IPs from Scaleway and the IPAM driver from OpenNebula. When the virtual network is created in OpenNebula, the elastic IPs are requested from Scaleway. Then, inside the Host, IP forwarding rules are applied so the VM can communicate over the public IP assigned by Scaleway.
* **Private Networking**: this is implemented using (BGP-EVPN) and VXLAN.

![image_cluster](/images/scaleway-deployment.jpg)

## OpenNebula resources

The following resources, associated to each Edge Cluster, will be created in OpenNebula:

1. Cluster - containing all other resources.
2. Hosts - for each Scaleway Elastic Metal Device.
3. Datastores - image and system datastores with SSH transfer manager using first instance as a replica.
4. Virtual network - for public networking.
5. Virtual network template - for private networking.

## Operating Providers & Edge Clusters

Refer to the [cluster operation guide]({{% relref "../../operations_and_references/hybrid_cluster_operations/cluster_operations#cluster-operations" %}}) to check all of the operations needed to create, manage, and delete an Edge Cluster. Refer to the [providers guide]({{% relref "../../operations_and_references/hybrid_cluster_operations/provider_operations#provider-operations" %}}) to check all of the operations related to providers.

You can also manage AWS and Equinix Clusters using the OneProvision GUI in Sunstone.

![image_fireedge](/images/oneprovision_fireedge.png)
