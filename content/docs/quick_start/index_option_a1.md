---
title: "Quick Start alt. option"
date: "2025-02-17"
description: "Understand, deploy and evaluate OpenNebula. Deploy a production-ready OpenNebula cloud"
categories:
no_list: true
hide_feedback: true
pageintoc: "1"
tags:
weight: "1"
---

<a id="cloud-installation"></a>

<!--# Cloud Installation -->

<!-- This first chapter is designed to quickly take you from an introduction to OpenNebula to deploying your first cloud for learning and evaluation.

The first section, [Understand OpenNebula]({{% relref "understand_opennebula" %}}), provides you with a bird's eye view of the system's base concepts, key features, architecture basics, and the most common pathway from cloud design to deployment.

The second section, [Try OpenNebula with miniONE]({{% relref "try_opennebula_with_minione" %}}), consists of tutorials for quickly installing an OpenNebula cloud for purposes of evaluation, testing, and even on-premises production operations. The tutorials guide you in building progressively complex infrastructure, from a basic Front-end install to automatically deploying a Kubernetes cluster.

The third section, [Automatic Deployment of OpenNebula with OneDeploy]({{% relref "automatic_deployment_of_opennebula_with_one_deploy" %}}) contains an overview and tutorials for automatically installing a production-grade OpenNebula cloud using OneDeploy, an automated installation tool based on Ansible playbooks. -->

{{< alert title="Note" color="success" >}}
This would not be the final text but a "proof of concept" for presenting the contents of the Quick Start around these 3 concepts.{{< /alert >}}

## Learn

Gain a bird's eye view of OpenNebula, and the pathway to designing and deploying a cloud.

#### Understand OpenNebula

{{< cardpane >}}
   {{< card header="OpenNebula concepts, features and components" >}}
      <p></p>
            <inl>
         <a href="/docs/quick_start/understand_opennebula/opennebula_concepts">OpenNebula Concepts</a>
            </inl>
            <inl>
         <a href="/docs/quick_start/understand_opennebula/key_features">Key Features</a>
            </inl>
   {{< /card >}}
   <p></p>
   {{< card header="Pathway to designing an OpenNebula cloud" >}}
      <inl>
         <a href="/docs/quick_start/understand_opennebula/cloud_architecture_and_design/cloud_architecture_design">Cloud Architecture Design</a>
      </inl>
      <inl>
         <a href="/docs/quick_start/understand_opennebula/cloud_architecture_and_design/edge_cloud_reference_architecture">Edge Cloud Architecture</a>
      </inl>
      <inl>
         <a href="/docs/quick_start/understand_opennebula/cloud_architecture_and_design/open_cloud_reference_architecture">Open Cloud Architecture</a>
      </inl>
   {{< /card >}}
{{< /cardpane >}}

<hr class="panel-line">

## Evaluate

Follow tutorials to quickly deploy an on-prem or remote cloud for learning and evaluation. Deploy and run a Cloud Cluster, a Kubernetes Cluster, and Virtual Machines.

#### Run Evaluation Environments with miniONE

{{< cardpane >}}
   {{< card header="Emulated OpenNebula environment to learn about and explore OpenNebula" >}}
      <p></p>
      <inl>
         <a href="/docs/quick_start/try_opennebula_with_minione/opennebula_learning_environment/create_an_emulated_environment_with_minione">Create an Emulated Environment</a>
      </inl>
   {{< /card >}}
   <p></p>
   {{< card header="Deploy a cloud and run Virtual Machines and Kubernetes clusters" >}}
      <p></p>
      <inl>
         <a href="/docs/quick_start/try_opennebula_with_minione/opennebula_evaluation_environment/">Deployment Tutorials</a>
      </inl>
<!--      <inl>
         <a href="try_opennebula_with_minione/opennebula_evaluation_environment/provisioning_edge_cluster">Provision a Cloud Cluster</a>
      </inl>
      <inl>
         <a href="try_opennebula_with_minione/opennebula_evaluation_environment/running_kubernetes_clusters">Deploy a Kubernetes Cluster</a>
      </inl> -->
   {{< /card >}}
{{< /cardpane >}}

<hr class="panel-line">

## Deploy

Follow tutorials for automatically installing a production-grade OpenNebula cloud using OneDeploy, an automated installation tool based on Ansible playbooks.

#### Production-ready Deployment

{{< card header="Perform an automated installation of a production-grade OpenNebula Cloud" >}}
   <p></p>
      <inl>
         <a href="/docs/quick_start/automatic_deployment_of_opennebula_with_one_deploy/one_deploy_overview">Overview of Automatic Deployment</a>
      </inl>
      <inl>
         <a href="/docs/quick_start/automatic_deployment_of_opennebula_with_one_deploy/one_deploy_tutorial_local_ds">Deploy with Local Storage</a>
      </inl>
      <inl>
         <a href="/docs/quick_start/automatic_deployment_of_opennebula_with_one_deploy/one_deploy_tutorial_shared_ds">Deploy with Shared Storage</a>
      </inl>
   {{< /card >}}
