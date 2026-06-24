---
title: "Bare Metal as a Service with NICo"
date: "2026-06-24"
description: "Integrate OpenNebula with NVIDIA NICo to offer multi-tenant bare metal instances as a service."
weight: 1
tags: ['AI']
---

<a id="bare_metal_nico"></a>

This guide describes how to integrate an existing OpenNebula cloud with NVIDIA NICo to offer basic multi-tenant Bare Metal as a Service. OpenNebula represents each NICo allocation as a Host and uses the NICo VMM and IM drivers to create, monitor, and delete bare metal instances through the NICo REST API.

The integration is intended for environments where OpenNebula provides the cloud management, user, group, quota, and template controls, while NICo provides the bare metal capacity and the lifecycle operations for each instance.

This guide focuses on the service integration model. For the complete driver attribute reference, see the [NICo Driver]({{% relref "product/operation_references/hypervisor_configuration/nico_driver" %}}) documentation.

## Assumptions

Before you start, make sure that:

- OpenNebula is already installed and running.
- The NICo service is already deployed and reachable from the OpenNebula Front-end.
- The NICo VMM and IM drivers are installed in the OpenNebula Front-end.
- You have a NICo allocation ID for the capacity you want to expose through OpenNebula.
- You have the NICo API credentials and connection details required by your environment.
- The NICo VPC, VPC prefix, operating system, instance type, network security group, and SSH key group identifiers have been created in NICo.
- OpenNebula users, groups, and Virtual Data Centers (VDCs) are already planned for the tenants that will consume the service.

## Integration Model

The NICo integration maps OpenNebula objects to NICo resources as follows:

| OpenNebula object | NICo resource |
| --- | --- |
| Host using the `nico` IM and VMM drivers | NICo allocation and API connection |
| VM template | Bare metal instance definition |
| VM | NICo bare metal instance |
| VM `DEPLOY_ID` | NICo instance UUID |
| NIC section in the VM template | NICo VPC prefix selection |

In this model, the OpenNebula Host does not represent a physical hypervisor. It represents a NICo allocation that OpenNebula can consume. The NICo IM driver reports capacity from that allocation, and the NICo VMM driver performs the instance lifecycle operations.

For multi-tenancy, create one or more service templates and publish them only to the groups or VDCs that should consume each NICo allocation. Use OpenNebula quotas to limit how many bare metal instances each tenant can deploy.

## Create the NICo Host

Create a dedicated Host that uses the NICo information manager and virtualization drivers:

```shell
onehost create nico --im nico --vm nico
```

Update the Host template with the NICo connection details and the allocation that this Host represents. The required and optional Host attributes are described in the [NICo Driver]({{% relref "product/operation_references/hypervisor_configuration/nico_driver" %}}) reference.

```shell
onehost update nico
```

After the next monitoring cycle, verify that OpenNebula can monitor the allocation:

```shell
onehost show nico
```

If different tenants must consume different NICo allocations, create one OpenNebula Host per allocation and restrict the corresponding VM templates with `SCHED_REQUIREMENTS`.

## Create a Tenant Network Placeholder

NICo uses its own VPC and VPC prefix identifiers to attach the bare metal instance to the requested network. OpenNebula still requires a VM template `NIC` section, so create or reuse a Virtual Network that acts as the tenant-facing network object.

The NICo driver reads `NICO_VPC_PREFIX_ID` from the first `NIC` section of the VM template. Define one VM template per tenant network, or clone the template and change the `NICO_VPC_PREFIX_ID` for each published service.

## Create the Bare Metal Service Template

Create a VM template that describes the NICo instance type, operating system, VPC, and networking attributes to use for the bare metal instance. Use the attribute set documented in the [NICo Driver]({{% relref "product/operation_references/hypervisor_configuration/nico_driver" %}}) reference.

At the service level, pay special attention to the scheduling expression and the tenant network mapping. For example, pin a service template to the intended NICo Host:

```default
NIC = [
  NETWORK            = "nico-network",
  NICO_VPC_PREFIX_ID = "vpc-prefix-id"
]

SCHED_REQUIREMENTS = "ID = 123"
```

Use `CPU = "1"` and `MEMORY = "1"` in the VM template because each OpenNebula VM represents one NICo instance. Capacity control comes from the NICo allocation reported by the Host and from OpenNebula quotas, not from the CPU and memory values in the template.

If a template can be placed on any NICo Host, schedule by VMM driver instead:

```default
SCHED_REQUIREMENTS = "VM_MAD = \"nico\""
```

For production services, pinning by Host ID is usually safer because it prevents a tenant template from consuming the wrong NICo allocation.

## Publish the Service to Tenants

Use OpenNebula groups, VDCs, and template permissions to expose the service to the right tenants.

Recommended model:

- Create a group for each tenant or service tier.
- Add the tenant users to the corresponding group.
- Create a VDC that includes the NICo Host, the tenant Virtual Network, and the service template.
- Publish only the VM templates that match the tenant entitlement.
- Apply VM quotas to limit how many bare metal instances each tenant can run.

Example quota for a tenant group that can run up to two NICo bare metal instances:

```shell
onegroup quota tenant-a
```

```default
VM = [
  RUNNING_VMS = "2"
]
```

This keeps the service multi-tenant at the OpenNebula layer while delegating the physical bare metal provisioning to NICo.

## Instantiate and Operate Bare Metal Instances

Tenants can instantiate the published service template from Sunstone or with the CLI:

```shell
onetemplate instantiate nico-bare-metal --name tenant-a-bm-01
```

OpenNebula sends the create request to NICo and stores the returned NICo instance UUID as the VM `DEPLOY_ID`. You can inspect the mapping with:

```shell
onevm show tenant-a-bm-01
```

Use standard OpenNebula lifecycle actions for tenant operations:

- `onevm terminate` deletes the NICo instance.
- `onevm reboot` requests a NICo reboot.
- `onevm show` displays the monitored state and NICo attributes reported by the driver.

During a NICo reboot request, OpenNebula keeps the VM in `RUNNING`. Check the monitored `NICO_STATUS` value to inspect transient NICo states such as `Rebooting`.

## Validation Checklist

After the integration is complete, validate the service with the following checks:

1. The NICo Host is monitored successfully in OpenNebula.
2. The Host capacity matches the expected NICo allocation.
3. A tenant can see only the published bare metal service templates.
4. A tenant can instantiate a template and obtain a running NICo instance.
5. The OpenNebula VM `DEPLOY_ID` matches the NICo instance UUID.
6. Tenant quotas prevent deploying more instances than allowed.
7. Terminating the OpenNebula VM removes the corresponding NICo instance.

## Troubleshooting

- If the Host is in an error state, verify the NICo API endpoint, issuer URL, organization, client credentials, target scopes, and allocation ID.
- If instantiation fails before reaching NICo, check that the VM template includes `NICO_INSTANCE_TYPE_ID`, `NICO_OS_ID`, `NICO_VPC_ID`, a `NIC` section, and `NIC/NICO_VPC_PREFIX_ID`.
- If the VM is scheduled to the wrong infrastructure, tighten `SCHED_REQUIREMENTS` to the NICo Host ID.
- If tenants can see the wrong service templates, review template ownership, permissions, groups, and VDC membership.
