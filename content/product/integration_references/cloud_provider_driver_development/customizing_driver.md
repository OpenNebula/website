---
title: "Customizing a Provisioning Driver"
linkTitle: "Customization"
date: "2025-02-17"
description:
categories:
pageintoc: "211"
tags:
weight: "3"
---

Here you will find detailed instructions on customizing and extending existing drivers in OneForm. It covers common scenarios such as adding new zones, modifying resources, adding user inputs, and configuring new images or operating systems.

## Adding New User Inputs

There are two ways to introduce user inputs: Terraform variables and Jinja2 templates.

### Inputs via Terraform Variables

Declare the variable in `variables.tf`. Optionally, add custom validations in `validators.tf`.

Example `variables.tf`:

```hcl
variable "disk_size" {
  description = "Disk size for the instance"
  type        = number
  default     = 50
}
```

Validator (`validators.tf`):

```hcl
locals {
  validators = {
    disk_size = {
      type   = "number"
      values = { min = 20, max = 200 }
    }
  }
}
```

### Inputs via Jinja2 Templates

If the input affects provisioning configuration or other non-Terraform elements, like IPAM configurations, define it in the Jinja2 metadata within `ansible/templates`.

Example `templates/mycluster.j2`:

```yaml
{#
name: My Cluster
description: Just an awesome cluster
user_inputs:
  - name: my_custom_attr
    description: Some custom attribute added to my provision
    type: number
    default: 2
    match:
      type: number
      values:
        min: 0
        max: 10
#}

---
all:
  vars:
    my_custom_value: {{ user_inputs.my_custom_attr }}
    # other attributes ...
```

## Adding New Zones

In OneForm drivers, zones are primarily used for logical grouping or for defining specific availability zones in cloud providers. Zones are freely defined because any input provided by the user is directly passed to Terraform. However, usually, zone choices are constrained by validators.

To add new zones, you must extend the validators defined in `validators.tf` as shown below.

Current validator configuration:

```hcl
locals {
  validators = {
    zone = {
      type   = "list"
      values = ["us-east-1a", "us-east-1b"]
    }
  }
}
```

Updated validator with a new zone:

```hcl
locals {
  validators = {
    zone = {
      type   = "list"
      values = ["us-east-1a", "us-east-1b", "us-east-1c"]
    }
  }
}
```

With this change, users are able to select the new zone `us-east-1c` from the provided dropdown list when creating the provision.

## Adding new Images and OS Versions

Terraform enables dynamic configuration of machine images, like AMIs, through data sources. These resources can be exposed as user-selectable inputs.

For this example, define multiple OS images using Terraform data sources:

```hcl
data "mycloud_image" "ubuntu_2204" {
  filter {
    name   = "name"
    values = ["ubuntu-22.04-*"]
  }
}

data "mycloud_image" "ubuntu_2004" {
  filter {
    name   = "name"
    values = ["ubuntu-20.04-*"]
  }
}

locals {
  registered_instance_os_name = {
    "ubuntu_2204" = data.mycloud_image.ubuntu_2204.id
    "ubuntu_2004" = data.mycloud_image.ubuntu_2004.id
  }
}
```

Then create a validator to ensure users select from the registered OS versions:

```hcl
locals {
  validators = {
    instance_os_name = {
      type   = "list"
      values = ["ubuntu_2204", "ubuntu_2004"]
    }
  }
}
```

Finally, define the variable to allow user selection from user inputs:

```hcl
variable "instance_os_name" {
  description = "Operating system"
  type        = string
  default     = "ubuntu_2204"
}
```

You can use it safely in any configured resource:

```hcl
resource "mycloud_instance" "vm" {
  image_id = local.registered_instance_os_name[var.instance_os_name]
}
```

## Modifying Terraform Resources

Since all infrastructure resources in OneForm are managed via Terraform, modify existing resources or create new ones following standard Terraform practices.

OneForm executes operations on the root Terraform module (`terraform/main.tf`). Any Terraform-compatible change to the resources declared in this module is recognized by OneForm.

For example, to modify an existing instance type:

Current configuration (`main.tf`):

```hcl
resource "mycloud_instance" "vm" {
  type = var.instance_type
}
```

Updated configuration:

```hcl
resource "mycloud_instance" "vm" {
  type = var.instance_type
  auto_placement = "on"
  # other attributes ...
}
```

Alternatively, use a variable to allow user customization of this new attribute:

```hcl
# variables.tf
variable "instance_auto_placement" {
  description = "Enable or disable instance auto placement behaviour"
  type        = boolean
  default     = true
}

# ---

# main.tf
resource "mycloud_instance" "vm" {
  type = var.instance_type
  auto_placement = var.instance_auto_placement
  # other attributes ...
}
```
