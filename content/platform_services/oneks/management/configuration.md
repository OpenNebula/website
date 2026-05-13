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

This section is intended for users intending to install, configure, or troubleshoot the OneKS service.

## OneKS Server Configuration

OneKS is implemented as an ODS-based Ruby service plus a CLI/API client.

The main runtime components include:

* `oneks-server`: The service daemon/helper script.  
* `oneks`: The user-facing CLI.  
* **ODS Log Controller**: Log management component.  
* **Event Manager**: Lifecycle event watcher.  
* **Cluster Watchdog**: Cluster state monitoring component.  
* **Seed VM Dependency**: Temporary managed VM used for control-plane bootstrap.  
* **Cluster Router Dependency**: Router-related Cluster dependency.

By default, the OneKS server listens locally on Host `127.0.0.1` and port `10780`.

The client API path uses `/api/v1`.

Default local API endpoint:

```default
http://127.0.0.1:10780/api/v1
```

Remote API access depends on how the service is exposed in the deployment.

OneKS manages OneKS Cluster documents and node-group documents, starts an event manager, and subscribes to OpenNebula lifecycle events.

Important runtime behavior includes:

* **VM Event Watching**: Watches VM allocation and VM state changes.  
* **Seed VM Lifecycle**: Creates and monitors temporary seed VMs during control-plane bootstrap.  
* **Seed VM Readiness**: Tracks seed VM readiness through the `ONEKS_STATE` value.  
* **Router Monitoring**: Monitors virtual router allocation.  
* **Log Exposure**: Exposes per-cluster logs through the API and CLI.  
* **State Reconciliation**: Reconciles Cluster and group state based on observed lifecycle events.

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

* **XML-RPC Endpoint Configuration**: OpenNebula XML-RPC endpoint used by OneKS.  
* **TPROXY XML-RPC Endpoint**: Endpoint exposed through transparent proxy where required.  
* **Server Host and Port**: Local OneKS API listener configuration.  
* **Subscriber Endpoint and Timeout**: Event subscription configuration.  
* `kubectl` **Path**: Path to `kubectl` used by the service where required.  
* **Kubeconfig Path**: Path used for kubeconfig handling where required.  
* **Kubernetes Timeout**: Timeout for Kubernetes operations.  
* **Retry Values**: Retry behavior for lifecycle actions.  
* **Cooldown Values**: Cooldown behavior between retries or state checks.  
* **Concurrency**: Number of concurrent lifecycle operations.  
* **Authentication Mode**: Authentication behavior for API access.  
* **Token Expiry**: Token lifetime where token-based authentication is used.  
* **Log Level**: Service logging verbosity.  
* **Log Output System**: Destination and format for logs.

## Service Management

systemd unit:

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

* **Explicit Server URL**: Value passed with `--server`.  
* `ONEKS_URL`: Environment variable.  
* **User Endpoint File**: `~/.one/oneks_endpoint`.  
* **oneadmin Endpoint File**: `/var/lib/one/.one/oneks_endpoint`.  
* **Default Endpoint**: `http://localhost:10780`.

The API client appends `/api/v1`.

Authentication resolution order:

* **CLI Credentials**: Values such as `--username` and `--password`.  
* **Environment Credentials**: Values such as `ONEKS_USER` and `ONEKS_PASSWORD`.  
* `ONE_AUTH`: Environment variable.  
* **User Auth File**: `~/.one/one_auth`.  
* **oneadmin Auth File**: `/var/lib/one/.one/one_auth`.

## Advanced Configuration

OneKS watches OpenNebula events and depends on:

* **Subscriber Endpoint Connectivity**: Required for event-driven lifecycle tracking.  
* **Seed VM State Reporting**: Required for control-plane bootstrap progress.  
* **Cluster Router Lifecycle Monitoring**: Required where the topology depends on routers.  
* **TPROXY Support**: Required where services must be exposed through the public network gateway.

Advanced configuration includes:

* **Concurrency Tuning**: Controls how many operations can run in parallel.  
* **Log Verbosity**: Controls the level of service logs.  
* **Development Versus Production Mode**: Controls runtime behavior depending on deployment mode.  
* **Required Network Services**: OneGate, XML-RPC, and related service connectivity.  
* **TPROXY Ports and Connectivity**: Typically ports `5030` and `2633` through the public network gateway.  
* **Timeout and Retry Behavior**: Controls how long lifecycle actions wait before failing or retrying.
