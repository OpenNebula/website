---
title: "Developing a Provisioning Driver"
date: "2025-06-05"
description:
categories:
pageintoc: "211"
tags:
weight: "3"
---

This document provides a detailed step-by-step guide to creating a new provisioning driver for OpenNebula Formation. It covers all the necessary components starting with the basic configuration, infrastructure provisioned using Terraform, and post-deployment configuration handled by Ansible.

{{< alert title="Important" color="warning" >}}
Please note that creating a driver requires working knowledge of both **Terraform** and **Ansible**, as they are fundamental to the provisioning and configuration workflows.
{{< /alert >}}

## Getting Started from Scratch

A driver in OneForm is a self-contained directory that bundles everything required to provision and configure infrastructure. It integrates with OpenNebula and OneForm to automate deployments across various providers.

An OneForm driver must include at least the following elements:

- A **`provider.yaml`** file: Defines the basic metadata and UI configuration.
- A **`terraform/`** directory: Contains all the Terraform logic used to provision resources.
- An **`ansible/`** directory: Contains playbooks and templates to configure the infrastructure after it has been deployed.

Optionally, but recommended if the cloud provider supports it, a driver can also include the following directories:

- **`ipam/`**: Contains optional scripts to manage IP address allocation and release. These scripts integrate with OpenNebula’s Virtual Network Manager to assign internal IPs to virtual machines dynamically.
- **`elastic/`**: Implements logic to allocate and release public IP addresses from cloud providers. This is useful when creating public virtual networks that require internet-facing IPs.

Here’s what a typical driver directory structure looks like:

```default
mycloud/
├── provider.yaml
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── provider.tf
│   └── validators.tf
├── ansible/
│   ├── ansible.cfg
│   ├── inventory.yaml
│   ├── site.yaml
│   └── templates/
│       └── mycluster.j2
├── ipam/               # optional
│   ├── allocate_address
│   ├── free_address
│   ├── get_address
│   ├── register_address_range
│   └── unregister_address_range
└── elastic/            # optional
    └── mycloud_vnm.rb
```

Each of these elements plays a specific role in the provisioning and configuration process. During the next sections, we are going to cover all the required files that are needed to create your own custom driver.

## Basic driver information

The `provider.yaml` file contains the basic metadata for your driver. It defines key information about the provider and how it should appear in the OneForm interface.

Here is a standard structure:

```yaml
name: 'MyCloud'
description: 'MyCloud Infrastructure Provider'
version: '1.0.0'
fireedge:
  logo: 'mycloud.png'
```

Below is a summary of the fields:

| Field           | Description                                                        |
| --------------- | ------------------------------------------------------------------ |
| `name`          | A short, unique name to identify the provider.                     |
| `description`   | A short description of the provider and its purpose.               |
| `version`       | The driver version. Useful for tracking compatibility and updates. |
| `fireedge.logo` | Path to a logo image to be displayed in the Sunstone UI.           |

## Terraform Configuration

Every driver must include the following required files inside the Terraform subdirectory:

```default
mycloud/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── provider.tf
│   └── validators.tf
...
```

### main.tf

This is the main file that contains the core deployment logic. Here you define all the Terraform resources required by your infrastructure, such as hosts, VPCs, subnets, and more.

It's highly recommended to organize your code using modules, since this improves readability and maintainability, especially in complex deployments. You can create a module for each logical resource type (e.g., cluster, host) within the `terraform/` directory and reference them from `main.tf` as shown below:

```hcl
module "cluster" {
  source       = "./cluster"
  cidr_block   = var.cidr_block
}

module "host" {
  source             = "./host"
  oneform_hosts      = var.oneform_hosts
  instance_type      = var.instance_type
  instance_os_name   = var.instance_os_name
  instance_disk_size = var.instance_disk_size
  cloud_tags         = var.oneform_tags
}
```

### variables.tf

Defines the input variables required to deploy the infrastructure. These are automatically detected by OneForm to generate user inputs:

