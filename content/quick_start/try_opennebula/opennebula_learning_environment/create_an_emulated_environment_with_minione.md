---
title: "Create an Emulated Environment with miniONE"
date: "2025-02-17"
description:
categories: [Introduction, Evaluation, Learning]
pageintoc: "15"
tags: [miniONE]
weight: "2"
---

<a id="create-an-emulated-environment-with-minione"></a>

<!--# Create an Emulated Environment with miniONE -->

++++ + = check out later

In this tutorial, we'll install an OpenNebula Front-end and a KVM hypervisor on a single server in under ten minutes, using **miniONE**, the installation script provided by OpenNebula.

The miniONE tool is a simple Bash script that allows you to install an OpenNebula Front-end with a single command. All the OpenNebula services needed to use, manage and run the cloud will be installed on this single server.

The miniONE tool offers two installation options:

1. Install minione with no options, by running the command:

>```
>bash minione
>```

> In this case miniONE installs the Front-end and a KVM hypervisor node on the local machine. With this configuration you will be able to deploy VMs to the local machine, but you will _not_ be able to provision remote resources, since this type of installation uses a private IP address for communicating with VMs.

2. Install minione with the Front-end option, by running the command:

>```
>bash minione --frontend
>```

>With this option, miniONE installs _only_ the OpenNebula Front-end -- it does not install the KVM hypervisor. The installed Front-end uses a public IP address for communication, so you can use this Front-end to provision resources in remote infrastructure.

In this tutorial, we will install miniONE with no options. With this setup, during installation miniONE will:

- Install a KVM hypervisor on the local machine
- Automatically download a Virtual Machine template for the Alpine Linux 3.20 OS from the [OpenNebula Marketplace]+++put link

After installation, we will use the [Sunstone UI]+insert link to try out and manage these components.

{{< alert title="Tip" color="success" >}}
This is not the only thing you can do with miniONE: Installing with the `--frontend` flag allows you to deploy cloud clusters on remote infrastructure. This is covered in [Quick Start: OpenNebula Evaluation Environment]({{% relref "opennebula_evaluation_environment/" %}}).
{{< /alert >}}

But in this particular tutorial, we'll do the single Front-end install + KVM host.

To install an OpenNebula Front-end using miniONE, we’ll need to complete the following high-level steps:

> 1. Ensure that the host server meets the installation requirements.
> 2. Download and run the miniONE script.
> 3. Verify the installation.

To run the miniONE script, you will need a physical or virtual server with a fresh installation of a supported operating system, with the latest software updates and without any customizations. The server will need an internet connection to download software packages during installation.

**Supported operating systems:**
: - RHEL/AlmaLinux 8 or 9
  - Debian 11 or 12
  - Ubuntu 22.04 or 24.04

**Minimum hardware:**
: - 4 GiB RAM
  - 80 GiB free disk space

**Configuration:**
: - Access to the privileged user (root) account
  - A public IP address
  - An SSH server running on port 22
  - Open ports:
    : - 22 (SSH)
      - 80 (for the Ruby Sunstone GUI)
      - 2616 (for the FireEdge GUI)
      - 5030 (for the OneGate service)

Note that the server needs an internet connection to download software packages during installation.

## Step 2: Download and Install miniONE

You can download miniONE from the [GitHub repository](https://github.com/OpenNebula/minione).

To quickly download miniONE, run:

```
wget 'https://github.com/OpenNebula/minione/releases/latest/download/minione'
````

After downloading, open a terminal and use the `sudo` to become the `root` user. For example, run:

```default
sudo -i
```

Go to the folder where you downloaded the miniONE script, by using the `cd` command:

```default
cd <path/to/folder>
```

Next, ensure that the `minione` file has execute permissions, by running:

```default
chmod +x minione
```

To install miniONE, run:

```default
bash minione
```

The miniONE script will begin the installation, logging output to the terminal. Installation usually takes between one and two minutes. When it's finished, miniONE shows a report with connection parameters and login credentials:

```default
### Report
OpenNebula 7.0 was installed
Sunstone is running on:
  http://192.168.1.130/
FireEdge is running on:
  http://192.168.1.130:2616/
Use following to login:
  user: oneadmin
  password: ZMCoOWUsBg
```

At this point, you have successfully installed miniONE. OpenNebula services should be running, and the system should be ready for your first login.

## Step 3: Verify the Installation

We will verify the installation by logging in to OpenNebula's FireEdge Sunstone GUI.

Point your browser to the FireEdge IP and port provided by the miniONE report, in this case `192.168.1.130`, or simply to `http://localhost:2616`. You should be greeted with the Sunstone login screen:

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

