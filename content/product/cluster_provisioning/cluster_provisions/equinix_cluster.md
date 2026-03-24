---
title: "Equinix Cluster"
linkTitle: "Equinix"
date: "2025-02-17"
description:
categories:
pageintoc: "212"
tags:
weight: "4"
---

<a id="equinix-cluster"></a>

<!--# Equinix Edge Cluster -->

Equinix supports metal Edge Clusters enabling the deployment of OpenNebula Hosts on bare-metal instances. Equinix metal Provisions support KVM hypervisors.

## Equinix Edge Cluster Implementation

An Edge Cluster in Equinix creates the **Packet Device**, which is a Host to run Virtual Machines.

The network model is implemented in the following way:

* **Public Networking**: Relies on Elastic IPs from Equinix and the IPAM driver from OpenNebula. When you create the Virtual Network in OpenNebula, the Elastic IPs are requested from Equinix. IP forwarding rules are applied within the Host, so the VM communicates through the public IP assigned by Equinix.
* **Private Networking**: Uses BGP-EVPN and VXLAN.

{{< image path="images/oneform/oneprovision/equinix/equinix_deployment.svg" alt="Network model implementation with public and private networking" align="center" width="80%" pb="20px" >}}

## OpenNebula Resources

The following resources, associated to each Edge Cluster, are created in OpenNebula:

1. **Cluster**: Containing all other resources
2. **Hosts**: Cor each Equinix device
3. **Datastores**: Image and system datastores with SSH transfer manager using first instance as a replica
4. **Virtual Network**: For public networking
5. **Virtual Network Template**: For private networking

## Creating an Equinix Provision

### Prerequisites

To create an Equinix Provision, you must have an [Equinix Provider]({{% relref "/product/cluster_provisioning/cluster_providers/equinix_provider/" %}}) already created.

### Procedure

The following process demonstrates how to create an Equinix Provision in your OpenNebula installation. Please select the tab for your preferred interface:

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}

{{% tab header="Sunstone"%}}
**Step 1.** Navigate to **Infrastructure -> Clusters** in the Sunstone sidebar:

{{< theme-image
  dark="images/oneform/oneprovision/common/dark/sunstone_navigation.png"
  light="images/oneform/oneprovision/common/light/sunstone_navigation.png"
  alt="Step 1"
>}}

**Step 2.** Click **Create** and select **Install a new Cloud Cluster**:

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

**Step 3.** Select your preferred Equinix Provider and click **Next**:

{{< theme-image
  dark="images/oneform/oneprovision/equinix/dark/equinix_provider.png"
  light="images/oneform/oneprovision/equinix/light/equinix_provider.png"
  alt="Step 3"
>}}

**Step 4.** Enter a name for the Cluster in the **General** page and click **Next**:

{{< theme-image
  dark="images/oneform/oneprovision/common/dark/general_step.png"
  light="images/oneform/oneprovision/common/light/general_step.png"
  alt="Step 4"
>}}

**Step 5.** Select the type of deployment and click **Next**:

{{< theme-image
  dark="images/oneform/oneprovision/equinix/dark/deployment_types_step.png"
  light="images/oneform/oneprovision/equinix/light/deployment_types_step.png"
  alt="Step 5"
>}}

**Step 6.** Fill the **User Inputs** section to configure the Cluster and click **Next**:

{{< theme-image
  dark="images/oneform/oneprovision/equinix/dark/user_inputs_step.png"
  light="images/oneform/oneprovision/equinix/light/user_inputs_step.png"
  alt="Step 6"
>}}

**Step 7.** Optionally you can add tags to help identify your Cluster in OpenNebula and Equinix. Click **Finish** to start the Cluster deployment:

{{< theme-image
  dark="images/oneform/oneprovision/common/dark/tags_step.png"
  light="images/oneform/oneprovision/common/light/tags_step.png"
  alt="Step 7"
>}}

**Step 8.** You can observe the logs and the status of the Cluster deployment in the **Cluster Logs** view:

{{< theme-image
  dark="images/oneform/oneprovision/aws/dark/aws_cluster_logs.png"
  light="images/oneform/oneprovision/aws/light/aws_cluster_logs.png"
  alt="Step 8"
>}}

**Step 9.** After reaching the RUNNING state, a full cloud Cluster is available, ready to operate:

{{< theme-image
  dark="images/oneform/oneprovision/equinix/dark/equinix_cluster.png"
  light="images/oneform/oneprovision/equinix/light/equinix_cluster.png"
  alt="Step 9"
>}}

{{% /tab %}}

{{% tab header="CLI"%}}

Create an Equinix Provision with the `oneprovision create <name> --provider-id <ID>` command, specifying `equinix` as the Provider type and the ID of the associated Provider to this Provision (use `oneprovider list` to find the appropriate ID). This initiates an automated process in which OneForm prompts for all required input parameters and starts the deployment:

```bash
oneprovision create equinix --provider-id 1
```
```default
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

After you have created the Provision, list all the existing Provisions using the `oneprovision list` command:

```bash
oneprovision list
```
```default
  ID USER     GROUP     NAME                  STATE            REGTIME
  1  oneadmin oneadmin  Equinix SSH Cluster   RUNNING          06/05 10:52:29
```

To inspect the details of a specific Provision, run the `oneprovision show` command. The output displays information about the generated OpenNebula objects such as Hosts, datastores, and networks:

```bash
oneprovision show 1
```
```default
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

To create a new AWS Provision using the OneForm API, use the following example request, replacing the appropriate parameters for your Provision:

```bash
curl -X POST "https://oneform.example.server/api/v1/provisions" \
  -u "username:password" \
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
<br>

For further details about the API, see the [OneForm API Reference]({{% relref "/product/integration_references/system_interfaces/oneform_api.md" %}}).
{{% /tab %}}

{{< /tabpane >}}

Now that you have created an Equinix Cluster, learn how to [Manage your Provisioned Clusters]({{% relref "/product/cluster_provisioning/cluster_operations/provision_operations.md" %}}).

