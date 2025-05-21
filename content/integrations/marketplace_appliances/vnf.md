---
title: "VNF and Virtual Router"
date: "2025-02-17"
description:
categories:
pageintoc: "199"
tags:
weight: "15"
---

<a id="service-vnf"></a>

<!--# Virtual Network Functions (VNF) and Virtual Router -->

## Appliance Description

The Virtual Router (VR) is a solution to common problems regarding management of VNETs and routing. It consists of the **Service Virtual Router**, which is deployed as a set of Virtual Machines, and associated logic implemented in the core of OpenNebula.

## Main Features

The VR includes a comprehensive set of features:

- Keepalive Failover, High-Availability for the Service Virtual Router itself
- Router4, for fine control of routing between your virtual networks
- NAT4 to enable private virtual networks to reach the Internet
- HAProxy Load Balancer, a robust layer4 (TCP) reverse-proxy/load-balancing solution
- Keepalive LVS Load Balancer, so called layer4 switching, a high-performance load-balancing solution
- SDNAT4, a public to private, private to public IP address mapping (SNAT + DNAT)
- DNS, a DNS recursor (to provide DNS to isolated virtual networks)
- DHCP4, an additional DHCP server implementation

## Main References

- [Virtual Router](https://github.com/OpenNebula/one-apps/tree/master/appliances/VRouter) in the [OpenNebula one-apps](https://github.com/OpenNebula/one-apps) project
- [Full documentation](https://github.com/OpenNebula/one-apps/wiki) for the Virtual Router
- [Virtual Router Release Notes](https://github.com/OpenNebula/one-apps/releases)
