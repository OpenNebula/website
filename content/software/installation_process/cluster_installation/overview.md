---
title: "Overview"
linkTitle: "Overview"
date: "2026-04-15"
description: "Deploy OpenNebula Front-end Clusters automatically or manually."
categories:
pageintoc: "168"
tags:
weight: "1"
---

OpenNebula Clusters are logical groupings of Hosts, datastores and Virtual Networks that provide compute capacity for cloud workloads. Cluster compute resources can consist of on-premise servers or virtual or bare-metal instances from a 3rd-party IaaS provider. 

Before deploying OpenNebula Clusters, you must deploy an OpenNebula Front-end. If you have not already deployed a Front-end, refer to the [Front-end Deployment Documentation]({{% relref "software/installation_process/frontend_installation/" %}}) for details. 

Once you have successfully deployed an OpenNebula Front-end, you can proceed to manually install or automatically create (provision) Clusters to handle cloud workloads. There are three options:

* [Automated Cluster Provisioning with OneForm]({{% relref "software/installation_process/cluster_installation/automated/" %}})
* [Manual Cluster Installation with KVM]({{% relref "software/installation_process/cluster_installation/kvm_node_installation/" %}})
* [Manual Cluster Installation with LXC]({{% relref "software/installation_process/cluster_installation/lxc_node_installation/" %}})

OneDeploy can also be used to deploy Cluster nodes (independently or simultaneously with Front-end deployment). Please refer to the [Advanced Installation with OneDeploy]({{% relref "software/installation_process/advanced_installation_with_onedeploy/" %}}) documentation.