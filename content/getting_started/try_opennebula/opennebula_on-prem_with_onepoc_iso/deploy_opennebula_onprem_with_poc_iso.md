---
title: "Deploy OpenNebula On-prem with the PoC ISO"
description:
weight: 1
---

## Introduction

The OpenNebula PoC ISO is a disk image that can be written to removable media, that can be booted up to install a pre-configured version of AlmaLinux 9 and OpenNebula Enterprise Edition, including initial setup, on a server provided.

Once the ISO has booted and finished installing and setting up the software, a pre-configured cloud based on OpenNebula will be ready for immediate use, installed on a single bare-metal server, complete with the OpenNebula Front-end server and a KVM hypervisor node. The same ISO can be used to install other KVM hypervisors on the same infrastructure.

The OS installed also includes a menu and a little set of ansible playbooks to make the OpenNebula infrastructure Management simpler.

## Requirements

The OpenNebula PoC ISO is based on AlmaLinux 9, and thus it shares the same requirements to run. Note that only the x86-64-v2 instruction set (introduced in 2008\) is supported. The following table states the minimum requirements for installing the PoC ISO.

| Component | Minimum (not recommended) | Recommended |
| :---- | :---- | :---- |
| **CPU** | - Intel - Nehalem/Silvermont<br />- AMD - Bulldozer/Jaguar<br />- Virtualization enabled at BIOS level | - Recent CPU (after 2020)<br />- Virtualization enabled at BIOS level |
| **Memory** | - 6 GB for the frontend<br />- 4 GB for the hypervisors | - Over 32 GB for frontend and nodes |
| **Disk** | - 128 GB SATA SSD  | - 512 GB NvME |
| **Network** | - Not needed for installation<br />- At least a NIC for management | - At least 2 NICs (management and service) |

{{< alert title="Warning" color="warning" >}}
Installing the ISO will delete all the disk data on the server during the installation. 
{{< /alert >}}

## Downloading the image, preparing the media and installing

