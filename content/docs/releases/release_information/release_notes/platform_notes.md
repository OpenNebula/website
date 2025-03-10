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
| MariaDB or MySQL         | Version included in the Linux distribution | [MySQL Setup]({{% relref "/docs/releases/installation/database#mysql" %}})                                                                               |
| SQLite                   | Version included in the Linux distribution | Default DB, no configuration needed                                                                                                                                                         |
| Ruby Gems                | Versions installed by opennebula-rubygems  | Detailed information in `/usr/share/one/Gemfile`                                                                                                                                            |

{{< alert title="Note" color="success" >}}
Debian front-ends are not certified to manage VMware infrastructures with OpenNebula.{{< /alert >}} 

### KVM Nodes

| Component                | Version                                                                                                    | More information                                                                                                                     |
|--------------------------|------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| Red Hat Enterprise Linux | 8, 9                                                                                                       | [KVM Driver]({{% relref "../../../configuration_and_operation/operation_references/hypervisor_configuration/kvm_driver#kvmg" %}})                           |
| AlmaLinux                | 8, 9                                                                                                       | [KVM Driver]({{% relref "../../../configuration_and_operation/operation_references/hypervisor_configuration/kvm_driver#kvmg" %}})                           |
| Ubuntu Server            | 22.04 (LTS), 24.04 (LTS)                                                                                   | [KVM Driver]({{% relref "../../../configuration_and_operation/operation_references/hypervisor_configuration/kvm_driver#kvmg" %}})                           |
| Debian                   | 11, 12                                                                                                     | [KVM Driver]({{% relref "../../../configuration_and_operation/operation_references/hypervisor_configuration/kvm_driver#kvmg" %}})                           |
| KVM/Libvirt              | Support for version included in the Linux distribution.<br/>For RHEL the packages from `qemu-ev` are used. | [KVM Node Installation]({{% relref "kvm_node_installation#kvm-node" %}}) |

### LXC Nodes

| Component     | Version                                                | More information                                                                                                                     |
|---------------|--------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| Ubuntu Server | 22.04 (LTS), 24.04 (LTS)                               | [LXC Driver]({{% relref "../../../configuration_and_operation/operation_references/hypervisor_configuration/lxc_driver#lxcmg" %}})                          |
| Debian        | 11, 12                                                 | [LXC Driver]({{% relref "../../../configuration_and_operation/operation_references/hypervisor_configuration/lxc_driver#lxcmg" %}})                          |
| AlmaLinux     | 8, 9                                                   | [LXC Driver]({{% relref "../../../configuration_and_operation/operation_references/hypervisor_configuration/lxc_driver#lxcmg" %}})                          |
| LXC           | Support for version included in the Linux distribution | [LXC Node Installation]({{% relref "lxc_node_installation#lxc-node" %}}) |

<a id="context-supported-platforms"></a>

### [Linux and Windows Contextualization Packages](https://github.com/OpenNebula/one-apps/wiki/linux_release)

