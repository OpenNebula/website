---
title: "Quick Start (Option 5)"
date: "2025-02-17"
description: "From learning about OpenNebula to deploying a production-ready OpenNebula cloud"
#description: "Learn about OpenNebula, install an evaluation cloud, and automatically install a production-ready cloud"
#"Understand, deploy and evaluate OpenNebula. Deploy a production-ready OpenNebula cloud"
categories:
hide_feedback: true
no_list: true
pageintoc: "1"
tags:
weight: "1"
---

<a id="cloud-installation"></a>

+[NOTE: This is Option 5 for the Quick Start index page]

<!--# Cloud Installation -->

<!-- This first chapter is designed to quickly take you from an introduction to OpenNebula to deploying your first cloud for learning and evaluation.

The first section, [Understand OpenNebula]({{% relref "understand_opennebula" %}}), provides you with a bird's eye view of the system's base concepts, key features, architecture basics, and the most common pathway from cloud design to deployment.

The second section, [Try OpenNebula with miniONE]({{% relref "try_opennebula_with_minione" %}}), consists of tutorials for quickly installing an OpenNebula cloud for purposes of evaluation, testing, and even on-premises production operations. The tutorials guide you in building progressively complex infrastructure, from a basic Front-end install to automatically deploying a Kubernetes cluster.

The third section, [Automatic Deployment of OpenNebula with OneDeploy]({{% relref "automatic_deployment_of_opennebula_with_one_deploy" %}}) contains an overview and tutorials for automatically installing a production-grade OpenNebula cloud using OneDeploy, an automated installation tool based on Ansible playbooks. -->

The Quick Start is designed to help you to:

- Quickly understand the OpenNebula model, explore popular use cases, and design a cloud
- Easily deploy an OpenNebula cloud for learning and evaluation
- Automatically deploy a production-grade OpenNebula cloud

Once you've acquired a basic grasp of OpenNebula concepts, the fastest way to familiarize yourself with OpenNebula is by following the tutorials in the [OpenNebula Evaluation Environment]({{% relref "try_opennebula_with_minione/opennebula_evaluation_environment/" %}}). The tutorials use [miniONE](https://github.com/OpenNebula/minione) -- a simple installation script -- to quickly install a Front-end, then guide you through deploying cloud infrastructure using a Sunstone, OpenNebula's point-and-click web UI.

<hr class="panel-line">

{{< cardpane >}}
   {{< card header="**Understand OpenNebula**" subtitle="*High-level view*" >}}
      <p></p>
      <a href="../understand_opennebula/opennebula_concepts">OpenNebula Concepts</a>
         <inl><a href="../understand_opennebula/opennebula_concepts/opennebula_overview">OpenNebula Overview</a></inl>
         <inl><a href="../understand_opennebula/opennebula_concepts/key_features">Key Features</a></inl>
      <p></p>
      <a href="../understand_opennebula/cloud_architecture_design">Cloud Architecture and Design</a>
      <inl>
         <a href="../understand_opennebula/cloud_architecture_and_design/cloud_architecture_design">Cloud Architecture Design</a>
      </inl>
      <inl>
         <a href="../understand_opennebula/cloud_architecture_and_design/edge_cloud_reference_architecture">Edge Cloud Architecture</a>
      </inl>
      <inl>
         <a href="../understand_opennebula/cloud_architecture_and_design/open_cloud_reference_architecture">Open Cloud Architecture</a>
      </inl>
   {{< /card >}}

   {{< card header="**Evaluate OpenNebula**" subtitle="*Tutorials*" >}}
      <p></p>
         <a href="../try_opennebula_with_minione/opennebula_learning_environment/create_an_emulated_environment_with_minione">Create Learning Environment</a>
         <inl><a href="../try_opennebula_with_minione/opennebula_learning_environment/cerate_an_emulated_environment_with_minione">Create an Emulated Environment with miniONE</a></inl>
      <p></p>
         <a href="../try_opennebula_with_minione/opennebula_evaluation_environment/">Create an Evaluation Environment</a>
      <ol>
         <ni><a href="../try_opennebula_with_minione/opennebula_evaluation_environment/try_opennebula_onprem">On-prem</a></ni>
         <ni><a href="../try_opennebula_with_minione/opennebula_evaluation_environment/try_opennebula_on_kvm">On AWS</a></ni>
         <ni><a href="../try_opennebula_with_minione/opennebula_evaluation_environment/try_opennebula_hosted">On Hosted Infrastructure</a></ni>
      </ol>
      <inl>
         <a href="../try_opennebula_with_minione/opennebula_evaluation_environment/provisioning_edge_cluster">Provision a Cloud Cluster</a>
      </inl>
      <inl>
         <a href="../try_opennebula_with_minione/opennebula_evaluation_environment/running_virtual_machines">Run Virtual Machines</a>
      </inl>
      <inl>
         <a href="../try_opennebula_with_minione/opennebula_evaluation_environment/running_kubernetes_clusters">Deploy a Kubernetes Cluster</a>
      </inl>
      <inl>
         <a href="../try_opennebula_with_minione/opennebula_evaluation_environment/running_kubernetes_clusters">Deploy a Kubernetes Cluster</a>
      </inl>
   {{< /card >}}
   {{< card header="**Deploy a Cloud**" subtitle="*Tutorials*" >}}
   <p></p>
         <a href="../automatic_deployment_of_opennebula_with_one_deploy/one_deploy_overview">Overview of Automatic Deployment</a>
   <p></p>
         <a href="../automatic_deployment_of_opennebula_with_one_deploy/one_deploy_tutorial_local_ds">Deploy with Local Storage</a>
   <p></p>
         <a href="../automatic_deployment_of_opennebula_with_one_deploy/one_deploy_tutorial_shared_ds">Deploy with Shared Storage</a>
   {{< /card >}}
{{< /cardpane >}}
