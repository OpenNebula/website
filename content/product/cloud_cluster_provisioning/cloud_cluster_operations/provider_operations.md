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

In OneForm, providers are created directly from external cloud drivers such as AWS, Scaleway and Equinix. Define with the `oneform` CLI your cloud infrastructure instance and configuration.

With this guide, you will understand how the drivers and providers and provisions relate by: 

- enabling and disabling cloud drivers.
- managing access controls

{{< alert title="Important" color="warning" >}}
All driver information is securely stored and encrypted. While regular users can list and view driver information, only members of the `oneadmin` group are allowed to manage and modify providers.
{{< /alert >}}

## Enabling a OneForm Driver

To use a new cloud driver, enable the driver using the `oneform enable` command. This validates all the information about the driver and allows users to create providers and provisions based on this driver.

```bash
$ oneform enable <driver_name>
```

After running the command, you will see that all the driver templates are created and stored in OpenNebula’s database.

{{< alert title="Note" color="success" >}}
Drivers included by default in OpenNebula - such as **aws**, **equinix**, **scaleway**, and **onprem** - are already enabled after a fresh OpenNebula installation. For detailed usage and configuration instructions, refer to each driver's dedicated section in this chapter.

In case you need to develop and enable custom drivers, refer to the [Provider Development Guide](/product/integration_references/cloud_provider_driver_development/) for step-by-step instructions.
{{< /alert >}}

## Disabling a OneForm Driver

To disable a driver in OpenNebula, run the `oneform disable` command. 

```bash
$ oneform disable <driver_name>
```

{{< alert title="Important" color="warning" >}}
This action will not remove the existing instantiated providers and provisions, but it will prevent users from creating new providers and provisions using this driver.
{{< /alert >}}

## Managing Access Controls

To manage access control for the provider and provision associated to the driver, execute these commands:

- Changing permissions

  ```bash
  $ oneprovider chmod <provider_id> <octet>
  $ oneprovision chmod <provision_id> <octet>
  ```

- Changing owners

  ```bash
  $ oneprovider chown <provider_id> <user_id> (<group_id>)
  $ oneprovision chown <provision_id> <user_id> (<group_id>)
  ```

- Changing groups

  ```bash
  $ oneprovider chgrp <provider_id> <group_id>
  $ oneprovision chgrp <provision_id> <group_id>
  ```
