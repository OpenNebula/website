---
title: "Automated Deployment and Configuration"
description:
categories:
pageintoc: ""
tags:
weight: 3
---

This section details a step-by-step procedure to provision the reference infrastructure on the IONOS Cloud, demonstrated by screenshots. It provides guidance on how to extract the list of required parameters of the provisioned infrastructure, which are used for the automation of the OpenNebula deployment.

## Infrastructure Provisioning

<<<<<<<< HEAD:content/solutions/hosted_cloud_providers/ionos_opennebula/auto_deploy_and_config.md
The virtual servers can be deployed through the IONOS [Data Center Designer (DCD)](https://dcd.ionos.com/).

Build the configuration shown below, taking into account the details described in the [Hardware and Software Specification]({{% relref "hw_spec_and_arch" %}}) section.
========
The virtual servers can be deployed through the IONOS [Data Center Designer (DCD)](https://dcd.ionos.com/). After deploying the virtual servers, in the DCD you should see your newly-created infrastructure as shown below:
>>>>>>>> ionos_rev_2:content/solutions/hosted_cloud_providers/ionos_opennebula/ionos_auto_deploy_and_config.md

![><][dcd-layout]

This page will guide you in building this configuration. You will need to take into account the details described in the [Hardware and Software Specification]({{% relref "ionos_hw_spec_and_arch" %}}) section.

### Building with DCD 

To achieve the deployment base shown in the figure above, follow the below steps:

1. Add the Dedicated Core Servers.
2. Add internet access from the toolbar.
3. Connect all servers to the internet access. Ensure to consistently use the first NIC in each server.
4. Connect each server's second NIC to the private LAN between the servers. Ensure to consistently use each server's second NIC.
5. Add HDD instances and specify the base image for the operating systems:
<<<<<<<< HEAD:content/solutions/hosted_cloud_providers/ionos_opennebula/auto_deploy_and_config.md
   1. Choose the specifications as shown in [Table 1]({{% relref "hw_spec_and_arch#table-1-front-end-requirements" %}}) of [Hardware and Software Specification]({{% relref "hw_spec_and_arch" %}}).
========
   1. Choose the specifications as shown in [Table 1]({{% relref "ionos_hw_spec_and_arch#table-1-front-end-requirements" %}}) of [Hardware and Software Specification]({{% relref "ionos_hw_spec_and_arch" %}}).
>>>>>>>> ionos_rev_2:content/solutions/hosted_cloud_providers/ionos_opennebula/ionos_auto_deploy_and_config.md
   2. Add the SSH key of the host from which the access is needed.
   3. Set it as a boot device.

Then, book the following two IP ranges, as shown below.

* **booked-for-servers**: These are the management IPs for each servers. Book an IP block with enough addresses for the servers, assigning one IP address per server. 
* **booked-for-vms**: These are the traffic IPs for the public-facing VMs that will be deployed using OpenNebula. Book a block big enough for the VMs.

<a id="ip-man"></a>
![><][ip-man]

Assign the booked IP addresses to the servers, as shown below. Note that, without assigning any booked public IP addresses, IONOS will automatically assign new addresses at server startup.

<a id="ip-booked-for-server"></a>
![><][ip-booked-for-server]

To effect the changes, click the **Provision changes** button in the DCD. Implementing the changes should take a few minutes; the  result is reported in the DCD.

### Generating a Token

Access the [IONOS Token Manager](https://dcd.ionos.com/latest/#/tokens), generate a new token, and save the token's value. As indicated in the screenshot below, you will not be able to access this value later, so make sure you save it securely.

<a id="token-manager"></a>
![><][token-manager]

### Retrieving the Data Center UUID

At the [IONOS Data Center Designer web UI](https://dcd.ionos.com/), open the canvas where the infrastructure was designed. Copy and save the virtual data center's UUID by clicking the **API** icon, as shown below.

<a id="dcd-uuid"></a>
![><][dcd-uuid]

## Saving Required Parameters

At this point, all required infrastructure components should be deployed and configured in the IONOS DCD. To proceed with OpenNebula deployment, we need to extract and save some required parameters that the deployment automation relies on.

### Table 1: List of Required Parameters

| Description | How to obtain the parameter |
| :----- | :----- |
| Front-end Host IP | From the **booked-for-servers** IP range, choose an IP for the OpenNebula Front-end. |
| KVM Host IPs | From the other IPs in the **booked-for-servers** IP range, choose the IPs for the OpenNebula Hosts that will run the Virtual Machines. |
| KVM Host Gateway | For each KVM Host IP, you can find the IONOS assigned gateway IP in the DCD, as shown in [this screenshot](#ip-booked-for-server). |
| `VXLAN PHYDEV` | Interface name of the private LAN on all servers. To find out the name of the interface, run `ip address` in each server's command line. |
| `pubridge PHYDEV` | Interface name of the NIC connected to the Internet gateway on all servers. To find out the name of the interface, run the `ip address` command on each server's command line. |
| VMs Public IP Range | All the IPs that are contained in the IP range ``booked-for-vms``, as shown in [this screenshot](#ip-man). |
| GUI password for user `oneadmin` | Specified by the administrator performing the deployment steps. |
| IONOSCTL Token | The IONOS API/SDK token value that was generated and saved previously, as shown in [this screenshot](#dcd-uuid). |
| IONOS Data Center UUID | The virtual data center’s UUID, as shown in [this screenshot](#dcd-uuid). |

### Determining the Value for the `PHYDEV` Parameter

To find the value of the `PHYDEV` parameter for the VXLAN and the public bridge, access the Linux CLI of a deployed server and find the interface name of the first and second NICs that were connected to the Internet gateway and the private LAN respectively. To do this, run the `ip address` command and inspect the output, matching the NICs to their Linux system names, by comparing the assigned IP and MAC addresses as shown in the IONOS DCD.

If the first and second NICs were consistently used to connect the servers to the internet and the LAN respectively, the names of the interfaces should be the same on all servers -- that is, the output of `ip address` should display the same names for the first and second NICs. Verify that this is indeed the case, by accessing multiple servers and inspecting the output of the `ip address` command.

## Deployment and Automated Verification Procedure

The complete OpenNebula deployment procedure and all of the required resources are available in the [OpenNebula hosted IONOS repo](https://github.com/OpenNebula/opennebula-hosted-ionos), also referred to as the **deployment repository**. For instructions on how to use the required parameters extracted from the provisioned IONOS infrastructure, please check the `README` file in the repo.

The deployment procedure consists of the following high-level steps:

1. Initialize the deployment repository.
2. Update the deployment repository with the required parameters gathered above.
3. Customize the networking configuration of the provisioned servers.
4. Launch the deployment automation commands.
5. Launch the automated verification command.

{{< alert title="Note" color="success" >}}
For detailed information about how to use the required parameters and which configuration files to modify, please refer to the README of the [OpenNebula hosted IONOS repo](https://github.com/OpenNebula/opennebula-hosted-ionos).
{{< /alert >}}

[dcd-layout]: /images/solutions/ionos/dcd-layout.png
[ip-man]: /images/solutions/ionos/ip-management.png
[ip-booked-for-server]: /images/solutions/ionos/ip-booked-for-server.png
[token-manager]: /images/solutions/ionos/token-manager.png
[dcd-uuid]: /images/solutions/ionos/dcd-uuid.png
