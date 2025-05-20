---
title: "Compatibility Guide"
date: "2025-02-17"
description:
categories:
pageintoc: "247"
tags:
weight: "5"
---

<a id="compatibility"></a>

<!--# Compatibility Guide -->

This guide is aimed at OpenNebula 6.10.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account, or are prone to cause confusion. You can check the upgrade process in the [corresponding section](../../upgrade_process). If upgrading from previous versions, please make sure you read all the intermediate versions’ Compatibility Guides for possible pitfalls.

Visit the [Features list](../../../quick_start/understand_opennebula/opennebula_concepts/key_features#features) and the [What’s New guide](whats_new#whats-new) for a comprehensive list of what’s new in OpenNebula 7.0.

## Deprecated Components

As part of OpenNebula 7.0’s effort to streamline infrastructure operations and simplify cloud deployments based on KVM and LXC, the following components have been removed:

- vCenter Drivers – Support for VMware vCenter has been discontinued.
- Original Sunstone – The legacy Sunstone interface with a Ruby backend has been removed in favor of the current interface.
- Ebtables Network Driver – The ebtables driver has been deprecated and is no longer available in favor on more reliable VLAN solutions.

## Redesigned Scheduling System

OpenNebula 7.0 introduces a [completely redesigned scheduling architecture](../../../product/cloud_system_administration/scheduler/overview/#opennebula-scheduler-framework-architecture) based on a modular driver framework. The scheduler is no longer a persistent system service; instead, it is executed on demand whenever a new *plan* is required.

This new framework supports multiple scheduling algorithms. By default, the original rank-based scheduler handles placement decisions, while the new OpenNebula DRS scheduler is used for optimization tasks. We recommend [reviewing the updated configuration options and files](../../../product/cloud_system_administration/scheduler/configuration/) to fine-tune the scheduling behavior to your specific infrastructure needs.

## OneFlow: Support for Virtual Router Roles

This version of OneFlow introduces support for Virtual Router roles, enabling more advanced and flexible service definitions. To accommodate this enhancement, the underlying data model has been updated—some attributes have been renamed or relocated within the flow definition document.

The database migrator automatically updates existing services to the new format. However, users with custom applications or integrations are advised to review the updated data model to ensure compatibility and make any necessary adjustments:

| Old attribute        | New Attribute     |
|----------------------|-------------------|
| vm_template          | template_id       |
| vm_template_contents | template_contents |
| custom_attrs         | user_inputs       |

New attributes:

| Attribute| Permitted Values  | Default Value |
|----------|-------------------|---------------|
| type     | vm,vr             |  vm           |


## Cloud Cluster Provisioning

- This version removes the legacy provisioning component, incorporating internal code changes that lay the groundwork for a complete rewrite. The fully redesigned provisioning system, featuring enhanced support for additional providers, will be released in a subsequent maintenance update.

## Resize Operation

The enforcement parameter was deprecated to ensure NUMA consistency for the VM during a resize. Instead, it has been reinstated to control capacity attributes, such as memory and CPU.

## New Default Local Datastore Driver

Starting with OpenNebula 6.10.2, the default driver for Local datastores is now `local`, replacing the legacy `ssh` driver (see [Local Storage Datastore Drivers](../../../product/cloud\_clusters\_infrastructure\_configuration/storage\_system\_configuration/local\_ds#local-ds-drivers). While the `ssh` driver remains fully supported and existing datastores require no changes, the new `local` driver was developed from scratch to improve maintainability and facilitate future enhancements.

This redesign was necessary to support advanced QCOW2 features such as thin provisioning, which introduced incompatibilities with previous implementations. The new driver streamlines the codebase and lays the foundation for upcoming capabilities.

Note: Caching support is not yet included in this release but is in an advanced development stage and will be available in an upcoming maintenance update.

## Labels on Sunstone


