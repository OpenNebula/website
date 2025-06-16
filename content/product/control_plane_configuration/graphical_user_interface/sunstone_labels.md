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

Each resource **will store the label information in its own template**, thus it can be easily edited from the CLI or Sunstone.

![labels_edit](/images/sunstone_labels_edit.png)

This feature enables the possibility to **group the different resources** under a given label and filter them in the admin and cloud views. The user will be able to easily find the template to instantiate **or select a set of resources** to apply a given action.

![labels_filter](/images/sunstone_labels_filter.png)

## Label creation

To create a label, go to the Settings section of a user and enter the name of the label.

![labels_create](/images/sunstone_labels_create.png)

{{< alert title="Warning" color="warning" >}}
When user apply a label to a resource, they can only apply the labels that they have created. The same happens with the label filter, the user can only filter by the labels that they have created.{{< /alert >}} 
