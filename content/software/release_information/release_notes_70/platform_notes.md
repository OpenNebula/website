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
| Red Hat Enterprise Linux | 8, 9, 10                                   | [Front-End Installation]({{% relref "front_end_installation" %}})                                                     |
| AlmaLinux                | 8, 9, 10                                   | [Front-End Installation]({{% relref "front_end_installation" %}})                                                     |
| Ubuntu Server            | 22.04 (LTS), 24.04 (LTS)                   | [Front-End Installation]({{% relref "front_end_installation" %}})                                                     |
| Debian                   | 11, 12, 13                                     | [Front-End Installation]({{% relref "front_end_installation" %}}).<br/>Not certified to manage VMware infrastructures |
| MariaDB or MySQL         | Version included in the Linux distribution | [MySQL Setup]({{% relref "../../../software/installation_process/manual_installation/database#mysql" %}})                                                                  |
| SQLite                   | Version included in the Linux distribution | Default DB, no configuration needed                                                                                                                                                         |

{{< alert title="Note" color="success" >}}
Support for nodes’ operating system ensures that the latest two LTS releases feature certified packages.{{< /alert >}}

### KVM Nodes

| Component                | Version                                                                                                    | More information                                                                                                                     |
|--------------------------|------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| Red Hat Enterprise Linux | 8, 9, 10                                                                                                   | [KVM Driver]({{% relref "../../../product/operation_references/hypervisor_configuration/kvm_driver#kvmg" %}})                           |
| AlmaLinux                | 8, 9, 10                                                                                                   | [KVM Driver]({{% relref "../../../product/operation_references/hypervisor_configuration/kvm_driver#kvmg" %}})                           |
| Ubuntu Server            | 22.04 (LTS), 24.04 (LTS)                                                                                   | [KVM Driver]({{% relref "../../../product/operation_references/hypervisor_configuration/kvm_driver#kvmg" %}})                           |
| Debian                   | 11, 12                                                                                                     | [KVM Driver]({{% relref "../../../product/operation_references/hypervisor_configuration/kvm_driver#kvmg" %}})                           |
| KVM/Libvirt              | Support for version included in the Linux distribution.                                                    | [KVM Node Installation]({{% relref "kvm_node_installation#kvm-node" %}}) |

### LXC Nodes

| Component     | Version                                                | More information                                                                                                                     |
|---------------|--------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| Ubuntu Server | 22.04 (LTS), 24.04 (LTS)                               | [LXC Driver]({{% relref "../../../product/operation_references/hypervisor_configuration/lxc_driver#lxcmg" %}})                          |
| Debian        | 11, 12                                                 | [LXC Driver]({{% relref "../../../product/operation_references/hypervisor_configuration/lxc_driver#lxcmg" %}})                          |
| AlmaLinux     | 8, 9, 10                                               | [LXC Driver]({{% relref "../../../product/operation_references/hypervisor_configuration/lxc_driver#lxcmg" %}})                          |
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
| iSCSI       | Version included in the Linux distribution | [LVM Drivers]({{% relref "../../../product/cluster_configuration/lvm" %}}) |
| LVM2        | Version included in the Linux distribution | [LVM Drivers]({{% relref "../../../product/cluster_configuration/lvm" %}}) |
| Ceph        | Reef v18.2.x<br/>Squid   v19.2.x          | [The Ceph Datastore]({{% relref "../../../product/cluster_configuration/storage_system/ceph_ds#ceph-ds" %}})  |
| NetApp      | ONTAP 9.16.1P1.                            | [NetApp ONTAP Drivers]({{% relref "../../../product/cluster_configuration/san_storage/netapp" %}}) |
| LVM-thin    | NetApp ONTAP 9.16.1P1 & Pure Storage 6.7.2 | [LVM Thin]({{% relref "../../../product/cluster_configuration/lvm" %}}) |

### Authentication

| Component             | Version                                    | More information                                                                                                        |
|-----------------------|--------------------------------------------|-------------------------------------------------------------------------------------------------------------------------|
| net-ldap ruby library | 0.19.0 or 0.20                             | [LDAP Authentication]({{% relref "../../../product/cloud_system_administration/authentication_configuration/ldap#ldap" %}})      |
| openssl               | Version included in the Linux distribution | [x509 Authentication]({{% relref "../../../product/cloud_system_administration/authentication_configuration/x509#x509-auth" %}}) |

### Monitoring and Backups

| Component                     | Version   | More information                                                                                                                    |
|-------------------------------|-----------|-------------------------------------------------------------------------------------------------------------------------------------|
| Prometheus monitoring toolkit | 2.53.1    | [Monitoring and Alerting Installation]({{% relref "../../../product/cloud_system_administration/prometheus/install.md#monitor-alert-installation" %}}) |
| Restic backup backend         | 0.17.3    | [Backup Datastore: Restic]({{% relref "../../../product/cluster_configuration/backup_system/restic.md#vm-backups-restic" %}})                                        |
| Veeam B&R                     | 12.3.1    | [Veeam Backup (EE)]({{% relref "../../../product/cluster_configuration/backup_system/veeam.md" %}}) |

### Sunstone

| Browser   | Version     |
|-----------|-------------|
| Chrome    | 61.0 - 94.0 |
| Firefox   | 59.0 - 92.0 |

{{< alert title="Note" color="success" >}}
For Windows desktops using **Chrome** or **Firefox** you should disable the option `touch-events` for your browser:{{< /alert >}}

**Chrome**: `chrome://flags` -> `#touch-events`: `disabled`.
**Firefox**: `about:config` -> `dom.w3c_touch_events`: `disabled`.

### Billing

| Component   | Version     |
|-------------|-------------|
| WHMCS       | 8.13.1      |


## Certified Infrastructure Scale

A single instance of OpenNebula (i.e., a single `oned` process) has been stress-tested to cope with 500 hypervisors without performance degradation. This is the maximum recommended configuration for a single instance, and depending on the underlying configuration of storage and networking, it is mainly recommended to switch to a federated scenario for any larger number of hypervisors.

However, there are several OpenNebula users managing significantly higher numbers of hypervisors (to the order of two thousand) with a single instance. This largely depends, as mentioned, on the storage, networking, and also monitoring configuration.

## Front-End Platform Notes

The following applies to all Front-Ends:

* Only **Ruby versions >= 2.0 are supported**.

## Nodes Platform Notes

The following items apply to all distributions:

* When using qcow2 storage drivers you can make sure that the data is written to disk when doing snapshots by setting the `cache` parameter to `writethrough`. This change will make writes slower than other cache modes but safer. To do this edit the file `/etc/one/vmm_exec/vmm_exec_kvm.conf` and change the line for `DISK`:

```default
DISK = [ driver = "qcow2", cache = "writethrough" ]
```

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
