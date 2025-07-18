---
title: "Automated Deployment and Configuration"
description:
categories:
pageintoc: ""
tags:
weight: 3
---

To perform the automated deployment of an OpenNebula cloud, the Ampere infrastructure of connected servers must be previously configured and available. This guide provides guidance on how to extract the list of required parameters of the provisioned infrastructure -- which will later be used for the automation of the OpenNebula deployment -- and an outline of the process for the automated deployment of an OpenNebula cloud.

## Ampere Infrastructure Provisioning

Provisioning the Ampere infrastructure on premises is out of the scope of this guide. To perform the automated deployment of an OpenNebula cloud, the Ampere infrastructure must meet the following conditions:

- Servers are provisioned
- Networking is configured
- Storage is configured
- The required operating system is installed
- Servers in the infrastructure are reachable from the machine where the deployment commands will be run

For the reference architecture and HW/SW specifications, please refer to the [previous section]({{% relref "ampere_hw_spec_and_arch" %}}).

## Save Required Parameters

To proceed with OpenNebula deployment, we need to extract and save some required parameters that the deployment automation relies on.

| Description | How to obtain the parameter |
| :----- | :----- |
| Front-end Host IP | A reachable IP on the server, that will be used by the automated deployment. |
| KVM Host IP | A reachable IP on the server, that will be used by the automated deployment. |
| `VXLAN PHYDEV` | Interface name of the private LAN on all servers. To find out the name of the interface, run `ip address` in each server's command line. |
| GUI password for user `oneadmin` | Specified by the administrator performing the deployment steps. |

## Deployment and Automated Verification Procedure

The complete OpenNebula deployment procedure and all of the required resources are available in the [Certified Hardware Ampere for OpenNebula](https://github.com/OpenNebula/certified-hardware-ampere), also referred to as the **deployment repository**. For instructions on how to use the required parameters extracted from the provisioned Ampere servers, please check the `README` file in the repo.

The deployment procedure consists of the following high-level steps:

1. Clone the deployment repository.
1. Update the deployment repository with the required parameters gathered above.
1. Launch the deployment automation commands.
1. Launch the verification automation command.

{{< alert title="Note" color="success" >}}
For detailed information about how to use the required parameters and which configuration files to modify, please refer to the `README` of the [Certified Hardware Ampere for OpenNebula](https://github.com/OpenNebula/certified-hardware-ampere).
{{< /alert >}}

