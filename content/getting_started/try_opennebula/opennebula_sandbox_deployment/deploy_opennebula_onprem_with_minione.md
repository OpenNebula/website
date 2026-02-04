---
title: "Deploy OpenNebula on-prem with miniONE"
linkTitle: "miniONE deployment"
date: "2025-02-17"
#description: "Install an OpenNebula Front-end and a KVM hypervisor on a single server in a few minutes, using **miniONE**, the installation script provided by OpenNebula."
categories: [Introduction, Evaluation, Learning]
pageintoc: "15"
tags: [miniONE]
type: docs
weight: "1"
---

<a id="create-an-emulated-environment-with-minione"></a>

<!--# Create an Emulated Environment with miniONE -->

In this tutorial, we'll install an OpenNebula Front-end in under ten minutes, using **miniONE**, the installation tool provided by OpenNebula.

The miniONE tool is a simple script that allows you to install an OpenNebula Front-end with a single command. It installs quickly and easily and is a great tool for learning and evaluation. After running **miniONE**, all the OpenNebula services needed to use, manage and run the cloud will be installed on a single Front-end.

This tutorial covers installation of a Front-end and KVM hypervisor node on the local machine. The resulting installation uses a private IP for communication between the Front-end and Virtual Machines, so it is not suitable for deploying resources to remote infrastructure.

With this setup, during installation miniONE will:

