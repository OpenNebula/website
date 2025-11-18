---
title: OpenNebula NVIDIA Fabric Manager
linkTitle: NVIDIA Fabric Manager
weight: 8
---

<a id="one_fabricmanager"></a>

## Introduction

The OpenNebula NVIDIA&reg; Fabric Manager integration provides a complete solution for managing and virtualizing NVIDIA&reg; NVSwitch fabric within a cloud environment. The overall goal is to eliminate I/O bottlenecks in multi-GPU workloads by ensuring Virtual Machines (VMs) receive guaranteed and high-speed NVLink bandwidth, which is a significant advancement over standard GPU passthrough.

## NVIDIA Shared NVSwitch Virtualization Model

The NVIDIA Fabric Manager integration relies on the NVIDIA Shared NVSwitch Virtualization Model. This model is an evolution of simple GPU passthrough. It virtualizes the NVSwitch fabric to provide full NVLink bandwidth to multi-GPU VMs, even when the GPUs are allocated to separate VMs.

The following image shows the reference architecture proposed by NVIDIA:

![Reference architecture proposed by NVIDIA](/images/onefabric_virtualization_model.svg)

In the previous example image, we have three VMs running on the hypervisor: two Guest VMs and one Service VM.

The Service VM is responsible for managing the NVSwitches. It executes the commands to control GPU partitioning and configure the NVSwitches accordingly. The Guest VMs are configured with PCI passthrough for the GPUs and utilize the processing power. Each Guest VM is assigned the GPUs that comprise each of the active partitions of the NVSwitches.

Key components of the NVIDIA Shared NVSwitch Virtualization Model:

- **Service VM** (Fabric Manager VM): a persistent, minimal Virtual Machine runs on the KVM host.
- **PCI Passthrough:** the NVSwitch hardware devices are passed directly to this Service VM. The GPUs are passed directly to guest (workload) VMs.
- **Fabric Manager:** the NVIDIA Fabric Manager and associated NVIDIA tools run inside the Service VM, allowing it to dynamically reconfigure and manage the NVSwitches.

This allows NVIDIAFabric Manager Service to reconfigure the switches dynamically and fix the bandwidth limitations seen in plain GPU passthrough.

