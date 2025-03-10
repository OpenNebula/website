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

An Equinix provider contains the credentials to interact with Equinix and also the location to deploy your Provisions. OpenNebula comes with four pre-defined providers in the following regions:

* Amsterdam
* Parsippany (NJ, US)
* Tokyo
* California (US)

In order to define an Equinix provider, you need the following information:

* **Credentials**: these are used to interact with the remote provider. You need to provide `token` and `project`. You can follow [this guide](https://metal.equinix.com/developers/api/) to get this data.
* **Facility**: this is the location in the world where the resources are going to be deployed. All the available [facilities are listed here](https://www.equinix.com/data-centers/).
* **Plans and OS**: these define the capacity of the resources that are going to be deployed and the operating system that is going to be installed on them.

{{< alert title="Warning" color="warning" >}}
Please note even though Equinix support multiple OSs, the automation tools are tailored to works with `Ubuntu 20.04`. If you use another OS, please be aware that it might required some adjustments, and things might not work as expected. Avoid using a different OS in production environment unless you’ve properly tested it before.{{< /alert >}} 

## How to Create an Equinix Provider

To add a new provider you need to write the previous data in YAML template:

```default
$ cat provider.yaml
name: 'equinix-amsterdam'

description: 'Edge cluster in Equinix Amsterdam'
provider: 'equinix'

plain:
   provision_type: 'metal'

connection:
  token: 'Equinix token'
  project: 'Equinix project'
  facility: 'ams1'

inputs:
  - name: 'equinix_os'
    type: 'list'
    default: 'ubuntu_20_04'
    options:
      - 'ubuntu_20_04'
  - name: 'equinix_plan'
    type: 'list'
    default: 't1.small'
    options:
      - 't1.small'
      - 'c1.small'
      - 'm1.xlarge'
```

Then you just need to use the command `oneprovider create`:

```default
$ oneprovider create provider.yaml
ID: 0
```

The providers’ templates are located in `/usr/share/one/oneprovision/edge-clusters/metal/providers/equinix`. You just need to enter valid credentials.

## How to Customize an Existing Provider

The provider information is stored in the OpenNebula database and can be updated just like any other resource. In this case, you need to use the command `oneprovider update`. It will open an editor so you can edit all the information there. You can also use the OneProvision FireEdge GUI to update all the information.

## Insufficient capacity on Equinix Metal

Sometimes there may not be enough hardware available at a given Equinix Metal facility for a given machine type, in which case the following error is shown:

```default
The facility ams1 has no provisionable c3.small.x86 servers matching your criteria
```

In this case, either select a different node type or Equinix Metal provider. You can check the current capacity status on the Equinix Metal API .
