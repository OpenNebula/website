---
title: "Overview"
date: "2025-02-17"
description:
categories:
pageintoc: "185"
tags:
weight: "1"
---

<a id="public-marketplaces-overview"></a>

<!--# Public Marketplaces -->

OpenNebula will configure by default the following Marketplaces in your installation:

| Marketplace Name   | Description                                                                                 |
|--------------------|---------------------------------------------------------------------------------------------|
| OpenNebula Public  | The official public [OpenNebula Systems Marketplace](http://marketplace.opennebula.systems) |
| Linux Containers   | The public LXC [image repository](https://images.linuxcontainers.org)                       |

{{< alert title="Important" color="success" >}}
The OpenNebula Front-end needs access to the Internet to use the Public Marketplaces.{{< /alert >}} 

Only the OpenNebula Public mMrketplace is enabled by default. Other Marketplaces are initialized as disabled. To enable them use `onemarket enable <market_id>`.

You can list the Marketplaces configured in OpenNebula with `onemarket list`. The output for the default installation of OpenNebula will look similar to:

```default
$ onemarket list
ID NAME                                                            SIZE AVAIL   APPS MAD     ZONE STAT
1  Linux Containers                                                  0M -          0 linuxco    0 off
0  OpenNebula Public                                                 0M -         48 one        0 on
```

<a id="marketplace-disable"></a>

## Disable Marketplace

Marketplace can be disabled with `onemarket disable`. By disabling a Marketplace all Appliances will be removed from OpenNebula and it will no longer be monitored. Note that this process doesn’t affect already exported Images. After enabling the Marketplace with `onemarket enable`, it will be monitored again and all Appliances from this Marketplace will show up once more. Finally, Marketplaces can be disabled by adding `STATE=DISABLED` to the template file.
