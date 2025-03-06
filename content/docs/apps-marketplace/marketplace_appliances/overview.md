---
title: "Overview"
date: "2025/02/17"
description:
categories:
pageintoc: "195"
tags:
weight: "1"
---

<a id="service-overview"></a>

<a id="one-service-appliance"></a>

<!--# Overview -->

The public OpenNebula [Marketplace](https://marketplace.opennebula.io/) includes easy-to-use appliances, which are preconfigured Virtual Machines that can be used to deploy different services. These appliance include the images with all necessary packages installed for the service run, including the [OpenNebula contextualization packages]({{% relref "../../configuration_and_operation/virtual_machines_operation/virtual_machine_images/vm_templates#context-overview" %}}) and specific scripts that bring the service up on boot. This allows to customize the final service state by the cloud user via special contextualization parameters.

No security credentials are persisted in the distributed appliances. Initial passwords are provided via the contextualization parameters or are dynamically generated for each new virtual machine. No two virtual machines with default contextualization parameters share the same passwords or database credentials.

## OneKE Service (Kubernetes)

OneKE is a minimal [hyperconverged](https://en.wikipedia.org/wiki/Hyper-converged_infrastructure) Kubernetes platform that comes with OpenNebula out of the box. OneKE is based on [RKE2 - Rancher’s Next Generation Kubernetes Distribution](https://docs.rke2.io/) with preinstalled components to handle:

* storage persistence,
* ingress traffic,
* load balancing.

The full documentation of the [OneKE appliance](https://github.com/OpenNebula/one-apps/wiki) is maintained in the OpenNebula Apps project.

## Virtual Router (VR)

The VR in OpenNebula is a solution to common problems regarding management of VNETs and routing, including:

* Keepalive Failover, High-Availability for the Service Virtual Router itself.
* Router4, to fine control routing between your virtual networks.
* NAT4, so you can enable your private virtual networks to reach the Internet.
* HAProxy Load Balancer, a robust layer4 (TCP) reverse-proxy/load-balancing solution.
* Keepalive LVS Load Balancer, so called layer4 switching, a high-performance load-balancing solution.
* SDNAT4, a public to private, private to public IP address mapping (SNAT + DNAT).
* DNS, a DNS recursor (to provide DNS to isolated virtual networks).
* DHCP4, a DHCP server implementation (if the usual contextualization doesn’t work for you).

The full documentation of the [VR appliance](https://github.com/OpenNebula/one-apps/wiki) is maintained in the OpenNebula Apps project.

## WordPress

This OpenNebula marketplace appliance comes with a preinstalled WordPress <https://wordpress.org/ service and includes the following features:

* Based on the latest AlmaLinux 8 Linux distribution (for x86-64).
* No default login (local or SSH) password - must be provided via contextualization

The full documentation of the [WordPress appliance](https://github.com/OpenNebula/one-apps/wiki) is maintained in the OpenNebula Apps project.