Refer to: [one-apps release](https://github.com/OpenNebula/one-apps/releases/latest)

More information: [one-apps wiki](https://github.com/OpenNebula/one-apps/wiki)

### Open Cloud Networking Infrastructure

| Component           | Version                                    | More information                                                                                                                             |
|---------------------|--------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| 8021q kernel module | Version included in the Linux distribution | [802.1Q VLAN]({{% relref "../../../configuration_and_operation/cloud_clusters_infrastructure_configuration/networking_system_configuration/vlan#hm-vlan" %}})             |
| Open vSwitch        | Version included in the Linux distribution | [Open vSwitch]({{% relref "../../../configuration_and_operation/cloud_clusters_infrastructure_configuration/networking_system_configuration/openvswitch#openvswitch" %}}) |
| iproute2            | Version included in the Linux distribution | [VXLAN]({{% relref "../../../configuration_and_operation/cloud_clusters_infrastructure_configuration/networking_system_configuration/vxlan#vxlan" %}})                    |

### Open Cloud Storage Infrastructure

| Component   | Version                                    | More information                                                                                                                         |
|-------------|--------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------|
| iSCSI       | Version included in the Linux distribution | [LVM Drivers]({{% relref "../../../configuration_and_operation/cloud_clusters_infrastructure_configuration/storage_system_configuration/lvm_drivers#lvm-drivers" %}}) |
| LVM2        | Version included in the Linux distribution | [LVM Drivers]({{% relref "../../../configuration_and_operation/cloud_clusters_infrastructure_configuration/storage_system_configuration/lvm_drivers#lvm-drivers" %}}) |
| Ceph        | Quincy v17.2.x<br/>Reef   v18.2.x          | [The Ceph Datastore]({{% relref "../../../configuration_and_operation/cloud_clusters_infrastructure_configuration/storage_system_configuration/ceph_ds#ceph-ds" %}})  |

### Authentication

| Component             | Version                                    | More information                                                                                                        |
|-----------------------|--------------------------------------------|-------------------------------------------------------------------------------------------------------------------------|
| net-ldap ruby library | 0.12.1 or 0.16.1                           | [LDAP Authentication]({{% relref "../../../configuration_and_operation/cloud_system_administration/authentication_configuration/ldap#ldap" %}})      |
| openssl               | Version included in the Linux distribution | [x509 Authentication]({{% relref "../../../configuration_and_operation/cloud_system_administration/authentication_configuration/x509#x509-auth" %}}) |

### Sunstone

| Browser   | Version     |
|-----------|-------------|
| Chrome    | 61.0 - 94.0 |
| Firefox   | 59.0 - 92.0 |

{{< alert title="Note" color="success" >}}
For Windows desktops using **Chrome** or **Firefox** you should disable the option `touch-events` for your browser:{{< /alert >}} 

**Chrome**: chrome://flags -> #touch-events: disabled.
**Firefox**: `about:config` -> dom.w3c_touch_events: disabled.

<a id="edge-cluster-provision-workloads-compatibility"></a>

## Compatibility of Workloads on Certified Edge Clusters

Edge Clusters can be *virtual* or *metal* depending of the instance type used to build the cluster. Note that not all providers offer both instance types.

{{< alert title="Important" color="success" >}}
Providers based on *virtual* instances have been disabled by default.{{< /alert >}} 

| Edge/Cloud Provider                                                                                                                  | Edge Cluster   | Hypervisor   |
|--------------------------------------------------------------------------------------------------------------------------------------|----------------|--------------|
| [Equinix]({{% relref "../../../hybrid_cloud/automated_hybrid_cluster_provisioning/edge_cluster_provisions/equinix_cluster#equinix-cluster" %}}) | metal          | KVM and LXC  |
| [AWS]({{% relref "../../../hybrid_cloud/automated_hybrid_cluster_provisioning/edge_cluster_provisions/aws_cluster#aws-cluster" %}})             | metal          | KVM and LXC  |
| [On-prem]({{% relref "../../../hybrid_cloud/automated_hybrid_cluster_provisioning/edge_cluster_provisions/onprem_cluster#onprem-cluster" %}})   | metal          | KVM and LXC  |

The Edge Cluster type determines the hypervisor and workload that can be run in the cluster. The following table summarizes the Edge Cluster you need to run specific workloads:

| Use Case                                                                                                                                                                                             | Edge Cluster   | Hypervisor   |
|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------|--------------|
| [I want to run virtual servers…]({{% relref "../../../quick_start/try_opennebula_with_minione/opennebula_evaluation_environment/running_virtual_machines#running-virtual-machines" %}})            | metal          | KVM, LXC     |
| [I want to run a Kubernetes cluster…]({{% relref "../../../quick_start/try_opennebula_with_minione/opennebula_evaluation_environment/running_kubernetes_clusters#running-kubernetes-clusters" %}}) | metal          | KVM          |

## Certified Infrastructure Scale

A single instance of OpenNebula (i.e., a single `oned` process) has been stress-tested to cope with 500 hypervisors without performance degradation. This is the maximum recommended configuration for a single instance, and depending on the underlying configuration of storage and networking, it is mainly recommended to switch to a federated scenario for any larger number of hypervisors.

However, there are several OpenNebula users managing significantly higher numbers of hypervisors (to the order of two thousand) with a single instance. This largely depends, as mentioned, on the storage, networking, and also monitoring configuration.

## Front-End Platform Notes

The following applies to all Front-Ends:

* XML-RPC tuning parameters (`MAX_CONN`, `MAX_CONN_BACKLOG`, `KEEPALIVE_TIMEOUT`, `KEEPALIVE_MAX_CONN` and `TIMEOUT`) are only available with packages distributed by us, as they are compiled with a newer xmlrpc-c library.
* Only **Ruby versions >= 2.0 are supported**.

## Nodes Platform Notes

The following items apply to all distributions:

* Since OpenNebula 4.14 there is a new monitoring probe that gets information about PCI devices. By default it retrieves all the PCI devices in a Host. To limit the PCI devices for which it gets info and appear in `onehost show`, refer to [PCI Passthrough]({{% relref "../../../configuration_and_operation/cloud_clusters_infrastructure_configuration/hosts_and_clusters_configuration/pci_passthrough#kvm-pci-passthrough" %}}).
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

### vCenter 7.0 Platform Notes

{{< alert title="Important" color="success" >}}
The legacy vCenter driver is currently included in the distribution, but no longer receives updates or bug fixes.{{< /alert >}} 

#### Problem with Boot Order

Currently in vCenter 7.0 changing the boot order is only supported in Virtual Machines at deployment time.

### Debian 10 and Ubuntu 18 Upgrade

When upgrading your nodes from Debian 10 or Ubuntu 18 you may need to update the opennebula sudoers file because of the  */usr merge* feature implemented for Debian11/Ubuntu20. You can [find more information and a recommended work around in this issue](https://github.com/OpenNebula/one/issues/6090).
