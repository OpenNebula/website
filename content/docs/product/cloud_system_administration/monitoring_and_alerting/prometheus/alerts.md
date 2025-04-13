---
title: "Alert Manager"

description:
categories:
pageintoc: ""
tags:
weight: "4"
---

<a id="monitor-alert-alarms"></a>

<!--# Alert Manager -->

## Installation and Configuration

{{< alert title="Note" color="success" >}}
If you are already running the Prometheus AlertManager you can skip this section and add the alarms described in the next section to your rules file.{{< /alert >}} 

AlertManager is part of the Prometheus distribution and should already be installed in your system after completing the installation process, [see more details here]({{% relref "install#monitor-alert-installation" %}}).

Now you just need to enable and start the AlertManager service:

```default
# systemctl enable --now opennebula-alertmanager.service
```

The configuration file for the AlertManager can be found in `/etc/one/alertmanager/alertmanager.yml`. By default, the only receiver configured is a webhook listening on a local port. AlertManager includes several options to notify the alarms, please refer to the [Prometheus documentation on Alerting Configuration](https://prometheus.io/docs/alerting/configuration/) to setup your own receiver.

```yaml
route:
  group_by: ['alertname']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 1h
  receiver: 'web.hook'
receivers:
  - name: 'web.hook'
    webhook_configs:
      - url: 'http://127.0.0.1:5001/'
inhibit_rules:
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: ['alertname', 'dev', 'instance']
```

<a id="monitor-alert-rules"></a>

## Alerts Rules

We provide some pre-defined alert rules that cover the most common use cases for an OpenNebula cloud. These rules are not intended to use as-is, but as a starting point to define the alert situations for your specific use case.  Please [review the Prometheus documentation](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/) to adapt the provided alert rules.

Alert Rules can be found in `/etc/one/prometheus/rules.yml`.

### Group: AllInstances

| Name                 | Severity                                                                     | Description                                                 |
|----------------------|------------------------------------------------------------------------------|-------------------------------------------------------------|
| InstanceDown         | critical                                                                     | Server is down for more than 30s                            |
|                      | `up == 0`                                                                    |                                                             |
| DiskFree             | warning                                                                      | Server has less than 10% of free space in rootfs            |
|                      | `(node_filesystem_avail_bytes{mountpoint="/",fstype!="rootfs"} / ...) <= 10` |                                                             |
| FreeMemory10         | warning                                                                      | Server has less than 10% of free memory                     |
|                      | `((node_memory_MemFree_bytes * 100) / node_memory_MemTotal_bytes) <= 10`     |                                                             |
| LoadAverage15        | warning                                                                      | Server has more that 90% of load average in last 15 minutes |
|                      | `node_load15 > 90`                                                           |                                                             |
| RebootInLast5Minutes | Server  has has been rebooted in last 5 minutes                              |                                                             |
|                      | `rate(node_boot_time_seconds[5m]) > 0`                                       |                                                             |

### Group: OpenNebulaHosts

| Name        | Severity                            | Description                                                   |
|-------------|-------------------------------------|---------------------------------------------------------------|
| HostDown    | critical                            | OpenNebula Host is down for more than 30s                     |
|             | `opennebula_host_state != 2`        |                                                               |
| LibvirtDown | critical                            | Libvirt daemon on host has been down for more than 30 seconds |
|             | `opennebula_libvirt_daemon_up == 0` |                                                               |

### Group: OpenNebulaVirtualMachines

| Name      | Severity                                          | Description                                           |
|-----------|---------------------------------------------------|-------------------------------------------------------|
| VMFailed  | critical                                          | OpenNebula VMs in failed state more than 30 seconds   |
|           | `count(opennebula_vm_lcm_state == 44 or ...) > 0` |                                                       |
| VMPending | critical                                          | OpenNebula VMs in pending state more than 300 seconds |
|           | `count(opennebula_vm_state == 1) > 0`             |                                                       |

### Group: OpenNebulaServices

| Name            | Severity                          | Description                                               |
|-----------------|-----------------------------------|-----------------------------------------------------------|
| OnedDown        | critical                          | OpenNebula oned service is down for more than 30s         |
|                 | `opennebula_oned_state == 0`      |                                                           |
| SchedulerDown   | critical                          | OpenNebula scheduler service is down for more than 30s    |
|                 | `opennebula_scheduler_state == 0` |                                                           |
| HookManagerDown | critical                          | OpenNebula hook manager service is down for more than 30s |
|                 | `opennebula_hem_state == 0`       |                                                           |

## Setting up Alarms for OpenNebula in HA

{{< alert title="Important" color="success" >}}
To avoid duplicate alert notifications you should configure **all** your alertmanager instances to run in HA mode,{{< /alert >}} 
then point **all** your prometheus instances to them.

Please refer to the [Using Prometheus with OpenNebula in HA]({{% relref "install#monitor-alert-ha" %}}) section for details.
