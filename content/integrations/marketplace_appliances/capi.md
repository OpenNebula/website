---
title: "Rancher CAPI"
date: "2025-05-15"
description:
categories:
pageintoc: "197"
tags:
weight: "10"
---

<a id="service-capi"></a>

## Appliance Description

The Rancher CAPI appliance provides a fully preconfigured environment with [Rancher](https://www.rancher.com/) and the [Turtles](https://turtles.docs.rancher.com/turtles/stable) extension installed and integrated. It ensures seamless detection of OpenNebula as an infrastructure provider and allows users to manage OpenNebula CAPI [RKE2](https://docs.rke2.io/) clusters directly from the Rancher web interface.

## Main Features

This appliance comes with a set of preinstalled components designed to streamline Kubernetes cluster management on OpenNebula:

* Rancher running on a lightweight [K3s](https://k3s.io/) cluster, along with the Turtles extension.
* [Cluster API provider for OpenNebula](https://github.com/OpenNebula/cluster-api-provider-opennebula) (CAPONE) imported as an infraestructure provider.
* RKE2 and Kubeadm charts to simplify cluster deployments.

## Main References

- [Rancher CAPI](https://github.com/OpenNebula/one-apps/tree/master/appliances/Capi) in the [OpenNebula one-apps](https://github.com/OpenNebula/one-apps) project
- [Full documentation](https://github.com/OpenNebula/one-apps/wiki/capi_intro) for the Rancher CAPI appliance
- Download the appliance from the [OpenNebula Marketplace](https://marketplace.opennebula.io/appliance):
