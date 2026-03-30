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

A complete list of [known issues for OpenNebula is maintained here](https://github.com/OpenNebula/one/issues?q=is%3Aopen%20is%3Aissue%20type%3ABug%20label%3A%22Status%3A%20Accepted%22).

This page will be updated with relevant information about bugs affecting OpenNebula, as well as possible workarounds until a patch is officially published.

## Core

- OneForm is not properly restarted in a [HA setup when the leader changes.](https://github.com/OpenNebula/one/issues/7562)

## Drivers - Virtualization

- [libvirtd restarts in cycles each 10 minutes with error message in system logs](https://github.com/OpenNebula/one/issues/6463), due to the way libvirtd gets activated per interaction by systemd in 120-second slices. As the default interval for the OpenNebula monitor probe is 600 seconds (10 minutes), each time a probe reactivates libvirtd, it sends those messages to syslog.

## Sunstone

- Guacamole RDP as is currently shipped in OpenNebula does not support NLA authentication. You can follow [these instructions](https://www.parallels.com/blogs/ras/disabling-network-level-authentication/) in order to disable NLA in the Windows box to use Guacamole RDP within Sunstone.

- The following new features have not been integrated into Sunstone yet, but are planned for a future release:
  - New [monitor message `EXEC_VM`](../../../product/cloud_system_administration/resource_monitoring/monitoring_system.md) to retrieve the result of commands executed inside a Virtual Machine.
  - [VirtioFS](../../../product/cluster_configuration/storage_system/virtiofs_ds.md) datastores enable Virtual Machines to directly access host filesystems, providing fast, low-latency shared file access. This simplifies data sharing across VMs while improving performance for data-intensive workloads.

## Migration

- When upgrading to 7.2 the `onedb` migration might fail if the `/etc/one/sunstone-views.yaml` file contains a single, unclosed value under the **labels_groups** key, example:

  ```yaml
  labels_groups:
    default:
  ```

  This can be mitigated by declaring an empty array as the value instead, example:

  ```yaml
  labels_groups:
    default: []
  ```

## Install Linux Graphical Desktop on KVM Virtual Machines

OpenNebula uses the `cirrus` graphical adapter for KVM Virtual Machines by default. It could happen that after installing a graphical desktop on a Linux VM, the Xorg window system does not load the appropriate video driver. You can force a VESA mode by configuring the kernel parameter `vga=VESA_MODE` in the GNU GRUB configuration file. [Here](https://en.wikipedia.org/wiki/VESA_BIOS_Extensions#Linux_video_mode_numbers/) you can find the VESA mode numbers. For example, adding `vga=791` as kernel parameter will select the 16-bit 1024×768 resolution mode.

## Market proxy settings

- The option `--proxy` in the `MARKET_MAD` may not be working correctly. To solve it, execute `systemctl edit opennebula` and add the following entries:

```default
[Service]
Environment="http_proxy=http://proxy_server"
Environment="https_proxy=http://proxy_server"
Environment="no_proxy=domain1,domain2"
```

Where `proxy_server` is the proxy server to be used and `no_proxy` is a list of the domains or IP ranges that must not be accessed via proxy by opennebula. After that, reload systemd service configuration with `systemctl daemon-reload` and restart opennebula with a `systemctl restart opennebula`

## Monitoring

When configuring resource usage forecasts, it is important to ensure that the `forecast period` is _not shorter_ than the `probe period` defined for `MONITOR_HOST` and `MONITOR_VM` in `/etc/one/monitord.conf`. If the forecast period is set to a value smaller than the monitoring interval, the prediction probe will raise an error and may disable monitoring for the affected Host and VMs.

By default, the monitoring interval for a Host is two minutes. In the following example, the forecast period is set to one minute, which is shorter than the Host's monitoring interval of two minutes. This **misconfiguration** will result in an error and place the Host in an error state:

```yaml
host:
  db_retention: 4 # Number of weeks
  forecast:
      enabled: true
      period: 1 # Number of minutes
      lookback: 60 # The look-back windows in minutes to use for the predictions
```

To avoid this error, always set the forecast period to a value _equal to or greater_ than the monitoring interval. For example, if the Host monitoring interval is two minutes, the forecast period should be set to at least two minutes:

```yaml
host:
  db_retention: 4 # Number of weeks
  forecast:
      enabled: true
      period: 2 # Number of minutes
      lookback: 60 # Look-back window in minutes for predictions
```

## SUSE

- The following components are not available for SUSE in 7.2:
  - opennebula-form
  - opennebula-ovirt
  - opennebula-lxc

- PyONE gRPC is not working on openSUSE 16 due to a [protobuf packaging bug](https://bugzilla.opensuse.org/show_bug.cgi?id=1260084). The workaround is to force-install a compatible version:

  ```default
  pip3.13 install protobuf==5.28.3 --force
  ```

## LinuxContainers marketplace

The appliances on this marketplace will fail [to boot](https://github.com/OpenNebula/one/issues/7391) when deployed on rhel10 like hosts. The parameter `lxc.apparmor.profile=unconfined` is what causes the issue and needs to be removed after the appliance is imported.

```
RAW=[
  DATA="lxc.apparmor.profile=unconfined",
  TYPE="lxc" ]
```
