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

An Equinix provider contains the credentials to interact with Equinix and also the location to deploy your Provisions. By default, OpenNebula comes with four pre-defined providers in the following regions:

* Amsterdam
* Parsippany (NJ, US)
* Tokyo
* California (US)

{{< alert title="Note" color="success" >}}
More zones can be added modifying the provider configuration. You can learn more about how to modify or expand a provider behaviour in this [Guide](/product/integration_references/edge_provider_driver_development/customizing_driver.md).
{{< /alert >}}

In order to define an Equinix provider, you need the following information:

* **Credentials**: these are used to interact with the remote provider. You need to provide `token` and `project`. You can follow [this guide](https://metal.equinix.com/developers/api/) to get this data.
* **Facility**: this is the location in the world where the resources are going to be deployed. All the available [facilities are listed here](https://www.equinix.com/data-centers/).
* **Plans and OS**: these define the capacity of the resources that are going to be deployed and the operating system that is going to be installed on them.

{{< alert title="Warning" color="warning" >}}
Please note even though Equinix support multiple OSs, the automation tools are tailored to works with `Ubuntu 24.04`. If you use another OS, please be aware that it might required some adjustments, and things might not work as expected. Avoid using a different OS in production environment unless you’ve properly tested it before.
{{< /alert >}}

## How to Create an Equinix Provider

The following process describes how to create an Equinix provider in your OpenNebula database and make it available for future provisioning operations.

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}

{{% tab header="Sunstone"%}}
Still under development.
{{% /tab %}}

{{% tab header="CLI"%}}

You can create an Equinix provider using the `oneprovider create <name>` command, specifying the external cloud provider name (`equinix` in this case). During instantiation, OneForm will prompt you to enter the required Equinix credentials and region.

```default
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

Once the provider has been created, you can review its details using the `oneprovider show <id>` command:

```default
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

### Insufficient capacity on Equinix Metal

Sometimes there may not be enough hardware available at a given Equinix Metal facility for a given machine type, in which case the following error is shown:

```default
The facility ams1 has no provisionable c3.small.x86 servers matching your criteria
```

In this case, either select a different node type or Equinix Metal provider. You can check the current capacity status on the Equinix Metal API.
