---
title: "Monitoring Driver"
date: "2025-02-17"
description:
categories:
pageintoc: "294"
tags:
weight: "4"
---

<a id="devel-im"></a>

<!--# Monitoring Driver -->

The Monitoring Drivers (or IM drivers) collect Host and Virtual Machine monitoring data by executing a monitoring agent in the Hosts. The agent periodically executes probes to collect data and periodically send this to the Front-end.

This guide describes the internals of the monitoring system. It is also a starting point on how to create a new IM driver from scratch.

## Message structure

The structure of monitoring message is:

```default
MESSAGE_TYPE ID RESULT TIMESTAMP PAYLOAD
```

| Name         | Description                                                    |
|--------------|----------------------------------------------------------------|
| MESSAGE_TYPE | SYSTEM_HOST, MONITOR_HOST, BEACON_HOST, MONITOR_VM or STATE_VM |
| ID           | ID of the Host, which generates the message.                   |
| RESULT       | Result of the action, possible values SUCCESS or FAILURE       |
| TIMESTAMP    | Timestamp of the message as unix epoch time                    |
| PAYLOAD      | Message data, depends on MESSAGE_TYPE                          |

Description of message types:

- **SYSTEM_HOST** - General information about the Host, which doesn’t change too often (e.g., total memory, disk capacity, datastores, pci devices, NUMA nodes…)
- **MONITOR_HOST** - Monitoring information: used memory, used cpu, network traffic…
- **BEACON_HOST** - notification message, indicating that the agent is still alive
- **MONITOR_VM** - VMs monitoring information: used memory, used CPUs, disk io…
- **STATE_VM** - VMs state: running, poweroff…

The provided hypervisors compose each message from data provided by probes in a specific directory:

- SYSTEM_HOST - `im/<hypervisor>-probes.d/host/system`
- MONITOR_HOST - `im/<hypervisor>-probes.d/host/monitor`
- BEACON_HOST - `im/<hypervisor>-probes.d/host/beacon`
- MONITOR_VM - `im/<hypervisor>-probes.d/vm/monitor`
- STATE_VM - `im/<hypervisor>-probes.d/vm/status`

Each IM probe is composed of one or several scripts that write information to `stdout` in this form:

```default
KEY1="value"
KEY2="another value with spaces"
```

<a id="devel-im-basic-monitoring-scripts"></a>

## Basic Monitoring Scripts

Mandatory values for each category are described below:

### SYSTEM_HOST Message

| Key         | Description                                                                                                 |
|-------------|-------------------------------------------------------------------------------------------------------------|
| HYPERVISOR  | Name of the hypervisor of the Host, useful for<br/>selecting the hosts with an specific technology.         |
| TOTALCPU    | Number of CPUs multiplied by 100. For example,<br/>a 16 cores machine will have a value of 1600.            |
| CPUSPEED    | Speed in Mhz of the CPUs.                                                                                   |
| TOTALMEMORY | Maximum memory that could be used for VMs. It is advised<br/>to take out the memory used by the hypervisor. |

### MONITOR_HOST Message

| Key        | Description                                                                                                                                         |
|------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| USEDMEMORY | Memory used, in kilobytes.                                                                                                                          |
| FREEMEMORY | Available memory for VMs at that moment, in kilobytes.                                                                                              |
| FREECPU    | Percentage of idling CPU multiplied by the number of cores. For example, if 50%<br/>of the CPU is idling in a 4 core machine the value will be 200. |
| USEDCPU    | Percentage of used CPU multiplied by the number of cores.                                                                                           |
| NETRX      | Received bytes from the network                                                                                                                     |
| NETTX      | Transferred bytes to the network                                                                                                                    |

### BEACON_HOST Message

No data

### MONITOR_VM Message

The format of the MONITOR_VM Message:

```default
VM = [ ID="0",
       UUID="6c1e1565-50f4-43b6-ba71-0fe46477d2ec",
       MONITOR="Q1BVPSIxLjAxIgpNRU1PUlk9IjE0MDgxNiIKTkVUUlg9IjAiCk5FVFRYPSIwIgpESVNLUkRCWVRFUz0iNDQxNjU0NDQiCkRJU0tXUkJZVEVTPSIxMjY2Njg4IgpESVNLUkRJT1BTPSIxMjg5IgpESVNLV1JJT1BTPSI4ODEiCg=="]
VM = [ ID="1",
       ... ]
```

