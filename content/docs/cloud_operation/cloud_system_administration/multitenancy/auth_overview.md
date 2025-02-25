---
title: "Overview"
date: "2025/02/17"
description:
categories:
pageintoc: "113"
tags:
weight: "1"
---

<a id="auth-overview"></a>

<!--# Overview -->

OpenNebula includes a complete user & group management system.

The resources a user may access in OpenNebula are controlled by a permissions system that resembles the typical UNIX one. By default, only the owner of a resource can use and manage it. Users can easily share the resources by granting use or manage permissions to other users in her group or to any other user in the system.

Upon group creation, an associated administrator user can be created. By default this user will be able to create users in the new group, and manage non owned resources for the regular group, through the CLI and/or a special Sunstone view. Groups can also be assigned to [Virtual Data Centers]({{% relref "manage_vdcs#manage-vdcs" %}}) (VDCs).

OpenNebula comes with a default set of ACL rules that enables a standard usage. For common use cases, you don’t need to manage the [ACL rules]({{% relref "chmod#manage-acl" %}}) but they might by useful if you need a high level of permission customization.

By default, the authentication and authorization is handled by the OpenNebula Service as described above. Optionally, you can delegate it to an external module, see the [Authentication Guide]({{% relref "../authentication_configuration/overview#external-auth" %}}) for more information.

## How Should I Read This Chapter

For basic users it’s recommended to read at least the ones for **Users**, **Groups** and **Permissions** as they contain the basics on how to control and share access you your resources. The other ones which describe more advanced features that usually are only available for cloud administrators are only recommended for such type of users.

* [Managing Users]({{% relref "manage_users#manage-users" %}})
* [Managing Groups]({{% relref "manage_groups#manage-groups" %}})
* [Managing VDCs]({{% relref "manage_vdcs#manage-vdcs" %}})
* [Managing Permissions and ACLs]({{% relref "chmod#chmod" %}})
* [Sunstone Views]({{% relref "fireedge_sunstone_views#fireedge-suns-views" %}})
* [Accounting Tool]({{% relref "accounting#accounting" %}})
* [Showback]({{% relref "showback#showback" %}})

## Hypervisor Compatibility

These guides are compatible with all hypervisors.
