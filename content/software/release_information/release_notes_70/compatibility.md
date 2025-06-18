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

This guide is aimed at OpenNebula 6.10.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account or could perhaps cause confusion. You can check the upgrade process in the [corresponding section](../../upgrade_process). If upgrading from previous versions, please make sure you read all the intermediate versions’ Compatibility Guides for possible pitfalls.

Visit the [Features list](../../../quick_start/understand_opennebula/opennebula_concepts/key_features#features) and the [What’s New guide](whats_new#whats-new) for a comprehensive list of what’s new in OpenNebula 7.0.

## Deprecated Components

As part of OpenNebula 7.0’s effort to streamline infrastructure operations and simplify cloud deployments based on KVM and LXC, the following components have been removed:

- vCenter Drivers – Support for VMware vCenter has been discontinued.
- Original Sunstone – The legacy Sunstone interface with a Ruby backend has been removed in favor of the current interface.
- Ebtables Network Driver – The ebtables driver has been deprecated and is no longer available in favor of more reliable VLAN solutions.
- Legacy hybrid cloud computing drivers have been removed (ec2, azure, OpenNebula) in favor of the new components.

## Redesigned Scheduling System

OpenNebula 7.0 introduces a [completely redesigned scheduling architecture](../../../product/cloud_system_administration/scheduler/overview/#opennebula-scheduler-framework-architecture) based on a modular driver framework. The scheduler is no longer a persistent system service; instead, it is executed on demand whenever a new _plan_ is required.

This new framework supports multiple scheduling algorithms. By default, the original rank-based scheduler handles placement decisions, while the new OpenNebula DRS scheduler is used for optimization tasks. We recommend [reviewing the updated configuration options and files](../../../product/cloud_system_administration/scheduler/configuration/) to fine-tune the scheduling behavior to your specific infrastructure needs.

## OneFlow: Support for Virtual Router Roles

This version of OneFlow introduces support for Virtual Router roles, enabling more advanced and flexible service definitions. To accommodate this enhancement, the underlying data model has been updated—some attributes have been renamed or relocated within the flow definition document.

The database migrator automatically updates existing services to the new format. However, users with custom applications or integrations are advised to review the updated data model to ensure compatibility and make any necessary adjustments:

| Old attribute          | New Attribute       |
| ---------------------- | ------------------- |
| `vm_template`          | `template_id`       |
| `vm_template_contents` | `template_contents` |
| `custom_attrs`         | `user_inputs`       |

New attributes:

| Attribute | Permitted Values | Default Value |
| --------- | ---------------- | ------------- |
| `type`    | `vm`, `vr`       | `vm`          |

### Examples:

Old Format:

```json
{
   "name": "old_role_example",
   "vm_template": 1,
   "cardinality": 3,
   "vm_template_contents": "ATT_A=\"$ATT_A\",\n\"CONTEXT\"=[ATT_A=\"$ATT_A\"],\n
        "CPU=\"2\"\n",
   "custom_attrs": {
       "ATT_A": "M|text|desc| |default"
   }
}
```

New Format:

```json
{
  "name": "new_role_example",
  "template_id": 1,
  "type": "vm",
  "cardinality": 3,
  "template_contents": {
    "CPU": 2
  },
  "user_inputs": {
    "ATT_A": "M|text|desc| |default"
  }
}
```

## Cluster Provisioning

- This version removes the legacy provisioning component, incorporating internal code changes that lay the groundwork for a complete rewrite. The fully redesigned provisioning system, featuring enhanced support for additional providers, will be released in a subsequent maintenance update.

## Resize Operation

The enforcement parameter was deprecated to ensure NUMA consistency for the VM during a resize. Instead, it has been reinstated to control capacity attributes, such as memory and CPU.

## New Default Local Datastore Driver

Starting with OpenNebula 6.10.2, the default driver for Local datastores is now `local`, replacing the legacy `ssh` driver (see [Local Storage Datastore Drivers](../../../product/cloud_clusters_infrastructure_configuration/storage_system_configuration/local_ds#local-ds-drivers)). While the `ssh` driver remains fully supported and existing datastores require no changes, the new `local` driver was developed from scratch to improve maintainability and facilitate future enhancements.

This redesign was necessary to support advanced QCOW2 features such as thin provisioning, which introduced incompatibilities with previous implementations. The new driver streamlines the codebase and lays the foundation for upcoming capabilities.

Note: Caching support is not yet included in this release but is in an advanced development stage and will be available in an upcoming maintenance update.

<a id="compatibility-guide-labels"></a>

## SAN driver BRIDGE_LIST location change

To make its behaviour consistent with other drivers, [LVM/SAN](/product/cluster_configuration/storage_system/lvm_drivers/) drivers now define the `BRIDGE_LIST` attribute in the IMAGE datastore, instead of in the SYSTEM one.

## Virtual Machine PCI passthrough address generation

The guest PCI address for passthrough devices (`VM_BUS`, `VM_SLOT`, `VM_ADDRESS`...) is now generated at allocation time (i.e. when the PCI device is assigned to the VM). This change has been introduce to properly generate NUMA-aware PCIe topologies.

## Labels on Sunstone

Starting from version 7.0, the labels system in Sunstone has been revamped, moving away from the old global/system-wide approach towards a more user/group-specific structure.

Previously, labels were stored directly on the resources they were applied to, which didn't scale well. There was no way to tell which user had created which label, and removing a label only affected the user template, leaving the resource template untouched. This often led to "stale labels", cluttering resource templates and misrepresenting which labels were actually in use, especially when different users applied similarly named labels to shared resources.

The new format introduces two types of labels: "User" and "Group" labels. These are now stored in either the user template or the group template, along with metadata about which resources they're applied to. This avoids cluttering the resource templates themselves and makes it possible to control label visibility more precisely by leveraging different group memberships.

When upgrading to 7.0, existing in-use labels will be automatically migrated. To avoid bringing over stale or unused data, only labels that are present both in a user's template and on a resource template will be migrated. Any existing persistent labels defined in `etc/one/sunstone/sunstone-views.yaml` will be migrated to the new format as user labels. New persistent labels can be defined in `etc/one/fireedge/sunstone/default-labels.yaml`.

#### Persistent labels

The new default or persistent labels in Sunstone adheres to the following structure:

```yaml
#User labels are organized as nested categories and subcategories under each user template.
user:
  Test1:
    A:
      B:
        C:

# For group labels, the first level key is the group name.
# Under each group, labels are organized similarly to users, with nested categories and subcategories.

group:
  oneadmin:
    Test2:
      D:
        E:
          F:
```