```hcl
variable "cidr_block" {
  description = "CIDR block for the private network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "oneform_hosts" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "Instance type to use"
  type        = string
  default     = "standard.medium"
}

variable "instance_os_name" {
  description = "Operating system for the instance"
  type        = string
  default     = "ubuntu_2204"
}

variable "instance_disk_size" {
  description = "Root disk size"
  type        = number
  default     = 100
}

variable "oneform_tags" {
  description = "Tags to assign to the instances"
  type        = map(string)
  default     = {}
}
```

> **Best Practices:**
>
> - Use the prefix `instance_` for variables related to the host configuration.
> - Avoid to use the prefix `oneform_`, since it is reserved for variables that affect OneForm behavior (like `oneform_hosts`).
> - **Always** add descriptions to each variable, as these descriptions are used to display the variables purpose to users who interact with the driver.

OneForm automatically parses each variable declared in `variables.tf`, using the `type` and `default` fields to build its user input interface. These user inputs are then exposed to the user when instantiating a provision template, and validated against the expected type. If no value is supplied, the `default` will be used.

Here is an example of how OneForm interprets these variables and add them to a provision template:

```json
{
  "name": "oneform_hosts",
  "description": "Number of instances to create",
  "type": "number",
  "default": 1,
  "match": {
    "type": "number",
    "values": {
      "min": 1,
      "max": 10
    }
  }
},
{
  "name": "instance_type",
  "description": "Instance type to use for the instance",
  "type": "string",
  "default": "c5.metal",
  "match": {
    "type": "list",
    "values": ["c5.metal", "m5.large"]
  }
}
```

While Terraform's native validation handles types and defaults, OneForm lets you define additional custom validation logic using the `validators.tf` file, covered later in this guide.

### outputs.tf

This file defines the output values that Terraform returns once infrastructure has been provisioned. These outputs are essential for OneForm to track and configure the deployed resources.

It is mandatory that the root module of the Terraform code returns at least two values per deployed instance inside an array named as `provisioned_hosts`:

- **`instance_id`**: This is the unique identifier of each virtual machine created by the provider. OneForm uses this value internally to track the instance lifecycle, associate public IPs, and manage resource orchestration.
- **`instance_ip`**: This is the public (or private, depending on the deployment) IP address of the provisioned host. It is used to establish an SSH connection so Ansible can perform configuration tasks on the host.

If these outputs are not present, OneForm will not be able to proceed with post-provisioning operations like inventory generation or system setup.

Here is a typical example:

```hcl
output "provisioned_hosts" {
  value = [
    for idx in range(length(module.host.id)) : {
      instance_id = module.host.id[idx]
      instance_ip = module.host.public_ip[idx]
    }
  ]
}
```

### provider.tf

This file defines provider-specific configuration, usually including credentials and region parameters. This file is especially important since all variables declared in `provider.tf` are automatically parsed by OneForm and exposed as required inputs when a user instantiates a provider template.

In addition, OneForm automatically builds the `connection` section of the provider template using these variables. This section is used internally when provisioning infrastructure so that the driver has access to the required authentication and configuration details.

Here’s an example of a `provider.tf` file containing Terraform variables:

```hcl
terraform {
  required_providers {
    mycloud = {
      source  = "myorg/mycloud"
      version = "~> 1.0"
    }
  }
}

variable "api_key" {
  type        = string
  sensitive   = true
  description = "API key for the provider"
}

variable "region" {
  type        = string
  description = "Deployment region"
  default     = "us-central-1"
}

provider "mycloud" {
  api_key = var.api_key
  region  = var.region
}
```

From this, OneForm will automatically generate the following structure in the provider template:

```json
{
  "name": "MyCloud",
  "description": "MyCloud Infrastructure Provider",
  "version": "1.0",
  "cloud_provider": "mycloud",
  "connection": {
    "api_key": "$api_key",
    "region": "$region"
  },
  "user_inputs": [
    {
      "name": "api_key",
      "description": "API key for the provider",
      "type": "string"
    },
    {
      "name": "region",
      "description": "Deployment region",
      "type": "string",
      "default": "us-central-1",
      "match": {
        "type": "list",
        "values": ["us-central-1", "us-central-2"]
      }
    }
  ]
}
```

