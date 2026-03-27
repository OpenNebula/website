---
title: "Cloud Cluster Provisioning"
linkTitle: "Cloud"
date: "2025-02-17"
description:
categories:
pageintoc: "211"
tags:
weight: "3"
---

OneForm enables automated provisioning of Clusters with supported 3rd-party cloud providers or bare-metal service providers. OneForm can interact with 3rd-party cloud service providers as long as a functioning Provider driver exists for that cloud service provider. 

OpenNebula offers existing Provider drivers for several cloud and bare-metal service providers in the [OneForm Registry Repository](https://github.com/OpenNebula/oneform-registry). Please refer to the [OneForm Registry Wiki](https://github.com/OpenNebula/oneform-registry/wiki) for details on installing and synchronizing the drivers in your OpenNebula deployment. 

If you wish to use OneForm to provision Clusters on a cloud or bare-metal service provider that is not included in the OneForm Registry repository, you can develop your own Provider driver for OneForm or customize an existing one. Please refer to the [Driver Development Guide]({{% relref "product/integration_references/cloud_provider_driver_development/creating_driver.md" %}}) and the [Driver Customization Guide]({{% relref "product/integration_references/cloud_provider_driver_development/customizing_driver.md" %}}) for details. 