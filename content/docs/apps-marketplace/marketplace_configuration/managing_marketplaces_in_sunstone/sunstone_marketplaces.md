---
title: "Marketplaces in Sunstone"
date: "2025/02/17"
description:
categories:
pageintoc: "193"
tags:
weight: "1"
---

<a id="sunstone-marketplaces"></a>

<!--# Managing Marketplaces in Sunstone -->

The [Sunstone web UI]({{% relref "../../../cloud_operation/control_plane_configuration/graphical_user_interface/fireedge_sunstone#fireedge-sunstone" %}}) allows you to graphically manage marketplaces. Within Sunstone, open the left-hand pane, then select **Storage** -> **Marketplaces** to perform the following operations:

* [Create a marketplace]({{% relref "#sunstone-marketplaces-create" %}})
* [Update a marketplace]({{% relref "#sunstone-marketplaces-update" %}})
* [Delete a marketplace]({{% relref "#sunstone-marketplaces-delete" %}})
* [Enable or disable a marketplace]({{% relref "#sunstone-marketplaces-enable" %}})
* [Change the owner or the group of a marketplace]({{% relref "#sunstone-marketplaces-change" %}})
* [Check details of a marketplace]({{% relref "#sunstone-marketplaces-details" %}})
* [See the appliances that have a marketplace]({{% relref "#sunstone-marketplaces-appliances" %}})

{{< alert title="Note" color="success" >}}
Only [OpenNebula Systems]({{% relref "../public_marketplaces/opennebula#market-one" %}}), [LinuxContainers]({{% relref "../public_marketplaces/lxc#market-linux-container" %}}), [HTTP]({{% relref "../private_marketplaces/market_http#market-http" %}}) and [S3]({{% relref "../private_marketplaces/market_s3#market-s3" %}}) marketplaces could be created with Sunstone.{{< /alert >}} 

![marketplace_dashboard](/images/marketplaces/dashboard.png)

<a id="sunstone-marketplaces-create"></a>

## Create a Marketplace

1. Click on the create button:

![marketplace_create1](/images/marketplaces/create_1.png)

2. Fill the name, description and type of the marketplace:

![marketplace_create2](/images/marketplaces/create_2.png)

3. Fill the fields of the marketplace. Depending on the marketplace type, these fields are different. Please, see [Public]({{% relref "../public_marketplaces/index#public-marketplaces" %}}) and [Private]({{% relref "../private_marketplaces/index#private-marketplaces" %}}) marketplaces documentation):

![marketplace_create3](/images/marketplaces/create_3.png)

<a id="sunstone-marketplaces-update"></a>

## Update a Marketplace

Select a marketplace and click on the update button:

![marketplace_update](/images/marketplaces/update.png)

<a id="sunstone-marketplaces-delete"></a>

## Delete a Marketplace

Select a marketplace and click on the delete button:

![marketplace_delete](/images/marketplaces/delete.png)

<a id="sunstone-marketplaces-enable"></a>

## Enable or Disable a Marketplace

Select a marketplace and click on the enable/disable menu:

![marketplace_enable](/images/marketplaces/enable.png)

<a id="sunstone-marketplaces-change"></a>

## Change the Owner or the Group of a Marketplace

Select a marketplace and click on the change owner/change group menu:

![marketplace_change](/images/marketplaces/change.png)

<a id="sunstone-marketplaces-details"></a>

## Check Details of a Marketplace

Select a marketplace and click on Info tab to see the details of a marketplace:

![marketplace_details](/images/marketplaces/details.png)

<a id="sunstone-marketplaces-appliances"></a>

## See Appliances Available in a Marketplace

Select a marketplace and click on Apps tab to see the appliances in a marketplace:

![marketplace_apps](/images/marketplaces/apps.png)
