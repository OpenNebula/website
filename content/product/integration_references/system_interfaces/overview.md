---
title: "Overview"
date: "2025-02-17"
description:
categories:
pageintoc: "281"
tags:
weight: "1"
---

<a id="introapis"></a>

<!--# Overview -->

OpenNebula has been designed to be easily adapted to any infrastructure and easily extended with new components. The result is a modular system that can implement a variety of cloud architectures and can interface with multiple datacenter services. In this Guide we review the main interfaces of OpenNebula and their.

{{< image path="/images/overview_architecture.svg" alt="OpenNebula Components Following a Modular Approach" align="center" width="50%" pb="20px" >}}

## How Should I Read This Chapter

You should be reading this Chapter if you are trying to automate tasks in your deployed OpenNebula cloud, and you have already read all of the previous guides.

This Chapter introduces the OpenNebula system interfaces:

> * The **XML-RPC interface** is the primary interface for OpenNebula, exposing all the functionality to interface the OpenNebula Daemon. Through the XML-RPC interface you can control and manage any OpenNebula resource. You can also find bindings on some popular languages like [Ruby]({{% relref "ruby#ruby" %}}), [JAVA]({{% relref "java#java" %}}), [Golang]({{% relref "go#go" %}}) and [Python]({{% relref "python#python" %}}).
> * The [OpenNebula OneFlow API]({{% relref "appflow_api#appflow-api" %}}) is a RESTful service to create, control, and monitor services composed of interconnected Virtual Machines with deployment dependencies between them.
> * The [The OneGate Server]({{% relref "onegate_api#onegate-api" %}}) provides a RESTful service for Virtual Machines to pull and push information from/to OpenNebula.
> * A very convenient way to integrate OpenNebula in your infrastructure are the **Hooks**. Hooks allow you to trigger actions on specific OpenNebula events. You can also subscribe to the event bus (zeroMQ) to integrate your own modules.

## Hypervisor Compatibility

All sections of this Chapter apply to KVM.
