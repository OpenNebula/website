---
title: "Linux Containers Marketplace"
date: "2025-02-17"
description:
categories:
pageintoc: "187"
tags:
weight: "3"
---

<a id="market-linux-container"></a>

<!--# Linux Containers MarketPlace -->

The [Linux Containers image server](https://images.linuxcontainers.org/) hosts a public image server with container images for LXC. OpenNebula’s Linux Containers marketplace enable users to easily download, contextualize and add Linux containers images to an OpenNebula datastore.

{{< alert title="Note" color="success" >}}
A log file (`/var/log/chroot.log`) is created inside the imported image filesystem with information about the operations done during the setup process; in case of issues it could be a useful source of information.{{< /alert >}} 

## Requirements

- Approximately 6GB of storage plus the container image size.

## Configuration Attributes

| Attribute       | Description                                 | Default                              |
|-----------------|---------------------------------------------|--------------------------------------|
| `NAME`          | Marketplace name (Required)                 |                                      |
| `MARKET_MAD`    | `linuxcontainers`                           |                                      |
| `ENDPOINT`      | The base URL of the Market.                 | `https://images.linuxcontainers.org` |
| `IMAGE_SIZE_MB` | Size in MB for the image holding the rootfs | `1024`                               |
| `FILESYSTEM`    | Filesystem used for the image               | `ext4`                               |
| `FORMAT`        | Image block file format                     | `raw`                                |
| `SKIP_UNTESTED` | Include only apps with support for context  | `yes`                                |
| `CPU`           | VMTemplate CPU                              | `1`                                  |
| `VCPU`          | VMTemplate VCPU                             | `2`                                  |
| `MEMORY`        | VMTemplate MEMORY                           | `768`                                |
| `PRIVILEGED`    | Security mode of the Linux Container        | `true`                               |
