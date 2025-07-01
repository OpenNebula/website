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

An AWS provider contains the credentials to interact with Amazon and also the region to deploy your Provisions. By default, OpenNebula comes with four pre-defined AWS providers in the following regions:

* Frankfurt
* London
* North Virginia (US)
* North California (US)

{{< alert title="Note" color="success" >}}
More zones can be added modifying the provider configuration. You can learn more about how to modify or expand a provider behaviour in this [Guide]().
{{< /alert >}}

In order to define an AWS provider, you need the following information:

* **Credentials**: these are used to interact with the remote provider. You need to provide `access_key` and `secret_key`. You can follow [this guide](https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html).
* **Region**: this is the location in the world where the resources are going to be allocated. All the available regions are [listed here](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html).
* **Instance types and AMI’s**: these define the capacity of the resources that are going to be deployed and the operating system that is going to be installed on them.

{{< alert title="Warning" color="warning" >}}
Please note even though custom AMIs (i.e other than the default one) can be used, the automation tools are tailored to works with these default ones. If you use a custom AMI, please be aware that it might required some adjustments, and things might not work as expected. Avoid using them in production environment unless you’ve properly tested it before.
{{< /alert >}}

## How to Create an AWS Provider

The following process describes how to register the AWS provider in your OpenNebula installation and makes it available for future provisioning operations:

{{< alert title="Note" color="success" >}}
The AWS driver is included by default with OpenNebula, so no additional setup is required before registration.
{{< /alert >}}

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}
{{% tab header="CLI"%}}

To register the AWS driver and create all associated templates, simply use the `oneform register` command:

```default
$ oneform register aws
```

Once registered, a provider template will be automatically created and stored in the OpenNebula database. You can verify its existence using the `oneprovider-template list` command:

```default
$ oneprovider-template list
  ID USER       GROUP      NAME                       REGTIME
  0  oneadmin   oneadmin   AWS                        06/05 07:36:43
```

This template can now be instantiated using the `oneprovider-template instantiate` command. During instantiation, OneForm will prompt you for the necessary AWS credentials and region:

```default
$ oneprovider-template instantiate 0
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

Once the provider has been instantiated, you can review its details using the `oneprovider show <id>` command:

```default
$ oneprovider show 1
PROVIDER 1 INFORMATION
ID                  : 1
NAME                : AWS
DESCRIPTION         : Amazon Web Services
USER                : oneadmin
GROUP               : oneadmin
CLOUD PROVIDER      : aws
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

{{< tab header="Sunstone">}}
    Still under development.
{{< /tab >}}

{{< /tabpane >}}

{{< alert title="Next steps" color="info" >}}
Congratulations! 👏 If you've completed the previous steps, you've successfully created your AWS provider in OpenNebula.
To learn more about the operations you can perform with providers, check out the [Provider Operations Guide]().
{{< /alert >}}

{{< alert title="Note" color="success" >}}
If you're interested in adjusting the driver's behavior, such as adding new user inputs or extending the list of available zones, take a look at the [How to Customize a Provisioning Driver Guide]().
{{< /alert >}}


{{< alert title="Note" color="success" >}}
The AWS driver is included by default with OpenNebula, so no additional setup is required before registration.
{{< /alert >}}
