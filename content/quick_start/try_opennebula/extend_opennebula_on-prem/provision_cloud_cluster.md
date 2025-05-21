---
title: "Provision a Cloud Cluster on a Public Cloud"
date: "2025-02-17"
description:
categories: [Learning, Evaluation, Deployment]
pageintoc: "21"
tags: ['Quick Start', OneProvision, Tutorial]
weight: "5"
---

<a id="first-edge-cluster"></a>

<!--# Provisioning an Edge Cluster -->

This page provides a brief overview of cloud cluster provisions in OpenNebula. After installing an OpenNebula Front-end with [miniONE](https://github.com/OpenNebula/minione), you can provision remote clusters on a variety of cloud providers, to deploy additional resources including [Kubernetes clusters]({{% relref "run_kubernetes_clusters_on_opennebula" %}}).

{{< alert color="success" >}}
This Beta version has removed the legacy provisioning component, incorporating internal code changes that lay the groundwork for a complete rewrite. The fully redesigned provisioning system, featuring enhanced support for additional providers, will be released in a subsequent maintenance update. This page provides a brief overview of a cloud cluster provision created in OpenNebula.
{{< /alert >}}

## Overview of the Provision

This section explains what OpenNebula creates behind the scenes when provisioning an Edge Cluster.

OpenNebula provides a ready-to-use specification for an Edge Cluster, which is comprised of resources in OpenNebula and their corresponding resources in the remote cloud provider. Together, these resources provide the functionality for running with a minimal footprint at edge locations. During provisioning, OpenNebula creates all of the cluster’s resources in OpenNebula and, with the aid of Terraform, their corresponding objects on the cloud provider.

The following resources are created *in OpenNebula*:

> * **Cluster**: each provision creates one cluster. There is a one-to-one relationship between the provision and the cluster, so each provision can only have one cluster.
> * **Datastore**: each provision deploys two datastores, for the system and the image. Datastores for edge clusters are based on OpenNebula’s [Local Storage datastores]({{% relref "../../../product/cloud_clusters_infrastructure_configuration/storage_system_configuration/local_ds#local-ds" %}}); datastores for HCI clusters are based on Ceph.
> * **Hosts**: After provisioning, you can deploy as many as desired, to run VMs.
> * **Virtual Networks**: To ensure that VMs have public connectivity, the provision includes a pre-configured private network, and a public network that pre-allocates elastic IPs.

To create the OpenNebula hosts and ensure connectivity, OpenNebula creates the following resources *in the remote provider*:

> * A **Virtual Private Cloud** (VPC) to allocate remote instances as OpenNebula hosts.
> * A **CIDR block of IPs** to assign secondary IPs to the hosts, and to allocate elastic IPs.
> * An **Internet Gateway** to provide internet access for the hosts and VMs.
> * A **routing table** for directing network traffic between these elements.

