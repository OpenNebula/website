---
title: "On-premises SSH"
date: "2025-02-17"
description:
categories:
pageintoc: "211"
tags:
weight: "2"
---

<!--# On-premises Cluster -->

A SSH on-premises Cluster utilizes existing physical or virtual servers as OpenNebula Hosts, integrating with and configuring on-premises infrastructure. The on-premises Cluster deployment operates using KVM hypervisors.

## On-premises SSH Cluster Implementation

Users must manually provide reachable IP addresses for each Host, ensuring that SSH connectivity functions correctly and system prerequisites are already met. The default OS is *Ubuntu 22.04*. The networking model is implemented as follows:

- **Public Networking**: Requires manually provided IP addresses or previously configured public IPs. IP forwarding rules must be managed manually.
- **Private Networking**: Uses BGP-EVPN and VXLAN to create private Virtual Networks among provided Hosts.

{{< image path="images/oneform/oneprovision/onprem/ssh_onprem_deployment.png" alt="Network model implementation with public and private networking" align="center" width="80%" pb="20px" >}}

## OpenNebula Resources

The following resources, which are associated with each on-premises Cluster, are created in OpenNebula:

1. **Cluster**: Aggregating all other resources.
2. **Hosts**: Corresponding to the provided IP addresses.
3. **Datastores**: Image and system datastores configured with an SSH transfer manager that utilize the first provided Host as the datastore replica.
4. **Virtual Network**: For public networking. This resource is configured manually.
5. **Virtual Network Template**: For private networking.

## Creating an On-premises Provision

### Prerequisites
To create an on-premises provision, you must have an [On-premises Provider]({{% relref "/product/cloud_cluster_provisioning/cloud_cluster_providers/onprem_provider/" %}}) that is already present with the `opennebula-form` package installation.

### Procedure

Select the relevant interface to create an on-premises provision in your OpenNebula installation:

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}

{{% tab header="Sunstone"%}}
**Step 1.** Navigate to **Infrastructure -> Clusters** in the Sunstone sidebar:

{{< theme-image
  dark="images/oneform/oneprovision/common/dark/sunstone_navigation.png"
  light="images/oneform/oneprovision/common/light/sunstone_navigation.png"
  alt="Step 1"
>}}

**Step 2.** Click **Create** button and select the option **Install a new On-Premise Cluster**:

{{< theme-image
  dark="images/oneform/oneprovision/common/dark/create_cluster_button.png"
  light="images/oneform/oneprovision/common/light/create_cluster_button.png"
  alt="Step 2.1"
>}}

{{< theme-image
  dark="images/oneform/oneprovision/common/dark/onprem_cluster_button.png"
  light="images/oneform/oneprovision/common/light/onprem_cluster_button.png"
  alt="Step 2.2"
>}}

**Step 3.** Enter a name for the cluster in the **General** page the click **Next**:

{{< theme-image
  dark="images/oneform/oneprovision/common/dark/onprem_general_step.png"
  light="images/oneform/oneprovision/common/light/onprem_general_step.png"
  alt="Step 3"
>}}

**Step 4.** Select the desired deployment type and click **Next**:

{{< theme-image
  dark="images/oneform/oneprovision/onprem/dark/ssh_deployment_types_step.png"
  light="images/oneform/oneprovision/onprem/light/ssh_deployment_types_step.png"
  alt="Step 4"
>}}

**Step 5.** Enter the correct configuration details in the **User Inputs** page and click **Next**:

{{< theme-image
  dark="images/oneform/oneprovision/onprem/dark/ssh_user_inputs.png"
  light="images/oneform/oneprovision/onprem/light/ssh_user_inputs.png"
  alt="Step 5"
>}}

If you chose to create an NFS Cluster type you need to enter some additional details about your NFS server:

{{< theme-image
  dark="images/oneform/oneprovision/onprem/dark/nfs_storage_parameters.png"
  light="images/oneform/oneprovision/onprem/light/nfs_storage_parameters.png"
  alt="Step 5"
>}}

**Step 6.** You can add optional tags to help identify the Cluster, click **Finish**:

{{< theme-image
  dark="images/oneform/oneprovision/onprem/dark/tags_step.png"
  light="images/oneform/oneprovision/onprem/light/tags_step.png"
  alt="Step 6"
>}}

**Step 7.** The **Cluster Logs** page shows the progress of the Cluster installation process:

{{< theme-image
  dark="images/oneform/oneprovision/onprem/dark/onprem_provision_logs.png"
  light="images/oneform/oneprovision/onprem/light/onprem_provision_logs.png"
  alt="Step 7"
>}}

**Step 8.** After reaching the RUNNING state, a full cloud cluster is available, ready to operate:

{{< theme-image
  dark="images/oneform/oneprovision/onprem/dark/onprem_cluster.png"
  light="images/oneform/oneprovision/onprem/light/onprem_cluster.png"
  alt="Step 8"
>}}

{{% /tab %}}

{{% tab header="CLI"%}}

### Listing templates

Create an on-prem provision with the `oneprovision create <name> --provider-id <id>` command, specifying `onprem` as the provider type and the ID of the associated provider to this provision (use `oneprovider list` to identify the correct provider). This will initiate an automated process in which OneForm prompts for all required input parameters and starts the deployment:


```bash
oneprovision create onprem --provider-id 1
```
```default
There are some parameters that require user input.
  * (oneform_onprem_hosts) Number of instances to create [type: number, default: 1]
    > 1

ID: 1
```

After you have created the provision, list all the existing provisions using the `oneprovision list` command:

```bash
oneprovision list
```
```default
ID USER     GROUP     NAME                  STATE            REGTIME
1  oneadmin oneadmin  On-Prem SSH Cluster   RUNNING          06/05 10:52:29
```

To inspect the details of a specific provision, run the `oneprovision show` command. The output displays information about the generated OpenNebula objects such as hosts, datastores, and networks:

```bash
oneprovision show 1
```
```default
PROVISION 1 INFORMATION
ID                  : 1
NAME                : On-Prem SSH Cluster
DESCRIPTION         : It deploys a SSH cluster on On-Prem
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
oneform_onprem_hosts : 0

OPENNEBULA RESOURCES
CLUSTER
ID                  : 2
NAME                : On-Prem SSH Cluster

HOSTS
ID   NAME            RESOURCE_ID
3    3.74.216.118    i-006a01c592f849031

NETWORKS
ID   TYPE            NAME
6    vxlan           private_onprem_network

DATASTORES
ID   TYPE            NAME
101  system_ds       onprem_system_ds
102  image_ds        onprem_image_ds
```

{{% /tab %}}

{{% tab header="API"%}}

To create a new on-premises Provision using the OneForm API, use the following example request, replacing the appropriate parameters for your Provision:

```bash
curl -X POST "https://oneform.example.server/api/v1/provisions" \
  -u "username:password" \
  -H "Content-Type: application/json" \
  -d '{
    "driver": "onprem",
    "deployment_type": "ssh_cluster",
    "provider_id": 1,
    "user_inputs_values": {
      "oneform_onprem_hosts": 1
    },
    "name": "OnPrem Cluster",
    "description": "Provision in OnPrem"
  }'
```
<br>

For further details about the API, see the [OneForm API Reference]({{% relref "/product/integration_references/system_interfaces/oneform_api.md" %}}).
{{% /tab %}}

{{< /tabpane >}}

Now that you have created an on-premises Cluster, learn how to [manage your provisioned Clusters]({{% relref "/product/cloud_cluster_provisioning/cloud_cluster_operations/provision_operations.md" %}}).