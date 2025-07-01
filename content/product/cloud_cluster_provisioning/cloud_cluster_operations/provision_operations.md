---
title: "Managing Provisions"
date: "2025-02-17"
description:
categories:
pageintoc: "222"
tags:
weight: "3"
---

<a id="provider-operations"></a>

<!--# Managing Provisions -->

In OneForm, **provisions** represent fully-deployed clusters or infrastructure stacks created from provision templates. Each provision is associated with a specific cloud or on-premise provider and contains OpenNebula resources such as Hosts, Datastores, and Virtual Networks.

This section explains how to:

* Scale existing provisions by adding or removing hosts
* Manage public IP assignments
* Retry or deprovision failed provisions
* Monitor and control provision lifecycle through CLI

## Scaling Provisions

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}
{{% tab header="CLI"%}}
To increase or decrease the number of hosts in a running provision, use the `add-host` or `del-host` commands. These operations will trigger an update of the infrastructure through Terraform and Ansible.

* **Add Hosts**:

  ```default
  $ oneprovision add-host <provision_id> --amount <number_of_hosts>
  ```

  Example:

  ```default
  $ oneprovision add-host 42 --amount 2
  ```

* **Remove Hosts**:

  ```default
  $ oneprovision del-host <provision_id> --host-ids <id1,id2,...>
  ```

  Example:

  ```default
  $ oneprovision del-host 42 --host-ids 105,106
  ```

> If both `--amount` and `--host-ids` are provided simultaneously, the operation will fail. You must choose one method of scaling at a time.

{{% /tab %}}

{{< tab header="Sunstone">}}
    Still under development.
{{< /tab >}}

{{< /tabpane >}}

## Managing Public IPs

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}
{{% tab header="CLI"%}}
For provisions that support public networking (e.g., AWS, Equinix), you can manage Elastic IPs dynamically through the following commands:

* **Add Public IPs**:

  ```default
  $ oneprovision add-ip <provision_id> --amount <number_of_ips>
  ```

  Example:

  ```default
  $ oneprovision add-ip 42 --amount 1
  ```

* **Remove a Public IP** (by AR ID):

  ```default
  $ oneprovision remove-ip <provision_id> <ar_id>
  ```

  Example:

  ```default
  $ oneprovision remove-ip 42 7
  ```

> To view current IP allocations, use `oneprovision show <id>` and inspect the associated public network address ranges (ARs).
{{% /tab %}}

{{< tab header="Sunstone">}}
    Still under development.
{{< /tab >}}

{{< /tabpane >}}

## Retrying Failed Provisions

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}
{{% tab header="CLI"%}}
If a provision fails during deployment, you can attempt to recover it by re-triggering the failed step:

```default
$ oneprovision retry <provision_id>
```

To force a retry even if the provision is in an unexpected state:

```default
$ oneprovision retry <provision_id> --force
```
{{% /tab %}}

{{< tab header="Sunstone">}}
    Still under development.
{{< /tab >}}

{{< /tabpane >}}

{{< alert title="Note" color="success" >}}
Retrying provisions is non-destructive and attempts to resume from the last recoverable state in the internal lifecycle.
{{< /alert >}}

## Deprovisioning a Cluster

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}
{{% tab header="CLI"%}}

To cleanly undeploy all infrastructure associated with a provision and remove its corresponding OpenNebula resources:

```default
$ oneprovision deprovision <provision_id>
```

This action will trigger Terraform destroy, Ansible cleanup tasks, and OpenNebula object removal.

{{% /tab %}}

{{< tab header="Sunstone">}}
    Still under development.
{{< /tab >}}

{{< /tabpane >}}

{{< alert title="Important" color="warning" >}}
Once deprovisioned, the associated cluster and resources cannot be recovered. Always verify the state and content of the provision before proceeding.
{{< /alert >}}
