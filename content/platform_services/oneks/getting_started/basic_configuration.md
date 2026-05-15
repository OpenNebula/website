---
title: "Basic Configuration"
linkTitle: "Basic Configuration"
date: "2026-05-12"
description:
categories:
tags:
weight: "2"
type: docs
---

Before creating a K8s Cluster, ensure that the minimum required components are configured and available.

## OneKS Service

Verify that the OneKS service is running. On the command line of your OpenNebula Front-end, run the following command:

```shell
sudo systemctl status opennebula-ks.service
```

The service should be in the active (`running`) state.

## OneGate Service

Verify that OneGate is configured and reachable. OneGate is required during K8s Cluster provisioning because the bootstrap process uses it to communicate with OpenNebula services.

Check the OneGate service status on the Front-end command line:

```shell
sudo systemctl status opennebula-gate.service
```

Validate the OneGate configuration using the OpenNebula OneGate [documentation]({{% relref "product/operation_references/opennebula_services_configuration/onegate/" %}}).

## Transparent Proxy Configuration 

Verify that the [transparent proxy]({{% relref "product/virtual_machines_operation/virtual_machines_networking/tproxy/" %}}) is configured to expose OneGate and the OpenNebula XML-RPC API through the Front-end public network.

The configuration is typically defined in the following location on the OpenNebula Front-end:

```default
/var/lib/one/remotes/etc/vnm/OpenNebulaNetwork.conf
```

Example configuration:

```default
:tproxy:
  - :remote_addr: 192.168.150.1 # Front-end public network IP
    :remote_port: 5030
    :service_port: 5030
  - :remote_addr: 192.168.150.1 # Front-end public network IP
    :remote_port: 2633
    :service_port: 2633
```

Replace `192.168.150.1` with the Front-end IP address of the public Virtual Network and save the file. On Front-end command line, as the oneadmin system user, sync the OpenNebulaNetwork.conf file with the hypervisor Hosts, by running `onehost sync -f`.

## Public and Private Virtual Networks

Identify the OpenNebula Virtual Network IDs that will be used by the K8s Cluster. On the Front-end command line, run the following command to inspect the available networks:

```shell
onevnet list
```

You need:

* A **public Virtual Network**, used as the gateway to the Internet and for external K8s Cluster connectivity.  
* A **private Virtual Network**, used for internal communication between K8s Cluster nodes.

## User Permissions

Verify that the user has permission to create and manage OneKS K8s Clusters and the related OpenNebula resources, including Virtual Machines, Virtual Networks, images, and templates.

## kubectl Client

[kubectl](https://kubernetes.io/docs/reference/kubectl/) is the official command-line interface for Kubernetes. kubectl communicates with K8s Clusters launched by OneKS remotely from the Front-end Host, removing the need to interact directly with the K8s Cluster VMs themselves. kubectl handles the following key functions:

* **K8s Cluster Management**: View nodes, health status, and resource usage.
* **Workload Deployment**: Create, update, and delete pods, services and containerized application deployments.
* **Troubleshooting**: Retrieving logs, describing pod and node statuses or errors.
* **Configuration**: Manage secrets, environment variables and storage.

kubectl must be installed on the Front-end Host machine. On a Linux machine, run the following command to install kubectl:

1. Download the latest release with the following command:

{{< tabpane text=true right=false >}}
{{% tab header="**Architecture**:" disabled=true /%}}

{{% tab header="x86-64"%}}
```shell
curl -fsSL "https://dl.k8s.io/release/$(curl -L -s \
https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```
{{% /tab %}}

{{% tab header="ARM64"%}}
```shell
curl -LO "https://dl.k8s.io/release/$(curl -L -s \
https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
```
{{% /tab %}}
{{< /tabpane >}}

To download a specific version of kubectl, replace `$(curl -L -s https://dl.k8s.io/release/stable.txt)` in the above commands with the version number. E.g. for version 1.36.0:
{{< tabpane text=true right=false >}}
{{% tab header="**Architecture**:" /%}}

{{% tab header="x86-64"%}}
```shell
curl -fsSL "https://dl.k8s.io/release/v1.36.0/bin/linux/amd64/kubectl"
```
{{% /tab %}}

{{% tab header="ARM64"%}}
```shell
curl -LO "https://dl.k8s.io/release/v1.36.0/bin/linux/arm64/kubectl"
```
{{% /tab %}}
{{< /tabpane >}}

2. Install kubectl:

```shell
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

{{< alert title="Note" type="primary" >}}
If you do not have root access on the target system, you can still install kubectl to the `~/.local/bin` directory:
```shell
chmod +x kubectl
mkdir -p ~/.local/bin
mv ./kubectl ~/.local/bin/kubectl
# and then append (or prepend) ~/.local/bin to $PATH
```
{{< /alert >}} 

3. Ensure the version you have installed is up-to-date or the expected version:

```shell
kubectl version --client
```

If the above command is not suitable for your Front-end Host configuration, consult the [kubectl installation documentation](https://kubernetes.io/docs/tasks/tools/) for [MacOS](https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/) or [Windows](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/).

## Next Steps

After completing the basic configuration steps described here, you are ready to start provisioning K8s Clusters with OneKS. Move on to the [OneKS Quick-start Guide]({{% relref "platform_services/oneks/getting_started/quick_start/" %}}) to learn how to deploy a basic K8s Cluster.