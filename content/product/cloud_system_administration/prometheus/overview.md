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

> - A Libvirt Exporter that provides information about VM (KVM domains) running on an OpenNebula Host.
> - An OpenNebula Exporter that provides basic information about the overall OpenNebula cloud.
> - Alert rules sample files based on the provided metrics.
> - [Grafana](https://grafana.com/) dashboards to visualize VM, Host, and OpenNebula information in a convenient way.

## How Should I Read This Chapter

Before reading this Chapter, you should have already installed your [Front-end]({{% relref "../../../software/installation_process/manual_installation/front_end_installation.md#frontend-installation" %}}) and [KVM Hosts]({{% relref "../../../software/installation_process/manual_installation/front_end_installation.md#kvm-node" %}}), and have an OpenNebula cloud up and running with at least one virtualization node.

This Chapter is structured as follows:

> - The [installation guide]({{% relref "install#monitor-alert-installation" %}}) describes the installation and basic configuration of the integration.
> - How to [visualize monitor data with Grafana]({{% relref "grafana#monitor-alert-grafana" %}}) is explained in a dedicated Section.
> - Specific procedures to [set up alarms]({{% relref "alerts#monitor-alert-alarms" %}}) is also addressed in this Chapter.

Finally, you can find a reference of the [metrics gathered by the exporters here]({{% relref "metrics#monitor-alert-metrics" %}}).

## Hypervisor Compatibility

These guides are compatible with the KVM hypervisor.
