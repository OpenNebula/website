---
title: "Start Here"
date: "2025-02-17"
description:
categories:
pageintoc: "258"
tags:
weight: "2"
---

<a id="start-here"></a>

<!--# Start Here -->

This guide describes the upgrade procedure for systems that are already running OpenNebula 6.0.x or newer. The upgrade will preserve all current users, hosts, resources, and configurations, for both SQLite and MySQL/MariaDB back-ends.

Read the [Compatibility Guide]({{% relref "../../release_information/release_notes/compatibility#compatibility" %}}) and [Release Notes]({{% relref "release_notes" %}}) to learn what's new in OpenNebula {{< version >}}.

## Previous Steps

OpenNebula 7.0 or newer is distributed with `onecfg` as part of the main server package. This tool simplifies the upgrade process of configuration files, and  is always included in the latest version of OpenNebula.

{{< alert title="Important" color="success" >}}
**For each OpenNebula upgrade (even between minor versions, e.g. 6.10.2 and 6.10.3), configuration files must be processed via `onecfg upgrade`**. If you skip the configuration upgrade step for an OpenNebula upgrade, the tool will lose the current version state and you'll have to handle the files upgrade manually and [reinitialize]({{% relref "../configuration_management_ee/usage" %}}) the configuration version management state.

```default
$ onecfg upgrade
FATAL : FAILED - Configuration can't be processed as it looks outdated!
You must have missed to run 'onecfg update' after previous OpenNebula upgrade.

$ onecfg status
...
ERROR: Configurations metadata are outdated.
```
{{< /alert >}}

<a id="upgrade-guides"></a>

## Upgrade OpenNebula

Update your OpenNebula packages by following only the guide that applies to your current OpenNebula configuration:

- [Upgrading a Single Front-End Deployment]({{% relref "upgrading_single#upgrade-single" %}})
- [Upgrading an HA Cluster]({{% relref "upgrading_ha#upgrade-ha" %}})
- [Upgrading a Federation]({{% relref "upgrading_federation#upgrade-federation" %}})

<a id="validate-upgrade"></a>
