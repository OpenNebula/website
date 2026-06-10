---
title: "OpenNebula Software Editions"
linkTitle: "Software Editions"
date: "2026-06-10"
description:
categories:
pageintoc: "245"
tags:
weight: "3"
---

OpenNebula is available in three software editions designed to meet different operational and business requirements: **Community Edition**, **Enterprise Extension**, and **AI Factory Extension**. If you would like to find out more about commercial subscriptions and pricing, please refer to the [Enterprise Services](https://opennebula.io/enterprise-services/) page of the OpenNebula website.

## Community Edition

The Community Edition provides the core OpenNebula platform and is available as open source software. It includes the essential capabilities required to build and operate private, hybrid, and edge cloud environments using OpenNebula's unified management platform. It is ideal for evaluation, development, lab environments, and organizations that prefer a self-supported deployment model.

## Enterprise Extension

The Enterprise Extension is available as part of an OpenNebula subscription and includes enterprise-grade support, maintenance, and access to advanced integrations and capabilities designed for production environments. Enterprise subscriptions provide additional validation, hardening, and specialized infrastructure integrations beyond the Community Edition.

Enterprise-only features include:

* [NetApp storage integration]({{% relref "product/cluster_configuration/san_storage/netapp/" %}})
* [LVM storage integration]({{% relref "product/cluster_configuration/lvm/lvm/" %}})
* [Everpure storage integration]({{% relref "product/cluster_configuration/san_storage/everpure/" %}})
* [Veeam backup integration]({{% relref "product/cluster_configuration/backup_system/veeam/" %}})
* [Elastic Kubernetes Service (OneKS)]({{% relref "platform_services/oneks/" %}})

The Enterprise Extension is designed for organizations operating business-critical cloud infrastructure that require vendor-backed support and advanced ecosystem integrations.

## AI Factory Extension

The AI Factory Extension builds on the Enterprise Extension to provide capabilities specifically designed for AI infrastructure, GPU-accelerated environments, and multi-tenant AI factories. It is delivered as part of an AI Factory subscription, which includes support for the complete AI stack and advanced NVIDIA integrations.

AI Factory-specific features include:

* [NVIDIA Spectrum-X integration]({{% relref "product/cluster_configuration/networking_system/spectrumx/" %}})
* [NVIDIA Fabric Manager integration]({{% relref "product/cluster_configuration/hosts_and_clusters/one_fabricmanager/" %}})

The AI Factory Extension enables organizations to deploy and operate production-ready AI platforms with advanced networking and GPU infrastructure management capabilities.

## Comparison

The Community Edition delivers the core OpenNebula experience while the Enterprise Extension adds production-grade integrations and support. The AI Factory Extension expands the platform with specialized capabilities for AI and GPU-accelerated infrastructure.

| **Capability** | **Community Edition** | **Enterprise Extension** | **AI Factory Extension** | 
|----------------|-----------------------|--------------------------|------------------------|
| Core OpenNebula Platform          | &#10004; | &#10004; | &#10004; |
| Commercial Support & Maintenance  | - | &#10004; | &#10004; |
| NetApp Storage Integration        | - | &#10004; | &#10004; |
| LVM Storage Integration           | - | &#10004; | &#10004; |
| Everpure Storage Integration      | - | &#10004; | &#10004; |
| Veeam Integration                 | - | &#10004; | &#10004; |
| Elastic Kubernetes Service        | - | &#10004; | &#10004; |
| OneKS                             | - | &#10004; | &#10004; |
| NVIDIA Spectrum-X                 | - |    -     | &#10004; | 
| NVIDIA Fabric Manager             | - |    -     | &#10004; |