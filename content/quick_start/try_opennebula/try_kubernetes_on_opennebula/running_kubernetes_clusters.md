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

<!-- We continue from the Deploy miniONE on Bare Metal.

4 roles:
VNF
master
worker
storage

Steps:

1. Create a private net
Go to Networks, then Virtual Networks - 1.network.png -, click **Create**.
Select host-only (see 2.network...png)
Add **Addresses**: Click **Address Range** - 1st 192.168.200.2 - size 100
You don't need any other config for the network since all VMs will communicate through the VNF

2. Donwload **Service OneKE 1.31** from the OpenNebula Marketplace
Go to Storage -> Apps, filter for the thing, select **Import**
Several things will be imported: service template itself, VM templates, and VM images.

3. Instantiate **Service OneKE 1.31**
Go to **Service Templates**, select it and click the Play Icon
  - Select a Name (at least 3 chars)
  - 1 instance to be deployed , then lcick Next
  Next screen: **Networks**:
  Select vnet for Public and privnet for Private
    BEAR IN MIND that with this setup you will have to use the VNF node to connect to the VMs 
  Click Next.
  Next screen: **Service Inputs**
    Virtual IPs: VIP for the VNF node. If you change this, you will need to add your IP to the ApiServer extracertificate SANs box or you'll get an error when trying to run kubectl.
    Scroll down and click **Enable Longhorn** and **Enable Traefik**.
    In **Virtual Network Functions** ensure **Enable DNS recursor" and **NAT4** and **ROUTER4** are activated. 
 Next screen: **Charter** - leave as is -->

{{< alert title="Warning" color="warning" >}}
The deployment described in this page has not been tested for this Beta version.
{{< /alert >}}

{{< alert color="success" >}}
The definitive version of this page will be published with the upcoming 7.0 stable release. Stay tuned!
{{< /alert >}}

This page illustrates how to download a Kubernetes cluster from the OpenNebula Marketplace and deploy it on a remote cloud cluster. For this example, the cloud cluster is provisioned on AWS, and has at least two virtual networks configured: a private and a public network, that pre-allocates elastsic IPs.

