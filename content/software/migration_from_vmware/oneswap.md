---
title: "Migrating VMs with OneSwap"
date: "2025-02-17"
description: 
categories:
pageintoc: "268"
tags:
weight: "2"
---

<a id="oneswap"></a>

<!--# OneSwap -->

OpenNebula provides [OneSwap](https://github.com/OpenNebula/one-swap), a command-line tool designed to simplify migrating Virtual Machines from vCenter to OpenNebula. OneSwap has been used in the field with a 96% success rate in converting VMs automatically, greatly simplifying and speeding up the migration process.

OneSwap supports importing Open Virtual Appliances (OVAs) previously exported from vCenter/ESXi environments. The [Managing OVAs and VMDKs]({{% relref "import_ova" %}}) guide provides instructions, with complete examples.

{{< alert color="success" >}}
OneSwap is part of a set of tools and services designed to guide you in achieving a smooth transition from VMware. These include the [VMware Migration Service](https://support.opennebula.pro/hc/en-us/articles/18919424033053-VMware-Migration-Service), a complete guidance and support framework to help organizations define and execute their migration plan with minimal disruption to business operations. Further information is available in [Migrating from VMware to OpenNebula](https://support.opennebula.pro/hc/en-us/articles/17225311830429-White-Paper-Migrating-from-VMware-to-OpenNebula).
{{< /alert >}}
