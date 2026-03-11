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

Equinix supports metal edge clusters that use bare-metal instances to create OpenNebula Hosts. Metal provisions run the LXC or KVM hypervisors.

## Equinix Edge Cluster Implementation

An Edge Cluster in Equinix creates the **Packet Device**, which is a host to run virtual machines.

The network model is implemented in the following way:

* **Public Networking**: relies on elastic IPs from Equinix and the IPAM driver from OpenNebula. When you create the virtual network in OpenNebula, the elastic IPs are requested to Equinix. IP forwarding rules are applied within the host, so the VM communicates over the public IP assigned by Equinix.
* **Private Networking**: uses BGP-EVPN and VXLAN.

![Network model implementation with public and private networking](/images/equinix_deployment.png)

## OpenNebula Resources

The following resources, associated to each Edge Cluster, are created in OpenNebula:

1. Cluster: containing all other resources
2. Hosts: for each Equinix device
3. Datastores: image and system datastores with SSH transfer manager using first instance as a replica
4. Virtual network: for public networking
5. Virtual network template: for private networking

## Creating an Equinix Provision

### Prerequisites

To create an Equinix provision, you must have an [Equinix provider](/product/cloud_cluster_provisioning/cloud_cluster_providers/equinix_provider/) already created.

### Procedure

Select the relevant interface to create an Equinix provision in your OpenNebula installation:


{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}

{{% tab header="Sunstone"%}}
**Step 1.** Navigate through `Infrastructure > Clusters` in the sidebar:

{{< theme-image
  dark="images/oneform/oneprovision/common/dark/sunstone_navigation.png"
  light="images/oneform/oneprovision/common/light/sunstone_navigation.png"
  alt="Step 1"
>}}

**Step 2.** Click on the `Create` button and select the option `Install a new Cloud Cluster`:

{{< theme-image
  dark="images/oneform/oneprovision/common/dark/create_cluster_button.png"
  light="images/oneform/oneprovision/common/light/create_cluster_button.png"
  alt="Step 2.1"
>}}

{{< theme-image
  dark="images/oneform/oneprovision/common/dark/cloud_cluster_button.png"
  light="images/oneform/oneprovision/common/light/cloud_cluster_button.png"
  alt="Step 2.2"
>}}

**Step 3.** Select the Provider you want to use to create the cloud cluster:

{{< theme-image
  dark="images/oneform/oneprovision/equinix/dark/equinix_provider.png"
  light="images/oneform/oneprovision/equinix/light/equinix_provider.png"
  alt="Step 3"
>}}

**Step 4.** Fill the general section with at least a name for the cluster, and then click on `Next` button:

{{< theme-image
  dark="images/oneform/oneprovision/common/dark/general_step.png"
  light="images/oneform/oneprovision/common/light/general_step.png"
  alt="Step 4"
>}}

**Step 5.** Select the kind of the deployment you want to use for the cluster and click on `Next` button:

{{< theme-image
  dark="images/oneform/oneprovision/equinix/dark/deployment_types_step.png"
  light="images/oneform/oneprovision/equinix/light/deployment_types_step.png"
  alt="Step 5"
>}}

**Step 6.** Fill the User Inputs section to configure the cluster and click on `Next` button:

{{< theme-image
  dark="images/oneform/oneprovision/equinix/dark/user_inputs_step.png"
  light="images/oneform/oneprovision/equinix/light/user_inputs_step.png"
  alt="Step 6"
>}}

**Step 7.** Fill optional tags for resources that will be created on Equinix and OpenNebula and click on `Finish` button:

{{< theme-image
  dark="images/oneform/oneprovision/common/dark/tags_step.png"
  light="images/oneform/oneprovision/common/light/tags_step.png"
  alt="Step 7"
>}}

**Step 8.** You can follow the logs and the state of the cluster during
the process:

**Step 9.** After reaching the RUNNING state, a full cloud cluster is available, full to operate with it:

{{< theme-image
  dark="images/oneform/oneprovision/equinix/dark/equinix_cluster.png"
  light="images/oneform/oneprovision/equinix/light/equinix_cluster.png"
  alt="Step 9"
>}}

{{% /tab %}}

{{% tab header="CLI"%}}

Create an Equinix provision with the `oneprovision create <name> --provider-id <id>` command, specifying `equinix` as the provider type and the ID of the associated provider to this provision. This initiates an automated process where OneForm prompts for all required input parameters and starts the deployment:

```bash
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

After you have created the provision, list all the existing provisions using the `oneprovision list` command:

```bash
$ oneprovision list
  ID USER     GROUP     NAME                  STATE            REGTIME
  1  oneadmin oneadmin  Equinix SSH Cluster   RUNNING          06/05 10:52:29
```

To inspect the details of a specific provision, run the `oneprovision show` command. The output displays information about the generated OpenNebula objects such as hosts, datastores, and networks:

```bash
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

For further details about the API, refer to the [OneForm API Reference Guide](/product/integration_references/system_interfaces/oneform_api.md).
{{% /tab %}}

{{< /tabpane >}}
