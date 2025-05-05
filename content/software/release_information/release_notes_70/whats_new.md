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

OpenNebula 7.0 “XXXX” is the first stable release of the OpenNebula 7 series. This release comes with many exciting features: integration with enterprise components (Veeam backup software, dedicated NetApp drivers, OVA import, LVM-thin drivers supporting any SAN vendor, revamped Sunstone interface (it’s lush!), and many more.

## OpenNebula Core

- The ability to import wild VMs into OpenNebula has been removed from code to provide a more coherent management experience across all interfaces and APIs.
- The enforce parameter has been restored for the resize operation. In this context, it only manages capacity enforcement checks (memory and CPU), while the NUMA topology is always verified independently.
- Option to define [Compute Quotas per Cluster]({{% relref "../../../product/cloud_system_administration/capacity_planning/quotas#compute-quotas" %}}) to achieve more granular control of resources.

## Storage & Backups

- [Integrated NFS life-cycle setup]({{% relref "../../../product/cloud_clusters_infrastructure_configuration/storage_system_configuration/nas_ds.md#automatic-nfs-setup" %}}) for volumes in shared datastore.

## Sunstone

- Removed Provision/Provider as application [Sunstone]({{% relref "../../../product/control_plane_configuration/graphical_user_interface/fireedge_sunstone.md#fireedge-sunstone" %}}).
- Architectural shift to Micro-Frontend as part of the Dynamic Tabs update [Sunstone development guide]({{% relref "../../../software/life_cycle_management/building_from_source_code/sunstone_dev.md#sunstone-dev" %}}).
- Guacamole VDI over SSH tunnel [Remote connections guide]({{% relref "../../../product/control_plane_configuration/graphical_user_interface/fireedge_sunstone.md#fireedge-remote-connections" %}}).

## API and CLI

- [The ‘onedb purge-history’ command now removes history records only within the specified –start, –end range for the –id, instead of deleting all records](https://github.com/OpenNebula/one/issues/6699).
- Feature 2

## Ecosystem

<!-- - [OVA import]({{ "../../marketplace/ova_management/import_ova#import-ova" }}), a new CLI command, oneswap, allows to ingest VMs in OVA format that can be exported directly from VMware vCenter. Stay tuned for Sunstone support! -->

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
- [Fix show more labels in cards](https://github.com/OpenNebula/one/issues/6643).
- [Fix host tab does not validate Enable/Disable button states](https://github.com/OpenNebula/one/issues/6792).
- [Fix add qcow2 format support for volatile disk type “swap”](https://github.com/OpenNebula/one/issues/6622).

## Other Issues Solved

- [Limit password size for each authentication driver to prevent DoS attacks](https://github.com/OpenNebula/one/issues/6892).
- [For ‘list’ and ‘top’ commadns fix filter flag G exposing resources of other group members](https://github.com/OpenNebula/one/issues/6952).
- [Fix duplicit Scheduled Actions](https://github.com/OpenNebula/one/issues/6996).
- [Disable KEEP_LAST for incremental backups on CEPH datastores. Support for KEEP_LAST will be addressed in future releases](https://github.com/OpenNebula/one/issues/6857).
