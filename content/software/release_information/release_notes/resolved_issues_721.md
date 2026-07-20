---
title: "Resolved Issues in 7.2.1 (EE)"
date: "2026-03-31"
---

A complete list of solved issues for 7.2.1 are listed in the [project development portal](https://github.com/OpenNebula/one/milestone/88).

## Elastic Kubernetes as a Service
[OneKS]({{% relref "platform_services/oneks/getting_started/overview/" %}}) is a new OpenNebula service that streamlines and simplifies the provisioning and operation of Kubernetes Clusters on OpenNebula cloud deployments. OneKS builds on CAPONE to expose a Cluster-centric lifecycle model for users needing a simple and repeatable way to consume Kubernetes inside OpenNebula.

## Backported Issues

The following new features have been backported to 7.2.1:

* Add option [`LOG_RESULT_LENGTH` to `oned.conf`]({{% relref "/product/operation_references/opennebula_services_configuration/oned#xml-rpc-server-configuration" %}}). This option enables capping of the log size to keep logs lean and save space.
* Add per-VM live migration options through [`MIGRATE_AUTO_CONVERGE` and `MIGRATE_COMPRESSED`]({{% relref "/product/operation_references/configuration_references/template#template-features" %}}) VM template attributes. Administrators can now tune auto-convergence and memory compression only for selected KVM VMs, improving migration reliability and bandwidth usage without changing global driver defaults.
* Add [custom favicon option in FireEdge]({{% relref "product/operation_references/opennebula_services_configuration/fireedge.md#branding-fireedge" %}}) for applying custom brands and logos to the Sunstone web UI.
* Add optional Prometheus exporter packages for OVS, MySQL/MariaDB, SMART storage health, and LVM monitoring for improved observability. See [Optional Exporters]({{% relref "/product/cloud_system_administration/prometheus/install#monitor-alert-extra-exporters" %}}) for installation and service details.
* VLAN_ID is not mandatory when creating a Open vSwitch in Sunstone to allow more flexibility in network configurations. See [Open vSwitch Networks]({{% relref "product/cluster_configuration/networking_system/openvswitch/" %}}) for details.
* Improve Open vSwitch VLAN trunking support in the `ovswitch` driver by adding native OVS `trunk` mode when only `VLAN_TAGGED_ID` is defined. Existing configurations using `VLAN_ID` continue to behave as before. Note that untagged traffic is now dropped for pure trunk configurations. See [Multiple VLANs (VLAN trunking)](/product/cluster_configuration/networking_system/openvswitch/#multiple-vlans-vlan-trunking) for details.
* [PCI device monitoring now includes `IFNAME`, `SRIOV` and `SRIOV_NUM` attributes]({{% relref "product/cluster_configuration/hosts_and_clusters/hosts#host-pci-devices" %}}) to map PCI devices to network interface names and identify SR-IOV Physical/Virtual Functions.
* [Move Open vSwitch DPDK socket directory](https://github.com/OpenNebula/one/issues/7673) to `/var/run/one/vhost-socks`.
* Add [Elastic Kubernetes as a Service with OneKS]({{% relref "platform_services/oneks/getting_started/overview/" %}}) for streamlined Kubernetes Cluster deployment.
* Fix various logrotate issues [#7646](https://github.com/OpenNebula/one/issues/7646).

## Resolved Issues

The following issues have been solved in 7.2.1:

* Fix `onehem-server` crash caused by a race condition between hook delete and update API calls [#7561](https://github.com/OpenNebula/one/issues/7561).
* Fix failure of `onegroup create` CLI command with empty `--resource` parameter [#7458](https://github.com/OpenNebula/one/issues/7458).
* Fix race condition in `oneflow` server when using `oneflow recover --delete` operation [#7570](https://github.com/OpenNebula/one/issues/7570).
* Fix S3 marketplace `SIGNATURE_VERSION` modification - parameter now hardcoded to `s3` version [#7437](https://github.com/OpenNebula/one/issues/7437).
* Fix failure to release network leases after VM deployment failure [#7349](https://github.com/OpenNebula/one/issues/7349).
* Fix failure of authentication drivers for users with empty password [#7606](https://github.com/OpenNebula/one/issues/7606).
* Fix unexpected behavior of standalone Ruby gem installation of openebula-cli [#7608](https://github.com/OpenNebula/one/issues/7608).
* Fix Ceph monitoring to reflect real disk usage in RBD [#7185](https://github.com/OpenNebula/one/issues/7185).
* Fix need to click VNC content frame to focus/enable window when typing [#7553](https://github.com/OpenNebula/one/issues/7553).
* Fix lack of translation of VM status hover widgets in Sunstone [#7365](https://github.com/OpenNebula/one/issues/7365).
* Fix monitoring errors and offline hosts when `PROBES_PERIOD` fields are empty in `/etc/one/monitord.conf` [#7659](https://github.com/OpenNebula/one/issues/7659).
* Fix an issue that causes VLAN trunk information in Virtual Networks to become inconsistent after updating network attributes, resulting in incorrect `VLAN_TAGGED_ID` values being propagated to VM NICs [#7654](https://github.com/OpenNebula/one/issues/7654).
* Fix pure LVM live migration failuer when VM has no CONTEXT defined [#7674](https://github.com/OpenNebula/one/issues/7674).
* Fix failure of Restic error handling with an exclusively locked repositories [#7403](https://github.com/OpenNebula/one/issues/7403) + [#7404](https://github.com/OpenNebula/one/issues/7404).
* Fix Ceph RBD incremental backup deadlocks when kernel pipe buffer is filled [#7529](https://github.com/OpenNebula/one/issues/7529).
* Fix improper `USER_INPUT` variable expansion in `SCHED_REQUIREMENTS` when instantiating via FireEdge [#7491](https://github.com/OpenNebula/one/issues/7491).
* Fix lack of `fireedge.error` in logrotate [#7621](https://github.com/OpenNebula/one/issues/7621).
* Fix Sunstone bug where Users/Groups are not shown from a non-master zone in a federation [#7617](https://github.com/OpenNebula/one/issues/7617).
* Fix Fireedge bug when missing a SAML key in the auth handler [#7601](https://github.com/OpenNebula/one/issues/7601).
* Fix Sunstone bug where view is not refreshed when changing group or zone [#7554](https://github.com/OpenNebula/one/issues/7554).
* Fix `oneswap` bug when NIC is not attached to template even if specified in YAML file [#7526](https://github.com/OpenNebula/one/issues/7526).
* Fix `oneswap` bug when Cluster name contains spaces [#7525](https://github.com/OpenNebula/one/issues/7525).
* Fix `onevm deploy` failure when 802.1Q driver is used but PHYDEV element in the template is an empty string [#7432](https://github.com/OpenNebula/one/issues/7432).
* Fix VRouter leaking network leases. Leases are no longer left orphaned after `onevrouter delete` operation [#7699](https://github.com/OpenNebula/one/issues/7699).
* Fix LVM (EE) crash during FT mode recovery [#7739](https://github.com/OpenNebula/one/issues/7739).
