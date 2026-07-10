---
title: "NVIDIA GPU Passthrough"
linkTitle: "NVIDIA GPU (vGPU, MIG, Passthrough)"
date: "2025-10-16"
description:
categories:
pageintoc: "58"
tags: ['AI','NVIDIA']
weight: "5"
---

## Overview

This guide describes how to deploy NVIDIA GPUs using PCI passthrough technologies in OpenNebula. OpenNebula supports multiple NVIDIA GPU deployment models, including conventional PCI passthrough, NVIDIA vGPU, MIG-backed vGPU, and NVIDIA Grace platform virtualization. While these deployment models share the same scheduling and deployment workflow, each requires a different host configuration.

The generic PCI passthrough configuration, including IOMMU, VFIO, Huge Pages, PCI monitoring, and device discovery, is described in the [**Host Configuration**]({{% relref "product/cluster_configuration/pci_passthrough_sriov/host_configuration/" %}}) guide. This guide focuses exclusively on the NVIDIA-specific configuration and deployment procedures for each supported deployment model.

## Deployment Models

NVIDIA GPUs can be deployed in OpenNebula using one of the following deployment models.

| Deployment Model | Typical Platforms | VFIO Driver | Additional Configuration |
| ----- | ----- | ----- | ----- |
| Conventional PCI Passthrough | H100 PCIe, H100 SXM, H200, L40, L40S, RTX, A100 | `vfio-pci` | Standard PCI passthrough |
| NVIDIA vGPU / MIG-backed vGPU | A100, H100, H200, B200 | NVIDIA vGPU stack | NVIDIA vGPU or MIG-backed vGPU configuration |
| Grace Platform Virtualization | GH200, GB200 | `nvgrace_gpu_vfio_pci` | Grace-specific virtualization configuration |

For **conventional PCI passthrough**, the NVIDIA driver is **not required** on the host. The GPU is owned exclusively by the guest operating system, where the NVIDIA driver is installed after deployment.

For **NVIDIA vGPU** and **MIG-backed vGPU**, the NVIDIA driver is required on the host because the host manages GPU partitioning and virtual GPU creation before assigning GPU resources to virtual machines.

---

## Conventional PCI Passthrough

## Overview

Conventional PCI passthrough assigns one or more physical NVIDIA GPUs directly to a virtual machine, providing the guest operating system with exclusive access to the assigned devices. In this deployment model, the host does not use the GPUs, which are instead bound to the `vfio-pci` driver and managed entirely by the guest operating system.

This deployment model is recommended for workloads requiring direct access to the GPU, such as AI training and inference, high-performance computing (HPC), scientific computing, visualization, and CUDA development. It is supported by NVIDIA PCIe and SXM GPUs, including NVIDIA H100, H200, L40, L40S, RTX, and A100 GPUs when Multi-Instance GPU (MIG) is not enabled.

## Requirements

Before deploying NVIDIA GPUs using conventional PCI passthrough, complete the generic PCI passthrough configuration described in the **Host Configuration** guide.

Verify that the host satisfies the following requirements:

* Hardware-assisted virtualization and the IOMMU are enabled.  
* The GPU is bound to the `vfio-pci` driver.  
* PCI monitoring is configured to discover NVIDIA GPUs.  
* The GPUs have been discovered by OpenNebula.

Verify that the GPU is managed by the `vfio-pci` driver:

```shell
lspci -nnk -d 10de:
```

Example output:

```
81:00.0 3D controller: NVIDIA Corporation H100 PCIe
       Kernel driver in use: vfio-pci

81:00.1 Audio device: NVIDIA Corporation Device xxxx
       Kernel driver in use: vfio-pci
```

Verify that the GPUs have been discovered by OpenNebula:

```shell
onehost show <host>
```

The GPUs should appear in the **PCI Devices** section and be available for scheduling.

{{< alert title="Note" type="primary" >}}
Unlike NVIDIA vGPU or MIG-backed vGPU deployments, the NVIDIA driver is not required on the host for conventional PCI passthrough. The GPU is owned exclusively by the guest operating system, where the NVIDIA driver is installed after deployment.{{< /alert >}}

---

## Host Configuration

This section describes the NVIDIA-specific configuration required after completing the generic PCI passthrough configuration. If the NVIDIA driver is installed on the host, prevent it from binding to GPUs intended for passthrough by blacklisting the NVIDIA kernel modules.

Create the following configuration file:

```default
/etc/modprobe.d/blacklist-nvidia.conf
```

