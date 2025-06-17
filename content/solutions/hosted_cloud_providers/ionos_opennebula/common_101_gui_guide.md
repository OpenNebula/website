---
title: "Basic OpenNebula UI Guide: VM instantiation"
description:
categories:
pageintoc: ""
tags:
weight: 4
---

After successful deployment and verification as implemented by the automations, access the OpenNebula Web UI at

[http://frontend_public_ip:2616/fireedge/sunstone](http://FRONTEND_PUBLIC_IP:2616/fireedge/sunstone) 

The default username is “oneadmin” and its password is specified in the “one_pass” variable of the inventory file.

<!-- <a id="one-marketplace"></a> -->
<!-- <img src="/images/solutions/ionos/one-marketplace.png" alt="Marketplace" class="img-maxwidth-50"> -->
![image][one-marketplace]

Instantiate the VM by clicking the icon highlighted below. And choose the previously imported image.

<a id="one-new-vm"></a>
![image][one-new-vm]

At the VM instantiation menu attach a NIC and choose the public bridge, as shown below. All other values can be left empty or their default values.

<a id="attach-nic"></a>
![image][attach-nic]

Add a PASSWORD field and specify the desired root password for the VM, then click Accept, as shown below.

<a id="one-vm-config"></a>
![image][one-vm-config]

Log in to the VM via VNC, using root user and the password previously specified, the VNC button is highlighted below.

<a id="one-vnc-connect"></a>
![image][one-vnc-connect]

Perform a manual, public connectivity test from the deployed VM, by pinging a public IP address, e.g. 8.8.8.8, as shown below.

<a id="one-vnc-connectivity-test"></a>
![image][one-vnc-connectivity-test]

Finally, as a cleanup step, terminate the VM by clicking the red “Trash can” icon, and verify that VM transitions to DONE state, as shown below.

<a id="one-terminate-vm"></a>
![image][one-terminate-vm]

# Manual VM connectivity verification {#manual-vm-connectivity-verification}

At this point the automatic verification does not verify the correct behaviour of the VXLAN networking deployed between the VMs.   
Deploy the following test VMs as shown below. This VM deployment has been demonstrated on the target architecture. For each VM deployment, follow the UI guide as detailed above with screenshots.

Log into each VM and verify the following connectivity matrix of the deployed VMs, as shown in Table 4\.

**Table 4\.** Connectivity matrix to manually test the VXLAN networking between the deployed VMs.

| *Source (row), target (column)* | VM1 | VM2 | VM3 | 8.8.8.8 (or any public IP) |
| :---- | :---- | :---- | :---- | :---- |
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