Like the WordPress VM, the Kubernetes cluster is available in the [OpenNebula Public Marketplace](https://marketplace.opennebula.io). You can find it as the multi-VM appliance **Service OneKE**, the OpenNebula Kubernetes Edition.

To deploy the Kubernetes cluster, we’ll follow these high-level steps:

> 1. Download the OneKE Service from the OpenNebula Marketplace.
> 2. Instantiate a private network on the Edge Cluster.
> 3. Instantiate the Kubernetes Service.
> 4. Deploy an application on Kubernetes.

This tutorial includes a preliminary section to avoid known problems related to a datastore parameter in AWS, and a [Known Issues]({{% relref "#k8s-known-issues" %}}) section at the end for troubleshooting.

In this tutorial we’ll perform a basic install of the Kubernetes cluster. The OneKE appliance offers options such as High Availability, Longhorn storage, load balancing and CNI plugins, which are out of the scope of this guide. For the full documentation of the OneKE appliance, please see the [OpenNebula Apps Documentation](https://github.com/OpenNebula/one-apps/wiki).

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

Click **Next**.

In the last screen, click **Finish**.

+++

### Verify the Cluster Deployment

To verify that the Kubernetes cluster and its VMs have correctly deployed, you can either use the Sunstone UI, or run the `onevm` command on the Front-end node.

To verify in the Sunstone GUI, open the left-hand pane, then Select **Instances** -> **Services**. You should see the OneKE service up and running, with its running VMs visible in the **Roles** tab.

To verify the deployment using the command line, log in to the Front-end node as user `oneadmin`, then run `oneflow list`. In the command output, check that the State is `RUNNING`, as shown below.

```default
[oneadmin@FN]$ oneflow list
ID USER     GROUP    NAME                                 STARTTIME STAT
3 oneadmin oneadmin Service OneKE 1.29              04/29 08:18:17  RUNNING
```

To verify that the VMs for the cluster were correctly deployed, you can use the `onevm list` command. In the example below, the command lists the VMs for the cluster (and, in this case, the WordPress VM deployed in the previous tutorial):

```default
[oneadmin@FN]$ onevm list
ID USER     GROUP    NAME                                            STAT  CPU     MEM HOST                                          TIME
 3 oneadmin oneadmin worker_0_(service_3)                            runn    2      3G <cluster_public_IP>                       0d 00h31
 2 oneadmin oneadmin master_0_(service_3)                            runn    2      3G <cluster_public_IP>                       0d 00h31
 1 oneadmin oneadmin vnf_0_(service_3)                               runn    1    512M <cluster_public_IP>                       0d 00h31
 0 oneadmin oneadmin Service WordPress - KVM-0                       runn    1    768M <cluster_public_IP>                       0d 01h22
```

At this point you have successfully instantiated the Kubernetes cluster. Before deploying an application, you need to find out the **public** IP address of the VNF node, since we will use it later to connect to the master Kubernetes node.

<a id="check-vnf"></a>

### Check the IP Address for the VNF Node

To check the VNF node IP in Sunstone, in the left-hand pane go to **Instances** -> **VMs**, then check the information displayed under **vnf_0_(service_<ID>)**. The IP is displayed on the right, highlighted in the image below (note that all public IPs have been blurred in the image):

> ![image](/images/sunstone-aws_k8s_vms_list.png)

Alternatively, to check on the command line, log in to the Front-end and run:

```bash
onevm show -j <VNF_VM_ID>|jq -r .VM.TEMPLATE.NIC[0].EXTERNAL_IP
```

Replace `<VNF_VM_ID>` with the ID of the VNF VM as listed by the `onevm list` command (ID `1` in the example above).

If you do not see all VMs listed, or if the OneKE Service is stuck in `DEPLOYING`, see [Known Issues]({{% relref "#k8s-known-issues" %}}) below.

{{< alert title="Tip" color="info" >}}
Once the OneFlow service has deployed, you can add more worker nodes. In Sunstone:

1. Go to **Instances** -> **Services**.
2. Select the OneKE service.
3. Select the **Roles** tab.
4. Click **Worker**, then the green **Scale** button.{{< /alert >}}  

{{< alert title="Note" color="success" >}}
The VNC icon ![icon5](/images/icons/sunstone/VNC.png) displayed by Sunstone does not work for accessing the VMs on Edge Clusters, since this access method is considered insecure and is disabled by OpenNebula.{{< /alert >}} 

<a id="step-4"></a>

## Step 4. Deploy an Application

To deploy an application, we will first connect to the master Kubernetes node via SSH.

For connecting to the master Kubernetes node, you need to know the public address (AWS elastic IP) of the VNF node, as described [above]({{% relref "#check-vnf" %}}).

Once you know the correct IP, from the Front-end node connect to the master Kubernetes node with the below command (replace “1.2.3.4” with the public IP address of the VNF node):

```bash
$ ssh -A -J root@1.2.3.4 root@172.20.0.2
```

In this example, `172.20.0.2` is the private IP address of the Kubernetes master node (the second address in the private network).

{{< alert title="Tip" color="info" >}}
If you don’t use `ssh-agent` then you may skip the `-A` flag in the above command. You will need to copy your *private* ssh key (used to connect to VNF) into the VNF node itself, at the location `~/.ssh/id_rsa`. Make sure that the file permissions are correct, i.e. `0600` (or `u=rw,go=`). For example:

```default
ssh root@1.2.3.4 install -m u=rwx,go= -d /root/.ssh/ # make sure ~/.ssh/ exists
scp ~/.ssh/id_rsa root@1.2.3.4:/root/.ssh/           # copy the key
ssh root@1.2.3.4 chmod u=rw,go= /root/.ssh/id_rsa    # make sure the key is secured
```
{{< /alert >}}

Once you have connected to the Kubernetes master node, check if `kubectl` is working, by running `kubectl get nodes`:

```default
root@oneke-ip-172-20-0-2:~# kubectl get nodes
NAME                  STATUS   ROLES                       AGE   VERSION
oneke-ip-172-20-0-2   Ready    control-plane,etcd,master   18m   v1.29.4+rke2r1
oneke-ip-172-20-0-3   Ready    <none>                      16m   v1.29.4+rke2r1
```

Now we are ready to deploy an application on the cluster. To deploy nginx:

```default
root@oneke-ip-172-20-0-2:~# kubectl run nginx --image=nginx --port 80
pod/nginx created
```

After a few seconds, you should be able to see the nginx pod running:

```default
root@oneke-ip-172-20-0-2:~# kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          86s
```

In order to access the application, we need to create a Service and IngressRoute objects that expose the application.

### Accessing the nginx Application

On the Kubernetes master node, create a file called `expose-nginx.yaml` with the following contents:

```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: nginx
spec:
  selector:
    run: nginx
  ports:
    - name: http
      protocol: TCP
      port: 80
      targetPort: 80
---
# In Traefik < 3.0.0 it used to be "apiVersion: traefik.containo.us/v1alpha1".
apiVersion: traefik.io/v1alpha1
kind: IngressRoute
metadata:
  name: nginx
spec:
  entryPoints: [web]
  routes:
    - kind: Rule
      match: Path(`/`)
      services:
        - kind: Service
          name: nginx
          port: 80
          scheme: http
```

Apply the manifest using `kubectl`:

```default
root@oneke-ip-172-20-0-2:~# kubectl apply -f expose-nginx.yaml
service/nginx created
ingressroute.traefik.containo.us/nginx created
```

To access the application, point your browser to the public IP of the VNF node in plain HTTP:

![external_ip_nginx_welcome_page](/images/external_ip_nginx_welcome_page.png)

Congratulations! You have successfully deployed a fully functional Kubernetes cluster at the edge, and have completed the Quick Start Guide.

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

#### Lack of Connectivity to the OneGate Server

Another possible cause for VMs in the Kubernetes cluster failing to run is lack of contact between the VNF node in the cluster and the OneGate server on the Front-end.

As described in [Quick Start Using miniONE on AWS]({{% relref "deploy_opennebula_on_aws#try-opennebula-on-kvm" %}}), the AWS instance where the Front-end is running must allow incoming connections for port 5030. If you do not want to open the port for all addresses, check the **public** IP address of the VNF node (the AWS Elastic IP, see [above]({{% relref "#check-vnf" %}})), and create an inbound rule in the AWS security groups for that IP.

In cases of lack of connectivity with the OneGate server, the `/var/log/one/oneflow.log` file on the Front-end will display messages like the following:

```default
[EM] Timeout reached for VM [0] to report
```

In this scenario only the VNF node is successfully deployed, but no Kubernetes nodes.

To troubleshoot, follow these steps:

1. Find out the IP address of the VNF node, as described [above]({{% relref "#check-vnf" %}}).
2. Log in to the VNF node via ssh as root.
3. Check if the VNF node is able to contact the OneGate server on the Front-end node, by running this command:

```default
onegate vm show
```

A successful response should look like:

```default
[root@VNF]$ onegate vm show
  VM 0
  NAME             : vnf_0_(service_3)
```

And a failure gives a timeout message:

```default
 [root@VNF]$ onegate vm show
 Timeout while connected to server (Failed to open TCP connection to <AWS elastic IP of FN>:5030 (execution expired)).
 Server: <AWS elastic IP of FN>:5030
```

In this case, the VNF node cannot communicate with the OneGate service on the Front-end node. Possible causes include:

> * **Wrong Front-end node for the AWS IP**: The VNF node may be trying to connect to the OneGate server on the wrong IP address. In the VNF node, the IP address for the Front-end node is defined by the value of `ONEGATE_ENDPOINT`, in the scripts found in the `/run/one-context` directory. You can check the value with:

>> ```default
>> grep -r ONEGATE /run/one-context*
>> ```

If the value of `ONEGATE_ENDPOINT` does not match the IP address where OneGate is listening on the Front-end node, edit the parameter with the correct IP address. Then, terminate the OneKE service from the Front-end (see [above]({{% relref "#terminate-oneflow" %}})) and re-deploy.

> * **Filtered incoming connections**: On the Front-end node, the OneGate server listens on port 5030, so you must ensure that this port accepts incoming connections. If necessary, create an inbound rule in the AWS security groups for the elastic IP of the VNF node.

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
