---
title: "Running Virtual Machines"
date: "2025-02-17"
description:
categories:
pageintoc: "22"
tags: ['quick start', learning, evaluation, 'VM operations', tutorial]
weight: "6"
---

<a id="running-virtual-machines"></a>

<!--# Running Virtual Machines -->

In previous tutorials of this Quick Start Guide, we:

> * Installed an [OpenNebula Front-end using miniONE]({{% relref "try_opennebula_on_kvm#try-opennebula-on-kvm" %}}), and
> * Deployed a [Metal Edge Cluster]({{% relref "provisioning_edge_cluster#first-edge-cluster" %}}) on AWS.

In this tutorial, we’ll use that infrastructure to deploy a fully-configured virtual machine with a ready-to-use WordPress installation, in under five minutes.

We’ll follow these high-level steps:

> 1. Download the WordPress Appliance from the OpenNebula Marketplace.
> 2. Instantiate the Virtual Machine for the Appliance.
> 3. Verify the Installation by Connecting to WordPress.

{{< alert title="Important" color="success" >}}
As mentioned above, in this tutorial we’ll deploy to the Edge Cluster created previously in this Quick Start Guide. To complete this tutorial, you need the Edge Cluster up and running.{{< /alert >}} 

## Step 1. Download the WordPress Appliance from the OpenNebula Marketplace

The [OpenNebula Public Marketplace](https://marketplace.opennebula.io) is a repository of Virtual Machines and appliances which are curated, tested and certified by OpenNebula.

To access the Marketplace, first log in to Sunstone on your OpenNebula Front-end, as user `oneadmin`.

Open the left-hand pane (by hovering the mouse over the icons on the left), then select **Storage**, then **Apps**.

![image](/images/sunstone-select_apps.png)
<br/>

Sunstone will display the **Apps** screen, showing the first page of apps that are available for download.

![image](/images/sunstone-apps_list.png)
<br/>

Search for the app called **Service WordPress - KVM**. If it’s not on the list, type `wordpress` in the search field at the top, to filter by name.

![image](/images/sunstone-apps-word_filter.png)
<br/>

Click **Service WordPress - KVM** to select it, then click the **Import into Datastore** ![icon1](/images/icons/sunstone/import_into_datastore.png) icon:

![image](/images/sunstone-import_wordp_to_ds.png)
<br/>

Sunstone will display the **Download App to OpenNebula** dialog:

![image](/images/sunstone-download_app.png)
<br/>

Click **Next**. In the next screen, we’ll need to select a datastore. For efficiency, and to try out the cluster created in [Provisioning an Edge Cluster]({{% relref "provisioning_edge_cluster#first-edge-cluster" %}}), select the `aws-cluster-image` datastore:

![image](/images/aws_cluster_images_datastore.png)
<br/>

Click **Finish**. Sunstone will download the appliance template and display basic information for the appliance, shown below in the **Info** tab:

![image](/images/sunstone-wordpress_info.png)
<br/>

Wait for the appliance **State** to indicate **READY**. When it does, the VM will be ready to be instantiated.

## Step 2. Instantiate the VM

In the left-hand pane, click **Templates**, then **VM Templates**:

![image](/images/sunstone-vm_templates.png)
<br/>

Select **Service WordPress - KVM**, then click the **Instantiate** ![icon2](/images/icons/sunstone/instantiate.png) icon at the top:

![image](/images/sunstone-vm_instantiate.png)
<br/>

Sunstone will display the first screen of the **Instantiate VM Template** wizard:

![image](/images/sunstone-vm_instantiate_wiz1.png)
<br/>

Feel free to modify the VM’s capacity according to your requirements, or leave the default values.

Click **Next**. Sunstone displays the **User Inputs** screen, where you can modify parameters such as the security credentials for the site administrator, or SSL certificates.

![image](/images/sunstone-vm_instantiate_wiz2.png)
<br/>

Click **Next**. Sunstone displays the last screen of the wizard, **Advanced Options**:

![image](/images/sunstone-vm_instantiate_wiz3.png)
<br/>

In this screen we need to specify what network the VM will connect to. Select the **Network** tab, then click the **Attach NIC** button:

![image](/images/sunstone-vm_instantiate_wiz4-attach_nic.png)
<br/>

Sunstone will display a wizard with network parameters:

![image](/images/sunstone-vm_instantiate-attach_nic1.png)
<br/>

Click **Next**. Sunstone displays the **Select a network** screen:

![image](/images/select_aws_cluster_public_network.png)
<br/>

Select `aws-cluster-public`, then click **Next**. Sunstone displays the **Network values** screen:

![image](/images/sunstone-vm_instantiate-attach_nic1_network_values.png)
<br/>

Click **Next**. Sunstone displays the final screen, **Select QoS**:

![image](/images/sunstone-vm_instantiate-attach_nic3.png)
<br/>

To instantiate the VM, click **Finish**. Sunstone will take you to the last screen of the **Instantiate VM Template** wizard. To deploy the VM, click **Finish**.

Sunstone will deploy the VM to the AWS edge cluster, and display the **VMs** screen with the status of the VM. When the VM is running — as indicated by the green dot — it will be ready for your first login.

![image](/images/sunstone-wordpress.png)
<br/>

{{< alert title="Note" color="success" >}}
The VNC icon ![icon3](/images/icons/sunstone/VNC.png) displayed by Sunstone does not work for accessing VMs deployed on Edge Clusters, since this access method is considered insecure and is disabled by OpenNebula.{{< /alert >}} 

## Step 3. Connect to WordPress

Select the public IP of the VM, which is highlighted in bold (blurred in the screen shown above). Simply enter the IP in your browser, and you’ll be greeted by the famous five-minute WordPress installation process.

![wordpress_install_page](/images/wordpress_install_page.png)

That’s it — you have a working OpenNebula cloud with a WordPress up and running. Congratulations!
