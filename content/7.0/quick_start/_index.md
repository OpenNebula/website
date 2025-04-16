---
title: "Quick Start"
date: "2025-02-17"
description: "From learning about OpenNebula to deploying a production-ready OpenNebula cloud"
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

The second section, [Try OpenNebula with miniONE]({{% relref "try_opennebula" %}}), consists of tutorials for quickly installing an OpenNebula cloud for purposes of evaluation, testing, and even on-premises production operations. The tutorials guide you in building progressively complex infrastructure, from a basic Front-end install to automatically deploying a Kubernetes cluster.

The third section, [Automatic Deployment of OpenNebula with OneDeploy]({{% relref "automatic_deployment_of_opennebula_with_one_deploy" %}}) contains an overview and tutorials for automatically installing a production-grade OpenNebula cloud using OneDeploy, an automated installation tool based on Ansible playbooks. -->

<!-- {{< alert title="Note" color="success" >}}
This would not be the final text but a "proof of concept" for presenting the contents of the Quick Start around these 3 concepts.{{< /alert >}} -->

## Learn

Gain a high-level view of OpenNebula, its key concepts and features. View the pathway to designing and deploying an OpenNebula cloud.

{{< card header="**Understand OpenNebula**" >}}
<p></p>
<a href="understand_opennebula/opennebula_concepts"><b>OpenNebula Concepts</b></a>
   <inl>
      <a href="understand_opennebula/opennebula_concepts/opennebula_overview">OpenNebula Overview</a>
   </inl>
   <inl>
      <a href="understand_opennebula/opennebula_concepts/key_features">Key Features</a>
   </inl>
   <inl>
      <a href="understand_opennebula/opennebula_concepts/cloud_access_model_and_roles">Cloud Access Model and Roles</a>
   </inl>
   <inl>
      <a href="understand_opennebula/opennebula_concepts/knowledge_base">Knowledge Base</a>
   </inl>
   <inl>
      <a href="understand_opennebula/opennebula_concepts/use_cases">Use Cases</a>
   </inl>
<p></p>
<a href="understand_opennebula/cloud_architecture_and_design/"><b>Cloud Architecture and Design</b></a>
   <inl>
      <a href="understand_opennebula/cloud_architecture_and_design/cloud_architecture_design">Cloud Architecture Design</a>
   </inl>
   <inl>
      <a href="understand_opennebula/cloud_architecture_and_design/edge_cloud_reference_architecture">Edge Cloud Reference Architecture</a>
   </inl>
   <inl>
      <a href="understand_opennebula/cloud_architecture_and_design/open_cloud_reference_architecture">Open Cloud Reference Architecture</a>
   </inl>

{{< /card >}}


## Evaluate

Using the miniONE installation tool, follow tutorials to quickly deploy an OpenNebula cloud for learning and evaluation. Provision a Cloud Cluster, run Virtual Machines, and deploy a Kubernetes Cluster.

{{< card header="**Try OpenNebula with miniONE**" >}}
<p></p>
<a href="try_opennebula/opennebula_learning_environment/"><b>Quick Start: OpenNebula Learning Environment</b></a>
   <inl>
      <a href="try_opennebula/opennebula_learning_environment/create_an_emulated_environment_with_minione">Create an Emulated Environment with miniONE</a>
   </inl>
<p></p>
<a href="try_opennebula/opennebula_evaluation_environment/"><b>Quick Start: OpenNebula Evaluation Environment</b></a>
   <inl>
      <a href="try_opennebula/opennebula_evaluation_environment/overview">Overview</a>
   </inl>
   <inl>
      <a href="try_opennebula/opennebula_evaluation_environment/try_opennebula_onprem">Try OpenNebula On-premises</a>
   </inl>
   <inl>
      <a href="try_opennebula/opennebula_evaluation_environment/try_opennebula_on_kvm">Try OpenNebula On AWS</a>
   </inl>
   <inl>
      <a href="try_opennebula/opennebula_evaluation_environment/try_opennebula_hosted">Try OpenNebula Hosted Front-end</a>
   </inl>
   <inl>
      <a href="try_opennebula/opennebula_evaluation_environment/provisioning_edge_cluster">Provision a Cloud Cluster</a>
   </inl>
   <inl>
      <a href="try_opennebula/opennebula_evaluation_environment/running_virtual_machines">Running Virtual Machines</a>
   </inl>
   <inl>
      <a href="try_opennebula/opennebula_evaluation_environment/running_kubernetes_clusters">Running Kubernetes Clusters</a>
   </inl>
   <inl>
      <a href="try_opennebula/opennebula_evaluation_environment/operating_edge_cluster">Operating an Edge Cluster</a>
   </inl>
{{< /card >}}

## Deploy

Follow tutorials for automatically installing a production-grade OpenNebula cloud using OneDeploy, an automated installation tool based on Ansible playbooks.

{{< card header="**Automatic Deployment with OneDeploy**" >}}
   <p></p>
      <inl>
         <a href="automatic_deployment_of_opennebula_with_one_deploy/one_deploy_overview">Overview of Automatic Deployment</a>
      </inl>
      <inl>
         <a href="automatic_deployment_of_opennebula_with_one_deploy/one_deploy_tutorial_local_ds">Deploy with Local Storage</a>
      </inl>
      <inl>
         <a href="automatic_deployment_of_opennebula_with_one_deploy/one_deploy_tutorial_shared_ds">Deploy with Shared Storage</a>
      </inl>
   {{< /card >}}
