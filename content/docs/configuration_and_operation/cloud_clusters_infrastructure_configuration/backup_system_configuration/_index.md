---
title: "Backup System Configuration"
date: "2025/02/17"
description:
categories:
pageintoc: "76"
tags:
weight: "4"
---

<a id="backup-system-configuration"></a>

<!--# Virtual Machine Backups -->

* [Overview]({{% relref "overview" %}})
  * [How Should I Read This Chapter]({{% relref "overview#how-should-i-read-this-chapter" %}})
  * [Hypervisor & Storage Compatibility]({{% relref "overview#hypervisor-storage-compatibility" %}})
* [Backup Datastore: Restic]({{% relref "restic" %}})
  * [Step 0. [Backup Server] Setup the backup server]({{% relref "restic#step-0-backup-server-setup-the-backup-server" %}})
  * [Step 1. [Front-end] Create a Restic Datastore]({{% relref "restic#step-1-front-end-create-a-restic-datastore" %}})
  * [Repository Maintenance and Troubleshooting]({{% relref "restic#repository-maintenance-and-troubleshooting" %}})
  * [Reference: Restic Datastore Attributes]({{% relref "restic#reference-restic-datastore-attributes" %}})
* [Backup Datastore: Rsync]({{% relref "rsync" %}})
  * [Step 0. Setup the backup server]({{% relref "rsync#step-0-setup-the-backup-server" %}})
  * [Step 1. Create OpenNebula Datastore]({{% relref "rsync#step-1-create-opennebula-datastore" %}})
  * [Other Configurations]({{% relref "rsync#other-configurations" %}})
  * [Reference: rsync Datastore Attributes]({{% relref "rsync#reference-rsync-datastore-attributes" %}})
