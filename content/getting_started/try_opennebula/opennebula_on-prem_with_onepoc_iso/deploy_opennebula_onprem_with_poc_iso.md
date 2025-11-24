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
**Installing the ISO will delete all the disk data on the server during the installation.**
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

{{< alert title="Note" color="warning" >}}
`/dev/sdXX` is the drive for the USB drive. It's recommended to check it twice to avoid catastrophic data lose{{< /alert >}}

On windows, the USB drive can be created with Rufus.

{{< alert title="Note" color="warning" >}}
The USB drive must be created using DD mode or else it won't be bootable.{{< /alert >}}

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

```bash

                         ╱╱        ╱╱╱╲╲
                     ╱╱╳╳╳╱     ╱╲╳╱╱╳╲╲╱╳╲
                   ╱╲╳╳╳╳╳╱    ╱╳╱       ╲╳╳   ╱╲╱╱╱╳╲╲      ╱╱╳╲╲╲    ╱╱╱╱╲╲╲╲
         ╱╱╱╱╲╲╲╲ ╱╳╳╳╳╳╳╲     ╳╳         ╲╳╲  ╳╳╱    ╲╳╲  ╱╳╱    ╲╳╲  ╳╳╱   ╱╳╲
      ╱╲╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╲╱ ╱    ╳╳         ╱╳╱  ╳╱      ╳╳ ╱╳╳╲╱╱╱╱╱╳╳  ╳╳    ╲╳╲
     ╱╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╲╱ ╱╲╱    ╲╳╱╲      ╱╳╲   ╳╳     ╱╳╲  ╳╳╲    ╱╱╲  ╳╳    ╱╳╱
    ╱╳╳╳╳╳╳╳╳╳╳╳╳╳╳╱  ╱╲╳╳╱      ╲╳╳╲╲╱╱╳╱╱    ╳╳╱╲╲╱╱╳╱    ╲╳╲╲╱╱╳╱   ╳╳    ╱╳╱
    ╳╳╳╳╳╳╳╳╳╳╳╳╱   ╱╳╳╳╳╲╲                    ╳╳
    ╲╳╳╳╳╳╳╳╱╱  ╱╱╳╳╳╳╲╱  ╱                    ╳╳
    ╱╳╳╳╱╱   ╱╱╳╳╳╲╱╱  ╱╱╳╱
  ╱╱╱   ╱╱╱╳╳╳╱╱   ╱╱╳╳╳╳╱╲    ╱╳╳╲     ╳╳               ╳╳                     ╱╳
   ╱╱╱╳╳╱╱╱   ╱╱╱╳╳╳╱╱╱   ╱    ╱╳╲╱╲    ╳╳      ╱╱╲      ╳╳ ╱╱╲╲                ╱╳      ╱╱╲
╱╱╱╱    ╳╱╱╱╳╳╱╱╱    ╱╱╲╳╳╱    ╱╳╱ ╱╱   ╳╳   ╱╲╲╱╱╱╲╳╲   ╳╳╲╱  ╲╱╳╲  ╳╳     ╳╳  ╱╳   ╱╳╱╱╳╲╲╲╳╱
╲╱╱╱╱╱╱╱╱╱     ╱╱╱╳╳╳╳╳╳╱╱╲    ╱╳╱  ╲╱  ╳╳  ╱╳╱╲    ╲╳╲  ╳╲      ╳╳  ╳╳     ╳╳  ╱╳  ╱╳╱     ╲╳╱
      ╱╱╱╱╱╳╲╱╱╱╱╱╱      ╱╱    ╱╳╱   ╲╳╲╳╳  ╲╳╳╱╱╱╱╱╱╱╱  ╳╳      ╲╳  ╳╳     ╳╳  ╱╳  ╲╳╲     ╲╳╱
              ╱╱╱╱╱╱╳╳╳╳╳╳╱    ╱╳╱    ╲╳╳╳   ╲╳╲   ╱╱╱   ╳╳╱╱  ╲╲╳╱  ╲╳╲  ╱╲╳╳  ╱╳   ╱╳╲   ╱╳╳╱
     ╲╲╲╲╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╲    ╱╱╲     ╲╱╱     ╲╲╲╱╱     ╱╲ ╲╲╱╱╱      ╲╲╱╱╱╱╱  ╱╱     ╲╲╱╱╱ ╱╲

Welcome to OpenNebula Proof of Concept (onepoc) !

- Please, log in as user `root`
- For a basic configuration of the server, please execute `onefemenu`
- After the network is configured, the sunstone interface will be running in

  http://this_server:2616

- Please, check the manual page onepoc-quickstart with a

  $ man onepoc-quickstart 7

Thank you!
```

{{< alert title="Note" color="success" >}}
Default user is root and default root password is `0p3nN3bul4`.
After the login, execute `onefemenu` in order to configure the frontend.
{{< /alert >}}

![frontend-menu](/images/ISO/04-frontend-menu.png)

