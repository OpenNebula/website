---
title: "Equinix"
date: "2025-02-17"
description:
categories:
pageintoc: "206"
tags:
weight: "3"
toc_hide: true
headless: true
---

<a id="equinix-provider"></a>

<!--# Equinix Provider -->

An Equinix Provider contains the credentials to interact with [Equinix](https://www.equinix.com/) hardware resources and also defines the location to deploy your Provisions. By default, OpenNebula comes with four pre-defined Providers in the following regions:

* Amsterdam (Netherlands)
* Parsippany (NJ, US)
* Tokyo (Japan)
* California (US)

It is possible to add zones by modifying the driver configuration. Learn more about customizing the driver's behavior to [Add New Zones]({{% relref "/product/integration_references/cloud_provider_driver_development/customizing_driver/#adding-new-zones" %}}).

To define a new Equinix Provider, specify the following information:

* **Credentials**: Authorizes interaction with the remote Provider. You need to provide the `token` and `project` objects derived through the [Equinix API](https://docs.equinix.com/equinix-api/).
* **Facility**: This defines the world location where the resources will be deployed. Check the available [Equinix facilities](https://www.equinix.com/data-centers/).
* **Plans and OS**: Defines the capacity of the resources that will be deployed and the operating system installed on them.

{{< alert title="Warning" color="warning" >}}
Equinix supports multiple OSs. However, the automation tools are tailored to work with *Ubuntu 24.04*.

If you choose an alternative OS, your selected configuration might require additional adjustments and you will likely observe some unexpected results. Avoid using an OS other than *Ubuntu 24.04* in production environments, unless you have thoroughly tested it.
{{< /alert >}}

## Creating an Equinix Provider

The procedure below describes how to create an Equinix Provider in your OpenNebula database and make it available for future provisioning operations.

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}

{{% tab header="Sunstone"%}}
**Step 1.** Navigate to **Infrastructure -> Providers** in the Sunstone sidebar:

{{< theme-image
  dark="images/oneform/oneprovider/common/dark/sunstone_navigation.png"
  light="images/oneform/oneprovider/common/light/sunstone_navigation.png"
  alt="Step 1"
>}}

**Step 2.** Click **Create**:

{{< theme-image
  dark="images/oneform/oneprovider/common/dark/create_provider_button.png"
  light="images/oneform/oneprovider/common/light/create_provider_button.png"
  alt="Step 2"
>}}

**Step 3.** Select the Equinix OneForm driver and click **Next**:

{{< theme-image
  dark="images/oneform/oneprovider/equinix/dark/equinix_driver.png"
  light="images/oneform/oneprovider/equinix/light/equinix_driver.png"
  alt="Step 3"
>}}

**Step 4.** In the **General** page enter a name for the Provider, then click **Next**:

{{< theme-image
  dark="images/oneform/oneprovider/common/dark/general_step.png"
  light="images/oneform/oneprovider/common/light/general_step.png"
  alt="Step 4"
>}}

**Step 5.** In the **Connection Values** page enter the **Auth Token** and **Project ID** then click **Finish**:
{{< theme-image
  dark="images/oneform/oneprovider/equinix/dark/equinix_connection_values.png"
  light="images/oneform/oneprovider/equinix/light/equinix_connection_values.png"
  alt="Step 5"
>}}

**Step 6.** Finally, your Equinix Provider will appear in the **Providers** view:

{{< theme-image
  dark="images/oneform/oneprovider/equinix/dark/equinix_provider.png"
  light="images/oneform/oneprovider/equinix/light/equinix_provider.png"
  alt="Step 6"
>}}
{{% /tab %}}

{{% tab header="CLI"%}}

Create an Equinix Provider using the `oneprovider create <ID>` command, and specifying `equinix` as the external cloud provider ID. During instantiation, OneForm will prompt you to enter the required Equinix credentials and region.

```bash
oneprovider create equinix
```
```default
There are some parameters that require user input.
  * (auth_token) Equinix Auth Token [type: string]
    *************************
  * (project_id) Equinix Project ID [type: string]
    ***************
  * (region) Equinix Region [type: string]
    0: am
    1: ty
    2: sv
    4: ny

    Press enter for default (am). Please type the selection number: 0

ID: 1
```

Once you have created the Provider, review its details using the `oneprovider show <id>` command:

```bash
oneprovider show 1
```
```default
PROVIDER 1 INFORMATION
ID                  : 1
NAME                : Equinix
DESCRIPTION         : Equinix Metal Cloud
USER                : oneadmin
GROUP               : oneadmin
DRIVER              : equinix
VERSION             : 1.0.0
REGISTRATION TIME   : 06/05 09:00:00

PERMISSIONS
OWNER               : um-
GROUP               : ---
OTHER               : ---

CONNECTION VALUES
auth_token          : *************************
project_id          : ***************
region              : am

ASSOCIATED PROVISIONS
IDS:                : --
```

{{% /tab %}}

{{% tab header="API"%}}
To create an Equinix Provider using the OneForm API, use the following example request, replacing the appropriate parameters:
```bash
curl -X POST "https://oneform.example.server/api/v1/providers" \
  -u "username:password" \
  -H "Content-Type: application/json" \
  -d '{
    "driver": "equinix",
    "connection_values": {
      "region": "am",
      "auth_token": "YOUR_EQUINIX_AUTH_TOKEN",
      "project_id": "YOUR_EQUINIX_PROJECT_ID"
    },
    "name": "My Equinix Provider",
    "description": "Provider for Equinix infrastructure in Amsterdam"
  }'
```
<br>

For further details about the API, please see to the [OneForm API Reference]({{% relref "product/integration_references/system_interfaces/oneform_api.md" %}}).
{{% /tab %}}

{{< /tabpane >}}

Now that you have created your Equinix Provider, refer to the next guide to [Provision an Equinix Edge Cluster]({{% relref "product/cluster_provisioning/cluster_provisions/equinix_cluster.md" %}}).

## Known Issues

### Insufficient Capacity on Equinix Metal

When there is not enough hardware available at a selected Equinix Metal facility for a given machine type, you will receive the following error message:

```default
The facility ams1 has no provisionable c3.small.x86 servers matching your criteria
```

To resolve this issue, either select a different node type or Equinix Metal Provider. You can check the current capacity status using the [Equinix Metal API](https://docs.equinix.com/api-catalog/metalv1/).
