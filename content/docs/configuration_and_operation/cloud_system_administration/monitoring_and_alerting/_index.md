---
title: "Monitoring and Alerting"
date: "2025-02-17"
description:
categories:
pageintoc: "127"
tags:
weight: "3"
---

<!--# Monitoring and Alerting -->

* [Overview]({{% relref "overview" %}})
  * [How Should I Read This Chapter]({{% relref "overview#how-should-i-read-this-chapter" %}})
  * [Hypervisor Compatibility]({{% relref "overview#hypervisor-compatibility" %}})
* [Installation and Configuration]({{% relref "install" %}})
  * [Step 1. OpenNebula Repositories [Front-end, Hosts]]({{% relref "install#step-1-opennebula-repositories-front-end-hosts" %}})
  * [Step 2. Install Front-end Packages [Front-end]]({{% relref "install#step-2-install-front-end-packages-front-end" %}})
  * [Step 3. Install Hosts Packages [Hosts]]({{% relref "install#step-3-install-hosts-packages-hosts" %}})
  * [Step 4. Configure Prometheus [Front-end]]({{% relref "install#step-4-configure-prometheus-front-end" %}})
  * [Step 5. Start the Prometheus Service [Front-end]]({{% relref "install#step-5-start-the-prometheus-service-front-end" %}})
  * [Step 6. Start Node and Libvirt Exporters [Host]]({{% relref "install#step-6-start-node-and-libvirt-exporters-host" %}})
  * [Using an Existing Prometheus Installation]({{% relref "install#using-an-existing-prometheus-installation" %}})
  * [Using Prometheus with OpenNebula in HA]({{% relref "install#using-prometheus-with-opennebula-in-ha" %}})
* [Grafana Visualization]({{% relref "grafana" %}})
  * [Requirements]({{% relref "grafana#requirements" %}})
  * [Grafana Dashboards]({{% relref "grafana#grafana-dashboards" %}})
  * [Grafana Provisioning]({{% relref "grafana#grafana-provisioning" %}})
* [Alert Manager]({{% relref "alerts" %}})
  * [Installation and Configuration]({{% relref "alerts#installation-and-configuration" %}})
  * [Alerts Rules]({{% relref "alerts#alerts-rules" %}})
  * [Setting up Alarms for OpenNebula in HA]({{% relref "alerts#setting-up-alarms-for-opennebula-in-ha" %}})
* [Exporter Metrics]({{% relref "metrics" %}})
  * [OpenNebula Exporter]({{% relref "metrics#opennebula-exporter" %}})
  * [Libvirt Exporter]({{% relref "metrics#libvirt-exporter" %}})
