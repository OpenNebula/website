---
title: "Self-service Cloud View"
date: "2025-02-17"
description:
categories:
pageintoc: "46"
tags:
weight: "2"
---

<a id="cloud-view"></a>

<!--# Self-service Cloud View -->

This is a simplified view intended for cloud consumers that just require a portal where they can provision new VMs easily. To create new VMs and Services, they just have to select one of the available Templates prepared by the administrators.

![sunstone_cloud_dash](/images/sunstone_cloud_dash.png)

## Using the Cloud

### Create VM

In this scenario the cloud administrator must prepare a set of Templates and Images to make them available to the cloud users. These resources must be **ready** to be used.

E.g. when template attributes are defined as mandatory, users can optionally **customize the VM capacity**, **resize disks**, **add new Network Interfaces** and **provide values required by the template**. Read tips on how to [prepare VM Templates for End-Users]({{% relref "../../virtual_machines_operation/virtual_machine_images/vm_templates#vm-templates-endusers" %}}).

![sunstone_cloud_create_vm](/images/sunstone_cloud_create_vm.png)

<a id="cloudview-ssh-keys"></a>

### Access the VMs with SSH Keys

Any user can provide his own ssh public key to be included in the VMs created through this view. This requires the VM guest to be [contextualized]({{% relref "../../virtual_machines_operation/virtual_machine_images/vm_templates#context-overview" %}}), and the Template must have the ssh **contextualization enabled**.

![sunstone_cloud_add_ssh_key](/images/sunstone_cloud_add_ssh_key.png)

### Manage VMs

The status of the virtual machines can be monitored from the **VMs tab**.

![sunstone_cloud_vms_list](/images/sunstone_cloud_vms_list.png)

Information about the capacity, operating system, ips, creation time and monitoring graphs for a specific VM are available in the **detail view**.

![sunstone_cloud_vm_info](/images/sunstone_cloud_vm_info.png)

Users can perform the following actions from this view:

* Access the VNC console, but only if it’s configured in the Template.
* Reboot the VM, the user can send the reboot signal (`reboot`) or reboot the machine (`reboot hard`).
* Power off the VM, the user can send the power off signal (`poweroff`) or power off the machine (`poweroff hard`).
* Terminate the VM.
* Save the VM into a new Template.
* Power on the VM.

<a id="save-vm-as-template-cloudview"></a>

<a id="cloudview-persistent"></a>

### Make the VM Changes Persistent

Users can create a persistent private copy of the available templates. A **persistent copy will preserve the changes** made to the VM disks after the instance is terminated. This **template is private**, and will only be listed to the owner user.

To create a persistent copy, use the **Persistent** switch:

![sunstone_persistent_vm](/images/sunstone_persistent_vm.png)

Alternatively, a VM that wasn’t created as persistent can be saved before it’s destroyed. To do so, the user has to `power off` the VM first and then use the `save` operation.

![sunstone_save_vm_1](/images/sunstone_save_vm_1.png)
![sunstone_save_vm_2](/images/sunstone_save_vm_2.png)

Any of the these two actions will create a new Template. This Template can be used to create **restore the state of a VM after deletion**. This template contains a copy of each one of the original disk images.

{{< alert title="Warning" color="warning" >}}
If you delete this template, all the disk contents will be also lost.{{< /alert >}} 

![sunstone_save_vm_3](/images/sunstone_save_vm_3.png)

{{< alert title="Note" color="success" >}}
**Avoid making a persistent copy of a persistent copy!** Although there are use cases where it is justified, you will end with a long list of Templates and the disk usage quota will decrease quickly.{{< /alert >}} 

For more details about the limitations of saved VM, continue to the [Managing Virtual Machines guide]({{% relref "../../virtual_machines_operation/virtual_machine_instances/vm_instances#vm-guide2-clone-vm" %}}).

### Create Service

In the same way that instantiating a VM, the cloud administrator must prepare a set of Service Templates. Before instantiating them, users can optionally **customize the Service cardinality**, **define the network interfaces** and **provide values required by the template**.

![sunstone_cloud_create_service](/images/sunstone_cloud_create_service.png)

### Manage Services

The status of the Services can be monitored from the Services tab.

![sunstone_cloud_services_list](/images/sunstone_cloud_services_list.png)

Information of the creation time, cardinality and status for each Role are available in the **detail view**.

![sunstone_cloud_service_info](/images/sunstone_cloud_service_info.png)

Users can perform the following actions from this view:

* Change the cardinality of each Role
* Retrieve the VMs of each Role
* Delete the Service
* Recover the Service from a fail status

### Usage, Accounting and Showback

From the user settings dialog, the user can check his current **change account configuration** like his password, language, ssh key and view:

![sunstone_cloud_user_settings](/images/sunstone_cloud_user_settings.png)

From the user dialog, the user can check his current **quotas**, **accounting**, **showback** information:

![sunstone_cloud_user_quotas](/images/sunstone_cloud_user_quotas.png)
