---
title: "Sunstone Labels"
linkTitle: "Labels"
date: "2025-02-17"
description:
categories:
pageintoc: "48"
tags:
weight: "4"
---

<a id="sunstone-labels"></a>

<!--# Sunstone Labels -->

Labels can be defined for most of the OpenNebula resources from the Admin view.

Depending on the type of label used, _the label information will be stored under either the_ **user** _or_ **group** _template_.

![labels_edit](/images/sunstone_labels_edit.png)

This feature enables the possibility to _group the different resources_ under a given label and filter them in the Admin and Cloud views. The user will be able to easily find the template to instantiate __or select a set of resources_ to apply a given action.

![labels_filter](/images/sunstone_labels_filter.png)

## Label creation

To create a label, select one or more resources, then press the **New label** button.

![labels_create](/images/sunstone_labels_create.png)

This will open the **Create Label** modal, which can be used to create user and group labels.

![labels_create_modal](/images/sunstone_labels_create_modal.png)

{{< alert title="Warning" color="warning" >}}
Only group admins can apply and create group labels. However they will still be visible to all members of the group.{{< /alert >}}

![labels_create](/images/sunstone_labels_create.png)

This will open the **Create Label** modal, which can be used to create user and group labels.

![labels_create_modal](/images/sunstone_labels_create_modal.png)

{{< alert title="Warning" color="warning" >}}
Only group admins can apply and create group labels. However they will still be visible to all members of the group.{{< /alert >}}

## System labels

In order to create a set of labels that will be displayed to all users across all groups, you can define a public group, which will be used to store this information.

```bash
onegroup create "systemLabels"
#ID: 100
```

Then define a broad ACL, allowing all users to access this group with USE permissions:

```bash
oneacl create "* GROUP/#100 USE"
#ID: 10
```

Now all users will have USE permissions on this group, even though they aren't a member of this group. This means they can read the group's template data, which Sunstone uses when displaying labels to users. For more fine-grained control you can create different groups for storing labels and regulate their access level using the ACLs.

{{< alert title="Tip" color="info" >}}
In order to allow a user to control the system labels, they can be added to the "system labels" group with group admin permissions. {{< /alert >}} 

### Default labels

In order to define a set of default labels that will be used to populate either a user or groups template, one can use the following [configuration file](https://github.com/OpenNebula/one/blob/8eae7221946b5003fc9d354d358503828248c6fd/src/fireedge/etc/sunstone/default-labels.yaml).

For example to create a persistent system label, the following configuration can be applied:

```yaml
group:
  system labels:
    public:
      virtual-network:
        - "1"
        - "2"
    private:
      virtual-network:
        - "3"
        - "4"
```

{{< alert title="Tip" color="info" >}}
A user will only see the labels on the resources they have access to, meaning it is fine to be overly-expressive here, as this does not affect the resource permissions in any way.{{< /alert >}} 

The following list of resource names can be used:

* `marketplace-app`
* `backup`
* `datastore`
* `host`
* `image`
* `security-group`
* `virtual-data-center`
* `vrouter`
* `vrouter-template`
* `vm-template`
* `vm`
* `virtual-network`
* `backupjobs`