Example contents:

```default
blacklist nouveau
blacklist nvidia
blacklist nvidia_drm
blacklist nvidia_modeset
blacklist nvidia_uvm
```

Regenerate the initramfs using the appropriate command for your Linux distribution and reboot the host.

{{< alert title="Note" type="primary" >}}
This step is only required if the NVIDIA driver is installed on the host. Hosts dedicated to GPU PCI passthrough typically do not require the NVIDIA driver.{{< /alert >}}

### Verify the GPU Driver

After completing the generic PCI passthrough configuration, verify that all GPU PCI functions are managed by the `vfio-pci` driver.

```shell
lspci -nnk -d 10de:
```

Example output:

```
81:00.0 3D controller: NVIDIA Corporation H100 PCIe
       Kernel driver in use: vfio-pci

81:00.1 Audio device: NVIDIA Corporation Device xxxx
       Kernel driver in use: vfio-pci
```

If any GPU function is still managed by the NVIDIA or Nouveau driver, review the VFIO configuration described in the **Host Configuration** guide.

{{< alert title="Note" type="primary" >}}
NVIDIA GPUs may expose multiple PCI functions, such as audio or USB controllers. All functions belonging to the GPU should be assigned together to the same virtual machine.{{< /alert >}}

### Verify GPU Discovery

After the next monitoring cycle, verify that OpenNebula has discovered the GPUs.

```shell
onehost show <host>
```

Example output:

```
PCI DEVICES

 VM ADDR TYPE           NAME                                              
 e1:00.0 10de:2321:0302 NVIDIA Corporation GH100 [H100L 94GB]
```

The GPUs should appear in the **PCI Devices** section and be available for scheduling.

Alternatively, the detected PCI devices can be inspected from the **PCI Devices** tab in Sunstone.

---

## Deploying a Virtual Machine

After the host has been configured and the GPUs have been discovered by OpenNebula, they can be assigned to virtual machines using the standard `PCI` attribute in the Virtual Machine Template.

OpenNebula supports both automatic and explicit GPU selection. Automatic selection is recommended because it allows the scheduler to place workloads on any compatible host, improving workload portability and resource utilization.

### Automatic GPU Selection

The following example requests any available NVIDIA GPU:

```
PCI = [
    CLASS  = "0302",
    VENDOR = "10de"
]
```

During deployment, OpenNebula selects a compatible GPU that matches the requested attributes and assigns it to the virtual machine.

Additional `PCI` attributes, such as `DEVICE` or `SHORT_ADDRESS`, can be used to further restrict device selection when required.

### Selecting a Specific GPU

For topology-sensitive deployments, benchmarking, or debugging, a specific GPU can be requested using its PCI address.

For example:

```
PCI = [
    SHORT_ADDRESS = "81:00.0"
]
```

Explicit device selection should be reserved for specialized deployments. In most environments, automatic GPU selection provides greater flexibility and simplifies workload scheduling.

### Assigning Multiple GPUs

Multiple GPUs can be assigned to the same virtual machine by including multiple `PCI` sections.

The following example requests two NVIDIA GPUs:

```
PCI = [
    CLASS  = "0302",
    VENDOR = "10de"
]

PCI = [
    CLASS  = "0302",
    VENDOR = "10de"
]
```

Each `PCI` section requests one compatible GPU. During deployment, OpenNebula assigns the requested number of devices to the virtual machine.

---

## Example H100 Virtual Machine Template

The following example shows a Virtual Machine Template for an NVIDIA H100 SXM system with eight GPUs assigned through PCI passthrough.

```default
CONTEXT = [
    NETWORK        = "YES",
    SSH_PUBLIC_KEY = "$USER[SSH_PUBLIC_KEY]"
]

CPU    = "208"
VCPU   = "208"
MEMORY = "716800"

CPU_MODEL = [
    MODEL = "host-passthrough"
]

TOPOLOGY = [
    CORES      = "52",
    SOCKETS    = "2",
    THREADS    = "2",
    PIN_POLICY = "THREAD"
]

OS = [
    ARCH            = "x86_64",
    FIRMWARE        = "/usr/share/OVMF/OVMF_CODE_4M.fd",
    FIRMWARE_SECURE = "NO",
    MACHINE         = "pc-q35-jammy"
]

DISK = [
    IMAGE = "ubuntu-24.04-gpu",
    SIZE  = "1572864"
]

NIC = [
    NETWORK = "admin_net"
]

GRAPHICS = [
    LISTEN = "0.0.0.0",
    TYPE   = "vnc"
]

FEATURES = [
    PCIHOLE64 = "2147483648"
]

PCI = [ SHORT_ADDRESS = "1b:00.0" ]
PCI = [ SHORT_ADDRESS = "43:00.0" ]
PCI = [ SHORT_ADDRESS = "52:00.0" ]
PCI = [ SHORT_ADDRESS = "61:00.0" ]
PCI = [ SHORT_ADDRESS = "9d:00.0" ]
PCI = [ SHORT_ADDRESS = "c3:00.0" ]
PCI = [ SHORT_ADDRESS = "d1:00.0" ]
PCI = [ SHORT_ADDRESS = "df:00.0" ]
```

