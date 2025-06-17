---
title: Overview
weight: 1
---

This guide provides a deployment and verification path to achieve an OpenNebula Hosted Cloud using IONOS infrastucture, as part of the OpenNebula Ready Certification Program.

As such it includes an OpenNebula Architecture specifically tailored for the IONOS infrastructure as well as the hardware specification from the IONOS offering. 
The guide provides instructions on how to request these resources using the IONOS interface and perform a ZeroTouch deployment of OpenNebula over them, as well as an automated verification step to ascertain the correctness of the resulting cloud.

Finally it includes a guide covering the basics to start using the OpenNebula Hosted Cloud.

The target high level cloud architecture overview is shown below, where the two hosts are deployed, one of them is hosting the OpenNebula frontend services and VMs, the other one is for hosting VMs only. Both machines should have a public IP, which is used to manage the nodes. The figure also shows the target reference VMs to  be deployed for testing purposes. At least one VM must be possible to configure with a public IP, and all of them shall be connected to the VXLAN network.

![image][high-level]

[high-level]: /images/solutions/ionos/high-level-architecture.png
