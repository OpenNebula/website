---
title: "Terraform Provider for OpenNebula"
date: "2025-02-17"
description:
categories:
pageintoc: "266"
tags:
weight: "1"
---

<a id="terraform"></a>

<!--# Terraform OpenNebula Provider -->

Terraform is used to create, manage, and manipulate infrastructure resources (e.g., physical machines, VMs, network switches, containers, etc.). Almost any infrastructure type can be represented as a resource in Terraform. The OpenNebula provider is officially supported by HashiCorp and is fully open source. The repository is available [here](https://github.com/OpenNebula/terraform-provider-opennebula).

The OpenNebula provider is used to interact with OpenNebula resources through Terraform. The provider allows you to manage your OpenNebula clusters resources. It needs to be configured with proper credentials before it can be used.

The official provider documentation can be found [here](https://www.terraform.io/docs/providers/opennebula/index.html).

## Usage

In order to use the OpenNebula Terraform provider, Terraform has to be [installed](https://learn.hashicorp.com/terraform/getting-started/install.html) first. Once Terraform is installed you can start defining the infrastructure:

```default
# Define a new datablockimage
resource "opennebula_virtual_machine" "myfirstvm-tf" {
    ...
}
```

Once `terraform init` is executed with OpenNebula resources defined in any `*.tf` file, the provider will be automatically retrieved by Terraform.

## Building from Source

Another way of using the Terraform provider is building it from source code. A complete guide on how to do this can be found in the provider [repository](https://github.com/OpenNebula/terraform-provider-opennebula#from-source).
