---
title: "Virtual Network Templates"
date: "2025-02-17"
description:
categories:
pageintoc: "87"
tags:
weight: "2"
---

<a id="vn-templates"></a>

<!--# Virtual Networks Templates -->

The Virtual Network Templates allow the end user to create Virtual Networks without knowing the details of the underlying infrastructure. Typically the administrator sets up the templates with the required physical attributes, e.g., driver or physical device information and lets the end user add all the logic information like address ranges or gateway.

Virtual Network Templates can be instantiated several times and shared between multiple users.

## Virtual Network Template Definition

A Virtual Network Template is a representation of a Virtual Network, so a template can be defined by using the same attributes available for a Virtual Network. Virtual Network Templates and Virtual Networks also share their required attributes depending on driver they are using (see the requirements [here]({{% relref "../../cluster_configuration/networking_system/manage_vnets#manage-vnets" %}}), Physical Network Attributes section).

When a network is created by instantiating a Virtual Network Template, it is associated to the default cluster. You can **control which clusters the networks** will be in with the `CLUSTER_IDS` attribute.

Here is an example of a Virtual Network Template with one address range:

```default
NAME=vntemplate
VN_MAD="bridge"
AR=[
IP="10.0.0.1",
SIZE="10",
TYPE="IP4" ]
CLUSTER_IDS="1,100"
```

The networks created by instantiating this template will be on clusters 1 and 100.

## Using Virtual Network Templates

By default just `oneadmin` can create Virtual Network Templates. If other users need permissions for creating Virtual Network Templates it can be provided by creating a specific ACL.

Once the Virtual Network Template is created, you can control access to it by its permissions. For example, if an end user needs to instantiate a specific template, it would be enough to give the template **USE** permission for others. You can find more [information about permissions here]({{% relref "../../cluster_configuration/networking_system/manage_vnets#manage-vnets" %}}).

{{< alert title="Note" color="success" >}}
Depending on the user, ACLs might need to be created in order to allow the users to manage their own networks.{{< /alert >}} 

### Operations

The available operations for Virtual Network Templates are the following:

- allocate
- instantiate
- info
- update
- delete
- chown
- chmod
- clone
- rename
- lock
- unlock

## Preparing Virtual Network Templates for End Users

First, create a Virtual Network Template and set all the attributes which need to be set to define the Virtual Network at the template like bridge, vlan id, etc.

{{< alert title="Note" color="success" >}}
Note that Virtual Network restricted attributes will be also restricted for Virtual Network Templates.{{< /alert >}} 

```default
$ cat vn_template.txt
  NAME=vntemplate
  VN_MAD="bridge"
  BRIDGE="virbr0"
$ onevntemplate create vn_template.txt
  ID: 0
```

Once the Virtual Network Template has been created, change the permissions to make it available for the users you want. In the example below all the users will be able to instantiate the template:

```default
$ onevntemplate chmod 0 604
$ onevntemplate show 0
  TEMPLATE 0 INFORMATION
  ID             : 0
  NAME           : vntemplate
  USER           : oneadmin
  GROUP          : oneadmin
  LOCK           : None
  REGISTER TIME  : 11/28 14:44:21

  PERMISSIONS
  OWNER          : um-
  GROUP          : ---
  OTHER          : u--
  TEMPLATE CONTENTS
  BRIDGE="virbr0"
  VN_MAD="bridge"

#check everything works well
$ onevntemplate instantiate 0 --user user --name private
  VN ID: 1
$ onevnet list
  ID USER          GROUP        NAME            CLUSTERS   BRIDGE  STATE  LEASES
  1  user          users        private         0          virbr0  rdy         0
```

The network is now ready. Users can create VMs and attach their interfaces to the newly created Virtual Network simply by adding `NIC = [ NETWORK = private ]` or selecting it through Sunstone.

{{< alert title="Note" color="success" >}}
Note that for using the newly created Virtual Network, the user needs to define an Address Range either during the Virtual Network Template instantiation or just by updating the Virtual Network.{{< /alert >}} 

You can also manage your Virtual Networks Templates using [Sunstone UI Interface]({{% relref "../../control_plane_configuration/graphical_user_interface/fireedge_sunstone#fireedge-sunstone" %}}). Select the **Networks Template** tab to create and operate your Virtual Networks Templates in a user-friendly way.

![image0](/images/sunstone_vnetstemplate.png)

- Create new Virtual Networks Template

![image1](/images/sunstone_vnetstemplate_create.png)
