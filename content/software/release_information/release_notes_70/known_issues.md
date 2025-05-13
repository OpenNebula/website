---
title: "Known Issues"
date: "2025-02-17"
description:
categories:
pageintoc: "248"
tags:
weight: "6"
---

<a id="known-issues"></a>

<!--# Known Issues -->

A complete list of [known issues for OpenNebula is maintained here](https://github.com/OpenNebula/one/issues?q=is%3Aopen+is%3Aissue+label%3A%22Type%3A+Bug%22+label%3A%22Status%3A+Accepted%22).

This page will be updated with relevant information about bugs affecting OpenNebula, as well as possible workarounds until a patch is officially published.

## Drivers - Virtualization

- [libvirtd restarts in cycles each 10 minutes with error message in system logs](https://github.com/OpenNebula/one/issues/6463), due to the way libvirtd gets activated per interaction by systemd in 120-second slices. As the default interval for the OpenNebula monitor probe is 600 seconds (10 minutes), each time a probe reactivates libvirtd, it sends those messages to syslog.

## Drivers - Network

- Edge Cluster Public IP: NIC_ALIAS on the public network can only be associated to a NIC on the same network.

## Drivers - Storage

- **LXC**, XFS formatted disk images are incompatible with the `fs_lvm` driver. The image [fails to be mounted](https://github.com/OpenNebula/one/issues/5802) on the host.

## Sunstone

- Guacamole RDP as is currently shipped in OpenNebula does not support NLA authentication. You can follow [these instructions](https://www.parallels.com/blogs/ras/disabling-network-level-authentication/) in order to disable NLA in the Windows box to use Guacamole RDP within Sunstone.

## Install Linux Graphical Desktop on KVM Virtual Machines

OpenNebula uses the `cirrus` graphical adapter for KVM Virtual Machines by default. It could happen that after installing a graphical desktop on a Linux VM, the Xorg window system does not load the appropriate video driver. You can force a VESA mode by configuring the kernel parameter `vga=VESA_MODE` in the GNU GRUB configuration file. [Here](https://en.wikipedia.org/wiki/VESA_BIOS_Extensions#Linux_video_mode_numbers/) you can find the VESA mode numbers. For example, adding `vga=791` as kernel parameter will select the 16-bit 1024×768 resolution mode.

## Warning when Exporting an App from the Marketplace Using CLI

When exporting an application from the marketplace using the CLI the following warning can be seen:

```default
/usr/lib/one/ruby/opennebula/xml_element.rb:124: warning: Passing a Node as the second parameter to Node.new is deprecated. Please pass a Document instead, or prefer an alternative constructor like Node#add_child. This will become an error in a future release of Nokogiri.
```

This is harmless and can be discarded, it will be addressed in future releases.

## Contextualization

- `GROW_ROOTFS` and `GROW_FS` will not extend btrfs filesystems
- `onesysprep` does not support Debian 12 yet

## Backups

- OpenNebula stores the whole VM Template in a backup. When restoring it some attributes are wiped out as they are dynamic or they need to be re-generated (e.g. IP). However some attributes (e.g. DEV_PREFIX) would be better to keep them. It is recommended to review and adjust the resulting template for any missing (and required) attribute. The [list of attributes removed can be checked here]({{% relref "../../../product/virtual_machines_operation/virtual_machine_backups/operations#vm-backups-restore" %}}).

## Market proxy settings

- The option `--proxy` in the `MARKET_MAD` may not be working correctly. To solve it, execute `systemctl edit opennebula` and add the following entries:

```default
[Service]
Environment="http_proxy=http://proxy_server"
Environment="https_proxy=http://proxy_server"
Environment="no_proxy=domain1,domain2"
```

Where `proxy_server` is the proxy server to be used and `no_proxy` is a list of the domains or IP ranges that must not be accessed via proxy by opennebula. After that, reload systemd service configuration with `systemctl daemon-reload` and restart opennebula with a `systemctl restart opennebula`
