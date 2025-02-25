---
title: "OneFlow Configuration"
date: "2025/02/17"
description:
categories:
pageintoc: "162"
tags:
weight: "6"
---

<a id="appflow-configure"></a>

<a id="oneflow-conf"></a>

<!--# OneFlow Configuration -->

OneFlow **orchestrates multi-VM services** as a whole, interacts with the OpenNebula Daemon to manage the Virtual Machines (starts, stops), and can be controlled via the Sunstone GUI or over CLI. It’s a dedicated daemon installed by default as part of the [Single Front-end Installation]({{% relref "../../package_installation_references/front_end_installation/install#frontend-installation" %}}), but can be deployed independently on a different machine. The server is distributed as an operating system package `opennebula-flow` with the system service `opennebula-flow`.

Read more in [Multi-VM Service Management]({{% relref "../../virtual_machines_operation/multi-vm_workflows/index#multivm-service-management" %}}).

## Configuration

The OneFlow configuration file can be found in `/etc/one/oneflow-server.conf` on your Front-end. It uses **YAML** syntax with following parameters:

{{< alert title="Note" color="success" >}}
After a configuration change, the OneFlow server must be [restarted]({{% relref "#oneflow-conf-service" %}}) to take effect.{{< /alert >}} 

| Parameter                             | Description                                                                                                                                                                                                                                                                                                                                                              |
|---------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Server Configuration**              |                                                                                                                                                                                                                                                                                                                                                                          |
| `:one_xmlrpc`                         | Endpoint of OpenNebula XML-RPC API                                                                                                                                                                                                                                                                                                                                       |
| `:subscriber_endpoint`                | Endpoint for ZeroMQ subscriptions                                                                                                                                                                                                                                                                                                                                        |
| `:autoscaler_interval`                | Time in seconds between each evaluation of elasticity rules                                                                                                                                                                                                                                                                                                              |
| `:host`                               | Host/IP where OneFlow will listen                                                                                                                                                                                                                                                                                                                                        |
| `:port`                               | Port where OneFlow will listen                                                                                                                                                                                                                                                                                                                                           |
| `:force_deletion`                     | Force deletion of VMs on terminate signal                                                                                                                                                                                                                                                                                                                                |
| `:retries`                            | Retries in case of aborting call due to authentication issue                                                                                                                                                                                                                                                                                                             |
| **Defaults**                          |                                                                                                                                                                                                                                                                                                                                                                          |
| `:default_cooldown`                   | Default cooldown period after a scale operation, in seconds                                                                                                                                                                                                                                                                                                              |
| `:wait_timeout`                       | Default time to wait for VMs state changes, in seconds                                                                                                                                                                                                                                                                                                                   |
| `:concurrency`                        | Number of threads to make actions with flows                                                                                                                                                                                                                                                                                                                             |
| `:shutdown_action`                    | Default shutdown action. Values: `shutdown`, `shutdown-hard`                                                                                                                                                                                                                                                                                                             |
| `:action_number`<br/>`:action_period` | Default number of virtual machines (`:action_number`) that will receive the given call in each interval (`:action_period`),<br/>when an action is performed on a Role.                                                                                                                                                                                                   |
| `:vm_name_template`                   | Default name for the Virtual Machines created by Oneflow. You can use any of the following placeholders:<br/>`$SERVICE_ID`, `$SERVICE_NAME`, `$ROLE_NAME`, `$VM_NUMBER`.                                                                                                                                                                                                 |
| `:page_size`                          | Default page size when purging DONE services                                                                                                                                                                                                                                                                                                                             |
| **Authentication**                    |                                                                                                                                                                                                                                                                                                                                                                          |
| `:core_auth`                          | Authentication driver to communicate with OpenNebula core<br/><br/>* `cipher` for symmetric cipher encryption of tokens<br/>* `x509` for X.509 certificate encryption of tokens<br/><br/>For more information, visit the [Cloud Server Authentication]({{% relref "../../../integration_framework/development_references/building_from_source_code/cloud_auth#cloud-auth" %}}) reference. |
| **Logging**                           |                                                                                                                                                                                                                                                                                                                                                                          |
| `:debug_level`                        | Logging level. Values: `0` for ERROR level, `1` for WARNING level, `2` for INFO level, `3` for DEBUG level                                                                                                                                                                                                                                                               |
| `:expire_delta`                       | Default interval for timestamps. Tokens will be generated using the same timestamp for this interval of time. THIS VALUE CANNOT BE LOWER THAN EXPIRE_MARGIN.                                                                                                                                                                                                             |
| `:expire_margin`                      | Tokens will be generated if time > EXPIRE_TIME - EXPIRE_MARGIN                                                                                                                                                                                                                                                                                                           |

