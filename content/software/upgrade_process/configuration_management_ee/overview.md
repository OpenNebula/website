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

{{< alert title="Important" color="success" >}}
Complete feature is available in OpenNebula **Enterprise Edition**.{{< /alert >}} 
Only a single functionality comes in **Community Edition**.

OpenNebula has tens of configuration files, where cloud administrators can fine-tune the behavior of their cloud environment. When doing an upgrade to a newer minor OpenNebula version (`X.Y`), unfortunately, all custom changes in configuration files must be migrated to new configuration files. OpenNebula **Enterprise Edition** comes with a dedicated tool (`onecfg`), which automates and simplifies the upgrade of configuration files.

This chapter describes how to use the configuration management tool to

- Upgrade your configuration files for the new OpenNebula version.
- Check the version status of the current installation.
- Identify custom changes made to the configuration files.
- Apply changes to configuration files based on differential file (available also in **Community Edition**).
- Validate configuration files.

## How Should I Read This Chapter

In this chapter, you’ll find all the information about how to manage your configuration files. Although this knowledge is not so important for new installations, it’s essential for the OpenNebula upgrades that might happen in the near future.

First, get familiar with the [Basic Usage]({{% relref "usage#cfg-usage" %}}) of the tool `onecfg`. Move on to the [Diff Format]({{% relref "diff_formats#cfg-diff-formats" %}}), which describes the custom changes you already have or you want to apply. Then get familiar with how configuration upgrade automation fits into the [OpenNebula Upgrade Workflow]({{% relref "../upgrade_guide/start_here.md#start-here" %}}) and how to [Troubleshoot]({{% relref "conflicts#cfg-conflicts" %}}) potential conflicts.

The [Appendix]({{% relref "appendix#cfg-files" %}}) presents list of supported configuration files and their types.

## Hypervisor Compatibility

This chapter applies to all supported hypervisors.
