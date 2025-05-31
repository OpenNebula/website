---
title: "AWS Edge Cluster"
date: "2025-02-17"
description:
categories:
pageintoc: "211"
tags:
weight: "2"
---

<a id="aws-cluster"></a>

<!--# AWS Edge Cluster -->

## Edge Cluster Types

The AWS **metal** Edge Clusters uses baremetal instances to create OpenNebula Hosts, providing the best performance and highest capacity. These Edge Clusters can run **LXC** or **KVM** hypervisors.

## AWS Edge Cluster Implementation

An Edge Cluster in AWS creates the following resources:

* **AWS instance**: Host to run Virtual Machines.
* **AWS VPC**: it creates an isolated virtual network for all the deployed resources. There are some limits in the number of VPC that can be requested by the user, please refer to [this link](https://docs.aws.amazon.com/vpc/latest/userguide/amazon-vpc-limits.html) for more information.
* **AWS subnet**: it allows communication between VMs that are running in the provisioned Hosts.
* **AWS internet gateway**: it allows VMs to have public connectivity over Internet.
* **AWS security group**: by default all the traffic is allowed but custom security rules can be defined by the user to allow only specific traffic to the VMs.

The network model is implemented in the following way:

* **Public Networking**: this is implemented using elastic IPs from AWS and the IPAM driver from OpenNebula. When the virtual network is created in OpenNebula, the elastic IPs are requested from AWS. Then, inside the Host, IP forwarding rules are applied so the VM can communicate over the public IP assigned by AWS. There are some limits to the number of elastic IPs that can be requested; please refer to [this link](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html#using-instance-addressing-limit) for more information.
* **Private Networking**: this is implemented using (BGP-EVPN) and VXLAN.

![image_cluster](/images/aws_deployment.png)

## OpenNebula resources

The following resources, associated to each Edge Cluster, will be created in OpenNebula:

1. Cluster - containing all other resources
2. Hosts - for each AWS instance
3. Datastores - image and system datastores with SSH transfer manager using first instance as a replica
4. Virtual network - for public networking
5. Virtual network template - for private networking