The `PCI` entries assign the eight H100 GPUs to the virtual machine.

---

## Guest Configuration

After the virtual machine has been deployed, verify that the GPUs are visible inside the guest:

```shell
lspci | grep -i nvidia
```

Example output:

```
23:00.0 3D controller: NVIDIA Corporation GH100 [H100 SXM5 80GB]
24:00.0 3D controller: NVIDIA Corporation GH100 [H100 SXM5 80GB]
25:00.0 3D controller: NVIDIA Corporation GH100 [H100 SXM5 80GB]
26:00.0 3D controller: NVIDIA Corporation GH100 [H100 SXM5 80GB]
43:00.0 3D controller: NVIDIA Corporation GH100 [H100 SXM5 80GB]
44:00.0 3D controller: NVIDIA Corporation GH100 [H100 SXM5 80GB]
45:00.0 3D controller: NVIDIA Corporation GH100 [H100 SXM5 80GB]
46:00.0 3D controller: NVIDIA Corporation GH100 [H100 SXM5 80GB]
```

Install the appropriate NVIDIA driver inside the guest operating system. The selected driver version must support the assigned GPU model and be compatible with the required CUDA software stack.

After installing the driver, verify that all assigned GPUs are detected:

```shell
nvidia-smi
```

Use the output provided in the NVIDIA qualification guide for your platform to verify that all assigned GPUs are present and that no driver or hardware errors are reported. Avoid using placeholder outputs, as driver versions and formatting vary across NVIDIA software releases.

## NVIDIA vGPU and MIG-backed vGPU

### Overview

NVIDIA vGPU enables multiple virtual machines to share the resources of a physical GPU by exposing one or more virtual GPU (vGPU) profiles that can be independently assigned to guest operating systems.

Depending on the GPU generation, vGPU profiles can be created using one of two deployment models:

* **NVIDIA vGPU**, where virtual GPU profiles are created directly by the NVIDIA AI Enterprise software stack.  
* **MIG-backed vGPU**, where the GPU is first partitioned using NVIDIA Multi-Instance GPU (MIG), and one or more vGPU profiles are created from the resulting GPU Instances.

Regardless of how the profiles are created, OpenNebula automatically discovers the available vGPU profiles during host monitoring and schedules them as GPU resources that can be assigned to virtual machines.

Before deploying NVIDIA vGPU devices, complete the generic PCI passthrough configuration described in the **Host Configuration** guide.

---

## Requirements

Before continuing, verify that the host satisfies the following requirements:

* A supported NVIDIA GPU is installed.  
* The NVIDIA host driver is installed and operational.  
* PCI monitoring is configured.  
* The GPU has been discovered by OpenNebula.

Verify that the NVIDIA driver is correctly installed:

```shell
nvidia-smi
```

Verify that the GPU has been discovered by OpenNebula:

```shell
onehost show <host>
```

The GPU should appear in the **PCI Devices** section.

---

### Host Configuration

Depending on the GPU model, configure either **NVIDIA vGPU** or **MIG-backed vGPU**.

#### Configure NVIDIA vGPU

Conventional NVIDIA vGPU is supported on GPUs that expose vGPU profiles directly through the NVIDIA AI Enterprise software stack.

Install the NVIDIA AI Enterprise software stack and the NVIDIA vGPU Manager according to the NVIDIA documentation.

After installation, verify that the NVIDIA driver is operational:

```shell
nvidia-smi
```

Display the supported vGPU profiles:

```shell
nvidia-smi vgpu -s -v
```

The command lists all vGPU profiles supported by the GPU.

After the next monitoring cycle, OpenNebula automatically discovers the available vGPU profiles.

## Configure MIG-backed vGPU

Hopper and newer GPUs support creating vGPU profiles from GPU partitions created using NVIDIA Multi-Instance GPU (MIG).

