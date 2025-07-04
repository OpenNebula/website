---
title: "Monitoring System"

description:
categories:
pageintoc: ""
tags:
weight: "2"
---

<a id="monitor-alert-configuration"></a>

<a id="mon"></a>

<a id="mon-conf"></a>

<!--# The OpenNebula Monitoring System -->

The monitoring subsystem is represented by a dedicated daemon (`onemonitord`) running as part of the OpenNebula Daemon (`oned`), that **gathers information relevant to the Hosts and the Virtual Machines**, e.g., Host status, basic performance indicators, Virtual Machine status, and capacity consumption. This information is collected by executing a set of probe programs provided by OpenNebula. The output of these probes is sent to OpenNebula using a push mechanism. It’s part of the operating system package `opennebula`.

## Overview

Each Host periodically sends monitoring data via the network to the Front-end, which collects and processes it in a dedicated module. This distributed monitoring system resembles the architecture of dedicated monitoring systems, using a lightweight communication protocol and a push model.

As part of the regular start process, OpenNebula starts the `onemonitord` daemon running in the Front-end, that listens for network connections on port 4124 (both UDP and TCP). Initially, OpenNebula connects to the Hosts using SSH and starts a light agent that executes the probe scripts to collect and send data back to the `onemonitord` daemon in the Front-end.

Probes are structured in information categories for Host and Virtual Machine information. At regular intervals (in seconds, configurable per category in the `monitord.conf`) the data is transmitted, so the monitoring subsystem doesn’t need to make any additional connections to gather it.

![image0](/images/collector.png)

If information stops coming from a specific Host, OpenNebula detects it by missing heartbeats and pro-actively connects to the particular Host over SSH and restarts probes.

{{< alert title="Important" color="success" >}}
The firewall on the Front-end (if enabled) must allow incoming TCP and UDP packets on port 4124 from the Hosts.{{< /alert >}} 

## Configuration

The monitor daemon (`onemonitord`) is configured in `/etc/one/monitord.conf`. The table below describes the file’s configuration attributes.

{{< alert title="Tip" color="info" >}}
For a quick view of any changes in configuration file options in maintenance releases, check the Resolved Issues page in the [Release Notes]({{% relref "../../../software/release_information/release_notes_enterprise#rn-enterprise" %}}) for the release. Please note that even in the case of changes (such as a new option available), you do *not* need to update your configuration files unless you wish to change the application’s behavior.{{< /alert >}} 

| Parameter                                                                                   | Attribute                                                                                                                                                                                              | Description                                                                      |
|---------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------|
| `MANAGER_TIMER`                                                                             | Timer in seconds, monitord evaluates Host timeouts                                                                                                                                                     |                                                                                  |
| `MONITORING_INTERVAL_HOST`                                                                  | Wait time (seconds) without receiving any beacon before restarting the probes                                                                                                                          |                                                                                  |
| `HOST_MONITORING_EXPIRATION_TIME`                                                           | Time in seconds before Host monitoring information expires. Use 0 to disable Host<br/>monitoring recording                                                                                             |                                                                                  |
| `VM_MONITORING_EXPIRATION_TIME`                                                             | Time in seconds before VM monitoring information expires. Use 0 to disable VM<br/>monitoring recording                                                                                                 |                                                                                  |
| **Database** (main configuration taken from `oned.conf`, only `onemonitord` specifics here) |                                                                                                                                                                                                        |                                                                                  |
| `DB`                                                                                        | `CONNECTIONS`                                                                                                                                                                                          | DB connections. DB needs to be configured to support oned + monitord connections |
| **Network Configuration**                                                                   |                                                                                                                                                                                                        |                                                                                  |
| `NETWORK`                                                                                   | `ADDRESS`                                                                                                                                                                                              | Network address to bind the UDP/TCP listener to                                  |
| `MONITOR_ADDRESS`                                                                           | Agents will send updates to this monitor address.<br/>If “auto” is used, agents will detect the address from the ssh connection<br/>Front-end -> Host ($SSH_CLIENT), “auto” is not usable for HA setup |                                                                                  |
| `PORT`                                                                                      | Listening port                                                                                                                                                                                         |                                                                                  |
| `THREADS`                                                                                   | Number of threads used to receive messages from monitor probes                                                                                                                                         |                                                                                  |
| `PUBKEY`                                                                                    | Absolute path to public key. Empty for no encryption                                                                                                                                                   |                                                                                  |
| `PRIKEY`                                                                                    | Absolute path to private key. Empty for no encryption                                                                                                                                                  |                                                                                  |
| **Probes Configuration**                                                                    |                                                                                                                                                                                                        |                                                                                  |
| `PROBES_PERIOD`                                                                             | `BEACON_HOST`                                                                                                                                                                                          | Time in seconds to send heartbeat for the Host                                   |
| `SYSTEM_HOST`                                                                               | Time in seconds to send Host static/configuration information                                                                                                                                          |                                                                                  |
| `MONITOR_HOST`                                                                              | Time in seconds to send Host variable information                                                                                                                                                      |                                                                                  |
| `STATE_VM`                                                                                  | Time in seconds to send VM status (ie. running, error, stopped…)                                                                                                                                       |                                                                                  |
| `MONITOR_VM`                                                                                | Time in seconds to send VM resource usage metrics                                                                                                                                                      |                                                                                  |
| `SYNC_STATE_VM`                                                                             | Send a complete VM report if probes stopped more than `SYNC_STATE_VM` seconds                                                                                                                          |                                                                                  |

