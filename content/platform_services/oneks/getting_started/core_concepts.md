---
title: "Core Concepts"
linkTitle: "Core Concepts"
date: "2026-05-12"
description:
categories:
tags:
weight: "4"
type: docs
---

This section explains the main OneKS concepts used throughout the documentation. OneKS exposes Kubernetes Clusters as high-level resources while orchestrating the lower-level OpenNebula, Cluster API, CAPONE, and runtime components required to provision and operate them.

Users mainly interact with:

* **Cluster Profiles**: Reusable blueprints for Cluster component configuration.  
* **Clusters**: Top-level resources representing deployed Kubernetes Clusters.  
* **Node Groups**: Scalable worker-capacity groups attached to Clusters.  
* **Topologies**: Deployment layouts that combine control planes, node groups, networks, and runtime dependencies.

Lower-level resources such as OpenNebula VM templates, images, Virtual Networks, virtual routers, seed VMs, and Cluster API objects are managed underneath these abstractions.

## Seed VM

The seed VM is a managed, temporary OpenNebula VM dependency used during control-plane bootstrap.

It is not a first-class user resource, and users do not create or manage it directly.

During control-plane provisioning, OneKS creates the seed VM from an existing OpenNebula VM template. OneKS injects the rendered control-plane and Cluster API specification into the VM context, attaches the seed VM to the Cluster public network, and monitors its bootstrap state.

The seed VM performs the bootstrap and Cluster API pivoting workflow. It starts a temporary management environment, applies the Cluster API and RKE2 resources, waits for the workload control plane, retrieves the workload kubeconfig, initializes the providers in the workload Cluster, and moves the Cluster API objects.

OneKS monitors the seed VM through its `ONEKS_STATE` value.

* `ONEKS_STATE=RUNNING`: OneKS marks the dependency as ready and removes the seed VM automatically, depending on the configured dependency behavior.  
* Failure state or timeout: the control-plane group may enter `BOOTSTRAPPING_FAILURE`.

The seed VM is a critical part of the control-plane creation process, but it remains an implementation detail hidden from normal user workflows.

## Cluster Profiles

A Cluster Profile is a reusable blueprint used to define the configuration of a OneKS Cluster component.

In OneKS, profiles are used to define both control-plane configuration and node-group configuration. Profiles allow users to standardize how Kubernetes Clusters are created. Instead of requiring users to provide every low-level infrastructure detail, OneKS exposes predefined families, flavours, defaults, and validated inputs.

A Cluster profile can define:

* **Supported Kubernetes Versions**: The Kubernetes versions that can be deployed with the profile.  
* **Families and Flavours**: The selectable configuration groups and variants exposed to users.  
* **Default Capacity Values**: Default compute, memory, disk, and instance-count values.  
* **User Inputs**: Fields collected during Cluster or node-group creation.  
* **Validation Rules**: Constraints applied to user-provided values.  
* **Override Behavior**: Whether user-provided values can override flavour defaults.  
* **Runtime Dependencies**: Dependencies such as a temporary seed VM or a Cluster router.  
* **Templates**: Definitions used to render the underlying OpenNebula and Cluster API resources.

Profiles are the main mechanism for making OneKS Cluster deployments repeatable, controlled, and consistent across users and environments.

## Families and Flavours

OneKS uses **families** and **flavours** to expose predefined configuration choices:.

* **Family**: Identifies a group of related profile configurations. For example, a deployment may provide a `general` family for control-plane configurations and another `general` family for worker node groups.  
* **Flavour**: Selects a specific variant within a family. The flavour can define topology, capacity, or both.

For example, a default OneKS deployment may expose:

* **Control-plane Family** `general`: Includes flavours such as `standalone` and `ha`.  
* **Node-group Family** `general`: Includes flavours such as `small`, `medium`, and `large`.

When users create a Cluster or node group, they select a family and a flavour. OneKS then applies the defaults, validation rules, and dependencies associated with that selection.

This allows users to expose simple choices to users while keeping the underlying infrastructure configuration controlled.

## User Inputs and Defaults

Profiles may define user inputs. These inputs are collected during Cluster or node-group creation and are combined with the defaults defined by the selected flavour.