Just like with `variables.tf`, you can also extend the native validation by adding custom rules in the `validators.tf` file as it is explained in the next point.

### validators.tf

This optional file allows you to define additional custom validations for user inputs. It uses Terraform local variables to describe constraints that go beyond the native validation defined in `variables.tf`.

Each validator is declared inside a `locals` block under the `validators` object. Every key inside `validators` must exactly match the name of a variable declared in `variables.tf`. This is how OneForm links the validator definition with the corresponding input.

Each validator supports different types:

- `list`: Validates that the input is one of the predefined values. You must provide a `values` array of accepted strings.
- `number`: Validates that the input falls within a numeric range. Use the `values` object with `min`, `max`, or both.
- `string`: Validates that the input matches a given regular expression pattern. In this case, the `values` field must include a `regex` key.
- `map`: Allows for nested validations. You can use the `grouped_by` field to relate two variables (e.g., a zone must belong to a selected region). The `values` field must then contain a map where keys are the parent variable’s values and each key maps to a list of valid child values.

Here’s a generic example:

```hcl
locals {
  validators = {
    # List validator example
    instance_type = {
      type   = "list"
      values = ["standard.small", "standard.medium", "standard.large"]
    }

    # Number range validator example
    oneform_hosts = {
      type   = "number"
      values = {
        min = 1
        max = 10
      }
    }

    # String validator with regex pattern
    hostname = {
      type   = "string"
      values = {
        regex = "^[a-z0-9-]{3,15}$"
      }
    }

    # Map validator with grouping logic
    region = {
      type   = "list"
      values = ["fr-par", "nl-ams", "pl-waw"]
    }

    zone = {
      type       = "map"
      grouped_by = "region"
      values = {
        fr-par = ["fr-par-1", "fr-par-2", "fr-par-3"]
        nl-ams = ["nl-ams-1", "nl-ams-2", "nl-ams-3"]
        pl-waw = ["pl-waw-1", "pl-waw-2", "pl-waw-3"]
      }
    }
  }
}
```

Each validator, when interpreted by OneForm, is added to the `match` section of the corresponding user input. This section defines the input validation rules that will be applied at runtime. Here's how the output looks for a variable like `instance_type`:

```json
{
  "name": "instance_type",
  "description": "Instance type to use",
  "type": "string",
  "default": "standard.medium",
  "component": "terraform",
  "match": {
    "type": "list",
    "values": ["standard.small", "standard.medium", "standard.large"]
  }
}
```

## Ansible

Ansible handles post-deployment configuration. A driver must include the following required files inside the Ansible subdirectory:

```default
mycloud/
├── ansible/
│   ├── ansible.cfg
│   ├── inventory.yaml
│   ├── site.yaml
│   └── templates/
│       └── mycluster.j2
...
```

### ansible.cfg

This file contains the base configuration needed for Ansible to interact correctly with OneForm and the dynamic inventory system.

The following configuration block should be used as-is (although depending on the provider or the target host configuration, it might vary slightly). The only fields that may need to be adjusted are:

- `inventory_plugins`: This should point to the path where the dynamic inventory plugin `opennebula_form` is located.
- `collections_path`: This should point to the directory where the OneDeploy Ansible collections are installed.

These paths may vary if OpenNebula has been installed in a custom location; if not, they can be left as their default values.

Below is the recommended configuration:

```default
[defaults]
interpreter_python = /usr/bin/python3
library    = ./roles
roles_path = ./roles
inventory_plugins  = /usr/share/one/ansible/plugins/inventory
collections_path   = /usr/share/one/one-deploy
callback_whitelist = profile_tasks
display_skipped_hosts = False
retry_files_enabled   = False
host_key_checking     = False
allow_world_readable_tmpfiles = True

[privilege_escalation]
become = True
become_user = root

[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s
```

### site.yaml

