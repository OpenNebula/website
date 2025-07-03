---
title: "Architecture and Specifications"
#description: "Complete guide for configuring DR with OpenNebula and Ceph"
weight: 2
---

## Architecture

The reference architecture consists of two OpenNebula clusters with independent Front-ends on **Site A** and **Site B**.

Each site contains an OpenNebula Front-end, three KVM compute nodes, and an independent Ceph cluster with RDB mirroring. The Virtual Machines running production workloads reside on Site A. The Ceph clusters share the same storage network, as shown below.

![><](/images/solutions/disaster_recovery/disaster_recovery.png)


## Specifications

The setup tested in this reference architecture utilizes the same versions of software components, detailed below, on both sites. Note that the Ceph `rbd-mirror` service is active on both Ceph clusters.

### Site A (source):

- OpenNebula controller (Front-end)
  - OpenNebula 6.10.3 version
  - OS: Ubuntu 22.04
- Compute KVM Nodes with ceph (x3)
- Ceph cluster (one pool)
  - Squid 19.2.2 version
- VMs running production workloads
- Ceph RBD mirroring enabled (as primary)
  - `rbd-mirroring` service

### Site B (target):

- OpenNebula controller (Front-end)
  - OpenNebula 6.10.3 version
  - OS: Ubuntu 22.04
- Compute KVM Nodes with ceph (x3)
- Ceph cluster (one pool)
  - Squid 19.2.2 version
- Ceph receives mirrored RBD images
- Ceph RBD mirroring enabled (as replication)
  - `rbd-mirroring` service
