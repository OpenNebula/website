---
title: Overview
weight: 1
---

This guide provides a complete deployment and verification path to create an OpenNebula Hosted Cloud using IONOS infrastructure, as part of the OpenNebula Ready Certification Program. It includes an OpenNebula Architecture specifically tailored for the IONOS infrastructure, as well as the hardware specification from the IONOS offering.

The guide provides instructions on how to request these resources using the IONOS interface and perform a ZeroTouch deployment of OpenNebula over them. It also provides an automated verification procedure to ensure the correct functioning of the resulting cloud.

Lastly, it includes a guide covering the basics to start using the OpenNebula Hosted Cloud.

The target high-level cloud architecture overview is shown below. Two hosts are deployed: the first for hosting the OpenNebula Front-end services and VMs, the second for hosting VMs only. Both machines should have a public IP, which is used to manage the nodes. The figure below also shows the target reference VMs to be deployed for testing purposes. At least one VM must be accessible to configure with a public IP, and all of them shall be connected to the VXLAN network.

![><][high-level]

[high-level]: /images/solutions/ionos/high-level-architecture.png
