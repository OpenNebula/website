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

Before creating a Cluster, ensure that the minimum required components are configured and available.

## OneKS Service

Verify that the OneKS service is running. On the command line of your OpenNebula Front-end, run the following command:

```shell
sudo systemctl status opennebula-ks.service
```

The service should be in the active (`running`) state.

## OneGate Service

Verify that OneGate is configured and reachable. OneGate is required during Cluster provisioning because the bootstrap process uses it to communicate with OpenNebula services.

Check the OneGate service status on the Front-end command line:

```shell
sudo systemctl status opennebula-gate.service
```

Validate the OneGate configuration using the OpenNebula OneGate [documentation]({{% relref "product/operation_references/opennebula_services_configuration/onegate/" %}}).

## Transparent Proxy Configuration 

Verify that the [transparent proxy]({{% relref "product/virtual_machines_operation/virtual_machines_networking/tproxy/" %}}) is configured to expose OneGate and the OpenNebula XML-RPC API through the public network gateway.

The configuration is typically defined in the following location on the OpenNebula Front-end:

```default
/var/lib/one/remotes/etc/vnm/OpenNebulaNetwork.conf
```

Example configuration:

```default
:tproxy:
  - :remote_addr: 192.168.150.1 # Public network gateway IP
    :remote_port: 5030
    :service_port: 5030
  - :remote_addr: 192.168.150.1 # Public network gateway IP
    :remote_port: 2633
    :service_port: 2633
```

Replace `192.168.150.1` with the gateway IP address of the public Virtual Network.

## Public and Private Virtual Networks

Identify the OpenNebula Virtual Network IDs that will be used by the Cluster. On the Front-end command line, run the following command to inspect the available networks:

```shell
onevnet list
```

You need:

* A **public Virtual Network**, used as the gateway to the Internet and for external Cluster connectivity.  
* A **private Virtual Network**, used for internal communication between Cluster nodes.

## User Permissions

Verify that the user has permission to create and manage OneKS Clusters and the related OpenNebula resources, including virtual machines, Virtual Networks, images, and templates.

## Kubectl Client

To validate or manage the created Clusters from the Host, instead of accessing the Cluster VMs directly, [kubectl](https://kubernetes.io/docs/tasks/tools/) must be installed on the Host where the retrieved kubeconfig will be used.