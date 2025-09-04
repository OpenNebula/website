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

{{< alert title="Note" color="success" >}}
More zones can be added modifying the driver configuration. You can learn more about how to modify or expand a driver behaviour in this [Guide](/product/integration_references/edge_provider_driver_development/customizing_driver.md).
{{< /alert >}}

In order to define a Scaleway provider, you need the following information:

* **Credentials**: these are used to interact with the remote provider. You need to provide `access_key`, `secret_key` and `project_id`. You can follow [this guide](https://www.scaleway.com/en/docs/identity-and-access-management/iam/how-to/create-api-keys//) to get this data.
* **Zone**: this is the location in the world where the resources are going to be deployed. All the available [zones are listed here](https://www.scaleway.com/en/docs/console/account/reference-content/products-availability/).
* **Offers and OS**: these define the capacity of the resources that are going to be deployed and the operating system that is going to be installed on them.

{{< alert title="Warning" color="warning" >}}
Please note even though Scaleway support multiple OSs, the automation tools are tailored to works with `Ubuntu 24.04`. If you use another OS, please be aware that it might required some adjustments, and things might not work as expected. Avoid using a different OS in production environment unless you’ve properly tested it before.
{{< /alert >}}

## How to Create an Scaleway Provider

The following process describes how to create a Scaleway provider in your OpenNebula database and make it available for future provisioning operations.

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}

{{% tab header="Sunstone"%}}
Still under development.
{{% /tab %}}

{{% tab header="CLI"%}}

You can now instantiate a provision template by its ID. This will initiate an automated process where OneForm prompts for all required input parameters and starts the deployment:

```default
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

Once the provider has been created, you can review its details using the `oneprovider show <id>` command:

```default
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
