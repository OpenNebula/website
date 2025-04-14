---
title: "Database Maintenance"
date: "2025-02-17"
description:
categories:
pageintoc: "164"
tags:
weight: "8"
---

<a id="database-maintenance"></a>

<!--# Database Maintenance -->

OpenNebula persists the state of the cloud into the selected [SQL database]({{% relref "database" %}}). The database should be monitored and tuned for the best performance by cloud administrators following the best practices of the particular database product. In this guide, we provide a few tips on how to optimize database for OpenNebula and thoroughly describe OpenNebula’s database maintenance tool `onedb`, which simplifies the most common database operations - backups and restores, version upgrades, or consistency checks.

<a id="mysql-maintenance"></a>

## Optimize Database

Depending on the environment, you should consider periodically executing the following tasks for an optimal database performance:

### Cleanup Old Content

When Virtual Machines are terminated (changed into a `DONE` state), OpenNebula just changes their state in database but keeps the information in the database in case it’s required in the future (e.g., to generate accounting reports). To reduce the size of the VM table, it is recommended to periodically delete the information about already terminated Virtual Machines if no longer needed with [onedb purge-done]({{% relref "#onedb-purge-done" %}}) (tool is available below).

<a id="onedb"></a>

## OpenNebula Database Maintenance Tool

{{< alert title="Important" color="success" >}}
All the commands should be run with OpenNebula stopped, except the ones that has a warning in this documentation saying that it is executed with OpenNebula running.{{< /alert >}} 

This section describes the OpenNebula database maintenance command-line tool `onedb`. It can be used to get information from an OpenNebula database, backup and restore, upgrade to new versions of an OpenNebula database, clean up unused content, or fix inconsistency problems.

Available subcommands (visit the [manual page]({{% relref "../configuration_references/cli#cli" %}}) for full reference):

- [version]({{% relref "#onedb-version" %}}) - Shows current database schema version
- [history]({{% relref "#onedb-history" %}}) - Lists history of schema upgrades
- [fsck]({{% relref "#onedb-fsck" %}}) - Performs consistency check and repair on data
- [upgrade]({{% relref "#onedb-upgrade" %}}) - Upgrades database to new OpenNebula version
- [backup]({{% relref "#onedb-backup" %}}) - Backs up database into a file
- [restore]({{% relref "#onedb-restore" %}}) - Restores database from backup
- [purge-history]({{% relref "#onedb-purge-history" %}}) - Cleans up history records in VM metadata
- [change-history]({{% relref "#onedb-change-history" %}}) - Change records in VM metadata
- [update-history]({{% relref "#onedb-update-history" %}}) - Update history records in VM metadata
- [purge-done]({{% relref "#onedb-purge-done" %}}) - Cleans database of unused content
- [change-body]({{% relref "#onedb-change-body" %}}) - Allows to update OpenNebula objects in database
- [update-body]({{% relref "#onedb-update-body" %}}) - Allows to update OpenNebula objects body in database
- [sqlite2mysql]({{% relref "#onedb-sqlite2mysql" %}}) - Migration tool from SQLite to MySQL/MariaDB

The command `onedb` works with all supported database backends - SQLite or MySQL/MariaDB. The database type and connection parameters are automatically taken from OpenNebula Daemon configuration ([/etc/one/oned.conf]({{% relref "oned#oned-conf" %}})), but can be overwrite on the command line with the following example parameters:

**Automatic Connection Parameters**

```default
$ onedb <command> -v
```

**SQLite**

```default
$ onedb <command> -v --sqlite /var/lib/one/one.db
```

**MySQL/MariaDB**

```default
$ onedb <command> -v -S localhost -u oneadmin -p oneadmin -d opennebula
```

