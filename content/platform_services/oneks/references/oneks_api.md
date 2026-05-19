---
title: "REST API Reference"
linkTitle: "API"
date: "2026-05-12"
description:
categories:
tags:
weight: "1"
type: swagger
---

The OpenNebula OneKS API is a RESTful service for managing Kubernetes infrastructure on OpenNebula. It allows users to create and manage Kubernetes Clusters, operate nodegroups, retrieve K8s Cluster information, and trigger lifecycle actions such as scaling and upgrades. All data is sent and received in JSON format.

This guide is intended for developers and integrators. For other purposes, OneKS is accessible via its own [OneKS Command Line Interface]({{% relref "/product/operation_references/command_line_interface/cli.md#oneform-commands" %}}).

## API Authentication

User authentication is based on [HTTP Basic access authentication](http://tools.ietf.org/html/rfc1945#section-11). The required credentials are the username and password.

```shell
curl -u "username:password" http://oneks.example.server:10780/api/v1/clusters
```

By default, the OneKS API listens at `http://localhost:10780`. Customize this value along with other API service settings in the `/etc/one/oneks-server.conf` file. For more information, refer to the OneKS Configuration guide.

## API Methods

{{< tabpane text=true right=false >}}
{{% tab header="**API versions**:" disabled=true /%}}
{{% tab header="v1"%}}

> **Base URL**: *http://oneks.example.server:10780/api/v1*

{{< swaggerui src="openapi/oneks_v1.json?" >}}

{{% /tab %}}
{{< /tabpane >}}