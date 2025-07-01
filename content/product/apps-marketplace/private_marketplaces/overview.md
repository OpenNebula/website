---
title: "Overview"
date: "2025-02-17"
description:
categories:
pageintoc: "189"
tags:
weight: "1"
---

<a id="private-marketplace-overview"></a>

<!--# Overview -->

Besides the [public Marketplaces]({{% relref "../public_marketplaces/index#public-marketplaces" %}}) (leveraging various remote public repositories with existing Appliances and accessible universally by all OpenNebula instances), the private ones allow the cloud administrators to create the **Private Marketplaces** within an single organization in a specific OpenNebula (single Zone) or shared by a Federation (collection of Zones). Private Marketplaces provide their users with an easy way of privately publishing, downloading, and sharing their own custom Appliances.

A Marketplace is a repository of Marketplace Appliances. There are three types of Appliances:

- **Image**: an image that can be downloaded and used (optionally, it can have an associated Virtual Machine template).
- **Virtual Machine Template**: a Virtual Machine template that contains a list of images that are allocated in the Marketplaces.
- **Service Template**: a template to be used in OneFlow that contains a list of Virtual Machine templates that are allocated in the Marketplaces.

Using Private Marketplaces is very convenient, as it will allow you to move images across different kinds of datastores (using the Marketplace as an exchange point). It is a way to share OpenNebula images in a Federation, as these resources are federated. In an OpenNebula deployment where the different VDCs don’t share any resources, a Marketplace will act like a shared datastore for all the users.

{{< alert title="Warning" color="warning" >}}
Although a Marketplace created in a Zone will be seen in every Zone on the Federation and every image can be imported from the Marketplace on any Zone, only the Zone where the Marketplace was created will be able to upload appliances to the Marketplace.{{< /alert >}} 

## Backends

Marketplaces store the actual Marketplace Appliances. How they do so depends on the backend driver. Currently, the following Private Marketplace drivers are shipped with OpenNebula:

| Driver                          | Upload   | Description                                                                                                                                                                                                                                                            |
|---------------------------------|----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [http]({{% relref "market_http#market-http" %}}) | Yes      | When an image is uploaded to a Marketplace of this kind, the image<br/>is written into a file in a specified folder, which is in turn<br/>available via a web server.                                                                                                  |
| [S3]({{% relref "market_s3#market-s3" %}})       | Yes      | Images are stored to an S3 API-capable service. This means they can<br/>be stored in the official [AWS S3 service](https://aws.amazon.com/s3/) , or in services that implement<br/>that API like [Ceph Object Gateway S3](https://docs.ceph.com/en/latest/radosgw/s3/) |

Check [this]({{% relref "../public_marketplaces/index#public-marketplaces" %}}) to see information about Public Marketplaces. OpenNebula ships with the OpenNebula Systems Marketplace pre-registered, so users can access it directly.

## Use Cases

Using the Marketplace is recommended in many scenarios. To name a few:

* You can upload an image into a Marketplace and download it later to other datastores, even if the source and target datastores are of a different type, thus enabling image cloning from any datastore to any other datastore.
* In a Federation, it is almost essential to have a shared Marketplace in order to share Marketplace Apps across Zones.
* Marketplaces are a great way to provide content for the users in VDCs with no initial virtual resources.

## How Should I Read This Chapter

Before reading this Chapter make sure you have read the [Quick Start]({{% relref "../../../quick_start" %}}) guide.

Read the [Public Marketplaces]({{% relref "../public_marketplaces/index#public-marketplaces" %}}) as it’s global for all OpenNebula installations. Then, read the specific guide for the Private Marketplace type you are interested in. Finally, read the [Managing Marketplace Apps]({{% relref "../../apps-marketplace/managing_marketplaces/marketapps" %}}) to understand what operations you can perform on Marketplace Apps.

## Hypervisor Compatibility

This Chapter applies to all hypervisors.
