---
title: "Run a Kubernetes Cluster on OpenNebula"
date: "2025-02-17"
description:
categories: [Learning, Evaluation, Deployment, Introduction]
pageintoc: "23"
tags: ['Quick Start', Kubernetes, Tutorial, OneKE]
weight: "7"
---

<a id="running-kubernetes-clusters"></a>

<!--# Running Kubernetes Clusters -->

## Overview

Previous tutorials of this Quick Start guide show how to use miniONE to:

- [Install an OpenNebula Front-end and a KVM Host on-premises]({{% relref "deploy_opennebula_onprem_with_minione" %}})
- [Install an OpenNebula Front-end and a KVM Host on AWS]({{% relref "deploy_opennebula_on_aws" %}})
- [Validate the environment]({{% relref "validate_the_minione_environment" %}}) created by miniONE, by running a Virtual Machine

This tutorial builds on the infrastructure created in those previous tutorials. By following it, you can:

- Download a complete Kubernetes cluster from the [OpenNebula Public Marketplace](https://marketplace.opennebula.io)
- Deploy the cluster on the KVM Host installed by miniONE
- Validate the cluster by running a simple test application

This tutorial was designed and tested on an AWS metal instance -- the same `c5.metal` instance used for the [miniONE on AWS]({{% relref "deploy_opennebula_on_aws" %}}) guide. However, you should also be able to complete this tutorial on an on-premises installation with sufficient resources (for requirements, see [Deploy OpenNebula On-prem]({{% relref "deploy_opennebula_onprem_with_minione/#step-1-verify-installation-requirements" %}})).


As mentioned above, the Kubernetes cluster deployed in this tutorial is available in the [OpenNebula Public Marketplace](https://marketplace.opennebula.io). You can find it as the multi-VM appliance **Service OneKE**, the OpenNebula Kubernetes Edition.

To deploy the Kubernetes cluster, we'll follow these high-level steps:

1. Download the OneKE Service from the OpenNebula Marketplace.
2. Instantiate a private network on the Edge Cluster.
3. Instantiate the Kubernetes Service.
4. Deploy an application on Kubernetes.

In this tutorial we'll perform a basic install of the Kubernetes cluster plus the Traefik ingress router and Longhorn storage. The OneKE appliance offers additional options such as High Availability, load balancing and CNI plugins, which are out of the scope of this guide.

{{< alert title="Tip" color="success" >}}
For more information about OneKE, please see [OneKE Service (Kubernetes)]({{% relref "../../../integrations/marketplace_appliances/oneke" %}}). The full documentation for OneKE is available in the [OpenNebula Apps Documentation](https://github.com/OpenNebula/one-apps/wiki).
{{< /alert >}}

## Step 1. Download the OneKE Service from the OpenNebula Marketplace

The [OpenNebula Public Marketplace](https://marketplace.opennebula.io) is a repository of Virtual Machines and appliances which are curated, tested and certified by OpenNebula.

The Kubernetes cluster is packaged in a multi-VM service appliance listed as **Service OneKE <version>**. To download it, follow the same steps as when downloading the WordPress VM:

Open the left-hand pane, then select **Storage** -> **Apps**. Sunstone will display the **Apps** screen, showing the first page of apps that are available for download.

![image](/images/sunstone-apps_list.png)
<br/>

In the search field at the top, type `oneke` to filter by name. Then, select **Service OneKE <version number>** with the highest version number, in this case **Service OneKE 1.31** highlighted below.

![image](/images/sunstone-service_oneke.png)
<br/>

Click the **Import** button.

As with the WordPress appliance, Sunstone displays the **Download App to OpenNebula** wizard. In the first screen of the wizard, click **Next**.

![image](/images/sunstone-aws_cluster_download_oneke.png)

In the second screen you will need to select a datastore for the appliance. Select the **default** datastore.

![kubernetes-qs-marketplace-datastore](/images/aws_cluster_images_datastore.png)

Click **Finish**. Sunstone will import the appliance template and display a message at bottom right. To see the imported template, in the left-hand menu select **Templates** -> **Service Templates**:

![image](/images/sunstone-service_templates.png)

## Step 2. Instantiate a Private Network on the Cloud Cluster

In this step we will create a new virtual network and assign a range of private IPs to. This will network will be used by the OneKE service for internal communication.

In Sunstone, open the left-hand pane, then select **Network** -> **Network Templates**. Sunstone displays the **Virtual networks** page showing the network automatically created by miniONE:

![image](/images/sunstone-virtual_networks.png)

Click the **Create** button at the top. Sunstone will display the **Create Virtual Network** screen. Enter a name for the network -- for this example we will use `privnet`. Then, click **Next**.

In the next screen, activate the **Use only private host networking** switch:

![image](/images/sunstone-create_priv_network.png)

Then, click the **Addresses** tab. Here we will enter a range of private IP addresses. For this example, enter `192.168.200.2` for the base network address, and set the network size to `100`.

![image](/images/sunstone-create_priv_network_2.png)

Click **Finish**.

## Step 3. Instantiate the Kubernetes Service

In the left-hand pane, select **Templates** -> **Service Templates**.

Select **Service OneKE 1.31**, then click the **Instantiate** icon ![icon2](/images/icons/sunstone/instantiate.png).

Sunstone displays the **Instantiate Service Template** wizard. In the first screen you can give your service a name and specify the number of instances to instantiate. In this example we’ll leave the default name `Service OneKE 1.31` and start a single instance.

![kubernetes-qs-service-start](/images/sunstone-oneke_instantiate-1.png)

Click **Next** to go to the next screen, **Networks**.

Here we will select the private and the public network for the OneKE service.

To select the public network, click the **Public** tab on the left, then select network **vnet**. For the private network, click the **Private** tab, then select **privnet**.

![image](/images/sunstone-oneke_instantiate-2.png)

Click **Next**. Sunstone displays the **Service Inputs** screen:

![image](/images/sunstone-instantiate_oneke-sevice_inputs.png)

Here you can define parameters for the cluster, including a custom domain, plugins, VNF routers, storage options and others.

<!--

![image](/images/sunstone-kubernetes-user_inputs_vrouter.png)

![image](/images/sunstone-kubernetes-user_inputs_rke2.png)

![image](/images/sunstone-kubernetes-user_inputs_k8s.png)

![image](/images/sunstone-kubernetes-user_inputs_vnf.png)

![image](/images/sunstone-kubernetes-user_inputs_others.png)
<br/>

-->

For this tutorial we'll apply the following configuration:

In the **Kubernetes Cluster** tab, scroll down and activate **Enable Longhorn**. Then scroll down to the bottom of the page and **Enable Traefik**.

![image](/images/sunstone-instantiate_oneke-lhorn_traef.png)

Click **Next**.

In the last screen, click **Finish**.

### Verify the OneKE Service Deployment

To verify that the OneKE Service has correctly deployed, you can either use the Sunstone UI, or the command line the Front-end node.

To verify in the Sunstone GUI, open the left-hand pane, then Select **Instances** -> **Services**. You should see the OneKE service up and running. Its running VMs should be visible in the **Roles** tab.

![image](/images/sunstone-oneke_running.png)

To verify the deployment using the command line, log in to the Front-end node as user `oneadmin`, then run `oneflow list`. In the command output, check that the State is `RUNNING`, as shown below. Bear in mind that the service may take a few moments to display the `RUNNING` state.

```default
[oneadmin@FN]$ oneflow list
ID USER     GROUP    NAME                                                     STARTTIME STAT
1 oneadmin oneadmin Service OneKE 1.31                                   04/29 08:18:17 RUNNING
```

To verify that the VMs for the cluster were correctly deployed, you can use the `onevm list` command. In the example below, the command lists the VMs for the cluster:

```default
oneadmin@ip-172-31-47-22:~$ onevm list
  ID USER     GROUP    NAME                                         STAT  CPU     MEM HOST                                TIME
   6 oneadmin oneadmin worker_0_(service_2)                         runn    2      3G localhost                       0d 00h00
   5 oneadmin oneadmin master_0_(service_2)                         runn    2      3G localhost                       0d 00h00
   4 oneadmin oneadmin vnf_0_(service_2)                            runn    1    512M localhost                       0d 00h00
```

At this point you have successfully instantiated the Kubernetes cluster on your local hypervisor.

If the state of the OneKE service as reported by `oneflow list` remains in `DEPLOYING`, see [below](#oneflow-service-is-stuck-in-deploying).

Before deploying the test application described in this tutorial, you will need to find out the IP address of the VNF node on the **public** network -- in this case, the **vnet** network that we set as public network when instantiating the OneKE service -- since this is the address that we will use to connect to the application.

<a id="check-vnf"></a>

### Check the IP Address for the VNF Node

To check the VNF node IP in Sunstone, in the left-hand pane go to **Instances** -> **VMs**, then check the information displayed under **vnf_0_(service_<ID>)**. In the image below, the VNF is **vnf_0_(service_2) and the relevant IP address is `172.16.100.2`.


![image](/images/oneke_vms.png)

Alternatively, to check on the command line, on the Front-end node as user `oneadmin` run:

```bash
onevm show <VM ID> | less
```

(Replace `VM ID` for the VM ID number as shown by `onevm show`, in this case `4`.)

This displays the complete information for the VM, piped through the `less` pager. Use the up and down arrow to scroll, until you find the `VM NICS` table:

```default
VM NICS                                                                         
 ID NETWORK              BRIDGE       IP              MAC               PCI_ID  
  0 vnet                 minionebr    172.16.100.2    02:00:ac:10:64:02
  1 privnet              onebr1       192.168.200.2   02:00:c0:a8:c8:02
  2 vnet                 minionebr    172.16.100.3    02:00:ac:10:64:03
  3 privnet              onebr1       192.168.200.3   02:00:c0:a8:c8:03
```

The relevant IP is the first displayed for the `vnet` network, `172.16.100.2`.

To stop displaying the information for the VM, press `q`.

If you do not see all VMs listed, or if the OneKE Service is stuck in `DEPLOYING`, see [Known Issues]({{% relref "#k8s-known-issues" %}}) below.

{{< alert title="Tip" color="info" >}}
Once the OneFlow service has deployed, you can add more worker nodes. In Sunstone:

1. Go to **Instances** -> **Services**.
2. Select the OneKE service.
3. Select the **Roles** tab.
4. Click **Worker**, then the green **Scale** button.{{< /alert >}}  

<a id="step-4"></a>

## Step 5. Deploy an Application

In this tutorial we will deploy a very simple application designed for training purposes: a MariaDB database to which you can add sample data from the Kubernetes master. The database will reside in the Kubernetes cluster's Longhorn storage, so the first step is to enable storage for the cluster.

### Enable Longhorn Storage

We can enable Longhorn storage with a single command:

```bash
oneflow scale <OneKE service ID> storage 1
```

Most probably, the `OneKE service ID` should be `1`. You can find out with the `oneflow list` command:

```default
[oneadmin@FN]$ oneflow list
ID USER     GROUP    NAME                                                     STARTTIME STAT
1 oneadmin oneadmin Service OneKE 1.31                                   04/29 08:18:17 RUNNING
```

In the example above, the ID is `1`, so:

```bash
oneflow scale 1 storage 1
```

This will create a Virtual Machine as part of the OneKE Service which will serve as Longhorn storage for the Kubernetes cluster.

The command will take a moment to execute. During that time the OneKE service will change state, from `RUNNING` to `COOLDOWN` and back to `RUNNING`. You must wait until this cycle is finished to continue with the next steps. You can continuously check the status of the cluster by running (as `oneadmin` on the Front-end node):

```bash
oneflow top
```

This produces the output of `oneflow list`, updated continuously. Once the status is `RUNNING`, to exit the command type `Ctrl+C`.

On the Front-end node, we can check the status of the newly-created storage VM with `onevm list`:

```
oneadmin@ip-172-31-47-22:~$ onevm list
  ID USER     GROUP    NAME                                             STAT  CPU     MEM HOST                                   TIME
   7 oneadmin oneadmin storage_0_(service_2)                            runn    2      3G localhost                          0d 04h38
   6 oneadmin oneadmin worker_0_(service_2)                             runn    2      3G localhost                          0d 05h36
   5 oneadmin oneadmin master_0_(service_2)                             runn    2      3G localhost                          0d 05h36
   4 oneadmin oneadmin vnf_0_(service_2)                                runn    1    512M localhost                          0d 05h36
```

### Log into the Master Node and Deploy the Application

First, we will need to connect to the Kubernetes master node via SSH. To this, we need to use the VNF node as "jump host", i.e. we connect first to the VNF node and from there to the Kubernetes master node.

As we have seen [above](#check-the-ip-address-for-the-vnf-node), in this example the IP address of the VNF is `172.16.100.2`. With our network configuration, the IP address for the Kubernetes master node is probably `192.168.200.4` (the second IP address in the private network `privnet` that we assigned to the OneKE service). Of course if your configuration varies (for example if you installed additional networked Virtual Machines before deploying the OneKE service), then you will have to use the appropriate IPs.

To connect to the Kubernetes master node, from the Front-end, as user `root` run:

```bash
ssh -A -J root@192.168.200.4 root@172.16.100.2
```

An example run as user `root`:

```default
root@ip-172-31-47-22:~# ssh -A -J 172.16.100.2 192.168.200.4
Warning: Permanently added '172.16.100.2' (ED25519) to the list of known hosts.
The authenticity of host '192.168.200.4 (<no hostip for proxy command>)' can't be established.
ED25519 key fingerprint is SHA256:8fbzSN9OgOGZ1+2Zfdiq9r/6e+yEIJe1Ar6cqLpZ2Cw.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.200.4' (ED25519) to the list of known hosts.
Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 5.15.0-126-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Wed Jun  4 10:10:11 UTC 2025

  System load:           0.61
  Usage of /:            4.8% of 24.05GB
  Memory usage:          8%
  Swap usage:            0%
  Processes:             106
  Users logged in:       0
  IPv4 address for eth0: 10.0.2.15
  IPv6 address for eth0: fec0::211:22ff:fe33:4455

 * Strictly confined Kubernetes makes edge and IoT secure. Learn how MicroK8s
   just raised the bar for easy, resilient and secure K8s cluster deployment.

   https://ubuntu.com/engage/secure-kubernetes-at-the-edge

Expanded Security Maintenance for Applications is not enabled.

8 updates can be applied immediately.
8 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable

1 additional security update can be applied with ESM Apps.
Learn more about enabling ESM Apps service at https://ubuntu.com/esm


The list of available updates is more than a week old.
To check for new updates run: sudo apt update


   ___   _ __    ___
  / _ \ | '_ \  / _ \   OpenNebula Service Appliance
 | (_) || | | ||  __/
  \___/ |_| |_| \___|


 2/3 Configuration step is in progress...

 * * * * * * * *
 * PLEASE WAIT *
 * * * * * * * *
```

In the above example the Kubernetes master is self-configuring, hence the "PLEASE WAIT" message.

Once you have connected to the Kubernetes master node, check if `kubectl` is working, by running `kubectl get nodes`:

```
root@oneke-ip-192-168-200-4:~# kubectl get nodes
NAME                     STATUS   ROLES                       AGE     VERSION
oneke-ip-192-168-200-4   Ready    control-plane,etcd,master   5h32m   v1.31.3+rke2r1
oneke-ip-192-168-200-6   Ready    <none>                      5h32m   v1.31.3+rke2r1
oneke-ip-192-168-200-8   Ready    <none>                      4h38m   v1.31.3+rke2r1
```

The last row in the output is the `storage` role in the cluster created in the previous step, with IP `172.168.200.8`.

Now we are ready to download and deploy our example application.

We can download the application from the master node itself, by running:

```bash
wget https://github.com/alpeon/training-files/raw/refs/heads/main/OneKE/test-app.tar
```

This downloads the `test-app.tar` package file. Unpack it with:

```bash
tar xvf test-app.tar
```

This creates the `test-app` directory, which contains the YAML manifest files we will use to deploy the application.

Switch to the `test-app` directory:

```bash
cd test-app
```

Create all of the applications in the directory:

```bash
kubectl apply -f .
```

For example:

```default
root@oneke-ip-192-168-200-4:~/test-app# kubectl apply -f .
deployment.apps/mariadb created
persistentvolumeclaim/mariadb-data created
service/mariadb created
deployment.apps/test-app created
ingressroute.traefik.io/test-app-ingress created
service/test-app-service created
```

Check the status of the applications:

```bash
kubectl get pods
```

This should display the status of the database and the `test-app` application:

```default
NAME                        READY   STATUS    RESTARTS   AGE
mariadb-55496464b6-66kl9    1/1     Running   0          45s
test-app-56b5745c76-bxxld   1/1     Running   0          45s
```

The process may take some seconds to complete. When both pods display status `Running`, we are ready to connect to the application.

### Connect to the Application

From the Front-end node, as user `oneadmin` run `curl <VNF node IP>`. In our case:

```bash
curl 172.16.100.2
```

You should be greeted with:

```default
oneadmin@ip-172-31-47-22:~$ curl 172.16.100.2
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Spaceship: Nebula Explorer</title>
</head>

<body>

  <div>
      <h1>
        'sup Space Man, want to explore some Nebula?
      </h1>

      <div>
        Visit /create-db to create the database
        <br>
        Visit /insert-dummy to insert some dummy data
        <br>
        Visit /get-data to print out the dummy data

        </div>
        
        <div>
          <h2>
            See you, Space Cowboy!
          </h2>
          <pre>
          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⢦⣤⣤⣤⣄⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣽⣿⢨⡿⠟⠛⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢲⣤⣤⣀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣉⠻⣿⣿⣿⣿⣿⡏⠉⠉⠉⠉⢩⣿
          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢈⣩⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⡭⢝⣻⣿⣿⣿⣷⣿⣿⣿⣿
          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⢤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣭⡿⠛⣻⣿⣿⣿⣿
          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣿⣻⣿⣿⣿⣿
          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣶⣥⣬⣭⣿
          ⠀⠀⠀⠀⠀⠀⠀⠀⠰⠚⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⡍⠹⠿
          ⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⣴⣶⣶⣾
          ⠀⠀⠀⡄⠀⠀⣠⢟⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⣿⣿⣿⠋⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢛⡛⣹⣿
          ⠀⠀⠀⣷⡀⠀⢱⠟⢻⣿⣿⣿⣿⣿⣿⣿⡿⢫⣽⣿⣿⣿⣿⣿⣿⣿⣏⢹⠏⣼⣿⣟⣛⣙⡒⣾⣿⣀⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⢛⣣⣿⣿
          ⡄⠀⢀⣿⣇⣤⣾⢾⣿⣿⣿⣿⣿⣿⣿⣿⡇⣾⢿⣿⣿⣿⣿⣿⣿⣿⢿⣇⠀⠙⠿⠿⣿⡏⠛⢿⡮⠙⢻⡿⢡⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣭⢶⣿⡿⣿⣿⣿
          ⣇⠀⢸⣿⡏⠁⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣧⢧⡸⡿⠟⣿⣿⣿⣿⣿⠈⣿⠀⠀⠀⠀⠀⠀⠀⠬⡷⠖⠋⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠋⠁⠀⠙⠻⢶⣍⡛
          ⡿⢿⡇⢹⡿⢦⡀⠙⠛⢿⣿⣿⣿⣿⣿⣿⣿⣎⢻⡛⠂⣿⣿⡿⠙⠃⠈⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠀⣿⡟⢛⣦⣹⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⠾⠀⠀⠀⠀⠀⠀⠉⠻
          ⣦⣿⡉⠻⣿⣯⠹⠀⣐⢦⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⣠⠘⢿⣷⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⢿⠟⢠⣿⣿⣿⣿⣿⣿⢿⡛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
          ⢻⠙⢿⣦⡈⠛⣄⡀⠈⠀⠉⠛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⢸⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⠄⠀⣾⣿⣿⣿⣿⣿⠛⠛⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
          ⠘⠀⠀⠙⢻⣶⣄⠙⢦⡀⠀⠀⠈⠹⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⢀⡆⣼⣿⣿⣿⢻⡍⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
          ⠀⠀⠀⠀⠀⠈⠻⢷⣄⠈⠦⡀⣀⣴⢶⣿⣟⠛⠫⠍⠉⠉⠉⠙⠛⠛⠛⠛⠛⠛⠛⠛⢻⣿⣟⡽⠶⠚⢿⣷⡾⠋⡰⠋⢹⣟⠙⢷⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
          ⠀⠀⠀⠀⠀⢀⣀⣀⠻⢿⡟⠉⠻⠶⠧⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣶⠿⢯⡥⣤⠤⣤⣀⣻⢅⡴⠃⠀⢸⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
          ⠀⠀⣀⠀⢰⣿⡿⠿⢧⣤⣾⡿⠛⠻⢿⡛⠲⢤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⢾⡿⠋⠀⠠⣄⣈⢛⣄⡹⣧⡞⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
          ⠀⠀⠈⠁⢺⣿⡇⣠⣶⣿⣿⣿⣿⣿⣿⣿⣷⣶⣭⡳⢤⡀⠀⠀⠐⢤⣠⢞⣵⠋⠀⠀⠀⠀⠈⠛⠿⠋⣹⣾⡛⠶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
          ⠀⠀⠀⠀⣸⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⢿⣷⣶⣶⣿⣵⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⣼⠃⠀⠙⠲⡌⠳⣄⠀⠀⠀⠀⣀⡤⠶⠶⠦⣤⣀⠀⢀⣀⡀⠀⠀⠀⠀⠀
          ⠀⣠⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣝⣿⣧⣝⣻⡿⣿⣿⣿⣷⣦⣄⣀⣀⣼⣿⡷⣄⠀⠀⠙⢦⣸⣧⠔⣛⣿⠷⠋⠙⠲⠶⣄⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀
          ⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣝⢿⣄⣉⣷⢬⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⣷⣄⠀⠀⠛⠛⠛⠉⠀⠀⠀⠀⠀⠀⠈⢷⡄⠀⠀⠀⠀⠀⠀⠀⠀
          ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠹⣿⣷⣿⣿⣿⣿⣿⡿⠛⠉⠀⠀⠀⠈⠛⢷⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣄⢀⠀⠀⠀⠀⠀⠀
          ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠈⠻⣿⣿⣿⣿⣮⡳⣄⠀⠀⠀⠀⠀⠀⠀⠈⠛⠛⠲⢤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣶⡄⠀⠀⠀⠀
          ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠘⣿⣿⣏⠉⠻⣽⣧⣤⣴⣖⣲⠶⠬⠽⠿⠶⠖⠷⣬⡉⠉⠂⠀⠀⠀⠀⠀⠀⠀⠀⠉⠓⠶⠶⡂
          ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡃⠈⢻⣿⢧⢀⣠⣙⣻⣿⣿⣿⣷⣄⠀⠀⠀⠀⡀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
          ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣾⣿⣿⣤⠟⢿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⢰⡷⣿⣇⣀⣀⣀⣴⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀
          ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠇⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⡗⢒⣋⣉⣉⣭⣏⠻⣶⡖⢽⣏⠳⣤⡀⠀⠀⠀⠀⠀
          ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠀⠈⣿⡿⣿⣿⣿⣿⣿⣿⣷⣾⣿⣿⣿⡏⠉⠳⢤⡉⢺⣿⡆⠀⠉⠂⠀⠀⠀⠀
          ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⣹⣿⣶⣝⠿⣿⣿⣿⢿⣿⣿⣿⣿⡇⠀⠀⠀⠙⣾⣿⢻⡄⠀⠀⠀⠀⠀⠀
          ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠙⣿⣿⣷⣌⠛⢿⣌⢻⣿⣿⣿⣿⣷⣴⡤⠀⣿⣿⢰⣿⠀⠀⠀⠀⠀⠀
          ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⡘⢿⣿⣿⣿⣦⡙⠿⣿⣿⣿⣿⣿⣿⠀⠀⣿⣿⣾⣿⣷⠀⠀⠀⠀⠀
        </pre>

```

Now we can create the database with:

```bash
curl 172.16.100.2/create-db
```

This should return the following:

```
oneadmin@ip-172-31-47-282:~$ curl 172.16.100.2/create-db
{"message":"Table 'data' created successfully"}
```

To insert some dummy data into the database:

```bash
curl 172.16.100.2/insert-dummy
```

Repeat this commands to insert more than one data point. Then, verify the inserted data with:

```bash
curl 172.16.100.2/get-data
```

For example:

```default
oneadmin@ip-172-31-47-22:~$ curl 172.16.100.2/get-data
[{"data1":"2025-06-23 11:51:27","data2":"50","id":1},{"data1":"2025-06-23 11:51:54","data2":"63","id":2},{"data1":"2025-06-23 11:52:09","data2":"84","id":3}]
```

And that's it -- you have successfully deployed a Kubernetes cluster, and deployed and tested an application.

For more information including additional features for the OneKE Appliance, please refer to the [OpenNebula Apps Documentation](https://github.com/OpenNebula/one-apps/wiki).

<a id="k8s-known-issues"></a>

## Known Issues

<a id="oneflow-service-is-stuck-in-deploying"></a>

### OneFlow Service is Stuck in `DEPLOYING`

An error in network configuration, or any major failure (such as network timeouts or performance problems) can cause the OneKE service to lock up due to a communications outage between it and the Front-end node. The OneKE service will lock if *any* of the VMs belonging to it does not report `READY=YES` to OneGate within the default time.

If one or more of the VMs in the Kubernetes cluster never leave the `DEPLOYING` state, you can troubleshoot OneFlow communications by inspecting the file `/var/log/one/oneflow.log` on the Front-end node. Look for a line like the following:

```default
[E]: [LCM] [one.document.info] User couldn't be authenticated, aborting call.
```

The line above means that provisioning the service exceeded the allowed time. In this case it is not possible to recover the broken VM instance; it must be recreated.

Before attempting to recreate the instance, ensure that your environment has a good connection to the public Internet and does not suffer from any impairments in performance.

<a id="terminate-oneflow"></a>

To recreate the VM instance, you must first terminate the OneKE service. A service stuck in `DEPLOYING` cannot be terminated by the `delete` operation. To terminate it, you need to run the following command:

```default
oneflow recover --delete <service_ID>
```

Then, re-instantiate the service from the Sunstone UI: in the left-hand pane, **Service Templates** -> **OneKE 1.29**, then click the **Instantiate** icon.

#### One or more VMs Fail to Report Ready

Another possible cause for failure of the OneKE Service to leave the `DEPLOYING` state is that a temporary network glitch or other variation in performance prevented one or more of the VMs in the service to report `READY` to the OneGate service. In this case, it is possible that you see all of the VMs in the service up and running, but the OneKE service is stuck in `DEPLOYING`.

For example on the Front-end, the output of `onevm list` shows all VMs running:

```default
onevm list
  ID USER     GROUP    NAME                                            STAT  CPU     MEM HOST                         TIME
   3 oneadmin oneadmin worker_0_(service_3)                            runn    2      3G <public IP>              0d 01h02
   2 oneadmin oneadmin master_0_(service_3)                            runn    2      3G <public IP>              0d 01h02
   1 oneadmin oneadmin vnf_0_(service_3)                               runn    1    512M <public IP>              0d 01h03
   0 oneadmin oneadmin Service WordPress - KVM-0                       runn    1    768M <public IP>              0d 01h53
```

Yet `oneflow list` shows:

```default
ID USER     GROUP    NAME                                                                   STARTTIME STAT
 3 oneadmin oneadmin OneKE 1.29                                                        08/30 12:30:07 DEPLOYING
```

In this case you can manually instruct the VMs to report `READY` to the OneGate server. Follow these steps:

1. From the Front-end node, log in to the VNF node by running:
   ```default
   ssh root@<VNF IP>
   ```

   (To find out the IP address of the VNF node, see [above]({{% relref "#check-vnf" %}}).)

2. For each VM in the OneKE service, run the following command:
   ```default
   onegate vm update <ID> --data "READY=YES"
   ```

   For example, `onegate vm update 2 --data "READY=YES"`.

   Then, you can check the status of the service with `onegate vm show`:
   ```default
   onegate service show
   SERVICE 3
   NAME                : OneKE 1.29
   STATE               : RUNNING

   ROLE vnf
   VM 1
   NAME                : vnf_0_(service_3)

   ROLE master
   VM 2
   NAME                : master_0_(service_3)

   ROLE worker
   VM 3
   NAME                : worker_0_(service_3)

   ROLE storage
   ```
3. On the Front-end, run `oneflow list` again to verify that the service reports `RUNNING`:
   ```default
   [oneadmin@FN]$ oneflow list
   ID USER     GROUP    NAME                                                                    STARTTIME STAT
    3 oneadmin oneadmin OneKE 1.29                                                         08/30 12:35:21 RUNNING
   ```

#### One or more VMs is Ready, but Unreachable

In a similar situation as above when `onevm list` shows all VMs running, but the service is still in `DEPLOYING` state and the VM is not reachable through SSH (e.g. to run the `onegate vm update` command).

In this case, we can try to scale down and up the role of the problematic VM from [Sunstone]({{% relref "fireedge_sunstone.md" %}}), the Front-end UI:

> 1. In Sunstone, go to **Services**, then select the **OneKE** Service.
> 2. In the **Roles** tab, choose the problematic VM’s role (e.g. `worker`).
> 3. Scale the role to `0`.
> 4. Wait until VM shuts down and the scaling and cooldown period of the service finishes.
> 5. Scale the role to `1`.
> 6. Verify if the problem is solved and `oneflow list` reports the `RUNNING` state.
