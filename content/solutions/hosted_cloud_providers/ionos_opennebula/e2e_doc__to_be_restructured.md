---
title: "OpenNebula Deployment Guide on IONOS"
description:
categories:
pageintoc: ""
tags:
weight: "2"
---

![image][logo]

# **OpenNebula Deployment Guide**

**Project:** IONOS reference Cloud Provider integration  
**Date**: June 2nd 2025  
**Version**: 0.1

**Abstract**

This document describes the high-level architecture of the OpenNebula-based cloud platform, with its main functional components and its basic layout. **This is a living document that will evolve as new features are included in the integration or as new automations are performed.**  
A brief guide is provided for provisioning the cloud resources using the management web interface of IONOS cloud. After OpenNebula deployment, a guide is shown to perform basic UI tests and automated verification.

This guide should be included in the official OpenNebula documentation https://docs.opennebula.io/7.0/solutions/

**Revision History**

| Version | Date | Author | Comments |
| :---- | :---- | :---- | :---- |
| 0.1 | 02.06.2025 | OpenNebula Systems | **Initial version** of the document |
| 1.0 | 05.06.2025 | OpenNebula Systems | Verified on OpenNebula 7.0, and adapted to implemented automations |
|  |  |  |  |
|  |  |  |  |
|  |  |  |  |

**Table of Contents**

