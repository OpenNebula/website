---
title: "Veeam Backup (EE)"
weight: "1"
---

Veeam is a backup and recovery software that provides data protection and disaster recovery solutions for virtualized environments. The OpenNebula oVirtAPI Server allows users to back up OpenNebula VMs from the Veeam interface.

## Compatibility

The oVirtAPI module is compatible with the Veeam Backup & Replication version specified in the [Platform Notes]({{% relref "../../../software/release_information/release_notes_70/platform_notes/#monitoring-and-backups" %}}).

The following table summarizes the supported backup modes for each storage system:

<table class="docutils align-default" style="border-collapse: collapse; width: 100%; text-align: center;">
  <thead>
    <tr>
      <th class="head" rowspan="2" style="min-width: 120px; border: 1px solid; vertical-align: middle"><p>Storage</p></th>
      <th class="head" colspan="2" style="min-width: 100px; border: 1px solid"><p>Full</p></th>
      <th class="head" colspan="2" style="min-width: 100px; border: 1px solid"><p>Incremental</p></th>
    </tr>
    <tr>
      <th class="head" style="min-width: 100px; border: 1px solid"><p>Live</p></th>
      <th class="head" style="min-width: 100px; border: 1px solid"><p>Power off</p></th>
      <th class="head" style="min-width: 100px; border: 1px solid"><p>Live</p></th>
      <th class="head" style="min-width: 100px; border: 1px solid"><p>Power off</p></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="min-width: 120px; border: 1px solid"><p>File<sup>*</sup> (qcow2)</p></td>
      <td style="border: 1px solid"><p>Yes</p></td>
      <td style="border: 1px solid"><p>Yes</p></td>
      <td style="border: 1px solid"><p>Yes</p></td>
      <td style="border: 1px solid"><p>Yes</p></td>
    </tr>
    <tr>
      <td style="border: 1px solid"><p>File<sup>*</sup> (raw)</p></td>
      <td style="border: 1px solid"><p>Yes</p></td>
      <td style="border: 1px solid"><p>Yes</p></td>
      <td style="border: 1px solid"><p>No</p></td>
      <td style="border: 1px solid"><p>No</p></td>
    </tr>
    <tr>
      <td style="border: 1px solid"><p>Ceph</p></td>
      <td style="border: 1px solid"><p>Yes</p></td>
      <td style="border: 1px solid"><p>Yes</p></td>
      <td style="border: 1px solid"><p>No</p></td>
      <td style="border: 1px solid"><p>No</p></td>
    </tr>
    <tr>
      <td style="border: 1px solid"><p>LVM</p></td>
      <td style="border: 1px solid"><p>Yes</p></td>
      <td style="border: 1px solid"><p>Yes</p></td>
      <td style="border: 1px solid"><p>No</p></td>
      <td style="border: 1px solid"><p>No</p></td>
    </tr>
  </tbody>
</table>

<sup>\*</sup> Any datastore based on files with the given format, i.e., NFS/SAN or Local.

## Requirements & Architecture

In order to achieve a setup compatible with the OpenNebula and Veeam Backup integration, the following requirements must be met:

* A Backup Server hosting an OpenNebula Backup datastore and the OpenNebula oVirtAPI Server.
* The Veeam Backup appliance, deployed by Veeam when adding OpenNebula as a hypervisor.
* A management network must be in place connecting the following components:
     * OpenNebula Backup server
     * OpenNebula Front-end
     * All Hosts running VMs to be backed up by Veeam
     * Veeam Server
     * Veeam Backup appliance


![image](/images/backup_veeam_architecture.png)

## Step 1: Prepare the environment for the oVirtAPI Server

A server should be configured to expose both the Rsync Backup datastore and the oVirtAPI Server. This server should be accessible from all the clusters that you want to be able to back up via the management network shown in the architecture diagram. The oVirtAPI Server is going to act as the communication gateway between Veeam and OpenNebula.

## Step 2: Create a backup datastore

