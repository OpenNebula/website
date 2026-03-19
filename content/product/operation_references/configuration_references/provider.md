---
title: "Provider"
date: "2025-02-17"
description:
categories:
pageintoc: "149"
tags:
weight: "4"
---

<a id="provider"></a>

<!-- # Provider -->

A Provider defines the structure and configuration of a external cloud Provider in OpenNebula. These objects are stored as **JSON documents** within the OpenNebula database.

## Provider attributes

The following table describes the primary attributes used in Provider:

| Attribute           | Description                                                                         |
| ------------------- | ----------------------------------------------------------------------------------- |
| `name`              | Name used to identify the Provider.                                                 |
| `description`       | Short summary of the Provider's purpose or context.                                 |
| `driver`            | Internal identifier used to map the Provider to its corresponding driver folder.    |
| `version`           | Version string used to track updates to the driver.                                 |
| `fireedge`          | Metadata for the FireEdge UI (e.g., icons, labels or layout information).           |
| `connection`        | Connection inputs parameters and authentication details for accessing the Provider.        |
| `registration_time` | Timestamp indicating when the document was registered.                              |

### Dynamic template generation

Providers are dynamically generated from the content within each driver's directory. OneForm automatically extracts relevant Provider parameters directly from the Terraform files within the driver's `terraform` folder. This process includes identifying variables and default values used by Terraform for infrastructure provisioning.

Additional attributes, such as the Provider’s name or description, can be manually defined in the `driver.conf` file. These are automatically merged with the values extracted from the Terraform files during Provider template generation.

For more information about Providers' internal structure and behavior please refer to the [OneForm Driver Development Guides]({{% relref "product/integration_references/cloud_provider_driver_development/customizing_driver.md" %}}).

### User inputs

User inputs represent parameters prompted to the user during Provider creation. These inputs are automatically detected from variable definitions found in the `provider.tf` file within the driver's Terraform directory. Variables lacking default values become required inputs, whereas variables with defaults serve as optional parameters.

For example, a Provider’s Terraform variables may look like:

```hcl
variable "access_key" {
    type        = string
    sensitive   = true
    description = "AWS Access Key"
}

variable "secret_key" {
    type        = string
    sensitive   = true
    description = "AWS Secret Key"
}

variable "region" {
    type        = string
    description = "AWS Region"
    default     = "eu-central-1"
}

provider "aws" {
    access_key = var.access_key
    secret_key = var.secret_key
    region     = var.region
}
```

What OneForm dynamically interprets and translates into the Provider's inputs is shown below:

```json
{
  // ...
  "PROVIDER_BODY": {
    // ...
    "connection": [
      {
        "name": "access_key",
        "description": "AWS Access Key",
        "type": "string",
      },
      {
        "name": "secret_key",
        "description": "AWS Secret Key",
        "type": "string",
      },
      {
        "name": "region",
        "description": "AWS Region",
        "type": "string",
        "default": "eu-central-1",
        "match": {
          "type": "list",
          "values": [
            "eu-central-1",
            "eu-west-1"
          ]
        }
      }
    ]
  }
}
```

In this example, `access_key` and `secret_key` are required user inputs, while `region` is optional since it includes a default value. The connection hash is automatically replaced with the values entered by the user during the Provider creation process.

User inputs can also define validation rules using the `match` object. In the case of `region`, the validation ensures that the provided value must be one of the predefined values in the list. For more information about User inputs validation rules please refer to the [OneForm Driver Development Guides]({{% relref "product/integration_references/cloud_provider_driver_development/customizing_driver.md" %}}).

### Additional Attributes

When a Provider is created, additional attributes are automatically added to the resulting document in OpenNebula. One of these is the `provisions_ids` attribute.

This attribute contains a list of IDs corresponding to the Provisions that have been deployed using this particular Provider object. It is used internally by OneForm to track the relationship between Provider documents and the infrastructure they manage.

The example below shows a Provider associated with three Provisions, referenced by their IDs:

```json
{
  // ...
  "PROVIDER_BODY": {
    // ...
    "provisions_ids": [101, 102, 108]
  }
}
```

## Advanced Setup

### Permission to Create Providers

Providers are stored as *Documents* in the OpenNebula database. *Documents* are special types of resources in OpenNebula used by OneForm to store templates and information about Providers. When a new user Group is created, you can decide if you want to allow/deny its users to create Documents (and also OneForm Providers). By default, new groups are allowed to create Document resources.

---

## Full Template Example

Below is an example of a typical Provider document:

```json
{
  "ID": "0",
  "UID": "0",
  "GID": "0",
  "UNAME": "oneadmin",
  "GNAME": "oneadmin",
  "NAME": "AWS",
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
      "name": "AWS",
      "description": "Amazon Web Services",
      "driver": "aws",
      "version": "1.0.0",
      "fireedge": {
        "logo": "aws.png"
      },
      "connection": {
        "access_key": "********************",
        "secret_key": "********************",,
        "region": "us-east-1"
      },
      "provision_ids": [1],
      "registration_time": 1756468598
    }
  }
}

```
