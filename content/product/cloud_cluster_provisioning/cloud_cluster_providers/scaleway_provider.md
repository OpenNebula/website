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

In order to define a Scaleway provider, you need the following information:

* **Credentials**: these are used to interact with the remote provider. You need to provide `access_key`, `secret_key` and `project_id`. You can follow [this guide](https://www.scaleway.com/en/docs/identity-and-access-management/iam/how-to/create-api-keys//) to get this data.
* **Zone**: this is the location in the world where the resources are going to be deployed. All the available [zones are listed here](https://www.scaleway.com/en/docs/console/account/reference-content/products-availability/).
* **Offers and OS**: these define the capacity of the resources that are going to be deployed and the operating system that is going to be installed on them.

{{< alert title="Warning" color="warning" >}}
Please note even though Scaleway support multiple OSs, the automation tools are tailored to works with `Ubuntu 22.04`. If you use another OS, please be aware that it might required some adjustments, and things might not work as expected. Avoid using a different OS in production environment unless you’ve properly tested it before.
{{< /alert >}}

## How to Create an Scaleway Provider

The following process describes how to register the Scaleway provider in your OpenNebula installation and makes it available for future provisioning operations:

{{< alert title="Note" color="success" >}}
The Scaleway driver is included by default with OpenNebula, so no additional setup is required before registration.
{{< /alert >}}

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}
{{% tab header="CLI"%}}

To register the Scaleway driver and create all associated templates, simply use the `oneform register` command:

```default
$ oneform register scaleway
```

Once registered, a provider template will be automatically created and stored in the OpenNebula database. You can verify its existence using the `oneprovider-template list` command:

```default
$ oneprovider-template list
  ID USER       GROUP      NAME                       REGTIME
  0  oneadmin   oneadmin   Scaleway                   06/05 10:02:38
```

This template can now be instantiated using the `oneprovider-template instantiate` command. During instantiation, OneForm will prompt you for the necessary Scaleway credentials and region:

```default
$ oneprovider-template instantiate 0
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

Once the provider has been instantiated, you can review its details using the `oneprovider show <id>` command:

```default
$ oneprovider show 1
PROVIDER 1 INFORMATION
ID                  : 1
NAME                : Scaleway
DESCRIPTION         : Scaleway Bare Metal Provider
USER                : oneadmin
GROUP               : oneadmin
CLOUD PROVIDER      : scaleway
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

{{< tab header="Sunstone">}}
    Still under development.
{{< /tab >}}

{{< /tabpane >}}

{{< alert title="Next steps" color="info" >}}
Congratulations! 👏 If you've completed the previous steps, you've successfully created your Scaleway provider in OpenNebula.
To learn more about the operations you can perform with providers, check out the [Provider Operations Guide]().
{{< /alert >}}

{{< alert title="Note" color="success" >}}
If you're interested in adjusting the driver's behavior, such as adding new user inputs or extending the list of available zones, take a look at the [How to Customize a Provisioning Driver Guide]().
{{< /alert >}}
