---
title: "Quick Start Index Option (unfinished)"
date: "2025-02-17"
toc_hide: true
description: "Understand OpenNebula - Evaluate by deploying - Deploy a production-ready cloud"
categories:
#toc_hide: true
# no_list: true
pageintoc: "1"
tags:
weight: "1"
---

<a id="cloud-installation"></a>

<!--# Cloud Installation -->

This first chapter is designed to quickly take you from an introduction to OpenNebula to deploying your first cloud for learning and evaluation.

The first section, [Understand OpenNebula]({{% relref "understand_opennebula" %}}), provides you with a bird's eye view of the system's base concepts, key features, architecture basics, and the most common pathway from cloud design to deployment.

The second section, [Try OpenNebula with miniONE]({{% relref "try_opennebula_with_minione" %}}), consists of tutorials for quickly installing an OpenNebula cloud for purposes of evaluation, testing, and even on-premises production operations. The tutorials guide you in building progressively complex infrastructure, from a basic Front-end install to automatically deploying a Kubernetes cluster.

The third section, [Automatic Deployment of OpenNebula with OneDeploy]({{% relref "automatic_deployment_of_opennebula_with_one_deploy" %}}) contains an overview and tutorials for automatically installing a production-grade OpenNebula cloud using OneDeploy, an automated installation tool based on Ansible playbooks.

## Understand OpenNebula

{{< cardpane >}}
   {{< card header="[OpenNebula Concepts](understand_opennebula/opennebula_concepts)" >}}
      <inl>
         <a href="understand_opennebula/opennebula_concepts/opennebula_overview">Overview</a>
      </inl>
      <inl>
         <a href="understand_opennebula/opennebula_concepts/key_features">Key Features</a>
      </inl>
      <inl>
         <a href="understand_opennebula/opennebula_concepts/cloud_access_models_and_roles">Cloud Access Models and Roles</a>
      </inl>
      <inl>
         <a href="understand_opennebula/opennebula_concepts/knowledge_base">Knowledge Base</a>
      </inl>
      <inl>
         <a href="understand_opennebula/opennebula_concepts/use_cases">Use Cases</a>
      </inl>
   {{< /card >}}
   <p></p>
   {{< card header="[Cloud Architecture and Design](cloud_architecture_and_design)" >}}
      <inl>
         <a href="understand_opennebula/cloud_architecture_and_design/cloud_architecture_design">Cloud Architecture Design</a>
      </inl>
      <inl>
         <a href="understand_opennebula/cloud_architecture_and_design/edge_cloud_reference_architecture">Edge Cloud Architecture</a>
      </inl>
      <inl>
         <a href="understand_opennebula/cloud_architecture_and_design/open_cloud_reference_architecture">Open Cloud Architecture</a>
      </inl>
   {{< /card >}}
{{< /cardpane >}}

## Evaluate OpenNebula with miniONE

{{< cardpane >}}
   {{< card header="[Quick Start: OpenNebula Learning Environment](opennebula_learning_environment)" >}}
      <inl>
         <a href="try_opennebula_with_minione/opennebula_learning_environment/create_an_emulated_environment_with_minione">Create an Emulated Environment with miniONE</a>
      </inl>
   {{< /card >}}
   <p></p>
   {{< card header="[Quick Start: OpenNebula Evaluation Environment](opennebula_evaluation_environment)" >}}
      <inl>
         <a href="try_opennebula_with_minione/opennebula_evaluation_environment/overview">Overview</a>
      </inl>
   {{< /card >}}
{{< /cardpane >}}

## Automatic Deployment with OneDeploy

{{< cardpane >}}
   {{< card header="[OneDeploy Overview](one_deploy_overview)" >}}
      A general overview of OpenNebula objects, key features and architecture
   {{< /card >}}
   <p></p>
   {{< card header="[Quick Start: OpenNebula Evaluation_Environment](opennebula_evaluation_environment)" >}}
      OpenNebula reference architectures, and high-level steps for designing and deploying an OpenNebula cloud
   {{< /card >}}
{{< /cardpane >}}