Additionally, you need to enable the drivers that `onemonitord` will use to interface the hypervisor nodes in your cloud. In general, the following attributes can be tuned in the `arguments` section of the driver configuration (`IM_MAD`):

| Argument   | Description                                                              |
|------------|--------------------------------------------------------------------------|
| `-r`       | number of retries when monitoring a Host                                 |
| `-t`       | number of threads it limits the Hosts (started/stopped) at the same time |
| `-w`       | Timeout in seconds to execute external commands (e.g. ssh connections)   |

### Configure Probes

To fine tune monitoring probes you can adjust parameters in `/var/lib/one/remotes/etc/im/<hypervisor>-probe.d/probe_db.conf`. The following parameters can be tuned:

| Parameter       | Description                                                             |
|-----------------|-------------------------------------------------------------------------|
| `obsolete`      | [minutes] VM status entries older than this will be deleted             |
| `times_missing` | Number of monitor cycles a VM is missing to consider it definitely lost |

### Configure OpenNebula

No initial configuration is required because the monitoring daemon is enabled by default in [/etc/one/oned.conf]({{% relref "../../../product/operation_references/opennebula_services_configuration/oned#oned-conf" %}}) as a monitor driver.

For example:

```default
IM_MAD = [
    NAME       = "monitord",
    EXECUTABLE = "onemonitord",
    ARGUMENTS  = "-c monitord.conf",
    THREADS    = 8 ]
```

This should be the only driver activated in this file. The following configuration attributes are available:

| Parameter   | Description                                                    |
|-------------|----------------------------------------------------------------|
| `THREADS`   | Number of threads used to process messages from monitor daemon |

<a id="mon-conf-service"></a>

## Service Control and Logs

Monitoring daemon is started as part of OpenNebula Daemon (service `opennebula`). There is **no dedicated system service**.

**Logs** are located in `/var/log/one` in following file(s):

- `/var/log/one/monitor.log`
- `/var/log/one/oned.log` (relevant monitoring messages may appear also in OpenNebula log)

## Monitoring Storage and Database Structure

The monitoring data collected by OpenNebula probes is processed by the monitoring module and stored in a time-series structure within the OpenNebula database. This data is accessed via the CLI and Sunstone UI through designated API calls. Additionally, OpenNebula employs a distributed database approach to efficiently store and process Host and VM monitoring data, enabling resource usage forecasting and ensuring scalability.

### Host Time-Series Databases

Each physical Host in an OpenNebula deployment maintains its own dedicated monitoring databases. These databases are updated through the regular Host and VM monitoring cycles:

- **Location**: `/var/tmp/one_db/host.db`
- **Purpose**: Stores historical monitoring metrics for the Host

Additionally, for each VM running on a Host, a dedicated database tracks its specific metrics:

- **Location**: `/var/tmp/one_db/<VM_ID>.db` (stored on the Host where the VM is running)
- **Purpose**: Stores historical monitoring metrics for the specific VM

{{< alert title="Note" color="success" >}}
Following a VM migration, forecast accuracy may be temporarily reduced until sufficient monitoring data is collected on the new Host.{{< /alert >}} 

For more details on how these databases contribute to resource forecasting, see the [Resource Forecast]({{% relref "forecast#monitor-alert-forecast" %}}) section.

## Advanced Setup

The following sections present optional advanced setups which can improve the security or performance of the monitoring subsystem:

### Encryption of Monitoring Messages

You can configure the probes to encrypt the monitoring messages sent to the Front-end. This may help to secure your environment when some of the hypervisors are in cloud/edge locations. Follow the next steps to configure encryption.

1. Generate dedicated public and private keys for the monitor system and store them in a safe place (we’ll use `/etc/one`). Do not use any passphrase to encrypt the private key:

```default
# ssh-keygen -f /etc/one/onemonitor
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /etc/one/onemonitor
Your public key has been saved in /etc/one/onemonitor.pub
The key fingerprint is:
SHA256:XlFQK35lZ0i2ncAZUbmkKJ8F8ra5uQJA3VGa36OP10I V
```

2. Change the format of the public key to PKCS#1:

