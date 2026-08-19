---
title: "What's New"
date: "2026-07-24"
description:
categories:
pageintoc: "244"
tags:
weight: "1"
---

<a id="whats-new"></a>

This page will contain the list of new features in OpenNebula 7.6.0.

## Features Backported to 7.4.x

Additionally, the following functionalities are present that were not in OpenNebula 7.4.0, although they debuted in subsequent maintenance releases of the 7.4.x series:

- Log HA hearbeat and replication messages at log level 5
- Option to configure network lease policy for internal Address Ranges. The policy can be set globally in [oned.conf]({{% relref "oned#virtual-networks" %}}) or [overridden for each Virtual Network]({{% relref "manage_vnets#lease-allocation-policy" %}}).
- Restricted-attribute configuration can now [protect a complete vector attribute]({{% relref "oned#oned-conf-restricted-attributes-configuration" %}}), such as `DISK`, `NIC`, or `PCI`, without listing each attribute within the vector separately.

## Other Issues Solved

List of new issues solved in OpenNebula 7.6.
