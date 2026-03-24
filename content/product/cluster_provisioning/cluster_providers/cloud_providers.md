---
title: "Cloud Providers"
linkTitle: "Cloud"
date: "2026-03-24"
description:
categories:
pageintoc: "204"
tags:
weight: "3"
---

<a id="cloud-providers"></a>

Cloud Providers define how OneForm interacts with 3rd-party IaaS cloud or bare-metal infrastructure providers such as AWS, Scaleway or Equinix. Providers for cloud-based service providers handle the credentials and API keys needed to connect with the service and automatically manage physical or virtual computing resources through OneForm. You only need to set up a Provider once for a cloud-based service, then it can be used repeatedly to provision Clusters without the need to recall credentials or configuration.  

## Creating Providers for 3rd-party Cloud or Bare-metal Services

To create Providers for 3rd-party services, you need to install a Provider driver for each specific service. The Provider driver defines the logic for interacting with the IaaS API. Provider drivers for several 3rd-party services are available in the [OneForm Registry Repository](https://github.com/OpenNebula/oneform-registry):

* Install the drivers with the [Driver Installation Instructions](https://github.com/OpenNebula/oneform-registry/wiki)

* After installing the drivers follow the instructions for creating Providers for the following services:
    * [Amazon AWS Provider](https://github.com/OpenNebula/oneform-registry/wiki/Amazon-Web-Services-Provider)
    * [Equinix Provider](https://github.com/OpenNebula/oneform-registry/wiki/Equinix-Provider)
    * [Scaleway Provider](https://github.com/OpenNebula/oneform-registry/wiki/Scaleway-Provider)

## Developing Provider Drivers

If a driver does not currently exist for your preferred cloud service, refer to the [Provider Driver Development Guide]({{% relref "/product/integration_references/cloud_provider_driver_development/creating_driver.md" %}}). If you need to customize and existing driver to add new zones or images, refer to the [Driver Customization Guide]({{% relref "/product/integration_references/cloud_provider_driver_development/customizing_driver.md" %}}).

## Provisioning Clusters

Once you have created Providers for your preferred cloud or bare-metal service, you can provision Clusters using those services through OneForm. Please refer to the Provisioning guide for your preferred service provider:

* [AWS]({{% relref "product/cluster_provisioning/cluster_provisions/aws_cluster.md" %}})
* [Equinix]({{% relref "product/cluster_provisioning/cluster_provisions/equinix_cluster.md" %}})
* [Scaleway]({{% relref "product/cluster_provisioning/cluster_provisions/scaleway_cluster.md" %}})