This is the main playbook executed by Ansible and must exist in every driver. It is responsible for orchestrating all post-deployment configuration steps.

At a minimum, this file should import the main playbook from OneDeploy (`opennebula.deploy.main`) to ensure proper integration with OpenNebula.

You can include as many custom tasks or additional playbooks as needed before or after the OneDeploy execution. This flexibility allows for additional configuration steps such as installing custom software, registering metadata, or performing health checks.

It is strongly recommended to include the host connectivity check at the beginning of the playbook. This step ensures that the remote servers are reachable and ready to be configured via SSH before proceeding with the rest of the playbook.

Additionally, every task, apart from OneDeploy, should include the tag `tags: always` to ensure its execution, since by default, OneForm only runs tasks tagged as `stage2` and `stage3` for post-provisioning steps, which is necessary for OneDeploy to function properly. These default tags can be customized in the OneForm configuration file located by default at `/etc/one/oneform-server.conf`.

```yaml
---
- name: Check hosts connectivity
  hosts: all
  gather_facts: false
  tasks:
    - name: Wait for hosts to be up
      ansible.builtin.wait_for_connection:
        timeout: 300
    - name: Wait for hosts to be reachable through SSH
      wait_for:
        host: "{{ ansible_host }}"
        port: 22
        state: started
        timeout: 60
  tags: always

# -------------------------------------------------------
# One-deploy playbooks
# -------------------------------------------------------

- ansible.builtin.import_playbook: opennebula.deploy.main

# -------------------------------------------------------
# Other playbooks (optional)
# -------------------------------------------------------

# - name: 'Example role'
#   hosts: all
#   tasks:
#     - name: 'Example task'
#       ansible.builtin.debug:
#         msg: 'Hello, world!'
#   tags: always

```

### inventory

OneForm uses a custom dynamic inventory plugin to configure provisions. A dynamic inventory is a mechanism that generates host information on-the-fly, based on live data from a source—in this case, a OneForm provision.

In OneForm, dynamic inventories are powered by the `opennebula_form` plugin, which automatically connects to the OpenNebula backend and retrieves real-time deployment details for each provisioned host.

These values are then injected into the Jinja2 inventory template defined in the `templates/` directory, allowing dynamic rendering of host lists, variables, network mappings, and datastore references.

To enable this mechanism, you must declare a basic inventory source using the plugin:

````yaml

