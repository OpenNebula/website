---
title: "Overview"
date: "2025-02-17"
description:
categories:
pageintoc: "143"
tags:
weight: "1"
---

<a id="whmcs-tenants-overview"></a>

<!--# Overview -->

**WHMCS** is a web host billing automation platform which can be configured for many uses.  We provide a Module for WHMCS which allows you to automate the creation and management of Users, Groups, and their Access Control Lists inside of OpenNebula, as well as provide billing based on their usage metrics.

You will be able to define these resource packages to control the usage and cost of your OpenNebula resources.

Inside of OpenNebula when an order is accepted, the setup is performed: there is a user and a group created for the service.  This group in will then be assigned a Usage Quota which you will define during the package configuration.

## How I Should Read This Chaper

Before reading this chapter you should be aware of the [WHMCS Documentation](https://docs.whmcs.com/Documentation_Home) and have it installed on a server which can access your OpenNebula install.  You should also be familiar with OpenNebula’s [Manage Users]({{% relref "../../../product/cloud_system_administration/multitenancy//manage_users#manage-users" %}}), [Manage Groups]({{% relref "../../../product/cloud_system_administration/multitenancy/manage_groups#manage-groups" %}}), [Usage Quotas]({{% relref "../../../product/cloud_system_administration/capacity_planning/quotas#quota-auth" %}}) and [Managing Permissions]({{% relref "../../../product/cloud_system_administration/multitenancy/chmod#chmod" %}}) features.

In this chapter there are three guides for this module:
: * Install/Configure
  * Admin Usage
  * User Guide

## Hypervisor Compatibility

These guides are compatible with all hypervisors.
