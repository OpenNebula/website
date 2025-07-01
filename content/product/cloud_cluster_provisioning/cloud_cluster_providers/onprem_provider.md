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

The following process describes how to register the On-Premises provider in your OpenNebula installation and make it available for future provisioning operations:

{{< alert title="Note" color="success" >}}
The On-Premises driver is included by default with OpenNebula, so no additional setup is required before registration.
{{< /alert >}}

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}
{{% tab header="CLI"%}}

To register the On-Premises driver and create all associated templates, simply use the `oneform register` command:

```default
$ oneform register onprem
```

Once registered, a provider template will be automatically created and stored in the OpenNebula database. You can verify its existence using the `oneprovider-template list` command:

```default
$ oneprovider-template list
  ID USER       GROUP      NAME                       REGTIME
  0  oneadmin   oneadmin   On-Premises                06/05 09:40:21
```

This template can now be instantiated using the `oneprovider-template instantiate` command. Since it does not connect to any external cloud provider, no credentials are required, the provider will be created immediately upon execution.

```default
$ oneprovider-template instantiate 0
ID: 1
```

Once the provider has been instantiated, you can review its details using the `oneprovider show <id>` command:

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

{{< tab header="Sunstone">}}
    Still under development.
{{< /tab >}}

{{< /tabpane >}}

{{< alert title="Next steps" color="info" >}}
Congratulations! 👏 If you've completed the previous steps, you've successfully created your On-Premises provider in OpenNebula.
To learn more about the operations you can perform with providers, check out the [Provider Operations Guide]().
{{< /alert >}}

{{< alert title="Note" color="success" >}}
If you're interested in adjusting the driver's behavior, such as adding new user inputs or extending the list of available zones, take a look at the [How to Customize a Provisioning Driver Guide]().
{{< /alert >}}