In the default configuration, the OneFlow server will only listen to requests coming from `localhost` (which is enough to control OneFlow over Sunstone running on the same host). If you want to control OneFlow over API/CLI remotely, you need to change `:host` parameter in `/etc/one/oneflow-server.conf` to a public IP of your Front-end host or to `0.0.0.0` (to work on all IP addresses configured on Host).

<a id="oneflow-conf-sunstone"></a>

### Configure Sunstone

Sunstone GUI enables end-users to access the OneFlow from the UI and it directly connects to OneFlow on their behalf. Sunstone has configured the OneFlow endpoint it connects to in `/etc/one/fireedge-server.conf` in parameter `:oneflow_server`. When OneFlow is running on a different host than Sunstone, the endpoint in Sunstone must be configured appropriately.

Sunstone tabs for OneFlow (*Services* and *Service Templates*) are enabled in Sunstone by default. To customize visibility for different types of users, follow the [Sunstone Views]({{% relref "../../cloud_system_administration/multitenancy/fireedge_sunstone_views#fireedge-suns-views" %}}) documentation.

### Configure CLI

OneFlow CLI (`oneflow` and `oneflow-template`) uses same credentials as other [command-line tools]({{% relref "../configuration_references/cli#cli" %}}). The login and password are taken from the file referenced by environment variable `$ONE_AUTH` (defaults to `$HOME/.one/one_auth`). Remote endpoint and (optionally) distinct user/password access to the above is configured in environment variable `$ONEFLOW_URL` (defaults to `http://localhost:2474`), `$ONEFLOW_USER` and `$ONEFLOW_PASSWORD`.

Example:

```default
$ ONEFLOW_URL=http://one.example.com:2474 oneflow list
```

See more in [Managing Users documentation]({{% relref "../../cloud_system_administration/multitenancy/manage_users#manage-users-shell" %}}).

<a id="oneflow-conf-service"></a>

## Service Control and Logs

Change the server running state by managing the operating system service `opennebula-flow`.

To start, restart or stop the server, execute one of:

```default
# systemctl start   opennebula-flow
# systemctl restart opennebula-flow
# systemctl stop    opennebula-flow
```

To enable or disable automatic start on Host boot, execute one of:

```default
# systemctl enable  opennebula-flow
# systemctl disable opennebula-flow
```

Server **logs** are located in `/var/log/one` in following files:

- `/var/log/one/oneflow.log`
- `/var/log/one/oneflow.error`

Logs of individual multi-VM Services managed by OneFlow can be found in

- `/var/log/one/oneflow/$ID.log` where `$ID` identifies the service

Other logs are also available in Journald. Use the following command to show:

```default
# journalctl -u opennebula-flow.service
```

## Advanced Setup

### Permission to Create Services

*Documents* are special types of resources in OpenNebula used by OneFlow to store *Service Templates* and information about *Services*. When a new user Group is created, you can decide if you want to allow/deny its users to create *Documents* (and also OneFlow Services). By default, [new groups]({{% relref "../../cloud_system_administration/multitenancy/manage_groups#manage-groups" %}}) are allowed to create Document resources.
