---
title: "Federation Configuration"
date: "2025-02-17"
description:
categories:
pageintoc: "37"
tags:
weight: "2"
---

<a id="federationconfig"></a>

<!--# Federation Configuration -->

This section will explain how to configure two (or more) OpenNebula Zones to work as federation *master* and *slave*. The process described here can be applied to new installations or existing OpenNebula instances.

OpenNebula *master* Zone server replicates database changes on *slaves* using a federated log. The log contains the SQL commands which should be applied in all Zones.

In this document, each configuration step starts with **Master** or **Slave** to indicate the server where the step must be performed.

{{< alert title="Important" color="success" >}}
*Master* and *slave* servers need to talk to each other through their XML-RPC API. You may need to update the `LISTEN_ADDRESS`, and or `PORT` in [/etc/one/oned.conf]({{% relref "../../operation_references/opennebula_services_configuration/oned#oned-conf" %}}), or any firewall rule blocking this communication. Note that by default this traffic is not secure, so if you are using public links you need to secure the communication.{{< /alert >}} 

{{< alert title="Important" color="success" >}}
When using an HA environment, every change at any configuration file included in the steps below should be applied to every HA cluster node.{{< /alert >}} 

{{< alert title="Important" color="success" >}}
The federation can be set up with MySQL/MariaDB or SQLite as backends, but you can’t mix them across Zones. MySQL/MariaDB is recommended for production deployments.{{< /alert >}} 

## Step 1. Configure the OpenNebula Federation Master Zone

Start by picking an OpenNebula to act as master of the federation. The *master* OpenNebula will be responsible for updating shared information across Zones and replicating the updates to the *slaves*. You may start with an existing installation or with a new one (see the [installation guide]({{% relref "front_end_installation" %}})).

{{< alert title="Note" color="success" >}}
When installing a new *master* from scratch be sure to start it at least once to properly bootstrap the database.{{< /alert >}} 

- **Master**: Edit the *master* Zone endpoint. This can be done via Sunstone or with the onezone command. Write down this endpoint to use it later when configuring the *slaves*.

```default
$ onezone update 0
ENDPOINT = http://<master-ip>:2633/RPC2
```

{{< alert title="Note" color="success" >}}
In the HA setup, the `<master-ip>` should be set to the **floating** IP address, see [the HA installation guide]({{% relref "../high_availability/frontend_ha#oneha" %}}) for more details. In single server Zones, just use the IP of the server.{{< /alert >}} 

- **Master**: Update `/etc/one/oned.conf` to change the mode to **master**.

```default
FEDERATION = [
    MODE    = "MASTER",
    ZONE_ID = 0
]
```

- **Master**: Restart the OpenNebula.

You are now ready to add *slave* Zones.

## Step 2. Adding a New Federation Slave Zone

- **Slave**: Install OpenNebula on the *slave* as usual following the [installation guide]({{% relref "front_end_installation" %}}). Start OpenNebula at least once to bootstrap the Zone database.
- **Slave**: Stop OpenNebula.
- **Master**: Create a Zone for the *slave* and write down the new Zone ID. This can be done via Sunstone or with the onezone command.

```default
$ vim /tmp/zone.tmpl
NAME     = slave-name
ENDPOINT = http://<slave-zone-ip>:2633/RPC2

$ onezone create /tmp/zone.tmpl
ID: 100

$ onezone list
   ID NAME
    0 OpenNebula
  100 slave-name
```

{{< alert title="Note" color="success" >}}
In HA setups use the **floating** IP address for the `<slave-zone-ip>`; in single server Zones just use the IP of the server.{{< /alert >}} 

- **Master**: Make a snapshot of the federated tables with the following command:

```default
$ onedb backup --federated -s /var/lib/one/one.db
Sqlite database backup of federated tables stored in /var/lib/one/one.db_federated_2017-6-15_8:52:51.bck
Use 'onedb restore' to restore the DB.
```

{{< alert title="Note" color="success" >}}
This example shows how to make a database snapshot with SQLite. For MySQL/MariaDB just change the `-s` option with the corresponding MySQL/MariaDB options: `-u <username> -p <password> -d <database_name>`. For SQLite, you need to stop OpenNebula before taking the DB snapshot. This is not required for MySQL/MariaDB.{{< /alert >}} 

- **Master**: Copy the database snapshot to the *slave*.
- **Master**: Copy **only selected files** from the directory `/var/lib/one/.one` to the *slave*. This directory and its content must have **oneadmin as owner**. Replace only these files:

