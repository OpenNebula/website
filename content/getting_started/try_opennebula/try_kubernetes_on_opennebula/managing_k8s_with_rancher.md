---
title: "Managing Kubernetes with Rancher and the Cluster API Integration"
date: "2025-02-17"
type: docs
description:
---

<a id="running-kubernetes-clusters"></a>

## Overview

Previous tutorials of this Quick Start guide show how to use miniONE to:

- [Install an OpenNebula Front-end and a KVM Host on-premises]({{% relref "deploy_opennebula_onprem_with_minione" %}})
- [Validate the environment]({{% relref "validate_the_environment" %}}) created by miniONE, by running a Virtual Machine

This tutorial builds on the infrastructure created in those previous tutorials. It shows how to use OpenNebula to quickly and easily install the [Rancher](https://www.rancher.com) Kubernetes management platform, and how to use Rancher's point-and-click interface to provision OpenNebula CAPI RKE2 clusters. It includes complete examples for deploying services, applying configurations, and upgrading the workload cluster.

This tutorial was designed and tested in an on-premises installation. You can use it, for example, as a continuation of [OpenNebula On-prem with miniONE]({{% relref "deploy_opennebula_onprem_with_minione" %}}). If you wish to deploy a production-grade Kubernetes cluster on Amazon AWS, please see [Run a Kubernetes Cluster]({{% relref "running_kubernetes_clusters" %}}).

### OpenNebula's CAPI Appliance

The [Kubernetes Cluster API](https://cluster-api.sigs.k8s.io/introduction) (CAPI) is a set of declarative APIs designed for simplifying and automating Kubernetes life cycle management. [OpenNebula's Kubernetes (CAPI) appliance](https://marketplace.opennebula.io/appliance/c33522e7-7b7e-4046-bc23-833797431bf0) provides a ready-to-use solution for managing Kubernetes clusters through the Rancher web UI. The appliance is fully integrated to support OpenNebula as an infrastructure provider via the [Cluster API Provider for OpenNebula](https://github.com/OpenNebula/cluster-api-provider-opennebula).

As shown in this tutorial, the CAPI appliance eliminates the need for manual configuration -- it allows you to effortlessly create, manage, and upgrade CAPI-managed RKE2 clusters, greatly reducing operational overhead.

This tutorial shows how to: 

- Download and install the CAPI Appliance
- Log in to Rancher and deploy an RKE2 cluster
- Import the cluster into Rancher
- Deploy a sample application
- Deploy additional services
- Upgrade the workload cluster

### Pre-requisites

To follow this tutorial you will need:

- An [OpenNebula Front-end running on premises]({{% relref "deploy_opennebula_onprem_with_minione" %}}) (version >=6.10) on a machine that meets the [Rancher installation requirements](https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/installation-requirements#rke2-kubernetes):
   - 4 vCPUs
   - 16 GiB RAM
- The [OneGate service]({{% relref "onegate_usage" %}}) must be running on the Front-end (it is enabled by default if you installed with miniONE).
- A public and a private virtual network on your Front-end. The public network is installed automatically by miniONE; creating a private network is explained below.

### Tutorial Outline

For completing this tutorial, we'll follow these high-level steps:

1. Create a private network on the Front-end.
1. Download the CAPI Appliance.
1. Instantiate the CAPI Appliance.
1. Connect to the Rancher UI.
1. Deploy an OpenNebula RKE2 cluster.
1. Import the cluster into Rancher.

Additionally, we'll perform various operations on the workload cluster:
   - Install Longhorn
   - Deploy an Nginx service
   - Add a worker node to the cluster
   - Upgrade the workload cluster to the newest version

## Step 1. Create a Private Network on the Front-end

In this step we will create a new virtual network and assign a range of private IPs to it. This network will be used by the Virtual Machines in the workload Kubernetes cluster.

To create the network in Sunstone, open the left-hand pane, then select **Networks** -> **Virtual Networks**. Sunstone displays the **Virtual networks** page. If you installed using miniONE, this screen shows the public network automatically installed, called **vnet**:

![image](/images/sunstone-virtual_networks.png)

Click the **Create** button at the top. Sunstone will display the **Create Virtual Network** screen. Enter a name for the network -- for this example we will use `private`. Then, click **Next**.

In the next screen, activate the **Use only private host networking** switch:

![image](/images/sunstone-create_priv_network.png)

Then, click the **Addresses** tab. Here we will enter a range of private IP addresses. For this example, in **First IPv4 address** enter `192.168.200.2`, and set the network size to `100`.

![image](/images/sunstone-create_priv_network_2.png)

Click **Finish**.

## Step 2. Download the CAPI Appliance

From your OpenNebula Front-end, you can download the CAPI appliance from the Sunstone UI or from the command line.

### Download from the Sunstone UI

You can download the CAPI appliance by following the same steps as when [downloading the WordPress VM]({{% relref "validate_the_environment#step-1-download-the-wordpress-appliance-from-the-opennebula-marketplace" %}}):

1. On the left-hand pane, go to **Storage** -> **Apps**.
1. On the **Apps** screen showing the available apps, filter for `capi`.
1. Click **Service Capi** to select it, then click **Import**.
1. In the import wizard, select the **default** image datastore, then click **Finish**.

### Download from the Command Line

On the Front-end, as the `oneadmin` user run:

```bash
onemarketapp export 'Service Capi' Capi --datastore default
```

This automatically downloads the **Service Capi** appliance into the default datastore.

## Step 3. Instantiate the CAPI Appliance

### From the Sunstone UI

To instantiate the Service Capi appliance, follow the same steps described for [the WordPress VM]({{% relref "validate_the_environment#step-2-instantiate-the-vm" %}}):

1. In the left-hand pane, go to **Templates** -> **VM Templates**.
1. Select **Capi**, then click the **Instantiate** icon at the top.
1. Sunstone displays the **Instantiate VM Template** wizard. In this wizard you can modify the VM's capacity to your requirements, or leave the default values.
1. In the last screen of the wizard, click **Finish**.

Sunstone will display the **Instances** -> **VMs** screen, showing the newly-created VM:

<a id="capi_vm_running"></a>
![><](/images/capi_vm_running.png)

Wait a few moments until the VM displays the **RUNNING** state.

### From the Command Line

To instantiate the Capi appliance template without additional user inputs, as user `oneadmin` run:

```bash
onetemplate instantiate Capi --nic vnet
```

This instantiates the template and attaches the NIC on the public network, **vnet**, to the Virtual Machine.

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

If you leave the Rancher password empty, it will default to `capi1234` (username `admin`).

The last number in the command output is the ID for the Virtual Machine, in this case `2`.

{{< alert title="Note" color="success" >}}
You will need to wait some minutes for the K3s cluster and the Rancher web UI to become available. The total time will depend on the Front-end machine and the resources assigned to the cluster -- with the default resource values, the configuration process may take 6 to 8 minutes to complete.
{{< /alert >}}

## Step 4. Connect to the Rancher UI

To connect to the Rancher interface, fire up a web browser and go to `https://<VM IP>.sslip.io`. In this tutorial, the IP is `172.16.100.3`. You can obtain the VM's IP from the Sunstone UI: in the left-hand pane go to **Instances** -> **VMs**, then check IP address displayed for the VM (see image [above](#capi_vm_running)).

Alternatively, on the Front-end run:

```bash
onevm show <VM ID>
```

where `VM ID` is the number that was given by the `onetemplate instantiate` command. To quickly filter the IP from the output of `onevm show`, you can run:

```bash
onevm show <VM ID> | grep ETH0_IP=
```

For example:

```default
oneadmin@frontend:~$ onevm show 2 | grep ETH0_IP=
  ETH0_IP="172.16.100.3",
```

In this case we will connect to `https://172.16.100.3.sslip.io`.

![><](images/rancher_login.png)

If you did not set a password when instantiating the VM, log in with these credentials:

- **Username**: `admin`
- **Password**: `capi1234`

{{< alert title="Warning" color="warning" >}}
As mentioned above, with the default resources the complete configuration process for the K3s cluster and Rancher can take between 6 and 8 minutes to complete. Occasionally, a bug related to the installation of Turtles -- specifically with the `helm-install-rancher-turtles` pod -- may cause the installation to hang. In such cases, if the Rancher interface does not come up you will need to restart the process.
{{< /alert >}}

{{< alert title="Tip" color="success" >}}
If the Rancher UI takes too long to become available or if you prefer to monitor the process manually, you can log in to the Capi VM with:

```bash
onevm ssh <VM ID>
```

This will log you in as user `root`. To see the status of the pods during the configuration process, run:

```bash
kubectl get pods -A
```
{{< /alert >}}

## Step 5. Deploy an OpenNebula RKE2 Cluster

To deploy an OpenNebula RKE2 cluster, there are two available options:

- Import a YAML file for the cluster
- Use the Helm charts provided by OpenNebula for Kubeadm and RKE2

For this tutorial we will use the second option, installing via the GUI using the RKE2 Helm chart.

To install from the Helm chart, follow these steps:

In Rancher's left-hand navigation pane, go to the Management Cluster by clicking the Rancher icon ![rancher](/images/icons/rancher/rancher_icon.png), then select **Apps** -> **Charts**.

In the **Filter charts results** input field, type `capone`. This should display two charts, `capone-kadm` and `capone-rke2`.

![><](/images/rancher-capone_apps.png)

For this tutorial, select `capone-rke2`.

Rancher will take you to a screen displaying chart details. To install, click the **Install** button at top right.

In the next screen, you can specify the namespace where the resources will be created, as well as an optional name for the cluster. In this example we will use the `default` namespace, and name `capone4`.

Click **Next**. The next screen shows the YAML configuration file. Here you will need to edit some parameters to adapt the deployment to your environment.

![><](/images/rancher_capone_yaml.png)

{{< alert title="Note" color="success" >}}
It is not necessary to import the CAPONE appliances -- the only requirement is that the public and private networks in the cluster definition already exist, as will be shown below.
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

After modifying the parameters, click the **Install** button on the bottom right corner.

The cluster should install and deploy; this process can take a few minutes.

In Rancher's left-hand navigation pane, go to the Management Cluster by clicking the Rancher icon ![rancher](/images/icons/rancher/rancher_icon.png), then select **Apps** -> **Installed Apps**. The list of applications should show the name of the cluster you deployed (in this example, `capone4`), with status `Deployed`.

![><](/images/rancher_capone_deployed.png)

{{< alert title="Note" color="success" >}}
You can also verify the deployment on the Front-end, by verifying that three new Virtual Machines have been instantiated:
- On the command line, as user `oneadmin` run `onevm list`:

```default
oneadmin@frontend:~$ onevm list
  ID USER     GROUP    NAME                                         STAT  CPU     MEM HOST                                TIME
   4 oneadmin oneadmin capone4-ljm6z                                runn    1      3G localhost                       0d 00h01
   3 oneadmin oneadmin vr-capone4-cp-0                              runn    1    512M localhost                       0d 00h01
   2 oneadmin oneadmin Capi-2                                       runn    2      8G localhost                       2d 19h37
   0 oneadmin oneadmin Alpine Linux 3.20-0                          runn    1    256M localhost                       2d 20h03
```

This shows the Virtual Router `vr-capone4-cp-0`, the master node `capone4-ljm6z`, and the Capi appliance `Capi-2`; as well as an Alpine Linux VM previously installed.

- On the Sunstone UI, you can see the list of instantiated VMs by going to the left-hand pane and selecting **Instances** -> **VMs**.
{{< /alert >}}

## Step 6. Import the Cluster into Rancher

To manage the cluster in the Rancher UI, you must first import it into Rancher.

To import the cluster, in the left-hand pane go to Cluster Management by clicking the "farmhouse" icon ![icon](/images/icons/rancher/farmhouse.png) near the bottom. Then, in the left-hand pane select **Clusters**, and in the **Clusters** screen select the `capone4` cluster.

Rancher displays the screen for the cluster, shown below.

![><](/images/rancher_capone_import.png)

This screen shows three alternative commands that you can use for importing the cluster. In this case, since the Rancher installation uses a self-signed certificate, we will use the second command, with `curl` and `kubectl`:

```bash
curl --insecure -sfL https://172.16.100.3.sslip.io/v3/import/<import file>.yaml | kubectl apply -f -
```

Copy the command from the screen (you can click the command to copy it to the clipboard).

You will need to enter the command in the Kubectl Shell for the Management Cluster. To go to the Kubectl Shell for the Management Cluster, go to **Cluster Management** (via the "farmhouse" icon ![icon](/images/icons/rancher/farmhouse.png) at bottom left). Then, in the **Clusters** screen select the `local` cluster, click the three-dot menu ![icon](/images/icons/rancher/3_dots_menu.png) on the right, and select **Kubectl Shell** from the drop-down.

![><](/images/rancher_open_kubectl_shell.png)

Rancher should display a tab on the bottom of the screen, with the **Kubectl:local** shell:

![><](/images/rancher_kubectl_shell.png)

First, before running the import command you must retrieve the kubeconfig file for the workload cluster. For cluster `capone4`, run:

```bash
kubectl get secrets capone4-kubeconfig -o jsonpath="{.data.value}" | base64 -d > one-kubeconfig
```

This downloads the configuration for the cluster into the `one-kubeconfig` file.

Now it's time to import the cluster into Rancher. Paste the command you copied [above](#step-6-import-the-cluster-into-rancher), for example:

```default
curl --insecure -sfL https://172.16.100.3.sslip.io/v3/import/tz6fbq7c78wmwhsq9cskmpdxcdpwttr4cjlplbrdw5k77rkzvq6vmw_c-94vbm.yaml | kubectl apply --kubeconfig one-kubeconfig -f -
```

This will import the cluster into Rancher, which should take a few seconds.

Once the cluster has been imported, it becomes fully accessible from the Rancher UI, where it is displayed alongside the K3s cluster.

![><](/images/rancher_2_clusters_listed.png)

You can now explore and use the cluster -- for instance installing Helm charts, executing `kubectl` commands, and even upgrading the Kubernetes version of the cluster. In the next sections we will perform a few example operations.

## Operating the Cluster

This section provides a brief overview of performing day-to-day operations on the workload cluster through the Rancher UI. Here we will:

- Install Longhorn
- Create a Persistent Volume Claim (PVC) on Longhorn
- Deploy an Nginx instance that uses the Longhorn volume
- Expose the Nginx instance

### Installing Longhorn

In the `capone4` cluster, select **Cluster Management**, then the `capone4` cluster:

![><](/images/rancher_goto_wkload_cluster.png)

In the left-hand nav pane for the cluster, go to **Apps** -> **Charts**. In the **Filter charts results** input field, type `longhorn`.

![><](/images/rancher_install_longhorn.png)

Select the **Longhorn** chart. Rancher should display the details screen for Longhorn:

![><](/images/rancher_longhorn_chart.png)

Click the **Install** button at top right.

The Rancher UI will take you to the **Installed Apps** screen, where Longhorn should be displayed as "Deployed" (near the bottom of the image below).

![><](/images/rancher_apps_longhorn_deployed.png)

### Creating a Persistent Volume Claim on Longhorn

In this step we will create the Persistent Volume Claim that will be used by our Nginx deployment.

To create a PVC, in the left-hand nav pane for the cluster select **Storage** -> **PersistentVolumeClaims**.

![><](/images/rancher_create_pvc.png)

Rancher will display the **PersistentVolumeClaims** screen. To create a new PVC, click **Create**.

Fill in the required parameters for the PVC:

- In the **Name** field, type `nginx`
- In **Source**, leave at its default option, "Use a Storage Class to provision a new Persistent Volume"
- In the **Storage Class** drop-down, select `longhorn`
- In **Request Storage**, you can modify the default value of 10 GiB to your needs. In this example we will set it to 2 GiB

![><](/images/rancher_create_pvc_2.png)

Click **Create**.

The PVC should now be listed in the **Storage** -> **PersistentVolumeClaims** tab for the cluster, shown below.

![><](/images/rancher_pvc_created.png)

### Creating an Nginx Deployment

We will create the Nginx deployment by importing the deployment's YAML definition, to illustrate Rancher's YAML import feature.

Go to the **Cluster Dashboard** (click the icon for the cluster on the left, then in the cluster nav pane click **Cluster**). Then, in the top bar click the **Import YAML** icon ![Import YAML](/images/icons/rancher/import_yaml.png):

![><](/images/rancher_import_yaml.png)

Rancher displays the **Import YAML** screen. To deploy Nginx, you can copy and paste the following definition:

```yaml
---
kind: Deployment
apiVersion: apps/v1
metadata:
  name: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: http
        image: nginx:alpine
        imagePullPolicy: IfNotPresent
        ports:
        - name: http
          containerPort: 80
        volumeMounts:
        - mountPath: "/persistent/"
          name: nginx
      volumes:
      - name: nginx
        persistentVolumeClaim:
          claimName: nginx
```

Paste the definition into the input box, then click **Import**. Rancher will create a simple Nginx deployment that mounts the PVC we previously created.

![><](/images/rancher_yaml_imported.png)

To see the Nginx deployment, in the menu for the cluster select **Deployments**, and in the `default` namespace look for `nginx`.

![><](/images/rancher_nginx_deployment.png)

Clicking `nginx` displays additional information for the deployment, including its IP, in this case `10.42.0.32`:

![><](/images/rancher_nginx_deployment_2.png)

### Checking the Nginx Deployment from OpenNebula (Optional)

This optional step shows how you can check the Nginx deployment without logging into Rancher.

The node where Nginx is running is the Virtual Machine created by OpenNebula as part of the workload cluster, which you can see in Sunstone (**Instances** -> **VMs**), or by running `onevm list` on the Front-end node:

```default
oneadmin@frontend:~$ onevm list
  ID USER     GROUP    NAME                                         STAT  CPU     MEM HOST                                TIME
   4 oneadmin oneadmin capone4-ljm6z                                runn    1      3G localhost                       0d 00h01
   3 oneadmin oneadmin vr-capone4-cp-0                              runn    1    512M localhost                       0d 00h01
   2 oneadmin oneadmin Capi-2                                       runn    2      8G localhost                       2d 19h37
   0 oneadmin oneadmin Alpine Linux 3.20-0                          runn    1    256M localhost                       2d 20h03
```

To quickly check that the Nginx deployment is working, you can log in to the VM from the Front-end with `onevm ssh <VM ID>` (in this case `4`):

```bash
onevm ssh 4
```

And run `curl` against the deployment's IP (in this case `10.42.0.32`):

```default
root@capone4-ljm6z:/var/log# curl 10.42.0.32
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
root@capone4-ljm6z:/var/log#
```

At this point we know that the Nginx deployment is working. In the next step we will expose it and check the result on a web browser.

### Exposing the Nginx Deployment

For this tutorial, we'll expose the Nginx deployment by creating a **NodePort** service.

To create the service, in Rancher click the **Import YAML** icon ![Import YAML](/images/icons/rancher/import_yaml.png) in the top bar. Then, copy-paste the below definition:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 30080
  type: NodePort
```

This will expose port 80 of the pod running the `nginx` service on port 30080 of the master node in the `capone4` cluster.

After clicking **Import**, you should see `nginx-service` in the cluster's **Services** tab:

![><](/images/rancher_nginx-service.png)

Now your Nginx deployment should be visible on the external IP of the node -- which in this example setup is `192.168.100.4` -- on port 30080:

![><](/images/rancher_nginx_welcome_screen.png)

## Additional Tasks

### Adding Worker Nodes to the Cluster

{{< alert title="Note" color="success" >}}
Before creating a replica, ensure you have enough resources allocated to the Capi deployment, and on the machine running the Front-end.
{{< /alert >}}

To add a Worker Node to the cluster, use CAPI to create a replica of the cluster.

In Rancher, go to **Cluster Management**, then in the left-hand nav pane **CAPI** -> **Machine Deployments**. Rancher should display the current deployment of the `capone4` cluster. Clicking the deployment name shows the YAML file for the deployment. To add a replica, click the three-dot menu ![icon](/images/icons/rancher/3_dots_menu.png) at top right, then select **Edit YAML**. Find the string `replicas: 1` and change the number to the desired number of replicas.

![><](/images/rancher_create_replica.png)

### Upgrading the Workload Cluster

To upgrade the cluster from within Rancher, select **Cluster Management** at bottom left, then **Clusters** on the left-hand pane. Click the three-dot menu ![icon](/images/icons/rancher/3_dots_menu.png) for the cluster, then select **Edit Config** from the drop-down.

![><](/images/rancher_edit_config.png)

Rancher should display the configuration screen for the cluster. In the **Basics** section, select the desired version for upgrading.

![><](/images/rancher_cluster_conf_screen.png)

Rancher should display the **Clusters** screen, where the cluster should display status `Upgrading`. The upgrade can take several minutes. To see the upgrade process, click the **Explore** button to the right of the cluster -- this takes you to the Cluster Dashboard where upgrade messages are displayed.

When the upgrade is finished, the **Clusters** screen should display the cluster with the new version.

![><](/images/rancher_cluster_upgraded.png)

Congratulations! You have successfully deployed a K3s cluster with the Rancher management platform as well as a production-grade workload cluster where you've created, exposed and tested a deployment -- all with minimal configuration and using graphical interfaces.

## Next Steps

This tutorial marks the end of the Quick Start guide.

To learn about OpenNebula in depth, the next sections of the documentation include all of the information necessary for [configuration and administration]({{% relref "product/index" %}}), as well as software [life cycle, releases and installation details]({{% relref "software/index" %}}).

If you are interested in installing OpenNebula by following further tutorials, you can head over to [Automatic Installation with OneDeploy]({{% relref "software/installation_process/automatic_installation_with_onedeploy/one_deploy_overview" %}}) to automatically install a production-ready OpenNebula cloud.
