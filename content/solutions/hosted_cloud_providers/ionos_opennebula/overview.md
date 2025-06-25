---
title: Overview
weight: 1
---

[IONOS](https://www.ionos.com/) is an internet service provider whose offerings include cloud infrastructure, services and hosting. OpenNebula supports deploying a cloud on hosted IONOS infrastructure, and managing cloud resources through the OpenNebula control interfaces. The resulting OpenNebula hosted infrastructure has been validated as part of the OpenNebula Cloud-Ready Certification Program.

To deploy and verify an OpenNebula cloud on hosted IONOS infrastructure, OpenNebula provides [Hosted Cloud IONOS](https://github.com/OpenNebula/hosted-cloud-ionos), a set of Ansible playbooks that allows you to deploy and verify an OpenNebula cloud with a few simple commands.

This guide provides a complete deployment and verification path to create an OpenNebula Hosted Cloud using IONOS infrastructure. It includes an OpenNebula Architecture specifically tailored for the IONOS infrastructure, as well as the hardware specification from the IONOS offering.

Following this guide, you can:

- Request the necessary hardware resources using the IONOS interface.
- Perform a Zero-touch deployment of OpenNebula over these resources.
- Ensure the correct operation of the resulting cloud using an automated verification procedure.

Additionally, this guide includes a brief description of how to instantiate a Virtual Machine, to help you get started on your OpenNebula Hosted Cloud.

## Basic Outline of the Deployment Procedure

Performing the deployment involves these high-level steps:

1. Create the deployment base of networked servers on IONOS.
2. Initialize the OpenNebula GitHub repository on your deployment machine.
3. Modify the repository with the parameters for your IONOS infrastructure.
4. Perform the automated deployment to the IONOS infrastructure.
5. Verify the deployment by running the automated verification command.

## Additional Information Resources

- [IONOS Data Center Designer documentation](https://docs.ionos.com/cloud/set-up-ionos-cloud/data-center-designer)
- [OpenNebula Hosted Cloud IONOS](https://github.com/OpenNebula/hosted-cloud-ionos)
- [Ansible documentation](https://docs.ansible.com/)
