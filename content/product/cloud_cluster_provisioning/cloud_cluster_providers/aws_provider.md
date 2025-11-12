---
title: "AWS Provider"
date: "2025-02-17"
description:
categories:
pageintoc: "205"
tags:
weight: "2"
---

<a id="aws-provider"></a>

<!--# Amazon AWS Provider -->

An AWS provider contains the credentials to interact with Amazon and also the region to deploy your Provisions. By default, OpenNebula comes with four pre-defined regions for the AWS provider:

* Frankfurt (`eu-central-1`)
* London (`eu-west-1`)
* North Virginia (US) (`us-east-1`)
* North California (US) (`us-west-1`)

{{< alert title="Note" color="success" >}}
More zones can be added modifying the driver configuration. You can learn more about how to modify or expand a driver behaviour in this [Guide](/product/integration_references/edge_provider_driver_development/customizing_driver.md).
{{< /alert >}}

In order to define an AWS provider, you need the following information:

* **Credentials**: these are used to interact with the remote provider. You need to provide `access_key` and `secret_key`. You can follow [this guide](https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html).
* **Region**: this is the location in the world where the resources are going to be allocated. All the available regions are [listed here](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html).
* **Instance types and AMI’s**: these define the capacity of the resources that are going to be deployed and the operating system that is going to be installed on them.

{{< alert title="Warning" color="warning" >}}
Please note even though custom AMIs (i.e other than the default one) can be used, the automation tools are tailored to works with these default ones. If you use a custom AMI, please be aware that it might required some adjustments, and things might not work as expected. Avoid using them in production environment unless you’ve properly tested it before.
{{< /alert >}}

## How to Create an AWS Provider

The following process describes how to create an AWS provider in your OpenNebula database and make it available for future provisioning operations.

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}

{{% tab header="Sunstone"%}}
Still under development.
{{% /tab %}}

{{% tab header="CLI"%}}

You can create an AWS provider using the `oneprovider create <name>` command, specifying the external cloud provider name (`aws` in this case). During instantiation, OneForm will prompt you to enter the required AWS credentials and region.

```bash
$ oneprovider create aws
There are some parameters that require user input.
  * (access_key) AWS Access Key [type: string]
    ***************
  * (secret_key) AWS Secret Key [type: string]
    ************************
  * (region) AWS Region [type: string]
    0: eu-central-1
    1: eu-west-1

    Press enter for default (eu-central-1). Please type the selection number: 0

ID: 1
```

Once the provider has been created, you can review its details using the `oneprovider show <id>` command:

```bash
$ oneprovider show 1
PROVIDER 1 INFORMATION
ID                  : 1
NAME                : AWS
DESCRIPTION         : Amazon Web Services
USER                : oneadmin
GROUP               : oneadmin
DRIVER              : aws
VERSION             : 1.0.0
REGISTRATION TIME   : 06/05 09:00:30

PERMISSIONS
OWNER               : um-
GROUP               : ---
OTHER               : ---

CONNECTION VALUES
access_key          : ***************
secret_key          : ************************
region              : eu-central-1

ASSOCIATED PROVISIONS
IDS:                : --
```

{{% /tab %}}

{{% tab header="API"%}}

```bash
curl -X POST "https://oneform.example.server/api/v1/providers" \
  -H "Content-Type: application/json" \
  -d '{
    "driver": "aws",
    "connection_values": {
      "region": "us-east-1",
      "access_key": "YOUR_AWS_ACCESS_KEY",
      "secret_key": "YOUR_AWS_SECRET_KEY"
    },
    "name": "My AWS Provider",
    "description": "Provider for AWS infrastructure in us-east-1"
  }'
```

For further details about the API, please refer to the [OneForm API Reference Guide](/product/integration_references/system_interfaces/oneform_api.md).
{{% /tab %}}

{{< /tabpane >}}
