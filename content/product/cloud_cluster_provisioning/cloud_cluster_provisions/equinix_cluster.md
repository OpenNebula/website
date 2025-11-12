---
title: "Equinix Edge Cluster"
date: "2025-02-17"
description:
categories:
pageintoc: "212"
tags:
weight: "4"
---

<a id="equinix-cluster"></a>

<!--# Equinix Edge Cluster -->

## Edge Cluster Types

Equinix supports **metal** edge clusters that use bare-metal instances to create OpenNebula Hosts. Metal provisions can run the **LXC** or **KVM** hypervisors.

## Equinix Edge Cluster Implementation

An Edge Cluster in Equinix creates the following resources:

* **Packet Device**: Host to run virtual machines.

The network model is implemented in the following way:

* **Public Networking**: this is implemented using elastic IPs from Equinix and the IPAM driver from OpenNebula. When the virtual network is created in OpenNebula, the elastic IPs are requested from Equinix. Then, inside the Host, IP forwarding rules are applied so the VM can communicate over the public IP assigned by Equinix.
* **Private Networking**: this is implemented using (BGP-EVPN) and VXLAN.

![image_cluster](/images/equinix_deployment.png)

## OpenNebula resources

The following resources, associated to each Edge Cluster, will be created in OpenNebula:

1. Cluster - containing all other resources
2. Hosts - for each Equinix device
3. Datastores - image and system datastores with SSH transfer manager using first instance as a replica
4. Virtual network - for public networking
5. Virtual network template - for private networking

## How to Create An Equinix Provision

The following process describes how to create an Equinix provision in your OpenNebula installation:

{{< alert title="Note" color="success" >}}
To create a provision in Equinix, first [you must have an Equinix provider already created]().
{{< /alert >}}

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}

{{% tab header="Sunstone"%}}
Still under development.
{{% /tab %}}

{{% tab header="CLI"%}}

You can create an Equinix provision using the `oneprovider create <name> --provider-id <id>` command, specifying `equinix` as the provider type and the ID of the associated provider to this provision. This will initiate an automated process where OneForm prompts for all required input parameters and starts the deployment:

```default
$ oneprovision create equinix--provider-id 1
There are some parameters that require user input.
  * (oneform_hosts) Number of instances to create [type: number, default: 1]
    > 1
  * (instance_type) Instance type [type: list: c3.small, c5.small]
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
  1  oneadmin oneadmin  Equinix SSH Cluster   RUNNING          06/05 10:52:29
```

To inspect the full details of a specific provision, including the generated OpenNebula objects such as hosts, datastores, and networks, run the `oneprovision show` command:

```default
$ oneprovision show 1
PROVISION 1 INFORMATION
ID                  : 1
NAME                : Equinix SSH Cluster
DESCRIPTION         : It deploys a SSH cluster on Equinix
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
oneform_hosts       : 1
instance_disk_size  : 128
instance_os_name    : ubuntu_2204
instance_public_ips : 0
instance_type       : c3.small

OPENNEBULA RESOURCES
CLUSTER
ID                  : 2
NAME                : Equinix SSH Cluster

HOSTS
ID   NAME            RESOURCE_ID
3    3.74.216.118    i-006a01c592f849031

NETWORKS
ID   TYPE            NAME
6    vxlan           private_equinix_network
7    elastic         public_equinix_network

DATASTORES
ID   TYPE            NAME
101  system_ds       equinix_system_ds
102  image_ds        equinix_image_ds
```

{{% /tab %}}

{{% tab header="API"%}}

```bash
curl -X POST "https://oneform.example.server/api/v1/provisions" \
  -H "Content-Type: application/json" \
  -d '{
    "driver": "equinix",
    "deployment_type": "ssh_cluster",
    "provider_id": 1,
    "user_inputs_values": {
      "oneform_hosts": 1,
      "instance_disk_size": 128,
      "instance_os_name": "ubuntu_2204",
      "instance_public_ips": 0,
      "instance_type": "c3.small"
    },
    "name": "Equinix Cluster",
    "description": "Provision in Equinix"
  }'
```

For further details about the API, please refer to the [OneForm API Reference Guide](/product/integration_references/system_interfaces/oneform_api.md).
{{% /tab %}}

{{< /tabpane >}}
