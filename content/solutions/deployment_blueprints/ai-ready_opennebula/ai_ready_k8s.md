---
title: Validation with AI-Ready Kubernetes
linkTitle: AI-Ready Kubernetes
weight: 4
---

<a id="ai_ready_k8s"></a>

{{< alert title="Important" color="success" >}}
To perform the validation with AI-Ready Kubernetes and NVIDIA Dynamo, you must comply with one of the prerequisites:
* Have an AI Factory ready to be validated; or
* Configure an AI Factory by following the procedure outlined in [Configuration and Deployment]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/configuration_and_deployment" %}}).
{{< /alert >}}

Tools like Kubernetes provide robust orchestration for deploying AI workloads at scale, being able to manage isolation between cluster workloads and GPU resources for AI inference tasks. With the use of NVIDIA GPU Operator,  you perform the provision of the necessary NVIDIA drivers and libraries for making GPU resources available to containers.
Kubernetes embraces multitenancy, supporting different isolated namespaces where the access from different teams or users are managed with Role Based Access Control (RBAC) and network policies. As an administrator, you can also enforce limits on the GPU usage or other resources consumed per namespace, ensuring fair resource allocation.

Additionally, running Kubernetes clusters on top of OpenNebula-provisioned virtual machines (VMs) provides several advantages, like hardware-level isolation, physical secure multi-tenancy, an additional layer of resource isolation for performance-sensitive workloads, multi-cloud architectures, flexibility as well as lifecycle management, resource efficiency, among others. Use CAPONE, the OpenNebula Cluster API provisioner for Kubernetes, to run K8s clusters over OpenNebula- provisioned infrastructure. This allows you to provision Kubernetes workload clusters in a declarative manner.

In this guide you will learn how to combine all of these components for provisioning a secure, robust and scalable solution for our AI workloads on top of the NVIDIA Dynamo framework powered by the OpenNebula cloud platform.

## Hardware Specification and Architecture

This section contains the hardware specifications of the used hardware and software resources for an AI-ready Kubernetes cluster with NVIDIA Dynamo.

### Architecture

The diagram below depicts the top-level architecture of the NVIDIA Dynamo framework setup in an OpenNebula deployment over two servers. One server hosts the OpenNebula frontend,  and the second one contains two NVIDIA L40S GPU PCI cards which operate as the host server for the K8s Cluster VMs. For this reference setup, the VMs share a simple bridged network.

![Architecture of NVIDIA Dynamo in OpenNebula over two servers](/images/solutions/deployment_blueprints/ai-ready_opennebula/k8s_architecture_opennebula.svg)


To deploy the GPU-enabled Kubernetes workload cluster, first deploy a VM with the OpenNebula “CAPI Service” marketplace appliance which contains a light Kubernetes management cluster based in K3s and includes a Rancher and CAPONE controller deployment. This instance is used to provision the GPU-enabled Kubernetes workload cluster nodes in a declarative way.

The GPU-enabled Kubernetes workload cluster consists of three VMs that operate as a control plane node and two worker nodes. Each worker node uses one of the two NVIDIA L40S GPU PCI cards. Deploy the NVIDIA GPU Operator in this cluster for automatic configuration of the nodes that make the GPU available to its workloads, and the NVIDIA Dynamo framework operator to deploy inference graphs in a declarative manner.

### Hardware Specification

The requirements to run an AI-ready Kubernetes cluster vary depending on the type of workload and the purpose for which we intend to use it. The OpenNebula frontend is lightweight in terms of requirements, but it is essential to ensure sufficient resource allocation on the worker nodes to load LLMs into memory, and to consider storage to hold them. For this reason, the hosts and VMs are to be sized appropriately in terms of disk capacity, CPU, and RAM.

#### Front-end Requirements

