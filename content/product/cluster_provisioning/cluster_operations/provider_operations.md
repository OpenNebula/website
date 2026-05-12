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

In OneForm, Providers are created using Provider drivers for on-premise hardware or 3rd-party cloud/bare-metal services such as AWS, Scaleway and i3Dnet. Use the `oneform` CLI tool to manage your cloud infrastructure instance and configuration.

With this guide, you will understand how the drivers and Providers and Provisions relate by: 

- Enabling and disabling cloud drivers.
- Managing access controls

{{< alert title="Important" type="warning" >}}
All driver information is securely stored and encrypted. While regular users can list and view driver information, only members of the `oneadmin` group are allowed to manage and modify Providers.
{{< /alert >}}

## Enabling a OneForm Driver

To use a new cloud driver, enable it using the `oneform enable` command. This validates all the information about the driver and allows users to create Providers and Provisions based on the driver.

```bash
oneform enable <driver_name>
```

After running the command, you will see that all the driver templates are created and stored in OpenNebula’s database.

## Additional Drivers

Only the **onprem** driver is included by default in a fresh OpenNebula installation with OneForm. To install and enable other drivers, such as **aws**, **i3dnet** and **scaleway**, you need to clone the [OneForm Registry repository](https://github.com/OpenNebula/oneform-registry) onto the OpenNebula Front-end with the following commands as the `oneadmin` user:

```bash
git -C /var/lib/one/oneform/drivers clone https://github.com/OpenNebula/oneform-registry.git
```

Then synchronize oneform:

```bash
oneform sync
```

After completing these commands, additional drivers will be available. Run `oneform list` to see all available drivers.

If you wish to develop and enable custom drivers, refer to the [Provider Development Guide]({{% relref "/product/integration_references/cloud_provider_driver_development/" %}}) for step-by-step instructions.

## Disabling a OneForm Driver

To disable a driver in OpenNebula, use the `oneform disable` command:

```bash
oneform disable <driver_name>
```

{{< alert title="Important" type="warning" >}}
This action will not remove the existing instantiated Providers and Provisions, but it will prevent users from creating new Providers and Provisions using this driver.
{{< /alert >}}

## Managing Access Controls

To manage access control for the Provider and Provision associated with the driver, execute the the following commands:

- Changing permissions

  ```bash
  oneprovider chmod <provider_id> <octet>
  oneprovision chmod <provision_id> <octet>
  ```

- Changing owners

  ```bash
  oneprovider chown <provider_id> <user_id> (<group_id>)
  oneprovision chown <provision_id> <user_id> (<group_id>)
  ```

- Changing groups

  ```bash
  oneprovider chgrp <provider_id> <group_id>
  oneprovision chgrp <provision_id> <group_id>
  ```
