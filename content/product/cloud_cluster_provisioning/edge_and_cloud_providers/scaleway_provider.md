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

A Scaleway Provider contains the credentials to interact with Scaleway and also the location to deploy your Provisions. OpenNebula comes with three pre-defined Providers in the following regions:

* PAR-1 (France - Paris)
* NL-AMS-1 (Netherlands - Amsterdam)
* PL-WAW-3 (Poland - Warsaw)

In order to define a Scaleway Provider you need the following information:

* **Credentials**: these are used to interact with the remote Provider. You need to provide `access_key`, `secret_key` and `project_id`. You can follow [this guide](https://www.scaleway.com/en/docs/identity-and-access-management/iam/how-to/create-api-keys//) to get this data.
* **Zone**: this is the location in the world where the resources are going to be deployed. All the available [zones are listed here](https://www.scaleway.com/en/docs/console/account/reference-content/products-availability/).
* **Offers and OS**: these define the capacity of the resources that are going to be deployed and the operating system that is going to be installed on them.

{{< alert title="Warning" color="warning" >}}
Please note even though Scaleway support multiple OSs, the automation tools are tailored to work with `Ubuntu 22.04`. If you use another OS, please be aware that it might require some adjustments and things might not work as expected. Avoid using a different OS in production environments unless you’ve properly tested it before.{{< /alert >}} 

## How to Create a Scaleway Provider

To add a new Provider you need to write the previous data in YAML template:

```default
$ cat provider.yaml
name: 'scaleway'

description: 'Provision cluster in Scaleway Paris'
provider: 'scaleway'

plain:
  provision_type: 'metal'

connection:
  access_key: 'Scaleway Access Key'
  secret_key: 'Scaleway Secret Key'
  project_id: 'Scaleway Project ID'
  zone: 'fr-par-1'

inputs:
  - name: 'scw_baremetal_os'
    type: 'text'
    default: 'Ubuntu'
    description: 'Scaleway ost operating system'

  - name: 'scw_offer'
    type: 'list'
    default: 'EM-A115X-SSD'
    description: 'Scaleway server capacity'
    options:
      - 'EM-A115X-SSD'
```

Then you just need to use the command `oneprovider create`:

```default
$ oneprovider create provider.yaml
ID: 0
```

## How to Customize an Existing Provider

The Provider information is stored in the OpenNebula database and can be updated just like any other resource. In this case, you need to use the command `oneprovider update`. It will open an editor so you can edit all the information there.
