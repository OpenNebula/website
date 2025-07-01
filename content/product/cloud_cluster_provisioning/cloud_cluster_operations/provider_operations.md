---
title: "Managing Providers"
date: "2025-02-17"
description:
categories:
pageintoc: "222"
tags:
weight: "2"
---

<a id="provider-operations"></a>

<!--# Managing Providers -->

In OneForm, **providers** are created from **templates** that define where infrastructure should be instantiated and configured. These templates are generated from **drivers** (e.g., `aws`, `onprem`, `equinix`) using the `oneform` CLI.

This section explains how to:

- Register or unregister provider drivers
- Visualize the generated templates
- Understand how provider and provision templates relate

{{< alert title="Important" color="warning" >}}
All provider information is securely stored and encrypted. For this reason, only users who belong to the `oneadmin` group are allowed to manage them.
{{< /alert >}}

## Registering Provider Drivers

To create a new provider setup, you must first register a driver using the `oneform` command. This will generate:

- A **provider template** that defines how providers should be instantiated.
- A set of **provision templates** that defines how infrastructure will be provisioned using that provider (e.g., SSH-cluster template, HCI Cluster template)

To register a driver (e.g., AWS, OnPrem, Equinix):

```default
$ oneform register <driver_name>
```

**Example:**

```default
$ oneform register aws
```

After execution, all the driver templates will be created and stored in OpenNebula’s database.

{{< alert title="Note" color="success" >}}
Drivers included by default in OpenNebula, such as **aws**, **equinix**, **scaleway**, and **onprem**, can be registered directly using the `oneform register` command. For detailed usage and configuration instructions, refer to each driver's dedicated section in this chapter.

In case you need to develop and register custom drivers, please refer to the [Provider Development Guide]() for step-by-step instructions.
{{< /alert >}}

## Viewing Registered Templates

Once a driver has been registered, you can view the generated templates with:

- List provider templates:

  ```default
  $ oneprovider-template list
    ID USER       GROUP      NAME                       REGTIME
    0  oneadmin   oneadmin   AWS                        06/05 07:36:43
  ```

- List provision templates:

  ```default
  $ oneprovision-template list
    ID USER       GROUP      NAME                       REGTIME
    0  oneadmin   oneadmin   AWS SSH Cluster            06/05 07:36:43
  ```

Each entry corresponds to a specific provider/provision configuration and can be instantiated independently.

## Unregistering a Driver

If you want to remove a driver and its associated templates, use:

```default
$ oneform unregister <driver_name>
```

This will remove the provider driver registration and its generated templates.

{{< alert title="Important" color="warning" >}}
This action will not remove the existing instantiated providers, but it will prevent users from creating new providers and provisions using this driver.
{{< /alert >}}

## Changing Ownership and Permissions

To manage access control for the provider and provision templates associated to the driver, use the following commands:

- **Change permissions**:

  ```default
  $ oneform chmod <driver_name> <octet>
  ```

- **Change owner**:

  ```default
  $ oneform chown <driver_name> <user_id> (<group_id>)
  ```

- **Change group**:

  ```default
  $ oneform chgrp <driver_name> <group_id>
  ```

{{< alert title="Note" color="success" >}}
These operations apply to all provider templates and provision templates resources related to this driver.
{{< /alert >}}
