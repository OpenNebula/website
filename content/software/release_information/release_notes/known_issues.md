---
title: "Known Issues"
date: "2025-10-06"
description:
categories:
pageintoc: "248"
tags:
weight: "6"
---

<a id="known-issues"></a>

<!--# Known Issues -->

A complete list of [known issues for OpenNebula is maintained here](https://github.com/OpenNebula/one/issues?q=is%3Aopen%20is%3Aissue%20type%3ABug%20label%3A%22Status%3A%20Accepted%22%20milestone%3A%22Release%207.4%22).

This page will be updated with relevant information about bugs affecting OpenNebula, as well as possible workarounds until a patch is officially published.

## Upgrade Overwrites the Host Fencing Script

Upgrading the OpenNebula packages [overwrites a customized](https://github.com/OpenNebula/one/issues/7996) `/var/lib/one/remotes/hooks/ft/fence_host.sh` with the stock template. If the Host error hook is configured with fencing enabled, fencing (and thus the hook) will fail after the upgrade until the file is restored.

The pre-upgrade file is preserved in the configuration backup taken automatically during the package upgrade, and can be restored from there:

```default
cp /var/lib/one/backups/config/<timestamp>-v<previous version>/var/lib/one/remotes/hooks/ft/fence_host.sh \
   /var/lib/one/remotes/hooks/ft/fence_host.sh
```

## Frontend HA

- [ARP tables are not updated automatically](https://github.com/OpenNebula/one/issues/7920) when a leader is elected in Red Hat Enterprise Linux OS variants.

## Sunstone

[Repeated column width recalculations per table cell](https://github.com/OpenNebula/one/issues/7946) leads to FireEdge performance degradation. The fix is scheduled to be released in 7.4.1.

## Veeam Backups

Worker creation and restores [will fail](https://github.com/OpenNebula/one/issues/7949) if the VM with ID 0 doesn't exist in the database.

It can be fixed by changing the line ~145 in the `/usr/lib/one/ovirtapi-server/controllers/disk_controller.rb` file (located in the oVirtAPI backup server). Then restart the apache2/httpd service.

```
vm_id = disk_hash['IMAGE']['VM_ID'].to_i
if backup_mode == 'incremental' && vm_id > 0    # <-- Add this vm_id check
    vm = VmController.get_one_vms(client, :vm_id => vm_id)
    vm_hash = vm.to_hash
    backup_ids = vm_hash.dig('VM', 'BACKUPS', 'BACKUP_IDS', 'ID')
```
