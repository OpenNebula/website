---
title: "WHMCS Admin Usage"
date: "2025-02-17"
description:
categories:
pageintoc: "145"
tags:
weight: "3"
---

<a id="whmcs-tenants-admin"></a>

<!--# WHMCS Tenants Module Administrator Usage -->

## Creating a Product Group

Before creating products you should create groups to better organize your offerings.  To create a new product group, navigate to **System Settings** -> **Products/Services**, then click on the **Create a New Group** button there. Fill in the Product Group Name and any other pieces of this form, such as Template and Payment Gateways, then click **Save Changes** once you’re done.

## Creating a Product

Navigate to **System Settings** -> **Products/Services**.

From the Products/Services page, click on **Create a New Product**.  Select the **Product Type**, **Product Group**, and a **Product Name**.  The **Module** should be **OpenNebula Tenants**.  Once this is call done, click the **Continue** button.

![image](/images/whmcs_tenants_new_product.png)

On this page, click on the **Module Settings** tab then select **OpenNebula Tenants** for the **Module Name**, then select your recently created **Server Group**.  Here, you can fill in the maximum resources usable by this product. You can also set the ACL parameters which will be created in OpenNebula for this product.

These resource limits correlate to the [Quota]({{% relref "../../../product/cloud_system_administration/capacity_planning/quotas#quota-auth" %}}) for the Group in OpenNebula, so this will limit the amount of resources used in OpenNebula for each product.  You can also enable Metric Billing and set pricing for each of these metrics:

> * IP Addresses
> * RAM
> * CPU cores
> * Supporting Multiple VDCs
> * Datastore Images
> * Datastore Size
> * NETRX
> * NETTX

Below the resources you can determine if the User should be automatically set up or if the system should wait for the Administrator to accept the order.

![image](/images/whmcs_tenants_module_settings.png)

{{< alert title="Note" color="success" >}}
For more information about managing VDCs refer to the [Managing VDCs]({{% relref "../../../product/cloud_system_administration/multitenancy/manage_vdcs#manage-vdcs" %}}) page.{{< /alert >}} 

The **Upgrades** tab can also be a useful feature to make use of.  If you create multiple products with different resource quotas, you can select the products here which your users can upgrade to.  You can select multiple products by holding the Shift or Ctrl key.

## Managing Orders

To view the orders waiting to be accepted navigate to **Orders** -> **Pending Orders** on the top bar. On this page you can view the information about the client and the service they are ordering. Here you can accept, cancel, set as fraud, or delete the orders.

![image](/images/whmcs_tenants_accept_order.png)

If your product is configured to be set up after manually accepting the order, you will need to accept the order created before any changes are made in OpenNebula. This is also true for package upgrades your users might request.

Once orders are set up there is a User, Group, and ACL created which correspond to the Service in WHMCS. Then, the Quota will be created for the Group linked to this order. On the service page for the customer, they will have a Login link.

{{< alert title="Note" color="success" >}}
If there are issues when upgrading products, the user and group may need to be recreated. Any existing VMs can be assigned to the admin user temporarily while this is done. This will be fixed in a future release.{{< /alert >}} 

## Checking Metrics

To view metrics for your customers, navigate to **View/Search Clients** and click on the ID of any user. Click on the **Products/Services** tab, there should be a Metric Statistics section with a table. You can click **Refresh Now** to update the information manually.
