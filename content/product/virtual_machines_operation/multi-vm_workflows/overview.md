---
title: "Overview"
date: "2025-02-17"
description:
categories:
pageintoc: "104"
tags:
weight: "1"
---

<a id="oneapps-overview"></a>

<a id="oneflow-overview"></a>

<a id="multivm-service-management-overview"></a>

<!--# Overview -->

## How Should I Read This Chapter

Some applications require multiple VMs to implement their workflow. OpenNebula allows you to coordinate the deployment and resource usage of such applications through the OneFlow component.

This component is able to deploy services; these services are a group of interconnected Virtual Machines that work as an entity. They can communicate with each other using Virtual Networks deployed by the OneFlow server itself, and they can also have some relationship. A group of Virtual Machines, known as a Role, can depend on other Roles, so it will be deployed when the parent is ready.

This OneFlow component is able to implement elasticity policies. The service can scale up or down depending on the requirements, in order to add or remove Virtual Machines.

## Hypervisor Compatibility

These guides are compatible with all hypervisors.
