---
title: "Platform Notes"
date: "2025-02-17"
description:
categories:
pageintoc: "245"
tags:
weight: "3"
---

<a id="uspng"></a>

<!--# Platform Notes 7.0 -->

This page will show you the specific considerations when using an OpenNebula cloud, according to the different supported platforms.

This is the list of the individual platform components that have been through the complete [OpenNebula Quality Assurance and Certification Process](https://github.com/OpenNebula/one/wiki/Quality-Assurance).

## Certified Components Version

### Front-End Components

| Component                | Version                                    | More information                                                                                                                                                                            |
|--------------------------|--------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Red Hat Enterprise Linux | 8, 9                                       | [Front-End Installation]({{% relref "front_end_installation" %}})                                                     |
| AlmaLinux                | 8, 9                                       | [Front-End Installation]({{% relref "front_end_installation" %}})                                                     |
| Ubuntu Server            | 22.04 (LTS), 24.04 (LTS)                   | [Front-End Installation]({{% relref "front_end_installation" %}})                                                     |
| Debian                   | 11, 12                                     | [Front-End Installation]({{% relref "front_end_installation" %}}).<br/>Not certified to manage VMware infrastructures |
| MariaDB or MySQL         | Version included in the Linux distribution | [MySQL Setup]({{% relref "../../../software/installation_process/manual_installation/database#mysql" %}})                                                                  |
| SQLite                   | Version included in the Linux distribution | Default DB, no configuration needed                                                                                                                                                         |
| Ruby Gems                | Versions installed by opennebula-rubygems  | Detailed information in `/usr/share/one/Gemfile`                                                                                                                                            |

{{< alert title="Note" color="success" >}}
Support for nodes’ operating system ensures that the latest two LTS releases feature certified packages.{{< /alert >}}

### KVM Nodes

| Component                | Version                                                                                                    | More information                                                                                                                     |
|--------------------------|------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| Red Hat Enterprise Linux | 8, 9                                                                                                       | [KVM Driver]({{% relref "../../../product/operation_references/hypervisor_configuration/kvm_driver#kvmg" %}})                           |
| AlmaLinux                | 8, 9                                                                                                       | [KVM Driver]({{% relref "../../../product/operation_references/hypervisor_configuration/kvm_driver#kvmg" %}})                           |
| Ubuntu Server            | 22.04 (LTS), 24.04 (LTS)                                                                                   | [KVM Driver]({{% relref "../../../product/operation_references/hypervisor_configuration/kvm_driver#kvmg" %}})                           |
| Debian                   | 11, 12                                                                                                     | [KVM Driver]({{% relref "../../../product/operation_references/hypervisor_configuration/kvm_driver#kvmg" %}})                           |
| KVM/Libvirt              | Support for version included in the Linux distribution.<br/>For RHEL the packages from `qemu-ev` are used. | [KVM Node Installation]({{% relref "kvm_node_installation#kvm-node" %}}) |

### LXC Nodes

| Component     | Version                                                | More information                                                                                                                     |
|---------------|--------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| Ubuntu Server | 22.04 (LTS), 24.04 (LTS)                               | [LXC Driver]({{% relref "../../../product/operation_references/hypervisor_configuration/lxc_driver#lxcmg" %}})                          |
| Debian        | 11, 12                                                 | [LXC Driver]({{% relref "../../../product/operation_references/hypervisor_configuration/lxc_driver#lxcmg" %}})                          |
| AlmaLinux     | 8, 9                                                   | [LXC Driver]({{% relref "../../../product/operation_references/hypervisor_configuration/lxc_driver#lxcmg" %}})                          |
| LXC           | Support for version included in the Linux distribution | [LXC Node Installation]({{% relref "lxc_node_installation#lxc-node" %}}) |

<a id="context-supported-platforms"></a>

### [Linux and Windows Contextualization Packages](https://github.com/OpenNebula/one-apps/wiki/linux_release)

Refer to: [one-apps release](https://github.com/OpenNebula/one-apps/releases/latest)

More information: [one-apps wiki](https://github.com/OpenNebula/one-apps/wiki)

### Open Cloud Networking Infrastructure

| Component           | Version                                    | More information                                                                                                                             |
|---------------------|--------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| 8021q kernel module | Version included in the Linux distribution | [802.1Q VLAN]({{% relref "../../../product/cluster_configuration/networking_system/vlan#hm-vlan" %}})             |
| Open vSwitch        | Version included in the Linux distribution | [Open vSwitch]({{% relref "../../../product/cluster_configuration/networking_system/openvswitch#openvswitch" %}}) |
| iproute2            | Version included in the Linux distribution | [VXLAN]({{% relref "../../../product/cluster_configuration/networking_system/vxlan#vxlan" %}})                    |

### Open Cloud Storage Infrastructure

| Component   | Version                                    | More information                                                                                                                         |
|-------------|--------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------|
| iSCSI       | Version included in the Linux distribution | [LVM Drivers]({{% relref "../../../product/cluster_configuration/storage_system/lvm_drivers#lvm-drivers" %}}) |
| LVM2        | Version included in the Linux distribution | [LVM Drivers]({{% relref "../../../product/cluster_configuration/storage_system/lvm_drivers#lvm-drivers" %}}) |
| Ceph        | Reef v18.2.x<br/>Squid   v19.2.x          | [The Ceph Datastore]({{% relref "../../../product/cluster_configuration/storage_system/ceph_ds#ceph-ds" %}})  |

### Authentication

| Component             | Version                                    | More information                                                                                                        |
|-----------------------|--------------------------------------------|-------------------------------------------------------------------------------------------------------------------------|
| net-ldap ruby library | 0.19.0                                     | [LDAP Authentication]({{% relref "../../../product/cloud_system_administration/authentication_configuration/ldap#ldap" %}})      |
| openssl               | Version included in the Linux distribution | [x509 Authentication]({{% relref "../../../product/cloud_system_administration/authentication_configuration/x509#x509-auth" %}}) |

### Monitoring and Backups

| Component                     | Version   | More information                                                                                                                    |
|-------------------------------|-----------|-------------------------------------------------------------------------------------------------------------------------------------|
| Prometheus monitoring toolkit | 2.53.1    | [Monitoring and Alerting Installation]({{% relref "../../../product/cloud_system_administration/prometheus/install.md#monitor-alert-installation" %}}) |
| Restic backup backend         | 0.16.5    | [Backup Datastore: Restic]({{% relref "../../../product/cluster_configuration/backup_system/restic.md#vm-backups-restic" %}})                                        |
| Veeam                         | 12.3.1    | [Veeam Backup (EE)]({{% relref "../../../integrations/backup_extensions/veeam.md" %}}) |

### Sunstone

| Browser   | Version     |
|-----------|-------------|
| Chrome    | 61.0 - 94.0 |
| Firefox   | 59.0 - 92.0 |

{{< alert title="Note" color="success" >}}
For Windows desktops using **Chrome** or **Firefox** you should disable the option `touch-events` for your browser:{{< /alert >}}

**Chrome**: `chrome://flags` -> `#touch-events`: `disabled`.
**Firefox**: `about:config` -> `dom.w3c_touch_events`: `disabled`.

## Certified Infrastructure Scale

A single instance of OpenNebula (i.e., a single `oned` process) has been stress-tested to cope with 500 hypervisors without performance degradation. This is the maximum recommended configuration for a single instance, and depending on the underlying configuration of storage and networking, it is mainly recommended to switch to a federated scenario for any larger number of hypervisors.

However, there are several OpenNebula users managing significantly higher numbers of hypervisors (to the order of two thousand) with a single instance. This largely depends, as mentioned, on the storage, networking, and also monitoring configuration.

## Front-End Platform Notes

The following applies to all Front-Ends:

* XML-RPC tuning parameters (`MAX_CONN`, `MAX_CONN_BACKLOG`, `KEEPALIVE_TIMEOUT`, `KEEPALIVE_MAX_CONN` and `TIMEOUT`) are only available with packages distributed by us, as they are compiled with a newer xmlrpc-c library.
* Only **Ruby versions >= 2.0 are supported**.

## Nodes Platform Notes

The following items apply to all distributions:

* When using qcow2 storage drivers you can make sure that the data is written to disk when doing snapshots by setting the `cache` parameter to `writethrough`. This change will make writes slower than other cache modes but safer. To do this edit the file `/etc/one/vmm_exec/vmm_exec_kvm.conf` and change the line for `DISK`:

```default
DISK = [ driver = "qcow2", cache = "writethrough" ]
```

* Most Linux distributions using a kernel 5.X (i.e. Debian 11) mount cgroups v2 via systemd natively. If you have hosts with a previous version of the distribution mounting cgroups via fstab or in v1 compatibility mode (i.e. Debian 10) and their libvirt version is <5.5, during the migration of VMs from older hosts to new ones you can experience errors like

```default
WWW MMM DD hh:mm:ss yyyy: MIGRATE: error: Unable to write to '/sys/fs/cgroup/machine.slice/machine-qemu/..../cpu.weight': Numerical result out of range Could not migrate VM_UID to HOST ExitCode: 1
```

This happens in every single VM migration from a host with the previous OS version to a host with the new one.

To solve this, there are 2 options: Delete the VM and recreate it scheduled in a host with the new OS version or mount cgroups in v1 compatibility mode in the nodes with the new OS version. To do this

> 1. Edit the bootloader default options (normally under `/etc/defaults/grub.conf`)
> 2. Modify the default commandline for the nodes (usually `GRUB_CMDLINE_LINUX="..."`) and add the option `systemd.unified_cgroup_hierarchy=0`
> 3. Recreate the grub configuration file (in most cases executing a `grub-mkconfig -o /boot/grub/grub.cfg`)
> 4. Reboot the host. The change will be persistent if the kernel is updated

### RedHat 8 Platform Notes

#### Disable PolicyKit for Libvirt

It is recommended that you disable PolicyKit for Libvirt:

```default
$ cat /etc/libvirt/libvirtd.conf
...
auth_unix_ro = "none"
auth_unix_rw = "none"
unix_sock_group = "oneadmin"
unix_sock_ro_perms = "0770"
unix_sock_rw_perms = "0770"
...
```

### AlmaLinux 9 Platform Notes

#### Disable Libvirtd’s SystemD Socket Activation

OpenNebula currently works only with the legacy `livirtd.service`. You should disable libvirt’s modular daemons and systemd socket activation for the `libvirtd.service`.
You can take a look at [this](https://github.com/OpenNebula/one/issues/6143) bug report, for a detailed workaround procedure.