{{< alert title="Warning" color="warning" >}}
If the MySQL user password contains special characters, such as `@` or `#`, the onedb command might fail to connect to the database. The workaround is to temporarily change the oneadmin password to an alphanumeric string. The [SET PASSWORD](http://dev.mysql.com/doc/refman/5.6/en/set-password.html) statement can be used for this:

```default
$ mysql -u oneadmin -p
mysql> SET PASSWORD = PASSWORD('newpass');
```{{< /alert >}}  

<a id="onedb-version"></a>

### onedb version

Prints the current database schema version, e.g.:

```default
$ onedb version
Shared: 5.12.0
Local:  5.12.0
Required shared version: 5.12.0
Required local version:  5.12.0
```

Use the `-v` flag to see the complete version with comments, e.g.:

```default
$ onedb version -v
Shared tables version:   5.12.0
Required version:        5.12.0
Timestamp: 09/08 11:52:46
Comment:   Database migrated from 5.6.0 to 5.12.0 (OpenNebula 5.12.0) by onedb command.

Local tables version:    5.12.0
Required version:        5.12.0
Timestamp: 09/08 11:58:27
Comment:   Database migrated from 5.8.0 to 5.12.0 (OpenNebula 5.12.0) by onedb command.
```

Command exits with different return codes based on the state of database:

- `0`: The current version of the DB match with the source version.
- `1`: The database has not been bootstrapped yet, requires OpenNebula start.
- `2`: The DB version is older than required, requires upgrade.
- `3`: The DB version is newer and not supported by this release.
- `-1`: Any other problem (e.g., connection issues)

<a id="onedb-history"></a>

### onedb history

Every database upgrade is internally logged into the table. You can use the `history` command to show the upgrade history, e.g.:

```default
$ onedb history -S localhost -u oneadmin -p oneadmin -d opennebula
Version:   3.0.0
Timestamp: 10/07 12:40:49
Comment:   OpenNebula 3.0.0 daemon bootstrap

...

Version:   3.7.80
Timestamp: 10/08 17:36:15
Comment:   Database migrated from 3.6.0 to 3.7.80 (OpenNebula 3.7.80) by onedb command.

Version:   3.8.0
Timestamp: 10/19 16:04:17
Comment:   Database migrated from 3.7.80 to 3.8.0 (OpenNebula 3.8.0) by onedb command.
```

<a id="onedb-change-history"></a>

### onedb change history

Change the CLUSTER_ID of a previous VM sequence in a non interactive way. This is useful when accidentally deleting a cluster. You might be unable to attach disks or NICs to the VM due to the VM being reported in a non existing cluster.

The following command changes the the sequence 0 of the VM 224 to have the CLUSTER_ID set to 0.

```default
$ onedb change-history --id 224 --seq 0 '/HISTORY/CID' 0
```

<a id="onedb-update-history"></a>

### onedb update history

Change the scheduling record of a previous VM sequence interactively. This is useful when recovering from errors in the database.

The following command prompts an editor to open where the XML of the sequence 0 of the VM 224 will be edited.

```default
$ onedb update-history --id 224 --seq 0
```

<a id="onedb-fsck"></a>

### onedb fsck

Checks the consistency of OpenNebula objects inside the database and fixes any problems it finds. For example, if the machine where OpenNebula is running crashes or loses connectivity to the database, you may have the wrong number of VMs running in a Host or incorrect usage quotas for some users.

To repair any error, first you need to stop OpenNebula and then run the `onedb fsck` command. To check consistency, without writing fixes, use the `--dry` option.

```default
$ onedb fsck
Sqlite database backup stored in /var/lib/one/one.db.bck
Use 'onedb restore' or copy the file back to restore the DB.

Host 0 RUNNING_VMS has 12   is  11
Host 0 CPU_USAGE has 1200   is  1100
Host 0 MEM_USAGE has 1572864    is  1441792
Image 0 RUNNING_VMS has 6   is  5
User 2 quotas: CPU_USED has 12  is  11.0
User 2 quotas: MEMORY_USED has 1536     is  1408
User 2 quotas: VMS_USED has 12  is  11
User 2 quotas: Image 0  RVMS has 6  is  5
Group 1 quotas: CPU_USED has 12     is  11.0
Group 1 quotas: MEMORY_USED has 1536    is  1408
Group 1 quotas: VMS_USED has 12     is  11
Group 1 quotas: Image 0 RVMS has 6  is  5

Total errors found: 12
```

#### Repairing VM History End-time

If `onedb fsck` shows the following error message:

```none
[UNREPAIRED] History record for VM <<vid>> seq # <<seq>> is not closed (etime = 0)
```

it means that when using accounting or showback, the etime (end-time) of that history record was not set and the VM was considered as still running while it shouldn’t have been. To fix this problem, you can locate the time when the VM was shut down in the logs and then execute this patch to edit the times manually:

```default
$ onedb patch -v /usr/lib/one/ruby/onedb/patches/history_times.rb
Version read:
Shared tables 4.11.80 : OpenNebula 5.0.1 daemon bootstrap
Local tables  4.13.85 : OpenNebula 5.0.1 daemon bootstrap

Sqlite database backup stored in /var/lib/one/one.db_2015-10-13_12:40:2.bck
Use 'onedb restore' or copy the file back to restore the DB.

  > Running patch /usr/lib/one/ruby/onedb/patches/history_times.rb
This tool will allow you to edit the timestamps of VM history records, used to calculate accounting and showback.
VM ID: 1
History sequence number: 0

STIME   Start time          : 2015-10-08 15:24:06 UTC
PSTIME  Prolog start time   : 2015-10-08 15:24:06 UTC
PETIME  Prolog end time     : 2015-10-08 15:24:29 UTC
RSTIME  Running start time  : 2015-10-08 15:24:29 UTC
RETIME  Running end time    : 2015-10-08 15:42:35 UTC
ESTIME  Epilog start time   : 2015-10-08 15:42:35 UTC
EETIME  Epilog end time     : 2015-10-08 15:42:36 UTC
ETIME   End time            : 2015-10-08 15:42:36 UTC

To set new values:
  empty to use current value; <YYYY-MM-DD HH:MM:SS> in UTC; or 0 to leave unset (open history record).
STIME   Start time          : 2015-10-08 15:24:06 UTC
New value                   :

ETIME   End time            : 2015-10-08 15:42:36 UTC
New value                   :


The history record # 0 for VM 1 will be updated with these new values:
STIME   Start time          : 2015-10-08 15:24:06 UTC
PSTIME  Prolog start time   : 2015-10-08 15:24:06 UTC
PETIME  Prolog end time     : 2015-10-08 15:24:29 UTC
RSTIME  Running start time  : 2015-10-08 15:24:29 UTC
RETIME  Running end time    : 2015-10-08 15:42:35 UTC
ESTIME  Epilog start time   : 2015-10-08 15:42:35 UTC
EETIME  Epilog end time     : 2015-10-08 15:42:36 UTC
ETIME   End time            : 2015-10-08 15:42:36 UTC

Confirm to write to the database [Y/n]: y
  > Done

  > Total time: 27.79s
```

<a id="onedb-upgrade"></a>

### onedb upgrade

Upgrades database to the new OpenNebula version. This process is fully documented in the [upgrade guides]({{% relref "../../../software/release_information/upgrade/index#upgrade" %}}).

<a id="onedb-backup"></a>

### onedb backup

Dumps OpenNebula database into a file, e.g.:

```default
$ onedb backup /tmp/my_backup.db
Sqlite database backup stored in /tmp/my_backup.db
Use 'onedb restore' or copy the file back to restore the DB.
```

<a id="onedb-restore"></a>

### onedb restore

Restores OpenNebula database from a provided [backup]({{% relref "#onedb-backup" %}}) file. Please note that only backups **from the same Back-end can be restored**, e.g. you can’t back-up SQLite database and then restore to a MySQL. E.g.,

```default
$ onedb restore /tmp/my_backup.db
Sqlite database backup restored in /var/lib/one/one.db
```

<a id="onedb-purge-history"></a>

### onedb purge-history

{{< alert title="Warning" color="warning" >}}
The operation is done while OpenNebula is running. Make a **database backup** before executing!{{< /alert >}} 

Deletes all but the last two history records from the metadata of Virtual Machines which are still active (not in a `DONE` state). You can specify the start and end dates if you don’t want to delete all history. E.g.,

```default
$ onedb purge-history --start 2008/07/24 --end 2023/06/14
```

You can also delete history records for a specific VM

```default
$ onedb purge-history --id <vm_id>
```

<a id="onedb-purge-done"></a>

### onedb purge-done

{{< alert title="Warning" color="warning" >}}
The operation is done while OpenNebula is running. Make a **database backup** before executing!{{< /alert >}} 

Deletes information from the database with already terminated Virtual Machines (state `DONE`). You can set start and end dates via `-start` and `--end` parameters if you don’t want to delete all the old data. E.g.,

```default
$ onedb purge-done --end 2016/01
```

<a id="onedb-change-body"></a>

### onedb change-body

{{< alert title="Warning" color="warning" >}}
The operation is done while OpenNebula is running. Make a **database backup** before executing!{{< /alert >}} 

This command allows you to update the body content of OpenNebula objects in a database. Supported object types are `vm`, `host`, `vnet`, `image`, `cluster`, `document`, `group`, `marketplace`, `marketplaceapp`, `secgroup`, `template`, `vrouter` or `zone`.

You can filter the objects to update using one of the options:

* `--id`: object ID. Example: `156`
* `--xpath`: XPath expression. Example: `TEMPLATE[count(NIC)>1]`
* `--expr`: Simple expression using operators `=`, `!=`, `<`, `>`, `<=` or `>=`. Examples: `UNAME=oneadmin`, `TEMPLATE/NIC/NIC_ID>0`

If you want to change a value, add it as a third parameter. Use `--delete` argument to delete matching objects. In case you want to append a new attribute use `--append` option.

Examples:

- Change the `service` network of VMs that belong to user `johndoe` to `new_network`:

```default
$ onedb change-body vm --expr UNAME=johndoe '/VM/TEMPLATE/NIC[NETWORK="service"]/NETWORK' new_network
```

- Delete the `CACHE` attribute for all VMs and their disks. Don’t modify DB (`dry`), but only show the XML object content.

```default
$ onedb change-body vm '/VM/TEMPLATE/DISK/CACHE' --delete --dry
```

- Delete the `CACHE` attribute for all disks in VMs in `poweroff` state:

```default
$ onedb change-body vm --expr LCM_STATE=8 '/VM/TEMPLATE/DISK/CACHE' --delete
```

- Append cache attribute in all disks in `poweroff` state:

```default
$ onedb change-body vm --expr LCM_STATE=8 '/VM/TEMPLATE/DISK/CACHE' default --append
```

<a id="onedb-update-body"></a>

### onedb update-body

{{< alert title="Warning" color="warning" >}}
The operation is done while OpenNebula is running. Make a **database backup** before executing!{{< /alert >}} 

This command allows you to update the body content of OpenNebula objects in a database. Supported object types are `vm`, `host`, `vnet`, `image`, `cluster`, `document`, `group`, `marketplace`, `marketplaceapp`, `secgroup`, `template`, `vrouter` or `zone`.

You can filter the objects to update using one of the options:

* `--id`: object ID. Example: `156`

You can use the parameter `--file` to pass the object XML directly.

<a id="onedb-sqlite2mysql"></a>

### onedb sqlite2mysql

This command migrates from an SQLite database to a MySQL database. Follow the steps:

* Stop OpenNebula
* Reconfigure database in [/etc/one/oned.conf]({{% relref "oned#oned-conf" %}}) to use MySQL instead of SQLite.
* Bootstrap the MySQL Database by running `oned -i`
* Migrate the Database: `onedb sqlite2mysql -s <SQLITE_PATH> -u <MYSQL_USER> -p <MYSQL_PASS> -d <MYSQL_DB>`
* Start OpenNebula.
