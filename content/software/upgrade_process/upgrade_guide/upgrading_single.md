---
title: "Upgrading Single Front-End"
date: "2025-02-17"
description:
categories:
pageintoc: "259"
tags:
weight: "3"
---

<a id="upgrade-single"></a>

<!--# Upgrading Single Front-end Deployments -->

{{< alert title="Important" color="success" >}}
Users of the Community Edition of OpenNebula can upgrade from the previous stable version if they are running a non-commercial OpenNebula cloud. In order to access the migrator package a request needs to be made through this [online form](https://opennebula.io/get-migration). In order to use these non-commercial migrators to upgrade to the latest CE release (OpenNebula 6.8.0), you will need to upgrade your existing OpenNebula environment first to CE Patch Release 6.6.0.1{{< /alert >}} 

{{< alert title="Important" color="success" >}}
If you haven’t done so, please enable the [OpenNebula and needed 3rd party repositories]({{% relref "front_end_installation#setup-opennebula-repos" %}}) before attempting the upgrade process.{{< /alert >}} 

## Upgrading from 6.x and higher

### Step 1. Check Virtual Machine Status

Before proceeding, make sure you don’t have any VMs in a transient state (prolog, migrate, epilog, save). Wait until these VMs get to a final state (running, suspended, stopped, done). Check the [Managing Virtual Machines guide]({{% relref "../../../product/virtual_machines_operation/virtual_machine_instances/vm_instances#vm-guide-2" %}}) for more information on the VM life-cycle.

### Step 2. Set All Hosts to Disable Mode

Set all Hosts to disable mode to stop all monitoring processes.

```default
$ onehost disable <host_id>
```

### Step 3. Stop OpenNebula

Stop OpenNebula and any other related services you may have running: OneFlow, OneGate & FireEdge. It’s preferable to use the system tools, like `systemctl` or `service` as `root` in order to stop the services.

{{< alert title="Important" color="success" >}}
If you are running FireEdge service behind Apache/Nginx, please stop also the Apache/Nginx service.{{< /alert >}} 

{{< alert title="Warning" color="warning" >}}
Make sure that every OpenNebula process is stopped. The output of `systemctl list-units | grep opennebula` should be empty.{{< /alert >}} 

### Step 4. Back-up OpenNebula Configuration

Back-up the configuration files located in `/etc/one` and `/var/lib/one/remotes/etc`. You don’t need to do a manual backup of your database; the `onedb` command will perform one automatically.

```default
$ cp -ra /etc/one /etc/one.$(date +'%Y-%m-%d')
$ cp -ra /var/lib/one/remotes/etc /var/lib/one/remotes/etc.$(date +'%Y-%m-%d')
$ onedb backup
```

### Step 5. Upgrade OpenNebula Packages Repository

In order to be able to retrieve the packages for the latest version, you need to update the OpenNebula packages repository. The instructions for doing this are detailed [here]({{% relref "opennebula_repository_configuration#repositories" %}}).

### Step 6. Upgrade to the New Version

Ubuntu/Debian

```default
$ apt-get update
$ apt-get install --only-upgrade opennebula opennebula-gate opennebula-flow opennebula-provision opennebula-fireedge python3-pyone
```

RHEL

```default
$ yum upgrade opennebula opennebula-gate opennebula-flow opennebula-provision opennebula-fireedge python3-pyone
```

#### Community Edition

If upgrading OpenNebula CE, you will need to install the `opennebula-migration-community` package on your Front-end.

If you are upgrading to the *latest* version, you will need to download the package from the [Get Migration Packages](https://opennebula.io/get-migration) page.

If you are upgrading to any prior version (such as upgrading from 6.6 to 6.8), then the migration package is already included in the OpenNebula repositories.

To install the migration package:

On RHEL:

```default
$ rpm -i opennebula-migration-community*.rpm
```

On Debian/Ubuntu:

```default
$ dpkg -i opennebula-migration-community*.deb
```

{{< alert title="Note" color="success" >}}
Before downloading the migration package, it’s a good idea to double-check the URL in your software repository file. Ensure that the URL includes the software major and minor version (in `<major>.<minor>` format), but not the exact release.

For example, for OpenNebula version 6.8, the file should point to `https://downloads.opennebula.io/repo/6.8` and not `https://downloads.opennebula.io/repo/6.8.0`. The first case will include migration packages for 6.8.\*, whereas the second case will exclude minor versions such as 6.8.0.1.{{< /alert >}}  

### Step 7. Update Configuration Files

In HA setups it is necessary to replace in the file `/etc/one/monitord.conf` the default value `auto` of `MONITOR_ADDRESS` attributed to the virtual IP address used in RAFT_LEADER_HOOK and RAFT_FOLLOWER_HOOK in `/etc/one/oned.conf`.

#### Community Edition

In order to update the configuration files with your existing customizations you’ll need to:

- Compare the old and new configuration files: `diff -ur /etc/one.YYYY-MM-DD /etc/one` and `diff -ur /var/lib/one/remotes/etc.YYYY-MM-DD /var/lib/one/remotes/etc`. You can use graphical diff-tools like `meld` to compare both directories; they are very useful in this step.
- Edit the **new** files and port all the customizations from the previous version.

#### Enterprise Edition

If you have modified configuration files, let’s use `onecfg` to automate the configuration file upgrades.

Before upgrading OpenNebula, you need to ensure that the configuration state is clean without any pending migrations from past or outdated configurations. Run `onecfg status` to check the configuration state.

A clean state might look like this:

```default
$ onecfg status
--- Versions ------------------------------
OpenNebula:  6.8.3
Config:      6.8.0

--- Available Configuration Updates -------
No updates available.
```

#### Unknown Configuration Version Error

If you get error message about an unknown configuration version, you don’t need to do anything. The configuration version will be automatically initialized during the OpenNebula upgrade. The configuration of the current version will be based on the former OpenNebula version.

```default
$ onecfg status
--- Versions ------------------------------
OpenNebula:  6.8.3
Config:      unknown
ERROR: Unknown config version
```

#### Configuration Metadata Outdated Error

If the configuration tool complains about outdated metadata, you have not run a configuration upgrade during some of the past OpenNebula upgrades. Please note, configuration must be upgraded or processed with even OpenNebula’s maintenance releases.

The following invalid state:

```default
$ onecfg status
--- Versions ------------------------------
OpenNebula:  6.8.3
Config:      6.8.0
ERROR: Configurations metadata are outdated.
```

needs to be fixed by reinitialization of the configuration state. Any unprocessed upgrades will be lost and the current state will be initialized based on your current OpenNebula version and configurations located in system directories.

```default
$ onecfg init --force
$ onecfg status
--- Versions ------------------------------
OpenNebula:  6.8.3
Config:      6.8.3

--- Available Configuration Updates -------
No updates available.
```

After checking the state of configuration, in most cases running the following command without any extra parameters will suffice, as it will upgrade the probes based on the internal configuration version tracking of the currently installed OpenNebula.

```default
$ onecfg upgrade
ANY   : Backup stored in '/tmp/onescape/backups/2020-6...
ANY   : Configuration updated to 6.2.1
```

If you get conflicts when running `onecfg` upgrade refer to the [onecfg upgrade basic usage documentation]({{% relref "../configuration_management_ee/usage#cfg-usage" %}}) on how to upgrade and troubleshoot the configurations, in particular the [onecfg upgrade doc]({{% relref "../configuration_management_ee/usage#cfg-upgrade" %}}) and the [troubleshooting section]({{% relref "../configuration_management_ee/conflicts#cfg-conflicts" %}}).

### Step 8. Upgrade the Database Version

{{< alert title="Important" color="success" >}}
Users of the Community Edition of OpenNebula can upgrade from the previous stable version if they are running a non-commercial OpenNebula cloud. In order to access the migrator package a request needs to be made through this [online form](https://opennebula.io/get-migration).{{< /alert >}} 

Make sure at this point that OpenNebula is not running. If you installed from packages, the service may have been started automatically. Simply run the `onedb upgrade -v` command. The connection parameters are automatically retrieved from `/etc/one/oned.conf`.

### Step 9. Check DB Consistency

First, move the {{< version >}} backup file created by the upgrade command to a safe place. If you face any issues, the `onedb` command can restore this backup, but it won’t downgrade databases to previous versions. Then, execute the `onedb fsck` command:

```default
$ onedb fsck
MySQL dump stored in /var/lib/one/mysql_localhost_opennebula.sql
Use 'onedb restore' or restore the DB using the mysql command:
mysql -u user -h server -P port db_name < backup_file

Total errors found: 0
```

### Step 10. Start OpenNebula

Start OpenNebula and any other related services: OneFlow, OneGate & FireEdge. It’s preferable to use the system tools, like `systemctl` or `service` as `root` in order to stop the services.

{{< alert title="Important" color="success" >}}
If you are running FireEdge service behind Apache/Nginx, please start also the Apache/Nginx service.{{< /alert >}} 

### Step 11. Restore Custom Probes

If you have any custom monitoring probes, follow [these instructions]({{% relref "../../../product/integration_references/infrastructure_drivers_development/devel-im#devel-im" %}}), to update them to the new monitoring system

### Step 12. Update the Hypervisors

{{< alert title="Warning" color="warning" >}}
The hypervisor node operating system must meet the minimum version required according to the [KVM]({{% relref "../../release_information/release_notes_70/platform_notes.md#platform-notes-kvm" %}}) or [LXC]({{% relref "../../release_information/release_notes_70/platform_notes#platform-notes-lxc" %}}) platform notes. Running a frontend node with a newer OpenNebula version controlling hypervisor nodes running in old unsupported platforms, like CentOS 7, can result in a myriad of dependency problems. A very common issue is the old ruby version shipped in CentOS 7 not being able to run the newer driver code.{{< /alert >}}

Update the virtualization, storage and networking drivers.  As the `oneadmin` user, execute:

```default
$ onehost sync
```

Then log in to your hypervisor Hosts and update the `opennebula-node` packages:

Ubuntu/Debian

```default
$ apt-get install --only-upgrade opennebula-node-<hypervisor>
```

RHEL

```default
$ yum upgrade opennebula-node-<hypervisor>
```

{{< alert title="Note" color="success" >}}
Note that the `<hypervisor>` tag should be replaced by the name of the corresponding hypervisor (i.e `kvm` or `lxc`).{{< /alert >}} 

{{< alert title="Important" color="success" >}}
For KVM hypervisor it’s necessary to restart also the libvirt service{{< /alert >}} 

### Step 13. Enable Hosts

Enable all Hosts, disabled in step 2:

```default
$ onehost enable <host_id>
```

If upgrading from a version earlier than 6.0, please see [Upgrading from Previous Versions]({{% relref "upgrade_from_previous_versions#upgrade-from-previous" %}}).

### Testing

OpenNebula will continue the monitoring and management of your previous Hosts and VMs.

As a measure of caution, look for any error messages in `oned.log`, and check that all drivers are loaded successfully. You may also try some  **show** subcommand for some resources to check everything is working (e.g. `onehost show`, or `onevm show`).

### Restoring the Previous Version

If for any reason you need to restore your previous OpenNebula, simply uninstall OpenNebula {{< version >}}, and install again your previous version. After that, update the drivers if needed, as outlined in Step 12.