Common inputs include:

* `count:` The number of nodes or instances to create.  
* `cpu`: The CPU capacity assigned to each node.  
* `vcpu`: The virtual CPU value assigned to each node.  
* `memory`: The memory assigned to each node.  
* `disk_size`: The disk size assigned to each node.

For example, a worker node flavour may define default CPU, memory, and disk values while allowing the user to choose the number of worker nodes.

A flavour can also control whether user-provided values are allowed to override its defaults. This behavior is controlled by the `override_defaults` setting.

* `override_defaults` **enabled**: User-provided values can override the flavour defaults.  
* `override_defaults` **disabled**: Flavour defaults take precedence over user-provided values.

This lets users decide whether a flavour is fixed or user-customizable.

## Default Profiles

A OneKS deployment may expose default profiles for common Cluster patterns. The exact profiles available depend on the user configuration. A typical default configuration includes the following profiles.

**Control-plane profile:**

* **Family**: `general`  
* **Flavours**: `standalone`, `ha`  
* **Inputs**: `count`, `cpu`, `vcpu`, `memory`, `disk_size`

Available flavours:

* `standalone`: Deploys a single control-plane node. It is suitable for development, evaluation, and non-critical environments.  
* `ha`: Deploys multiple control-plane nodes. It is intended for environments that require higher availability.

**Node-group profile:**

* **Family**: `general`  
* **Flavours**: `small`, `medium`, `large`  
* **Inputs**: `count`, `cpu`, `vcpu`, `memory`, `disk_size`

Available flavours:

* `small`: Suitable for lightweight workloads.  
* `medium`: Suitable for balanced workloads.  
* `large`: Suitable for more demanding workloads.

Each flavour can define default values for CPU, virtual CPU, memory, disk size, and node count.

## Custom Profiles

Custom profiles are an user extension mechanism. Users can define new profiles to expose additional Cluster offerings or adapt OneKS to a specific infrastructure environment.

A typical custom profile workflow includes:

* **Profile Family**: Select or create the family that will expose the profile.  
* **Supported Kubernetes Versions**: Define the Kubernetes versions allowed for the profile.  
* **Flavours**: Define the available configuration variants.  
* **Default Values**: Define default values for each flavour.  
* **User Inputs**: Define the inputs users can provide.  
* **Validation Rules**: Define constraints for the accepted inputs.  
* **Dependencies**: Define required dependencies such as a seed VM or Cluster router.  
* **Testing**: Validate the profile before making it available to users.

Custom profiles are mainly relevant for users who manage the OneKS service and define the Cluster options exposed to users.

## Clusters

A OneKS Cluster is the top-level resource exposed to users and users. It represents a deployed Kubernetes Cluster running on OpenNebula.

A Cluster includes:

* **Cluster Identity and Metadata**: The name, description, ownership, and registration information for the Cluster.  
* **Kubernetes Version**: The Kubernetes version deployed in the Cluster.  
* **Network References**: The public and private OpenNebula Virtual Networks used by the Cluster.  
* **Control Plane**: One logical control-plane group.  
* **Node Groups**: Zero or more worker-capacity groups.  
* **Lifecycle State**: The current operational state of the Cluster.  
* **Historical Events**: Recorded lifecycle actions and state changes.  
* **Kubeconfig Retrieval**: Access information for the Kubernetes API server.  
* **Logs**: Cluster lifecycle logs and operational visibility.

The OneKS API, CLI, and Sunstone workflows are centered around Cluster resources.

Each OneKS Cluster has one logical control-plane group. Depending on the selected control-plane flavour, this group may contain:

* **Standalone Control Plane**: One control-plane node.  
* **High-availability Control Plane**: Multiple control-plane nodes.

Even in `HA` deployments, the control plane is represented as one logical control-plane group. Users do not manually create separate control-plane groups. Control-plane capacity and topology are determined during Cluster creation by the selected profile family and flavour.

A Cluster requires two OpenNebula Virtual Networks:

* **Public Virtual Network**: Provides external connectivity where required and supports required bootstrap and service access paths.  
* **Private Virtual Network**: Provides internal Cluster communication and helps preserve network isolation between Cluster nodes.

