---
title: "Managing Provisions"
date: "2025-02-17"
description:
categories:
pageintoc: "222"
tags:
weight: "3"
---

<a id="provision-operations"></a>

<!--# Managing Provisions -->

In OneForm, Provisions represent fully-deployed Clusters or infrastructure stacks. Each Provision is associated with a specific cloud or on-premises Provider and contains OpenNebula resources such as Hosts, datastores, and Virtual Networks.

Here you will find details on how to:

* [Scale existing Provisions by adding or removing hosts](#scaling-provisions)
* [Manage public IP assignments](#managing-public-ips)
* [Retry or deprovision failed Provisions](#retrying-failed-provisions)
* [Monitor and control Provision lifecycles through the CLI](#retrying-failed-provisions)

## Scaling Provisions

Select the tab for your preferred interface to view the procedure to scale Provisions:

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}

{{% tab header="Sunstone"%}}
In the Sunstone interface, go to **Infrastructure -> Clusters** and select the Cluster you want to scale. Open the **Host** tab:
{{< image
  pathDark="images/oneform/oneprovision/operations/dark/add_host_operation.png"
  path="images/oneform/oneprovision/operations/light/add_host_operation.png"
  alt="Scaling provisions"
>}}
{{% /tab %}}

{{% tab header="CLI"%}}
To increase the number of hosts in a running Provision, use `oneprovision add-host`. Alternatively, execute `oneprovision del-host` command to decrease hosts. These operations trigger an update of the infrastructure through Terraform and Ansible.

Do not set `--amount` and `--host-ids` simultaneously since the operation will fail. You must choose one method of scaling at a time:


* Add Hosts:

  ```bash
  oneprovision add-host <provision_id> --amount <number_of_hosts>
  ```

  Example:

  ```bash
  oneprovision add-host 42 --amount 2
  ```

* Remove Hosts:

  ```bash
  oneprovision del-host <provision_id> --host-ids <id1,id2,...>
  ```

  Example:

  ```bash
  oneprovision del-host 42 --host-ids 105,106
  ```

{{% /tab %}}

{{% tab header="API"%}}

Use the following example requests, replacing the appropriate parameters for your Provision:

* Add Hosts

```bash
curl -X POST "https://oneform.example.server/api/v1/provisions/<id>/scale" \
  -u "username:password" \
  -H "Content-Type: application/json" \
  -d '{
    "direction": "up",
    "nodes": 2
  }'
```

* Remove Hosts

```bash
curl -X POST "https://oneform.example.server/api/v1/provisions/<id>/scale" \
  -u "username:password" \
  -H "Content-Type: application/json" \
  -d '{
    "direction": "down",
    "nodes": [ "node1" ],
    "opts": {
      "force": true
    }
  }'
```
<br>

For further details about the API, see the [OneForm API Reference]({{% relref "/product/integration_references/system_interfaces/oneform_api.md" %}}).
{{% /tab %}}

{{< /tabpane >}}

## Managing Public IPs

Select the tab for your preferred interface to view the procedure to manage public IPs:

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}

{{% tab header="Sunstone"%}}
In the Sunstone interface, go to **Infrastructure -> Clusters** and select the Cluster you want to scale. Open the **VNet** tab and click **Add public IPs**:
{{< image
  pathDark="images/oneform/oneprovision/operations/dark/add_ip_operation_modal.png"
  path="images/oneform/oneprovision/operations/light/add_ip_operation_modal.png"
  alt="Managing IPs"
>}}
{{% /tab %}}

{{% tab header="CLI"%}}
For Provisions that support public networking like AWS and i3Dnet, dynamically manage Elastic IPs through the following commands:

* Add Public IPs

  ```bash
  oneprovision add-ip <provision_id> --amount <number_of_ips>
  ```

  Example:

  ```bash
  oneprovision add-ip 42 --amount 1
  ```

* Remove a Public IP by Address Range (AR ID)

  ```bash
  oneprovision remove-ip <provision_id> <ar_id>
  ```

  Example:

  ```bash
  oneprovision remove-ip 42 7
  ```

To view current IP allocations, run `oneprovision show <id>` and inspect the associated public network address ranges (ARs).
{{% /tab %}}

{{% tab header="API"%}}
Use the following example requests, replacing the appropriate parameters for your Provision:

* Add Public IPs

```bash
curl -X POST "https://oneform.example.server/api/v1/provisions/<id>/add-ip" \
  -u "username:password" \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 3
  }'
```

* Remove a Public IP

```bash
curl -X POST "https://oneform.example.server/api/v1/provisions/<id>/remove-ip" \
  -u "username:password" \
  -H "Content-Type: application/json" \
  -d '{
    "ar_id": 42
  }'
```
<br>
For further details about the API, see the [OneForm API Reference]({{% relref "/product/integration_references/system_interfaces/oneform_api.md" %}}).
{{% /tab %}}

{{< /tabpane >}}

## Retrying Failed Provisions

Retrying a Provision is a non-destructive operation that attempts to resume from the last recoverable state within its internal lifecycle.

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}

{{% tab header="Sunstone"%}}
In the **Cluster Logs** view, if a Cluster installation fails. Click the **Retry** icon in the top right hand corner of the page:
{{< image
  pathDark="images/oneform/oneprovision/operations/dark/retry_operation_cluster_logs.png"
  path="images/oneform/oneprovision/operations/light/retry_operation_cluster_logs.png"
  alt="Managing IPs"
>}}
{{% /tab %}}

{{% tab header="CLI"%}}
If a Provision fails during deployment, attempt recovery by re-triggering the failed step:

```bash
oneprovision retry <provision_id>
```

To force a retry even if the Provision is in an unexpected state:

```bash
oneprovision retry <provision_id> --force
```
{{% /tab %}}

{{% tab header="API"%}}
Use the following example request, replacing the appropriate parameters for your Provision:
```bash
curl -X POST "https://oneform.example.server/api/v1/provisions/<id>/retry" \
  -u "username:password" \
  -H "Content-Type: application/json" \
  -d '{}'
```
<br>

For further details about the API, see the [OneForm API Reference]({{% relref "/product/integration_references/system_interfaces/oneform_api.md" %}}).
{{% /tab %}}
{{< /tabpane >}}


## Deprovisioning a Cluster

Deprovisioning a Cluster triggers the following actions:
* Terraform destroy
* Ansible cleanup tasks
* OpenNebula object removal

{{< alert title="Important" type="warning" >}}
Once deprovisioned, the associated Cluster and resources cannot be recovered. Always verify the state and content of the Provision before proceeding.
{{< /alert >}}

Select the tab for your preferred interface to view the procedure to deprovision a Cluster: 

{{< tabpane text=true right=false >}}
{{% tab header="**Interfaces**:" disabled=true /%}}

{{% tab header="Sunstone"%}}
In the Sunstone interface, go to **Infrastructure -> Clusters** and select the Cluster you want to deprovision. Click **Deprovision** and then **Accept**:
{{< image
  pathDark="images/oneform/oneprovision/operations/dark/deprovision_cluster.png"
  path="images/oneform/oneprovision/operations/light/deprovision_cluster.png"
  alt="Managing IPs"
>}}
{{% /tab %}}

{{% tab header="CLI"%}}

To undeploy all the infrastructure associated with a Provision, as well as remove its corresponding OpenNebula resources, run:

```bash
oneprovision deprovision <provision_id>
```

{{% /tab %}}

{{% tab header="API"%}}

```bash
curl -X POST "https://oneform.example.server/api/v1/provisions/<id>/undeploy" \
  -u "username:password" \
  -H "Content-Type: application/json" \
  -d '{
    "force": true
  }'
```
<br>

For further details about the API, see the [OneForm API Reference]({{% relref "/product/integration_references/system_interfaces/oneform_api.md" %}}).
{{% /tab %}}

{{< /tabpane >}}
