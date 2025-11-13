---
title: "Configuration and Deployment"
date: "2025-10-21"
weight: 2
---

<a id="ai_config_deploy"></a>

Here you will find the details to deploy and configure an AI-ready OpenNebula cloud using the [OneDeploy](https://github.com/OpenNebula/one-deploy) tool. This guide focuses on a local environment, preparing it for demanding AI workloads by leveraging PCI passthrough for GPUs like the NVIDIA H100 and L40S.

Machine Learning (ML) training and inference are resource-intensive tasks that often require the full power of a dedicated GPU. PCI passthrough allows a Virtual Machine to have exclusive access to a physical GPU, delivering bare-metal performance for the most demanding AI workloads.

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

## Deployment with OneDeploy

Use OneDeploy to automate the deployment of our OpenNebula cloud with PCI passthrough configured for our GPUs.

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

### Step 1: Configure the Inventory for PCI Passthrough

For this configuration, use a dedicated inventory file to define the general cloud architecture, where you specify PCI devices for passthrough.

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

### Step 2: Run the Deployment

Once your inventory file is ready (e.g., saved as `inventory/ai_factory.yml`), run OneDeploy to provision your OpenNebula cloud.

```shell
make I=inventory/ai_factory.yml
```

When you enable the PCI passthrough feature in your inventory, OneDeploy handles all the necessary configuration steps. On each hypervisor node, OneDeploy prepares the specified GPUs for passthrough by binding them to the required `vfio-pci` driver. It also ensures the correct permissions are set so that OpenNebula manages the devices.

Simultaneously, on the OpenNebula front-end, OneDeploy configures the monitoring system to recognize these GPUs and intelligently updates each Host's template. This ensures that the GPUs are always correctly identified by OpenNebula, even if hardware addresses change, providing a stable and reliable passthrough setup.

## Post-Deployment Validation

After the deployment is complete, verify that the GPUs are correctly configured and available to OpenNebula by checking the Host information in Sunstone:

1. Log in to your OpenNebula Sunstone GUI
2. Navigate to **Infrastructure -> Hosts**
3. Select one of the hypervisors you configured for passthrough (e.g., `h100-node`).
4. Go to the **PCI** tab.
5. You will see your GPU listed as an available PCI device.

If the device is visible here, your AI-ready OpenNebula cloud is correctly configured. The H100 and L40S GPUs are now ready to be passed through to Virtual Machines for high-performance AI and ML tasks.

## Deployment on Scaleway

Here you have a practical guide to deploy an AI-ready OpenNebula cloud on a single [Scaleway Elastic Metal](https://www.scaleway.com/en/elastic-metal/) instance equipped with GPUs. This setup is ideal for demonstrations, proofs-of-concept (PoCs), or for quickly trying out the solution without the need for a complex physical infrastructure.

The outlined procedure is based on an instance with NVIDIA L40S GPUs as an example. A converged OpenNebula cloud, including frontend and KVM node, is deployed on the same bare metal server.

### Instance Launch and Initial Checks

1. Log in to your Scaleway console.
2. Navigate to **Bare Metal > Elastic Metal**
3. Click **"Create Elastic Metal Server"**.
4. Configure your server in the portal:

    *  **Availability Zone:** Choose your preferred zone, such as `PARIS 2`. Alternatively, select `Auto allocate.
    *  **Billing Method:** Select either hourly or monthly. Note that hourly billing is often more cost-effective for short-term projects or testing.
    *  **Server Type:** Select an instance. For GPU acceleration, you must choose an `Elastic Metal Titanium server.
    *  **Image:** Choose `Ubuntu 24.04 LTS` as the operating system.
    *  **Cloud-init:** You can skip this step, as it is not used in this setup.
    *  **Disk Partitions:** Configure the disk partition table so that the `/` path has the full disk space available.
    *  **Name and Tags:** Enter a name for your server and add any optional tags for organization.
    *  **SSH Keys:** add your public SSH key. This is essential for securely accessing your server.
    *  **Public Bandwidth:** the default bandwidth is usually sufficient. You can increase it here if your use case requires higher public throughput.
    * **Private Networks:** enabling 25Gbps Private Networks is not needed for a single-node setup.
    * **Environmental Summary:** review the Environmental Footprint Summary.
    * **Cost Summary:** review the *Estimated Cost Summary* to ensure it matches your expectations.
    * **Create Server:** once you have verified all settings, click **"Create Elastic Metal Server"** to provision and launch your instance.

5. After some minutes and once the instance is running, connect to it via SSH using its public IP address:
```default
$ ssh ubuntu@<your_instance_public_ip>
```

6. Verify that the GPUs are detected as PCI devices:
```default
$ lspci -Dnnk | grep NVIDIA
```
You should see an output similar to this, listing your NVIDIA GPUs:
```
0000:01:00.0 3D controller [0302]: NVIDIA Corporation AD102GL [L40S] [10de:26b9] (rev a1)
    Subsystem: NVIDIA Corporation AD102GL [L40S] [10de:1851]
0000:82:00.0 3D controller [0302]: NVIDIA Corporation AD102GL [L40S] [10de:26b9] (rev a1)
    Subsystem: NVIDIA Corporation AD102GL [L40S] [10de:1851]
```

Make sure you note down the full PCI addresses for both GPUs.

7. Confirm that IOMMU is enabled on the server. The `ls` command below should list several numbered subdirectories:
```default
$ ls -la /sys/kernel/iommu_groups/
```
If the directory is not empty, IOMMU is active, which is a prerequisite for PCI passthrough.

### Server Pre-configuration

These steps prepare the server for the OneDeploy tool, which runs as the `root` user.

1.  Enable Local Root SSH Access:
    Generate an SSH key pair for the `root` user and authorize it for local connections. This allows Ansible to connect to `127.0.0.1` as `root`.
    ```default
    $ sudo su
    # ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N "" -q
    # cat /root/.ssh/id_ed25519.pub >> /root/.ssh/authorized_keys
    ```

2.  Create a Virtual Network Bridge:
    To provide network connectivity to the VMs, create a virtual bridge with NAT. This allows VMs to access the internet through the server's public network interface.

    2.1 Create the Netplan configuration file for the bridge:
    ```default
    # tee /etc/netplan/60-bridge.yaml > /dev/null << 'EOF'
    network:
      version: 2
      bridges:
        br0:
          dhcp4: no
          addresses: [192.168.100.1/24]
          interfaces: []
          parameters:
            stp: false
            forward-delay: 0
          nameservers:
            addresses: [1.1.1.1,8.8.8.8]
    EOF
    ```

    2.2  Apply the network configuration and enable IP forwarding. Replace `enp129s0f0np0` with your server's main network interface if it is different.
    ```default
    # netplan apply
    # sysctl -w net.ipv4.ip_forward=1
    # iptables -t nat -A POSTROUTING -s 192.168.100.0/24 -o enp129s0f0np0 -j MASQUERADE
    # iptables-save | uniq | iptables-restore
    ```

### OneDeploy Dependencies

As a `root` user, clone the `one-deploy` repository and install its dependencies.

```default
# cd /root
# git clone https://github.com/OpenNebula/one-deploy.git
# cd one-deploy/
# apt update && apt install -y pipx make
# pipx install hatch
# pipx ensurepath
# source ~/.bashrc
# make requirements
# hatch shell
(one-deploy) #
```
For more details, refer to the [OneDeploy System Requirements](https://github.com/OpenNebula/one-deploy/wiki/sys_reqs).

### Configure and Run OneDeploy

Create an inventory file named `inventory/scaleway.yml` with the following content. This file defines a complete OpenNebula deployment on the local machine (`127.0.0.1`).

```yaml
---
all:
  vars:
    ansible_user: root
    one_version: '7.0'
    one_pass: YOUR_SECURE_PASSWORD # Replace with a strong password
    gate_endpoint: "http://192.168.100.1:5030"
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
            IP: 192.168.100.50
            SIZE: 200
          NETWORK_ADDRESS: 192.168.100.0
          NETWORK_MASK: 255.255.255.0
          GATEWAY: 192.168.100.1
          DNS: 1.1.1.1

frontend:
  hosts:
    f1: { ansible_host: 127.0.0.1 }

node:
  hosts:
    h1:
      ansible_host: 127.0.0.1
      pci_passthrough_enabled: true
      pci_devices:
        - address: "0000:01:00.0" # First L40S GPU
        - address: "0000:82:00.0" # Second L40S GPU
```

{{< alert title="Important" color="success" >}}
*   Replace `YOUR_SECURE_PASSWORD` with a strong and unique password for the `oneadmin` user.
*   The PCI device addresses (`0000:01:00.0`, `0000:82:00.0`) must match the ones you found earlier with `lspci`.
{{< /alert >}}

Now, run the deployment:
```default
(one-deploy) # make I=inventory/scaleway.yml
```

### Post-Deployment Validation

Once the deployment is complete:
1. Access the OpenNebula Sunstone web interface at `http://<your_instance_public_ip>:2616`.
2. Log in with the username `oneadmin` and the password you set in the inventory file.

{{< alert title="Note" color="info" >}}
To improve the security of your deployment in public-facing OpenNebula instances, configure a reverse proxy such as Nginx or Apache to handle SSL termination and rate limiting, forwarding requests to localhost:2616. Then, set the host variable in /etc/one/fireedge-server.conf so that it listens only on localhost.
{{< /alert >}}

Verify the GPU passthrough configuration:
1.  In Sunstone, navigate to **Infrastructure -> Hosts**.
2.  Select the `127.0.0.1` host.
3.  Go to the **PCI** tab. You should see both L40S GPUs listed and ready for passthrough.

{{< alert title="Tip" color="success" >}}
After completing the steps to have your AI-ready OpenNebula cloud using the OneDeploy tool, validate your deployment following one of the alternative options:
* [Validation with LLM Inferencing]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/llm_inference_certification" %}})
* [Validation with AI-Ready Kubernetes]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/ai_ready_k8s" %}})
{{< /alert >}}
