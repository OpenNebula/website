---
title: "On-premises Cluster"
date: "2025-02-17"
description:
categories:
pageintoc: "211"
tags:
weight: "2"
---

<!--# On-premises Cluster -->

An on-premises cluster utilizes existing physical or virtual servers as OpenNebula Hosts, integrating with and configuring said infrastructure. This cluster deployment operates using KVM hypervisors.

## On-premises Cluster Implementation

Users must manually provide reachable IP addresses for the hosts, ensuring that SSH connectivity and system prerequisites are met. The default OS is *Ubuntu 22.04*. The networking model is implemented as follows:

- **Public Networking**: requires manually provided IP addresses or previously configured public IPs. IP forwarding rules must be manually managed.
- **Private Networking**: uses BGP-EVPN and VXLAN to create private virtual networks among provided hosts.

## OpenNebula Resources

The following resources, which are associated with each on-premises cluster, are created in OpenNebula:

1. Cluster: aggregating all other resources
2. Hosts: corresponding to provided IP addresses
3. Datastores: image and system datastores configured with an SSH transfer manager, utilizing the first provided host as the datastore replica
4. Virtual network: for public networking. This resource is configured manually.
5. Virtual network template: for private networking

## Creating an On-premises Provision

### Prerequisites
To create an on-premises provision, you must have an [On-Prem provider](/product/cloud_cluster_provisioning/cloud_cluster_providers/onprem_provider/) already created.

### Procedure

Select the relevant interface to create an on-prem provision in your OpenNebula installation:

#### NFS On-premises Cluster

{{< tabpane text=true right=false id="nfs-cluster" >}}

{{% tab header="**Interfaces**:" disabled=true /%}}

{{% tab header="Sunstone<span style='display:none'>-nfs</span>"%}}
**Step 1.** Navigate through `Infrastructure > Clusters` in the sidebar:

{{< theme-image
  dark="images/oneform/oneprovision/common/dark/sunstone_navigation.png"
  light="images/oneform/oneprovision/common/light/sunstone_navigation.png"
  alt="Step 1"
>}}

**Step 2.** Click on the `Create` button and select the option `Install a new On-Premise Cluster`:

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


**Step 3.** Fill the general section with at least a name for the cluster and click on `Next` button:

{{< theme-image
  dark="images/oneform/oneprovision/common/dark/onprem_general_step.png"
  light="images/oneform/oneprovision/common/light/onprem_general_step.png"
  alt="Step 3"
>}}

{{% /tab %}}

{{% tab header="CLI<span style='display:none'>-nfs</span>"%}}

### Listing templates

Create an on-prem provision with the `oneprovider create <name> --provider-id <id>` command, specifying `onprem` as the provider type and the ID of the associated provider to this provision. This will initiate an automated process where OneForm prompts for all required input parameters and starts the deployment:


```bash
$ oneprovision create onprem --provider-id 1
There are some parameters that require user input.
  * (oneform_onprem_hosts) Number of instances to create [type: number, default: 1]
    > 1

ID: 1
```

After you have created the provision, list all the existing provisions using the `oneprovision list` command:

```bash
$ oneprovision list
  ID USER     GROUP     NAME                  STATE            REGTIME
  1  oneadmin oneadmin  On-Prem SSH Cluster   RUNNING          06/05 10:52:29
```

To inspect the details of a specific provision, run the `oneprovision show` command. The output displays information about the generated OpenNebula objects such as hosts, datastores, and networks:

```bash
$ oneprovision show 1
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

{{% tab header="API<span style='display:none'>-nfs</span>"%}}

```bash
curl -X POST "https://oneform.example.server/api/v1/provisions" \
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

For further details about the API, refer to the [OneForm API Reference Guide](/product/integration_references/system_interfaces/oneform_api.md).
{{% /tab %}}

{{< /tabpane >}}


#### SSH On-premises Cluster

{{< tabpane text=true right=false id="ssh-cluster" >}}

{{% tab header="**Interfaces**:" disabled=true /%}}

{{% tab header="Sunstone<span style='display:none'>-ssh</span>"%}}
**Step 1.** Navigate through `Infrastructure > Clusters` in the sidebar:

{{< theme-image
  dark="images/oneform/oneprovision/common/dark/sunstone_navigation.png"
  light="images/oneform/oneprovision/common/light/sunstone_navigation.png"
  alt="Step 1"
>}}

**Step 2.** Click on the `Create` button and select the option `Install a new On-Premise Cluster`:

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


**Step 3.** Fill the general section with at least a name for the cluster and click on `Next` button:

{{< theme-image
  dark="images/oneform/oneprovision/common/dark/onprem_general_step.png"
  light="images/oneform/oneprovision/common/light/onprem_general_step.png"
  alt="Step 3"
>}}{{% /tab %}}

{{% tab header="CLI<span style='display:none'>-ssh</span>"%}}
Still under development.
{{% /tab %}}

{{% tab header="API<span style='display:none'>-ssh</span>"%}}
Still under development.
{{% /tab %}}

{{< /tabpane >}}