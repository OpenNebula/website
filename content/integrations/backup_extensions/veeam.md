---
title: "Veeam Backup (EE)"
weight: "1"
---

Veeam is a backup and recovery software that provides data protection and disaster recovery solutions for virtualized environments. The OpenNebula oVirtAPI Server allows to backup OpenNebula VMs from the Veeam interface.

## Compatibility

The oVirtAPI module is compatible with Veeam Backup & Replication 12.0.

The following table summarizes the supported backup modes for each storage system:

<table class="docutils align-default">
<thead>
<th class="head" rowspan="2"><p>Storage</p></th>
<th class="head" colspan="2"><p>Full</p></th>
<th class="head" colspan="2"><p>Incremental</p></th>
</tr>
<tr class="row-even"><th class="head"><p>Live</p></th>
<th class="head"><p>Power off</p></th>
<th class="head"><p>Live</p></th>
<th class="head"><p>Power off</p></th>
</tr>
</thead>
<tbody>
<tr class="row-odd">
<td><p>File<sup>*</sup> (qcow2)</p></td>
<td><p>Yes</p></td>
<td><p>Yes</p></td>
<td><p>Yes</p></td>
<td><p>Yes</p></td>
</tr>
<tr class="row-even"><td><p>File<sup>*</sup> (raw)</p></td>
<td><p>Yes</p></td>
<td><p>Yes</p></td>
<td><p>No</p></td>
<td><p>No</p></td>
</tr>
<tr class="row-odd"><td><p>Ceph</p></td>
<td><p>Yes</p></td>
<td><p>Yes
<td><p>No
<td><p>No
</tr>
<tr class="row-even"><td><p>LVM</p></td>
<td><p>Yes</p></td>
<td><p>Yes</p></td>
<td><p>No</p></td>
<td><p>No</p></td>
</tr>
</tbody>
</table>

<sup>\*</sup> Any datastore based on files with the given format, i.e. NFS/SAN or Local.

## Requirements & Architecture

In order to achieve a setup compatible with the OpenNebula and Veeam Backup integration, the following requirements must be met:

* A Backup Server hosting an OpenNebula backup datastore and the OpenNebula oVirtAPI Server.
* The Veeam Backup Appliance, deployed by Veeam when adding OpenNebula as a hypervisor.
* A management network must be in place connecting the following components:
     * OpenNebula backup server
     * OpenNebula Front-end
     * All Host running VMs to be backed up by Veeam
     * Veeam Server
     * Veeam Backup Appliance


![image](/images/backup_veeam_architecture.png)

## Step 1: Prepare the environment for the oVirtAPI Server

A server should be configured to expose both the Rsync backup datastore and the oVirtAPI Server. This server should be accessible from all the clusters that you want to be able to back up via the management network shown in the architecture diagram. The oVirtAPI Server is going to act as the communication gateway between Veeam and OpenNebula.

## Step 2: Create a backup datastore

The next step is to create a backup datastore in OpenNebula. This datastore will be used by the oVirtAPI module to handle the backup of the virtual machines before sending the backup data to Veeam. Currently only [Rsync Datastore]({{% relref "../../../product/cloud_clusters_infrastructure_configuration/backup_system_configuration/rsync.md" %}}) is supported. 

{{< alert title="Remember" color="success" >}}
The backup datastore must be created in the backup server configured in step 1. Also remember to add this datastore to any cluster that you want to be able to back up.{{< /alert >}} 

**Rsync Datastore**

Here is an example to create an Rsync datastore in a host named "backup-host" and then add it to a given cluster:


    # Create the Rsync backup datastore
    cat << EOF > /tmp/rsync-datastore.txt
    NAME="VeeamDS"
    DS_MAD="rsync"
    TM_MAD="-"
    TYPE="BACKUP_DS"
    VEEAM_DS="YES"
    RESTIC_COMPRESSION="-"
    RESTRICTED_DIRS="/"
    RSYNC_HOST="localhost"
    RSYNC_USER="oneadmin"
    SAFE_DIRS="/var/tmp"
    EOF

    onedatastore create /tmp/rsync-datastore.txt

    # Add the datastore to the cluster with "onecluster adddatastore <cluster-name> <datastore-name>"
    onecluster adddatastore somecluster VeeamDS

You can find more details regarding the Rsync datastore in [Backup Datastore: Rsync]({{% relref "../../../product/cloud_clusters_infrastructure_configuration/backup_system_configuration/rsync.md" %}}).

**Sizing recommendations**

The backup datastore need to have enough size to hold the disks of the VMs that are going to be backed up. This introduces a layer of redundancy to the backups, as they will be stored in the OpenNebula Backup Datastore and the Veeam Backup Storage. This is something inherent to the Veean integration with oVirt, as further backups of a virtual machine will be incremental and only the changed disk regions will be retrieved.

If storage becomes a constraint, we recommend cleaning up the OpenNebula Backup Datastore regularly in order to minimize the storage requirement, but keep in mind that this will reset the backup chain and force Veeam to perform a full backup and download the entire image during the next backup job.

## Step 3: Install and configure the oVirtAPI module

In order to install the oVirtAPI module, you need to have the OpenNebula repository configured in the backups server. You can do this by following the instructions in [OpenNebula Repositories]({{% relref "../../../software/installation_process/manual_installation/opennebula_repository_configuration.md" %}}). Then, follow the steps below:

1. Install the ``opennebula-ovirtapi`` package in the backup server.
2. Change the ``one_xmlrpc`` variable in the configuration file ``/etc/one/ovirtapi/ovirtapi-server.yml`` and make sure it points to your OpenNebula front-end address.
3. You must also place a certificate at ``/etc/one/ovirtapi/ovirtapi-ssl.crt`` or generate one with:

    ``openssl req -newkey rsa:2048 -nodes -keyout /etc/one/ovirtapi/ovirtapi-ssl.key -x509 -days 365 -out /etc/one/ovirtapi/ovirtapi-ssl.crt -subj "/C=US/ST=State/L=City/O=Organization/OU=OrgUnit/CN=example.com"``

4. Start the oVirtAPI module with:

    ``systemctl start opennebula-ovirtapi``

## Step 4: Add OpenNebula to Veeam

To add OpenNebula as a hypervisor to Veeam, configure it as an oVirt KVM Manager in Veeam and choose the IP address of the oVirtAPI module. You can follow the [official Veeam documentation](https://helpcenter.veeam.com/docs/vbrhv/userguide/connecting_manager.html?ver=6) for this step.

## Current limitations

- Volatile disks cannot be backed up. 
- Only in-place restores are supported.
