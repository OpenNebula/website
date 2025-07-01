---
title: "OneForm Server API"
type: swagger
weight: 7
description:
---

The OpenNebula Formation API is a RESTful service designed to register, configure, and orchestrate infrastructure provisioning workflows across multiple providers. It enables users to define provider templates, instantiate and manage providers, register reusable provisioning templates, and launch full provisioning cycles, each consisting of one or more cloud resources such as hosts, networks, and datastores. All data is sent and received in JSON format.

This guide is intended for developers and integrators. For other purposes, OneForm is accessible via its own [OneForm Command Line Interface]().

{{< swaggerui src="openapi/oneform.json" >}}
