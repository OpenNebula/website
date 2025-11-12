---
title: "OneFlow Server API"
date: "2025-02-17"
type: swagger
description:
categories:
pageintoc: "287"
tags:
weight: "7"
---

<!--# It hides the tablist nav, remove this css rule if more oneflow api version are added -->
<style>ul.nav.nav-tabs[role="tablist"] > li { display: none; }</style>
<a id="appflow-api"></a>

<!--# OneFlow Specification -->

The OpenNebula OneFlow API is a RESTfull service to create, control and monitor services composed of interconnected Virtual Machines with deployment dependencies between them. Each group of Virtual Machines is deployed and managed as a single entity, and is completely integrated with the advanced OpenNebula user and group management. There are two kind of resources; services templates and services. All data is sent and received as JSON.

This guide is intended for developers. The OpenNebula distribution includes a [cli]({{% relref "../../../product/operation_references/command_line_interface/cli#cli" %}}) to interact with OneFlow and it is also fully integrated in the [Sunstone GUI]({{% relref "../../../product/operation_references/opennebula_services_configuration/oneflow#oneflow-conf-sunstone" %}}).

## API Authentication

User authentication will be [HTTP Basic access authentication](http://tools.ietf.org/html/rfc1945#section-11). The credentials passed should be the username and password.

```default
$ curl -u "username:password" https://oneflow.example.server:2474
```

{{< alert title="Note" color="success" >}}
By default, the OneFlow API listens at `http://localhost:2474`. This value, along with other API service settings, can be customized in the `/etc/one/oneflow-server.conf` file.
For more information, please refer to the [OneFlow Configuration Guide]().
{{< /alert >}}

## API Methods

{{< tabpane text=true right=false >}}
{{% tab header="v1" %}}

> **Base URL**: *oneflow.example.server*

{{< swaggerui src="openapi/oneflow_v1.json" >}}

{{% /tab %}}
{{< /tabpane >}}
