---
title: Overview
weight: 1
---

[Ampere](https://amperecomputing.com/) is a semiconductor design company that develops server-grade processors for cloud environments, with a focus on high performance and energy efficiency.

To deploy and verify an OpenNebula cloud Ampere hardware, OpenNebula provides a [Certified Ampere Hardware with OpenNebula software](https://github.com/OpenNebula/certified-hardware-ampere), a set of Ansible playbooks that allows you to deploy and verify an OpenNebula cloud with a few simple commands.

This guide provides a reference Ampere hardware specification, that has been used to verify OpenNebula. It includes instructions on how to perform a ZeroTouch deployment of OpenNebula on the certified hardware, and provides a reference architecture and configuration.

Following this guide, you can:

- Perform a Zero-touch deployment of OpenNebula over these resources.
- Ensure the correct operation of the resulting cloud using an automated verification procedure.

Additionally, this guide includes a brief description of how to instantiate a Virtual Machine, to help you get started on your OpenNebula Cloud.

## Basic Outline of the Deployment Procedure

Performing the deployment involves these high-level steps:

1. Clone the dedicated OpenNebula on Ampere GitHub repository on your deployment machine.
1. Modify the repository with the parameters for your Ampere servers.
1. Perform the automated deployment to the Ampere servers.
1. Verify the deployment by running the automated verification command.

## Additional Information Resources

 - [Certified Ampere Hardware with OpenNebula software](https://github.com/OpenNebula/certified-hardware-ampere)
 - [Ampere Resource Library](https://amperecomputing.com/resource-library)