### Enable MIG Mode

Display the current MIG configuration:

```shell
nvidia-smi -i 0 -q | grep MIG -A2
```

Enable MIG mode:

```shell
sudo nvidia-smi -i 0 -mig 1
```

Verify that MIG mode has been enabled:

```shell
nvidia-smi -i 0 -q | grep MIG -A2
```

Example output:

```default
MIG Mode
    Current                  : Enabled
    Pending                  : Enabled
```

Some GPU models require a reboot before MIG mode becomes active.

---

### Display Available GPU Instance Profiles

Display the supported GPU Instance profiles:

```shell
nvidia-smi mig -lgip
```

Example output:

```shell
+-----------------------------------------------------------------------------+
| GPU instance profiles:                                                      |
| GPU   Name             ID    Instances   Memory     SM    DEC   ENC   OFA   |
|       Profile                Free/Total  GiB        CE                      |
|=============================================================================|
|   0  MIG 1g.10gb        19     7/7        9.62       16     0     0     0   |
|   0  MIG 2g.20gb        14     3/3       19.50       32     1     0     0   |
|   0  MIG 3g.40gb         9     2/2       39.25       60     2     0     0   |
+-----------------------------------------------------------------------------+
```

Display the supported GPU Instance placements:

```shell
nvidia-smi mig -lgipp
```

### Create GPU and Compute Instances

Create the desired GPU Instances.

For example, the following command creates four **1g.10gb** GPU Instances together with their default Compute Instances:

```shell
sudo nvidia-smi mig -cgi 19,19,19,19 -C
```

Verify the resulting MIG devices:

```shell
nvidia-smi -L
```

Example output:

```
GPU 0: NVIDIA H100 PCIe

  MIG 1g.10gb Device 0: (UUID: MIG-xxxxxxxx)
  MIG 1g.10gb Device 1: (UUID: MIG-xxxxxxxx)
  MIG 1g.10gb Device 2: (UUID: MIG-xxxxxxxx)
  MIG 1g.10gb Device 3: (UUID: MIG-xxxxxxxx)
```

### Configure vGPU Profiles

After creating the GPU and Compute Instances, configure the required NVIDIA vGPU profiles according to the NVIDIA AI Enterprise documentation.

Verify the available profiles:

```shell
nvidia-smi vgpu -s -v
```

### Refresh OpenNebula Monitoring

Once the GPU configuration has been completed, refresh host monitoring:

```shell
onehost forceupdate <hostid>
```

Verify that the configured vGPU profiles have been discovered:

```shell
onehost show <host>
```

The configured profiles should appear in the **PCI Devices** section and be available for scheduling.

---

### Deploying a Virtual Machine

Virtual machines request NVIDIA vGPU resources by selecting one of the vGPU profiles discovered during host monitoring.

The available profiles can be inspected from the **PCI Devices** tab in Sunstone or using:

```shell
onehost show <host>
```

Each discovered profile reports the profile name together with the number of available instances.

---

**Example Virtual Machine Template**

Virtual machines request NVIDIA vGPU resources using the `PCI` attribute. The `PROFILE` attribute must match one of the profiles discovered during host monitoring.

The following example requests an NVIDIA L40S-2B vGPU profile:

```
PCI = [
    CLASS   = "0302",
    DEVICE  = "26b9",
    PROFILE = "1146 (NVIDIA L40S-2B)",
    VENDOR  = "10de"
]
```

When the virtual machine is deployed, OpenNebula allocates a compatible GPU exposing the requested profile.

For MIG-backed vGPU deployments, the deployment workflow is identical. The available profiles are generated from the configured GPU Instances and automatically discovered during host monitoring.

---

### Guest Configuration

After the virtual machine has been deployed, install the NVIDIA guest driver corresponding to the selected NVIDIA vGPU software release.

Refer to the NVIDIA AI Enterprise documentation or your Linux distribution for instructions on installing the appropriate guest driver.

After the installation completes, verify that the assigned virtual GPU is detected:

```shell
nvidia-smi
```

Use the output provided by the NVIDIA vGPU software stack for your selected profile to verify that:

* the assigned virtual GPU is detected correctly;  
* the reported GPU name matches the selected vGPU profile;  
* no driver or hardware errors are reported.

The guest configuration is identical for conventional NVIDIA vGPU and MIG-backed vGPU deployments. Once deployed, the guest operating system interacts with the assigned virtual GPU transparently, regardless of how the profile was created.