---
title: "NVIDIA GPU Passthrough"
date: "2025-10-16"
description:
categories:
pageintoc: "58"
tags:
weight: "7"
---

<a id="nvidia-gpu-passthrough"></a>

<!--# NVIDIA GPU Passthrough -->

This guide provides detailed instructions for configuring PCI passthrough for high-performance NVIDIA&reg; GPUs on x86_64 hypervisors (this guide is not applicable to ARM-based systems). The procedures described here have been validated with NVIDIA H100 GPUs but can be adapted for other similar high-performance NVIDIA GPUs. This allows Virtual Machines to get exclusive access to the GPU, which is recommended for AI/ML workloads. It builds upon the concepts explained in the general [PCI Passthrough]({{% relref "pci_passthrough.md" %}}) guide.

{{< alert title="Note" color="success" >}}
As an alternative to PCI passthrough, OpenNebula also supports NVIDIA vGPU, which allows a single physical GPU to be partitioned and shared among multiple VMs. While PCI passthrough is the recommended approach for demanding AI/ML workloads, especially model training, vGPU can be a suitable option for less intensive tasks like model inference or development environments. For more information, see the [NVIDIA vGPU guide]({{% relref "vgpu.md" %}}).
{{< /alert >}}

## Hypervisor Configuration

The following configurations must be performed on the KVM hypervisors that will host the GPUs.

### Enabling IOMMU

The IOMMU (Input-Output Memory Management Unit) is a hardware feature that allows the hypervisor to isolate I/O devices and is a prerequisite for PCI passthrough. To enable it, you need to add kernel parameters to the hypervisor's boot configuration.

1. Edit the GRUB configuration file at `/etc/default/grub` and add the appropriate parameter to the `GRUB_CMDLINE_LINUX_DEFAULT` line:

*   **For Intel CPUs**: `intel_iommu=on iommu=pt`
*   **For AMD CPUs**: `amd_iommu=on iommu=pt`

Example for an Intel-based hypervisor:

```default
GRUB_CMDLINE_LINUX_DEFAULT="intel_iommu=on iommu=pt"
```

2. After saving the file, update the GRUB configuration and reboot the hypervisor:

```default
# update-grub
# reboot
```

After rebooting, verify that IOMMU is enabled by checking the kernel messages:

```default
# dmesg | grep -i iommu
```

Alternatively, to confirm that IOMMU is active proceed to check that the `/sys/kernel/iommu_groups/` directory exists and is populated with subdirectories. An empty directory might indicate that IOMMU is not correctly enabled in the kernel or BIOS.

### VFIO Driver Binding

Once IOMMU is enabled, the GPU must be unbound from the default host driver (e.g., `nouveau`) and bound to the `vfio-pci` driver, which is designed for PCI passthrough.

1.  Install `driverctl` utility:

    ```default
    # apt install driverctl
    ```

2.  Ensure `vfio-pci` module is loaded on boot:

    ```default
    # echo "vfio-pci" | sudo tee /etc/modules-load.d/vfio-pci.conf
    # modprobe vfio-pci
    ```

3.  Identify the GPU's PCI address:

    ```default
    # lspci -D | grep -i nvidia
    0000:e1:00.0 3D controller: NVIDIA Corporation GH100 [H100 PCIe] (rev a1)
    ```

4.  Set the driver override:
    Use the PCI address from the previous step to set an override for the device to use the `vfio-pci` driver.

    ```default
    # driverctl set-override 0000:e1:00.0 vfio-pci
    ```

5.  Verify the driver binding:
    Check that the GPU is now using the `vfio-pci` driver.

    ```default
    # lspci -Dnns e1:00.0 -k
    Kernel driver in use: vfio-pci
    ```

### VFIO Device Ownership

For OpenNebula to manage the GPU, the VFIO device files in `/dev/vfio/` must be owned by the `root:kvm` user and group. This is achieved by creating a `udev` rule.

1.  Identify the IOMMU group for your GPU using its PCI address:

    ```default
    # find /sys/kernel/iommu_groups/ -type l | grep e1:00.0
    /sys/kernel/iommu_groups/85/devices/0000:e1:00.0
    ```
    In this example, the IOMMU group is `85`.

2.  Create a `udev` rule:
    Create the file `/etc/udev/rules.d/99-vfio.rules` with the following content:

    ```default
    SUBSYSTEM=="vfio", GROUP="kvm", MODE="0666"
    ```

3.  Reload `udev` rules:

    ```default
    # udevadm control --reload
    # udevadm trigger
    ```

4.  Verify ownership:
    Check the ownership of the device file corresponding to your GPU's IOMMU group.

    ```default
    # ls -la /dev/vfio/
    crw-rw-rw- 1 root kvm 509, 0 Oct 16 10:00 85
    ```

## OpenNebula Configuration

### Monitoring PCI Devices

To make the GPUs available in OpenNebula, configure the PCI probe on the front-end node to monitor NVIDIA devices.