```default
# ssh-keygen -f /etc/one/onemonitor.pub -e -m pem > /etc/one/onemonitor_pem.pub
```

3. Update configuration `/etc/one/monitord.conf` and set path to keys:

```default
NETWORK = [
  ...
  PUBKEY = "/etc/one/onemonitor_pem.pub",
  PRIKEY = "/etc/one/onemonitor"
]
```

4. Restart [OpenNebula]({{% relref "../../../product/operation_references/opennebula_services_configuration/oned#oned-conf-service" %}})

```default
# systemctl restart opennebula
```

5. Restart the probes on the Hosts to use the configured keys:

```default
# sudo -u oneadmin onehost sync -f
```

### Monitoring in HA

If you are running OpenNebula in an HA cluster, it is recommended to use a virtual IP for the `MONITOR_ADDRESS` attribute. This way the RAFT hook will move the monitor address and the probes do not need to be restarted. Adjust the RAFT hook configuration to include the monitor IP, see more details in [OpenNebula Front-end HA (Raft Hooks)]({{% relref "../../../product/control_plane_configuration/high_availability/frontend_ha.md#frontend-ha-setup" %}}).

### Adjust Monitoring Intervals

For medium-sized clouds, the default values should perform well. For larger environments, you may need to tune your OpenNebula installation with appropriate values of the monitoring parameters and monitoring intervals in the `PROBES_PERIOD` section. The final values should consider the number of Hosts and VMs that, in turn, will determine the processing requirements for OpenNebula. Also, you may need to increase the number of threads (`THREADS`) in [/etc/one/oned.conf]({{% relref "../../../product/operation_references/opennebula_services_configuration/oned#oned-conf" %}}) and drivers in `/etc/one/monitord.conf`.

If the system is not working well, the problem could be in database performance. If the number of Virtual Machines and Hosts is too large and the monitoring periods too low, OpenNebula will not be able to write that amount of data to the database.

<a id="monitoring-troubleshooting"></a>

## Troubleshooting

{{< alert title="Important" color="success" >}}
When debugging the monitor system, we recommend increasing the `DEBUG` level for both `oned` and `onemonitord`, and restarting OpenNebula.{{< /alert >}} 

### Healthy Monitoring System

The default location for the monitoring log file is `/var/log/one/monitor.log`. Approximately every configured monitor period OpenNebula receives the monitoring data of every Virtual Machine and of a Host as follows:

```default
Sun Mar 15 22:12:15 2020 [Z0][HMM][I]: Successfully monitored VM: 0
Sun Mar 15 22:13:10 2020 [Z0][HMM][I]: Successfully monitored host: 0
Sun Mar 15 22:13:45 2020 [Z0][HMM][I]: Successfully monitored VM: 2
Sun Mar 15 22:15:10 2020 [Z0][HMM][I]: Successfully monitored host: 1
```

However, if in `/var/log/one/monitor.log` a Host is being monitored **actively** periodically (every `MONITORING_INTERVAL_HOST` seconds) then the monitorization is **not** working correctly:

```default
Sun Mar 15 22:31:55 2020 [Z0][HMM][D]: Monitoring host localhost(0)
Sun Mar 15 22:31:59 2020 [Z0][HMM][D]: Start monitor success, host: 0
Sun Mar 15 22:35:10 2020 [Z0][HMM][D]: Monitoring host localhost(0)
Sun Mar 15 22:35:19 2020 [Z0][HMM][D]: Start monitor success, host: 0
```

If this is the case, it’s probably because the Monitor Daemon isn’t receiving any data from probes, which could be caused by the wrong UDP settings. You should not see a restart of the `onemonitord` process.

### Monitoring Probes

To troubleshoot errors produced during the execution of the monitoring probes, try to execute them directly through the command line as user `oneadmin` in the Hosts. Information about malformed messages should be reported in `/var/log/one/oned.log` or `/var/log/one/monitor.log`

## Tuning and Extending

The monitor system can be easily customized to include additional monitoring metrics. These new metrics can be used to implement custom scheduling policies or gather data of interest for the Hosts or VMs. Metrics are gathered by **probes**, simple programs that print the metric value to standard output using OpenNebula Template syntax. For example, in a KVM hypervisor, the system usage probe outputs:

```default
host/monitor$ ./linux_usage.rb
HYPERVISOR=kvm
USEDMEMORY=2147156
FREEMEMORY=5831016
FREECPU=792
USEDCPU=8
NETRX=0
NETTX=0
```

or, the NUMA configuration probe:

