---
title: "Infrastructure Drivers Development"
date: "2025-02-17"
description:
categories:
pageintoc: "290"
tags:
weight: "2"
---

<!--# Infrastructure Integration -->

* [Overview]({{% relref "overview" %}})
  * [How Should I Read This Chapter]({{% relref "overview#how-should-i-read-this-chapter" %}})
* [Virtualization Driver]({{% relref "devel-vmm" %}})
  * [Driver Configuration]({{% relref "devel-vmm#driver-configuration" %}})
  * [Actions]({{% relref "devel-vmm#actions" %}})
  * [Poll Information]({{% relref "devel-vmm#poll-information" %}})
  * [Deployment File]({{% relref "devel-vmm#deployment-file" %}})
* [Storage Driver]({{% relref "sd" %}})
  * [Datastore Drivers Structure]({{% relref "sd#datastore-drivers-structure" %}})
  * [TM Drivers Structure]({{% relref "sd#tm-drivers-structure" %}})
  * [Tuning OpenNebula Core and Driver Integration]({{% relref "sd#tuning-opennebula-core-and-driver-integration" %}})
  * [The Monitoring Process]({{% relref "sd#the-monitoring-process" %}})
  * [Mixed Transfer modes]({{% relref "sd#mixed-transfer-modes" %}})
  * [An Example VM]({{% relref "sd#an-example-vm" %}})
  * [Helper Scripts]({{% relref "sd#helper-scripts" %}})
  * [Decoded Example]({{% relref "sd#decoded-example" %}})
  * [Datastore Backup STDIN Example]({{% relref "sd#datastore-backup-stdin-example" %}})
  * [Export XML]({{% relref "sd#export-xml" %}})
* [Monitoring Driver]({{% relref "devel-im" %}})
  * [Message structure]({{% relref "devel-im#message-structure" %}})
  * [Basic Monitoring Scripts]({{% relref "devel-im#basic-monitoring-scripts" %}})
  * [System Datastore Information]({{% relref "devel-im#system-datastore-information" %}})
  * [Creating a New IM Driver]({{% relref "devel-im#creating-a-new-im-driver" %}})
* [Networking Driver]({{% relref "devel-nm" %}})
  * [Driver Configuration and Description]({{% relref "devel-nm#driver-configuration-and-description" %}})
  * [Driver Customization]({{% relref "devel-nm#driver-customization" %}})
  * [Driver Parameters]({{% relref "devel-nm#driver-parameters" %}})
  * [The 802.1Q Driver]({{% relref "devel-nm#the-802-1q-driver" %}})
  * [The VXLAN Driver]({{% relref "devel-nm#the-vxlan-driver" %}})
  * [The Open vSwitch Driver]({{% relref "devel-nm#the-open-vswitch-driver" %}})
  * [The Dummy Driver]({{% relref "devel-nm#the-dummy-driver" %}})
  * [The Bridge Driver]({{% relref "devel-nm#the-bridge-driver" %}})
  * [The FW Driver]({{% relref "devel-nm#the-fw-driver" %}})
  * [The Elastic Driver]({{% relref "devel-nm#the-elastic-driver" %}})
* [Authentication Driver]({{% relref "devel-auth" %}})
  * [Authentication Driver]({{% relref "devel-auth#id1" %}})
  * [Enabling the Driver]({{% relref "devel-auth#enabling-the-driver" %}})
  * [Managed Groups]({{% relref "devel-auth#managed-groups" %}})
* [Market Driver]({{% relref "devel-market" %}})
  * [Marketplace Drivers Structure]({{% relref "devel-market#marketplace-drivers-structure" %}})
* [IPAM Driver]({{% relref "devel-ipam" %}})
  * [IPAM Drivers Structure]({{% relref "devel-ipam#ipam-drivers-structure" %}})
  * [IPAM Usage]({{% relref "devel-ipam#ipam-usage" %}})
