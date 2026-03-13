---
title: "AWS Cluster"
linkTitle: "AWS"
date: "2025-02-17"
description:
categories:
pageintoc: "211"
tags:
weight: "3"
---

<a id="aws-cluster"></a>

<!--# AWS Edge Cluster -->

AWS Edge Clusters provisioned through OneForm support KVM-based deployments. These clusters run on bare-metal EC2 instances and are fully integrated with OpenNebula’s virtualization and storage layers.

AWS Provisions offer an SSH-based Storage Cluster configuration, which uses the [OpenNebula Local Storage Datastore]({{% relref "product/cluster_configuration/storage_system/local_ds/" %}}) to provision both system and image datastores.

## AWS Edge Cluster Implementation

Provisioning an Edge Cluster in AWS creates the following resources:

* **AWS Instance**: Host to run Virtual Machines.
* **AWS VPC**: An isolated Virtual Network for all the deployed resources. There are some limits in the number of VPCs that can be requested by the user. For more details, refer to [Amazon VPC Quotas](https://docs.aws.amazon.com/vpc/latest/userguide/amazon-vpc-limits.html).
* **AWS Subnet**: Enables communication among VMs that are running on the provisioned Hosts.
* **AWS Internet Gateway**: Enables VMs to have public connectivity over the internet.
* **AWS Security Group**: Enables custom security rules to allow only specific traffic to the VMs. By default all traffic is allowed. 

The network model is implemented in the following way:

* **Public Networking**: Relies on Elastic IPs from AWS and the IPAM driver from OpenNebula. When you create a Virtual Network in OpenNebula, the Elastic IPs are requested from AWS. IP forwarding rules are applied within the Host such that the VM communicates over the public IP assigned by AWS. There are limits to the number of Elastic IPs that can be requested. Refer to [Elastic IP address quota](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html#using-instance-addressing-limit) for more information.
* **Private Networking**: Uses BGP-EVPN and VXLAN.

{{< image path="images/oneform/oneprovision/aws/aws_deployment.svg" alt="Network model implementation with public and private networking" align="center" width="80%" pb="20px" >}}

## OpenNebula Resources

The following resources, which are associated with each Edge Cluster, are created in OpenNebula:

1. **Cluster**: Contains all other resources
2. **Hosts**: For each AWS instance
3. **Datastores**: Image and system datastores with SSH transfer manager using first instance as a replica
4. **Virtual Network**: For public networking
5. **Virtual Network Template**: For private networking

## Creating an AWS Provision

### Prerequisites

To create a Provision in AWS, you must have an [AWS Provider]({{% relref "/product/cloud_cluster_provisioning/cloud_cluster_providers/aws_provider/" %}}) already created.

### Procedure

The following process demonstrates how to create an AWS Provision in your OpenNebula installation. Please select the tab for your preferred interface:

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}

{{% tab header="Sunstone"%}}
**Step 1.** Navigate to **Infrastructure -> Clusters** in the Sunstone sidebar:

{{< image
  pathDark="images/oneform/oneprovision/common/dark/sunstone_navigation.png"
  path="images/oneform/oneprovision/common/light/sunstone_navigation.png"
  alt="Step 1"
>}}

**Step 2.** Click **Create** and select the **Install a new Cloud Cluster**:

{{< image
  pathDark="images/oneform/oneprovision/common/dark/create_cluster_button.png"
  path="images/oneform/oneprovision/common/light/create_cluster_button.png"
  alt="Step 2.1"
>}}

{{< image
  pathDark="images/oneform/oneprovision/common/dark/cloud_cluster_button.png"
  path="images/oneform/oneprovision/common/light/cloud_cluster_button.png"
  alt="Step 2.2"
>}}

**Step 3.** Select your preferred AWS Provider and click **Next**:

{{< image
  pathDark="images/oneform/oneprovision/aws/dark/aws_provider.png"
  path="images/oneform/oneprovision/aws/light/aws_provider.png"
  alt="Step 3"
>}}

**Step 4.** Enter a name for the Cluster in the **General** page and click **Next**:

{{< image
  pathDark="images/oneform/oneprovision/common/dark/general_step.png"
  path="images/oneform/oneprovision/common/light/general_step.png"
  alt="Step 4"
>}}


**Step 5.** Select the type of deployment and click **Next**:

{{< image
  pathDark="images/oneform/oneprovision/aws/dark/deployment_types_step.png"
  path="images/oneform/oneprovision/aws/light/deployment_types_step.png"
  alt="Step 5"
>}}

**Step 6.** Fill the **User Inputs** section to configure the Cluster and click **Next**:

{{< image
  pathDark="images/oneform/oneprovision/aws/dark/user_inputs_step.png"
  path="images/oneform/oneprovision/aws/light/user_inputs_step.png"
  alt="Step 6"
>}}

**Step 7.** Optionally you can add tags to help identify your Cluster in OpenNebula and AWS. Click **Finish** to start the Cluster deployment:

{{< image
  pathDark="images/oneform/oneprovision/common/dark/tags_step.png"
  path="images/oneform/oneprovision/common/light/tags_step.png"
  alt="Step 7"
>}}

**Step 8.** You can observe the logs and the status of the Cluster deployment in the **Cluster Logs** view:

{{< image
  pathDark="images/oneform/oneprovision/aws/dark/aws_cluster_logs.png"
  path="images/oneform/oneprovision/aws/light/aws_cluster_logs.png"
  alt="Step 8"
>}}

**Step 9.** After reaching the RUNNING state, a full cloud Cluster is available, ready to operate:

{{< image
  pathDark="images/oneform/oneprovision/aws/dark/aws_cluster.png"
  path="images/oneform/oneprovision/aws/light/aws_cluster.png"
  alt="Step 9"
>}}

{{% /tab %}}

{{% tab header="CLI"%}}

Create an AWS Provision with the `oneprovision create <name> --provider-id <ID>` command, specifying `aws` as the Provider type and the ID of the associated Provider for this Provision (use `oneprovider list` to find the appropriate ID). This initiates an automated process in which OneForm prompts for all required input parameters then starts the deployment:

```bash
oneprovision create aws --provider-id 1
```
```default
There are some parameters that require user input.
  * (cidr_block) CIDR block for the VPC [type: string, default: 10.0.0.0/16]
    > 10.0.0.0/16
  * (oneform_hosts) Number of instances to create [type: number, default: 1]
    > 1
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

After you have created the Provision, list all the existing Provisions using the `oneprovision list` command:

```bash
oneprovision list
```
```default
ID USER     GROUP    NAME                  STATE            REGTIME
1  oneadmin oneadmin AWS SSH Cluster       RUNNING          06/05 10:52:29
```

To inspect the details of a specific Provision, run the `oneprovision show <ID>` command. The output displays information about the generated OpenNebula objects such as hosts, datastores, and networks:

```bash
oneprovision show 1
```
```default
PROVISION 1 INFORMATION
ID                  : 1
NAME                : AWS SSH Cluster
DESCRIPTION         : It deploys a SSH cluster on AWS
USER                : oneadmin
GROUP               : oneadmin
STATE               : RUNNING
PROVIDER ID         : 1
REGISTRATION TIME   : 06/05 10:52:29

PERMISSIONS
OWNER               : um-
GROUP               : ---
OTHER               : ---

PROVISION VALUES
cidr_block          : 10.0.0.0/16
oneform_hosts       : 1
instance_disk_size  : 128
instance_os_name    : ubuntu_2204
instance_public_ips : 0
instance_type       : c5.metal

OPENNEBULA RESOURCES
CLUSTER
ID                  : 2
NAME                : AWS SSH Cluster

HOSTS
ID   NAME            RESOURCE_ID
3    3.74.216.118    i-006a01c592f849031

NETWORKS
ID   TYPE            NAME
6    vxlan           private_aws_network
7    elastic         public_aws_network

DATASTORES
ID   TYPE            NAME
101  system_ds       aws_system_ds
102  image_ds        aws_image_ds
```

{{% /tab %}}

{{% tab header="API"%}}

To create a new AWS Provision using the OneForm API, use the following example request, replacing the appropriate parameters for your Provision:

```bash
curl -X POST "https://oneform.example.server/api/v1/provisions" \
  -u "username:password" \
  -H "Content-Type: application/json" \
  -d '{
    "driver": "aws",
    "deployment_type": "ssh_cluster",
    "provider_id": 1,
    "user_inputs_values": {
      "cidr_block": "10.0.0.0/16"
      "oneform_hosts": 1,
      "instance_disk_size": 128,
      "instance_os_name": "ubuntu_2204",
      "instance_public_ips": 0,
      "instance_type": "c5.metal"
    },
    "name": "AWS Cluster",
    "description": "Provision in AWS"
  }'
```
<br>

For further details about the API, see the [OneForm API Reference]({{% relref "/product/integration_references/system_interfaces/oneform_api.md" %}}).
{{% /tab %}}
{{< /tabpane >}}

Now that you have created an AWS Cluster, learn how to [Manage your Provisioned Clusters]({{% relref "/product/cloud_cluster_provisioning/cloud_cluster_operations/provision_operations.md" %}}).
