---
title: "Compatibility Guide"
date: "2026-07-24"
description:
categories:
pageintoc: "247"
tags:
weight: "5"
---

<a id="compatibility"></a>

<!--# Compatibility Guide -->

This guide is aimed at OpenNebula 7.4.x users and administrators who want to upgrade to the latest version. The following sections summarize the new features and usage changes that should be taken into account or could perhaps cause confusion. You can check the upgrade process in the [corresponding section]({{% relref "software/upgrade_process/" %}}). If upgrading from previous versions, please make sure you read all the intermediate versions’ Compatibility Guides for possible pitfalls.

## ACPI on ARM KVM VMs

Starting with OpenNebula 7.6, the effective [`FEATURES/ACPI`]({{% relref "product/operation_references/configuration_references/template#template-features" %}}) value is always honored when generating the KVM deployment XML for ARM VMs. The ARM KVM driver defaults `ACPI` to `yes`; in previous versions this value could be ignored depending on the VM firmware configuration.

Existing ARM VMs that rely on Device Tree instead of ACPI must explicitly disable ACPI in their VM template:

```default
FEATURES = [ ACPI = "no" ]
```
