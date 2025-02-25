---
title: "Storage System Configuration"
date: "2025/02/17"
description:
categories:
pageintoc: "66"
tags:
weight: "3"
---

<!--# Open Cloud Storage Setup -->

* [Overview]({{% relref "overview" %}})
  * [Datastore Types]({{% relref "overview#datastore-types" %}})
  * [How Should I Read This Chapter]({{% relref "overview#how-should-i-read-this-chapter" %}})
  * [Hypervisor Compatibility]({{% relref "overview#hypervisor-compatibility" %}})
* [Datastores]({{% relref "datastores" %}})
  * [Types]({{% relref "datastores#types" %}})
  * [Attributes]({{% relref "datastores#attributes" %}})
  * [Basic Configuration]({{% relref "datastores#basic-configuration" %}})
  * [Disable a System Datastore]({{% relref "datastores#disable-a-system-datastore" %}})
  * [Using Sunstone to Manage Datastores]({{% relref "datastores#using-sunstone-to-manage-datastores" %}})
* [NFS/NAS Datastore]({{% relref "nas_ds" %}})
  * [Manual Front-end Setup]({{% relref "nas_ds#manual-front-end-setup" %}})
  * [Manual Host Setup]({{% relref "nas_ds#manual-host-setup" %}})
  * [Automatic Setup]({{% relref "nas_ds#automatic-setup" %}})
  * [OpenNebula Configuration]({{% relref "nas_ds#opennebula-configuration" %}})
  * [NFS/NAS and Local Storage]({{% relref "nas_ds#nfs-nas-and-local-storage" %}})
  * [Datastore Internals]({{% relref "nas_ds#datastore-internals" %}})
* [Local Storage Datastore]({{% relref "local_ds" %}})
  * [Front-end Setup]({{% relref "local_ds#front-end-setup" %}})
  * [Host Setup]({{% relref "local_ds#host-setup" %}})
  * [OpenNebula Configuration]({{% relref "local_ds#opennebula-configuration" %}})
  * [Datastore Drivers]({{% relref "local_ds#datastore-drivers" %}})
  * [Datastore Internals]({{% relref "local_ds#datastore-internals" %}})
* [Ceph Datastore]({{% relref "ceph_ds" %}})
  * [Ceph Cluster Setup]({{% relref "ceph_ds#ceph-cluster-setup" %}})
  * [Front-end and Hosts Setup]({{% relref "ceph_ds#front-end-and-hosts-setup" %}})
  * [Hosts Setup]({{% relref "ceph_ds#hosts-setup" %}})
  * [OpenNebula Configuration]({{% relref "ceph_ds#opennebula-configuration" %}})
  * [Datastore Internals]({{% relref "ceph_ds#datastore-internals" %}})
* [SAN Datastore]({{% relref "lvm_drivers" %}})
  * [Front-end Setup]({{% relref "lvm_drivers#front-end-setup" %}})
  * [Hosts Setup]({{% relref "lvm_drivers#hosts-setup" %}})
  * [OpenNebula Configuration]({{% relref "lvm_drivers#opennebula-configuration" %}})
  * [Datastore Internals]({{% relref "lvm_drivers#datastore-internals" %}})
* [Raw Device Mapping Datastore]({{% relref "dev_ds" %}})
  * [Datastore Layout]({{% relref "dev_ds#datastore-layout" %}})
  * [Front-end Setup]({{% relref "dev_ds#front-end-setup" %}})
  * [Node Setup]({{% relref "dev_ds#node-setup" %}})
  * [OpenNebula Configuration]({{% relref "dev_ds#opennebula-configuration" %}})
  * [Datastore Usage]({{% relref "dev_ds#datastore-usage" %}})
* [iSCSI - Libvirt Datastore]({{% relref "iscsi_ds" %}})
  * [Front-end Setup]({{% relref "iscsi_ds#front-end-setup" %}})
  * [Node Setup]({{% relref "iscsi_ds#node-setup" %}})
  * [OpenNebula Configuration]({{% relref "iscsi_ds#opennebula-configuration" %}})
  * [Datastore Usage]({{% relref "iscsi_ds#datastore-usage" %}})
* [Kernels and Files Datastore]({{% relref "file_ds" %}})
  * [Configuration]({{% relref "file_ds#configuration" %}})
  * [Host Configuration]({{% relref "file_ds#host-configuration" %}})
