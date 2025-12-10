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

## Sunstone

- Guacamole RDP as is currently shipped in OpenNebula does not support NLA authentication. You can follow [these instructions](https://www.parallels.com/blogs/ras/disabling-network-level-authentication/) in order to disable NLA in the Windows box to use Guacamole RDP within Sunstone.
- The Windows Optimized [OS Profile](../../../product/virtual_machines_operation/guest_operating_systems/os_profile.md) yaml file at `/etc/one/fireedge/sunstone/profiles/windows_optimized.yaml` has the wrong configuration. Utilizing such profile in Sunstone will lead to a VM that libvirt fails to create. You have to edit the file and replace its contents with the [documentation yaml content](../../../product/virtual_machines_operation/guest_operating_systems/os_profile.md#profile-chain-loading).
- Enabling fullViewMode in sunstone configuration is not working. You can find the detailed information [here](https://github.com/OpenNebula/one/issues/7154). This is the typo in the configuration file. You can simply fix the issue by removing one `":"` in this [configuration file](https://github.com/OpenNebula/one/blob/release-7.0.0/src/fireedge/etc/sunstone/sunstone-server.conf#L128).
- When fullModeView mode is active and a status change is made in the VM, the buttons at the top are not updated. To see the buttons that correspond to the current status of the VM, you have to go back to the data table and reselect the VM. This error will be resolved in future versions. You can find more information [here](https://github.com/OpenNebula/one/issues/7172).
- Uploaded files are not deleted from /var/tmp when creating an image from upload file. You can find detailed information [here](https://github.com/OpenNebula/one/issues/7252). This may also trigger a race condition that deletes the temporary file from /var/tmp preventing the correct registering of the image, this may apply in some cases only.

## Migration

- When upgrading to 7.0 the `onedb` migration might fail if the `/etc/one/sunstone-views.yaml` file contains a single, unclosed value under the **labels_groups** key, example:

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

## Backups

- For Veeam related issues, please referer to the [Veeam (EE) page](../../../product/cluster_configuration/backup_system/veeam.md).

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

### OneGate

- [Avoid Host not permitted on Sinatra server when is behind NGINX proxy](https://github.com/OpenNebula/one/issues/7231)

## LinuxContainers marketplace

The appliances on this marketplace will fail [to boot](https://github.com/OpenNebula/one/issues/7391) when deployed on rhel10 like hosts. The parameter `lxc.apparmor.profile=unconfined` is what causes the issue and needs to be removed after the appliance is imported.

```
RAW=[
  DATA="lxc.apparmor.profile=unconfined",
  TYPE="lxc" ]
```

## High CPU utilization due to predictions

With some configurations, the usage of CPU on the hosts can be very high, due to running predictions. In such case, the number of threads used by BLAS (Basic Linear Algebra Subprograms) can be limited to 1 (or other suitable number) with the environment variables:

```shell
export OMP_NUM_THREADS=${OMP_NUM_THREADS:-1}
export OPENBLAS_NUM_THREADS=${OPENBLAS_NUM_THREADS:-1}
export MKL_NUM_THREADS=${MKL_NUM_THREADS:-1}
export BLIS_NUM_THREADS=${BLIS_NUM_THREADS:-1}
export NUMEXPR_NUM_THREADS=${NUMEXPR_NUM_THREADS:-1}
```

A more comprehensive way is to replace the following old files with the appropriate files from `one` repository:
* [prediction script](https://github.com/OpenNebula/one/blob/master/src/im_mad/remotes/lib/python/prediction.sh)
* [prediction script from node probes](https://github.com/OpenNebula/one/blob/master/src/im_mad/remotes/node-probes.d/prediction.sh)
* [prediction model](https://github.com/OpenNebula/one/blob/master/src/im_mad/remotes/lib/python/pyoneai/ml/sklearn_prediction_model.py)
