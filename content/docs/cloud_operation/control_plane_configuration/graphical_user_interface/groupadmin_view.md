---
title: "Group Admin View"
date: "2025/02/17"
description:
categories:
pageintoc: "47"
tags:
weight: "3"
---

<a id="vdc-admin-view"></a>

<a id="group-admin-view"></a>

<!--# Group Admin View -->

The role of a **Group Admin is to manage all the virtual resources of the Group**, including the creation of new users. It’s like a limited version of the cloud administrator view. You can read more about OpenNebula’s approach to Groups and VDC’s from the perspective of different user roles in the [Understanding OpenNebula]({{% relref "../../../cloud_installation/understand_opennebula/opennebula_concepts/cloud_access_model_and_roles#understand" %}}) guide.

![groupadmin_dash](/images/sunstone_groupadmin_dash.png)

## Manage Users

The Group Admin **can create new user accounts**, that will belong to the same Group.

![groupadmin_create_user](/images/sunstone_groupadmin_create_user.png)

They can also see the current resource usage of all the Group users.

![groupadmin_users](/images/sunstone_groupadmin_users.png)

And **set quota limits** for each one of them. Read chapter about how to [Usage Quotas]({{% relref "../../cloud_system_administration/capacity_planning/quotas#quota-auth" %}}) for more information.

![groupadmin_edit_quota](/images/sunstone_groupadmin_edit_quota.png)

## Manage Resources

The Group Admin can manage the Services, VMs and Templates of other users in the Group.

![groupadmin_list_vms](/images/sunstone_groupadmin_list_vms.png)

## Create Resources

The Group Admin **can create new resources** in the same way as a regular user does from the [Cloud view]({{% relref "cloud_view#cloud-view" %}}). The creation wizard for the VMs and Services are similar in the `groupadmin` and `cloud` views.

![groupadmin_instantiate](/images/sunstone_groupadmin_instantiate.png)

<a id="vdc-admin-view-save"></a>

<a id="group-admin-view-save"></a>

## Prepare Resources for Other Users

Any user of the Cloud View or Group Admin View **can save the changes** made to a VM back to a new Template, and use this Template to instantiate new VMs later. See the [VM persistency options in the Cloud View]({{% relref "cloud_view#cloudview-persistent" %}}) for more information.

The Group Admin **can also share** his own Saved Templates with the rest of the group.

For example, the Group Admin can instantiate a clean VM prepared by the cloud administrator, install software needed by other users in his Group, save it in a new Template and make it available for the rest of the group.

![groupadmin_share_template](/images/sunstone_groupadmin_share_template.png)

These shared templates will be listed to all the group users in the VM creation wizard, marked as `group`. A Saved Template created by a regular user is only available for that user and is marked as `mine`.

![groupadmin_create_vm_templates_list](/images/sunstone_groupadmin_create_vm_templates_list.png)

## Accounting & Showback

### Group Accounting & Showback

The Group info tab provides information of the **resources usage, accounting and showback** reports can be generated. These records can be configured to report the usage per VM or per user for a specific range of time.

![groupadmin_group_acct](/images/sunstone_groupadmin_group_acct.png)

![groupadmin_group_showback](/images/sunstone_groupadmin_group_showback.png)

### User Accounting & Showback

The detail view of the user provides information of their usage of resources, from this view accounting reports can be also generated for this specific user.

![groupadmin_user_acct](/images/sunstone_groupadmin_user_acct.png)

## Networking

Group administrators **can create** [Virtual Routers]({{% relref "../../virtual_machines_operation/virtual_machines_networking/vrouter#vrouter" %}}) **from Templates** prepared by the cloud administrator. These Virtual Routers can be used to connect two or more of the Virtual Networks assigned to the Group.

![groupadmin_create_vrouter](/images/sunstone_groupadmin_create_vrouter.png)
