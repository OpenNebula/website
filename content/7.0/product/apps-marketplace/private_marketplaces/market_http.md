---
title: "HTTP Marketplace"
date: "2025-02-17"
description:
categories:
pageintoc: "190"
tags:
weight: "2"
---

<a id="market-http"></a>

<!--# HTTP Marketplace -->

## Overview

This Marketplace uses a conventional HTTP server to expose the images (Marketplace Appliances) uploaded to the Marketplace. The image will be placed in a specific directory (available on or at least accessible from the Front-end), that must be also served by a dedicated HTTP service.

This is a fully supported Marketplace with all the implemented features.

## Requirements

The web server should be deployed either in the Front-end or on a node reachable by the Front-end. A directory that will be used to store the uploaded images (Marketplace Apps.) should be configured to have the necessary space available and the web server must be configured to grant HTTP access to that directory.

It is recommended to use either [Apache](https://httpd.apache.org/) or [NGINX](https://www.nginx.com/), as they are known to work properly with the potentially large size of the Marketplace App. files. However, other web servers may work, as long as they can handle the load.

The web server should be deployed by the administrator before registering the MarketPlace.

## Summary

## Configuration

These are the configuration attributes of a Marketplace template of the HTTP kind:

| Attribute     | Required   | Description                                                                                                                                         |
|---------------|------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| `NAME`        | **YES**    | Marketplace name that is going to be shown in OpenNebula.                                                                                           |
| `MARKET_MAD`  | **YES**    | Must be `http`.                                                                                                                                     |
| `PUBLIC_DIR`  | **YES**    | Absolute directory path to place images (the HTTP server document root) in the Front-end or in the Hosts pointed at by the `BRIDGE_LIST` directive. |
| `BASE_URL`    | **YES**    | Base URL of the Marketplace HTTP endpoint.                                                                                                          |
| `BRIDGE_LIST` | **NO**     | Space separated list of servers to access the public directory. If not defined, the public directory will be local to the Front-end.                |

When an image is uploaded to this market, it is copied to `BRIDGE_LIST`:`PUBLIC_DIR` (if `BRIDGE_LIST` is not set, then it is copied to the current frontend where OpenNebula is running). After that, they are available in `BASE_URL`. OpenNebula does not set up neither the webserver nor the secure access to it.

![HTTP marketplace overview](/images/market_http.png)

For example, the following examples illustrate the creation of a Marketplace:

```default
$ cat market.conf
NAME        = PrivateMarket
MARKET_MAD  = http
BASE_URL    = "http://frontend.opennebula.org/"
PUBLIC_DIR  = "/var/local/market-http"
BRIDGE_LIST = "web-server.opennebula.org"
```

which is created by passing the following command:

```default
$ onemarket create market.conf
ID: 100
```

{{< alert title="Note" color="success" >}}
In order to use the [download]({{% relref "../marketplace_appliances/marketapps#marketapp-download" %}}) functionality, make sure you read the [Sunstone Advanced Guide]({{% relref "../../../product/control_plane_configuration/large-scale_deployment/fireedge_for_large_deployments#fireedge-advance" %}}).{{< /alert >}} 

## Tuning & Extending

{{< alert title="Important" color="success" >}}
Any modification of code should be handled carefully. Although we might provide hints on how to fine-tune various parts by customizing the OpenNebula internals, in general, **it’s NOT recommended to make changes in the existing code**. Please note the changes will be lost during the OpenNebula upgrade and have to be introduced back again manually!{{< /alert >}} 

System administrators and integrators are encouraged to modify these drivers in order to integrate them with their datacenter. Please refer to the [Market Driver Development]({{% relref "../../../product/integration_references/infrastructure_drivers_development/devel-market#devel-market" %}}) guide to learn about the driver details.