Now it is time to download the [OpenNebula AlmaLinux ISO from https://one-poc.s3.eu-central-1.amazonaws.com/AlmaLinux-onepoc.iso](https://one-poc.s3.eu-central-1.amazonaws.com/AlmaLinux-onepoc.iso) in first instance. To check if the image was downloaded correctly, you can check the [checksum for the ISO in https://one-poc.s3.eu-central-1.amazonaws.com/AlmaLinux-onepoc.iso.sha](https://one-poc.s3.eu-central-1.amazonaws.com/AlmaLinux-onepoc.iso.sha).

Once the image is downloaded, there are two ways to go:

- If the server has a IPMI, ILO, iDRAC, RSA or some other way to mount remote media (ISO or USB), the ISO can be directly mounted on it
- If, on the other side, there is no server console but there is physical access to the USB ports on the server, a USB image can be created to boot from it

In Linux or MacOS, the image can be dumped on the USB with the following command

```bash
dd if=/path/to/your/Almalinux-onepoc.iso of=/dev/sdXX
```

{{< alert title="Note" color="success" >}}
`/dev/sdXX` is the drive for the USB drive. It's recommended to check it twice to avoid catastrophic data lose{{< /alert >}}

On windows, the USB drive can be created with Rufus.

{{< alert title="Note" color="success" >}}
The image has to be created using DD mode or else the USB drive won't be bootable.{{< /alert >}}

With the media inserted (or virtually mounted) on the server, after rebooting it set the right boot device on the BIOS. Some BIOS may be able to boot the media as MBR and UEFI. We recommend to boot is as UEFI for compatibility reasons.

The bootloader will show the following screen

| ![uefi_boot_screen](/images/ISO/0-uefi_boot_screen.png) | ![mbr_boot_screen](/images/ISO/0-mbr_boot_screen.png) |
| ----- | ----- |
| UEFI boot screen | MBR boot screen |

The Options are the following:
- `Install OpenNebula POC` will install a full OpenNebula 7.0.1 frontend and the necessary software to make it a OpenNebula KVM hypervisor
- `Install OpenNebula Node` will install only the KVM Hypervisor packages

The installation interface will be in text mode and will only ask for confirmation before deleting all the data on the first disk that it finds on a screen that looks like the following:

![validation_script](/images/ISO/01-validation_script.png)

{{< alert title="Warning" color="warning" >}}
**IMPORTANT: OpenNebula will be installed on the first disk found and it will delete IRREVERSIBLY all the data in that disk. Ensure that this is the right server.**{{< /alert >}}

After the confirmation, the installation will start. It will show some information related to the default settings and the packages that will be installed

![anaconda_unattended_install](/images/ISO/02-anaconda_unattended_install.png)

## Frontend configuration

Once the installation is finished in the frontend, no network card will be configured, so an access with the console must be provided. It will look like the following

![frontend-issue_screen](/images/ISO/03-frontend-issue_screen.png)

Default user is root and default root password is `0p3nN3bul4`
After the login, execute `onefemenu` in order to configure the frontend.

![frontend-menu](/images/ISO/04-frontend-menu.png)

Now is time to configure the network using the option `netconf` on the menu. This will launch `mtui` (the default ncurses configuration interface), which allows the setup of the network and hostname, as more complex network configuration (bonding, VLAN, etc.)

![frontend-network_setup](/images/ISO/05-frontend-network_setup.png)

Once that is finished, a set of ansible scripts will be running to set up certain OpenNebula services that rely on the network. The hostname can also be set up here.

![frontend-ansible_config](/images/ISO/06-frontend-ansible_config.png)

## Configure hosts

To configure hosts:

- log in as root (with the same password `0p3nN3bul4`)
- execute `onehostmenu`
- setup the network with netconf, in the same manner as with the frontend

The hosts do not need any other configuration on them but the network

## Adding hosts to the frontend

To add the nodes the following information is needed:

- the management IP for the node
- a user with sudo permissions (root is OK)
- the password for that user (if ssh passwordless access is not configured)

As the frontend itself is a node, it should be added up to the infrastructure as well. On the same onefemenu interface, navigate to add\_host and put there the same IP that has been already configured.

NOTE: It's important to set the same IP that was used to access externally (neither localhost nor a loopback 127.x.x.x)

The frontend has ssh passwordless access configured, so it won't ask for any password. If a second node is added, the password for that user will be asked in order to have a key interchange

After some Ansible configuration, the node will be added with all the necessary configuration set up

**Graphical User Interface**

The GUI should be available in http://\<frontend\_ip\>:2616

The oneadmin password can be obtained in onefemenu, in the option `show_oneadmin_pass`

NOTE: take in account that oneadmin password is 32 chars long. We recommend to create other users to work with OpenNebula, which can be on the oneadmin group.

**Networking**

The ISO PoC networking comes with no networks added, but FRR is configured to add BGP-EVPN so VXLANs should work for internal communication.

That means that a virtual network over VXLAN can be created from the web interface, selecting the type VXLAN, setting up the physical device for the package transit, and filling the contextualization of the network (address, gateway, etc.).

A VNET can be set up on the sunstone interface on Networks \-\> Virtual Networks \-\> Create Virtual Network, following the next model. In this case we are using the VXLAN 100, on the interface enp3s0 of the hosts. Please, note that the VXLAN mode must be `evpn` in all cases

![sunstone-network_config](/images/ISO/07-sunstone-network_config.png)

An address range must be created, in this case we chose an IPv4 range address starting from 172.30.0.8 with 100 consecutive IPs. The network contextualization, in this case, has the following parameters

![sunstone-network_context](/images/ISO/08-sunstone-network_context.png)

**IMPORTANT:**

- the contextualization MTU size of this network MUST be the MTU of the interface minus 50 bytes (the size of the VXLAN encapsulation)
- the physical device must have the same name on all the hosts. If the physical network interface name of the hosts is different (because they have different hardware), please check "Advanced configuration \-\> Setting interface altnames"
- This Virtual Networks are totally internal and have no access to external networks. Please, check "Advanced configuration \-\> Configure Gateway and NAT" if external access to the network is needed.

### Networking advanced Configuration

**Configure Gateway and NAT**

In order to access VMs via Network the virtual network must have a reachable gateway

To set the gateway there are some helpers on the file /usr/lib/one/onepoc/one\_aliases.sh

- The aliases `onevnet_add_gw` and `onevnet_del_gw` create or delete the gateway for the necessary bridge if the bridge exists in the frontend (a VM from the desired VNET is running on the frontend).
- The aliases `enable_masquerade` and `disable_masquerade` allow ALL the virtual networks with a gateway to have access to the same external networks as the frontend has.

**Setting interface altnames**

If the hosts have different names for the physical interface that has the network (i.e., on one of the hosts the name is `enp3s0` and in another is `eno1`) alternative names can be set for every  interface.  For instance, the following file can be created in the host with interface `eno1`

`/etc/systemd/system/altnames-opennebula.service`

With the following contents

```bash
[Unit]
Description=Set OpenNebula network interface alternative name

[Service]
Type=simple
ExecStart=ip link property add dev eno1 altname one_if

[Install]
WantedBy=multi-user.target
```

Note that the line `ExecStart` has the name of the interface (`eno1`) and the desired name for this physdev (`one_if').
After that is finished, reload, enable and start the service:

```bash
systemctl daemon-reload
systemctl enable altnames-opennebula.service
systemctl start altnames-opennebula.service
```

This will set up the interface `one_if` on this server. It can be checked with the command `ip link show dev one_if`

```default
2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether xx:xx:xx:xx:xx:xx brd ff:ff:ff:ff:ff:ff
    altname one_if
```

Repeat the same on the other hosts but changing eno1 for the required device name in the file.

When all nodes have the altname for the interface, change the PHYDEV of the required virtual networks to `one_if`.