1.  Edit the PCI probe configuration file at `/var/lib/one/remotes/etc/im/kvm-probes.d/pci.conf`.
2.  Add a filter for NVIDIA devices:

    ```default
    :filter: '10de:*'
    ```

3.  Synchronize the hosts from the Front-end to apply the new configuration:

    ```default
    # su - oneadmin
    $ onehost sync -f
    ```

After a few moments, you can check if the GPU is being monitored correctly by showing the host information (`onehost show <HOST_ID>`). The GPU should appear in the `PCI DEVICES` section.

By default, the host system monitoring probe may take up to **10 minutes** to detect new PCI devices. To run the host monitoring probe immediately, you can force it with:
```default
$ onehost forceupdate <HOST_ID>
```

## VM Template Best Practices for AI Workloads

To achieve proper GPU operation inside the VM, including optimal performance for AI/ML workloads, configure the VM Template with the following settings:

### Firmware (UEFI)

Modern high-performance GPUs like the H100 benefit from Resizable BAR, which requires UEFI booting. OpenNebula will automatically select the appropriate UEFI firmware file. If you need to use a specific OVMF file, you can provide its full path in the `FIRMWARE` attribute instead of `\"UEFI\"`.

*   **Attribute**: `FIRMWARE`
*   **Section**: `OS`
*   **Value**: `"UEFI"`

```default
OS = [
  ARCH = "x86_64",
  FIRMWARE = "UEFI"
]
```

### Machine Type (q35)

The `q35` machine type provides a modern PCIe-based chipset, improving compatibility and performance for PCIe devices like GPUs. Additionally, if the q35 machine type is used, OpenNebula replicates the hypervisor PCI topology into the guest VM. This gives AI frameworks visibility into the PCI layout, allowing them to optimize data transfers and reduce latency.

*   **Attribute**: `MACHINE`
*   **Section**: `OS`
*   **Value**: `"q35"`

```default
OS = [
  ...,
  MACHINE = "q35"
]
```

### CPU Model (Host Passthrough)

Exposing the host CPU exact model and feature set to the VM results in better hardware support and performance. Having the full list of CPU features is a hard requirement for modern high-performance GPUs like the NVIDIA H100, because its drivers require access to advanced CPU instruction sets to initialize and function correctly.

*   **Attribute**: `CPU_MODEL`
*   **Value**: `MODEL="host-passthrough"`

```default
CPU_MODEL = [
  MODEL = "host-passthrough"
]
```

### NUMA and CPU Pinning

CPU pinning is crucial for performance as it dedicates physical CPU cores to the VM, preventing them from being shared with other VMs. When a `PIN_POLICY` is defined, the OpenNebula scheduler automatically places the VM on a NUMA node that is physically close to the requested GPU and pins the vCPUs to the cores of that node, minimizing latency. For a more in-depth explanation of this topic, refer to the [Virtual Topology and CPU Pinning]({{% relref "numa.md" %}}) guide.

For VM pinning to work, you must also enable the pinning policy on the Host. You can do this by editing the Host's template and setting `PIN_POLICY="PINNED"`, or by selecting the `PINNED` policy in the Host's `NUMA` tab in Sunstone.

*   **Attribute**: `TOPOLOGY`
*   **Values**: `PIN_POLICY`, `CORES`, `SOCKETS`

```default
TOPOLOGY = [
  PIN_POLICY = "CORE",
  CORES = "16",
  SOCKETS = "1"
]
```

### PCI Device Passthrough

Finally, assign the GPU to the VM using the `PCI` attribute. You can select a specific GPU by its address. Once the VM is running, verify that the guest OS recognizes the device by executing the `lspci` command inside the VM.

*   **Attribute**: `PCI`
*   **Value**: `SHORT_ADDRESS="<pci_address>"`

```default
PCI = [
  SHORT_ADDRESS = "e1:00.0"
]
```

## Sample VM Template

Here is a sample VM Template that incorporates all the recommended attributes for an AI workload VM with an NVIDIA H100 GPU. This template is a reference. To meet your specific requirements, specify `MEMORY`, `VCPU`, `IMAGE_ID`, and other parameters.

```default
CONTEXT=[
  NETWORK="YES",
  SSH_PUBLIC_KEY="$USER[SSH_PUBLIC_KEY]" ]

CPU="1"

CPU_MODEL=[
  MODEL="host-passthrough" ]

DISK=[
  IMAGE_ID="163" ]

GRAPHICS=[
  LISTEN="0.0.0.0",
  TYPE="vnc" ]

HYPERVISOR="kvm"

LOGO="images/logos/ubuntu.png"

LXD_SECURITY_PRIVILEGED="true"

MEMORY="768"

OS=[
  ARCH="x86_64",
  FIRMWARE="UEFI",
  MACHINE="q35" ]

PCI=[
  SHORT_ADDRESS="e1:00.0" ]

SCHED_REQUIREMENTS="HYPERVISOR=kvm"

TOPOLOGY=[
  CORES="4",
  PIN_POLICY="CORE",
  SOCKETS="1",
  THREADS="1" ]

VCPU="4"
```