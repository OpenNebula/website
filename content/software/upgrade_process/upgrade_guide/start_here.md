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

This guide describes the upgrade procedure for systems that are already running an OpenNebula Enterprise Edition 6.0.x or newer. The upgrade to OpenNebula EE {{< version >}} can be done directly by following this section; you don’t need to perform intermediate version upgrades (for CE deployments, please see the Important Note below). The upgrade will preserve all current users, Hosts, resources, and configurations, for both SQLite and MySQL/MariaDB backends.

Read the [Compatibility Guide]({{% relref "../../release_information/release_notes_70/compatibility#compatibility" %}}) and [Release Notes]({{% relref "release_notes_70" %}}) to learn what's new in OpenNebula {{< version >}}.

{{< alert title="Important" color="success" >}}
Users of the Community Edition of OpenNebula can upgrade to the latest version only if they are running a non-commercial deployment, but they will need to upgrade first to the previous stable version. In order to access the latest migrator package, a request needs to be submitted through this [online form](https://opennebula.io/get-migration).{{< /alert >}} 

## Previous Steps

### Enterprise Edition

Enterprise Edition is distributed with a tool `onecfg` as part of the main server package (in 5.12 and earlier it was provided via the OneScape project and repository). This tool simplifies the upgrade process of configuration files and always comes in the latest version of OpenNebula.

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

Follow [onecfg upgrade]({{% relref "../configuration_management_ee/usage#cfg-upgrade" %}}) documentation for information on how to upgrade and troubleshoot the configurations.

<a id="validate-upgrade"></a>

## Validate OpenNebula

When all steps are done, run OpenNebula and check the working state.

Check the configuration state via `onecfg status`. There should be no errors and no new updates available. Your configuration should be up to date for the currently installed OpenNebula version. For example:

```default
$ onecfg status
--- Versions ------------------------------
OpenNebula:  6.10.2
Config:      6.10.0

--- Available Configuration Updates -------
No updates available.
```
