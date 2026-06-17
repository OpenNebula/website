---
title: "Backup Datastore: Interactive"
linkTitle: "Interactive"
date: "2026-06-17"
description:
categories:
pageintoc: "80"
tags:
weight: "4"
---

<a id="vm-backups-interactive"></a>

<!--# Backup Datastore: Interactive -->

The interactive backup datastore allows third-party backup systems to pull Virtual Machine backup data directly from OpenNebula KVM hypervisors. It is designed for integrations that manage their own backup repository, such as the OpenNebula-Veeam&reg; Backup Integration.

Interactive backups use the OpenNebula Backup Exporter (OneBEX). OneBEX is started on demand on the hypervisor that is running the VM backup operation. OpenNebula prepares the disk export, OneBEX exposes the export through an HTTP API, and the external backup system reads the backup data from the hypervisor.

## How It Works

When a VM backup is created in an interactive backup datastore, OpenNebula performs the following actions:

1. The VM backup workflow prepares the selected disks for export. Full backups and CBT incremental backups are supported.
2. OpenNebula writes the export metadata to `interactive_exports.json` in the VM backup directory on the hypervisor.
3. OneBEX is started on the hypervisor if it is not already running.
4. The external backup system requests the export from OneBEX, discovers the available disk transfers, and reads disk data ranges and block extents.
5. The external backup system finalizes each transfer and then finishes the VM backup session.
6. OpenNebula records the backup metadata as a backup image in the interactive backup datastore.

The interactive datastore is therefore a coordination datastore. The backup payload is stored by the external backup product, while OpenNebula keeps the backup image metadata needed to track and restore the backup.

OneBEX stops automatically when the backup session is finished or when it remains idle for longer than the configured timeout.

## Compatibility

The current interactive backup implementation supports the following configuration:

| Component | Support |
|-----------|---------|
| Hypervisor | KVM |
| VM disk storage | File-based `qcow2` disks |
| Backup types | Full and incremental |
| Incremental mode | CBT only (`INCREMENT_MODE="CBT"`) |
| VM state | Running and powered off VMs |
| OneBEX exporter | NBD |

{{< alert title="Important" type="info" >}}
Interactive incremental backups do not support the `SNAPSHOT` increment mode. OpenNebula rejects this combination when the backup configuration is updated.
{{< /alert >}}

## Network Requirements

The external backup system must be able to connect to OneBEX on every hypervisor that can run VMs backed up by third-party backup systems.

Make sure that:

- The OneBEX listen address and port are reachable from the external backup system.
- Firewalls allow the configured OneBEX port on the hypervisors.
- OpenNebula remotes are synchronized after changing the OneBEX configuration.
- The standard OpenNebula Front-end to Host connectivity is working.

## Configuring OneBEX

OneBEX is configured from the OpenNebula remotes directory on the Front-end:

```default
/var/lib/one/remotes/etc/onebex/onebex-server.conf
```

After changing this file, synchronize the remotes to the Hosts:

```default
$ onehost sync -f
```

{{< alert title="Note" type="info" >}}
OneBEX logs are written on each hypervisor to `/var/log/one/onebex.log`.
{{< /alert >}}

The configuration file defines the OneBEX listen address, shutdown behavior, logging settings, and Puma web server concurrency limits.

### Server Configuration

| Parameter | Default value | Description |
|-----------|---------------|-------------|
| `:host:` | `0.0.0.0` | Address where OneBEX listens for HTTP requests. By default, it listens on all available interfaces. |
| `:port:` | `13014` | TCP port where OneBEX listens for HTTP requests. |
| `:shutdown_delay:` | `2` | Delay, in seconds, after the final `/vms/:VM_ID/finish` request before stopping OneBEX. |
| `:idle_timeout:` | `300` | Maximum time, in seconds, without receiving any HTTP request before OneBEX stops automatically. |
| `:onebex_timeout:` | `1800` | Maximum time, in seconds, that OpenNebula waits for an interactive export to finish after it has started. |

### Log Configuration

| Parameter | Default value | Description |
|-----------|---------------|-------------|
| `:log: :level:` | `2` | Log verbosity level. Supported values are `0` for `ERROR`, `1` for `WARNING`, `2` for `INFO`, and `3` for `DEBUG`. |
| `:log: :system:` | `file` | Logging backend used by OneBEX. Supported values are `file` and `syslog`. |

### Puma Configuration

| Parameter | Default value | Description |
|-----------|---------------|-------------|
| `:puma: :min_threads:` | `1` | Minimum number of Puma threads used to handle concurrent OneBEX HTTP requests. |
| `:puma: :max_threads:` | `4` | Maximum number of Puma threads used to handle concurrent OneBEX HTTP requests. |

## Creating an Interactive Backup Datastore

Create a backup datastore that uses the `interactive` datastore driver:

```default
$ cat ds_interactive.txt
NAME   = "Interactive Backups"
TYPE   = "BACKUP_DS"

DS_MAD = "interactive"
TM_MAD = "-"
```

Create the datastore:

```default
$ onedatastore create ds_interactive.txt
ID: 100
```

Add the datastore to the clusters that contain the VMs to be backed up by third-party backup systems:

```default
$ onecluster adddatastore <cluster_name> <datastore_name>
```

After the datastore is created and OneBEX is reachable on the hypervisors, supported integrations can start using interactive backups.

## Restoring Interactive Backups

During interactive restores, OpenNebula passes the Image Datastore downloader a OneBEX-URL in the following form:

```default
onbex://<IMAGE_DS_ID>:<PORT_ID>
```

`IMAGE_DS_ID` is the destination Image Datastore ID where the restored disk image will be created. `PORT_ID` is the restore transfer port allocated for the interactive restore session.

## OneBEX API Reference

The OneBEX API is consumed by backup integrations. Current API is:

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/` | `GET` | Returns basic server information and the available API routes. |
| `/status` | `GET` | Returns the current export status for a VM. Requires `VM_ID`. |
| `/exporters` | `GET` | Lists the exporter backends available in OneBEX. |
| `/export` | `POST` | Starts one or more disk exports for a VM. Requires `VM_ID` and `DS_ID`; `DISKS` is optional. |
| `/transfers/:TRANSFER_ID/info` | `GET` | Returns size and format information for a transfer. |
| `/images/:TRANSFER_ID` | `OPTIONS` | Returns supported image transfer features and concurrency limits. |
| `/images/:TRANSFER_ID/extents` | `GET` | Returns block extent information for a transfer. |
| `/images/:TRANSFER_ID` | `GET` | Reads a byte range from a transfer. Requires an HTTP `Range` header. |
| `/images/:TRANSFER_ID` | `PATCH` | Flushes a transfer when the request body uses `op=flush`. |
| `/transfer/:TRANSFER_ID/finalize` | `POST` | Finalizes a transfer and releases its exporter resources. |
| `/vms/:VM_ID/finish` | `POST` | Finishes the VM backup session after all transfers have been finalized. |


## Exporters

OneBEX uses exporters to expose VM disk data to external backup systems.

| Exporter | Disk format | Transport | Description |
|----------|-------------|-----------|-------------|
| `nbd` | `qcow2` | Network Block Device | Exposes the backup disk through NBD. For local disk images, OneBEX starts a read-only `qemu-nbd` process and serves the image through a Unix socket. |
