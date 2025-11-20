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

A *provider* represents a cloud where resources such as hosts, networks, and storage are allocated to implement a provision. Usually, a provider includes a set of account credentials and a zone or region in the intended cloud that will be used to create the resources needed.

## Basic Outline

This guide is structured to help you as a cloud administrator with the following topics:

1. The conceptual model of a Provider in OpenNebula's architecture.
2. The layout of a provider such as Terraform modules, Ansible playbooks and metadata.

Find more about the cloud providers enabled by default with OpenNebula:

- [Amazon AWS Provider]({{% relref "aws_provider#aws-provider" %}})
- [Equinix Provider]({{% relref "equinix_provider#equinix-provider" %}})
- [Scaleway Provider]({{% relref "scaleway_provider#scaleway-provider" %}})
- [On-premises provider]({{% relref "onprem_provider#onprem-provider" %}})

## Logical Model of a Provider

A provider represents a logical cloud endpoint in OpenNebula. It consists of:

- **Account credentials** (API keys, tokens, or certificates), uses to authenticate against the provider cloud API.
- **Region or zone information**, indicating where resources should be provisioned.
- **Metadata files**, which declare static attributes such as the provider’s identifier, description, and version.

These elements are combined through an JSON document stored in the OpenNebula database:

```json
{
  "ID": "0",
  "UID": "0",
  "GID": "0",
  "UNAME": "oneadmin",
  "GNAME": "oneadmin",
  "NAME": "AWS Provider",
  "TYPE": "103",
  "PERMISSIONS": {
    "OWNER_U": "1",
    "OWNER_M": "1",
    "OWNER_A": "0",
    "GROUP_U": "0",
    "GROUP_M": "0",
    "GROUP_A": "0",
    "OTHER_U": "0",
    "OTHER_M": "0",
    "OTHER_A": "0"
  },
  "TEMPLATE": {
    "PROVIDER_BODY": {
      "name": "AWS Provider",
      "description": "AWS Provider in Virginia",
      "driver": "aws",
      "version": "1.0.0",
      "fireedge": {
        "logo": "aws.png"
      },
      "connection": {
        "access_key": "******************",
        "secret_key": "*************************",
        "region": "us-east-1"
      },
      "provision_ids": [
        1
      ],
      "registration_time": 1756468598
    }
  }
}
```

For more information about Provider datamodels and configuration, refer to [Provider](/product/operation_references/configuration_references/provider.md).

## Provider Structure

A provider in OpenNebula relies on the information extracted from the drivers located in a modular directory structure that encapsulates all components required for infrastructure provisioning and configuration. Each driver is defined by a top-level directory identified by a unique name, such as `aws`, `scaleway`, and `onprem`. The default location for driver directories is `/usr/share/one/oneform/drivers`, but you can customize the location via the `ONE_LOCATION` setting in your OpenNebula installation.

The following illustrates the directory structure of a driver:

```default
drivers/
├── aws
│   ├── ansible/
│   ├── terraform/
│   ├── elastic/           # Optional
│   ├── ipam/              # Optional
│   └── driver.conf
└── onprem
    ├── ansible/
    ├── terraform/
    └── driver.conf
```

Each component within the driver directory serves a specific purpose:

- **terraform/**: contains Terraform modules that define and provision the required infrastructure resources, such as hosts, networks, and storage.
- **ansible/**: stores OneDeploy Ansible playbooks, roles, and templates used for post-provisioning tasks, such as configuring services, installing software packages, and integrating the resources with OpenNebula.
- **ipam/** *(Optional)*: includes scripts responsible for IP Address Management, handling allocation, registration, and release of IP addresses within the provider.
- **elastic/** *(Optional)*: holds logic for managing Elastic IPs, including assigning and releasing floating IP addresses to and from Virtual Machines dynamically.
- **driver.conf**: a YAML file containing essential metadata about the driver, such as its name, description, version, and other configuration parameters.

For more information about how to create or modify an existing driver, refer to the [Provisioning Drivers](/product/integration_references/cloud_provider_driver_development/) guide.


## Hypervisor Compatibility

OneForm drivers are compatible with KVM. Compatibility with additional hypervisors, such as LXC, will be added in the future.
