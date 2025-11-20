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

In OneForm, provisions represent fully-deployed clusters or infrastructure stacks. Each provision is associated with a specific cloud or on-premise provider, and contains OpenNebula resources such as hosts, datastores, and virtual networks.

Here you will find details on how to:

* scale existing provisions, by adding or removing hosts
* manage public IP assignments
* retry or deprovision failed provisions
* monitor and control provision lifecycle through CLI

## Scaling Provisions

Select the relevant interface to scale provisions:

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}

{{% tab header="Sunstone"%}}
Still under development.
{{% /tab %}}

{{% tab header="CLI"%}}
To increase the number of hosts in a running provision, run `add-host`. Alternatively, execute the`del-host` command to decrease hosts. These operations trigger an update of the infrastructure through Terraform and Ansible.

If you specify both `--amount` and `--host-ids` simultaneously, the operation fails. You must choose one method of scaling at a time.


* Add Hosts:

  ```bash
  $ oneprovision add-host <provision_id> --amount <number_of_hosts>
  ```

  Example:

  ```bash
  $ oneprovision add-host 42 --amount 2
  ```

* Remove Hosts:

  ```bash
  $ oneprovision del-host <provision_id> --host-ids <id1,id2,...>
  ```

  Example:

  ```bash
  $ oneprovision del-host 42 --host-ids 105,106
  ```

{{% /tab %}}

{{% tab header="API"%}}

* Add Hosts

```bash
curl -X POST "https://oneform.example.server/api/v1/provisions/<id>/scale" \
  -H "Content-Type: application/json" \
  -d '{
    "direction": "up",
    "nodes": 2
  }'
```

* Remove Hosts

```bash
curl -X POST "https://oneform.example.server/api/v1/provisions/<id>/scale" \
  -H "Content-Type: application/json" \
  -d '{
    "direction": "down",
    "nodes": [ "node1" ],
    "opts": {
      "force": true
    }
  }'
```

For further details about the API, refer to the [OneForm API Reference Guide](/product/integration_references/system_interfaces/oneform_api.md).
{{% /tab %}}

{{< /tabpane >}}

## Managing Public IPs

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}

{{% tab header="Sunstone"%}}
Still under development.
{{% /tab %}}

{{% tab header="CLI"%}}
For provisions that support public networking like AWS and Equinix, dynamically manage Elastic IPs through the following commands:

* Add Public IPs

  ```bash
  $ oneprovision add-ip <provision_id> --amount <number_of_ips>
  ```

  Example:

  ```bash
  $ oneprovision add-ip 42 --amount 1
  ```

* Remove a Public IP by Address Range (AR ID)

  ```bash
  $ oneprovision remove-ip <provision_id> <ar_id>
  ```

  Example:

  ```bash
  $ oneprovision remove-ip 42 7
  ```

To view current IP allocations, run `oneprovision show <id>` and inspect the associated public network address ranges (ARs).
{{% /tab %}}

{{% tab header="API"%}}

* Add Public IPs

```bash
curl -X POST "https://oneform.example.server/api/v1/provisions/<id>/add-ip" \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 3
  }'
```

* Remove a Public IP

```bash
curl -X POST "https://oneform.example.server/api/v1/provisions/<id>/remove-ip" \
  -H "Content-Type: application/json" \
  -d '{
    "ar_id": 42
  }'
```

For further details about the API, refer to the [OneForm API Reference Guide](/product/integration_references/system_interfaces/oneform_api.md).
{{% /tab %}}

{{< /tabpane >}}

## Retrying Failed Provisions

Retrying a provision is a non-destructive operation that attempts to resume from the last recoverable state within its internal lifecycle.

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}

{{% tab header="Sunstone"%}}
Still under development.
{{% /tab %}}

{{% tab header="CLI"%}}
If a provision fails during deployment, attempt recovery by re-triggering the failed step:

```bash
$ oneprovision retry <provision_id>
```

To force a retry even if the provision is in an unexpected state:

```bash
$ oneprovision retry <provision_id> --force
```
{{% /tab %}}

{{% tab header="API"%}}

```bash
curl -X POST "https://oneform.example.server/api/v1/provisions/<id>/retry" \
  -H "Content-Type: application/json" \
  -d '{}'
```

For further details about the API, refer to the [OneForm API Reference Guide](/product/integration_references/system_interfaces/oneform_api.md).
{{% /tab %}}
{{< /tabpane >}}


## Deprovisioning a Cluster

Deprovisioning a cluster triggers these actions: Terraform's destroy, Ansible's cleanup tasks, and OpenNebula's object removal. 

{{< alert title="Important" color="warning" >}}
Once deprovisioned, the associated cluster and resources cannot be recovered. Always verify the state and content of the provision before proceeding.
{{< /alert >}}

Select the relevant interface to follow the procedure about deprovisioning a cluster: 

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}

{{% tab header="Sunstone"%}}
Still under development.
{{% /tab %}}

{{% tab header="CLI"%}}

To undeploy all the infrastructure associated with a provision, as well as remove its corresponding OpenNebula resources, run:

```bash
$ oneprovision deprovision <provision_id>
```

{{% /tab %}}

{{% tab header="API"%}}

```bash
curl -X POST "https://oneform.example.server/api/v1/provisions/<id>/undeploy" \
  -H "Content-Type: application/json" \
  -d '{
    "force": true
  }'
```

For further details about the API, refer to the [OneForm API Reference Guide](/product/integration_references/system_interfaces/oneform_api.md).
{{% /tab %}}

{{< /tabpane >}}
