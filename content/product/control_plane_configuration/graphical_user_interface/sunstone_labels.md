---
title: "Sunstone Labels"
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
Only groupadmins can apply and create group labels. However they will still be visible to all members of the group.{{< /alert >}}
