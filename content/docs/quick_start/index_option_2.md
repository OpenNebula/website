---
title: "Quick Start (Option 2)"
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

+[NOTE: This is Option 2 for the Quick Start index page]

<a id="cloud-installation"></a>

<!--# Cloud Installation -->

<!-- This first chapter is designed to quickly take you from an introduction to OpenNebula to deploying your first cloud for learning and evaluation.

The first section, [Understand OpenNebula]({{% relref "understand_opennebula" %}}), provides you with a bird's eye view of the system's base concepts, key features, architecture basics, and the most common pathway from cloud design to deployment.

The second section, [Try OpenNebula with miniONE]({{% relref "try_opennebula_with_minione" %}}), consists of tutorials for quickly installing an OpenNebula cloud for purposes of evaluation, testing, and even on-premises production operations. The tutorials guide you in building progressively complex infrastructure, from a basic Front-end install to automatically deploying a Kubernetes cluster.

The third section, [Automatic Deployment of OpenNebula with OneDeploy]({{% relref "automatic_deployment_of_opennebula_with_one_deploy" %}}) contains an overview and tutorials for automatically installing a production-grade OpenNebula cloud using OneDeploy, an automated installation tool based on Ansible playbooks. -->

## Understand OpenNebula

Gain a bird's eye view of OpenNebula, and the pathway to designing and deploying a cloud.

{{< cardpane >}}
   {{< card header="OpenNebula Concepts" >}}
         <inl>
            <a href="../understand_opennebula/opennebula_concepts/opennebula_overview">OpenNebula Overview</a>
         </inl>
         <inl>
            <a href="../understand_opennebula/opennebula_concepts/key_features">Key Features</a>
         </inl>
   {{< /card >}}
   <p></p>
   {{< card header="OpenNebula Cloud Design" >}}
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
{{< /cardpane >}}

<hr class="panel-line">

## Try OpenNebula with miniONE

Follow tutorials to quickly deploy an on-prem or remote cloud for learning and evaluation. Deploy and run a Cloud Cluster, a Kubernetes Cluster, and Virtual Machines.

{{< cardpane >}}
   {{< card header="Quick Start: OpenNebula Learning Environment" >}}
      <p></p>
      <bxctr>
         <a href="../try_opennebula_with_minione/opennebula_learning_environment/create_an_emulated_environment_with_minione">Create Learning Environment</a>
      </bxctr>
   {{< /card >}}
   <p></p>
   {{< card header="Quick Start: OpenNebula Evaluation Environment" >}}
      <p></p>
      <inl>
         <a href="../try_opennebula_with_minione/opennebula_evaluation_environment/">Create Evaluation Environment</a>
      </inl>
      <inl>
         <a href="../try_opennebula_with_minione/opennebula_evaluation_environment/provisioning_edge_cluster">Provision a Cloud Cluster</a>
      </inl>
      <inl>
         <a href="../try_opennebula_with_minione/opennebula_evaluation_environment/running_kubernetes_clusters">Deploy a Kubernetes Cluster</a>
      </inl>
   {{< /card >}}
{{< /cardpane >}}

<hr class="panel-line">

## Automatic Deployment of OpenNebula with OneDeploy

Follow tutorials to automatically install a production-grade OpenNebula cloud using OneDeploy, an installation tool based on Ansible playbooks.

{{< card header="Deploy a production-ready OpenNebula Cloud" >}}
   <p></p>
      <inl>
         <a href="../automatic_deployment_of_opennebula_with_one_deploy/one_deploy_overview">Overview of Automatic Deployment</a>
      </inl>
      <inl>
         <a href="../automatic_deployment_of_opennebula_with_one_deploy/one_deploy_tutorial_local_ds">Deploy with Local Storage</a>
      </inl>
      <inl>
         <a href="../automatic_deployment_of_opennebula_with_one_deploy/one_deploy_tutorial_shared_ds">Deploy with Shared Storage</a>
      </inl>
   {{< /card >}}