For additional information about NVIDIA Shared NVSwitch Virtualization Model, refer to the official [NVIDIA Fabric Manager](https://docs.nvidia.com/datacenter/tesla/fabric-manager-user-guide/index.html#shared-nvswitch-virtualization-model) documentation.


## The OpenNebula Approach

OpenNebula implements the NVIDIA Shared NVSwitch Virtualization Model through a two-part system designed for automation and centralized management:

1.  **Host Component (`opennebula-kvm-node` EE package):** the Enterprise Edition of the package is installed on each KVM host that contains NVSwitch devices. It provides a systemd service that manages a minimal, self-contained VM known as the "Fabric Manager VM". This VM is given direct, secure access to the NVSwitch hardware via PCI passthrough and contains the necessary NVIDIA tools like `nv-partitioner` and `nvswitch-audit` to manage the hardware.

The host component also includes a monitoring probe that runs periodically. It queries the Fabric Manager VM to get the current NVSwitch partitions and maps the logical GPU module IDs to the physical PCI addresses on the host. This information (`NVSWITCH_PARTITION`) is reported to OpenNebula, making the partition status and the GPU topology visible in the host's monitoring data for scheduling and management.

2.  **Frontend CLI (`onefabric`):** the primary user interface for the tool, managed from the OpenNebula frontend. It acts as a central point of control for the entire cluster. When you run a command like `onefabric list`, the tool uses SSH to connect to the relevant KVM hosts and remotely execute commands inside the Fabric Manager VM using `virsh` and the QEMU guest agent. This allows an administrator to manage the NVSwitch hardware across all hosts from a single console.

### Key Scenarios for OpenNebula NVIDIA Fabric Manager

The OpenNebula NVIDIA Fabric Manager Integration is essential for this cases:

- To enable Shared NVSwitch Virtualization for OpenNebula VMs.
- To dynamically partition NVSwitch devices across compute hosts.
- To ensure multi-GPU VMs receive full NVLink bandwidth.
- To monitor the status and topology of NVSwitch partitions in OpenNebula.

### Requirements

KVM Host requirements:

- NVIDIA NVSwitch Hardware: required on the KVM hosts.
- Host Software Component: the `opennebula-kvm-node EE package must be installed on all NVSwitch-equipped hosts.
- VFIO-PCI Drivers: the `vfio-pci driver must be enabled and loaded for the NVSwitch and GPU devices to allow PCI passthrough to the Service VM.
- Service VM Image: the required Fabric Manager VM image is handled and downloaded automatically during service startup.

OpenNebula Frontend requirements:

- onefabric CLI Tool: must be available on the OpenNebula frontend server. Installed by default on EE packages.
- Passwordless SSH Access: the frontend *oneadmin* user must have passwordless SSH access to the oneadmin user on all KVM hosts for remote command execution.


## Installation and Configuration

### Host Preparation and Component Installation

To begin the installation and configuration, we must verify that we meet the following prerequisites:

KVM Node Package: ensures that the `opennebula-kvm-node` EE package is installed on every KVM host that contains NVSwitch devices. This package contains the `opennebula-fabricmanager` service.

NVSwitch PCI passthrough Setup: The NVSwitch devices must be prepared for PCI passthrough using the vfio-pci driver. This can be done at OpenNebula deployment time using one-deploy, more information [here]({{% relref "../../../solutions/deployment_blueprints/ai-ready_opennebula/configuration_and_deployment.md" %}}). If this is not done during deployment, it is possible to manually configure the NVSwitches to use the virtio-pci driver by following the "Hypervisor Configuration" section from [NVIDIA GPU Passthrough]({{% relref "./nvidia_gpu_passthrough.md" %}}).

Once we have validated the prerequisites, we can start OpenNebula FabricManager service: the `opennebula-fabricmanager` service on the host is disabled by default, as it is designed to be started and stopped on demand or managed by the OpenNebula administrator. 

To start the service, run the following command on each virtualization node:

```bash
nvidia@opennebula-gpu01:~$ sudo systemctl start opennebula-fabricmanager.service
```

Once you start the service on each virtualization node, it executes pre-start scripts to prepare the VM environment, defines the `one-fabricmanager domain, and starts the VM.

During the start process the service will perform attempts to download the Fabric Manager VM image from a public URL. If you are working on an air-gapped installation, edit `/etc/onefabricmanager.conf` on each node in order to set a custom accessible URL with the image hosted.


### Validation (Post-Start)

The service startup process performs validation steps:

**NVSwitch Detection:** The service scans for NVSwitch devices (Vendor: 10de, Devices: 22a3) and confirms the vfio-pci driver is in use. These devices will be automatically added to the one-fabricmanager VM. If the devices have another IDs, you can add them into the configuration file on `/etc/onefabricmanager.conf` on the hosts nodes.

Example output during start:

```bash
nvidia@opennebula-gpu01:~$ systemctl status opennebula-fabricmanager.service
● opennebula-fabricmanager.service - OpenNebula FabricManager Service
Loaded: loaded (/usr/lib/systemd/system/opennebula-fabricmanager.service; disabled; preset: enabled)
Active: active (exited) since Sat 2025-11-15 09:08:27 UTC; 12s ago
Process: 498303 ExecStartPre=/usr/lib/one/download-image.sh (code=exited, status=0/SUCCESS)
Process: 498304 ExecStartPre=/usr/bin/test -f /etc/one/one-fabricmanager.xml (code=exited, status=0/SUCCESS)
Process: 498307 ExecStartPre=/usr/lib/one/prepare_vm_xml.sh (code=exited, status=0/SUCCESS)
Process: 500092 ExecStartPre=/bin/bash -c virsh -c qemu:///system dominfo one-fabricmanager >/dev/null 2>&1 || virsh -c qemu:///system define >
Process: 500112 ExecStart=/usr/bin/virsh -c qemu:///system start one-fabricmanager (code=exited, status=0/SUCCESS)
Main PID: 500112 (code=exited, status=0/SUCCESS)
CPU: 5.063s
Nov 15 09:08:18 opennebula-gpu01 download-image.sh[498303]: Image already exists at /var/lib/one/fabricmanager/service_FabricManager-7.0.0>
Nov 15 09:08:18 opennebula-gpu01 prepare_vm_xml.sh[498307]: Scanning for NVSwitch devices (Vendor: 10de, Devices: 22a3)...
Nov 15 09:08:18 opennebula-gpu01 prepare_vm_xml.sh[498307]: [OK] Found valid NVSwitch: 0000:07:00.0 (Driver: vfio-pci)
Nov 15 09:08:18 opennebula-gpu01 prepare_vm_xml.sh[498307]: [OK] Found valid NVSwitch: 0000:08:00.0 (Driver: vfio-pci)
Nov 15 09:08:18 opennebula-gpu01 prepare_vm_xml.sh[498307]: [OK] Found valid NVSwitch: 0000:09:00.0 (Driver: vfio-pci)
Nov 15 09:08:18 opennebula-gpu01 prepare_vm_xml.sh[498307]: [OK] Found valid NVSwitch: 0000:0a:00.0 (Driver: vfio-pci)
Nov 15 09:08:23 opennebula-gpu01 prepare_vm_xml.sh[498307]: Generated final XML at /var/lib/one/fabricmanager/one-fabricmanager.xml
Nov 15 09:08:23 opennebula-gpu01 bash[500092]: Domain 'one-fabricmanager' defined from /var/lib/one/fabricmanager/one-fabricmanager.xml
Nov 15 09:08:27 opennebula-gpu01 virsh[500112]: Domain 'one-fabricmanager' started
Nov 15 09:08:27 opennebula-gpu01 systemd[1]: Finished opennebula-fabricmanager.service - OpenNebula FabricManager Service.
```

After service starts you can check the artifacts generated by the service:

```bash
oneadmin@opennebula-gpu01:~$ ls -l fabricmanager/
total 3543304
-rw-r--r-- 1 oneadmin oneadmin       2135 Nov 15 09:08 one-fabricmanager.xml
-rw-r--r-- 1 oneadmin oneadmin 1493499904 Nov 15 09:11 service_FabricManager-<version>.qcow2
```
- `one-fabricmanager.xml`: This is the libvirt Domain XML file generated by the service. It defines the configuration for the Fabric Manager Service VM (named one-fabricmanager). This XML includes essential settings like CPU, memory, and critically, the PCI passthrough definitions that securely grant the VM direct access to the NVSwitch hardware devices on the KVM host.
- `service_FabricManager-<version>.qcow2`: This is the disk image (QCOW2 format) for the Fabric Manager Service VM. It contains the minimal operating system, the NVIDIA® Fabric Manager tools (nv-partitioner, nvswitch-audit), and the necessary configuration files required for the VM to boot and manage the NVSwitch hardware.

**VM Running:** The Service VM, named one-fabricmanager, should be running in virsh list.

Example:

```bash
oneadmin@opennebula-gpu01:~$ virsh list
...
 Id   Name                State
-----------------------------------
 10   one-fabricmanager   running
```

We can also do this validation using `opennebula-fabricmanager.rb` script on the host:

```bash
oneadmin@opennebula-gpu01:~$ /usr/lib/one/opennebula-fabricmanager.rb --status
Systemd service status:
● opennebula-fabricmanager.service - OpenNebula FabricManager Service
Loaded: loaded (/usr/lib/systemd/system/opennebula-fabricmanager.service; disabled; preset: enabled)
...
Nov 15 09:08:27 opennebula-gpu01 virsh[500112]: Domain 'one-fabricmanager' started

VM state (libvirt): running
```

## Fabric Manager Usage

The OpenNebula NVIDIA Fabric Manager is intended to use via `onefabric` commands, the central point of control, this tool will execute commands remotely via SSH against the KVM hosts and interacting with the Fabric Manager VM using the QEMU guest agent.

`onefabric` key Commands:

*   `onefabric list [--csv]`: Lists NVSwitch partitions. Use `--csv` for script-friendly output.
*   `onefabric activate <partition_id>`: Activates a specific hardware partition.
*   `onefabric deactivate <partition_id>`: Deactivates a specific hardware partition.
*   `onefabric audit`: Runs the `nvswitch-audit` tool inside the Fabric Manager VM.
*   `onefabric exec "<shell_command>"`: Executes an arbitrary shell command inside the Fabric Manager VM.

All commands can be scoped using optional arguments:

`--host <id/name>`:	Target a specific OpenNebula Host ID or Name.
`--cluster <id/name>`:	Target all hosts within a specific Cluster ID or Name.

If these parameters are not used, the command will be executed for all available hosts.

> **IMPORTANT:** You must manually deactivate any currently active partition that shares GPU resources with the new partition you wish to activate. The Fabric Manager does not automatically resolve resource conflicts, meaning you cannot activate a new partition if its required GPUs or NVLinks are already claimed by an active partition. For example, activating Partition 0 (8 GPUs) will fail if Partitions 1 and 2 (which together use all 8 GPUs) are currently active.
{.warning}

> The `onefabric` command remotely executes the `/usr/lib/one/opennebula-fabricmanager.rb` script available on the virtualization nodes. The administrator can then execute all commands from the host itself by directly using that script.
{.note}

### Partitioning configuration Example:

- List available Partitions on a Host using `onefabric list` command:

```bash
onefabric list --host 0
Output shows partitions, GPU Module IDs, and current STATUS (e.g., INACTIVE):

Partition ID   Number of GPUs GPU Module ID            Max NVLinks/GPU     STATUS
--------------------------------------------------------------------------------
0              8              1, 2, 3, 4, 5, 6, 7, 8   18                  INACTIVE
1              4              1, 2, 3, 4               18                  INACTIVE
...
```

- Activate Multiple Partitions (Example: Splitting the 8 GPUs into two 4-GPU groups) on host ID 0:

First, check that no partitions are active (onefabric list). Then activate both using `onefabric activate` command:

```bash
oneadmin@opennebula-gpu01:~$ onefabric activate 1 --host 0
Executing on 1 host(s).
Command: /usr/lib/one/opennebula-fabricmanager.rb --activate 1

--- [Host 0: 172.16.0.106] (remote) ---
Executing inside FabricManager VM: nv-partitioner -o 1 -p '1'
Successfully connected to Fabric Manager at 127.0.0.1
Successfully sent activation request for partition 1


oneadmin@opennebula-gpu01:~$ onefabric activate 2 --host 0
Executing on 1 host(s).
Command: /usr/lib/one/opennebula-fabricmanager.rb --activate 2

--- [Host 0: 172.16.0.106] (remote) ---
Executing inside FabricManager VM: nv-partitioner -o 1 -p '2'
Successfully connected to Fabric Manager at 127.0.0.1
Successfully sent activation request for partition 2
```

- Verification:

Using `onefabric list` command:

```bash
oneadmin@opennebula-gpu01:~$ onefabric list --host 0
Executing on 1 host(s).
Command: /usr/lib/one/opennebula-fabricmanager.rb --list

--- [Host 0: 172.16.0.106] (remote) ---
Executing inside FabricManager VM: nv-partitioner -o 0
Successfully connected to Fabric Manager at 127.0.0.1
Total supported partitions: 15

Partition ID   Number of GPUs GPU Module ID            Max NVLinks/GPU     STATUS
--------------------------------------------------------------------------------
0              8              1, 2, 3, 4, 5, 6, 7, 8   18                  INACTIVE
1              4              1, 2, 3, 4               18                  ACTIVE
2              4              5, 6, 7, 8               18                  ACTIVE
3              2              1, 3                     18                  INACTIVE
4              2              2, 4                     18                  INACTIVE
...
```

Using `onefabric audit` command:

```bash
oneadmin@opennebula-gpu01:~$ onefabric audit --host 0
Executing on 1 host(s).
Command: /usr/lib/one/opennebula-fabricmanager.rb --audit

--- [Host 0: 172.16.0.106] (remote) ---
Executing inside FabricManager VM: nvswitch-audit

GPU Reachability Matrix
GPU Physical Id      1  2  3  4  5  6  7  8
		  1 18 18 18 18  0  0  0  0
		  2 18 18 18 18  0  0  0  0
		  3 18 18 18 18  0  0  0  0
		  4 18 18 18 18  0  0  0  0
		  5  0  0  0  0 18 18 18 18
		  6  0  0  0  0 18 18 18 18
		  7  0  0  0  0 18 18 18 18
		  8  0  0  0  0 18 18 18 18
```

(The example above shows full 18-link connectivity for the active partitions 1 and 2)

### Monitoring 

**Partition Status Commands**

The primary way to check the final operational state is using `onefabric list` and `onefabric audit` commands (as shown in the examples above).

**Monitoring Probe**

The OpenNebula host component includes a periodic monitoring probe. This probe connects to the Fabric Manager VM to retrieve the current NVSwitch partitions and the mapping of logical GPU module IDs to physical PCI addresses.

This data is reported back to OpenNebula, making the partition status visible to the OpenNebula scheduler and management interface. The partition information is reported in the host's monitoring data under the **NVSWITCH_PARTITION** attribute.

Checking with `onehost show`: After activating one or more partitions, the details appear in the host's monitoring information:

Example with Partitions 1 and 2 (4 GPUs each) Active:

```bash
oneadmin@opennebula-gpu01:~$ onehost show 0
HOST 0 INFORMATION
ID : 0
NAME : 172.16.0.106
CLUSTER : default
STATE : MONITORED
IM_MAD : kvm
VM_MAD : kvm
LAST MONITORING TIME : 11/15 12:07:31

HOST SHARES
RUNNING VMS : 1
MEMORY
TOTAL : 2T
TOTAL +/- RESERVED : 2T
USED (REAL) : 154.2G
USED (ALLOCATED) : 32G
CPU
TOTAL : 22400
TOTAL +/- RESERVED : 22400
USED (REAL) : 224
USED (ALLOCATED) : 20800

LOCAL SYSTEM DATASTORE #0 CAPACITY
TOTAL: : 1.7T
USED: : 504.4G
FREE: : 1.3T

MONITORING INFORMATION
ARCH="x86_64"
CGROUPS_VERSION="2"
CPUSPEED="0"
HOSTNAME="opennebula-gpu01"
...
MODELNAME="Intel(R) Xeon(R) Platinum 8480C"
NVSWITCH_PARTITION=[
  NUM_GPUS="4",
  PARTITION_GPU_ADDR="0000:c3:00.0 0000:df:00.0 0000:d1:00.0 0000:9d:00.0",
  PARTITION_GPU_IDS="1 2 3 4",
  PARTITION_ID="1",
  PARTITION_STATUS="ACTIVE" ]
NVSWITCH_PARTITION=[
  NUM_GPUS="4",
  PARTITION_GPU_ADDR="0000:43:00.0 0000:61:00.0 0000:52:00.0 0000:1b:00.0",
  PARTITION_GPU_IDS="5 6 7 8",
  PARTITION_ID="2",
  PARTITION_STATUS="ACTIVE" ]
```

> Please note that after activating or deactivating an NVSwitch partition, the probe may take some time to run (defined in `/etc/one/monitord.conf`), so the information may take a while to update. If you want to force the execution, you can use the `onehost forceupdate` command against the specific host.
{.note}