```default
host/system$ ./numa_host.rb
HUGEPAGE = [ NODE_ID = "0", SIZE = "2048", PAGES = "0" ]
HUGEPAGE = [ NODE_ID = "0", SIZE = "1048576", PAGES = "0" ]
CORE = [ NODE_ID = "0", ID = "3", CPUS = "3,7" ]
CORE = [ NODE_ID = "0", ID = "1", CPUS = "1,5" ]
CORE = [ NODE_ID = "0", ID = "2", CPUS = "2,6" ]
CORE = [ NODE_ID = "0", ID = "0", CPUS = "0,4" ]
MEMORY_NODE = [ NODE_ID = "0", TOTAL = "7978172", DISTANCE = "0" ]
```

Probes are structured in different directories that determine the frequency in which they are executed, as well as the data sent back to the Front-end. The layout in the filesystem is:

```default
<hypervisor_name>-probes.d
|-- host
|   |-- beacon
|   |   |-- date.sh
|   |   |-- ...
|   |
|   |-- monitor
|   |   |-- linux_usage.rb
|   |   |--...
|   |
|   `-- system
|       |-- architecture.sh
|       |-- ...
`-- vm
    |-- monitor
    |   |-- monitor_ds_vm.rb
    |   |-- ...
    |
    `-- status
        `-- state.rb
```

The purpose of each directory is described in the following table:

| Directory      | Purpose                                                                                            | Update Frequency      |
|----------------|----------------------------------------------------------------------------------------------------|-----------------------|
| `host/beacon`  | Heartbeat & watchdog to collect rogue probe processes                                              | `BEACON_HOST` (30s)   |
| `host/monitor` | Monitor information (variable) (e.g. memory usage) stored in `HOST/MONITORING`                     | `MONITOR_HOST` (120s) |
| `host/system`  | General quasi-static info. about Host (e.g. NUMA nodes) stored in `HOST/TEMPLATE` and `HOST/SHARE` | `SYSTEM_HOST` (600s)  |
| `vm/monitor`   | Monitor information (variable) (e.g. used cpu, network usage) stored in `VM/MONITORING`            | `MONITOR_VM` (30s)    |
| `vm/state`     | State change notification, only send when a change is detected                                     | `STATE_VM` (30s)      |

If you need to add custom metrics, the procedure is:

1. Develop a program that gathers the metric and output it to stdout.
2. Place the program in the target directory. Depending on the nature and object it should be one of `host/monitor`, `host/system` or `vm/monitor`. You should not modify probes in the other directories.
3. Increment the `VERSION` number in `/var/lib/one/remotes/VERSION`.
4. Distribute changes to the hosts by running `onehost sync`.

## Usage

<a id="monit-cli"></a>

### Getting Monitoring Information in CLI

The information that you can retrieve is:

- `CAPACITY/FREE_CPU`
- `CAPACITY/FREE_MEMORY`
- `CAPACITY/USED_CPU`
- `CAPACITY/USED_MEMORY`
- `SYSTEM/NETRX`
- `SYSTEM/NETTX`

You can get monitoring information in three different ways:

#### Table

```default
$ onehost monitoring 0 USED_MEMORY --unit G --n 10 --table

Host 0 USED_MEMORY in GB from 09/06/2020 09:36 to 09/06/2020 14:38

TIME    VALUE
14:09  6.48 GB
14:12  6.54 GB
14:16  6.54 GB
14:19  6.54 GB
14:22  6.53 GB
14:25  6.42 GB
14:29  6.43 GB
14:32  6.44 GB
14:35  6.49 GB
14:38  6.48 GB
```

#### CSV

```default
$ onehost monitoring 0 USED_MEMORY --unit G --n 10 --csv ';'

TIME;VALUE
14:09;6.48 GB
14:12;6.54 GB
14:16;6.54 GB
14:19;6.54 GB
14:22;6.53 GB
14:25;6.42 GB
14:29;6.43 GB
14:32;6.44 GB
14:35;6.49 GB
14:38;6.48 GB
```

#### Plot

```default
$ onehost monitoring 0 USED_MEMORY --unit G --n 10

     Host 0 USED_MEMORY in GB from 09/06/2020 09:36 to 09/06/2020 14:38

 6.54 +----------------------------------------------------------------+
      |     *+     +     +      + A    +     +     +      +      +     |
 6.52 |-+  *                       *                                 +-|
      |   *                        *                                   |
      |  *                          *                                  |
  6.5 |-*                           *                                +-|
      |*                             *                        A******  |
 6.48 |-+                            *                       *       A-|
      |                               *                     *          |
      |                               *                    *           |
 6.46 |-+                              *                  *          +-|
      |                                *                 *             |
 6.44 |-+                               *            ***A            +-|
      |                                 *      **A***                  |
      |                                  * ****                        |
 6.42 |-+                                A*                          +-|
      |      +     +     +      +      +     +     +      +      +     |
  6.4 +----------------------------------------------------------------+
    14:09  14:12 14:15 14:18  14:21  14:24 14:27 14:30  14:33  14:36 14:39
                                    Time
```
