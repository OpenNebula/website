---
title: "Resolved Issues in 7.2.2 (EE)"
date: "2026-01-01"
---

A complete list of solved issues for 7.2.2 are listed in the [project development portal](https://github.com/OpenNebula/one/milestone/93).

## Elastic Kubernetes as a Service
[OneKS]({{% relref "platform_services/oneks/getting_started/overview/" %}}) is a new OpenNebula service that streamlines and simplifies the provisioning and operation of Kubernetes Clusters on OpenNebula cloud deployments. OneKS builds on CAPONE to expose a Cluster-centric lifecycle model for users needing a simple and repeatable way to consume Kubernetes inside OpenNebula.

## Backported Issues

The following new features have been backported to 7.2.2:

<!-- item structure
Include a high level description and a link to the documentation explaining the new feature. Example:

* Add per-VM live migration options through [`MIGRATE_AUTO_CONVERGE` and `MIGRATE_COMPRESSED`]({{% relref "/product/operation_references/configuration_references/template#template-features" %}}) VM template attributes. Administrators can now tune auto-convergence and memory compression only for selected KVM VMs, improving migration reliability and bandwidth usage without changing global driver defaults.

-->

## Resolved Issues

The following issues have been solved in 7.2.2:

* Fix `oneswap` vmware tools removal from a Windows Server 2025 [#814](https://github.com/OpenNebula/engineering/issues/814).
* Fix `oneswap` compatibility with vCenter 8.0.3 [7698](https://github.com/OpenNebula/one/issues/7698)
* `oneswap` Add Windows OS Profile/Best practices VM template options to oneswap Windows conversion [7351](https://github.com/OpenNebula/one/issues/7351).

<!-- item structure
One line per issue starting with "Fix ...". Descrive the issue so the user understands the fix. Add link to GH. Example:

* Fix failure of `onegroup create` CLI command with empty `--resource` parameter [#7458](https://github.com/OpenNebula/one/issues/7458).
-->

