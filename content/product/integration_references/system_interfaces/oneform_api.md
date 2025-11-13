---
title: "OneForm Server API"
type: swagger
weight: 7
description:
---

The OpenNebula OneForm API is a RESTful service designed to register, configure, and orchestrate infrastructure provisioning workflows across multiple providers. It enables users to define and create providers and launch full provisioning cycles, each consisting of one or more cloud resources such as hosts, networks, and datastores. All data is sent and received in JSON format.

This guide is intended for developers and integrators. For other purposes, OneForm is accessible via its own [OneForm Command Line Interface]({{% relref "../../../product/operation_references/command_line_interface/cli#cli" %}}).

## API Authentication

User authentication is based on [HTTP Basic access authentication](http://tools.ietf.org/html/rfc1945#section-11). The required credentials are the username and password.

```default
$ curl -u "username:password" https://oneform.example.server/api/v1
```

By default, the OneForm API listens at `http://localhost:13013`. Customize this value along with other API service settings in the `/etc/one/oneform-server.conf` file. For more information, refer to the [OneForm Configuration]({{% relref "../../../product/operation_references/opennebula_services_configuration/oneform" %}}) guide.


## API Methods

{{< tabpane text=true right=false >}}
{{% tab header="**API versions**:" disabled=true /%}}
{{% tab header="v1"%}}

> **Base URL**: *oneform.example.server/api/v1*

{{< swaggerui src="openapi/oneform_v1.json?" >}}

{{% /tab %}}
{{< /tabpane >}}
