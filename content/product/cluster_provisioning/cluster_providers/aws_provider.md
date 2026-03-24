---
title: "AWS"
date: "2025-02-17"
description:
categories:
pageintoc: "205"
tags:
weight: "2"
toc_hide: true
headless: true
---

<a id="aws-provider"></a>

<!--# Amazon AWS Provider -->

An AWS Provider contains the credentials to interact with AWS and also defines the target region to deploy your Provisions. By default, OpenNebula comes with four pre-defined regions for the AWS Provider:

* Frankfurt (`eu-central-1`)
* London (`eu-west-1`)
* North Virginia (US) (`us-east-1`)
* North California (US) (`us-west-1`)

It is possible to add zones by modifying the driver configuration. Learn more about how to modify or expand a driver behavior in [Adding New Zones]({{% relref "product/integration_references/cloud_provider_driver_development/customizing_driver.md#adding-new-zones" %}}).

To define an AWS Provider, specify the following information:

* **Credentials**: These are used to establish authorization with AWS. You must provide an `access_key` and a `secret_key`. Refer to  the [AWS Authentication Guide](https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html) for details.
* **Region**: This is the world location where the resources are going to be allocated. All available regions are [listed here](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html).
* **Instance Types and AMIs**: These define the capacity of the resources that are going to be deployed and the Amazon Machine Image (AMI) that will be used. The AMI dictates which operating system will be used.

{{< alert title="Warning" color="warning" >}}
You can use customized AMIs in addition to the default AMI provided with your OpenNebula deployment. However, the automation tools are tailored to work with the default AMI.

If you create a custom AMI, your selected configuration might require additional adjustments, and you are likely to encounter unexpected results. Avoid using customized AMIs in production environments to minimize the potential for problems.
{{< /alert >}}

## Creating an AWS Provider

The procedure below describes how to create an AWS Provider in your OpenNebula database and make it available for future provisioning operations.

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

**Step 3.** Select the AWS OneForm driver and click **Next**:

{{< theme-image
  dark="images/oneform/oneprovider/aws/dark/aws_driver.png"
  light="images/oneform/oneprovider/aws/light/aws_driver.png"
  alt="Step 3"
>}}

**Step 4.** In the **General** page a name for the Provider, and then click **Next**:

{{< theme-image
  dark="images/oneform/oneprovider/common/dark/general_step.png"
  light="images/oneform/oneprovider/common/light/general_step.png"
  alt="Step 4"
>}}

**Step 5.** In the **Connection Values** page enter the **Access Key** and **Secret Key**, then click **Finish**:

{{< theme-image
  dark="images/oneform/oneprovider/aws/dark/aws_connection_values.png"
  light="images/oneform/oneprovider/aws/light/aws_connection_values.png"
  alt="Step 5"
>}}

**Step 6.** Finally, in the **Providers** page your AWS Provider will now be visible:

{{< theme-image
  dark="images/oneform/oneprovider/aws/dark/aws_provider.png"
  light="images/oneform/oneprovider/aws/light/aws_provider.png"
  alt="Step 6"
>}}
{{% /tab %}}

{{% tab header="CLI"%}}

Create an AWS Provider using the `oneprovider create <ID>` command, specifying the external cloud Provider ID (`aws` in this case). During instantiation, OneForm will prompt you to enter the required AWS credentials and region.

```bash
oneprovider create aws
```
```default
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

Once you have created the Provider, review its details using the `oneprovider show <ID>` command:

```bash
oneprovider show 1
```
```default
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
To create an AWS Provider using the OneForm API, use the following example request, replacing the appropriate parameters:

```bash
curl -X POST "https://oneform.example.server/api/v1/providers" \
  -u "username:password" \
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

For further details about the API, refer to the [OneForm API Reference](/product/integration_references/system_interfaces/oneform_api.md).
{{% /tab %}}

{{< /tabpane >}}

Now that you have created your AWS Provider, refer to the next guide to [Provision an AWS Edge Cluster]({{% relref "product/cluster_provisioning/cluster_provisions/aws_cluster.md" %}}).