- Install OpenNebula from the software packages
- Install a KVM hypervisor on the local machine
- Automatically download a Virtual Machine template for the Alpine Linux 3.20 OS from the [OpenNebula Marketplace](https://marketplace.opennebula.io/))

After installation, we will use the [Sunstone UI]({{% relref fireedge_sunstone %}}) to try out and manage these components.

To install an OpenNebula Front-end using miniONE, we’ll need to complete the following high-level steps:

> 1. Ensure that the host server meets the installation requirements.
> 2. Download and run the miniONE script.
> 3. Verify the installation.


{{< alert title="Emulation" color="success" >}}
It is recommended to perform the installation on a machine capable of running KVM virtualization. If KVM virtualization is not available, miniONE will automatically fall back on QEMU emulation; however, running in full emulation mode will decrease performance.
{{< /alert >}}

{{< alert title="Tip" color="primary" >}}
To quickly check that your machine is capable of KVM emulation, you can run the `kvm-ok` command:
```
kvm-ok
INFO: /dev/kvm exists
KVM acceleration can be used
```
On Debian-based Linux, you can install `kvm-ok` by installing the `cpu-checker` package.
{{< /alert >}}

## Step 1: Verify Installation Requirements

To run the miniONE script, you will need a physical or virtual server with a fresh installation of a supported operating system, with the latest software updates and without any customizations. The server will need an internet connection to download software packages during installation.

**Supported operating systems:**
: - RHEL/AlmaLinux 8 or 9
  - Debian 11 or 12
  - Ubuntu 22.04 or 24.04

**Minimum hardware:**
: - 4 GiB RAM (16 GiB recommended for [deploying a Kubernetes cluster]({{% relref "running_kubernetes_clusters" %}}))
  - 80 GiB free disk space

**Configuration:**
: - Access to the privileged user (root) account
  - An SSH server running on port 22
  - Open ports:
    : - 22 (SSH)
      - 80 (for the web UI)

This tutorial was tested on on Ubuntu 22.04 and 24.04.

## Step 2: Download and Install miniONE

You can download miniONE from the [GitHub repository](https://github.com/OpenNebula/minione).

To quickly download miniONE, run:

```bash
wget 'https://github.com/OpenNebula/minione/releases/download/v7.0.1/minione'
```

After downloading, open a terminal and use the `sudo` to become the `root` user. For example, run:

```bash
sudo -i
```

Go to the folder where you downloaded the miniONE script, by using the `cd` command:

```bash
cd <path/to/folder>
```

Next, ensure that the `minione` file has execute permissions:

```bash
chmod +x minione
```

To install miniONE, run as root:

```bash
./minione
```

The miniONE script will begin the installation, logging output to the terminal. Installation usually takes between one and three minutes on most machines. When it's finished, miniONE shows a report with connection parameters and login credentials:

```default
### Report
OpenNebula 7.0 was installed
Sunstone is running on:
  http://192.168.1.130/
Use following to login:
  user: oneadmin
  password: ZMCoOWUsBg
```

Finally we will force a refresh of the ``localhost`` status:

```bash
sudo -u oneadmin onehost sync --force
```

At this point, you have successfully installed miniONE. OpenNebula services should be running, and the system should be ready for your first login.

## Step 3: Verify the Installation

We will verify the installation by logging in to OpenNebula's Edge Sunstone GUI.

Point your browser to the Edge IP and port provided by the miniONE report, in this case `192.168.1.130:80`, or simply to `http://localhost`. You should be greeted with the Sunstone login screen:

![image](/images/sunstone-login.png)
<br/>

In the **Username** input field, type `oneadmin`. For **Password**, enter the password provided by miniONE at the end of the report (in this example, `ZMCoOWUsBg`) then press `Enter` or click **SIGN IN**.

The screen should display the Sunstone Dashboard:

![image](/images/sunstone-dashboard.png)
<br/>

As you can see, the Dashboard indicates the following installed components:

- 1 VM template
- 1 image
- 1 virtual network

The installed virtual network is a bridged network attached to a local interface. To see this network, in Sunstone open the left-hand menu (by hovering the mouse over the left-hand pane), then click **Networks** --> **Virtual Networks**:

![image](/images/sunstone-select_vnetwork.png)

Sunstone should display the **Virtual networks** screen. Clicking the network name displays info tabs for the network:

![image](/images/sunstone-network_details.png)

During installation, a KVM virtualization host was automatically configured on the local server. To see the KVM host, in Sunstone open the left-hand menu, then click **Infrastructure** -> **Hosts**.

## Deploying a Virtual Machine Locally

During installation, miniONE automatically downloaded the template for a Virtual Machine with Alpine Linux 3.20 preinstalled. Using the Sunstone UI, we can now instantiate this Virtual Machine on the local KVM host with a few clicks.

To deploy the Alpine Linux VM, go to **Templates** -> **VM Templates**. This screen displays a list of all VM templates installed on the system. In this case, only the **Alpine Linux 3.20** template is installed:

![image](/images/sunstone-vm_templates-alpine.png)

To instantiate the VM template, click the template name, then click the **Instantiate** icon ![image](/images/icons/sunstone/instantiate.png) at the top.

Sunstone will display the first screen of the **Instantiate VM Template** wizard:

![image](/images/sunstone-instantiate_vm-1.png)

Feel free to modify the **Capacity** parameters if desired, or leave at their default values.

Click **Next**.

The next screen allows you to see and modify further parameters for the VM, including selecting the virtual network or scheduling actions.

![image](/images/sunstone-instantiate_vm-2.png)

Click **Finish**.

OpenNebula will instantiate the VM template. For the Alpine Linux VM, this should take just a few seconds. Once instantiation is complete, Sunstone should display the **Instances** -> **VMs** screen, with the Alpine Linux VM as the sole instance:

![image](/images/sunstone-vm_instances.png)

The green dot to the left of the VM name indicates that the VM is running. Note that you may need to click the **Refresh** icon ![image](images/icons/sunstone/refresh.png) at top left for the VM to display the running state.

### Logging into the Virtual Machine

The quickest way to log into the VM is by VNC, available directly in Sunstone. Just click the VNC icon ![image](/images/icons/sunstone/VNC.png) and Sunstone should display the VM boot messages screen directly in your browser.

![image](/images/sunstone-VNC-alpine.png)

Log in as root with password `opennebula`.

Congratulations! You've installed an OpenNebula Front-end with a KVM hypervisor and virtual network, then deployed a Virtual Machine.

To explore the resources in the environment you've just created, see [Validate the miniONE Environment]({{% relref "validate_the_environment" %}}) --- where additionally you can learn how to quickly download virtual appliances from the [OpenNebula Marketplace](https://marketplace.opennebula.io/) and deploy them to your new cloud.

### Troubleshooting

Cannot dispatch VM: No hosts enabled to launch the machine:

```bash
sudo -u oneadmin onehost sync --force
```


### Expected output

```bash
### Checks & detection
Checking augeas is installed  SKIP will try to install
Checking apt-transport-https is installed  SKIP will try to install
Checking AppArmor  SKIP will try to modify
Checking for present ssh key  SKIP
Checking iptables-persistent is installed  SKIP will try to install
Checking netfilter-persistent is installed  SKIP will try to install
Checking terraform  SKIP will try to install

### Main deployment steps:
Install OpenNebula frontend version 7.0
Install Terraform
Configure bridge minionebr with IP 172.16.100.1/24
Enable NAT over eth0
Modify AppArmor
Install OpenNebula KVM node
Export appliance and update VM template
Install  augeas-tools apt-transport-https iptables-persistent netfilter-persistent

Do you agree? [yes/no]:
yes

### Installation
Updating APT cache  OK
Install  augeas-tools apt-transport-https iptables-persistent netfilter-persistent  OK
Creating bridge interface minionebr  OK
Bring bridge interfaces up  OK
Enabling IPv4 forward  OK
Persisting IPv4 forward  OK
Configuring NAT  OK
Saving iptables changes  OK
Installing DNSMasq  OK
Starting DNSMasq  OK
Configuring repositories  OK
Updating APT cache  OK
Installing OpenNebula packages  OK
Installing TerraForm  OK
Installing OpenNebula kvm node packages  OK
Updating AppArmor  OK
Disable default libvirtd networking  OK
Restart libvirtd  OK

### Configuration
Switching OneGate endpoint in oned.conf  OK
Switching OneGate endpoint in onegate-server.conf  OK
Switching keep_empty_bridge on in OpenNebulaNetwork.conf  OK
Switching scheduler interval in oned.conf  OK
Setting initial password for current user and oneadmin  OK
Switching DEFAULT_CDROM_DEVICE_PREFIX in oned.conf  OK
Switching FireEdge port  OK
Starting OpenNebula services  OK
Enabling OpenNebula services  OK
Add ssh key to oneadmin user  OK
Update ssh configs to allow VM addresses reusing  OK
Ensure own hostname is resolvable  OK
Checking OpenNebula is working  OK
Disabling ssh from virtual network  OK
Adding localhost ssh key to known_hosts  OK
Testing ssh connection to localhost  OK
Updating datastores template  OK
Creating kvm host  OK
Restarting OpenNebula  OK
Ensure host is synced  OK
Creating virtual network  OK
Exporting [Alpine Linux 3.20] from Marketplace to local datastore  OK
Waiting until the image is ready  OK
Updating VM template  OK

### Report
OpenNebula 7.0 was installed
Sunstone is running on:
  http://172.20.0.4/
Use following to login:
  user: oneadmin
  password: fZAObvvbXv
```
