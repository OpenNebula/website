---
title: "WHMCS Tenants Module Install/Update"
date: "2025-02-17"
description:
categories:
pageintoc: "144"
tags:
weight: "2"
---

<a id="whmcs-tenants-instcfg"></a>

<!--# WHMCS Tenants Module Install/Update -->

{{< alert title = "Warning" color = "warning" >}}
You must use PHP 7.4; currently PHP 8.x will cause an error when creating the user.
{{< /alert >}}

The install and update process are essentially identical. The module files can be found in  `/usr/share/one/whmcs` after you have installed the `opennebula-whmcs-tenants` package via your package manager. You will just need to merge the `modules` directory to the main WHMCS directory on the server hosting WHMCS. When updating the module just copy the files on top of the existing files and overwrite them. An example command for copying the files is here:

```default
cp -rf /usr/share/one/whmcs/modules /path/to/web/root/whmcs/.
```

{{< alert title="Note" color="success" >}}
Make sure you download the updated package from the EE repository before doing either an install or an update.{{< /alert >}} 

# WHMCS Tenants Module Configuration

In this Chapter we will go over adding a server, creating the group for it, and configuring a product.

## Adding a Server

![image](/images/whmcs_tenants_system_settings.png)

To configure your WHMCS Tenants Module, first log in to your WHMCS admin area and navigate to **System Settings** -> **Servers** and click on the button **Add New Server**.

![image](/images/whmcs_tenants_add_server.png)

Fill in the **Hostname** for your OpenNebula Server. Under the **Server Details** section select **OpenNebula Tenants** as the module and fill in the **Username** and **Password** with a user in the *oneadmin* group in your OpenNebula installation.

Now click the button on top labeled **Go to Advanced Mode**.  This will open a larger form. Fill in a name for the server and scroll down to the bottom to verify that the port and SSL settings are correct. By default, the XML-RPC traffic is not encrypted with SSL so you may need to disable that unless you’ve [set up SSL for XML-RPC](https://support.opennebula.pro/hc/en-us/articles/5101146829585).

Once these are filled out, click the **Test Connection** button to verify the module can authenticate with your OpenNebula server.

Don't forget to hit the **Save Changes** button once this is verified in order to complete adding the server.

## Creating a Server Group

After the server is added it should return you to the list of servers. Here you can click the **Create New Group** button to make a server group to contain your OpenNebula Server(s).

Fill in the **Name** of your Server Group, then highlight your OpenNebula Server and click **Add** to add it to your new group.  Once this is done, click **Save Changes**.
