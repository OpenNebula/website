---
title: "Cluster Providers Overview"
linkTitle: "Overview"
date: "2025-02-17"
description:
categories:
pageintoc: "204"
tags:
weight: "1"
---

<!--# Overview -->
A **Provider** is an abstraction layer that defines the credentials, endpoints, and specific locations (such as a region or zone) within a target infrastructure. It acts as the "source of authority" that OneForm uses to authenticate and communicate with external resources — whether they are public cloud APIs (like AWS), bare-metal edge locations (like Equinix), or on-premises resources — to prepare the ground for a Cluster deployment.

## Basic Outline

This guide is structured to help you as a cloud administrator understand the following topics:

1. The conceptual model of a Provider in OpenNebula's architecture.
2. The layout of a Provider such as Terraform modules, Ansible playbooks and metadata.

An on-premises Provider is installed by default with OpenNebula, refer to the [On-premises Provider Guide]({{% relref "onprem_provider#onprem-provider" %}}) for details.

Provider drivers for 3rd-party IaaS cloud providers can be installed in your OpenNebula deployment. The Provider drivers are available in the [OneForm Registry Repository](https://github.com/OpenNebula/oneform-registry) in the [OpenNebula GitHub Project](https://github.com/OpenNebula). Instructions for installing and synchronizing the 3rd-party Provider drivers can be found in the [OneForm Registry Wiki](https://github.com/OpenNebula/oneform-registry/wiki). After installing the drivers, you can find additional guides in the Wiki to create Providers for the following cloud/bare-metal services:

- [Amazon AWS Provider](https://github.com/OpenNebula/oneform-registry/wiki/Amazon-Web-Services-Provider)
- [i3Dnet Provider](https://github.com/OpenNebula/oneform-registry/wiki/i3Dnet-Provider)
- [Scaleway Provider](https://github.com/OpenNebula/oneform-registry/wiki/Scaleway-Provider)

## Logical Model of a Provider

A Provider represents a logical Cluster endpoint in OpenNebula. It consists of:

- **Account Credentials**: API keys, tokens, or certificates. Used to authenticate against the provider cloud API.
- **Region or Zone Information**: Indicating where resources should be provisioned.
- **Metadata Files**: Used to declare static attributes such as the Provider’s identifier, description, and version.

These elements are combined through a JSON document stored in the OpenNebula database like in the following example:

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

For more detailed information about Provider datamodels and configuration, refer to the [Provider Reference]({{% relref "/product/operation_references/configuration_references/provider.md" %}}).

## Provider Drivers

Each Provider in OpenNebula is associated with a **Provider driver** that defines the underlying automation logic for infrastructure provisioning and configuration. A driver defines the logic for communicating with a specific cloud IaaS API or bare-metal hardware resource while the Provider defines the credentials, location and metadata. Therefore, a single driver is associated with a specific IaaS service (e.g. AWS, Equinix, Scaleway) while multiple Providers may use the same driver. For example, if you wish to use resources in multiple AWS regions, you must create a separate Provider for each AWS region, using the same AWS driver.  

### Driver Structure

Each driver is defined by a top-level directory identified by a unique name, such as `aws`, `scaleway`, or `onprem`. The default location for driver directories is `/usr/share/one/oneform/drivers`, but you can customize the location via the `ONE_LOCATION` setting in your OpenNebula installation.

The following illustrates the directory structure of a Provider driver:

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

- **terraform/**: Contains Terraform modules that define and provision the required infrastructure resources, such as Hosts, networks, and storage.
- **ansible/**: Stores OneDeploy Ansible playbooks, roles, and templates used for post-provisioning tasks, such as configuring services, installing software packages, and integrating the resources with OpenNebula.
- **ipam/** *(Optional)*: Includes scripts responsible for IP Address Management, handling allocation, registration, and release of IP addresses within the provider.
- **elastic/** *(Optional)*: Holds logic for managing Elastic IPs, including assigning and releasing floating IP addresses to and from Virtual Machines dynamically.
- **driver.conf**: A YAML file containing essential metadata about the driver, such as its name, description, version, and other configuration parameters.

For more information about how to create or modify an existing driver, refer to the [Provisioning Drivers Guide]({{% relref "/product/integration_references/cloud_provider_driver_development/" %}}).


## Hypervisor Compatibility

OneForm drivers are compatible with KVM. Compatibility with additional hypervisors, such as LXC, will be added in the future.
