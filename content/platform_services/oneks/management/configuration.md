---
title: "OneKS Cluster Configuration"
linkTitle: "Configuration"
date: "2026-05-12"
description:
categories:
tags:
weight: "3"
type: docs
---

This section is intended for users who install, configure, or troubleshoot the OneKS service.

## OneKS Server Configuration

OneKS is implemented as an ODS-based Ruby service plus a CLI/API client.

Main runtime components include:

* `oneks-server`: the service daemon/helper script.  
* `oneks`: the user-facing CLI.  
* **ODS log controller**: log management component.  
* **Event Manager**: lifecycle event watcher.  
* **Cluster Watchdog**: cluster state monitoring component.  
* **Seed VM dependency**: temporary managed VM used for control-plane bootstrap.  
* **Cluster Router dependency**: router-related cluster dependency.

By default, the OneKS server listens locally on host `127.0.0.1` and port `10780`.

The client API path uses `/api/v1`.

Default local API endpoint:

```default
http://127.0.0.1:10780/api/v1
```

Remote API access depends on how the service is exposed in the deployment.

OneKS manages OneKS cluster documents and node-group documents, starts an event manager, and subscribes to OpenNebula lifecycle events.

Important runtime behavior includes:

* **VM event watching**: watches VM allocation and VM state changes.  
* **Seed VM lifecycle**: creates and monitors temporary seed VMs during control-plane bootstrap.  
* **Seed VM readiness**: tracks seed VM readiness through the `ONEKS_STATE` value.  
* **Router monitoring**: monitors virtual router allocation.  
* **Log exposure**: exposes per-cluster logs through the API and CLI.  
* **State reconciliation**: reconciles cluster and group state based on observed lifecycle events.

Primary packaged paths:

```default
/etc/one/oneks-server.conf
/usr/lib/one/oneks/oneks-server.rb
/var/lib/one/oneks/
```

When OpenNebula is installed with `ONE_LOCATION` set, OneKS paths are resolved relative to that location.

With `ONE_LOCATION` set:

```default
$ONE_LOCATION/etc/oneks-server.conf
$ONE_LOCATION/lib/oneks/oneks-server.rb
$ONE_LOCATION/var/oneks/
```

Important configurable defaults include:

* **XML-RPC endpoint configuration**: OpenNebula XML-RPC endpoint used by OneKS.  
* **TPROXY XML-RPC endpoint**: endpoint exposed through transparent proxy where required.  
* **Server host and port**: local OneKS API listener configuration.  
* **Subscriber endpoint and timeout**: event subscription configuration.  
* **`kubectl` path**: path to `kubectl` used by the service where required.  
* **Kubeconfig path**: path used for kubeconfig handling where required.  
* **Kubernetes timeout**: timeout for Kubernetes operations.  
* **Retry values**: retry behavior for lifecycle actions.  
* **Cooldown values**: cooldown behavior between retries or state checks.  
* **Concurrency**: number of concurrent lifecycle operations.  
* **Authentication mode**: authentication behavior for API access.  
* **Token expiry**: token lifetime where token-based authentication is used.  
* **Log level**: service logging verbosity.  
* **Log output system**: destination and format for logs.

## Service Management

Systemd unit:

```default
opennebula-oneks.service
```

Service commands:

```shell
systemctl start opennebula-oneks
systemctl stop opennebula-oneks
systemctl restart opennebula-oneks
systemctl status opennebula-oneks
journalctl -u opennebula-oneks
```

Some deployments may expose the service under a different unit name, such as `opennebula-ks.service`. Use the unit name shipped by the installed package.

Helper commands:

```shell
oneks-server start
oneks-server stop
```

## Service Logs 

Service log paths:

```default
/var/log/one/oneks.log
/var/log/one/oneks.error
```

With `ONE_LOCATION`:

```default
$ONE_LOCATION/var/oneks.log
$ONE_LOCATION/var/oneks.error
```

Per-cluster lifecycle logs:

```default
/var/log/one/oneks/<cluster_id>.log
```

With `ONE_LOCATION`:

```default
$ONE_LOCATION/var/oneks/<cluster_id>.log
```

## Authentication and Endpoint Configuration

CLI binary:

```shell
oneks
```

Endpoint resolution order:

* **Explicit server URL**: value passed with `--server`.  
* **`ONEKS_URL`**: environment variable.  
* **User endpoint file**: `~/.one/oneks_endpoint`.  
* **oneadmin endpoint file**: `/var/lib/one/.one/oneks_endpoint`.  
* **Default endpoint**: `http://localhost:10780`.

The API client appends `/api/v1`.

Authentication resolution order:

* **CLI credentials:** values such as `--username` and `--password`.  
* **Environment credentials:** values such as `ONEKS_USER` and `ONEKS_PASSWORD`.  
* **`ONE_AUTH`:** environment variable.  
* **User auth file:** `~/.one/one_auth`.  
* **oneadmin auth file:** `/var/lib/one/.one/one_auth`.

## Advanced Configuration

OneKS watches OpenNebula events and depends on:

* **Subscriber endpoint connectivity**: required for event-driven lifecycle tracking.  
* **Seed VM state reporting**: required for control-plane bootstrap progress.  
* **Cluster router lifecycle monitoring**: required where the topology depends on routers.  
* **TPROXY support**: required where services must be exposed through the public network gateway.

Advanced configuration includes:

* **Concurrency tuning**: controls how many operations can run in parallel.  
* **Log verbosity**: controls the level of service logs.  
* **Development versus production mode**: controls runtime behavior depending on deployment mode.  
* **Required network services**: OneGate, XML-RPC, and related service connectivity.  
* **TPROXY ports and connectivity**: typically ports `5030` and `2633` through the public network gateway.  
* **Timeout and retry behavior**: controls how long lifecycle actions wait before failing or retrying.
