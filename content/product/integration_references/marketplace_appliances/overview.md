---
title: "Overview"
date: "2025-02-17"
description:
categories:
pageintoc: "36"
tags:
weight: "1"
---

<a id="overview-marketplace-appliances"></a>

<!--# Overview -->

The public OpenNebula [Marketplace](https://marketplace.opennebula.io/) includes easy-to-use appliances, which are preconfigured Virtual Machines that can be used to deploy different services. These appliances include the images with all necessary packages installed for the service run, including the [OpenNebula contextualization packages]({{% relref "../../../product/virtual_machines_operation/virtual_machines/vm_templates#context-overview" %}}) and specific scripts that bring the service up on boot. This allows to customize the final service state by the cloud user via special contextualization parameters.

No security credentials are persisted in the distributed appliances. Initial passwords are provided via the contextualization parameters or are dynamically generated for each new Virtual Machine. No two Virtual Machines with default contextualization  parameters share the same passwords or database credentials.

## Basic Guide Outline

[OneKE Service (Kubernetes)]({{% relref "oneke" %}}): it describes the OneKE appliance, a minimal hyperconverged Kubernetes platform bundled with OpenNebula and based on RKE2 (Rancher's Next Generation Kubernetes Distribution). The appliance is designed for out-of-the-box functionality, featuring preinstalled components for essential cluster services, including Longhorn for storage persistence, Traefik for ingress traffic, and load balancing options like Cilium, MetalLB, or the ONE Cloud Provider.

[Rancher CAPI]({{% relref "capi" %}}): provides a preconfigured environment for seamless management of Kubernetes clusters on OpenNebula. The appliance comes with Rancher running on a lightweight K3s cluster, integrated with the Turtles extension. It automatically imports the Cluster API provider for OpenNebula (CAPONE) as an infrastructure provider, allowing users to manage CAPI RKE2 clusters directly from the Rancher web interface.

You will also find information including description, features and main references for these appliances:
* [Wordpress]({{% relref "wordpress" %}})
* [VNF and Virtual Router]({{% relref "vnf" %}})
* [minIO]({{% relref "minio" %}})
* [vLLM AI]({{% relref "vllm" %}})


## Hypervisor Compatibility

This chapter applies to all hypervisors.