The user or user must provide the public and private network IDs during Cluster creation.

A OneKS Cluster coordinates several lower-level infrastructure resources, including:

* **OpenNebula VMs**: Virtual Machines used for control-plane and worker nodes.  
* **VM Templates**: OpenNebula templates used to instantiate Cluster-related VMs.  
* **Images**: Base images used by templates and Cluster nodes.  
* **Virtual Networks**: Public and private networks selected during Cluster creation.  
* **Virtual Routers**: Routing components used by the Cluster networking topology.  
* **Seed VMs**: Temporary bootstrap VMs used during control-plane provisioning.  
* **Cluster API and CAPONE resources**: Lower-level lifecycle resources used to provision the Kubernetes Cluster.

Users normally do not interact with these resources directly during standard workflows. OneKS orchestrates them as part of the Cluster lifecycle.

A Cluster has a lifecycle state that reflects its current operational condition. Common lifecycle states include `PROVISIONING`, `RUNNING`, `WARNING`, and failure states.

A Cluster is considered ready for Kubernetes use when it reaches the `RUNNING` state and the Kubernetes nodes report `Ready` through `kubectl`.

The full state list and reconciliation behavior are documented in [Monitoring and Troubleshooting]({{% relref "platform_services/oneks/management/monitoring_and_troubleshooting/" %}}).

After a Cluster is running, users access it by retrieving its `kubeconfig`, which contains the Kubernetes API endpoint and credentials required to connect to the Cluster.

Example:

```shell
oneks show cluster <cluster_id> --kubeconfig > kubeconfig
```

The kubeconfig can then be used with standard Kubernetes commands:

```shell
KUBECONFIG=./kubeconfig kubectl get nodes
```

The expected result is that the control-plane nodes and any worker nodes appear in the `Ready` state.

## Node Groups

A Node Group is a scalable worker-capacity group attached to a OneKS Cluster. Node groups are the main operational unit for managing worker capacity in OneKS.

A node group defines:

* **Parent Cluster**: The Cluster the node group belongs to.  
* **Profile Family**: The node-group family selected during creation.  
* **Flavour**: The worker node size or capacity profile.  
* **Input Values**: Node count and resource sizing values.  
* **OpenNebula VM Instances**: The VMs associated with the node group.  
* **Lifecycle State**: The current operational state of the node group.  
* **Dependency State**: The state of any runtime dependencies.  
* **Historical Events**: Recorded lifecycle actions and state changes.

Users create node groups after the Cluster control plane is running.

Worker nodes host application workloads. When a node group is created, OneKS provisions the requested number of worker nodes using the selected node-group flavour.

Example worker flavours:

* `small`: lightweight workloads.  
* `medium`: balanced workloads.  
* `large`: resource-intensive workloads.

A node group is always attached to an existing Cluster.

Conceptually, creating a node group requires:

* **Parent Cluster ID**: The ID of the Cluster that will receive the node group.  
* **Node-group Name**: The name used to identify the worker capacity group.  
* **Node-group Family**: The profile family used for the node group.  
* **Node-group Flavour**: The selected worker capacity profile.  
* **User input Values**: Optional values such as node count or resource sizing.

In an interactive CLI or Web UI flow, the user selects these values step by step.

After the node group is created, OneKS provisions the worker VMs and joins them to the Kubernetes Cluster.

Scaling changes the number of worker nodes in a node group. Scaling is performed against node groups, not directly against the Cluster control plane.

For example, scaling a node group to three nodes means that OneKS reconciles that node group until it contains three worker nodes.

After scaling, users should validate the result with:

```shell
KUBECONFIG=./kubeconfig kubectl get nodes
```

Node groups have their own lifecycle states. Common lifecycle states include `PROVISIONING`, `RUNNING`, `SCALING`, `WARNING`, and failure states.

A node group is ready for Kubernetes workloads when it reaches the `RUNNING` state and its worker nodes are visible and `Ready` in Kubernetes.

The full state list and reconciliation behavior are documented in **Monitoring and Troubleshooting**.

A Cluster can have:

