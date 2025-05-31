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

An AWS Provider contains the credentials to interact with Amazon and also the region to deploy your Provisions. OpenNebula comes with four pre-defined AWS Providers in the following regions:

* Frankfurt
* London
* North Virginia (US)
* North California (US)

In order to define an AWS Provider you need the following information:

* **Credentials**: these are used to interact with the remote Provider. You need to provide `access_key` and `secret_key`. To do this you can follow [this guide](https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html).
* **Region**: this is the location in the world where the resources are going to be allocated. All the available regions are [listed here](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html).
* **Instance types and AMIs**: these define the capacity of the resources that are going to be deployed and the operating system that is going to be installed on them.

{{< alert title="Warning" color="warning" >}}
Please note even though custom AMIs (i.e., other than the default one) can be used, the automation tools are tailored to work with these default ones. If you use a custom AMI, please be aware that it might require some adjustments and things might not work as expected. Avoid using them in production environments unless you’ve properly tested it before.{{< /alert >}} 

## How to Create an AWS Provider

To add a new Provider you need a YAML template file with the following information:

```default
$ cat provider.yaml
name: 'aws-frankfurt'

description: 'Edge cluster in AWS Frankfurt'
provider: 'aws'

plain:
   provision_type: 'metal'

connection:
   access_key: 'AWS access key'
   secret_key: 'AWS secret key'
   region: 'eu-central-1'

inputs:
- name: 'aws_ami_image'
  type: 'text'
  default: 'default'
  description: 'AWS AMI image (default = Ubuntu Focal)'
- name: 'aws_instance_type'
  type: 'list'
  default: 'c5.metal'
  options:
  - 'c5.metal'
  - 'i3.metal'
  - 'm5.metal'
  - 'r5.metal'
```

When you leave the `aws_ami_image` with default value then the latest Ubuntu Focal ami will be searched and used.

Then you just need to use the command `oneprovider create`:

```default
$ oneprovider create provider.yaml
ID: 0
```

## How to Customize an Existing Provider

The Provider information is stored in the OpenNebula database and can be updated just like any other resource. In this case, you need to use the command `oneprovider update`. It will open an editor so you can edit all the information there.
