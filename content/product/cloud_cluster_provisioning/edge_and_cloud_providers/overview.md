---
title: "Overview"
date: "2025-02-17"
description:
categories:
pageintoc: "204"
tags:
weight: "1"
---

<!--# Overview -->

A Provider represents a Cloud where resources (hosts, networks or storage) are allocated to implement a Provision. Usually a Provider includes a zone or region in the target Cloud and an account that will be used to create the resources needed.

## How Should I Read This Chapter

In this chapter you can find a guide on how to create Providers based on the supported Clouds. The following Cloud providers are enabled by default after installing OpenNebula:

> - [Equinix Provider]({{% relref "equinix_provider#equinix-provider" %}})
> - [Amazon AWS Provider]({{% relref "aws_provider#aws-provider" %}})
> - [Scaleway Provider]({{% relref "scaleway_provider#scaleway-provider" %}})

Note, the on-premise provider is a convenient abstraction to represent your own resources on your datacenter.

## Hypervisor Compatibility

Provisions are compatible with the KVM and LXC hypervisors.
