---
title: "Resolved Issues in 7.2.2 (EE)"
date: "2026-01-01"
---

A complete list of solved issues for 7.2.2 are listed in the [project development portal](https://github.com/OpenNebula/one/milestone/93).

## Backported Issues

The following new features have been backported to 7.2.2:

* Add Windows OS Profile/Best practices VM template options to `oneswap` Windows conversion [7351](https://github.com/OpenNebula/one/issues/7351).
* Support for SR-IOV capable network interfaces in [switchdev mode]({{% relref "product/cluster_configuration/hosts_and_clusters/pci_passthrough.md#usage-as-network-interfaces" %}}).

<!-- item structure
Include a high level description and a link to the documentation explaining the new feature. Example:

* Add per-VM live migration options through [`MIGRATE_AUTO_CONVERGE` and `MIGRATE_COMPRESSED`]({{% relref "/product/operation_references/configuration_references/template#template-features" %}}) VM template attributes. Administrators can now tune auto-convergence and memory compression only for selected KVM VMs, improving migration reliability and bandwidth usage without changing global driver defaults.
-->

## Resolved Issues

The following issues have been solved in 7.2.2:

* Fix `oneswap` vmware tools removal from a Windows Server 2025 [#814](https://github.com/OpenNebula/engineering/issues/814).
* Fix `oneswap` compatibility with vCenter 8.0.3 [7698](https://github.com/OpenNebula/one/issues/7698)
* `oneswap` Add Windows OS Profile/Best practices VM template options to oneswap Windows conversion [7351](https://github.com/OpenNebula/one/issues/7351).
* Fix `opennebula-exporter` crash when monitoring diskless VMs [7703](https://github.com/OpenNebula/one/issues/7703).
* Fix PCI attach to prevent bus address collisions [#7695](https://github.com/OpenNebula/one/issues/7695)
* Fix lack of VLAN tags clearance in OVS when removing them from virtual network [#7707](https://github.com/OpenNebula/one/issues/7707)
* Fix OneKS lifecycle operations after renaming a cluster by using stable Kubernetes identifiers [#7724](https://github.com/OpenNebula/one/issues/7724).
* `oneswap` Add support for batch VM conversion [#7726](https://github.com/OpenNebula/one/issues/7726)
* Fix LVM (EE) post-reboot activation silently skipping VM disks [#7720](https://github.com/OpenNebula/one/issues/7720).

<!-- item structure
One line per issue starting with "Fix ...". Descrive the issue so the user understands the fix. Add link to GH. Example:

* Fix failure of `onegroup create` CLI command with empty `--resource` parameter [#7458](https://github.com/OpenNebula/one/issues/7458).
-->

