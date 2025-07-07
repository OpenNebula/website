---
title: "Overview"
date: "2025-02-17"
description:
categories:
pageintoc: "251"
tags:
weight: "1"
---

<a id="cfg-overview"></a>

<!--# Overview -->

OpenNebula has tens of configuration files, where cloud administrators can fine-tune the behavior of their cloud environment. When carrying out an upgrade to a newer minor OpenNebula version (`X.Y`), unfortunately all custom changes in configuration files must be migrated to new configuration files. OpenNebula includes a dedicated tool (`onecfg`) which automates and simplifies the upgrade of configuration files.

This Chapter describes how to use the configuration management tool to:

- Upgrade your configuration files for the new OpenNebula version.
- Check the version status of the current installation.
- Identify custom changes made to the configuration files.
- Apply changes to configuration files based on differential file (available also in **Community Edition**).
- Validate configuration files.

{{< alert title="Important" color="success" >}}
You can upgrade to OpenNebula {{< version >}} from any previous installation of OpenNebula EE or CE.

OpenNebula version {{< version >}} includes migrators for the database ([`onedb`]({{% relref "upgrading_single/#step-8-upgrade-the-database-version" %}})) and for configuration files (`onecfg`, described in this section). These migrators, included in the `opennebula-migration` package, are available in both the Enterprise and Community Edition, and support migrating from all previous OpenNebula EE or CE versions.
{{< /alert >}}

## How Should I Read This Chapter

In this Chapter, you’ll find all the information about how to manage your configuration files. Although this knowledge is not so important for new installations, it’s essential for the OpenNebula upgrades that might happen in the near future.

First, get familiar with the [Basic Usage]({{% relref "usage" %}}) of the tool `onecfg`. Move on to the [Diff Format]({{% relref "diff_formats" %}}), which describes the custom changes you already have or you want to apply. Then get familiar with how configuration upgrade automation fits into the OpenNebula upgrade workflow (see the [Upgrade Guide - Start Here]({{% relref "../upgrade_guide/start_here.md" %}}) page) and how to [Troubleshoot]({{% relref "conflicts" %}}) potential conflicts.

The [Appendix]({{% relref "appendix" %}}) presents a list of supported configuration files and their types.

## Hypervisor Compatibility

This Chapter applies to all supported hypervisors.
