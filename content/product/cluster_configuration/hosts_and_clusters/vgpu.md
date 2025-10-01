---
title: "NVIDIA vGPU & MIG"
linkTitle: "NVIDIA vGPU"
date: "2025-02-17"
description:
categories:
pageintoc: "57"
tags:
weight: "6"
---

<a id="kvm-vgpu"></a>

<!--# NVIDIA vGPU & MIG support -->

This section describes how to configure the hypervisor in order to use NVIDIA vGPU & MIG features.

## BIOS

You need to check that the following settings are enabled in your BIOS configuration:

- Enable SR-IOV
- Enable IOMMU

Note that the specific menu options where you need to activate these features depend on the motherboard manufacturer.

## NVIDIA Drivers

The NVIDIA drivers are proprietary, so you will probably need to download them separately. Please check the documentation for your Linux distribution. Once you have installed and rebooted your server you should be able to access the GPU information as follows:

```default
$ lsmod | grep vfio
nvidia_vgpu_vfio       57344  0

$ nvidia-smi
Wed Feb  9 12:36:07 2022
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 510.47.03    Driver Version: 510.47.03    CUDA Version: N/A      |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  NVIDIA A10          On   | 00000000:41:00.0 Off |                    0 |
|  0%   52C    P8    26W / 150W |      0MiB / 23028MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+
```

## Enable the NVIDIA vGPU

{{< alert title="Warning" color="warning" >}}
The following steps assume that your graphic card supports SR-IOV. If not, please refer to official NVIDIA documentation in order to activate vGPU.{{< /alert >}}

### Finding the PCI

```default
$ lspci | grep NVIDIA
41:00.0 3D controller: NVIDIA Corporation Device 2236 (rev a1)
```

In this example the address is `41:00.0`. We now need to convert this to transformed-bdf format by replacing the colon and period with underscores, in our case: `41_00_0`. Now we can obtain the PCI name and the full information about the NVIDIA GPU (e.g., max number of virtual functions):

```default
$ virsh nodedev-list --cap pci | grep 41_00_0
pci_0000_41_00_0
```

```default
$ virsh nodedev-dumpxml pci_0000_41_00_0
<device>
    <name>pci_0000_41_00_0</name>
    <path>/sys/devices/pci0000:40/0000:40:03.1/0000:41:00.0</path>
    <parent>pci_0000_40_03_1</parent>
    <driver>
        <name>nvidia</name>
    </driver>
    <capability type='pci'>
        <class>0x030200</class>
        <domain>0</domain>
        <bus>65</bus>
        <slot>0</slot>
        <function>0</function>
        <product id='0x2236'/>
        <vendor id='0x10de'>NVIDIA Corporation</vendor>
        <capability type='virt_functions' maxCount='32'/>
        <iommuGroup number='44'>
        <address domain='0x0000' bus='0x40' slot='0x03' function='0x1'/>
        <address domain='0x0000' bus='0x41' slot='0x00' function='0x0'/>
        <address domain='0x0000' bus='0x40' slot='0x03' function='0x0'/>
        </iommuGroup>
        <pci-express>
        <link validity='cap' port='0' speed='16' width='16'/>
        <link validity='sta' speed='2.5' width='16'/>
        </pci-express>
    </capability>
</device>
```

### Enabling Virtual Functions

{{< alert title="Important" color="success" >}}
You need to perform this operation every time you reboot your server.{{< /alert >}}

```default
$ # /usr/lib/nvidia/sriov-manage -e slot:bus:domain.function
$ /usr/lib/nvidia/sriov-manage -e 00:41:0000.0
Enabling VFs on 00:41:0000.0
```

If you get an error while doing this operation, please double check that all the BIOS steps have been correctly performed. If everything goes well, you should get something similar to this:

```default
$ ls -l /sys/bus/pci/devices/0000:41:00.0/ | grep virtfn
lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn0 -> ../0000:41:00.4
lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn1 -> ../0000:41:00.5
lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn10 -> ../0000:41:01.6
...
lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn30 -> ../0000:41:04.2
lrwxrwxrwx 1 root root           0 Feb  9 10:37 virtfn31 -> ../0000:41:04.3
```

## Configuring QEMU

Finally, add the following udev rule:

```default
$ echo 'SUBSYSTEM=="vfio", GROUP="kvm", MODE="0666"' > /etc/udev/rules.d/opennebula-vfio.rules

# Reload udev rules:
$ udevadm control --reload-rules && udevadm trigger
```

