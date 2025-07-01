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

A Provider represents a Cloud where resources (hosts, networks or storage) are allocated to implement a Provision. Usually a Provider includes a set of account credentials and a zone or region in the target Cloud that will be used to create the resources needed.

## How to Read This Chapter

This chapter is structured to help cloud administrators understand:

1. The conceptual model of a Provider in OpenNebula's architecture.
2. The layout of a provider (Terraform modules, Ansible playbooks and metadata).

This overview section is oriented to a generic view of provider structure, for an especific providers, the following sections contains Cloud providers are enabled by default after installing OpenNebula:

> - [Amazon AWS Provider]({{% relref "aws_provider#aws-provider" %}})
> - [Equinix Provider]({{% relref "equinix_provider#equinix-provider" %}})
> - [Scaleway Provider]({{% relref "scaleway_provider#scaleway-provider" %}})
> - [On-premises provider]({{% relref "onprem_provider#onprem-provider" %}})

By the end of this section, you will have a clear understanding of how providers are organized and what components they include.

## Logic Model of a Provider

A Provider represents a logical cloud endpoint in OpenNebula. It consists of:

- **Account credentials** (API keys, tokens, or certificates), uses to authenticate against the provider cloud API.
- **Region or zone information**, indicating where resources should be provisioned.
- **Metadata files**, which declare static attributes such as the provider’s identifier, description, and version.

This elements are combined through an JSON document stored in the OpenNebula dabase:

```json
{
    "name": "Example provider",
    "description": "Example provider for demostration",
    "version": "1.0.0",
    "fireedge": {
        "logo": "example.png"
    },
    "cloud_provider": "example",
    "connection": {
        "api_key": "$api_key",
        "region": "$region"
    },
    "user_inputs": [
    {
        "name": "api_key",
        "description": "Example API Key",
        "type": "string",
    },
    {
        "name": "region",
        "description": "Example Region",
        "type": "string",
        "default": "region-1",
        "match": {
        "type": "list",
        "values": [
            "region-1",
            "region-2"
        ]
        }
    }
    ],
    "registration_time": 1748504203
}
```

For more information about Provider datamodel and configuration please refer to [Provider configuration]({{% relref "../../operation_references/configuration_references/provider_template#provider-template" %}}) section.

## Provider Structure

A Provider in OpenNebula follows a standardized, modular directory structure designed to encapsulate all components required for infrastructure provisioning and configuration. Each provider is defined by a top-level directory identified by a unique name (e.g., `aws`, `scaleway`, `onprem`). The default location for provider directories is `/usr/share/one/providers`, but this can be customized via the `ONE_LOCATION` setting in your OpenNebula installation.

The following illustrates the usual directory structure of a provider:

```default
providers/
├── aws
│   ├── ansible/
│   ├── terraform/
│   ├── elastic/           # Optional
│   ├── ipam/              # Optional
│   └── provider.yaml
└── onprem
    ├── ansible/
    ├── terraform/
    └── provider.yaml
```

Each component within the provider directory serves a specific purpose:

- **terraform/**: Contains Terraform modules that define and provision the required infrastructure resources, such as hosts, networks, and storage.
- **ansible/**: Stores OneDeploy Ansible playbooks, roles, and templates used for post-provisioning tasks, such as configuring services, installing software packages, and integrating the resources with OpenNebula.
- **ipam/** *(Optional)*: Includes scripts responsible for IP Address Management, handling allocation, registration, and release of IP addresses within the provider.
- **elastic/** *(Optional)*: Holds logic for managing Elastic IPs, including assigning and releasing floating IP addresses to and from Virtual Machines dynamically.
- **provider.yaml**: A YAML file containing essential metadata about the provider, such as its name, description, version, and configuration parameters.

For more information about how to create or modify an existing provider, refer to the [Provider Development Guide]().

## Hypervisor Compatibility

Cloud Providers are compatible with KVM. Compatibility with additional hypervisors, such as LXC, will be added in the future.
