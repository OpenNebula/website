---
title: "Marketplace Configuration"
date: "2025-02-17"
description: "Manage public and private marketplaces, and explore the appliances available on OpenNebula's public marketplace"
categories:
pageintoc: "182"
tags:
weight: "6"
---

<a id="apps-marketplace"></a>

<!--# Apps-marketplace -->

OpenNebula Marketplaces provide a simple way to integrate your cloud with popular application/image providers. Think of them as external datastores.

A Marketplace can be:

* **Public**: accessible universally by all OpenNebula installations.
* **Private**: local within an organization and specific for a single OpenNebula (a single zone) or shared by a federation (a collection of zones). If you are interested in setting up your own private marketplace, please follow [this guide]({{% relref "private_marketplaces/index" %}}).

A Marketplace stores Marketplace Appliances. A MarketPlace Appliance includes one or more Images and, possibly, some associated metadata like VM Templates or OpenNebula Multi-VM service definitions.
