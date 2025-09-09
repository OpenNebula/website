---
title: "Overview"
type: docs
linkTitle: "Overview"
description: "Short overview of the OpenNebula Community Marketplace."
weight: 2
---

The OpenNebula Community Marketplace is a public repository of virtual appliances and templates that are ready to be used within OpenNebula cloud environments.The Marketplace provides pre-built and tested images that users can easily import into their own OpenNebula cloud to quickly deploy virtual machines (VMs), applications, and services without having to build them from scratch.
All OpenNebula users can contribute their appliances to the Community Marketplace. It is accessible via the OpenNebula Sunstone GUI or CLI and hosted at https://community-marketplace.opennebula.io.

If you're running an OpenNebula cloud and think the other OpenNebula users may benefit from the appliances you are using, the Community Marketplace is one of the fastest ways to share them with the OpenNebula Community eliminating a necessity for everyone to build the same or similar appliances.

## Introduction to Appliance Marketplaces

OpenNebula Marketplaces provide a simple way to integrate your cloud with popular application/image providers. They can be treated as external datastores.
A Marketplace stores Marketplace Appliances. A MarketPlace Appliance includes one or more Images and, possibly, some associated metadata like VM Templates or OpenNebula Multi-VM service definitions.
A Marketplace can be:
* **Public**: accessible universally by all OpenNebula installations.
* **Private**: local within an organization and specific for a single.

OpenNebula (a single zone) or shared by a federation (a collection of zones).
The list of the Public Marketplaces configured by default is presented in table below.

|Marketplace&nbsp;Name|Description|
|----------------|-----------|
|OpenNebula Public|The official public [OpenNebula Systems Marketplace](http://marketplace.opennebula.systems). It is a catalog of virtual appliances ready to run in OpenNebula environments available at the specified link above.|
|Linux Containers|The public LXD/LXC [image repository](https://images.linuxcontainers.org). It hosts a public image server with container images for LXC and LXD. OpenNebula’s Linux Containers marketplace enables users to easily download, contextualize and add Linux container images to an OpenNebula datastore.|

It’s important to note the OpenNebula front-end needs access to the Internet to use the public Marketplaces.

Besides the `public` Marketplaces (leveraging various remote public repositories with existing Appliances and accessible universally by all OpenNebula instances), the `private` ones allow the cloud administrators to create the `private` Marketplaces within a single organization in a specific OpenNebula (single zone) or shared by a Federation (collection of zones). `Private` Marketplaces provide their users with an easy way of privately publishing, downloading and sharing their own custom Appliances.

As it was written above a Marketplace is a repository of Marketplace Appliances. There are three types of Appliances:
* **Image**: an image that can be downloaded and used (optionally it can have an associated virtual machine template)
* **Virtual Machine Template**: a virtual machine template that contains a list of images that are allocated in the Marketplaces.
* **Service Template**: a template to be used in OneFlow that contains a list of virtual machine templates that are allocated in the Marketplaces.

Using `private` Marketplaces is very convenient, as it will allow you to move images across different kinds of datastores (using the Marketplace as an exchange point). It is a way to share OpenNebula images in a Federation, as these resources are federated. In an OpenNebula deployment where the different Virtual Data Centers (VDCs) don’t share any resources, a Marketplace will act like a shared datastore for all the users.

Although a marketplace created in a zone will be seen in every zone of the Federation and every image can be imported from the marketplace on any zone, only the zone where the marketplace was created will be able to upload appliances to the marketplace.

Marketplaces store the actual Marketplace Appliances. How they do so depends on the back-end driver. Currently, the list of the supported back-end drivers is given in table below.
|Driver|Upload|Description|
|------|------|-----------|
|http|Yes|When an image is uploaded to a Marketplace of this kind, the image is written into a file in a specified folder, which is in turn available via a web server.|
|S3|Yes|Images are stored to an S3 API-capable service. This means they can be stored in the official [AWS S3 service](https://aws.amazon.com/s3/) , or in services that implement that API like [Ceph Object Gateway S3](https://docs.ceph.com/en/latest/radosgw/s3/).|

OpenNebula ships with the [OpenNebula Systems Marketplace](http://marketplace.opennebula.systems/) pre-registered, so users can access it directly.
