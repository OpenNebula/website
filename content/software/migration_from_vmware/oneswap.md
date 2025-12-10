---
title: "Migrating VMs with OneSwap"
date: "2025-02-17"
description: "The OneSwap command-line tool allows you to quickly migrate Virtual Machines and appliances from VMware."
categories:
pageintoc: "268"
tags:
weight: "1"
---

<a id="oneswap"></a>

<!--# OneSwap -->

OpenNebula provides [OneSwap](https://github.com/OpenNebula/one-swap), a command-line tool designed to simplify migrating Virtual Machines from vCenter to OpenNebula. OneSwap has been used in the field with a 96% success rate in converting VMs automatically, greatly simplifying and speeding up the migration process.

OneSwap supports importing Open Virtual Appliances (OVAs) previously exported from vCenter/ESXi environments. The [Managing OVAs and VMDKs]({{% relref "import_ova" %}}) guide provides instructions, with complete examples.

{{< alert color="success" >}}
OneSwap is part of a set of tools and services designed to guide you in achieving a smooth transition from VMware. These include the [VMware Migration Service](https://support.opennebula.pro/hc/en-us/articles/18919424033053-VMware-Migration-Service), a complete guidance and support framework to help organizations define and execute their migration plan with minimal disruption to business operations. Further information is available in [Migrating from VMware to OpenNebula](https://support.opennebula.pro/hc/en-us/articles/17225311830429-White-Paper-Migrating-from-VMware-to-OpenNebula).
{{< /alert >}}

## Installation and requirements

The package `opennebula-swap`, provided on the official repositories, provides the command `oneswap`.

It can be installed in Ubuntu with  

```
apt install opennebula-swap
```

And in Alma Linux and RHEL with

```
dnf install opennebula-swap
```

### Requirements and recommended settings

OneSwap requirements for virtual conversion from VMWare to OpenNebula are the following:
- OneSwap is only supported on Ubuntu 24.0 LTS and Alma Linux/RHEL 9 servers.
- A working OpenNebula environment with capacity enough to store imported images and VMs and a user with permissions on the destination datastores. Alternatively, conversion can be done with user `oneadmin` and set the right permissions in a posterior step.
- A vCenter endpoint with valid credentials to export the VMs. 
  - The parameters `vcenter`, `vuser`, `vpass` and `port` must be specified.
  - If Delta conversion mode is being used, the user running `oneswap` command must have ssh passwordless access to the ESXi host where the VMs to convert are running.
- If oneswap is ran on a different machine than OpenNebula frontend, then the following components must also be configured:
  - The [Command Line Interface (CLI) to access to the OpenNebula server]({{% relref "command_line_interface#cli-configuration" %}}) must be able to execute commands on the OpenNebula frontend. Normally, only the variables `ONE_XMLRPC` and `ONE_AUTH` are needed.
  - Set up the transfer method options (oneswap parameters `http_transfer`, `http_host` and `http_port`).

{{< alert color="success" title="OneSwap configuration file" >}}
OneSwap parameters can be set up on the configuration file `oneswap.yaml`, for instance 
```
:vcenter: '172.20.0.123'                 # vCenter hostname or IP
:vuser: 'administrator@vsphere.local'    # vCenter username
:vpass: 'changeme123'                    # vCenter password
:port: 443                               # vCenter port

:http_transfer: true                     # Needed to run oneswap on a host that is not the frontend
:http_host: 172.10.0.3                   # OpenNebula frontend IP
:http_port: 443                          # OpenNebula frontend port
```
{{< /alert >}}

### Optional requirements and required tools

- VDDK library is recommended to improve disk transfer speeds. As of the moment of writing, the library can be downloaded from [Broadcom developer portal](https://developer.broadcom.com/sdks/vmware-virtual-disk-development-kit-vddk/latest/)
- It is recommended to increase the vCenter API timeout to avoid request timeouts while converting big VMs. By default this value is 120 minutes and can be changed in vCenter at "Administration -> Deployment -> Client Configuration", allowing values up to 1440 minutes (24 hours).
- The following libraries/programs must be installed 
  - `libguestfs` library, version must be >= 1.50
  - `libvirt` library, version should be >= 8.7.0
  - `virt-v2v`, stable version

Ubuntu 24.04 and AlmaLinux/RHEL 9 provide up to date versions of the packages

### Required software for migrating Windows Virtual machines

There are two requirements to convert Windows Virtual Machines:
- [VirtIO ISO drivers](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso) must be stored in the `/usr/local/share/virtio-win` directory.
- [RHsrvany, an Open Source srvany implementation](https://github.com/rwmjones/rhsrvany) to create the needed Windows services during the migration. The package for AlmaLinux and RHEL is [hosted on fedoraproject.org](https://kojipkgs.fedoraproject.org/packages/mingw-srvany/1.1/11.eln153/noarch/mingw-srvany-redistributable-1.1-11.eln153.noarch.rpm). <br/>
For compatibility with older versions of virt2v the following symlinks are needed

```
ln -s /usr/share/virt-tools /usr/local/share/virt-tools
ln -s /usr/share/virtio-win /usr/local/share/virtio-win
```

{{< alert color="success" title="Installing RHsrvany on Ubuntu" >}}
Github page for the project provides instructions about how to decompress the package for Ubuntu. At the moment of writing the procedure is

```
apt install -y rpm2cpio

wget -nd -O srvany.rpm https://kojipkgs.fedoraproject.org/packages/mingw-srvany/1.1/11.eln153/noarch/mingw-srvany-redistributable-1.1-11.eln153.noarch.rpm

rpm2cpio srvany.rpm | cpio -idmv \
  && mkdir /usr/share/virt-tools \
  && mv ./usr/i686-w64-mingw32/sys-root/mingw/bin/*exe /usr/share/virt-tools/
```
{{< /alert >}}

## Migrating Virtual Machines 

{{< alert color="warning" title="Limitations for importing" >}}
- The **VMs to be converted must be powered off in vCenter** for both regular and Delta conversion. Suspended or hibernated VM migration will fail. <br/>
- For __regular conversion, VMs must not have any snapshot__, either.
{{< /alert >}}

### On Linux VMs
- The virtual machine must have the kernel headers installed. The name of the package may differ on each distribution, for instance, in Ubuntu the package to install is `linux-headers` and in Alma Linux is `kernel-headers`.
- The kernel version must support virtio drivers (kernel 2.6.30 or greater, from 2009-07-09).
- virt-v2v tool does not support updating GRUB2, if the following message is shown during the conversion process:

```
WARNING: could not determine a way to update the configuration of Grub2
```

booting the VM from a rescue CD and fixing grub may be necessary

### On Windows VMs
- Fast startup must be disabled (Control Panel -> Power Options -> Advanced power settings)
- Installing VirtIO Storage and Network drivers before the conversion will improve conversion times. If not, they will be injected later.
- Officially, Windows 2016 and onwards **require** UEFI boot.
- Windows VMs can only be converted with virt-v2v style transfer (`custom` and `fallback` will fail)

### UEFI boot
OneSwap normally detects if the VM boots in UEFI mode and sets up OpenNebula template accordingly, but in some strange cases autodetection may fail. In these cases, modify the following options on the OpenNebula template:
- CPU architecture: `x86_64`
- Machine type: `q35`
- UEFI firmware: UEFI (for secure firmware the box must be checked)
![Setting up UEFI boot after oneswap migration](/images/oneswap/modify_UEFI.png)