| FRONT-END  |
| :---- | :---- |
| Number of Zones | 1 |
| Cloud Manager | OpenNebula 7.0 |
| Server Specs | Supermicro Hyper A+ server, details in the [table below](#server-specifications) |
| Operating System | Ubuntu 24.04.2 LTS |
| High Availability | No (1 Front-end) |
| Authorization | Builtin |

#### Host Requirements

| VIRTUALIZATION HOSTS  |
| :---- | :---- |
| Number of Nodes | 1 |
| Server Specs | Supermicro Hyper A+ server, details in the [table below](#server-specifications) |
| Operating System | Ubuntu 24.04.2 LTS |
| Hypervisor | KVM |
| Special Devices | None |

#### Storage Specification

| STORAGE   |
| :---- | :---- |
| Type | Local disk |
| Capacity | 1 Datastore |

#### Network Requirements

| NETWORK   |
| :---- | :---- |
| Networking | bridge |
| Number of Networks | 1 networks: service |

#### Provisioning Model

| PROVISIONING MODEL  |
| :---- | :---- |
| Manual on-prem | The two servers have been manually provisioned and configured on-prem. |

#### Server Specifications

The server specifications are based on a two-server setup: one server operates as the OpenNebula frontend and the other one is the cluster for VMs host with two L40S GPU cards attached. This setup  is compatible with any OpenNebula setup having a host server with AI-ready NVIDIA GPUs [supported by the GPU operator](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/24.9.2/platform-support.html#supported-nvidia-data-center-gpus-and-systems).

| Parameter                | Supermicro A+ Server AS -2025HS-TNR                                                       |
|--------------------------|-------------------------------------------------------------------------------------------|
| **Architecture**         | amd64 (x86_64 bits)                                                                       |
| **CPU Model**            | AMD(R) EPYC 9334 Processor @2.7GHz                                                        |
| **CPU Vendor**           | AMD(R)                                                                                    |
| **CPU Cores**            | 128 (2 socket × 32 cores, 2 threads per core)                                             |
| **CPU Frequency**        | 2,7 GHz                                                                                   |
| **NUMA Nodes**           | 2 (Node0: CPUs 0-63, Node1: CPUs 64-128)                                                  |
| **L1d Cache**            | 2 MiB (64 instances)                                                                      |
| **L1i Cache**            | 2 MiB (64 instances)                                                                      |
| **L2 Cache**             | 64 MiB (64 instances)                                                                     |
| **L3 Cache**             | 256 MiB (8 instances)                                                                     |
| **BIOS Vendor**          | American Megatrends Inc. (AMI)                                                            |
| **BIOS Release Date**    | 10/07/2024                                                                                |
| **BIOS Firmware Revision**    | 3.0                                                                                  |
| **ROM Size**             | 32MB                                                                                      |
| **Boot Mode**            | UEFI, ACPI supported                                                                      |
| **Disks**                | 1 × NVMe (SAMSUNG MZQL215THBLA-00A07, 15TB)                                               |
| **Partitions**           | /boot/efi (1G), /boot (2G), LVM root (14T)                                                |
| **Network**              | 1 × Intel X710 10G GbE                                                                    |
| **RAM**                  | 1152 GB (24x48GB DDR5-5600)                                                               |


## Infrastructure Deployment and Configuration

Here is a brief glossary of the components described in this section:

- Management Cluster: a lightweight Kubernetes cluster that contains Cluster API provider components for creating workload Kubernetes declaratively, based on CRDs and yaml manifests/Helm charts.
- Workload Cluster: the Kubernetes clusters created through the Cluster API that manage the actual workloads.
- CAPI service Appliance: an OpenNebula Cluster API VM appliance that contains a lightweight-Kubernetes-based (k3s) management cluster prebuilt with the OpenNebula Cluster API Provider (CAPONE) and other Cluster API providers, as well as a Rancher instance. This appliance is ready for deploying and managing workload clusters without any previous setup.
- CAPONE: the OpenNebula Cluster API Provider which is a Kubernetes  Cluster API infrastructure provider that contacts with the OpenNebula frontend API for provisioning the necessary infrastructure for running workload clusters over OpenNebula VMs.

### Infrastructure Provisioning

This setup requires OpenNebula running on a GPU-ready environment, such as an OpenNebula host configured with PCI-Passthrough for exposing the GPU cards to the node workloads.

### Kubernetes GPU Workload Cluster Provisioning with CAPONE

#### Deploying the Management Cluster

Once the OpenNebula host is up and running, proceed to deploy the Kubernetes management cluster. This cluster uses the CAPONE controller for automatically provisioning the required VMs for hosting the Kubernetes GPU workload cluster.

Deploy your Kubernetes management cluster through the CAPI Service in OpenNebula.

##### Step 1: Deploying the CAPI Appliance

1. Download the CAPI Service from the marketplace:

```shell
oneadmin@frontend$ onemarketapp export "Service Capi" service_Capi -d <datastore_id>
```

Where `datastore_id` is your image datastore identifier. In this example, use the default one, with ID:`1`.

```shell
oneadmin@frontend$ onemarketapp export "Service Capi" service_Capi -d 1
```

2. Update the `service_Capi template by adding the necessary scheduling requirements for deploying in to the desired host, in this case host with ID: 1,  and topology necessary for CPU pinning:

```shell
oneadmin@frontend$ onetemplate update service_Capi
---
NIC=[ NETWORK="service" ]
CPU_MODEL=[MODEL="host-passthrough" ]
SCHED_REQUIREMENTS="HYPERVISOR=kvm & ID = 1"
TOPOLOGY=[ CORES="2", PIN_POLICY="THREAD", SOCKETS="1", THREADS="2" ]
```

3. Instantiate the `service_Capi` appliance:

```shell
oneadmin@frontend$ onetemplate instantiate service_Capi
```

The CAPI appliance takes some minutes to be in “Ready” status. Once the appliance is available, proceed to deploy the workload to the Kubernetes cluster by following the next steps.

##### Step 2: Deploy the Workload Cluster

1. Access the management cluster Kubernetes API. To achieve this, port-forward the 6443 port from the CAPI appliance VM to your localhost, e.g.

```shell
laptop$ ssh -fNL 9443:<capi_appliance_vm_ip>:6443 oneadmin@<one_host_ip>
```

2. Configure the management cluster kubeconfig:

```shell
laptop$ ssh -J oneadmin@<frontend_ip> root@<control_plane_vm_ip> \
cat /etc/rancher/k3s/k3s.yaml | \
sed 's|server: https://127.0.0.1:6443|server: https://127.0.0.1:9443|'> \
kubeconfig_management.yaml
```

3. Create a `values.yaml` file for parameterizing the workload cluster helm chart. You will see that the `values.yaml` file contains some default value overrides, like the images and templates applied for the workload nodes:

```yaml
ONE_XMLRPC: "http://<frontend_host_ip>:2633/RPC2"
ONE_AUTH: "oneadmin:<password>"

ROUTER_TEMPLATE_NAME: "{{ .Release.Name }}-router"
MASTER_TEMPLATE_NAME: "{{ .Release.Name }}-master"
WORKER_TEMPLATE_NAME: "{{ .Release.Name }}-worker"

CLUSTER_IMAGES:
  - imageName: "{{ .Release.Name }}-router"
    imageContent: |
      PATH = "https://d24fmfybwxpuhu.cloudfront.net/service_VRouter-7.0.0-0-20250528.qcow2"
      DEV_PREFIX = "vd"
  - imageName: "{{ .Release.Name }}-node"
    imageContent: |
      PATH = "https://d24fmfybwxpuhu.cloudfront.net/ubuntu2404-7.0.0-0-20250528.qcow2"
      DEV_PREFIX = "vd"

CLUSTER_TEMPLATES:
  - templateName: "{{ .Release.Name }}-router"
    templateContent: |
      CONTEXT = [
        NETWORK = "YES",
        ONEAPP_VNF_DNS_ENABLED = "YES",
        ONEAPP_VNF_DNS_NAMESERVERS = "1.1.1.1,8.8.8.8",
        ONEAPP_VNF_DNS_USE_ROOTSERVERS = "NO",
        ONEAPP_VNF_NAT4_ENABLED = "YES",
        ONEAPP_VNF_NAT4_INTERFACES_OUT = "eth0",
        ONEAPP_VNF_ROUTER4_ENABLED = "YES",
        SSH_PUBLIC_KEY = "$USER[SSH_PUBLIC_KEY]",
        TOKEN = "YES" ]
      CPU = "1"
      CPU_MODEL=[
        MODEL="host-passthrough" ]
      DISK = [
        IMAGE = "{{ .Release.Name }}-router" ]
      GRAPHICS = [
        LISTEN = "0.0.0.0",
        TYPE = "vnc" ]
      LXD_SECURITY_PRIVILEGED = "true"
      MEMORY = "512"
      NIC_DEFAULT = [
        MODEL = "virtio" ]
      SCHED_REQUIREMENTS="HYPERVISOR=kvm & ID = 1"
      TOPOLOGY = [
        CORES="1",
        PIN_POLICY="THREAD",
        SOCKETS="1",
        THREADS="2" ]
      OS = [
        ARCH = "x86_64",
        FIRMWARE_SECURE = "YES" ]
      VCPU = "2"
      VROUTER = "YES"
  - templateName: "{{ .Release.Name }}-master"
    templateContent: |
      CONTEXT = [
        BACKEND = "YES",
        NETWORK = "YES",
        GROW_FS = "/",
        SET_HOSTNAME = "$NAME",
        SSH_PUBLIC_KEY = "$USER[SSH_PUBLIC_KEY]",
        TOKEN = "YES" ]
      CPU = "12"
      CPU_MODEL=[
        MODEL="host-passthrough" ]
      DISK = [
        IMAGE = "{{ .Release.Name }}-node",
        SIZE = "41920" ]
      FEATURES=[
        ACPI="yes",
        APIC="yes",
        PAE="yes" ]
      GRAPHICS = [
        LISTEN = "0.0.0.0",
        TYPE = "vnc" ]
      HYPERVISOR = "kvm"
      LXD_SECURITY_PRIVILEGED = "true"
      MEMORY = "32768"
      NIC=[
        NETWORK="service" ]
      OS = [
        ARCH = "x86_64",
        FIRMWARE="UEFI",
        MACHINE="pc-q35-noble" ]
      SCHED_REQUIREMENTS = "HYPERVISOR=kvm & ID = 1"
      TOPOLOGY=[
        CORES="8",
        PIN_POLICY="SHARED",
        SOCKETS="1",
        THREADS="2" ]
      VCPU = "16"
  - templateName: "{{ .Release.Name }}-worker"
    templateContent: |
      CONTEXT = [
        BACKEND = "YES",
        NETWORK = "YES",
        GROW_FS = "/",
        SET_HOSTNAME = "$NAME",
        SSH_PUBLIC_KEY = "$USER[SSH_PUBLIC_KEY]",
        TOKEN = "YES" ]
      CPU = "12"
      CPU_MODEL=[
        MODEL="host-passthrough" ]
      DISK = [
        IMAGE = "{{ .Release.Name }}-node",
        SIZE = "204800" ]
      FEATURES=[
        ACPI="yes",
        APIC="yes",
        PAE="yes" ]
      GRAPHICS = [
        LISTEN = "0.0.0.0",
        TYPE = "vnc" ]
      HYPERVISOR = "kvm"
      LXD_SECURITY_PRIVILEGED = "true"
      MEMORY = "32768"
      NIC=[
        NETWORK="service" ]
      OS=[
        ARCH="x86_64",
        FIRMWARE="UEFI",
        MACHINE="pc-q35-noble" ]
      PCI=[
        CLASS="0302",
        DEVICE="26b9",
        VENDOR="10de" ]
      SCHED_REQUIREMENTS="HYPERVISOR=kvm & ID = 1"
      TOPOLOGY=[
        CORES="8",
        PIN_POLICY="SHARED",
        SOCKETS="1",
        THREADS="2" ]
      VCPU = "16"

CONTROL_PLANE_MACHINE_COUNT: 1
WORKER_MACHINE_COUNT: 2
PUBLIC_NETWORK_NAME: service
PRIVATE_NETWORK_NAME: service
```

4. Once the `values.yaml` file is available, add the helm chart repo and apply the helm chart referencing the values file:

```shell
# add opennebula capone helm repo
laptop$ helm repo add capone \
https://opennebula.github.io/cluster-api-provider-opennebula/charts/ \
&& helm repo update

# verify charts in that repo
laptop$ helm search repo capone
---
NAME                    CHART VERSION   APP VERSION     DESCRIPTION
capone/capone-kadm      0.1.7           v0.1.7          OpenNebula/Kubeadm CAPI Templates
capone/capone-rke2      0.1.7           v0.1.7          OpenNebula/RKE2 CAPI Templates


# install rke2 capi workload cluster template
laptop$ helm install --kubeconfig ./kubeconfig_management.yaml \
k8s-gpu-test capone/capone-rke2 --values ./values.yaml
```

The CAPONE and rke2 Cluster API controllers in the management cluster will deploy the workload cluster on the scheduled host. Check the logs of those controllers to review the progress:

```shell
NAMESPACE                           NAME                                                             READY   STATUS
capone-system                       capone-controller-manager-64db4f6867-49ppm                       1/1     Running
rke2-bootstrap-system               rke2-bootstrap-controller-manager-676f89558c-85nxg               1/1     Running
rke2-control-plane-system           rke2-control-plane-controller-manager-76fb8568cd-5txwc           1/1     Running
```

When the cluster is deployed, you will see the list of VMs: 1 vRouter instance with control plane Kubernetes API as backend, 1 control plane node, and 2 worker nodes.

```shell
oneadmin@frontend$ onevm list
---
  ID USER     GROUP    NAME                                  STAT  CPU     MEM HOST
 448 oneadmin oneadmin k8s-gpu-test-md-0-m5tzv-drg4k         runn   16     32G vgpu2
 447 oneadmin oneadmin k8s-gpu-test-md-0-m5tzv-btvn4         runn   16     32G vgpu2
 446 oneadmin oneadmin k8s-gpu-test-qb8dl                    runn   16     32G vgpu2
 445 oneadmin oneadmin vr-k8s-gpu-test-cp-0                  runn    2    512M vgpu2
 ```

#### Connecting to the Workload Cluster Kubernetes API Locally

To establish a local connection to the Workload Cluster Kubernetes API, create a ssh tunnel from your localhost to the K8s workload cluster API, exposing through the vRouter instance. Specify the `vrouter_ip` parameter as the public IP address of the vRouter instance, and the `vr_host_ip` as the ip address of the OpenNebula host where the vRouter node is hosted: 

```shell
laptop$ ssh -fNL 8443:<vrouter_ip>:6443 oneadmin@<vr_host_ip>
```

To access the Kubernetes API from your localhost, use the kubeconfig file that is located in the `/etc/rancher/rke2/rke2.yaml` file of the workload cluster control plane node. Also, modify the local kubeconfig file for pointing to localhost, where `host_ip` is the ip address of the OpenNebula frontend IP address. and `control_plane_vm_ip` the workload cluster control plane VM IP address.

```shell
laptop$ ssh -J oneadmin@<frontend_ip> root@<control_plane_vm_ip> \
cat /etc/rancher/rke2/rke2.yaml | \
sed 's|server: https://127.0.0.1:6443|server: https://127.0.0.1:8443|'> \
kubeconfig_workload.yaml
```

Connect to the workload cluster through kubectl, checking for instance the workload cluster nodes:

```shell
laptop$ kubectl --kubeconfig=kubeconfig_workload.yaml get nodes

---

NAME                            STATUS   ROLES                       AGE   VERSION
k8s-gpu-test-md-0-m5tzv-btvn4   Ready    <none>                      8d    v1.31.4+rke2r1
k8s-gpu-test-md-0-m5tzv-drg4k   Ready    <none>                      8d    v1.31.4+rke2r1
k8s-gpu-test-qb8dl              Ready    control-plane,etcd,master   8d    v1.31.4+rke2r1
```

If you want to avoid setting the `--kubeconfig` flag each time you use kubectl, export an env variable referencing the kubeconfig file. This will make kubectl refer to that kubeconfig by default on the shell that you are using:

```shell
laptop$ export KUBECONFIG="$PWD/kubeconfig_workload.yaml"
```

### NVIDIA GPU Operator Installation

The NVIDIA GPU Operator executes the necessary steps for allowing NVIDIA GPU workloads in Kubernetes using the device plugin framework. The managed components includes:

* NVIDIA CUDA drivers
* Kubernetes device plugin for GPUs
* [NVIDIA Container runtime](https://developer.nvidia.com/container-runtime)
* [DCGM](https://developer.nvidia.com/dcgm) based monitoring
* Others

 As a prerequisite, you must [install Helm](https://helm.sh/docs/intro/install/) and have the workload cluster kubeconfig set with kubectl.

The procedure to install the NVIDIA GPU Operator is as follows:

1. Add the NVIDIA helm repo:

```shell
laptop$ helm repo add nvidia https://helm.ngc.nvidia.com/nvidia \
&& helm repo update
```

2. Export the `KUBECONFIG` variable.
3. Deploy the gpu-operator on the workload cluster:

```shell
# create gpu-operator namespace
laptop$ kubectl create ns gpu-operator

# enforce privileged pods on that namespace
laptop$ kubectl label --overwrite ns gpu-operator \
 pod-security.kubernetes.io/enforce=privileged

# install the helm chart
laptop$ helm install --wait --generate-name \
 -n gpu-operator --create-namespace \
 nvidia/gpu-operator \
 --version=v25.3.2 \
 --set "toolkit.env[0].name=CONTAINERD_CONFIG" \
 --set "toolkit.env[0].value=/var/lib/rancher/rke2/agent/etc/containerd/config.toml" \
 --set "toolkit.env[1].name=CONTAINERD_SOCKET" \
 --set "toolkit.env[1].value=/run/k3s/containerd/containerd.sock" \
 --set "toolkit.env[2].name=CONTAINERD_RUNTIME_CLASS" \
 --set "toolkit.env[2].value=nvidia" \
 --set "toolkit.env[3].name=CONTAINERD_SET_AS_DEFAULT" \
 --set-string "toolkit.env[3].value=true"
```

Note that you have specified the `CONTAINERD_CONFIG` and `CONTAINERD_SOCKET` paths for the rke2 Kubernetes distribution, as it’s using a different one than the default.

After a successful Helm installation, you will see this output:

```shell
NAME: gpu-operator-1753949578
LAST DEPLOYED: Thu Jul 31 10:13:01 2025
NAMESPACE: gpu-operator
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

4. Check that the deployed pods for the gpu-operator are up and running:

```shell
laptop$ kubectl get pods -n gpu-operator
---
NAME                                                              READY   STATUS      RESTARTS   AGE
gpu-feature-discovery-f9fs6                                       1/1     Running     0          8d
gpu-feature-discovery-q7h26                                       1/1     Running     0          8d
gpu-operator-1753950388-node-feature-discovery-gc-854b7fb8jr989   1/1     Running     0          8d
gpu-operator-1753950388-node-feature-discovery-master-955d78rh4   1/1     Running     0          8d
gpu-operator-1753950388-node-feature-discovery-worker-4tvlv       1/1     Running     0          8d
gpu-operator-1753950388-node-feature-discovery-worker-d7sxz       1/1     Running     0          8d
gpu-operator-1753950388-node-feature-discovery-worker-zb5gj       1/1     Running     0          8d
gpu-operator-84f4699cc4-kdcjn                                     1/1     Running     0          8d
nvidia-container-toolkit-daemonset-d5fwk                          1/1     Running     0          8d
nvidia-container-toolkit-daemonset-k54w7                          1/1     Running     0          8d
nvidia-cuda-validator-gmnrq                                       0/1     Completed   0          8d
nvidia-cuda-validator-vl94m                                       0/1     Completed   0          8d
nvidia-dcgm-exporter-g5j2n                                        1/1     Running     0          8d
nvidia-dcgm-exporter-g6x99                                        1/1     Running     0          8d
nvidia-device-plugin-daemonset-rhj8z                              1/1     Running     0          8d
nvidia-device-plugin-daemonset-v5bcq                              1/1     Running     0          8d
nvidia-operator-validator-ctg6s                                   1/1     Running     0          8d
nvidia-operator-validator-z52q7                                   1/1     Running     0          8d
```

5. Check if the Kubernetes nodes gpu autodiscovery operates as expected, by checking the workload nodes, for instance the `nvidia.com/*` labels and the allocatable gpu capacity:

```shell
laptop$ kubectl describe $WORKLOAD_NODE
>>>
[...]
                    nvidia.com/gpu.memory=46068
                    nvidia.com/gpu.mode=compute
                    nvidia.com/gpu.present=true
                    nvidia.com/gpu.product=NVIDIA-L40S
                    nvidia.com/gpu.replicas=1

[...]
Capacity:
  cpu:                16
  ephemeral-storage:  202051056Ki
  hugepages-1Gi:      0
  hugepages-2Mi:      0
  memory:             32855784Ki
  nvidia.com/gpu:     1
  pods:               110
Allocatable:
  cpu:                16
  ephemeral-storage:  196555267123
  hugepages-1Gi:      0
  hugepages-2Mi:      0
  memory:             32855784Ki
  nvidia.com/gpu:     1
  pods:               110
```

6. Finally, to use the PCI GPUs on the specific pod, add the `spec.runtimeClassName:nvidia` parameter in the pod/deploy manifest and set [`nvidia.com/gpu`](http://nvidia.com/gpu)`:1` as a requested resource.


{{< alert title="Tip" color="success" >}}
Alternatively, after validating your AI Factory with AI-Ready Kubernetes, you may choose to follow [Validation with NVIDIA Dynamo on Kubernetes]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/nvidia_dynamo" %}}), [Validation with KAI Scheduler]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/nvidia_kai_scheduler" %}}) and [Validation with LLM Inferencing]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/llm_inference_certification" %}}).
{{< /alert >}}