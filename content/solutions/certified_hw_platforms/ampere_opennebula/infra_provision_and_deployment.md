---
title: "Automated Deployment and Verification"
description:
categories:
pageintoc: ""
tags:
weight: 3
---

## Infastructure Provisioning

This guide does not cover how to provision the Ampere infrastructure on-premise. As a starting point, it is assumed that the servers are provisioned, networking and storage are configured, the required operating system is installed, and the servers are reachable from the machine where the below commands are executed.

## Saving Required Parameters

To proceed with OpenNebula deployment, we need to extract and save some required parameters that the deployment automation relies on.

| Description | How to obtain the parameter |
| :----- | :----- |
| Front-end Host IP | A reachable IP of the server, that is used by the automated deployment. |
| KVM Host IPs | A reachable IP of the server, that is used by the automated deployment. |
| `VXLAN PHYDEV` | Interface name of the private LAN on all servers. To find out the name of the interface, run `ip address` in each server's command line. |
| GUI password for user `oneadmin` | Specified by the administrator performing the deployment steps. |

## Deployment and Automated Verification Procedure

The complete OpenNebula deployment procedure and all of the required resources are available in the [Certified Hardware Ampere for OpenNebula](https://github.com/OpenNebula/certified-hardware-ampere), also referred to as the **deployment repository**. For instructions on how to use the required parameters extracted from the provisioned Ampere servers, please check the `README` file in the repo.

The deployment procedure consists of the following high-level steps:

1. Initialize the deployment repository.
1. Update the deployment repository with the required parameters gathered above.
1. Launch the deployment automation commands.
1. Launch the automated verification command.

{{< alert title="Note" color="success" >}}
For detailed information about how to use the required parameters and which configuration files to modify, please refer to the README of the [Certified Hardware Ampere for OpenNebula](https://github.com/OpenNebula/certified-hardware-ampere).
{{< /alert >}}

<!-- TODO: we should find a way how to do this properly in Hugo framework -->
After the deployment is successful, optionally follow the screenshot-drive guide about how to instantiate a VM, and access it from OpenNebula's GUI: 
[Basic OpenNebula UI Guide: VM Instantiation](../../hosted_cloud_providers/ionos_opennebula/common_101_gui_guide).