```default
$ ls -1 /var/lib/one/.one
one_auth
oneflow_auth
onegate_auth
sunstone_auth
```

- **Slave**: Update `/etc/one/oned.conf` to change the mode to **slave**, set the *master’s* URL and the `ZONE_ID` obtained when the Zone was created on *master*:

```default
FEDERATION = [
    MODE        = "SLAVE",
    ZONE_ID     = 100,
    MASTER_ONED = "http://<master-ip>:2633/RPC2"
]
```

- **Slave**: Restore the database snapshot:

```default
$ onedb restore --federated -s /var/lib/one/one.db /var/lib/one/one.db_federated_2017-6-14_16:0:36.bck
Sqlite database backup restored in one.db
```

- **Slave**: Start OpenNebula.
- **Slave**: In each Slave node you must place the configuration so that it is able to know which Zone it represents. For this you must modify the `/etc/one/fireedge-server.conf` file with the zone information.

```default
default_zone:
    id: 100 //ID
    name: 'Slave' // NAME
    endpoint: 'http://<slave-ip>:2633/RPC2' //ENDPOINT
```

{{< alert title="Note" color="success" >}}
In case the default [PORT]({{% relref "../../operation_references/opennebula_services_configuration/fireedge#fireedge-conf" %}}) of the FireEdge (Master or Slave) is changed, it is required that the Zone that this FireEdge represents has the `FIREEDGE_ENDPOINT` field added with the endpoint that the other FireEdge receives HTTPS requests.{{< /alert >}} 

- **Slave**: Start FireEdge.

The Zone should be now configured and ready to use.

## Step 3. Adding HA to a Federation Slave Zone (Optional)

Now you can start adding more servers to the *slave* Zone to provide it with HA capabilities. The procedure is the same as the one described for stand-alone Zones in [the HA installation guide]({{% relref "../high_availability/frontend_ha#oneha" %}}). In this case, the replication works in a multi-tier fashion. The *master* replicates a database change to one of the Zone servers. Then this server replicates the change across the Zone servers.

{{< alert title="Important" color="success" >}}
It is important to double check that the federation is working before adding HA servers to the Zone, as you will be updating the Zone metadata which is federated information.{{< /alert >}} 

## Step 4. Show Service Information by Zone in Sunstone (Optional)

To see services information for a specific Zone within Sunstone, you need to do the following:

- Adjust the `:host` field in `/etc/one/oneflow-server.conf` of the slave Zone to allow listening for requests outside of 127.0.0.1

{{< alert title="Note" color="success" >}}
So that the oneflow-server listens for requests from anywhere, the Host field can be set to 0.0.0.0{{< /alert >}} 

- Update the slave Zone in the master Zone. Adding the `ONEFLOW_ENDPOINT=http://<slave-zone-ip>:2474/` field with the public address of the slave Zone with the following command `onezone update <id-slave-zone>`
- Restart the Sunstone service

## Importing Existing OpenNebula Zones

There is no automatic procedure to import existing users and groups into a running federation. However, you can preserve everything else like datastores, VMs, networks…

- **Slave**: Back up details of users, groups, and VDCs you want to recreate in the federated environment.
- **Slave**: Stop OpenNebula. If the Zone was running an HA cluster, stop all servers and pick one of them to add the Zone to the federation. Put this server in solo mode by setting `SERVER_ID` to `-1` in `/etc/one/oned.conf`.
- **Master, Slave**: Follow the procedure described in Step 2 to add a new Zone.
- **Slave**: Recreate any user, group, or VDC you need to preserve in the federated environment.

The Zone is now ready to use. If you want to add more HA servers, follow the standard procedure.

## Updating a Federation

OpenNebula database has two different version numbers:

- federated (shared) tables version
- local tables version

{{< alert title="Important" color="success" >}}
To federate OpenNebula Zones, they must run the same version of the federated tables (which are pretty stable).{{< /alert >}} 

Upgrades to a version that does not increase the federated version can be done asynchronously in each Zone. However, an update in the shared table version requires a coordinated update of all Zones.

## Administration Account Configuration

A Federation will have a unique oneadmin account. This is required to perform API calls across Zones. It’s recommended not to use this account directly in a production environment but to create an account in the ‘oneadmin’ group for each Zone administrator instead.

When additional access restrictions are needed, the Federation Administrator can create a special administrative group with total permissions for one Zone only.
