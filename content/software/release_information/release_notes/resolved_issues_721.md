---
title: "Resolved Issues in 7.2.1"
date: "2026-03-31"
---

A complete list of solved issues for 7.2.1 are listed in the [project development portal](https://github.com/OpenNebula/one/milestone/88).

## Backported Issues

The following new features have been backported to 7.2.1:

* Add option [`LOG_RESULT_LENGTH` to `oned.conf`]({{% relref "/product/operation_references/opennebula_services_configuration/oned#xml-rpc-server-configuration" %}}) to configure max length of API result log.
* Add per-VM live migration options through [`MIGRATE_AUTO_CONVERGE` and `MIGRATE_COMPRESSED`]({{% relref "/product/operation_references/configuration_references/template#template-features" %}}) VM template attributes. Administrators can now tune auto-convergence and memory compression only for selected KVM VMs, improving migration reliability and bandwidth usage without changing global driver defaults.
* [Allow the customization of the favicon in FireEdge]({{% relref "product/operation_references/opennebula_services_configuration/fireedge.md#branding-fireedge" %}}).
* Add optional Prometheus exporter packages for OVS, MySQL/MariaDB, SMART storage health, and LVM monitoring. See [Optional Exporters]({{% relref "/product/cloud_system_administration/prometheus/install#monitor-alert-extra-exporters" %}}) for installation and service details.
* VLAN_ID is not mandatory when creating a OpenvSwitch in Sunstone. See [Open vSwitch Networks]({{% relref "product/cluster_configuration/networking_system/openvswitch/" %}}) for details.
* Improved Open vSwitch VLAN trunking support in the `ovswitch` driver by adding native OVS `trunk` mode when only `VLAN_TAGGED_ID` is defined. Existing configurations using `VLAN_ID` continue to behave as before. Note that untagged traffic is now dropped for pure trunk configurations. See [Multiple VLANs (VLAN trunking)](/product/cluster_configuration/networking_system/openvswitch/#multiple-vlans-vlan-trunking) for details.
* [PCI device monitoring now includes `IFNAME`, `SRIOV` and `SRIOV_NUM` attributes]({{% relref "product/cluster_configuration/hosts_and_clusters/hosts#host-pci-devices" %}}) to map PCI devices to network interface names and identify SR-IOV Physical/Virtual Functions.
* Moved Open vSwitch DPDK socket directory to `/var/run/one/vhost-socks` [#7673](https://github.com/OpenNebula/one/issues/7673)

## Resolved Issues

The following issues have been solved in 7.2.1:

* Fix a `onehem-server` crash caused by a race condition between hook delete and update API calls [#7561](https://github.com/OpenNebula/one-ee/pull/7561).
* Fix a  empty `--resource` for `onegroup create` CLI command [#7458](https://github.com/OpenNebula/one/issues/7458).
* Fix race condition in `oneflow` server in cancel actions [#7570](https://github.com/OpenNebula/one/issues/7570).
* Fix S3 marketplace `SIGNATURE_VERSION` parameter hardcoded to `s3` version [7437](https://github.com/OpenNebula/one/issues/7437).
* Fix race condition in `oneflow` server in cancel actions [#7570](https://github.com/OpenNebula/one/issues/7570)
* Fix usage of network lease in case of VM deploy failure [#7349](https://github.com/OpenNebula/one/issues/7349)
* Fix authentication drivers for users with empty password [#7606](https://github.com/OpenNebula/one/issues/7606)
* Fix standalone installation of Ruby gem openebula-cli [#7608](https://github.com/OpenNebula/one/issues/7608)
* Fix Ceph monitoring to reflect actual disk usage in RBD [#7185](https://github.com/OpenNebula/one/issues/7185).
* Fix auto focus VNC window when typing [#7553](https://github.com/OpenNebula/one/issues/7553).
* Fix translations in other languages [#7365](https://github.com/OpenNebula/one/issues/7365).
* Fix empty `PROBES_PERIOD` values causing monitor probes to run without delay [#7659](https://github.com/OpenNebula/one/issues/7659).
* Fix an issue that could cause VLAN trunk information in Virtual Networks to become inconsistent after updating network attributes, resulting in incorrect `VLAN_TAGGED_ID` values being propagated to VM NICs. [#7654](https://github.com/OpenNebula/one/issues/7654).
* Fix pure LVM live migration when VM has no CONTEXT [#7674](https://github.com/OpenNebula/one/issues/7674).
* Fix Restic exclusive lock detection [#7403](https://github.com/OpenNebula/one/issues/7403) + [#7404](https://github.com/OpenNebula/one/issues/7404).
* Fix CEPH RBD incremental backup deadlocks [#7529](https://github.com/OpenNebula/one/issues/7529)
