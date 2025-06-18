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

Labels can be defined for most of the OpenNebula resources from the admin view.

Depending on the type of label used **the label information will be stored under either the user or group template**.

![labels_edit](/images/sunstone_labels_edit.png)

This feature enables the possibility to **group the different resources** under a given label and filter them in the admin and cloud views. The user will be able to easily find the template to instantiate **or select a set of resources** to apply a given action.

![labels_filter](/images/sunstone_labels_filter.png)

## Label creation

To create a label, select one or more resources and press the **New label** button.

![labels_create](/images/sunstone_labels_create.png)

This will open the **Create label** modal, which can be used to create user and group labels.

![labels_create_modal](/images/sunstone_labels_create_modal.png)

{{< alert title="Warning" color="warning" >}}
Only groupadmins can apply and create group labels. However they will still be visible to all members of the group.{{< /alert >}}