[Target Cloud Architecture](#target-cloud-architecture)

[Specification](#hardware-and-software-cloud-specification)

[Infrastructure Provisioning](#infrastructure-provisioning)

[Overview](#heading=h.h873mpetsgxz)

[Building with DCD](#building-with-dcd)

[Generate a token](#generate-a-token)

[Find the data center UUID](#retrieving-the-data-ceenter-uuid)

[Saving essential parameters](#saving-essential-parameters)

[Deployment and Automated Verification Procedure](#deployment-and-automated-verification-procedure)

[Basic UI Guide: VM instantiation](#basic-ui-guide:-vm-instantiation)

[Manual VM connectivity verification](#manual-vm-connectivity-verification)

# 

# 

# 

# 

# 

# 

# 

# **Overview**

This guide provides a deployment and verification path to achieve an OpenNebula Hosted Cloud using IONOS bare metal resources, as part of the OpenNebula Ready Certification Program.

As such it includes an OpenNebula Architecture specifically tailored for the IONOS infrastructure as well as the hardware specification from the IONOS bare metal offering, as well as instructions on how to request these resources using the IONOS interface and perform a ZeroTouch automatic deployment of OpenNebula over them, as well as an automated verification step to ascertain the correctness of the resulting cloud.

Finally it includes a guide covering the basics to start using the OpenNebula Hosted Cloud.

# **Target Cloud Architecture** {#target-cloud-architecture}

The target high level cloud architecture overview is shown in Figure 1, where the two hosts are deployed, one of them is hosting the OpenNebula frontend services and VMs, the other one is for hosting VMs only. Both machines should have a public IP, which is used to manage the nodes. The figure also shows the target reference VMs to  be deployed for testing purposes. At least one VM must be possible to configure with a public IP, and all of them shall be connected to the VXLAN network.

**Figure 1\.** High Level Cloud Architecture Overview for OpenNebula deployment on IONOS cloud.

# **Hardware and Software Cloud Specification** {#hardware-and-software-cloud-specification}

This section contains the specification of the used hardware and software resources in this deployment guide, summarized in Table 1\.

**Table 1\.** Specification of the reference OpenNebula deployment on IONOS cloud.

| FRONT-END |  |
| :---- | :---- |
| **Number of Zones** | 1 |
| **Cloud Manager** | OpenNebula 6.99.85 |
| **Server Specs** | IONOS “Dedicated Core Server”,Intel Skylake, 2 Cores,  8GB RAM |
| **Operating System** | Debian 12 |
| **High Availability** | No (1 frontend) |
| **Authorization** | Builtin |
| **VIRTUALIZATION HOSTS** |  |
| **Number of Nodes** | 1 |
| **Server Specs** | IONOS “Dedicated Core Server”,Intel Skylake, 2 Cores,  8GB RAM |
| **Operating System** | Debian 12 |
| **Hypervisor** | KVM |
| **Special Devices** | None |
| **STORAGE** |  |
| **Type** | Local disk |
| **Capacity** | 1 Datastore |
| **NETWORK** |  |
| **Networking** | VXLAN, Public routed network |
| **Number of Networks** | 2 networks: VXLAN  Public routed network, with each host machine having a NIC and a public IP |
| **PROVISIONING MODEL** |  |
| **VDCs** | 1 VDC with 1 cluster (2 nodes)   Users will be able to provision and manage VMs via OpenNebula Web Interface, on the Frontend node’s public IP. |

# 

# **Infrastructure Provisioning** {#infrastructure-provisioning}

The deployment of the virtual servers can be done through the IONOS [Data Center Designer (DCD)](https://dcd.ionos.com/).   
Build the following configuration, shown in Figure 2, with the details described in the Specification section.

![image][dcd-layout]

**Figure 2\.** The layout of the reference deployment in the IONOS Data Center Designer’s web UI.

## **Building with DCD** {#building-with-dcd}

The steps to achieve the base of deployment showed in Figure 2 in the IONOS DCD are the following:

1. Add the Dedicated Core Servers .  
2. Add Internet access from the toolbar.  
3. Connect all servers to the Internet access, use consistently their first NICs.  
4. Connect their second NICs to the private LAN between them, use the second NICs consistently.  
5. Add HDD instances and specify the base image for the operating systems  
   1. Choose the specifications as shown in Table 1\.  
   2. Add the SSH key of the host from which the access is needed,  
   3. Set it as a boot device.

Then book the following two IP ranges, as shown in Figure 3\.

* booked-for-servers: These are the management IPs for each servers, book an IP block with enough addresses for the servers, assigning 1 IP per server.  
* booked-for-vms: These are the traffic IPs for public-facing VMs, that will be deployed using OpenNebula. Book a block big enough for the VMs.

![image][ip-man]

**Figure 3\.** Booking the IP blocks for servers and the VMs in the IONOS DCD.

Assign the booked IP addresses to the servers, as shown in Figure 4\. Note that, without assigning any booked public IP addresses, IONOS will automatically assign new addresses at server startup.

| ![][image4] |
| :---: |
| **Figure 4\.** Assign the IP addresses from the “booked-for-servers” block to the first NICs of the servers. |

Click “Provision changes” button in the DCD to perform all the changes done in this section. The changes should take a few minutes and the success result is reported in the DCD.

## **Generate a token** {#generate-a-token}

Access the [Token Manager of IONOS](https://dcd.ionos.com/latest/#/tokens), generate a new token, and save the token’s value. As shown in Figure 4.1, this value cannot be accessed through the web later, only at this moment.

| ![][image5] |
| :---: |
| **Figure 4.1.** Generate a new token with the IONOS Token Manager, and save the tokens value. |

## **Retrieving the Data Ceenter UUID** {#retrieving-the-data-ceenter-uuid}

At the [IONOS Data Center Designer web UI](https://dcd.ionos.com/), open the canvas where the infrastructure was designed. Copy and save the virtual data center’s UUID, by clicking the API icon, as shown in Figure 4.2.

| ![][image6] |
| :---: |
| **Figure 4.2** Find and extract the UUID of the created virtual data center. |

# **Saving essential parameters** {#saving-essential-parameters}

As of now, all required infrastructure components have been deployed and configured in the IONOS DCD. To proceed with OpenNebula deployment, we need to extract and save some essential parameters that the deployment automation relies on. Table 2 lists all of these parameters and summarizes how to find them.

**Table 2\.** List of essential deployment parameters and how to find them in the just-provisioned IONOS infrastructure.

| Description | How to get the parameter? |
| ----- | ----- |
| Frontend Host IP | Choose an IP from the ‘booked-for-servers’ IP range that will serve as OpenNebula Frontend. |
| KVM Host IPs | Choose all other IPs from the ‘booked-for-servers’ IP range that will serve as OpenNebula hosts, running Virtual Machines. |
| KVM Host Gateway | For each KVM Host IP, you can find the IONOS assigned gateway IP in the DCD, as shown in Figure 4\. |
| VXLAN PHYDEV | Interface name of the private LAN on all servers. Find it by launching ‘ip address’ command in servers’ the Linux CLI. |
| pubridge PHYDEV | Interface name of the NIC connected to the Internet gateway on all servers. Find it by launching ‘ip address’ command in servers’ the Linux CLI. |
| VMs Public IP Range | All the IPs that are contained in the IP range ‘booked-for-vms’, as shown in Figure 3\. |
| GUI password of \`oneadmin\` | Specified by the administrator performing the deployment steps. |
| IONOS Data Center UUID | The virtual data center’s UUID, as shown in Figure 4.2. |
| IONOSCTL Token | The IONOS API/SDK token value, as it was generated and saved previously, as shown in Figure 4.1. |

To find the PHYDEV parameter value for the VXLAN and the public bridge, access the Linux CLI of a deployed server. Find the interface name of the first and second NICs that were connected to the Internet gateway and the private LAN respectively. Launch the “ip address” command and inspect the outputs, matching the NICs to their Linux system names, by comparing the assigned IP and MAC addresses as shown in the IONOS DCD. These interface names should be the same on all servers, if consistently the first and second NICs were used to connect them to the internet and the private LAN respectively. Verify that this is indeed the case, by accessing multiple servers and inspecting the outputs of the “ip address” commands.

# **Deployment and Automated Verification Procedure** {#deployment-and-automated-verification-procedure}

The whole OpenNeula deployment procedure and all required resources are available in [OpenNebula's hosted IONOS repo](https://github.com/OpenNebula/opennebula-hosted-ionos), also referred to as deployment repository. Take a look at the README for specific instructions on how to use the essential parameters that were extracted from the provisioned IONOS infrastructure, shown in Table 2\.

The deployment procedure consists of the following high level steps:

1. Initialize the deployment repository.  
2. Update the deployment repository with the essential parameters gathered above.  
3. Customize networking configuration of the provisioned servers.  
4. Launch the deployment automation commands.  
5. Launch the automated verification command.

For detailed information about how to use the essential parameters and which configuration files to modify, please refer to the README of the [OpenNebula's hosted IONOS repo](https://github.com/OpenNebula/opennebula-hosted-ionos).

# **Basic UI Guide: VM instantiation** {#basic-ui-guide:-vm-instantiation}

Access the OpenNebula Web UI at

              [http://\<\<frontend\_public\_ip\>\>:2616/fireedge/sunstone](http://FRONTEND_PUBLIC_IP:2616/fireedge/sunstone) 

The default username is “oneadmin” and its password is specified in the “one\_pass” variable of the inventory file.

Import a VM template from the public marketplace, as shown in Figure 5\. For instance, search for “Alpine Linux 3.17”, select it and click on the “Cloud” icon for importing.

| ![][image7] |
| :---: |
| **Figure 5\.** Import a VM template and image from the Apps menu. |

Instantiate the VM by clicking the icon highlighted in Figure 6\. And choose the previously imported image.

| ![][image8] |
| :---: |
| **Figure 6\.** Instantiate a VM in the OpenNebula UI. |

At the VM instantiation menu attach a NIC and choose the public bridge, as shown in Figure 7\. All other values can be left empty or their default values.

| ![][image9] |
| :---: |
| **Figure 7\.** Attach a NIC to the VM, by choosing the public network. |

Add a PASSWORD field and specify the desired root password for the VM, then click Accept, as shown in Figure 8\.

| ![][image10] |
| :---: |
| **Figure 8\.** Specify the root password in the VM Configuration’s Context tab. |

Log in to the VM via VNC, using root user and the password previously specified, the VNC button is highlighted in Figure 9\.

| ![][image11] |
| :---: |
| **Figure 9\.** Accessing the VM’s console via VNC. |

Perform a manual, public connectivity test from the deployed VM, by pinging a public IP address, e.g. 8.8.8.8, as shown in Figure 10\.

| ![][image12] |
| :---: |
| **Figure 10\.** Performing a connectivity test from the VM manually, by pinging a public IP address. |

Finally, as a cleanup step, terminate the VM by clicking the red “Trash can” icon, and verify that VM transitions to DONE state, as shown in Figure 11\.

| ![][image13] |
| :---: |
| **Figure 11\.** A terminated VM, successfully transitioned to DONE state. |

# **Manual VM connectivity verification** {#manual-vm-connectivity-verification}

At this point the automatic verification does not verify the correct behaviour of the VXLAN networking deployed between the VMs.   
Deploy the following test VMs as shown in Table 3\. This VM deployment has been demonstrated on the target architecture in Figure 1\. For each VM deployment, follow the UI guide as detailed above with screenshots.

**Table 3\.** VMs to be deployed for the manual VXLAN verification.

| VM name | Hosting location | Networking |
| :---- | :---- | :---- |
| VM1 | KVM node2 | public NIC, vxlan NIC |
| VM2 | KVM node2 | vxlan NIC |
| VM3 | KVM node1 | vxlan NIC |

Log into each VM and verify the following connectivity matrix of the deployed VMs, as shown in Table 4\.

**Table 4\.** Connectivity matrix to manually test the VXLAN networking between the deployed VMs.

| *Source (row), target (column)* | VM1 | VM2 | VM3 | 8.8.8.8 (or any public IP) |
| :---- | :---- | :---- | :---- | :---- |
| **VM1** | \- | TEST | TEST | TEST |
| **VM2** | To vxlan: TEST | \- | TEST | \- |
| **VM3** | To vxlan: TEST | TEST | \- | \- |
| **Local laptop (or any public IP)** | To public: TEST | \- | \- | \- |


[logo]: /images/solutions/ionos/logo.png
[dcd-layout]: /images/solutions/ionos/dcd-layout.png
[ip-man]: /images/solutions/ionos/ip-management.png