{{< alert title="Note" color="success" >}}
Check full NVIDIA documentation [here](https://docs.nvidia.com/grid/latest/pdf/grid-vgpu-user-guide.pdf).{{< /alert >}}

## (Optional) Using MIG-backed vGPU for GPU partitioning

MIG (Multi-Instance GPU) allows partitioning a single GPU into multiple isolated GPU instances.
This is useful for running multiple workloads with guaranteed/isolated resources.

{{< alert title="Important" color="success" >}}
Note: Only certain NVIDIA GPUs support vGPU on MIG instances (e.g., H100). Other GPUs may not support MIG-backed vGPU. Always check your GPU model and driver version before attempting this setup.{{< /alert >}} 

1. Enable MIG Mode

Enable MIG on a specific GPU (example: index 0):

```default
$ nvidia-smi -i 0 -mig 1
$ nvidia-smi -i 0 -q | grep "MIG Mode" -A1  # Check MIG status
```

{{< alert title="Important" color="success" >}}
A GPU reset (or system reboot) may be required after enabling MIG mode.{{< /alert >}} 

2. List Available MIG Profiles

MIG profiles define how the GPU can be split into slices.
Each profile specifies the fraction of GPU compute and memory.

We can list aviable MIG Profiles with:

```default
$ nvidia-smi mig -lgip
```
Based on the output we can split the GPU on instances using profiles IDs.

3. Create MIG Instances

You can create GPU Instances (GI) and Compute Instances (CI).
The -cgi option creates both in a single command.

Examples (H100 94GB):

- Create 2 homogeneous instances:

```default
$ nvidia-smi mig -cgi 19,19 -C
```

- Create 3 heterogeneous instances:

```default
$ nvidia-smi mig -cgi 14,14,19 -C
```

You can add more instances later as long as GPU resources are available (check aviable profiles with nvidia-smi mig -lgip).
Similarly, you can remove specific instances (see step 5) to free resources and reconfigure the partitioning without resetting the whole GPU.

Each MIG instance you create will be represented as a vGPU profile by the NVIDIA driver.
When assigning vGPUs to VMs, these profiles appear as selectable devices corresponding to the MIG slices you configured.

{{< alert title="Important" color="success" >}}
Created MIG instances (GPU/Compute Instances) are not persistent across a GPU reset or reboot.{{< /alert >}} 

4. Inspect MIG Partitioning

We can use the following commands in order to show existing MIG partitioning:

```default
$ nvidia-smi mig -lgi   # list existing GPU instances
$ nvidia-smi mig -lci   # list existing compute instances
$ nvidia-smi mig -L     # list existing MIG devices
```

5. Destroy MIG Instances

To remove MIG partitions, destroy Compute Instances (CI) first, then GPU Instances (GI):

```default
$ nvidia-smi mig -dci -i <GPU_ID> -gi <GI_ID> -ci <Compute_ID>
$ nvidia-smi mig -dgi -i <GPU_ID> -gi <GI_ID>
```

## Using the vGPU

Once the setup is complete, you can follow the [general steps]({{% relref "pci_passthrough#pci-config" %}}) for adding PCI devices to a VM. For NVIDIA GPUs, please consider the following:

- OpenNebula supports both the legacy mediated device interface and the new vendor-specific interface introduced with Ubuntu 24.04. The vGPU device configuration is handled automatically by the virtualization and monitoring drivers. The monitoring process automatically sets the appropriate mode for each device using the `MDEV_MODE` attribute.
- NVIDIA vGPUs can be configured using different profiles, which define the vGPU’s characteristics and hardware capabilities. These profiles are retrieved from the drivers by the monitoring process, allowing you to easily select the one that best suits your application’s requirements. When using MIG, each MIG instance you created appears as a separate vGPU profile.

The following example shows the monitoring information for a NVIDIA vGPU device:

```default
$ onehost show -j 13
...
    "PCI_DEVICES": {
    "PCI": [
      {
        "ADDRESS": "0000:41:00:4",
        "BUS": "41",
        "CLASS": "0302",
        "CLASS_NAME": "3D controller",
        "DEVICE": "2236",
        "DEVICE_NAME": "NVIDIA Corporation GA102GL [A10]",
        "DOMAIN": "0000",
        "FUNCTION": "4",
        "MDEV_MODE": "nvidia",
        "NUMA_NODE": "-",
        "PROFILES": "588 (NVIDIA A10-1B),589 (NVIDIA A10-2B),590 (NVIDIA A10-1Q),591 (NVIDIA A10-2Q),592 (NVIDIA A10-3Q),593 (NVIDIA A10-4Q),594 (NVIDIA A10-6Q),595 (NVIDIA A10-8Q),596 (NVIDIA A10-12Q),597 (NVIDIA A10-24Q),598 (NVIDIA A10-1A),599 (NVIDIA A10-2A),600 (NVIDIA A10-3A),601 (NVIDIA A10-4A),602 (NVIDIA A10-6A),603 (NVIDIA A10-8A),604 (NVIDIA A10-12A),605 (NVIDIA A10-24A)",
        "SHORT_ADDRESS": "41:00.4",
        "SLOT": "00",
        "TYPE": "10de:2236:0302",
        "UUID": "e4042b96-e63d-56cf-bcc8-4e6eecccc12e",
        "VENDOR": "10de",
        "VENDOR_NAME": "NVIDIA Corporation",
        "VMID": "-1"
      }
```

This monitoring information is also available under the VMs PCI tab in the instances section.

![sunstone_gpu_graph](/images/sunstone_gpu_graph.png)

{{< alert title="Important" color="success" >}}
When using NVIDIA cards, ensure that only the GPU (for PCI passthrough) or vGPUs (for SR-IOV) are exposed through the PCI monitoring probe. Do not mix both types of devices in the same configuration.{{< /alert >}}
