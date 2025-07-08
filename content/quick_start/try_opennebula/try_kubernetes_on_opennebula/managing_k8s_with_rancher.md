---
title: "Managing Kubernetes with Rancher and the Cluster API Integration"
date: "2025-02-17"
description:
---

<a id="running-kubernetes-clusters"></a>

## Overview

OpenNebula's CAPI appliance, provides a ready-to-use solution for managing Kubernetes clusters through the [Rancher web UI](https://www.rancher.com). The appliance includes a fully configured lightweight K3s cluster with the Rancher interface already installed, and is fully integrated to support OpenNebula as an infrastructure provider via the [Cluster API Provider for OpenNebula](https://github.com/OpenNebula/cluster-api-provider-opennebula).

You can download the the CAPI appliance from the [OpenNebula Public Marketplace](https://marketplace.opennebula.io/) (where it is available as **Service Capi**) or on your OpenNebula Front-end using the [command line]({{% relref "marketapps#exploring-marketplace-appliances" %}}) or the [Sunstone web UI]({{% relref "marketapps#using-sunstone-to-manage-marketplace-appliances" %}}). The CAPI appliance eliminates the need for manual configuration, greatly reducing operational overhead and allowing you to effortlessly create, manage, and upgrade CAPI-managed RKE2 clusters.

This tutorial shows how to: 

- Download and install the CAPI Appliance
- Log in to Rancher and deploy an RKE2 cluster
- Importing and operating a workload cluster
- Deploying a sample application

This tutorial was designed and tested in an on-premises installation. You can use it, for example, as a continuation of [OpenNebula On-prem with miniONE]({{% relref "deploy_opennebula_onprem_with_minione" %}}).

## Pre-requisites

To follow this tutorial you will need:

- An [OpenNebula Front-end running on premises]({{% relref "deploy_opennebula_onprem_with_minione" %}}) (version >=6.10) running on a machine that meets the [Rancher installation requirements](https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/installation-requirements#rke2-kubernetes):
   - 4 vCPUs
   - 16 GiB RAM
- The [OneGate service]({{% relref "onegate_usage" %}}) must be running on the Front-end (it is enabled by default if you installed with miniONE).
- A public and a private virtual network on your Front-end. The public network is installed automatically by miniONE; creating a private network is explained in the next step.

## Instantiate a Private Network on the Front-end

In this step we will create a new virtual network and assign a range of private IPs to. This will network will be used by the Virtual Machines in the workload Kubernetes cluster.

In Sunstone, open the left-hand pane, then select **Networks** -> **Virtual Networks**. Sunstone displays the **Virtual networks** page showing the public network, **vnet**:

![image](/images/sunstone-virtual_networks.png)

Click the **Create** button at the top. Sunstone will display the **Create Virtual Network** screen. Enter a name for the network -- for this example we will use `private`. Then, click **Next**.

In the next screen, activate the **Use only private host networking** switch:

![image](/images/sunstone-create_priv_network.png)

Then, click the **Addresses** tab. Here we will enter a range of private IP addresses. For this example, enter `192.168.200.2` for the base network address, and set the network size to `100`.

![image](/images/sunstone-create_priv_network_2.png)

Click **Finish**.

## Download the CAPI Appliance

From your OpenNebula Front-end, you can download the CAPI appliance from the Sunstone UI or from the command line.

### From the Sunstone UI

You can download the CAPI appliance by following the same steps as when [downloading the WordPress VM]({{% relref "validate_the_minione_environment#step-1-download-the-wordpress-appliance-from-the-opennebula-marketplace" %}}):

   1. On the left-hand pane, go to **Storage** -> **Apps**.
   1. On the **Apps** showing the available apps, filter for `capi`.
   1. Click **Service Capi** to select it, then click **Import**.
   1. In the import wizard, select the **default** image datastore, then click **Finish**.

### From the Command Line

On the Front-end, as the `oneadmin` user run:

```bash
onemarketapp export 'Service Capi' Capi --datastore default
```

This automatically downloads the **Service Capi** appliance into the default datastore.

## Instantiate the CAPI Appliance

### From the Sunstone UI

To instantiate the Service Capi appliance, follow the same steps described for [the WordPress VM]({{% relref "validate_the_minione_environment#step-2-instantiate-the-vm" %}}):

1. In the left-hand pane, go to **Templates** -> **VM Templates**.
1. Select **Capi**, then click the **Instantiate** icon at the top.
1. Sunstone displays the **Instantiate VM Template** wizard. In this wizard you can modify the VM's capacity to your requirements, or leave the default values.
1. In the last screen of the wizard, click **Finish**.

Sunstone will display the **Instances** -> **VMs** screen, showing the newly-created VM:

![><](/images/capi_vm_running.png)

Wait a few moments until the VM displays the **RUNNING** state.

### From the Command Line

To instantiate the Capi appliance template without additional usere inputs, as user `oneadmin` run:

```bash
onetemplate instantiate Capi --nic vnet
```

The above command instantiates the template and attaches the public virtual network NIC to the VM.

When you run the command, you will be prompted for user inputs such as the versions for CAPONE, K3s and Turtles. For this tutorial we can leave the values at their defaults, by hitting **Enter** at each prompt.

```default
oneadmin@frontend:~$ onetemplate instantiate Capi --nic vnet
There are some parameters that require user input. Use the string <<EDITOR>> to launch an editor (e.g. for multi-line inputs)
  * (ONEAPP_CAPI_CAPONE_VERSION) Capone Version
  * (ONEAPP_CAPI_CERT_MANAGER_VERSION) Cert Manager Chart Version
  * (ONEAPP_CAPI_K3S_VERSION) K3s Version
  * (ONEAPP_CAPI_RANCHER_HOSTNAME) Rancher Hostname
  * (ONEAPP_CAPI_RANCHER_PASSWORD) Rancher Password
  * (ONEAPP_CAPI_RANCHER_VERSION) Rancher Chart Version
  * (ONEAPP_CAPI_TURTLES_VERSION) Turtles Chart Version
VM ID: 
2
```

The last number in the command output is the ID for the Virtual Machine, in this case `2`.

## Connecting to the Rancher UI

You may need to wait a few minutes for the K3s cluster and the Rancher web UI to become available.

To connect to the Rancher interface, fire up a web browser and go to `https://<VM IP>.sslip.io`. You can obtain the VM's IP from the Sunstone UI (see image above), or by running:

```bash
onevm show <VM ID>
```

where `VM ID` is the number given by `onetemplate instantiate` above. To quickly filter the output for the VM, run:

```bash
onevm show <VM ID> | grep ETH0_IP=
```

For example:

```default
oneadmin@frontend:~$ onevm show 2 | grep ETH0_IP=
  ETH0_IP="172.16.100.3",
```

In this case we would connect to `https://172.16.100.3.sslip.io`.

![><](images/rancher_login.png)

If you did not set a password when instantiating the VM, log in with these credentials:

- **Username**: `admin`
- **Password**: `capi1234`

{{< alert title="Warning" color="warning" >}}
With the default resources, the complete configuration process can take between 6 and 8 minutes to complete. Occasionally, a bug related to the installation of Turtles -- specifically with the `helm-install-rancher-turtles` pod -- may cause the installation to hang. In such cases, if the Rancher interface does not come up you will need to restart the process.
{{< /alert >}}

{{< alert title="Tip" color="success" >}}
If the Rancher UI takes too long to become available or if you prefer to monitor the process manually, you can log in to the VM with:


```bash
onevm ssh <VM ID>
```

This will log you in as user `root`. To see the status of the pods during the configuration process, run:

```bash
kubectl get pods -A
```
{{< /alert >}}

## Deploying an OpenNebula RKE2 Cluster

To deploy an OpenNebula RKE2 cluster, you can import a YAML file for the cluster or use the Helm charts provided by OpenNebula for Kubeadm and RKE2. For this tutorial we will install via the GUI using the RKE2 Helm chart.

To install from the Helm chart, follow these steps:

In Rancher's left-hand navigation pane, go to the Management Cluster by clicking the Rancher icon ![rancher](/images/icons/rancher/rancher_icon.png), then select **Apps** -> **Charts**.

In the **Filter charts results** input field, type `capone`. This should display two charts:

![><](/images/rancher-capone_apps.png)

For this tutorial, select `capone-rke2`.

Rancher will take you to a screen for the chart. To install, click the **Install** button at top right.

In the next screen, you can specify the namespace where the resources will be created, as well as an optional name for the cluster. In this example we will use the `default` namespace, and name `capone4`.

Click **Next**. The next screen shows the YAML configuration file. Here you will need to edit some parameters to adapt the deployment to your environment.

![><](/images/rancher_capone_yaml.png)

{{< alert title="Note" color="success" >}}
It is not necessary to import the appliances related to CAPONE -- the only requirement is that the public and private networks in the cluster definition already exist, as will be shown below.
{{< /alert >}}

Scroll down to the end of the YAML file:

![><](/images/rancher_capone_yaml_bottom.png)

Here you will to ensure that the values of the following parameters match your installation:

- `ONE_AUTH`: User credentials for the Front-end, in `<user>:<password>` format. By default, the user is `oneadmin`. The password is the same as for logging in to Sunstone. If you installed your Front-end using miniONE, the credentials were shown at the end of the installation output. (If you installed using miniONE and are unsure of the credentials, on the Front-end check the contents of `/var/lib/one/.one/one_auth`.)
- `ONE_XMLRPC`: The XML RPC endpoint. This will be the base address of the public network that the VM is connected to. In this example, the network is `vnet` and the address is `172.16.100.1`.
- `PRIVATE_NETWORK_NAME`: Name for the private network created on the Front-end, in our case `private`.
- `PUBLIC_NETWORK_NAME`: Name for the public network created on the Front-end, in our case `vnet`.

The parameters that were modified for this example are shown below:

```bash
ONE_AUTH: oneadmin:ZMCoOWUsBg
ONE_XMLRPC: http://172.16.100.1:2633/RPC2
PRIVATE_NETWORK_NAME: private
PUBLIC_NETWORK_NAME: vnet
```

After modifying the parameters, click the **Install** on the bottom right corner.

The application should install and deploy; this process can take a few minutes.

To see the deployed application, in Rancher's left nav pane go to the Management Cluster, then select **Apps** -> **Installed Apps**. The list of applications should show the name of the cluster you deployed (in this example, `capone4`), with status `Deployed`.

![><](/images/rancher_capone_deployed.png)

{{< alert title="Note" color="success" >}}
You can also verify the deployment on the Front-end, by verifying that three new Virtual Machines have been instantiated:
- On the command line, as user `oneadmin` run `onevm list`:

```default
oneadmin@PC07:~$ onevm list
  ID USER     GROUP    NAME                                         STAT  CPU     MEM HOST                                TIME
   4 oneadmin oneadmin capone4-ljm6z                                runn    1      3G localhost                       0d 00h01
   3 oneadmin oneadmin vr-capone4-cp-0                              runn    1    512M localhost                       0d 00h01
   2 oneadmin oneadmin Capi-2                                       runn    2      8G localhost                       2d 19h37
   0 oneadmin oneadmin Alpine Linux 3.20-0                          runn    1    256M localhost                       2d 20h03
```

This shows the Virtual Router `vr-capone4-cp-0`, the master node `capone4-ljm6z`, and the Capi appliance `Capi-2`; as well as an Alpine Linux VM previously installed.

- On the Sunstone UI, you can see the list of instantiated VMs by going to the left-hand pane and selecting **Instances** -> **VMs**.
{{< /alert >}}

## Importing the Workload Cluster into Rancher

To manage the workload cluster in the Rancher UI, you must first import it into Rancher.

To import the cluster, in the left-hand pane go to Cluster Management by clicking the "farmhouse" icon ![icon](/images/icons/rancher/farmhouse.png) near the bottom. Then, in the **Clusters** screen select the `capone4` cluster.

Rancher displays the screen for the cluster, shown below.

![><](/images/rancher_capone_import.png)

This screen shows alternative commands for importing the workload cluster. In this case, since the Rancher installation uses a self-signed certificate, we will import the cluster using the second command, with `curl` and `kubectl`:

```bash
curl --insecure -sfL https://172.16.100.3.sslip.io/v3/import/<name>.yaml | kubectl apply -f -
```

Copy the command from the screen (clicking on the command in the Rancher screen should copy it to the clipboard). You will need to enter the command in the Kubectl Shell for the Management Cluster.

To go to the Kubectl Shell for the Management Cluster, go to Cluster Management. Then, in the **Clusters** screen select the `local` cluster and click the 3-dot icon ![icon](/images/icons/rancher/3_dots_menu.png) on the right.

![><](/images/rancher_open_kubectl_shell.png)

Rancher should display a tab on the bottom of the screen, with the **Kubectl:local** shell:

![><](/images/rancher_kubectl_shell.png)

First, before running the import command you must retrieve the kubeconfig file for the workload cluster. For cluster `capone4`, run:

```bash
kubectl get secrets capone4-kubeconfig -o jsonpath="{.data.value}" | base64 -d > one-kubeconfig
```

This downloads the configuration for the cluster into the `one-kubeconfig` file.

Now it's time to import the cluster into Rancher. Paste the command you copied [above](#importing-the-workload-cluster-into-rancher). This command takes the form:

```bash
curl --insecure -sfL https://<import-yaml>  | kubectl apply --kubeconfig one-kubeconfig -f -
```

Where `<import-yaml` is the IP address and YAML name given previously by Rancher, i.e. the command that you copied from the clipboard. For example:

```default
curl --insecure -sfL https://172.16.100.3.sslip.io/v3/import/tz6fbq7c78wmwhsq9cskmpdxcdpwttr4cjlplbrdw5k77rkzvq6vmw_c-94vbm.yaml | kubectl apply --kubeconfig one-kubeconfig -f -
```

This will import the cluster into Rancher, which should take a few seconds.

Once the cluster has been imported, it becomes fully accessible from the Rancher UI, where it is displayed alongside the K3s cluster.

![><](/images/rancher_2_clusters_listed.png)

You can now explore and use the cluster, for instance installing Helm charts, executing `kubectl` commands, and even upgrading the Kubernetes version of the cluster.

## Operating the Workload Cluster

This section provides a brief overview of performing day-to-day operations on the workload cluster through the Rancher UI. This section provides details for:

- Install Longhorn
- Create a Persistent Volume Claim (PVC) on Longhorn
- Deploy an Nginx instance that uses the Longhorn volume

### Installing Longhorn

In the workload cluster, use the left-hand nav pane to go to **Apps** -> **Charts**. In the **Filter charts results** input field, type `longhorn`, then select the **Longhorn** chart.

Rancher should display screen for Longhorn:

![><](/images/rancher_longhorn_chart.png)

Click the **Install** button at top right.

The Rancher UI will take you to the **Installed Apps** screen, where Longhorn should be displayed as "Deployed".

![><](/images/rancher_apps_longhorn_deployed.png)

### Creating a Persistent Volume Claim on Longhorn

In this step we will create the Persistent Volume Claim that will be used by our Nginx deployment.

To create a PVC, in the left-hand nav pane for the cluster select **Storage** -> **PersistentVolumeClaims**.

![><](/images/rancher_create_pvc.png)

Rancher will display the **PersistentVolumeClaims** screen. To create a new PVC, click **Create**.

Fill in the required parameters for the PVC:

- In the **Name** field, `nginx`
- In **Source**, leave at its default option, "Use a Storage Class to provision a new Persistent Volume"
- In **Request Storage**, you can modify the default value of 10 GiB to your needs. In this example we will set it to 2 GiB

![><](/images/rancher_create_pvc.png)

Click **Create**.
