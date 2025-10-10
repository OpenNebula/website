---
title: "What's New"
date: "2025-10-06"
description:
categories:
pageintoc: "244"
tags:
weight: "2"
---

<a id="whats-new"></a>

<!--# What’s New in 7.2 -->

We’re excited to introduce OpenNebula 7.2.0 *Phoenix*, the new major OpenNebula release.

The name *Phoenix* reflects a broader transformation in cloud infrastructure—symbolizing resilience and rebirth for organizations rethinking their architecture in the face of AI, multi-cloud, and edge computing trends.

OpenNebula 7.2 represents a major leap forward, especially for those migrating from VMware or modernizing their stack for next-generation workloads. A key highlight is that the migration packages are now included in the Community Edition, making it easier for community users to stay up to date and take full advantage of the latest innovations.

We invite you to explore the features, join the community conversations, and give your feedback on this final release.

We encourage you to review the [Known Issues]({{% relref "known_issues" %}}) and report any bugs through our [GitHub development portal](https://github.com/OpenNebula/).

## OpenNebula Core

<!--keeping some examples-->
- The ability to import wild VMs into OpenNebula has been removed from code to provide a more coherent management experience across all interfaces and APIs.



## Monitoring
<!--keeping some examples-->
- [Resource Usage Forecast](../../../product/cloud_system_administration/resource_monitoring/forecast/): Introduces predictive analytics for Host and VM resource consumption, enabling proactive infrastructure management. By analyzing trends in CPU, memory, disk, and network usage, OpenNebula 7.0 supports improved capacity planning, optimized workload scheduling, and early detection of performance bottlenecks.

## Scheduler
<!--keeping some examples-->
- OpenNebula 7.0.0 features a [complete re-write of the scheduling framework](../../../product/cloud_system_administration/scheduler/overview/#opennebula-scheduler-framework-architecture) to easily support multiple scheduling algorithms, and more responsive and reliable execution of scheduling plans.


## Storage & Backups
<!--keeping some examples-->
- [Integrated NFS life cycle setup](../../../product/cluster_configuration/storage_system/nas_ds.md#automatic-nfs-setup): simplify the configuration and management of SAN/NFS in shared storage scenarios.


## Sunstone
<!--keeping some examples-->
- Dynamic Tabs to be able to add third party section in Sunstone in an easy way. Learn how in the [Sunstone Development](../../../software/installation_process/build_from_source_code/sunstone_dev.md#sunstone-dev") guide.


## API and CLI
<!--keeping some examples-->
- [The `onedb purge-history` command now removes history records only within the specified `–start`, `–end` range for the `–id`, instead of deleting all records](https://github.com/OpenNebula/one/issues/6699).
- The output of `onemarketapp list` list now contains 2 extra columns displaying **HYPERVISOR** and 
**ARCHITECTURE**.

## KVM & Networking
<!--keeping some examples-->
- [Transparent proxying](../../../product/virtual_machines_operation/virtual_machines_networking/tproxy) allows VMs to access external services like OneGate without requiring complex networking setup.



## OpenNebula Flow
<!--keeping some examples-->
- [Oneflow clients include content-type header to make them work with Sinatra 4.0.0](https://github.com/OpenNebula/one/issues/6508).


## Marketplace
<!--keeping some examples-->
- The [public marketplaces](../../../product/apps-marketplace/public_marketplaces/overview#-overview) appliances generate [scheduling requirements](../../../product/cloud_system_administration/scheduler/overview.md#host-requirements) and [OS configurations](../../../product/operation_references/hypervisor_configuration/kvm_driver#arm64specifics) based on the architecture.


## Features Backported to 7.0.x
<!--keeping some examples-->
Additionally, the following functionalities are present that were not in OpenNebula 6.10.0, although they debuted in subsequent maintenance releases of the 6.10.x series:

- [Add human-readable text for schedule actions to describe the recurring intervals](https://github.com/OpenNebula/one/issues/6410).


## Other Issues Solved
<!--keeping some examples-->
- [Fix de-selecting hidden datatable entries](https://github.com/OpenNebula/one/issues/6781).

