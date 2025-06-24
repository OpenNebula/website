---
title: "Basic OpenNebula UI Guide: VM Instantiation"
description:
categories:
pageintoc: ""
tags:
weight: 4
---

This short guide explains how to access your OpenNebula cloud via the web UI and instantiate a Virtual Machine that was automatically imported when the OpenNebula cloud was created.

{{< alert title="Tip" color="success" >}}
This guide provides the basic steps. If you wish to see a more detailed guide, please refer to [Deploying a Virtual Machine Locally]({{% relref "deploy_opennebula_onprem_with_minione#deploying-a-virtual-machine-locally" %}}).
{{< /alert >}}

After successfully verifying the infrastructure deployed by the automations, to run a Virtual Machine access the OpenNebula web UI at:

`http://<Front-end public IP>:2616/fireedge/sunstone`

To log in, use the default username `oneadmin`, and the password specified in the `one_pass` variable of the inventory file.

The image below shows the Virtual Machine included in the OpenNebula installation:

<a id="one-marketplace"></a>
![image][one-marketplace]

To instantiate the VM, in the Sunstone UI's left-hand menu go to **Instances** --> **VMs**. Click the icon highlighted below, then select the Virtual Machine image.

<a id="one-new-vm"></a>
![image][one-new-vm]

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
![image][one-vnc-connectivity-test]

Finally, as a cleanup step, terminate the VM by clicking the red “Trash can” icon, then verify that the VM transitions to state `DONE`, as shown below.

<a id="one-terminate-vm"></a>
![image][one-terminate-vm]

## Manually Verifying VM Connectivity

Currently the automatic verification does not verify the correct behavior of the VXLAN networking deployed between the VMs.

To verify VXLAN networking, deploy the test VMs shown below. These VM deployments have been demonstrated on the target architecture. For each VM deployment, follow the UI guide as detailed above with screenshots.

Log into each VM and verify the following connectivity matrix of the deployed VMs, as shown in the table below.

### Table 1: Connectivity Matrix

Connectivity matrix to manually test VXLAN networking between the deployed VMs.

| Source | <th class="head" rowspan="4" style="text-align: center; font-weight: bold !important; vertical-align: bottom !important;">Targets</th> |
| :---- | :---- | :---- | :---- | :---- |
| VM1 | VM2 | VM3 | `8.8.8.8` (or any public IP) |
| **VM1** | \- | TEST | TEST | TEST |
| **VM2** | To vxlan: TEST | \- | TEST | \- |
| **VM3** | To vxlan: TEST | TEST | \- | \- |
| **Local laptop (or any public IP)** | To public: TEST | \- | \- | \- |


[one-marketplace]: /images/solutions/ionos/one-marketplace.png
[one-new-vm]: /images/solutions/ionos/one-new-vm.png
[attach-nic]: /images/solutions/ionos/attach-nic.png
[one-vm-config]: /images/solutions/ionos/one-vm-config.png
[one-vnc-connect]: /images/solutions/ionos/one-vnc-connect.png
[one-vnc-connectivity-test]: /images/solutions/ionos/one-vnc-connectivity-test.png
[one-terminate-vm]: /images/solutions/ionos/one-terminate-vm.png
