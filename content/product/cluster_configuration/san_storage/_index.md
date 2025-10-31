---
title: "SAN Storage"
date: "2025-10-27"
description: "This section describes the validation of external SAN (Storage Area Network) appliances used as backend storage for OpenNebula's datastores. It focuses on ensuring compatibility, performance, and proper configuration of iSCSI-based block storage across different enterprise-grade storage vendors. Each guide outlines the required setup steps to integrate the storage array with OpenNebula hosts, including iSCSI initiator configuration, LUN or volume creation, and host-to-storage mappings. While vendor-specific tools and interfaces differ, the core validation approach remains consistent: verifying that the exported block devices are properly discovered, accessible via multipath, and usable for LVM thin provisioning within OpenNebula."
categories:
pageintoc: "66"
tags:
weight: "4"
---

<!--# SAN Storage Setup -->
