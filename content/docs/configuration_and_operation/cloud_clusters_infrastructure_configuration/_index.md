---
title: "Cloud Clusters Infrastructure Configuration"
date: "2025-02-17"
description: "Define the fundamental building blocks of your cloud: hosts, clusters, networks and storage"
categories:
pageintoc: "50"
tags:
weight: "2"
---

<a id="cloud-clusters-infrastructure-configuration"></a>

<!--# Cloud Clusters Infrastructure Configuration -->

* [Hosts and Clusters Configuration]({{% relref "hosts_and_clusters_configuration/index" %}})
  * [Overview]({{% relref "hosts_and_clusters_configuration/overview" %}})
  * [Hosts]({{% relref "hosts_and_clusters_configuration/hosts" %}})
  * [Clusters]({{% relref "hosts_and_clusters_configuration/cluster_guide" %}})
  * [Virtual Topology and CPU Pinning]({{% relref "hosts_and_clusters_configuration/numa" %}})
  * [PCI Passthrough]({{% relref "hosts_and_clusters_configuration/pci_passthrough" %}})
  * [NVIDIA GPU]({{% relref "hosts_and_clusters_configuration/vgpu" %}})
* [Networking System Configuration]({{% relref "networking_system_configuration/index" %}})
  * [Overview]({{% relref "networking_system_configuration/overview" %}})
  * [Defining and Managing Virtual Networks]({{% relref "networking_system_configuration/manage_vnets" %}})
  * [Node Setup]({{% relref "networking_system_configuration/node" %}})
  * [Bridged Networking]({{% relref "networking_system_configuration/bridged" %}})
  * [802.1Q VLAN Networks]({{% relref "networking_system_configuration/vlan" %}})
  * [VXLAN Networks]({{% relref "networking_system_configuration/vxlan" %}})
  * [Open vSwitch Networks]({{% relref "networking_system_configuration/openvswitch" %}})
* [Storage System Configuration]({{% relref "storage_system_configuration/index" %}})
  * [Overview]({{% relref "storage_system_configuration/overview" %}})
  * [Datastores]({{% relref "storage_system_configuration/datastores" %}})
  * [NFS/NAS Datastore]({{% relref "storage_system_configuration/nas_ds" %}})
  * [Local Storage Datastore]({{% relref "storage_system_configuration/local_ds" %}})
  * [Ceph Datastore]({{% relref "storage_system_configuration/ceph_ds" %}})
  * [SAN Datastore]({{% relref "storage_system_configuration/lvm_drivers" %}})
  * [Raw Device Mapping Datastore]({{% relref "storage_system_configuration/dev_ds" %}})
  * [iSCSI - Libvirt Datastore]({{% relref "storage_system_configuration/iscsi_ds" %}})
  * [Kernels and Files Datastore]({{% relref "storage_system_configuration/file_ds" %}})
* [Backup System Configuration]({{% relref "backup_system_configuration/index" %}})
  * [Overview]({{% relref "backup_system_configuration/overview" %}})
  * [Backup Datastore: Restic]({{% relref "backup_system_configuration/restic" %}})
  * [Backup Datastore: Rsync]({{% relref "backup_system_configuration/rsync" %}})
