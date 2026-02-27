---
title: "Scaleway Provider"
date: "2025-02-17"
description:
categories:
pageintoc: "207"
tags:
weight: "4"
---

<a id="scaleway-provider"></a>

<!--# Scaleway Provider -->

A Scaleway provider contains the credentials to interact with Scaleway and also the location to deploy your Provisions. By default, OpenNebula comes with three pre-defined providers in the following regions:

* France - Paris (PAR-1)
* Netherlands - Amsterdam (NL-AMS-1 )
* Poland - Warsaw (PL-WAW-3)

It is possible to add zones by modifying the driver configuration. Learn more about how to modify or expand a driver behaviour in [Adding New Zones](/product/integration_references/cloud_provider_driver_development/customizing_driver/#adding-new-zones).


To define a Scaleway provider, specify the following information:

* **Credentials**: these are used to interact with the remote provider. Provide `access_key`, `secret_key` and `project_id`. To retrieve the required details, follow this guide on [How to create API Keys](https://www.scaleway.com/en/docs/identity-and-access-management/iam/how-to/create-api-keys//) from Scaleway.
* **Zone**: this is the location in the world where the resources are going to be deployed. All the available [zones are listed here](https://www.scaleway.com/en/docs/console/account/reference-content/products-availability/).
* **Offers and OS**: these define the capacity of the resources that are going to be deployed and the operating system that is going to be installed on them.

{{< alert title="Warning" color="warning" >}}
Scaleway supports multiple OSs. However, the automation tools are tailored to work with *Ubuntu 24.04*.

If you choose a different OS, your selected configuration might require additional adjustments and you will likely observe some unexpected results. Avoid using a different OS than *Ubuntu 24.04* in production environments, unless you have properly tested it before.
{{< /alert >}}


## Creating an Scaleway Provider

The following process describes how to create a Scaleway provider in your OpenNebula database and make it available for future provisioning operations.

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

**Step 3.** Select the Scaleway oneform driver and click on `Next` button:

{{< theme-image
  dark="images/oneform/oneprovider/scaleway/dark/scaleway_driver.png"
  light="images/oneform/oneprovider/scaleway/light/scaleway_driver.png"
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
  dark="images/oneform/oneprovider/scaleway/dark/scaleway_connection_values.png"
  light="images/oneform/oneprovider/scaleway/light/scaleway_connection_values.png"
  alt="Step 5"
>}}

**Step 6.** Finally, you can see your already Scaleway provider:

{{< theme-image
  dark="images/oneform/oneprovider/scaleway/dark/scaleway_provider.png"
  light="images/oneform/oneprovider/scaleway/light/scaleway_provider.png"
  alt="Step 6"
>}}

{{% /tab %}}

{{% tab header="CLI"%}}

Instantiate a provision template by its ID. This step initiates an automated process where OneForm prompts for all required input parameters and starts the deployment:

```bash
$ oneprovider create scaleway
There are some parameters that require user input.
  * (access_key) Scaleway Access Key [type: string]
    ***************
  * (secret_key) Scaleway Secret Key [type: string]
    ************************
  * (project_id) Scaleway Project ID [type: string]
    *******************
  * (region) Scaleway Region [type: string]
    0: fr-par
    1: nl-ams
    2: pl-waw

    Press enter for default (fr-par). Please type the selection number: 0
  * (zone) Scaleway Zone [type: string]
    0: fr-par-1
    1: fr-par-2
    2: fr-par-3

    Press enter for default (fr-par-1). Please type the selection number: 2

ID: 1
```

Once you have created the provider, review its details using the `oneprovider show <id>` command:

```bash
$ oneprovider show 1
PROVIDER 1 INFORMATION
ID                  : 1
NAME                : Scaleway
DESCRIPTION         : Scaleway Bare Metal Provider
USER                : oneadmin
GROUP               : oneadmin
DRIVER              : scaleway
VERSION             : 1.0.0
REGISTRATION TIME   : 06/05 10:09:44

PERMISSIONS
OWNER               : um-
GROUP               : ---
OTHER               : ---

CONNECTION VALUES
access_key          : ***************
secret_key          : ************************
project_id          : *****************
region              : fr-par
zone                : fr-par-2

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
      "region": "fr-par",
      "zone": "fr-par-2",
      "access_key": "YOUR_SCALEWAY_AUTH_TOKEN",
      "secret_key": "YOUR_SCALEWAY_SECRET_KEY",
      "project_id": "YOUR_SCALEWAY_PROJECT_ID"
    },
    "name": "My Scaleway Provider",
    "description": "Provider for Scaleway infrastructure in Paris"
  }'
```

For further details about the API, please refer to the [OneForm API Reference Guide](/product/integration_references/system_interfaces/oneform_api.md).
{{% /tab %}}

{{< /tabpane >}}
