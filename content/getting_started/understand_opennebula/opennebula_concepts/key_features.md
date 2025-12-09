---
title: "Key Features"
date: "2025-02-17"
description:
categories: [Introduction, Overview]
pageintoc: "5"
tags: [Features]
type: docs
weight: "2"
---

<a id="key-features"></a>

<a id="features"></a>

<!--# Key Features -->

OpenNebula offers a simple but feature-rich and flexible solution to build and manage data center virtualization and enterprise clouds. This page provides a summary of its key features(\*).

To learn more about the infrastructure platforms and services supported in each version of OpenNebula, please refer to the [Platform Notes]({{% relref "../../../software/release_information/release_notes_70/platform_notes.md#uspng" %}}) for each version.

For high-level overviews and in-depth technical guides, please refer to OpenNebula’s [White Papers](https://opennebula.io/white-papers/).


## Platform Architecture and Management

### Centralized Control Plane

OpenNebula provides a unified and centralized control plane for the complete management, monitoring, and automation of virtual and cloud resources across the infrastructure.

* Web-based Management Interface (GUI): modern Sunstone GUI built on a responsive web framework for complete lifecycle management, monitoring, and accounting of all virtual infrastructure resources.
* Command-Line Interface (CLI): powerful and scriptable command-line tools that mirror Unix-style commands for fast automation and administration.
* Application Programming Interface (API): REST, gRPC, and XML-RPC APIs offering seamless integration with third-party systems and applications for complete automation and orchestration.

### Federation and Scalability

OpenNebula ensures large-scale deployment and distributed cloud operations with a flexible, federated architecture designed for scalability and isolation.

* Disaggregated Architecture: efficient management of highly distributed cloud and edge environments with clusters across multiple sites or data centers.
* Instance Federation: enables the federation of multiple OpenNebula control planes, allowing unified management across geographically distributed zones.
* Scalability: proven scalability in production environments with over 2,500 hypervisor nodes managed within a single OpenNebula instance.

### Availability and Business Continuity

Built-in high-availability features ensure continuous service operation and data protection with minimal downtime.

* High Availability of Control Plane: redundant front-end components with automatic failover for uninterrupted management services.
* High Availability of Hypervisor Nodes: cluster-based failover mechanisms to automatically restart workloads on surviving hosts.
* Disaster Recovery Across Data Centers: synchronous and asynchronous VM replication and recovery workflows to protect workloads across multiple sites.

### Hybrid and Edge Cloud

Automates the provisioning and lifecycle management of clusters across private, public, and edge clouds.

* Dynamic Expansion: automatically scales clusters by extending private cloud capacity to public or edge environments.
* Multi-Cloud Federation: enables seamless access and workload mobility across clusters deployed in different clouds.
* Unified Management: provides a single control plane for orchestrating compute, storage, and networking resources across hybrid and distributed infrastructures.

## Infrastructure and Virtualization Layer

### Virtualization

Supports multiple hypervisors and container technologies to match diverse workload needs.

* Processor Architectures: certified compatibility with Intel and AMD x86 platforms, as well as ARM64-based processors, including Ampere and NVIDIA Grace, ensuring full flexibility across edge, data center, and AI infrastructure environments.
* Supported Operating Systems: runs on major Linux distributions, including Red Hat Enterprise Linux, Ubuntu, Debian, and Rocky Linux, ensuring flexibility and ease of integration across enterprise environments.
* KVM Virtualization: robust virtualization using Kernel-based Virtual Machine technology.
* Container Virtualization (LXC): lightweight container-based virtualization for fast, efficient workloads.

### Enhanced Platform Awareness (EPA)

OpenNebula leverages Intel’s Enhanced Platform Awareness (EPA) framework to provide precise hardware-level optimization and secure, performance-aware orchestration of virtualized workloads.

* NUMA & CPU Pinning: optimized workload placement through NUMA-aware scheduling, CPU pinning, and core isolation—ensuring deterministic performance and minimal latency for compute-intensive applications.
* PCI Passthrough & SR-IOV: enables secure, high-performance access to GPUs, network interfaces, and accelerators with direct I/O and SR-IOV virtualization, supporting low-overhead multi-tenant environments.
* Memory and HugePages Management: advanced memory allocation and hugepage configuration improve throughput and latency for virtual network functions (VNFs), AI inference, and HPC workloads.Native integration with Intel EPA for NFV, AI, and HPC workloads.

### Accelerated Computing

Native integration with NVIDIA technologies to deliver GPU and DPU-accelerated NFV, AI, and HPC workloads.

* GPU Support: full compatibility with NVIDIA Hopper and Blackwell architectures.
* GPU Scheduling: efficient sharing and allocation using vGPU and MIG.
* NVLink Integration: optimized multi-GPU communication for high-performance AI training.
* Enhanced Networking: support for Infiniband, Spectrum-X, and BlueField DPU fabrics.
* GPU Passthrough: secure, high-performance GPU access for multi-tenant environments.
* DPU Integration (BF-3): hardware offload for networking, security, and encryption tasks.
* GPU Telemetry: real-time GPU monitoring via NVIDIA DCGM and gpu-tools.
* Inference Applications: pre-built apps optimized for fast inference, with native integration of vLLM and Hugging Face frameworks for efficient deployment of AI and LLM workloads.
* NVIDIA Ecosystem Integration: seamless integration with the NVIDIA AI software stack, including platforms such as Run:ai and Dynamo, enabling unified orchestration, scheduling, and monitoring of AI workloads.

### Network

Comprehensive networking support, including software-defined networking (SDN), virtual, and physical appliances, supporting multiple backends for isolation and performance.

* Linux Bridge Networks: simple, native networking for basic virtualization scenarios.
* 802.1Q VLANs: tagged VLAN networks for tenant separation with support for QinQ
* VXLAN Networks: overlay networks for large-scale multi-tenant deployments using multicast or BGP EVPN.
* Open vSwitch and DPDK: advanced SDN integration for high-speed VNF complex network topologies and network functions.

### Storage

Full support for both software-defined storage (SDS) and appliance-based storage solutions, covering environments ranging from local disks to enterprise-grade storage systems.

* Raw device mapping (RDM): use the directly attached devices in the hypervisors in your VMS.
* NFS/NAS: shared network storage with full image management support.
* Local storage with multi-tier caching: cost-efficient, high-performance storage using local disks with support for image caching across clusters and hypervisors in multi-cluster or hybrid configurations,
* Disaggregated and HCI Ceph: scalable distributed storage with block and image replication.
* SAN/LVM: high-performance block storage with thin provisioning, with specific guides for NetApp, Pure Storage, and generic SAN appliances.
* NetApp: optimized driver for NetApp All-Flash systems and ONTAP features.

### Backup

Integrated and third-party backup solutions ensure data protection and recovery.

* Built-in Backup: native CBT (change block tracking) and snapshot-based backup with full, incremental, and differential options for all storage solutions (Section B.4).
* Veeam Integration: seamless integration with Veeam for enterprise-grade incremental and full backup and restore, ensuring data protection, fast recovery, and compliance with corporate retention policies.

## Cloud and Workload Orchestration

### Cloud Provisioning Model

A self-service model enabling users to deploy and manage multi-tier applications easily.

* Self-Service Portal: a simple web portal allowing users to deploy virtual machines and services from a predefined catalog.
* Elastic Multi-VM Services: auto-scaling of application components based on customizable elasticity rules.
* Application Insight: real-time application metrics and state monitoring for informed scaling and resource decisions.

### Capacity and Performance Management

Advanced scheduling and resource optimization ensure efficient use of compute and storage resources.

* Live Migration: seamless movement of running VMs between hosts for maintenance or load balancing.
* Dynamic Resource Scheduling (DRS): cluster-wide automated & semi-automated load balancing, and generation of migration plans.
* AI-driven Predictive Scheduler: multi-policy scheduling engine supporting priorities, affinity, and cost-aware placement.
* Affinity/Anti-Affinity Rules: policy-driven placement of VMs to optimize locality or fault tolerance.
* Host Overcommitment: maximize resource utilization and efficiency.

### Observability and Monitoring

Integrated telemetry and analytics tools for proactive monitoring and performance visibility.

* Built-in Monitoring: native monitoring subsystem that provides real-time visibility into virtual machines, hosts, and services directly from the OpenNebula control plane—no external tools required.
* Predictive Monitoring: built-in health and capacity forecasting to anticipate performance issues.
* External Integration: export of metrics and events to Prometheus and Grafana for unified observability.

### Secure Multi-Tenancy

Comprehensive isolation, quota management, and access controls ensure secure multi-user environments.

* Application Sharing: secure sharing of templates and applications across users, groups, and projects.
* Authentication Realms: integration with LDAP, Active Directory, SAML, and other identity backends for centralized access control.
* Fine-Grained ACLs: per-resource access permissions for complete control of user and group privileges.
* Quota Management: enforces CPU, GPU, storage, and network usage limits per user or tenant to ensure fair resource allocation and policy compliance, including cluster-level quotas and custom quota items for granular governance and control.
* Cluster and VDC: logical partitioning of resources into isolated clusters and Virtual Data Centers.
* Users & Groups: logical grouping of users and projects for efficient policy administration.
* Network Isolation: VLANs and overlays ensure tenant traffic separation.

## Extensibility, Automation, and Hybrid Operations

### Kubernetes Platform

Enterprise-grade Kubernetes management and orchestration through built-in add-ons.

* Cluster API: native support for Cluster API Provider for OpenNebula (CAPONE) to provision and manage clusters.
* Cloud Provider Interface (CPI): direct integration for OpenNebula-managed resources in Kubernetes.
* Container Storage Interface (CSI): persistent volume provisioning from OpenNebula storage backends.
* Rancher Integration: fully certified integration with SUSE Rancher Prime and RKE2, providing enterprise-grade multi-cluster lifecycle management and unified governance of Kubernetes environments.
* Unified KaaS Model: simplifies the operation of Kubernetes environments by offering a consistent management experience, built-in automation, and end-to-end support through OpenNebula’s Enterprise Subscription.

### Confidential Computing

Secure execution environments ensure data privacy and integrity during processing.

* Confidential Computing: encrypted processing for protecting sensitive workloads in use.
* vTPM: virtual Trusted Platform Module support for attestation and secure boot.
* Encrypted Datastores: native support for encrypted storage backends to safeguard data at rest and ensure compliance with enterprise security standards.

### Automation

Comprehensive automation and orchestration capabilities ensure consistent, repeatable, and policy-driven operations across environments.

* Infrastructure as Code: Full support for automation frameworks such as Terraform for declarative infrastructure provisioning and lifecycle management.
* Configuration Management: Seamless integration with tools like Ansible for configuration control, post-deployment automation, and compliance enforcement.

### App Marketplaces

Distribute and reuse cloud-ready applications within and across organizations.

* Guest Operating Systems: broad support for Windows and Linux guests, ensuring full compatibility for enterprise, development, and AI workloads across heterogeneous environments.
* Public Marketplace: access to a broad catalog of pre-built templates for common operating systems, application stacks, and services, enabling rapid deployment and standardization across environments.
* Private Marketplace: internal catalog for sharing and distributing certified applications.
* Third-Party Integration: support for external marketplaces such as Linux Containers.

## Usability, Interoperability, and Migration

### Graphical User Interface

Modern, intuitive interface for both administrators and end users.

* Dynamic Tabs: modular interface views for efficient navigation and operation.
* VNC Console: secure, browser-based remote access to virtual machines through integrated VNC sessions.
* White Labeling: customizable branding and visual identity for organizations.
* Self-Service Cloud View: simplified interface for end users and developers.
* Group Admin View: delegated administration for project or departmental management.
* Sunstone Labels: tag-based organization and filtering of resources.

### Interfaces and Integration

Extensible and open architecture designed for seamless interoperability.

* Modular Architecture: Flexible design allowing custom extensions and third-party integrations.
* Hooking System: Event-driven hooks for workflow automation and external triggers.
* Rich API Set: Multi-language APIs for integration with third-party systems and applications for complete automation and orchestration.

### Migration from VMware

Comprehensive tools and workflows to enable a smooth transition from VMware environments to OpenNebula with minimal downtime and configuration effort.

* OneSwap: streamlines virtual machine migration from VMware into OpenNebula with minimal reconfiguration and downtime.
* OVA Import: enables direct import of OVA appliances and templates, simplifying workload onboarding and ensuring compatibility across virtualization environments.
* Minimal Disruption: migration workflows designed to ensure business continuity, avoiding downtime and configuration drift.


{{< alert title="Important" color="success" >}}
(\*) *Because OpenNebula leverages the functionality exposed by the underlying platform services, its functionality and performance may be affected by the limitations imposed by those services.*

- *The list of features may change on the different platform configurations*
- *Not all platform configurations exhibit similar performance and stability*
- *The features may change to offer users more features and integration with other virtualization and cloud components*
- *The features may change due to changes in the functionality provided by underlying virtualization services*
{{< /alert >}}
