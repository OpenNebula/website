---
title: "On-Premises Cluster"
date: "2025-02-17"
description:
categories:
pageintoc: "211"
tags:
weight: "2"
---

<!--# On-Premises Cluster -->

## Cluster Types

The **On-Premises** clusters utilize existing physical or virtual servers as OpenNebula Hosts. These clusters can operate using LXC or KVM hypervisors.

## On-Premises Cluster Implementation

A cluster in an On-Premises setup does not provision new hardware or cloud resources. Instead, it integrates and configures existing infrastructure. Users must manually provide reachable IP addresses for the hosts, ensuring that SSH connectivity and system prerequisites are met (default OS: Ubuntu 22.04).

The networking model is implemented in the following way:

- **Public Networking**: Requires manually provided IP addresses or previously configured public IPs. IP forwarding rules must be manually managed.
- **Private Networking**: Implemented using BGP-EVPN and VXLAN to create private virtual networks between provided hosts.

## OpenNebula resources

The following resources, associated with each On-Premises Cluster, will be created in OpenNebula:

1. Cluster - aggregating all other resources
2. Hosts - corresponding to provided IP addresses
3. Datastores - image and system datastores configured with an SSH transfer manager, utilizing the first provided host as the datastore replica
4. Virtual network - for public networking (configured manually)
5. Virtual network template - for private networking


## How to Create An On-Prem Provision

The following process describes how to create an On-Prem provision in your OpenNebula installation:

{{< alert title="Note" color="success" >}}
To create a provision in On-Prem, first [you must have an On-Prem provider already created]().
{{< /alert >}}

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}
{{% tab header="CLI"%}}

### Listing templates

Once the On-Prem provider has been registered in the system, provision templates should appear listed using the `oneprovision-template list` command:

```default
$ oneprovision-template list
  ID USER       GROUP      NAME               REGTIME
  0  oneadmin   oneadmin   On-Prem SSH Cluster    06/05 10:45:22
```

In this example, we have one provision template available: **On-Prem SSH Cluster**. These templates define the structure and configuration of infrastructure that can be deployed on top of the On-Prem cloud.

### Instantiating a template

You can now instantiate a provision template by its ID. This will initiate an automated process where OneForm prompts for all required input parameters and starts the deployment:

```default
$ oneprovision-template instantiate 0 --provider-id 1
There are some parameters that require user input.
  * (cidr_block) CIDR block for the VPC [type: string, default: 10.0.0.0/16]
    > 10.0.0.0/16
  * (oneform_hosts) Number of instances to create [type: number, default: 1]
    > 2
  * (instance_type) Instance type [type: list: c5.metal, m5.large]
    > 0
  * (instance_os_name) OS [type: list: ubuntu_2204, ubuntu_2404]
    0: ubuntu_2204
    1: ubuntu_2404

    Press enter for default (ubuntu_2204). Please type the selection number: 0
  * (instance_disk_size) Disk size in GB [type: number, min: 32, max: 1024]
    > 128
  * (instance_public_ips) Number of public IPs [type: number, min: 0, max: 5]
    > 1

ID: 1
```

After the provision is created, you can see a list with all your provisions using the `oneprovision list` command:

```default
$ oneprovision list
  ID USER     GROUP     NAME                  STATE            REGTIME
  1  oneadmin oneadmin  On-Prem SSH Cluster   RUNNING          06/05 10:52:29
```

To inspect the full details of a specific provision, including the generated OpenNebula objects such as hosts, datastores, and networks, run the `oneprovision show` command:

```default
$ oneprovision show 1
PROVISION 1 INFORMATION
ID                  : 1
NAME                : On-Prem SSH Cluster
DESCRIPTION         : It deploys a SSH cluster on On-Prem
USER                : oneadmin
GROUP               : oneadmin
STATE               : PENDING
PROVIDER ID         : 1
REGISTRATION TIME   : 06/05 10:52:29

PERMISSIONS
OWNER               : um-
GROUP               : ---
OTHER               : ---

PROVISION VALUES
cidr_block          : 10.0.0.0/16
oneform_hosts       : 0
instance_disk_size  : 128
instance_os_name    : ubuntu_2204
instance_public_ips : 0
instance_type       : c5.metal

OPENNEBULA RESOURCES
CLUSTER
ID                  : 2
NAME                : On-Prem SSH Cluster

HOSTS
ID   NAME            RESOURCE_ID
3    3.74.216.118    i-006a01c592f849031

NETWORKS
ID   TYPE            NAME
6    vxlan           private_onprem_network

DATASTORES
ID   TYPE            NAME
101  system_ds       onprem_system_ds
102  image_ds        onprem_image_ds
```

{{% /tab %}}

{{< tab header="Sunstone">}}
    Still under development.
{{< /tab >}}

{{< /tabpane >}}