Now is time to configure the network using the option [`netconf`](./advanced_configuration_of_poc_iso.md#netconf) on the menu. This will launch `nmtui` (the default ncurses configuration interface), which allows the setup of the network and hostname, as more complex network configuration (bonding, VLAN, etc.)

![frontend-network_setup](/images/ISO/05-frontend-network_setup.png)

## Add the server as an OpenNebula host

After the installation, the server runs only the frontend and needs to be added as a OpenNebula hypervisor to run VMs. The steps are:

- log in as root in the server
- execute [`onehostmenu`](./advanced_configuration_of_poc_iso.md#onehostmenu)
- select the option `add_host`

{{< alert title="Note" color="success" >}}
When a node is added, always use it's external IP, neither `localhost` nor a loopback addres `127.x.x.x'.
{{< /alert >}}

After selecting the option `add_host`, the IP for the host will be asked for

```
                                 ┌──────────────────────────────────────────────────────────┐
                                 │ Insert the IP for the node                               │
                                 │ ┌──────────────────────────────────────────────────────┐ │
                                 │ │AA.BB.CC.DD                                           │ │
                                 │ └──────────────────────────────────────────────────────┘ │
                                 │                                                          │
                                 ├──────────────────────────────────────────────────────────┤
                                 │               <  OK  >        <Cancel>                   │
                                 └──────────────────────────────────────────────────────────┘

```

Then, the user to log into the node will be asked. It MUST be root or have sudo root access without password

```
                                 ┌──────────────────────────────────────────────────────────┐
                                 │ Insert the user for the node                             │
                                 │ ┌──────────────────────────────────────────────────────┐ │
                                 │ │root                                                  │ │
                                 │ └──────────────────────────────────────────────────────┘ │
                                 │                                                          │
                                 ├──────────────────────────────────────────────────────────┤
                                 │               <  OK  >        <Cancel>                   │
                                 └──────────────────────────────────────────────────────────┘
```

A confirmation dialog like the following will be shown:

```
                       ┌──────────────────────────────────────────────────────────────────────────────┐
                       │ Add node AA.BB.CC.DD logging as user root (with nopasswd root permissions)?  │
                       │ Password will be asked. If not provided, an ssh connection using the ssh key │
                       │ of onepoc user will be used                                                  │
                       │                                                                              │
                       │                                                                              │
                       ├──────────────────────────────────────────────────────────────────────────────┤
                       │                         < Yes >             < No  >                          │
                       └──────────────────────────────────────────────────────────────────────────────┘
```

After that, an ansible playbook will run in order to execute all the needed operations on the frontend. This may take some minutes

```
...
PLAY RECAP *********************************************************************
...
...
AA.BB.CC.DD                : ok=52   changed=27   unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
frontend                   : ok=43   changed=11   unreachable=0    failed=0    skipped=27   rescued=0    ignored=0

Press any key to continue
```

**Graphical User Interface**

The GUI should be available in http://\<frontend\_ip\>:2616

The oneadmin password can be obtained in `onefemenu`, in the option `show_oneadmin_pass`

{{< alert title="Note" color="success" >}}
`oneadmin` default password is 32 hex chars long (128 bits of entropy). It's recommended to create another users to work with OpenNebula and let oneadmin user only for administrative tasks.
{{< /alert >}}

**Networking**

The ISO PoC networking comes with no networks added, but FRR is configured to add BGP-EVPN so VXLANs should work for internal communication.

That means that a virtual network over VXLAN can be created from the web interface, selecting the type VXLAN, setting up the physical device for the package transit, and filling the contextualization of the network (address, gateway, etc.).

A VNET can be set up on the sunstone interface on Networks \-\> Virtual Networks \-\> Create Virtual Network, following the next model. In this case we are using the VXLAN 100, on the interface enp3s0 of the hosts. Please, note that the VXLAN mode must be `evpn` in all cases

![sunstone-network_config](/images/ISO/07-sunstone-network_config.png)

An address range must be created, in this case we chose an IPv4 range address starting from 172.30.0.8 with 100 consecutive IPs. The network contextualization, in this case, has the following parameters

![sunstone-network_context](/images/ISO/08-sunstone-network_context.png)

{{< alert title="Note" color="warning" >}}
The contextualization MTU on this network MUST be the MTU of the physical interface minus 50 bytes (the size of the VXLAN encapsulation). 1450 is a safe default (regular ethernet frame size).
{{< /alert >}}


### Network considerations

VXLAN networks are totally internal and have no access to external networks. By default they can be considered a totally isolated net. External access from/to this networks must be configured.

- To determine the virtual network that needs external access use `onevnet list`. This command will list the existent virtual networks, for instance:

```
# onevnet list
  ID USER     GROUP    NAME                                                           CLUSTERS   BRIDGE                            STATE                    LEASES OUTD ERRO
   0 oneadmin oneadmin test_vnet                                                      0          XXXXX                             rdy                           0    0    0
```

- The `ID` and the `NAME` field of every row can be used for all operations on virtual networks. In this case, to create the default gateway on this virtual net, the following command should be executed

```
# onevnet_add_gw 0
```

To delete the gateway and make the network unreachable, reverting the behaviour, execute `onevnet_del_gw`

- Virtual machines on this virtual net now are reachable, but they won't be able to access to the internet because there is no NAT. A simple NAT can be created executing the command `enable_masquerade`

{{< alert title="Note" color="warning" >}}
By default, the `enable_masquerade` command will allow ALL the virtual networks having a gateway. To disable this behaviour, execute `disable_masquerade`.
{{< /alert >}}


