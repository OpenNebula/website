---
title: "AWS Edge Cluster"
date: "2025-02-17"
description:
categories:
pageintoc: "211"
tags:
weight: "3"
---

<a id="aws-cluster"></a>

<!--# AWS Edge Cluster -->

## Edge Cluster Types

AWS edge clusters provisioned through OneForm currently support **KVM-based deployments**. These clusters run on bare-metal EC2 instances and are fully integrated with OpenNebula’s virtualization and storage layers.

AWS provisions offer an **SSH-based Storage Cluster** configuration, which uses the [OpenNebula SSH datastore driver]() to provision both system and image datastores.

## AWS Edge Cluster Implementation

An Edge Cluster in AWS creates the following resources:

* **AWS instance**: Host to run virtual machines.
* **AWS VPC**: it creates an isolated virtual network for all the deployed resources. There are some limits in the number of VPC that can be requested by the user, please refer to [this link](https://docs.aws.amazon.com/vpc/latest/userguide/amazon-vpc-limits.html) for more information.
* **AWS subnet**: it allows communication between VMs that are running in the provisioned Hosts.
* **AWS internet gateway**: it allows VMs to have public connectivity over Internet.
* **AWS security group**: by default all the traffic is allowed, but custom security rules can be defined by the user to allow only specific traffic to the VMs.

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

## How to Create An AWS Provision

The following process describes how to create an AWS provision in your OpenNebula installation:

{{< alert title="Note" color="success" >}}
To create a provision in AWS, first [you must have an AWS provider already created]().
{{< /alert >}}

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}

{{% tab header="Sunstone"%}}
Still under development.
{{% /tab %}}

{{% tab header="CLI"%}}

You can create an AWS provision using the `oneprovider create <name> --provider-id <id>` command, specifying `aws` as the provider type and the ID of the associated provider to this provision. This will initiate an automated process where OneForm prompts for all required input parameters and starts the deployment:

```default
$ oneprovision create aws --provider-id 1
There are some parameters that require user input.
  * (cidr_block) CIDR block for the VPC [type: string, default: 10.0.0.0/16]
    > 10.0.0.0/16
  * (oneform_hosts) Number of instances to create [type: number, default: 1]
    > 1
  * (instance_type) Instance type [type: list: c5.metal, m5.large]
    > 0
  * (instance_os_name) OS [type: list: ubuntu_2204, ubuntu_2404]
    0: ubuntu_2204
    1: ubuntu_2404

    Press enter for default (ubuntu_2204). Please type the selection number: 0
  * (instance_disk_size) Disk size in GB [type: number, min: 32, max: 1024]
    > 128
  * (instance_public_ips) Number of public IPs [type: number, min: 0, max: 5]
    > 1

ID: 1
```

After the provision is created, you can see a list with all your provisions using the `oneprovision list` command:

```default
$ oneprovision list
  ID USER     GROUP    NAME                  STATE            REGTIME
  1  oneadmin oneadmin AWS SSH Cluster       RUNNING          06/05 10:52:29
```

To inspect the full details of a specific provision, including the generated OpenNebula objects such as hosts, datastores, and networks, run the `oneprovision show` command:

```default
$ oneprovision show 1
PROVISION 1 INFORMATION
ID                  : 1
NAME                : AWS SSH Cluster
DESCRIPTION         : It deploys a SSH cluster on AWS
USER                : oneadmin
GROUP               : oneadmin
STATE               : RUNNING
PROVIDER ID         : 1
REGISTRATION TIME   : 06/05 10:52:29

PERMISSIONS
OWNER               : um-
GROUP               : ---
OTHER               : ---

PROVISION VALUES
cidr_block          : 10.0.0.0/16
oneform_hosts       : 1
instance_disk_size  : 128
instance_os_name    : ubuntu_2204
instance_public_ips : 0
instance_type       : c5.metal

OPENNEBULA RESOURCES
CLUSTER
ID                  : 2
NAME                : AWS SSH Cluster

HOSTS
ID   NAME            RESOURCE_ID
3    3.74.216.118    i-006a01c592f849031

NETWORKS
ID   TYPE            NAME
6    vxlan           private_aws_network
7    elastic         public_aws_network

DATASTORES
ID   TYPE            NAME
101  system_ds       aws_system_ds
102  image_ds        aws_image_ds
```

{{% /tab %}}

{{% tab header="API"%}}

```bash
curl -X POST "https://oneform.example.server/api/v1/provisions" \
  -H "Content-Type: application/json" \
  -d '{
    "driver": "aws",
    "deployment_type": "ssh_cluster",
    "provider_id": 1,
    "user_inputs_values": {
      "cidr_block": "10.0.0.0/16"
      "oneform_hosts": 1,
      "instance_disk_size": 128,
      "instance_os_name": "ubuntu_2204",
      "instance_public_ips": 0,
      "instance_type": "c5.metal"
    },
    "name": "AWS Cluster",
    "description": "Provision in AWS"
  }'
```

For further details about the API, please refer to the [OneForm API Reference Guide](/product/integration_references/system_interfaces/oneform_api.md).
{{% /tab %}}
{{< /tabpane >}}