```yaml
plugin: opennebula_form
````

### Jinja2 templates

Each file inside the `templates/` directory that uses Jinja2 syntax and includes the necessary metadata block (commented YAML at the top) is treated by OneForm as a separate provision template:

```yaml
{#
name: AWS SSH Cluster
description: It deploys a SSH cluster on AWS
fireedge:
  logo: "aws_ssh_cluster.png"
user_inputs:
  - name: instance_public_ips
    description: Number of public IPs to allocate
    type: number
    default: 0
    match:
      type: number
      values:
        min: 0
        max: 5
#}

---

# Jinja2 template content
```

This metadata is used by OneForm to define the provision template name, description and any custom user inputs. These user inputs can include validation rules using the same format shown earlier in the `variables.tf` and `validators.tf` sections.

In addition to defining how infrastructure is mapped into Ansible groups, these templates also specify the objects that OneForm will register as part of the `one_objects` structure. This includes virtual networks, datastores, and host definitions that will be configured during provisioning.

For example, OneForm will extract the following from a template like this:

```json
{
  "name": "Example Cluster",
  "description": "Deploys a sample cluster",
  "user_inputs": [...],
  "one_objects": {
    "cluster": {},
    "hosts": [],
    "networks": [...],
    "datastores": [...]
  }
}
```

These values are parsed from the metadata and Jinja structure and become part of the internal representation of the provision template within OneForm.

Here’s an example of a Jinja2 inventory template that includes metadata and defines the full infrastructure mapping:

```jinja2
---
all:
  vars:
    ansible_user: root
    one_version: {{ one.version }}
    vn:
      private_network:
        managed: true
        template:
          phydev: enp125s0
          vn_mad: vxlan
          vxlan_mode: evpn
          vlan_id: automatic
          dns: 8.8.8.8
          gateway: 192.168.0.1
          ip_link_conf: nolearning=
          ar:
            - type: IP4
              ip: 192.168.0.100
              size: 100
      public_network:
        managed: true
        template:
          vn_mad: elastic
          bridge: br0
          netrole: public
          vxlan_mode: evpn
          vxlan_tep: dev
          ip_link_conf: nolearning=
    ds:
      mode: generic
      config:
        SYSTEM_DS:
          system_ds:
            id: {{ one.system_ds_id}}
            template:
              type: SYSTEM_DS
              tm_mad: ssh
              safe_dirs: /var/tmp /tmp
        IMAGE_DS:
          image_ds:
            id: {{ one.image_ds_id }}
            template:
              type: IMAGE_DS
              ds_mad: fs
              tm_mad: ssh
              safe_dirs: /var/tmp /tmp

frontend:
  hosts:
    f1: { ansible_user: root, ansible_host: {{ one.frontend_ip}} }

node:
  hosts:
    {% for node in one.nodes %}
    n{{ loop.index }}: { ansible_user: root, ansible_host: {{ node }} }
    {% endfor %}
```

#### Available Variables in Jinja2 Template

When a Jinja2 inventory template is rendered, it receives a structured dataset that includes all the information needed to generate the complete inventory. The most relevant structures are:

| Variable            | Description                                                                      |
| ------------------- | -------------------------------------------------------------------------------- |
| `id`                | ID of the provision template.                                                    |
| `name`              | Name of the provision template.                                                  |
| `description`       | Short description shown in the interface.                                        |
| `deployment_file`   | File name (without extension) used to identify the template inside `templates/`. |
| `fireedge`          | Optional UI metadata (e.g., logo).                                               |
| `user_inputs`       | Key-value pairs of inputs defined by the user or defaulted by the template.      |
| `state`             | Current lifecycle state of the provision.                                        |
| `provider_id`       | ID of the associated provider.                                                   |
| `registration_time` | UNIX timestamp of when the template was registered.                              |
| `one`               | Runtime deployment info for OpenNebula (see below).                              |

Inside the `one` object, the following fields are available:

| `one` Field    | Description                                                         |
| -------------- | ------------------------------------------------------------------- |
| `version`      | OpenNebula version which provision is configuring.                  |
| `frontend_ip`  | IP address of the OpenNebula frontend used for remote config.       |
| `nodes`        | List of host IPs that have been provisioned and will be configured. |
| `network_ids`  | IDs of the networks created during provisioning.                    |
| `system_ds_id` | ID of the system datastore assigned to the provision.               |
| `image_ds_id`  | ID of the image datastore assigned to the provision.                |

This information can be used to dynamically build inventories and infrastructure declarations.

Example usage:

```jinja2
one_version: {{ one.version }}
user_value: {{ user_inputs.custom_value }}
```

## Elastic and IPAM Integration

In addition to Terraform and Ansible logic, drivers may also include optional support for Elastic and IPAM drivers:

- **Elastic driver**: Automates the request and release of public IP addresses from the cloud provider. This is useful for virtual etworks that require internet access.
- **IPAM driver**: Manages internal IP address allocation and ensures each VM receives a valid and unique IP during provisioning.

Both components are fully supported by OneForm and integrated into the networking phase. For detailed information on how to implement and configure them, refer to the dedicated [Elastic and IPAM Drivers section]().

Here is an example of how these drivers should be added to the driver directory:

```default
mycloud/
│
├── ipam/
│   ├── allocate_address
│   ├── free_address
│   ├── get_address
│   ├── register_address_range
│   └── unregister_address_range
├── elastic/
│   └── mycloud_vnm.rb
...
```

## A Complete Example

To see a full implementation of a production-ready driver, you can explore the official AWS driver in the OpenNebula GitHub repository:

> 👉 [View OneForm AWS Provisioning Driver on GitHub]()
