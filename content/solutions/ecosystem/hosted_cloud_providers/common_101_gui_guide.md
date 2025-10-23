---
title: "Validate Hosted Cloud Deployments"
<<<<<<<< HEAD:content/solutions/hosted_cloud_providers/validate_hosted_cloud_deployments/common_101_gui_guide.md
========
linkTitle: "Validation"
>>>>>>>> one-7.0-maintenance:content/solutions/ecosystem/hosted_cloud_providers/common_101_gui_guide.md
date: "2025-07-16"
description: "This short guide explains how to access a Hosted OpenNebula Cloud Deployment via the web UI and instantiate and access a Virtual Machine."
categories:
pageintoc: ""
tags:
weight: 2
---

<a id="validate-hosted-cloud"></a>

{{< alert title="Tip" color="success" >}}
This guide provides the basic steps. If you wish to see a more detailed guide, please refer to [Deploying a Virtual Machine Locally]({{% relref "deploy_opennebula_onprem_with_minione#deploying-a-virtual-machine-locally" %}}).
{{< /alert >}}

After successfully verifying the infrastructure deployed by the automations, to run a Virtual Machine access the OpenNebula web UI at:

`http://<Front-end public IP>:2616/fireedge/sunstone`

To log in, use the default username `oneadmin`, and the password specified in the `one_pass` variable of the inventory file.

The image below shows the **Alpine Linux 3.20** Virtual Machine included in the OpenNebula installation:

<a id="one-marketplace"></a>
![><][one-marketplace]

To instantiate the VM, in the Sunstone UI's left-hand menu go to **Instances** --> **VMs**. Click the **Create** icon highlighted below, then select the Virtual Machine image.

<a id="one-new-vm"></a>
![><][one-new-vm]

Follow the steps of the VM instantiation wizard. Ensure to attach a NIC and choose the public bridge, as shown below. All other values can be left empty or at their defaults.

<a id="attach-nic"></a>
![image][attach-nic]

Add a `PASSWORD` field and specify the desired root password for the VM, then click **Accept**, as shown below.

<a id="one-vm-config"></a>
![image][one-vm-config]

Log in to the VM via VNC (click the screen icon on the right). Log in as user `root` with the password that you specified in the previous step.

<a id="one-vnc-connect"></a>
![image][one-vnc-connect]

To test connectivity, from the deployed VM, ping a public IP address, e.g. `8.8.8.8`, as shown below.

<a id="one-vnc-connectivity-test"></a>
![><][one-vnc-connectivity-test]

Finally, as a cleanup step, terminate the VM by clicking the red “Trash can” icon, then verify that the VM transitions to state `DONE`, as shown below.

<a id="one-terminate-vm"></a>
![image][one-terminate-vm]

[one-marketplace]: /images/guides/common_101_ui/one-marketplace.png
[one-new-vm]: /images/guides/common_101_ui/one-new-vm.png
[attach-nic]: /images/guides/validate_cloud_deployment_101_ui/attach-nic.png
[one-vm-config]: /images/guides/common_101_ui/one-vm-config.png
[one-vnc-connect]: /images/guides/common_101_ui/one-vnc-connect.png
[one-vnc-connectivity-test]: /images/guides/validate_cloud_deployment_101_ui/one-vnc-connectivity-test.png
[one-terminate-vm]: /images/guides/common_101_ui/one-terminate-vm.png
