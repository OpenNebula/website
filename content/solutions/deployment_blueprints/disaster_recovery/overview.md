---
title: "Overview"
#description: "Complete guide for configuring DR with OpenNebula and Ceph"
weight: 1
---

Disaster Recovery (DR) involves anticipating and designing an adequate response for any situation that prevents the correct functioning of a system in an organization. DR plays a key role in an organization's business and operations continuity, and is a critical aspect in the planning and maintenance of cloud infrastructure. OpenNebula supports a reliable DR solution based on [Ceph](https://ceph.com/en/) RADOS Block Device (RBD) mirroring across two sites.

In this configuration, Ceph asynchronously replicates Virtual Machine disk images from the source Site **A** to the target Site **B**, ensuring up-to-date data copies. During failover, OpenNebula metadata is synchronized to enable quick deployment of Virtual Machines on Site B. In the event of a disaster at Site A, Site B can promote mirrored volumes and start VMs with minimal downtime. This setup ensures business continuity, data integrity, and faster recovery during outages.

This guide provides the complete architecture specification, configuration settings and necessary steps to enable DR using Ceph RBD mirroring, as well as full instructions for recovery procedures including example configuration files and commands.

Following this guide, you can:

- Set up the DR solution
- Design your own recovery procedures based on the provided examples
- Test the DR solution

{{< alert title="Note" color="success" >}}
This guide does not cover setting up the Ceph clusters on your OpenNebula infrastructure. For details on configuring Ceph as your storage system, see [Ceph Datastore]({{% relref "ceph_ds" %}}). You can also deploy OpenNebula with Ceph storage using [OneDeploy](https://github.com/OpenNebula/one-deploy); for details please see [Deploying a Single Front-end with Ceph Storage](https://github.com/OpenNebula/one-deploy/wiki/arch_single_ceph) in the OneDeploy Wiki.
{{< /alert >}}

### Basic Outline

Configuring the DR solution involves these high-level steps:

1. Set up OpenNebula Front-ends on the source and target sites.
1. Deploy an independent Ceph cluster for each site.
1. Configure information for mirroring, including for VMs and authentication between clusters.
1. Run the provided commands to enable mirroring.

### Additional Information Resources

* [Ceph Datastore]({{% relref "ceph_ds" %}})
* [Ceph Documentation](https://docs.ceph.com/en/mimic/)
* [RBD Mirroring](https://docs.ceph.com/en/mimic/rbd/rbd-mirroring/)

