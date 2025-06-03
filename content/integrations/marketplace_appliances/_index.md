---
title: "Marketplace Appliances"
date: "2025-02-17"
description: "Easily deploy production-ready applications and services through the OpenNebula Marketplace, featuring a curated selection of official appliances maintained by OpenNebula Systems and trusted partners"
categories:
pageintoc: "194"
tags:
weight: "2"
---

<a id="appliances"></a>

<!--# Appliances -->

The public OpenNebula [Marketplace](https://marketplace.opennebula.io/) includes easy-to-use appliances, which are            preconfigured Virtual Machines that can be used to deploy different services. These appliances include the images with all    necessary packages installed for the service run, including the [OpenNebula contextualization packages]({{% relref "../../../product/virtual_machines_operation/virtual_machine_images/vm_templates#context-overview" %}}) and specific scripts that bring the service up on boot. This allows to customize the final service state by the cloud user via special contextualization      parameters.

No security credentials are persisted in the distributed appliances. Initial passwords are provided via the contextualization parameters or are dynamically generated for each new virtual machine. No two virtual machines with default contextualization  parameters share the same passwords or database credentials.