The next step is to create a backup datastore in OpenNebula. This datastore will be used by the oVirtAPI module to handle the backup of the Virtual Machines before sending the backup data to Veeam. Currently only [Rsync Datastore]({{% relref "../../../product/cluster_configuration/backup_system/rsync.md" %}}) is supported. An additional property called ``VEEAM_DS`` must exist in the backup datastore template and be set to ``YES``.

{{< alert title="Remember" color="success" >}}
The backup datastore must be created in the backup server configured in step 1. Also, remember to add this datastore to any cluster that you want to be able to back up.{{< /alert >}} 

**Rsync Datastore**

Here is an example of how to create an Rsync datastore in a Host named `backup-host` and then add it to a given cluster:


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

{{< alert title="SELinux/AppArmor issues" color="success" >}}
SELinux and AppArmor may cause some issues in the backup server if not configured properly. Either disable them or make sure to whitelist the datastore directories (``/var/lib/one/datastores``).
{{< /alert >}} 

You can find more details regarding the Rsync datastore in [Backup Datastore: Rsync]({{% relref "../../../product/cluster_configuration/backup_system/rsync.md" %}}).

**Sizing recommendations**

The backup datastore needs to have enough space to hold the disks of the VMs that are going to be backed up. This introduces a layer of redundancy to the backups, as they will be stored in the OpenNebula Backup datastore and the Veeam Backup storage. This is something inherent to the Veean integration with oVirt, as further backups of a Virtual Machine will be incremental and only the changed disk regions will be retrieved.

If storage becomes a constraint, we recommend cleaning up the OpenNebula Backup datastore regularly in order to minimize the storage requirement, but keep in mind that this will reset the backup chain and force Veeam to perform a full backup and download the entire image during the next backup job.

We provide alongside the ovirtapi package the ``/usr/share/one/backup_clean.rb`` script to aid in cleaning up the backup datastore. This script can be set up as a cronjob in the backup server with the oneadmin user. The following crontab example will run the script every day at 12:00 am and delete the oldest images until the backup datastore is under 50% capacity:

    0 0 * * * ONE_AUTH="oneadmin:oneadmin" MAX_USED_PERCENTAGE="50" /path/to/your/script.sh

{{< alert title="Remember" color="success" >}}
For the ``/usr/share/one/backup_clean.rb`` script to work you need to set the ONE_AUTH environment variable to a valid ``user:password`` pair that can delete the backup images. You may also set the ``MAX_USED_PERCENTAGE`` variable to a different threshold (set to 50% by default).{{< /alert >}} 

## Step 3: Install and configure the oVirtAPI module

In order to install the oVirtAPI module, you need to have the OpenNebula repository configured in the backup server. You can do so by following the instructions in [OpenNebula Repositories]({{% relref "../../../software/installation_process/manual_installation/opennebula_repository_configuration.md" %}}). Then, install the opennebula-ovirtapi package.

The configuration file can be found at ``/etc/one/ovirtapi-server.yml``. You should change the following variables before starting the service:

* ``one_xmlrpc``: Address of the OpenNebula Front-end.
* ``endpoint_port``: Port used by the OpenNebula RPC endpoint (defaults to 2633).
* ``public_ip``: Address that Veeam is going to use to communicate with the ovirtapi server.

During installation a self-signed certificate is generated at ``/etc/one/ovirtapi-ssl.crt`` for encryption. You can replace this certificate with your own and change the ``cert_path`` configuration variable.

After installing the package, you should make sure that the oneadmin user in the backup server can perform passwordless ssh towards the oneadmin user in the Front-end server. 

Finally, start the service with either ``systemctl start apache2`` (Ubuntu/Debian) or ``systemctl start httpd`` (RHEL/Alma).

{{< alert title="Important" color="success" >}}
Once the package is installed, a ``oneadmin`` user will be created. Please make sure that this user and the same ``oneadmin`` user in the frontend can establish passwordless ssh connections in both directions.
{{< /alert >}} 

