---
title: "OneForm Server API"
type: swagger
weight: 7
description:
---

The OpenNebula Formation API is a RESTful service designed to register, configure, and orchestrate infrastructure provisioning workflows across multiple providers. It enables users to define provider templates, instantiate and manage providers, register reusable provisioning templates, and launch full provisioning cycles, each consisting of one or more cloud resources such as hosts, networks, and datastores. All data is sent and received in JSON format.

This guide is intended for developers and integrators. For other purposes, OneForm is accessible via its own [OneForm Command Line Interface]().

## Authentication & Authorization

User authentication will be [HTTP Basic access authentication](http://tools.ietf.org/html/rfc1945#section-11). The credentials passed should be the username and password.

```default
$ curl -u "username:password" https://oneform.server
```

## API Resources

{{< swaggerui src="openapi/oneform_v1.json?" >}}
