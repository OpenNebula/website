---
title: "Equinix Provider"
date: "2025-02-17"
description:
categories:
pageintoc: "206"
tags:
weight: "3"
---

<a id="equinix-provider"></a>

<!--# Equinix Provider -->

An Equinix provider contains the credentials to interact with Equinix and also the location to deploy your Provisions. By default, OpenNebula comes with four pre-defined providers in the following Equinix Metal Metros:

* Amsterdam
* Parsippany (NJ, US)
* Tokyo
* California (US)

It is possible to add metros by modifying the driver configuration. Learn more about how to modify or expand a driver behaviour in [Adding New Zones](/product/integration_references/cloud_provider_driver_development/customizing_driver/#adding-new-zones).

To define an Equinix provider, specify the following information:

* **Credentials**: these are used to interact with the remote provider. You need to provide `token` and `project`. To retrieve the required data, follow the [Equinix API](https://docs.equinix.com/equinix-api/) guide.
* **Facility**: this is the location in the world where the resources are going to be deployed. All the available [facilities are listed here](https://www.equinix.com/data-centers/).
* **Plans and OS**: these define the capacity of the resources that are going to be deployed and the operating system that is going to be installed on them.

{{< alert title="Warning" color="warning" >}}
Equinix supports multiple OSs. However, the automation tools are tailored to work with *Ubuntu 24.04*.

If you choose a different OS, your selected configuration might require additional adjustments and you will likely observe some unexpected results. Avoid using a different OS than *Ubuntu 24.04* in production environments,  unless you have properly tested it before.
{{< /alert >}}

## Creating an Equinix Provider

The procedure below describes how to create an Equinix provider in your OpenNebula database, and make it available for future provisioning operations.

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}

{{% tab header="Sunstone"%}}
**Step 1.** Navigate through `Infrastructure > Providers` in the sidebar:

{{< theme-image
  dark="images/oneform/oneprovider/common/dark/sunstone_navigation.png"
  light="images/oneform/oneprovider/common/light/sunstone_navigation.png"
  alt="Step 1"
>}}

**Step 2.** Click on the `Create` button:

{{< theme-image
  dark="images/oneform/oneprovider/common/dark/create_provider_button.png"
  light="images/oneform/oneprovider/common/light/create_provider_button.png"
  alt="Step 2"
>}}

**Step 3.** Select the Equinix oneform driver and click on `Next` button:

{{< theme-image
  dark="images/oneform/oneprovider/equinix/dark/equinix_driver.png"
  light="images/oneform/oneprovider/equinix/light/equinix_driver.png"
  alt="Step 3"
>}}

**Step 4.** Fill the general section with at least a name for the provider, and then click on `Next` button:

{{< theme-image
  dark="images/oneform/oneprovider/common/dark/general_step.png"
  light="images/oneform/oneprovider/common/light/general_step.png"
  alt="Step 4"
>}}

**Step 5.** Fill the Connection Values Section and click on `Finish` button:
{{< theme-image
  dark="images/oneform/oneprovider/equinix/dark/equinix_connection_values.png"
  light="images/oneform/oneprovider/equinix/light/equinix_connection_values.png"
  alt="Step 5"
>}}

**Step 6.** Finally, you can see your already Equinix provider:

{{< theme-image
  dark="images/oneform/oneprovider/equinix/dark/equinix_provider.png"
  light="images/oneform/oneprovider/equinix/light/equinix_provider.png"
  alt="Step 6"
>}}
{{% /tab %}}

{{% tab header="CLI"%}}

Create an Equinix provider using the `oneprovider create <name>` command, and specifying `equinix` as the external cloud provider. During instantiation, OneForm will prompt you to enter the required Equinix credentials and region.

```bash
$ oneprovider create equinix
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

Once you have created the provider, review its details using the `oneprovider show <id>` command:

```bash
$ oneprovider show 1
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

```bash
curl -X POST "https://oneform.example.server/api/v1/providers" \
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

For further details about the API, please refer to the [OneForm API Reference Guide](/product/integration_references/system_interfaces/oneform_api.md).
{{% /tab %}}

{{< /tabpane >}}

## Known Issues

### Insufficient Capacity on Equinix Metal

When there is not enough hardware available at a Equinix Metal facility for a given machine type, you will see the following error message:

```default
The facility ams1 has no provisionable c3.small.x86 servers matching your criteria
```

To solve this issue, either select a different node type or Equinix Metal provider. You can check the current capacity status on the Equinix Metal API.
