---
title: "Overview"

description:
categories:
pageintoc: ""
tags:
weight: "1"
---

<a id="monitor-alert-prom-overview"></a>

<!--# Monitoring and Alerting -->

This Chapter contains documentation on how to configure OpenNebula to work with the [Prometheus monitoring and alerting toolkit](http://prometheus.io). The integration consists of four components:

> - A **Libvirt Exporter** that provides information about VM (KVM domains) running on an OpenNebula Host.
> - An **OpenNebula Exporter** that provides basic information about the overall OpenNebula cloud.
> - Alert rules sample files based on the provided metrics.
> - [Grafana](https://grafana.com/) dashboards to visualize VM, Host, and OpenNebula information in a convenient way.

Additionally, four **optional** exporter sub-packages are shipped to cover deployment-specific telemetry:

> - **OVS Exporter** for Open vSwitch metrics on Hosts using OVS networking.
> - **MySQL Exporter** for MariaDB/MySQL server metrics on Front-ends using the MySQL backend.
> - **SMART Exporter** for S.M.A.R.T. disk health on Hosts (or any machine with physical disks).
> - **LVM Exporter** for LVM physical-volume / volume-group / logical-volume metrics on Hosts using LVM-backed datastores.

These are *opt-in* — install only the ones relevant to your deployment. Prometheus auto-detects them via TCP probe and adds matching scrape configs the next time `patch_datasources.rb` runs (see the [installation guide]({{% relref "install#monitor-alert-installation" %}})).

## How Should I Read This Chapter

Before reading this Chapter, you should have already installed your [Front-end]({{% relref "software/installation_process/frontend_installation/manual/frontend_install.md#frontend-installation" %}}) and [KVM Hosts]({{% relref "software/installation_process/frontend_installation/manual/frontend_install.md#kvm-node" %}}), and have an OpenNebula cloud up and running with at least one virtualization node.

This Chapter is structured as follows:

> - The [installation guide]({{% relref "install#monitor-alert-installation" %}}) describes the installation and basic configuration of the integration.
> - How to [visualize monitor data with Grafana]({{% relref "grafana#monitor-alert-grafana" %}}) is explained in a dedicated Section.
> - Specific procedures to [set up alarms]({{% relref "alerts#monitor-alert-alarms" %}}) is also addressed in this Chapter.

Finally, you can find a reference of the [metrics gathered by the exporters here]({{% relref "metrics#monitor-alert-metrics" %}}).

## Hypervisor Compatibility

These guides are compatible with the KVM hypervisor.
