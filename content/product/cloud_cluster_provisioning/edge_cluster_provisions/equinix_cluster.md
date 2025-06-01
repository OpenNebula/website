---
title: "Equinix Edge Cluster"
date: "2025-02-17"
description:
categories:
pageintoc: "212"
tags:
weight: "3"
---

<a id="equinix-cluster"></a>

<!--# Equinix Edge Cluster -->

## Edge Cluster Types

Equinix supports **metal** Edge Clusters that use bare-metal instances to create OpenNebula Hosts. Metal provisions can run the **LXC** or **KVM** hypervisors.

## Equinix Edge Cluster Implementation

An Edge Cluster in Equinix creates the following resources:

* **Packet Device**: Host to run Virtual Machines.

The network model is implemented in the following way:

* **Public Networking**: this is implemented using elastic IPs from Equinix and the IPAM driver from OpenNebula. When the virtual network is created in OpenNebula, the elastic IPs are requested from Equinix. Then, inside the Host, IP forwarding rules are applied so the VM can communicate over the public IP assigned by Equinix.
* **Private Networking**: this is implemented using (BGP-EVPN) and VXLAN.

![image_cluster](/images/equinix_deployment.png)

## OpenNebula resources

The following resources, associated to each Edge Cluster, will be created in OpenNebula:

1. Cluster - containing all other resources
2. Hosts - for each Equinix device
3. Datastores - image and system datastores with SSH transfer manager using first instance as a replica
4. Virtual network - for public networking
5. Virtual network template - for private networking

## Operating Providers & Edge Clusters

Refer to the [cluster operation guide]({{% relref "../../cloud_cluster_provisioning/hybrid_cluster_operations" %}}) to check all of the operations needed to create, manage, and delete an Edge Cluster. Refer to the [providers guide]({{% relref "../../cloud_cluster_provisioning/hybrid_cluster_operations#provider-operations" %}}) to check all of the operations related to Providers.
