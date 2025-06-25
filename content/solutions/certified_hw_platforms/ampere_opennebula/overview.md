---
title: Overview
weight: 1
---

This guide provides a reference Ampere hardware specification, that has been used to verify OpenNebula. It includes insturctions on how to perform a ZeroTouch deployment of OpenNebula on the certified hardware, and provides a reference architecture and configuration.

The target high-level cloud architecture overview is shown below. Two Ampere servers are used: the first for hosting the OpenNebula Front-end services and VMs, the second for hosting VMs only. A simple VXLAN networking is configured for the communication between the VMs, so all deployed VMs are attached to the same logical LAN.

![><][high-level]

[high-level]: /images/solutions/ampere/high-level-architecture.png

