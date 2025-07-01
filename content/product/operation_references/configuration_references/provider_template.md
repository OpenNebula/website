---
title: "Provider Template"
date: "2025-02-17"
description:
categories:
pageintoc: "149"
tags:
weight: "4"
---

<a id="provider-template"></a>

<!-- # Provider Template -->

A Provider Template defines the structure and configuration of a provider in OpenNebula. These templates are stored as **JSON documents** within the OpenNebula database and can be registered using the `oneform register` command. Once registered, the template can be instantiated to create provider instances on demand.

{{< alert title="Note" color="success" >}}
For details on provider and provisioning operations, including registration and instantiation, please refer to the [Cloud Cluster Provisioning Guides]().
{{< /alert >}}

## Template attributes

The following table describes the primary attributes used in Provider templates:

| Attribute           | Description                                                                         |
| ------------------- | ----------------------------------------------------------------------------------- |
| `name`              | Name used to identify the provider.                                                 |
| `description`       | Short summary of the provider's purpose or context.                                 |
| `cloud_provider`    | Internal identifier used to map the provider to its corresponding driver folder.    |
| `version`           | Version string used to track updates to the driver.                                 |
| `fireedge`          | Metadata for the FireEdge UI (e.g., icons, labels or layout information).           |
| `connection`        | Connection parameters and authentication details for accessing the provider.        |
| `user_inputs`       | Definitions of input fields required from users to configure the provider.          |
| `registration_time` | Timestamp indicating when the document was registered.                              |

### Dynamic template generation

Provider templates are dynamically generated from the content within each provider’s directory. OneForm automatically extracts relevant provider parameters directly from the Terraform files within the provider's `terraform` folder. This process includes identifying variables and default values used by Terraform for infrastructure provisioning.

Additional attributes, such as the provider’s name or description, can be manually defined in the `provider.yaml` file. These are automatically merged with the values extracted from the Terraform files during provider template generation.

For more information about providers internal structure and behaviour please refer to the [OneForm Driver Development Guides]().

### User inputs

User inputs represent parameters prompted to the user during template instantiation. These inputs are automatically detected from variable definitions found in the `provider.tf` file within the provider's Terraform directory. Variables lacking default values become required inputs, whereas variables with defaults serve as optional parameters.

For example, a provider’s Terraform variables may look like:

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

What OneForm dynamically interprets and translates into the provider template's inputs is shown below:

```json
{
  // ...
  "PROVIDER_BODY": {
    // ...
    "user_inputs": [
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

In this example, `access_key` and `secret_key` are required user inputs, while `region` is optional since it includes a default value.

User inputs can also define validation rules using the `match` object. In the case of `region`, the validation ensures that the provided value must be one of the predefined values in the list. For more information about User inputs validation rules please refer to the [OneForm Driver Development Guide]().

### Connection details

Connection attributes are automatically generated based on the user inputs provided during instantiation. Typically, these details include region, credentials, or any other fields required to initialize the cloud provider driver.

For example, if a user provides the input `region = eu-west-1`, the resulting connection block might be:

```json
{
  // ...
  "PROVIDER_BODY": {
    // ...
    "connection": {
      "region": "eu-west-1",
      "access_key": "**********************",
      "secret_key": "**********************",
    }
  }
}
```

### Additional Attributes

When a provider template is instantiated, additional attributes are automatically added to the resulting document in OpenNebula. One of these is the `provisions_ids` attribute.

This attribute contains a list of IDs corresponding to the Provisions that have been deployed using this particular provider instance. It is used internally by OneForm to track the relationship between provider documents and the infrastructure they manage.

The example below shows a provider associated with three provisions, referenced by their IDs:

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

Providers are stored as *Documents* in the OpenNebula database. *Documents* are special types of resources in OpenNebula used by OneForm to store templates and information about providers. When a new user Group is created, you can decide if you want to allow/deny its users to create Documents (and also OneForm providers). By default, new groups are allowed to create Document resources.

---

## Full Template Example

Below is an example of a typical Provider template:

```json
{
  "ID": "0",
  "UID": "0",
  "GID": "0",
  "UNAME": "oneadmin",
  "GNAME": "oneadmin",
  "NAME": "AWS",
  "TYPE": "104",
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
      "version": "1.0.0",
      "fireedge": {
        "logo": "aws.png"
      },
      "cloud_provider": "aws",
      "connection": {
        "access_key": "$access_key",
        "secret_key": "$secret_key",
        "region": "$region"
      },
      "user_inputs": [
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
      ],
      "registration_time": 1748504203
    }
  }
}
```
