---
title: "Overview"

description:
categories:
pageintoc: ""
tags:
weight: "1"
---

<a id="monitor-alert-overview"></a>

<a id="monitoring-alerting"></a>

<!--# Monitoring and Alerting -->

This chapter provides documentation on how different resources are monitored in OpenNebula. There are two primary monitoring mechanisms:

- **OpenNebula Built-in Monitoring**: This system provides essential information about hosts and virtual machines, which is utilized for managing the life cycle of each resource.
- **Integration with Prometheus**: OpenNebula can be integrated with the [Prometheus monitoring and alerting toolkit](http://prometheus.io) to enable seamless data center monitoring.

## How to Use This Chapter

Before proceeding with this chapter, ensure you have already installed your [Front-end]({{% relref "../../../software/installation/front_end_installation#frontend-installation" %}}), configured [KVM Hosts]({{% relref "../../../software/installation/kvm_node_installation#kvm-node" %}}), and set up an OpenNebula cloud with at least one virtualization node.

This chapter is organized as follows:

- The [OpenNebula Monitoring guide]({{% relref "configuration#monitor-alert-configuration" %}}) covers the setup and operation of the built-in monitoring system.
- The [Resource Monitoring guide]({{% relref "metrics#monitor-alert-resource" %}}) outlines the metrics collected for each resource type.
- The [Resource Forecasting guide]({{% relref "forecast#monitor-alert-forecast" %}}) explains how to configure the monitoring system to generate resource usage forecasts.
- Lastly, the [Prometheus Integration Guide]({{% relref "../prometheus/overview#monitor-alert-prom-overview" %}}) provides instructions for setting up Prometheus to monitor your OpenNebula cloud.

## Hypervisor Compatibility

The monitoring and alerting features described in this guide are compatible with the KVM hypervisor.
