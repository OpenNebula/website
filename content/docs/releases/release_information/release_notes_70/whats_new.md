---
title: "What's New"
date: "2025-02-17"
description:
categories:
pageintoc: "244"
tags:
weight: "2"
---

<a id="whats-new"></a>

<!--# What’s New in 7.0 -->

## OpenNebula Core

- The ability to import wild VMs into OpenNebula has been removed from code to provide a more coherent management experience across all interfaces and APIs.
- The enforce parameter has been restored for the resize operation. In this context, it only manages capacity enforcement checks (memory and CPU), while the NUMA topology is always verified independently.
- Option to define [Compute Quotas per Cluster]({{% relref "../../../product/cloud_system_administration/capacity_planning/quotas#compute-quotas" %}}) to achieve more granular control of resources.

## Storage & Backups

- [Integrated NFS life-cycle setup]({{% relref "../../../product/cloud_clusters_infrastructure_configuration/storage_system_configuration/nas_ds#automatic-nfs-setup" %}}) for volumes in shared datastore.

## FireEdge Sunstone

- Removed Provision/Provider as application [FireEdge Sunstone]({{% relref "../../../product/control_plane_configuration/graphical_user_interface/fireedge_sunstone#fireedge-sunstone" %}}).
- Architectural shift to Micro-Frontend as part of the Dynamic Tabs update [Sunstone development guide]({{% relref "../../../product/control_plane_configuration/graphical_user_interface/fireedge_sunstone#sunstone-dev" %}}).
- Guacamole VDI over SSH tunnel [Remote connections guide]({{% relref "../../../product/control_plane_configuration/graphical_user_interface/fireedge_sunstone#fireedge-remote-connections" %}}).

## API and CLI

- Feature 1
- Feature 2

## KVM

- Feature 1
- Feature 2

## OpenNebula Gate

## OpenNebula Flow

- Oneflow clients include content-type header to make them work with Sinatra 4.0.0 <https://github.com/OpenNebula/one/issues/6508>_\_.

## Features Backported to 6.10.x

Additionally, the following functionalities are present that were not in OpenNebula 6.10.0, although they debuted in subsequent maintenance releases of the 6.10.x series:

- [Fix de-selecting hidden datatable entries](https://github.com/OpenNebula/one/issues/6781).
- [Text of selection in schedule action](https://github.com/OpenNebula/one/issues/6410).
- [Fix Filter datastore type when deploy a VM](https://github.com/OpenNebula/one/issues/6927).

## Other Issues Solved

- Issue 1
- Issue 2
