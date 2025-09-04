---
title: "Scaleway Edge Cluster"
date: "2025-02-17"
description:
categories:
pageintoc: "213"
tags:
weight: "5"
---

<a id="scaleway-cluster"></a>

<!--# Scaleway Edge Cluster -->

## Edge Cluster Types

Scaleway supports **metal** edge clusters that use bare-metal instances to create OpenNebula Hosts. Metal provisions can run the **LXC** or **KVM** hypervisors.

## Scaleway Edge Cluster Implementation

An Edge Cluster in Scaleway creates the following resources:

* **Scaleway Elastic Metal Device**: Host to run virtual machines.
* **Scaleway VPC**: it creates an isolated virtual network for all the deployed resources.
* **Scaleway private subnet**: it allows communication between VMs that are running in the provisioned Hosts.
* **Scaleway internet public gateway**: it allows VMs to have public connectivity over Internet.

The network model is implemented in the following way:

* **Public Networking**: this is implemented using elastic IPs from Scaleway and the IPAM driver from OpenNebula. When the virtual network is created in OpenNebula, the elastic IPs are requested from Scaleway. Then, inside the Host, IP forwarding rules are applied so the VM can communicate over the public IP assigned by Scaleway.
* **Private Networking**: this is implemented using (BGP-EVPN) and VXLAN.

![image_cluster](/images/scaleway-deployment.jpg)

## OpenNebula resources

The following resources, associated to each Edge Cluster, will be created in OpenNebula:

1. Cluster - containing all other resources.
2. Hosts - for each Scaleway Elastic Metal Device.
3. Datastores - image and system datastores with SSH transfer manager using first instance as a replica.
4. Virtual network - for public networking.
5. Virtual network template - for private networking.

## How to Create An Scaleway Provision

The following process describes how to create an Scaleway provision in your OpenNebula installation:

{{< alert title="Note" color="success" >}}
To create a provision in Scaleway, first [you must have an Scaleway provider already created]().
{{< /alert >}}

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}

{{% tab header="Sunstone"%}}
Still under development.
{{% /tab %}}

{{% tab header="CLI"%}}

You can create a Scaleway provision using the `oneprovider create <name> --provider-id <id>` command, specifying `scaleway` as the provider type and the ID of the associated provider to this provision. This will initiate an automated process where OneForm prompts for all required input parameters and starts the deployment:

```default
$ oneprovision create scaleway --provider-id 1
There are some parameters that require user input.
  * (oneform_hosts) Number of instances to create [type: number, default: 1]
    > 1
  * (instance_type) Instance type [type: list: em_a115x_ssd]
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
  ID USER     GROUP     NAME                  STATE            REGTIME
  1  oneadmin oneadmin  Scaleway SSH Cluster  RUNNING          06/05 10:52:29
```

To inspect the full details of a specific provision, including the generated OpenNebula objects such as hosts, datastores, and networks, run the `oneprovision show` command:

```default
$ oneprovision show 1
PROVISION 1 INFORMATION
ID                  : 1
NAME                : Scaleway SSH Cluster
DESCRIPTION         : It deploys a SSH cluster on Scaleway
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
oneform_hosts       : 0
instance_disk_size  : 128
instance_os_name    : ubuntu_2204
instance_public_ips : 0
instance_type       : c5.metal

OPENNEBULA RESOURCES
CLUSTER
ID                  : 2
NAME                : Scaleway SSH Cluster

HOSTS
ID   NAME            RESOURCE_ID
3    3.74.216.118    i-006a01c592f849031

NETWORKS
ID   TYPE            NAME
6    vxlan           private_scaleway_network
7    elastic         public_scaleway_network

DATASTORES
ID   TYPE            NAME
101  system_ds       scaleway_system_ds
102  image_ds        scaleway_image_ds
```

{{% /tab %}}

{{% tab header="API"%}}

```bash
curl -X POST "https://oneform.example.server/api/v1/provisions" \
  -H "Content-Type: application/json" \
  -d '{
    "driver": "scaleway",
    "deployment_type": "ssh_cluster",
    "provider_id": 1,
    "user_inputs_values": {
      "oneform_hosts": 1,
      "instance_disk_size": 128,
      "instance_os_name": "ubuntu_2204",
      "instance_public_ips": 0,
      "instance_type": "em_a115x_ssd"
    },
    "name": "Scaleway Cluster",
    "description": "Provision in Scaleway"
  }'
```

For further details about the API, please refer to the [OneForm API Reference Guide](/product/integration_references/system_interfaces/oneform_api.md).
{{% /tab %}}

{{< /tabpane >}}
