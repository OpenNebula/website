---
title: "NetApp SAN Datastore (EE)"
linkTitle: "NetApp - Native (EE)"
weight: "6"
---

This datastore is used to register an existing NetApp SAN appliance. It utilizes the NetApp ONTAP API to create volumes with a single LUN, which will be treated as Virtual Machine disks using the iSCSI interface. Both the Image and System datastores should use the same NetApp SAN appliance with identical Storage VM configurations (aggregates, etc.), as volumes (disks) are either cloned or renamed depending on the image type. Persistent images are renamed to the System datastore, while non‐persistent images are cloned using FlexClone and then split.

The [NetApp ONTAP documentation](https://docs.netapp.com/us-en/ontap/) may be useful during this setup.

{{< alert title="Note" color="success" >}}
Sharing datastores between multiple OpenNebula instances is not supported and may cause issues if they share datastore IDs.
{{< /alert >}}

## NetApp ONTAP Setup

The NetApp system requires specific configurations. This driver operates using a Storage VM that provides iSCSI connections, with volumes/LUNs mapped directly to each Host after creation. Configure and enable the iSCSI protocol according to your infrastructure requirements.

1. **Define Aggregates/Local Tiers for your Storage VM:**
   - In ONTAP System Manager: **Storage > Storage VMs > Select your SVM > Edit > Limit volume creation to preferred local tiers**
   - Assign at least one aggregate/tier and note their UUID(s) from the URL for later use

{{< alert title="Note" color="success" >}}
The UUID of an object is often found in the URL if using the web interface, otherwise you can use the ONTAP CLI to gather them: `vserver show -fields uuid`, `igroup show -fields uuid`, etc.
{{< /alert >}}

2. **To enable capacity monitoring:**
   - Enable *Enable maximum capacity limit* on the same Edit Storage VM screen
   - If not configured, set `DATASTORE_CAPACITY_CHECK=no` in both of the OpenNebula datastores’ attributes

3. This driver will manage the snapshots, so do not enable any automated snapshots for this SVM; they will not be picked up by OpenNebula unless created through OpenNebula.

4. If you do not plan to use the administrator account, create a new user with all API permissions and assign it to the SVM.

## Front-end Only Setup

The Front-end requires network access to the NetApp ONTAP API endpoint:

1. **API Access:**
   - Ensure network connectivity to the NetApp ONTAP API interface. The datastore will be in an ERROR state if the API is not accessible or the SVM cannot be monitored properly.

## Front-end & Node Setup

Configure both the Front-end and nodes with persistent iSCSI connections:

1. **iSCSI Initiators:**
   - Configure initiator security in NetApp Storage VM:
     - **Storage VM > Settings > iSCSI Protocol > Initiator Security**
     - Add initiators from `/etc/iscsi/initiatorname.conf` (all nodes and Front-end)
   - Discover and login to the iSCSI targets:
     ~~~bash
     iscsiadm -m discovery -t sendtargets -p <target_ip>   # for each iSCSI target IP from NetApp
     iscsiadm -m node -l                                 # login to all discovered targets
     ~~~

2. **Persistent iSCSI Configuration:**
   - Set `node.startup = automatic` in `/etc/iscsi/iscsid.conf`
   - Ensure iscsid is started with `systemctl status iscsid`
   - Enable iscsid with `systemctl enable iscsid`

3. **Multipath Configuration:**
   Update `/etc/multipath.conf` to something like:
   ~~~text
    defaults {
      user_friendly_names yes
      find_multipaths yes
    }

    devices {
      device {
        vendor "NETAPP"
        product "LUN.*"
        no_path_retry queue
        path_checker tur
        alias_prefix "mpath"
      }
    }

    blacklist {
      devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
      devnode "^hd[a-z][0-9]*"
      devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
    }
   ~~~

## OpenNebula Configuration

Create both datastores as NetApp (instant cloning/moving capabilities):

- **System Datastore**
- **Image Datastore**

### Create System Datastore

**Template required parameters:**

| Attribute             | Description                                     |
| --------------------- | ----------------------------------------------- |
| `NAME`                | Datastore name                                  |
| `TYPE`                | `SYSTEM_DS`                                     |
| `TM_MAD`              | `netapp`                                        |
| `DISK_TYPE`           | `BLOCK`                                         |
| `NETAPP_HOST`         | NetApp ONTAP API IP address                     |
| `NETAPP_USER`         | API username                                    |
| `NETAPP_PASS`         | API password                                    |
| `NETAPP_SVM`          | Storage VM UUID                                 |
| `NETAPP_AGGREGATES`   | Aggregate UUID(s)                               |
| `NETAPP_IGROUP`       | Initiator group UUID                            |
| `NETAPP_TARGET`       | iSCSI Target name                               |

**Example template:**

~~~shell
$ cat netapp_system.ds
NAME              = "netapp_system"
TYPE              = "SYSTEM_DS"
DISK_TYPE         = "BLOCK"
DS_MAD            = "netapp"
TM_MAD            = "netapp"
NETAPP_HOST       = "10.1.234.56"
NETAPP_USER       = "admin"
NETAPP_PASS       = "password"
NETAPP_SVM        = "c9dd74bc-8e3e-47f0-b274-61be0b2ccfe3"
NETAPP_AGGREGATES = "280f5971-3427-4cc6-9237-76c3264543d5"
NETAPP_IGROUP     = "27702521-68fb-4d9a-9676-efa3018501fc"
NETAPP_TARGET     = "iqn.1993-08.org.debian:01:1234"


$ onedatastore create netapp_system.ds
ID: 101
~~~

### Create Image Datastore

**Template required parameters:**

| Attribute           | Description                                     |
| ------------------- | ----------------------------------------------- |
| `NAME`              | Datastore name                                  |
| `TYPE`              | `IMAGE_DS`                                      |
| `DS_MAD`            | `netapp`                                        |
| `TM_MAD`            | `netapp`                                        |
| `DISK_TYPE`         | `BLOCK`                                         |
| `NETAPP_HOST`       | NetApp ONTAP API IP address                     |
| `NETAPP_USER`       | API username                                    |
| `NETAPP_PASS`       | API password                                    |
| `NETAPP_SVM`        | Storage VM UUID                                 |
| `NETAPP_AGGREGATES` | Aggregate UUID(s)                               |
| `NETAPP_IGROUP`     | Initiator group UUID                            |
| `NETAPP_TARGET`     | iSCSI Target name                               |

**Example template:**
~~~shell
$ cat netapp_image.ds
NAME              = "netapp_image"
TYPE              = "IMAGE_DS"
DISK_TYPE         = "BLOCK"
TM_MAD            = "netapp"
NETAPP_HOST       = "10.1.234.56"
NETAPP_USER       = "admin"
NETAPP_PASS       = "password"
NETAPP_SVM        = "c9dd74bc-8e3e-47f0-b274-61be0b2ccfe3"
NETAPP_AGGREGATES = "280f5971-3427-4cc6-9237-76c3264543d5"
NETAPP_IGROUP     = "27702521-68fb-4d9a-9676-efa3018501fc"
NETAPP_TARGET     = "iqn.1993-08.org.debian:01:1234"

$ onedatastore create netapp_image.ds
ID: 102
~~~

### Datastore Optional Attributes

Since Volumes contain the LUNs and snapshots, they are by default configured to contain 10% extra space and reserve this for snapshots. You can override these settings with the following datastore attributes, which should be same for both datastores:

**Template optional parameters:**

| Attribute                 | Description                                           |
| ------------------------- | ----------------------------------------------------- |
| `NETAPP_SUFFIX`           | Volume/LUN name suffix.                               |
| `NETAPP_GROW_THRESHOLD`   | Volume autogrow threshold in percent. Default: 96     |
| `NETAPP_GROW_RATIO`       | Volume maximum autogrow ratio. Default: 2             |
| `NETAPP_SNAPSHOT_RESERVE` | Volume snapshot reserve in percent. Default: 10       |

{{< alert title="Note" color="success" >}}
Volumes will be created with the extra reservation space in mind, which will be `size * ( 1 + NETAPP_SNAPSHOT_RESERVE / 100 )`.
{{< /alert >}}

## Datastore Internals

**Storage architecture details:**

- **Images:** Stored as a volume with a single LUN in NetApp
- **Naming Convention:**
  - Image datastore: `one_<datastore_id>_<image_id>` (volume), `one_<datastore_id>_<image_id>_lun` (LUN)
  - System datastore: `one_<vm_id>_disk_<disk_id>` (volume), `one_<datastore_id>_<vm_id>_disk_<disk_id>_lun` (LUN)
- **Operations:**
  - Non‐persistent: FlexClone, then split
  - Persistent: Rename

Symbolic links from the System datastore will be created for each Virtual Machine on its Host once the LUNs have been mapped.

{{< alert title="Note" color="success" >}}
The minimum size for a NetApp volume is 20 MB, so any disk smaller than that will result in a 20 MB volume; however, the LUN inside will be the correct size.
{{< /alert >}}

## Known Issues

Currently the NetApp password on the Datastore is not encrypted due to a typo in the configuration file `/etc/one/oned.conf`. To encrypt this password, the Encrypted Attributes section of this file you must change `DATASTORE_ENCRYPTED_ATTR = "NETAPP_PASSWORD"` to `DATASTORE_ENCRYPTED_ATTR = "NETAPP_PASS"` and then restart OpenNebula.

## System Considerations

Occasionally, under network interruptions or if a volume is deleted directly from NetApp, the iSCSI connection may drop or fail. This can cause the system to hang on a `sync` command, which in turn may lead to OpenNebula operation failures on the affected Host. Although the driver is designed to manage these issues automatically, it’s important to be aware of these potential iSCSI connection challenges.

You may wish to contact the OpenNebula Support team to assist in this cleanup; however, here are a few advanced tips to clean these up if you are comfortable doing so:

- If you have extra devices from failures leftover, run:
  ~~~bash
  rescan_scsi_bus.sh -r -m
  ~~~
- If an entire multipath setup remains, run:
  ~~~bash
  multipath -f <multipath_device>
  ~~~
  *Be very careful to target the correct multipath device.*

{{< alert title="Note" color="success" >}}
This behavior stems from the inherent complexities of iSCSI connections and is not exclusive to OpenNebula or NetApp.
{{< /alert >}}

If devices persist, follow these steps:

1. Run `dmsetup ls --tree` or `lsblk` to see which mapped devices remain. You may see devices not attached to a mapper entry in `lsblk`.
2. For each such device (not your root device), run:
   ~~~bash
   echo 1 > /sys/bus/scsi/devices/sdX/device/delete
   ~~~
   where `sdX` is the device name.
3. Once those devices are gone, remove leftover mapper entries:
   ~~~bash
   dmsetup remove /dev/mapper/<device_name>
   ~~~
4. If removal fails:
   - Check usage:
     ~~~bash
     fuser -v $(realpath /dev/mapper/<device_name>)
     ~~~
   - If it’s being used as swap:
     ~~~bash
     swapoff /dev/mapper/<device_name>
     dmsetup remove /dev/mapper/<device_name>
     ~~~
   - If another process holds it, kill the process and retry:
     ~~~bash
     dmsetup remove /dev/mapper/<device_name>
     ~~~
   - If you can’t kill the process or nothing shows up:
     ~~~bash
     dmsetup suspend /dev/mapper/<device_name>
     dmsetup wipe_table /dev/mapper/<device_name>
     dmsetup resume /dev/mapper/<device_name>
     dmsetup remove /dev/mapper/<device_name>
     ~~~

This should resolve most I/O lockups caused by failed iSCSI operations. Please contact the OpenNebula Support team if you need assistance.
