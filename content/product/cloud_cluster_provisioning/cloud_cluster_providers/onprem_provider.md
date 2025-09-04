---
title: "On-Premises Provider"
date: "2025-06-02"
description: "Add and configure on premises resources"
categories:
pageintoc: "205"
tags:
weight: "2"
---

<a id="onprem-provider"></a>

<!--# OnPrem Provider -->

The On-Premises provider defines how OneForm interacts with existing on-premise infrastructure. Unlike cloud-based providers, it does not require credentials to connect to external platforms. Instead, it manages already deployed physical or virtual machines using IP addresses provided at instantiation time.

This provider is ideal for environments where you want to integrate OneForm with infrastructure you already control—such as bare-metal servers, KVM hosts, or virtual machines in your private datacenter.

## How to Create an On-Premises Provider

The following process describes how to create an on-premises provider in your OpenNebula database and make it available for future provisioning operations.

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}

{{% tab header="Sunstone"%}}
Still under development.
{{% /tab %}}

{{% tab header="CLI"%}}
You can create an on-premises provider using the `oneprovider create <name>` command, specifying `onprem` as the provider type. As the on-premises provider does not require access credentials, the provider will be created directly.

```default
$ oneprovider create onprem
ID: 1
```

Once the provider has been created, you can review its details using the `oneprovider show <id>` command:

```default
$ oneprovider show 1
PROVIDER 1 INFORMATION
ID                  : 1
NAME                : On-Premises
DESCRIPTION         : On-Premises Cluster
USER                : oneadmin
GROUP               : oneadmin
CLOUD PROVIDER      : onprem
VERSION             : 1.0.0
REGISTRATION TIME   : 06/05 09:42:19

PERMISSIONS
OWNER               : um-
GROUP               : ---
OTHER               : ---

ASSOCIATED PROVISIONS
IDS:                : --
```

{{% /tab %}}

{{% tab header="API"%}}

```bash
curl -X POST "https://oneform.example.server/api/v1/providers" \
  -H "Content-Type: application/json" \
  -d '{
    "driver": "onprem",
    "connection_values": {},
    "name": "My OnPrem Provider",
    "description": "Provider for Onprem infrastructure"
  }'
```

For further details about the API, please refer to the [OneForm API Reference Guide](/product/integration_references/system_interfaces/oneform_api.md).
{{% /tab %}}
{{< /tabpane >}}
