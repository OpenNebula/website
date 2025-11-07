---
title: "Validate Certified Hardware Deployments"
linkTitle: "Validation"
date: "2025-07-16"
categories:
pageintoc: ""
tags:
weight: 4
---

<a id="validate-certified-hardware"></a>

{{< alert title="Tip" color="success" >}}
This guide provides the basic steps. If you wish to see a more detailed guide, please refer to [Deploying a Virtual Machine Locally]({{% relref "deploy_opennebula_onprem_with_minione#deploying-a-virtual-machine-locally" %}}).
{{< /alert >}}

After successfully verifying the infrastructure deployed by the automations, to run a Virtual Machine access the OpenNebula web UI at:

`http://<Front-end IP>:2616/fireedge/sunstone`

To log in, use the default username `oneadmin`, and the password specified in the `one_pass` variable of the inventory file.

The image below shows the **Alpine Linux 3.20** Virtual Machine included in the OpenNebula installation:

<a id="one-marketplace"></a>
![><][one-marketplace]

{{< alert title="Warning" color="warning" >}}
Make sure to choose the correct variant of the image, which fits the certified hardware's architecture. For example for ARM-based architectures the correct Alpine Linux 3.20 Virtual Machine template is **Alpine Linux 3.20 (aarch64)**.
{{< /alert >}}

To instantiate the VM, in the Sunstone UI's left-hand menu go to **Instances** --> **VMs**. Click the **Create** icon highlighted below, then select the Virtual Machine image. Follow the steps of the VM instantiation wizard. For this basic guide, all values can be left empty or at their defaults.

<a id="one-new-vm"></a>
![><][one-new-vm]

Add a `PASSWORD` field and specify the desired root password for the VM, then click **Accept**, as shown below.

<a id="one-vm-config"></a>
![image][one-vm-config]

Log in to the VM via VNC (click the screen icon on the right). Log in as user `root` with the password that you specified in the previous step.

<a id="one-vnc-connect"></a>
![image][one-vnc-connect]

After accessing the deployed VM's command line interface, verify that the terminal is responsive. For example, change to the home folder of user `root`:

```bash
root@vm:~# cd ~
root@vm:~# pwd
/root
```

Finally, as a cleanup step, terminate the VM by clicking the red “Trash can” icon, then verify that the VM transitions to state `DONE`, as shown below.

<a id="one-terminate-vm"></a>
![image][one-terminate-vm]

[one-marketplace]: /images/guides/common_101_ui/one-marketplace.png
[one-new-vm]: /images/guides/common_101_ui/one-new-vm.png
[one-vm-config]: /images/guides/common_101_ui/one-vm-config.png
[one-vnc-connect]: /images/guides/common_101_ui/one-vnc-connect.png
[one-terminate-vm]: /images/guides/common_101_ui/one-terminate-vm.png
