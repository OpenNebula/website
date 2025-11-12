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

In OneForm, providers are created directly from external cloud drivers (e.g., `aws`, `scaleway`, `equinix`) using the oneform CLI, defining where infrastructure should be instantiated and configured.

This section explains how to:

- Enable or disable cloud drivers
- Visualize the drivers information
- Understand how the drivers and providers and provisions relate

{{< alert title="Important" color="warning" >}}
All driver information is securely stored and encrypted. While regular users can list and view driver information, only members of the `oneadmin` group are allowed to manage and modify providers.
{{< /alert >}}

## Enabling OneForm Drivers

To use a new clud driver, you must first enable the driver using the `oneform enable` command. This will validate all the information about the driver and will allow users to create providers and provisions based on this driver.

```default
$ oneform enable <driver_name>
```

After execution, all the driver templates will be created and stored in OpenNebula’s database.

{{< alert title="Note" color="success" >}}
Drivers included by default in OpenNebula, such as **aws**, **equinix**, **scaleway**, and **onprem**, are already enabled after a fresh OpenNebula installation. For detailed usage and configuration instructions, refer to each driver's dedicated section in this chapter.

In case you need to develop and enable custom drivers, please refer to the [Provider Development Guide]() for step-by-step instructions.
{{< /alert >}}

## Disabling a OneForm Driver

If you want to disable a driver in OpenNebula, you can use the `oneform disable` command. 

```default
$ oneform disable <driver_name>
```

{{< alert title="Important" color="warning" >}}
This action will not remove the existing instantiated providers and provisions, but it will prevent users from creating new providers and provisions using this driver.
{{< /alert >}}

## Changing Ownership and Permissions

To manage access control for the provider and provision associated to the driver, you can use the following commands:

- **Change permissions**:

  ```default
  $ oneprovider chmod <provider_id> <octet>
  $ oneprovision chmod <provision_id> <octet>
  ```

- **Change owner**:

  ```default
  $ oneprovider chown <provider_id> <user_id> (<group_id>)
  $ oneprovision chown <provision_id> <user_id> (<group_id>)
  ```

- **Change group**:

  ```default
  $ oneprovider chgrp <provider_id> <group_id>
  $ oneprovision chgrp <provision_id> <group_id>
  ```