| Key         | Description                                                                                |
|-------------|--------------------------------------------------------------------------------------------|
| ID          | ID of the VM in OpenNebula.                                                                |
| UUID        | Unique ID, must be unique across all Hosts.                                                |
| MONITOR     | Base64 encoded monitoring information, the monitoring information includes following data: |
| TIMESTAMP   | Timestamp of the measurement.                                                              |
| CPU         | Percentage of 1 CPU consumed (two fully consumed cpu is 200).                              |
| MEMORY      | MEMORY consumption in kilobytes.                                                           |
| DISKRDBYTES | Amount of bytes read from disk.                                                            |
| DISKRDIOPS  | Number of IO read operations.                                                              |
| DISKWRBYTES | Amount of bytes written to disk.                                                           |
| DISKWRIOPS  | Number of IO write operations.                                                             |
| NETRX       | Received bytes from the network.                                                           |
| NETTX       | Sent bytes to the network.                                                                 |

### STATE_VM Message

The format of the STATE_VM message is:

```default
VM=[
  ID=115,
  DEPLOY_ID=one-115,
  UUID="6c1e1565-50f4-43b6-ba71-0fe46477d2ec",
  STATE="RUNNING" ]
VM=[
  ID=116,
  DEPLOY_ID=one-116,
  UUID="1a3f2513-50f4-43b6-ba71-0fe46477d2ec",
  STATE="POWEROFF" ]
```

| Key       | Description                                             |
|-----------|---------------------------------------------------------|
| ID        | ID of the VM in OpenNebula.                             |
| DEPLOY_ID | ID of the VM in the hypervisor, usually unique in Host. |
| UUID      | Unique ID, must be unique across all Hosts.             |
| STATE     | State of the VM (running, poweroff, …).                 |

<a id="devel-im-vm-information"></a>

## System Datastore Information

Monitoring probes are also responsible to collect the datastore sizes and its available space. The datastores information is included in SYSTEM_HOST message.

```default
DS_LOCATION_USED_MB=1
DS_LOCATION_TOTAL_MB=12639
DS_LOCATION_FREE_MB=10459
DS = [
  ID = 0,
  USED_MB = 1,
  TOTAL_MB = 12639,
  FREE_MB = 10459
]
DS = [
  ID = 1,
  USED_MB = 1,
  TOTAL_MB = 12639,
  FREE_MB = 10459
]
DS = [
  ID = 2,
  USED_MB = 1,
  TOTAL_MB = 12639,
  FREE_MB = 10459
]
```

These are the meanings of the values:

| Variable             | Description                                                        |
|----------------------|--------------------------------------------------------------------|
| DS_LOCATION_USED_MB  | Used space in megabytes in the DATASTORE LOCATION                  |
| DS_LOCATION_TOTAL_MB | Total space in megabytes in the DATASTORE LOCATION                 |
| DS_LOCATION_FREE_MB  | FREE space in megabytes in the DATASTORE LOCATION                  |
| ID                   | ID of the datastore, this is the same as the name of the directory |
| USED_MB              | Used space in megabytes for that datastore                         |
| TOTAL_MB             | Total space in megabytes for that datastore                        |
| FREE_MB              | Free space in megabytes for that datastore                         |

The DATASTORE LOCATION is the path where the datastores are mounted. By default, it is `/var/lib/one/datastores` but it is specified in the second parameter of the script call.

## Creating a New IM Driver

### Choosing the Execution Engine

OpenNebula provides two IM probe execution engines: `one_im_sh` and `one_im_ssh`. `one_im_sh` is used to execute probes in the Front-end; `one_im_ssh` is used when probes need to be run remotely on the Hosts, which is the case for `KVM`.

### Populating the Probes

Both `one_im_sh` and `one_im_ssh` require an argument which indicates the directory that contains the probes. This argument is appended with ”.d”. Also, you need to create:

- The `/var/lib/one/remotes/im/<im_name>.d` directory with **only** 2 files, the same ones that are provided by default inside `kvm.d`, which are: `collectd-client_control.sh` and `collectd-client.rb`.
- The probes should be actually placed in the `/var/lib/one/remotes/im/<im_name>-probes.d` folder.

### Enabling the Driver

A new IM section should be placed added to `monitord.conf`.

Example:

```default
IM_MAD = [
      name       = "ganglia",
      executable = "one_im_sh",
      arguments  = "ganglia" ]
```
