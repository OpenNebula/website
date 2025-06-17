---
title: "Provisioning, automated deployment and verification"
description:
categories:
pageintoc: ""
tags:
weight: 3
---

This section details a step-by-step procedure to provision the reference infrastructure on the IONOS Cloud demonstrated by screenshots. Provides guidance on how to extract the list of essential parameters of the provisioned infrastructure, which are used for the OpenNebula deployment automation.

# Infrastructure Provisioning

The deployment of the virtual servers can be done through the IONOS [Data Center Designer (DCD)](https://dcd.ionos.com/).   
Build the following configuration, shown below, with the details described in the Specification section.

![image][dcd-layout]

## Building with DCD 

The steps to achieve the base of deployment showed above in the IONOS DCD are the following:

1. Add the Dedicated Core Servers .  
2. Add Internet access from the toolbar.  
3. Connect all servers to the Internet access, use consistently their first NICs.  
4. Connect their second NICs to the private LAN between them, use the second NICs consistently.  
5. Add HDD instances and specify the base image for the operating systems  
   1. Choose the specifications as shown in Table 1\.  
   2. Add the SSH key of the host from which the access is needed,  
   3. Set it as a boot device.

Then book the following two IP ranges, as shown below.

* booked-for-servers: These are the management IPs for each servers, book an IP block with enough addresses for the servers, assigning 1 IP per server.  
* booked-for-vms: These are the traffic IPs for public-facing VMs, that will be deployed using OpenNebula. Book a block big enough for the VMs.

<a id="ip-man"></a>
![image][ip-man]

Assign the booked IP addresses to the servers, as shown below. Note that, without assigning any booked public IP addresses, IONOS will automatically assign new addresses at server startup.

<a id="ip-booked-for-server"></a>
![image][ip-booked-for-server]

Click “Provision changes” button in the DCD to perform all the changes done in this section. The changes should take a few minutes and the success result is reported in the DCD.

## Generate a token {#generate-a-token}

Access the [Token Manager of IONOS](https://dcd.ionos.com/latest/#/tokens), generate a new token, and save the token’s value. As shown below, this value cannot be accessed through the web later, only at this moment.

<a id="token-manager"></a>
![image][token-manager]

## Retrieving the Data Ceenter UUID {#retrieving-the-data-ceenter-uuid}

At the [IONOS Data Center Designer web UI](https://dcd.ionos.com/), open the canvas where the infrastructure was designed. Copy and save the virtual data center’s UUID, by clicking the API icon, as shown below.

<a id="dcd-uuid"></a>
![image][dcd-uuid]

# Saving essential parameters {#saving-essential-parameters}

As of now, all required infrastructure components have been deployed and configured in the IONOS DCD. To proceed with OpenNebula deployment, we need to extract and save some essential parameters that the deployment automation relies on.

| Description | How to get the parameter? |
| :----- | :----- |
| Frontend Host IP | Choose an IP from the ‘booked-for-servers’ IP range that will serve as OpenNebula Frontend. |
| KVM Host IPs | Choose all other IPs from the ‘booked-for-servers’ IP range that will serve as OpenNebula hosts, running Virtual Machines. |
| KVM Host Gateway | For each KVM Host IP, you can find the IONOS assigned gateway IP in the DCD, as shown in [this screenshot](#ip-booked-for-server). |
| VXLAN PHYDEV | Interface name of the private LAN on all servers. Find it by launching ‘ip address’ command in servers’ the Linux CLI. |
| pubridge PHYDEV | Interface name of the NIC connected to the Internet gateway on all servers. Find it by launching ‘ip address’ command in servers’ the Linux CLI. |
| VMs Public IP Range | All the IPs that are contained in the IP range ‘booked-for-vms’, as shown in [this screenshot](#ip-man). |
| GUI password of \`oneadmin\` | Specified by the administrator performing the deployment steps. |
| IONOSCTL Token | The IONOS API/SDK token value, as it was generated and saved previously, as shown in [this screenshot](#dcd-uuid). |
| IONOS Data Center UUID | The virtual data center’s UUID, as shown in [this screenshot](#dcd-uuid). |

To find the PHYDEV parameter value for the VXLAN and the public bridge, access the Linux CLI of a deployed server. Find the interface name of the first and second NICs that were connected to the Internet gateway and the private LAN respectively. Launch the “ip address” command and inspect the outputs, matching the NICs to their Linux system names, by comparing the assigned IP and MAC addresses as shown in the IONOS DCD. These interface names should be the same on all servers, if consistently the first and second NICs were used to connect them to the internet and the private LAN respectively. Verify that this is indeed the case, by accessing multiple servers and inspecting the outputs of the “ip address” commands.

# Deployment and Automated Verification Procedure {#deployment-and-automated-verification-procedure}

The whole OpenNeula deployment procedure and all required resources are available in [OpenNebula hosted IONOS repo](https://github.com/OpenNebula/opennebula-hosted-ionos), also referred to as deployment repository. Take a look at the README for specific instructions on how to use the essential parameters that were extracted from the provisioned IONOS infrastructure.

The deployment procedure consists of the following high level steps:

1. Initialize the deployment repository.  
2. Update the deployment repository with the essential parameters gathered above.  
3. Customize networking configuration of the provisioned servers.  
4. Launch the deployment automation commands.  
5. Launch the automated verification command.

For detailed information about how to use the essential parameters and which configuration files to modify, please refer to the README of the [OpenNebula hosted IONOS repo](https://github.com/OpenNebula/opennebula-hosted-ionos).

[dcd-layout]: /images/solutions/ionos/dcd-layout.png
[ip-man]: /images/solutions/ionos/ip-management.png
[ip-booked-for-server]: /images/solutions/ionos/ip-booked-for-server.png
[token-manager]: /images/solutions/ionos/token-manager.png
[dcd-uuid]: /images/solutions/ionos/dcd-uuid.png