{{< alert title="Package dependency" color="success" >}}
In RHEL and Alma environments, you may face issues with the passenger package dependencies (``mod_passenger`` and ``mod_ssl``). You may add the correct repository and install the packages with the following:

    curl --fail -sSLo /etc/yum.repos.d/passenger.repo https://oss-binaries.phusionpassenger.com/yum/definitions/el-passenger.repo
    dnf install -y passenger mod_passenger mod_ssl

{{< /alert >}} 

## Step 4: Add OpenNebula to Veeam

To add OpenNebula as a hypervisor to Veeam, configure it as an oVirt KVM Manager in Veeam and choose the IP address of the oVirtAPI module. You can follow the [official Veeam documentation](https://helpcenter.veeam.com/docs/vbrhv/userguide/connecting_manager.html?ver=6) for this step or follow the next steps:

### Step 4.1: Add the new virtualization manager

The first step should be to add the ovirtAPI Backup server to Veeam. Head over to **Backup Infrastructure**, then to **Managed Servers**, and then click **Add Manager**:

![image](/images/veeam/add_manager.png)

Then, choose to add a new **Virtualization Platform** and select **Oracle Linux Virtualization Manager**:

![image](/images/veeam/virtualization_platform.png)

![image](/images/veeam/virtualization_platform_olvm.png)

This will open a new dialog box. In the address field, you must make sure that it points to the IP address or DNS name of the server where the ovirtAPI module is installed and the backup datastore is hosted:

![image](/images/veeam/new_manager.png)

On the **Credentials** tab, you should set the user and password used to access the OpenNebula Front-end. You can either choose the oneadmin user or create a new user with the same privileges as oneadmin. If you are using the default certificate, you may receive an untrust certificate warning, which you can disregard:

![image](/images/veeam/one_credentials.png)

As a last step, you can click finish and the new ovirtAPI server should be listed under Managed Servers as a **oVirt KVM**hypervisor.

![image](/images/veeam/hypervisor_added.png)

### Step 4.2: Deploy the KVM appliance

In order for Veeam to be able to perform backup and restore operations, it must deploy a dedicated Virtual Machine to act as a worker. To deploy it, go to the **Backup Infrastructure** tab, then **Backup Proxies**, and click **Add Proxy**:

![image](/images/veeam/add_proxy.png)

A new dialog box will open. Select the **Oracle Linux Virtualization Manager**, then click to deploy the **Oracle Linux Virtualization Manager backup appliance**:

![image](/images/veeam/add_proxy_olvm.png)

![image](/images/veeam/add_proxy_app.png)

This will open a new wizard to deploy the appliance. You should choose to deploy a new appliance:

![image](/images/veeam/new_appliance.png)

Next you should choose the cluster on which to deploy the appliance, as well as a name and the storage domain where the appliance image should be stored: 

![image](/images/veeam/appliance_virtual_machine.png)

For the appliance credentials, you should choose the same ones that you set up when configuring the virtualization manager in the previous steps:

![image](/images/veeam/appliance_credentials.png)

In the **Network Settings** tab, choose the management network that the appliance should use. It is recommended to manually choose the IP address configuration that the appliance should use:

![image](/images/veeam/appliance_network.png)

In the next step, Veeam will take care of deploying the appliance. Once finished, you should see it listed in the same tab:

![image](/images/veeam/appliance_listed.png)

### Step 4.3: Verification

If everything is set properly, you should be able to see the available Virtual Machines in the **Inventory** tab under the **Virtual Infrastructure** -> **oVirt KVM** section.

![image](/images/veeam/verification.png)

### Logging information

The ovirtapi server will generate logs in the following directory depending on the operating system used:

* Ubuntu/Debian: ``/var/log/apache2``
* Alma/RHEL: ``/var/log/httpd``

If you use the cleanup script provided at ``/usr/share/one/backup_clean.rb``, the cleanup logs will be placed at ``/var/log/one/backup_cleaner_script.log``.

## Limitations and Known Issues

- Volatile disks cannot be backed up. They will not be displayed in the Veeam interface. 
- Veeam will not attempt incremental backups, so all backups will be full.
- When trying to start a backup job, the following error may appear. It can be solved by refreshing the backup job properties (even if no configuration is changed):

![image](/images/veeam_infra_error.png)
