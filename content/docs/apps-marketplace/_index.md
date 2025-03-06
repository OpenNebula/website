---
title: "Apps Marketplace"
date: "2025/02/17"
description: "Explore the appliances available on OpenNebula's public marketplace, and how to access, create and manage private marketplaces"
categories:
pageintoc: "182"
tags:
weight: "3"
---

<a id="apps-marketplace"></a>

<!--# Apps-marketplace -->

+[Add a reference to the [Integration Framework]({{% relref integration_and_development %}}) section]

OpenNebula Marketplaces provide a simple way to integrate your cloud with popular application/image providers. Think of them as external datastores.

A Marketplace can be:

* **Public**: accessible universally by all OpenNebula installations.
* **Private**: local within an organization and specific for a single OpenNebula (a single zone) or shared by a federation (a collection of zones). If you are   interested in setting up your own private marketplace, please follow [this guide]({{% relref "marketplace_configuration/private_marketplaces/index" %}}).

A Marketplace stores Marketplace Appliances. A MarketPlace Appliance includes one or more Images and, possibly, some associated metadata like VM Templates or    OpenNebula Multi-VM service definitions.

* [Marketplace Configuration]({{% relref "marketplace_configuration/index" %}})
  * [Public Marketplaces]({{% relref "marketplace_configuration/public_marketplaces/index" %}})
  * [Private Marketplaces]({{% relref "marketplace_configuration/private_marketplaces/index" %}})
  * [Managing Marketplaces In Sunstone]({{% relref "marketplace_configuration/managing_marketplaces_in_sunstone/index" %}})
* [Marketplace Appliances]({{% relref "marketplace_appliances/index" %}})
  * [Overview]({{% relref "marketplace_appliances/overview" %}})
  * [Managing Marketplace Appliances]({{% relref "marketplace_appliances/marketapps" %}})
  * [OneKE Service (K8s)]({{% relref "marketplace_appliances/oneke" %}})
  * [WordPress]({{% relref "marketplace_appliances/wordpress" %}})
  * [VNF and Virtual Router]({{% relref "marketplace_appliances/vnf" %}})
  * [minIO]({{% relref "marketplace_appliances/minio_intro" %}})
