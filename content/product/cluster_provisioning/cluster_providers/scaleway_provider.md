---
title: "Scaleway"
date: "2025-02-17"
description:
categories:
pageintoc: "207"
tags:
weight: "4"
toc_hide: true
headless: true
---

<a id="scaleway-provider"></a>

<!--# Scaleway Provider -->

A Scaleway Provider defines the credentials to authorize interaction with the [Scaleway Cloud Service](https://www.scaleway.com/) and also the target location to deploy Provisions. By default, OpenNebula comes with three pre-defined Scaleway Providers in the following regions:

* France - Paris (PAR-1)
* Netherlands - Amsterdam (NL-AMS-1 )
* Poland - Warsaw (PL-WAW-3)

It is possible to add zones by modifying the driver configuration. Learn more about customizing the driver's behavior to [Add New Zones]({{% relref "/product/integration_references/cloud_provider_driver_development/customizing_driver/#adding-new-zones" %}}).

To define a Scaleway Provider, specify the following information:

* **Credentials**: Used to interact with the remote Provider. The `access_key`, `secret_key` and `project_id` are required. Create or retrieve the required keys through the [Scaleway API](https://www.scaleway.com/en/docs/identity-and-access-management/iam/how-to/create-api-keys//).
* **Zone**: The world location where the resources will be deployed. All available zones are [listed here](https://www.scaleway.com/en/docs/console/account/reference-content/products-availability/).
* **Offers and OS**: Defines the capacity of the resources that will be deployed and the operating system to be installed on them.

{{< alert title="Warning" type="warning" >}}
Scaleway supports multiple OSs. However, the automation tools are tailored to work with *Ubuntu 24.04*.

If you choose an alternative OS, your selected configuration might require additional adjustments and you will likely observe some unexpected results. Avoid using an OS other than *Ubuntu 24.04* in production environments, unless you have thoroughly tested it.
{{< /alert >}}


## Creating a Scaleway Provider

The following process describes how to create a Scaleway Provider in your OpenNebula database and make it available for future provisioning operations.

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}

{{% tab header="Sunstone"%}}
**Step 1.** Navigate to **Infrastructure -> Providers** in the Sunstone sidebar:

{{< image
  pathDark="images/oneform/oneprovider/common/dark/sunstone_navigation.png"
  path="images/oneform/oneprovider/common/light/sunstone_navigation.png"
  alt="Step 1"
>}}

**Step 2.** Click **Create**:

{{< image
  pathDark="images/oneform/oneprovider/common/dark/create_provider_button.png"
  path="images/oneform/oneprovider/common/light/create_provider_button.png"
  alt="Step 2"
>}}

**Step 3.** Select the Scaleway OneForm driver and click **Next**:

{{< image
  pathDark="images/oneform/oneprovider/scaleway/dark/scaleway_driver.png"
  path="images/oneform/oneprovider/scaleway/light/scaleway_driver.png"
  alt="Step 3"
>}}

**Step 4.** In the **General** page enter a name for the Provider, and then click **Next**:

{{< image
  pathDark="images/oneform/oneprovider/common/dark/general_step.png"
  path="images/oneform/oneprovider/common/light/general_step.png"
  alt="Step 4"
>}}

**Step 5.** In the **Connection Values** page, enter the **Access Key**, **Secret Key** and **Project ID** and click **Finish**:
{{< image
  pathDark="images/oneform/oneprovider/scaleway/dark/scaleway_connection_values.png"
  path="images/oneform/oneprovider/scaleway/light/scaleway_connection_values.png"
  alt="Step 5"
>}}

**Step 6.** Finally, your Scaleway Provider will appear in the **Providers** view:

{{< image
  pathDark="images/oneform/oneprovider/scaleway/dark/scaleway_provider.png"
  path="images/oneform/oneprovider/scaleway/light/scaleway_provider.png"
  alt="Step 6"
>}}

{{% /tab %}}

{{% tab header="CLI"%}}

Instantiate a provision template by its ID. This step initiates an automated process in which OneForm prompts for all required input parameters and starts the deployment:

```bash
oneprovider create scaleway
```
```default
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

Once you have created the Provider, review its details using the `oneprovider show <ID>` command:

```bash
oneprovider show 1
```
```default
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
To create a Scaleway Provider using the OneForm API, use the following example request, replacing the appropriate parameters:
```bash
curl -X POST "https://oneform.example.server/api/v1/providers" \
  -u "username:password" \
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
<br>

For further details about the API, please see the [OneForm API Reference]({{% relref "/product/integration_references/system_interfaces/oneform_api.md" %}}).
{{% /tab %}}

{{< /tabpane >}}

Now that you have created your Scaleway Provider, refer to the next guide to [Provision a Scaleway Edge Cluster](https://github.com/OpenNebula/oneform-registry/wiki/Scaleway-Cluster).


