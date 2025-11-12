---
title: "On-Premises Cluster"
date: "2025-02-17"
description:
categories:
pageintoc: "211"
tags:
weight: "2"
---

<!--# On-Premises Cluster -->

## Cluster Types

The **On-Premises** clusters utilize existing physical or virtual servers as OpenNebula Hosts. These clusters can operate using KVM hypervisors.

## On-Premises Cluster Implementation

A cluster in an On-Premises setup does not provision new hardware or cloud resources. Instead, it integrates and configures existing infrastructure. Users must manually provide reachable IP addresses for the hosts, ensuring that SSH connectivity and system prerequisites are met (default OS: Ubuntu 22.04).

The networking model is implemented in the following way:

- **Public Networking**: Requires manually provided IP addresses or previously configured public IPs. IP forwarding rules must be manually managed.
- **Private Networking**: Implemented using BGP-EVPN and VXLAN to create private virtual networks between provided hosts.

## OpenNebula resources

The following resources, associated with each On-Premises Cluster, will be created in OpenNebula:

1. Cluster - aggregating all other resources
2. Hosts - corresponding to provided IP addresses
3. Datastores - image and system datastores configured with an SSH transfer manager, utilizing the first provided host as the datastore replica
4. Virtual network - for public networking (configured manually)
5. Virtual network template - for private networking

## How to Create An On-Prem Provision

The following process describes how to create an On-Prem provision in your OpenNebula installation:

{{< alert title="Note" color="success" >}}
To create a provision in On-Prem, first [you must have an On-Prem provider already created]().
{{< /alert >}}

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}

{{% tab header="Sunstone"%}}
Still under development.
{{% /tab %}}

{{% tab header="CLI"%}}

### Listing templates

You can create an on-premises provision using the `oneprovider create <name> --provider-id <id>` command, specifying `onprem` as the provider type and the ID of the associated provider to this provision. This will initiate an automated process where OneForm prompts for all required input parameters and starts the deployment:


```default
$ oneprovision create onprem --provider-id 1
There are some parameters that require user input.
  * (oneform_onprem_hosts) Number of instances to create [type: number, default: 1]
    > 1

ID: 1
```

After the provision is created, you can see a list with all your provisions using the `oneprovision list` command:

```default
$ oneprovision list
  ID USER     GROUP     NAME                  STATE            REGTIME
  1  oneadmin oneadmin  On-Prem SSH Cluster   RUNNING          06/05 10:52:29
```

To inspect the full details of a specific provision, including the generated OpenNebula objects such as hosts, datastores, and networks, run the `oneprovision show` command:

```default
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

{{% tab header="API"%}}

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

For further details about the API, please refer to the [OneForm API Reference Guide](/product/integration_references/system_interfaces/oneform_api.md).
{{% /tab %}}

{{< /tabpane >}}
