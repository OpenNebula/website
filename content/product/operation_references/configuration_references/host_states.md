---
title: "Host States Reference"
date: "2025-02-17"
description:
categories:
pageintoc: "155"
tags:
weight: "7"
---

<a id="host-states"></a>

<!--# Host States Reference -->

This page is a complete reference of all the Host states that will be useful for developers and administrators doing troubleshooting.

The simplified life-cycle is explained in the [Hosts guide]({{% relref "../../cluster_configuration/hosts_and_clusters/hosts#host-lifecycle" %}}). This simplified diagram uses a smaller number of state names. That section should be enough for end users and everyday administration tasks.

## List of States

OpenNebula’s Hosts define their state using the `STATE` variable. The state can be seen from the CLI (`onehost show`) and from Sunstone (Info panel for Hosts).

|   # | State                | Short State Alias   | Meaning                                 |
|-----|----------------------|---------------------|-----------------------------------------|
|   0 | INIT                 | `init`              | Initial state for enabled hosts         |
|   1 | MONITORING_MONITORED | `update`            | Monitoring the host                     |
|   2 | MONITORED            | `on`                | The host has been monitored             |
|   3 | ERROR                | `err`               | An error ocurrer during host monitoring |
|   4 | DISABLED             | `dsbl`              | The host was disabled                   |
|   5 | MONITORING_ERROR     | `retry`             | Monitoring the host (from error)        |
|   6 | MONITORING_INIT      | `init`              | Monitoring the host (from init)         |
|   7 | MONITORING_DISABLED  | `dsbl`              | Monitoring the host (from disabled)     |
|   8 | OFFLINE              | `off`               | The host was set offline                |
