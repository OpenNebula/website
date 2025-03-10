---
title: "Quick Start: OpenNebula Evaluation Environment"
date: "2025-02-17"
description:
categories:
pageintoc: "16"
tags:
weight: "2"
---

<a id="quick-start"></a>

<a id="qs"></a>

<!--# Quick Start: OpenNebula Evaluation Environment [formerly Quick Start] -->

The OpenNebula Evaluation environment is designed to help you deploy an OpenNebula environment for learning, developing or testing. By following a series of tutorials, you can progressively build infrastructure from an OpenNebula **Front-end** to provisioning an **Edge Cluster**, running a **Virtual Machine**, and finally deploying a **Kubernetes cluster**.

All tutorials use OpenNebula’s **Sunstone** web UI, and most take under ten minutes to complete. The Quick Start is by far the fastest way to familiarize yourself with OpenNebula.

* [Overview]({{% relref "overview" %}})
* [Try OpenNebula Front-end On-prem]({{% relref "try_opennebula_onprem" %}})
  * [Step 1: Ensure System Requirements]({{% relref "try_opennebula_onprem#step-1-ensure-system-requirements" %}})
  * [Step 2: Download and Install miniONE]({{% relref "try_opennebula_onprem#step-2-download-and-install-minione" %}})
  * [Step 3: Verify the Installation]({{% relref "try_opennebula_onprem#step-3-verify-the-installation" %}})
  * [Additional Installation Options]({{% relref "try_opennebula_onprem#additional-installation-options" %}})
  * [Next Steps]({{% relref "try_opennebula_onprem#next-steps" %}})
* [Try OpenNebula Front-end on AWS]({{% relref "try_opennebula_on_kvm" %}})
  * [Step 1. Prepare the VM in AWS]({{% relref "try_opennebula_on_kvm#step-1-prepare-the-vm-in-aws" %}})
  * [Step 3: Download and install miniONE]({{% relref "try_opennebula_on_kvm#step-3-download-and-install-minione" %}})
  * [Step 4: Verify the Installation]({{% relref "try_opennebula_on_kvm#step-4-verify-the-installation" %}})
  * [Next Steps]({{% relref "try_opennebula_on_kvm#next-steps" %}})
* [Try OpenNebula Hosted Front-end]({{% relref "try_opennebula_hosted" %}})
  * [Step 1: Request a PoC]({{% relref "try_opennebula_hosted#step-1-request-a-poc" %}})
  * [Step 2: Configure Access to Your Cloud]({{% relref "try_opennebula_hosted#step-2-configure-access-to-your-cloud" %}})
  * [Step 3. (Optional) Install the CLI]({{% relref "try_opennebula_hosted#step-3-optional-install-the-cli" %}})
  * [Exploring Sunstone and the Hosted Infrastructure]({{% relref "try_opennebula_hosted#exploring-sunstone-and-the-hosted-infrastructure" %}})
* [Provisioning a Cloud Cluster]({{% relref "provisioning_edge_cluster" %}})
  * [Brief Overview of the Provision]({{% relref "provisioning_edge_cluster#brief-overview-of-the-provision" %}})
  * [Step 1: Configure AWS]({{% relref "provisioning_edge_cluster#step-1-configure-aws" %}})
  * [Step 2: Create an AWS Provider in Sunstone]({{% relref "provisioning_edge_cluster#step-2-create-an-aws-provider-in-sunstone" %}})
  * [Step 3: Provision a Metal Edge Cluster]({{% relref "provisioning_edge_cluster#step-3-provision-a-metal-edge-cluster" %}})
  * [Step 4: Validate the New Infrastructure]({{% relref "provisioning_edge_cluster#step-4-validate-the-new-infrastructure" %}})
  * [Connecting to the Edge Cluster]({{% relref "provisioning_edge_cluster#connecting-to-the-edge-cluster" %}})
  * [Next Steps]({{% relref "provisioning_edge_cluster#next-steps" %}})
* [Running Virtual Machines]({{% relref "running_virtual_machines" %}})
  * [Step 1. Download the WordPress Appliance from the OpenNebula Marketplace]({{% relref "running_virtual_machines#step-1-download-the-wordpress-appliance-from-the-opennebula-marketplace" %}})
  * [Step 2. Instantiate the VM]({{% relref "running_virtual_machines#step-2-instantiate-the-vm" %}})
  * [Step 3. Connect to WordPress]({{% relref "running_virtual_machines#step-3-connect-to-wordpress" %}})
* [Running Kubernetes Clusters]({{% relref "running_kubernetes_clusters" %}})
  * [A Preliminary Step: Remove `REPLICA_HOST`]({{% relref "running_kubernetes_clusters#a-preliminary-step-remove-replica-host" %}})
  * [Step 1. Download the OneKE Service from the OpenNebula Marketplace]({{% relref "running_kubernetes_clusters#step-1-download-the-oneke-service-from-the-opennebula-marketplace" %}})
  * [Step 2. Instantiate a Private Network on the Edge Cluster]({{% relref "running_kubernetes_clusters#step-2-instantiate-a-private-network-on-the-edge-cluster" %}})
  * [Step 3. Instantiate the Kubernetes Service]({{% relref "running_kubernetes_clusters#step-3-instantiate-the-kubernetes-service" %}})
  * [Step 4. Deploy an Application]({{% relref "running_kubernetes_clusters#step-4-deploy-an-application" %}})
  * [Known Issues]({{% relref "running_kubernetes_clusters#known-issues" %}})
* [Operating an Edge Cluster]({{% relref "operating_edge_cluster" %}})
  * [Cluster]({{% relref "operating_edge_cluster#cluster" %}})
  * [Hosts]({{% relref "operating_edge_cluster#hosts" %}})
  * [Datastores]({{% relref "operating_edge_cluster#datastores" %}})
  * [Virtual Networks: Public]({{% relref "operating_edge_cluster#virtual-networks-public" %}})
  * [Virtual Networks: Private]({{% relref "operating_edge_cluster#virtual-networks-private" %}})