* **One Control-plane Group**: The logical control-plane group created during Cluster provisioning.  
* **Zero Node Groups**: A control-plane-only Cluster.  
* **One Node Group**: A simple Cluster with one worker capacity group.  
* **Multiple Node Groups**: A Cluster with separate worker pools for different workload types or capacity profiles.

For example, a Cluster could have:

* **Small Node Group**: Lightweight services
* **Medium Node Group**: General workloads  
* **Large Node Group**: Resource-intensive workloads

The exact options depend on the profiles configured by the user.

## Topologies

A topology describes how a OneKS Cluster is assembled from its control plane, node groups, networks, and runtime dependencies.

A OneKS topology is determined by:

* **Control-plane Profile and flavour**: The selected configuration for the Kubernetes control plane.  
* **Kubernetes Version**: The Kubernetes version deployed in the Cluster.  
* **Public and Private Networks**: The OpenNebula networks selected during Cluster creation.  
* **Control-plane Node Count**: The number of control-plane nodes defined by the selected flavour.  
* **Node-group Configuration**: The number and size of worker node groups.  
* **Runtime Dependencies**: Supporting components such as the seed VM and Cluster router.

Topologies allow OneKS to expose different Kubernetes deployment models without requiring users to manually construct the underlying infrastructure.

A standalone topology uses a single control-plane node.

This topology is suitable for:

* **Development Environments**: Clusters used for development and experimentation.  
* **Test Environments**: Clusters used for validation and temporary testing.  
* **Evaluation Clusters**: Clusters used to assess OneKS or Kubernetes behavior.  
* **Non-critical Workloads**: Workloads that do not require control-plane redundancy.

A standalone control plane is simpler and consumes fewer resources, but it does not provide control-plane redundancy. If the single control-plane node fails, the Kubernetes API may become unavailable until the node or underlying infrastructure is recovered.

A high-availability (`HA`) control-plane topology uses multiple control-plane nodes. This topology is intended for environments where control-plane availability is more important.

In OneKS, an `HA` control plane is represented as multiple control-plane nodes inside one logical control-plane group. Users select the `HA` flavour during Cluster creation. OneKS then orchestrates the underlying infrastructure and control-plane layout.

Worker capacity is provided by node groups. A Cluster may start with no worker node groups, or users may add one or more node groups after the control plane is running.

Each node group can have its own flavour and count.

Example standalone topology:

```default
Cluster
├── Control plane: standalone
└── Node groups
   └── small-workers, count: 2
```

Example HA topology:

```default
Cluster
├── Control plane: ha
└── Node groups
   ├── medium-workers, count: 3
   └── large-workers, count: 2
```

This model allows users to scale worker capacity independently from the control plane.

OneKS Cluster networking uses the public and private OpenNebula Virtual Networks selected during Cluster creation.

* **Public Network**: Provides external connectivity and supports required bootstrap and service access paths.  
* **Private Network**: Provides internal communication between Cluster nodes.  
* **Virtual Router**: Connects the OpenNebula networking layer with the Kubernetes Cluster topology where required.

Some topologies require runtime dependencies. Common dependencies include:

* **Seed VM**: Temporary VM used during control-plane bootstrap.  
* **Cluster router**: Router-related dependency used to support Cluster connectivity.  
* **OneGate**: OpenNebula service used by VMs to communicate with OpenNebula during bootstrap and runtime configuration.  
* **Transparent proxy, `tproxy`**: Networking configuration used to expose required OpenNebula services such as OneGate and the XML-RPC API through the public network gateway.

These dependencies are normally configured by the user and consumed automatically by OneKS during lifecycle operations.

Users do not build the topology manually. Instead, they select:

* **Kubernetes Version**: The version to deploy.  
* **Public Network**: The OpenNebula public Virtual Network used by the Cluster.  
* **Private Network**: The OpenNebula private Virtual Network used by the Cluster.  
* **Control-plane Flavour**: The selected control-plane deployment model.  
* **Node-group Flavour and Count**: The worker capacity profile and number of workers, if additional capacity is required.

OneKS translates those choices into the corresponding OpenNebula, Cluster API, CAPONE, and Kubernetes resources.