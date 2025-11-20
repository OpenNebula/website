---
title: "On-premises AI Factory Deployment"
linkTitle: "On-premises Deployment"
date: "2025-10-21"
weight: 2
---

<a id="cd_on-premises"></a>

Machine Learning (ML) training and inference are resource-intensive tasks that often require the full power of a dedicated GPU. PCI passthrough allows a Virtual Machine (VM) to have exclusive access to a physical GPU, delivering bare-metal performance for the most demanding AI workloads.

In this guide you will find the details to deploy and configure an AI-ready OpenNebula cloud using the [OneDeploy](https://github.com/OpenNebula/one-deploy) tool. It covers the general process for preparing an environment for demanding AI workloads by leveraging PCI passthrough for GPUs like the NVIDIA H100 and L40S. 

## Prerequisites

Before you begin, ensure your environment meets the following prerequisites.

### Hardware Requirements

The virtualization hosts (hypervisors) must support I/O MMU virtualization:
*   **Intel CPUs**: Must support **VT-d**.
*   **AMD CPUs**: Must support **AMD-Vi**.

You must enable this feature in your server's BIOS/UEFI. Refer to your hardware vendor's documentation for instructions.

### Kernel Configuration (Manual Step)

The OneDeploy tool automates many aspects of the configuration, but you must manually enable IOMMU support in the kernel on each hypervisor node. This is a critical step that OneDeploy does not perform automatically.

Before modifying the kernel parameters, check if IOMMU is already active by inspecting the `/sys/kernel/iommu_groups/` directory on the hypervisor.

```shell
ls /sys/kernel/iommu_groups/
```

If this directory exists and contains subdirectories (e.g., `0/`, `1/`, etc.), IOMMU is likely active. An empty directory or a non-existent directory indicates that IOMMU is not correctly enabled in your kernel or BIOS/UEFI.

If IOMMU is not active, add the appropriate parameter to the kernel's boot command line:

*   For Intel CPUs: `intel_iommu=on`
*   For AMD CPUs: `amd_iommu=on`

For a detailed guide on how to perform this kernel configuration, refer to the [NVIDIA GPU Passthrough documentation]({{% relref "product/cluster_configuration/hosts_and_clusters/nvidia_gpu_passthrough.md" %}}).

### Hypervisor Preparation

For a correct performance of the PCI passthrough with NVIDIA GPUs, start with a clean state on the hypervisor nodes regarding NVIDIA drivers.

Avoid pre-installing NVIDIA drivers on the hypervisor nodes before running the OneDeploy playbook. An active proprietary NVIDIA driver will claim the GPU and prevent other drivers, like `vfio-pci`, from binding to the device. This will block the PCI passthrough configuration from succeeding.

### Setting Up OneDeploy

The OneDeploy tool is a collection of Ansible playbooks that streamline the installation of OpenNebula. Before running this collection, prepare your control node which is the machine where you will execute the Ansible commands.

1.  **Clone the repository**:
    ```shell
    git clone https://github.com/OpenNebula/one-deploy.git
    cd one-deploy
    ```
2.  **Install dependencies**:
    OneDeploy requires Ansible and a few other Python libraries. For detailed system requirements and setup instructions, follow the [Platform Notes](https://github.com/OpenNebula/one-deploy/wiki/sys_reqs) in the official wiki.

For guidance on how to execute the playbooks in different cloud architectures, see the [Playbook Usage Guide](https://github.com/OpenNebula/one-deploy/wiki/sys_use).

## AI Factory Deployment

Once the prerequisites including configurations and dependencies are met, proceed to deploy your AI Factory with OneDeploy.

### Configure the Inventory for PCI Passthrough

Use a dedicated inventory file to define the general cloud architecture, where you specify PCI devices for passthrough.

Here is an example inventory file, which you can adapt for your environment. This example is based on the `inventory/pci_passthrough.yml` file found in the `one-deploy` repository. For more details on the `pci_passthrough` roles, refer to the [PCI Passthrough wiki page](https://github.com/OpenNebula/one-deploy/wiki/pci_passthrough). The inventory file shown below is a basic example, and you should adjust it to match your specific cloud architecture, including your frontend and node IP addresses, network configuration (`vn`), and datastore setup (`ds`). For more detailed information on configuring OneDeploy for different architectures like shared or Ceph-based storage, refer to the official [OneDeploy wiki](https://github.com/OpenNebula/one-deploy/wiki).


```yaml
---
all:
  vars:
    ansible_user: root
    one_version: '7.0'
    one_pass: opennebulapass
    ds:
      mode: ssh
    vn:
      admin_net:
        managed: true
        template:
          VN_MAD: bridge
          BRIDGE: br0
          AR:
            TYPE: IP4
            IP: 192.168.122.100
            SIZE: 48
          NETWORK_ADDRESS: 192.168.122.0
          NETWORK_MASK: 255.255.255.0
          GATEWAY: 192.168.122.1
          DNS: 1.1.1.1

frontend:
  hosts:
    f1: { ansible_host: 192.168.122.2 }

node:
  hosts:
    h100-node:
      ansible_host: 192.168.122.3
      pci_passthrough_enabled: true
      pci_devices:
        - address: "0000:09:00.0" # NVIDIA H100 GPU
    l40s-node:
      ansible_host: 192.168.122.4
      pci_passthrough_enabled: true
      pci_devices:
        - address: "0000:0a:00.0" # NVIDIA L40S GPU
    standard-node:
      ansible_host: 192.168.122.5
      pci_passthrough_enabled: false
```

Key configuration parameters to setup:

*   `pci_passthrough_enabled: true`: this boolean flag enables the PCI passthrough configuration for a specific node.
*   `pci_devices`: this is a list of PCI devices to be configured for passthrough on that node.
    *   `address`: the full PCI address of the device (e.g., `"0000:09:00.0"`). List this address by running the `lspci -D` command on the hypervisor. Note that you must provide the full address, as short addresses are not supported by this OneDeploy feature.

### Run the Deployment

Once your inventory file is ready (e.g., saved as `inventory/ai_factory.yml`), run OneDeploy to provision your OpenNebula cloud.

```shell
make I=inventory/ai_factory.yml
```

When you enable the PCI passthrough feature in your inventory, OneDeploy handles all the necessary configuration steps. On each hypervisor node, OneDeploy prepares the specified GPUs for passthrough by binding them to the required `vfio-pci` driver. It also ensures the correct permissions are set so that OpenNebula manages the devices.

Simultaneously, on the OpenNebula front-end, OneDeploy configures the monitoring system to recognize these GPUs and intelligently updates each Host's template. This ensures that the GPUs are always correctly identified by OpenNebula, even if hardware addresses change, providing a stable and reliable passthrough setup.

## Post-Deployment Verification

After the deployment is complete, verify that the GPUs are correctly configured and available to OpenNebula by checking the Host information in Sunstone:

1. Log in to your OpenNebula Sunstone GUI
2. Navigate to **Infrastructure -> Hosts**
3. Select one of the hypervisors you configured for passthrough (e.g., `h100-node`).
4. Go to the **PCI** tab.
5. You will see your GPU listed as an available PCI device.

If the device is visible here, your AI-ready OpenNebula cloud is correctly configured. The H100 and L40S GPUs are now ready to be passed through to Virtual Machines for high-performance AI and ML tasks.


{{< alert title="Tip" color="success" >}}
After completing the steps to have your AI-ready OpenNebula cloud with OneDeploy, validate your deployment following one of the alternative options:
* [Validation with LLM Inferencing]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/llm_inference_certification" %}})
* [Validation with AI-Ready Kubernetes]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/ai_ready_k8s" %}})
{{< /alert >}}
