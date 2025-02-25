---
title: "Upgrading Federated Instances"
date: "2025/02/17"
description:
categories:
pageintoc: "261"
tags:
weight: "5"
---

<a id="upgrade-federation"></a>

<!--# Upgrading a Federation -->

<!-- TYPE A. NO CHANGES IN FEDERATION TABLES

This version of OpenNebula does not modify the federation data model. You can upgrade each zone asynchronously following the corresponding guide:

* :ref:`Follow the upgrading for single Front-end deployments <upgrading_single>`
* :ref:`Follow the upgrading for high availability clusters <upgrading_ha>` -->
<!-- TYPE B. CHANGES IN FEDERATION TABLES -->

This version of OpenNebula introduces some changes in the federation data model. You need to coordinate the upgrade across zones and upgrade them at the same time.

## Step 1. Check Federation Status

Check that federation is in sync and all zones are at the same index (FED_INDEX):

```default
$ onezone list
C   ID NAME                                         ENDPOINT                                      FED_INDEX
   101 S-US-CA                                      http://192.168.150.3:2633/RPC2                715438
   100 S-EU-GE                                      http://192.168.150.2:2633/RPC2                715438
*    0 M-EU-FR                                      http://192.168.150.1:2633/RPC2                715438
```

It is a good idea to prevent any API access to the master zone during this step (e.g. by filtering out access to API).

{{< alert title="Note" color="success" >}}
If you are upgrading from version 6.2+ you can use `onezone disable <zone_id>`.{{< /alert >}} 

## Step 2. Stop All Zones

Stop OpenNebula and any other related services you may have running: OneFlow, OneGate & FireEdge. It’s preferable to use the system tools, like `systemctl` or `service` as `root` in order to stop the services.

{{< alert title="Important" color="success" >}}
If you are running FireEdge service behind Apache/Nginx, please stop also the Apache/Nginx service.{{< /alert >}} 

{{< alert title="Warning" color="warning" >}}
Make sure that every OpenNebula process is stopped. The output of `systemctl list-units | grep opennebula` should be empty.{{< /alert >}} 

## Step 3. Upgrade Master Zone

You can now upgrade the master zone:

> * [Follow the upgrading for single Front-end deployments]({{% relref "upgrading_single#upgrade-single" %}})
> * [Follow the upgrading for high availability clusters]({{% relref "upgrading_ha#upgrade-ha" %}})

## Step 4. Back-up Federated Tables

Once the master zone has been updated, you need to export federated tables:

```default
$ onedb backup -v --federated
```

{{< alert title="Important" color="success" >}}
If you are running MySQL you will need to supply connection parameters such as `--user` and `--password`, and `--host` if the database is not on localhost. Please refer to [the CLI Reference]({{% relref "../../../cloud_operation/operation_references/configuration_references/cli#cli" %}}) for further information.{{< /alert >}} 

## Step 5. Restore Federated Backup in Slave Zones

The backup that has been generated needs to be restored in all slave zones:

```default
$ scp <backup_file> <slave_ip>:/tmp
$ onedb restore <backup_file> -v --federated
```

## Step 6. Upgrade Slave Zones

You can now upgrade the slave zones:

> * [Follow the upgrading for single Front-end deployments]({{% relref "upgrading_single#upgrade-single" %}})
> * [Follow the upgrading for high availability clusters]({{% relref "upgrading_ha#upgrade-ha" %}})

You will restart OpenNebula in each zone as part of the upgrade. Once you finish upgrading your master, remove any access restriction to the API imposed in Step 1.

{{< alert title="Note" color="success" >}}
If you are upgrading from version 6.2+ you can use `onezone enable <zone_id>`.{{< /alert >}} 
