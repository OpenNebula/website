---
title: "FireEdge Configuration"
date: "2025-02-17"
description:
categories:
pageintoc: "161"
tags:
weight: "5"
---

<a id="fireedge"></a>

<a id="fireedge-setup"></a>

<a id="fireedge-configuration"></a>

<a id="fireedge-conf"></a>

<!--# FireEdge Configuration -->

The OpenNebula FireEdge server provides a **next-generation web-management interface** for remote OpenNebula Cluster provisioning as well as additional functionality to Sunstone. It’s a dedicated daemon installed by default as part of the [Single Front-end Installation]({{% relref "front_end_installation" %}}), but can be deployed independently on a different machine. The server is distributed as an operating system package `opennebula-fireedge` with the system service `opennebula-fireedge`.

## Main Features

- **Guacamole Proxy** for Sunstone to remotely access the VMs (incl., VNC, RDP, and SSH)
- **FireEdge Sunstone**: new iteration of Sunstone written in React/Redux. Accessible through the following URL:

```default
http://<OPENNEBULA-FRONTEND>:2616
```

<a id="fireedge-install-configuration"></a>

### Configuration

The FireEdge server configuration file can be found in `/etc/one/fireedge-server.conf` on your Front-end. It uses the **YAML** syntax, with the parameters listed in the table below.

{{< alert title="Note" color="success" >}}
After a configuration change, the FireEdge server must be [restarted]({{% relref "#fireedge-conf-service" %}}) to take effect.{{< /alert >}} 

| Parameter                       | Default Value                | Description                                                                                                                                                                                                                                                                               |
|---------------------------------|------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `log`                           | `prod`                       | Log debug: `prod` or `dev`                                                                                                                                                                                                                                                                |
| `cors`                          | `true`                       | Enable CORS (cross-origin resource sharing)                                                                                                                                                                                                                                               |
| `host`                          | `0.0.0.0`                    | IP on which the FireEdge server will listen                                                                                                                                                                                                                                               |
| `port`                          | `2616`                       | Port on which the FireEdge server will listen                                                                                                                                                                                                                                             |
| `one_xmlrpc`                    | `http://localhost:2633/RPC2` | Endpoint of OpenNebula XML-RPC API. It needs to match the **ENDPOINT** attribute of `onezone show 0`                                                                                                                                                                              |
| `oneflow_server`                | `http://localhost:2474`      | Endpoint of OneFlow server                                                                                                                                                                                                                                                                |
| `session_expiration`            | `180`                        | JWT expiration time (minutes)                                                                                                                                                                                                                                                             |
| `session_remember_expiration`   | `3600`                       | JWT expiration time when using remember check box (minutes)                                                                                                                                                                                                                           |
| `default_zone`                  |                              | Shows the default resources of that zone                                                                                                                                                                                                                                                  |
| `default_zone/id`               | `0`                          | Id of the zone to which this fireedge belongs                                                                                                                                                                                                                                             |
| `default_zone/name`             | `OpenNebula`                 | Name of the zone to which this fireedge belongs                                                                                                                                                                                                                                           |
| `default_zone/endpoint`         | `http://localhost:2633/RPC2` | XML-RPC url of the zone to which this fireedge belongs                                                                                                                                                                                                                                |
| `minimun_opennebula_expiration` | `30`                         | Minimum time to reuse previously generated JWTs (minutes)                                                                                                                                                                                                                             |
| `subscriber_endpoint`           | `tcp://localhost:2101`       | Endpoint to subscribe for OpenNebula events                                                                                                                                                                                                                                               |
| `debug_level`                   | `2`                          | Log debug level                                                                                                                                                                                                                                                                           |
| `truncate_max_length`           | `150`                        | Log message max length                                                                                                                                                                                                                                                                    |
| `api_timeout`                   | `45_000`                     | Global API timeout limit                                                                                                                                                                                                                                                                  |
| `guacd/port`                    | `4822`                       | Connection port of guacd server                                                                                                                                                                                                                                                           |
| `guacd/host`                    | `localhost`                  | Connection hostname/IP of guacd server                                                                                                                                                                                                                                                    |
| `auth`                          | `opennebula`                 | Authentication driver for incoming requests: **OpenNebula** the authentication will be done by the OpenNebula core using the driver defined for the user. **remote** performs the login based on a Kerberos X-Auth-Username header provided by authentication backend |
| `auth_redirect`                 |                              | This configuration is for the login button redirect. The available options are: **/**, **.** or a **URL**                                                                                                                                                                         |

{{< alert title="Note" color="success" >}}
JWT is a acronym of JSON Web Token{{< /alert >}} 

<a id="fireedge-sunstone-configuration"></a>

**FireEdge Sunstone**

![fireedge_sunstone_dashboard](/images/fireedge_sunstone_dashboard.png)

| Parameter                 | Default Value                           | Description                                                                     |
|---------------------------|-----------------------------------------|---------------------------------------------------------------------------------|
| `support_url`             | `https://opennebula.zendesk.com/api/v2` | Zendesk support URL                                                             |
| `token_remote_support`    |                                         | Support enterprise token                                                        |
| `sunstone_prepend`        |                                         | Optional parameter for `Sunstone commands` command                              |
| `tmpdir`                  | `/var/tmp`                              | Directory to store temporal files when uploading images                     |
| `max_upload_file_size`    | `10737418240`                           | Max size upload file (bytes). Default is 10GB                                   |
| `proxy`                   |                                         | Enable an http proxy for the support portal and to download MarketPlaceApps |
| `leases`                  |                                         | Enable the vm leases                                                            |
| `supported_fs`            |                                         | Support filesystem                                                              |
| `currency`                | `EUR`                                   | Currency formatting                                                             |
| `default_lang`            | `en`                                    | Default language setting                                                        |
| `langs`                   |                                         | List of server localizations                                                    |
| `keep_me_logged_in`       | `true`                                  | True to display ‘Keep me logged in’ option                                      |
| `currentTimeZone`         |                                         | Time Zone                                                                       |
| `rowStyle`                |                                         | Changes the style of rows in datatables, values can be `card` or `list`.    |

Once the server is initialized, it creates the file `/var/lib/one/.one/fireedge_key`, used to encrypt communication with Guacd.

<a id="fireedge-in-ha"></a>

In HA environments, `fireedge_key` needs to be copied from the first leader to the followers. Optionally, in order to have the provision logs available in all the HA nodes, `/var/lib/one/fireedge` need to be shared between nodes.

<a id="fireedge-configuration-for-sunstone"></a>

### Tuning and Extending

<a id="fireedge-branding"></a>

## Branding FireEdge

You can add your logo to the login, main, favicon and loading screens by updating the `logo:` attribute as follows:

- The logo configuration is done in the `/etc/one/fireedge/sunstone/views/sunstone-views.yaml` file.
- The logo of the main UI screen is defined for each view.

The logo image must be copied to `/usr/lib/one/fireedge/dist/client/assets/images/logos`.

The following example shows how you can change the logo to a generic linux one (included by default in all FireEdge installations):

```yaml
# /etc/one/fireedge/sunstone/views/sunstone-views.yaml
---
logo: linux.png

groups:
    oneadmin:
        - admin
        - user
default:
    - user
```

{{< alert title="Note" color="success" >}}
The logo can be updated without having to restart the FireEdge server!{{< /alert >}} 

![fireedge_sunstone_linux_login_logo](/images/fireedge_login_linux_logo.png) ![fireedge_sunstone_linux_drawer_logo](/images/fireedge_drawer_linux_logo.png)

<a id="fireedge-conf-guacamole"></a>

## Configure DataTables

You can change the style of the rows depending on your preferences. in case they are changed in the fireedge-server.conf file. this change will be priority. and it will adjust the view to all users.

![fireedge_sunstone_list_datatable](/images/sunstone_list_datatable.png)

Each user can also do it from his configuration.

![fireedge_sunstone_setting_list_datatable](/images/sunstone_setting_list_datatable.png)

## Configure Guacamole

FireEdge uses [Apache Guacamole](http://guacamole.apache.org), a free and open source web application that allows you to access a remote console or desktop of the Virtual Machine anywhere using a modern web browser. It is a clientless **remote desktop gateway** which only requires Guacamole installed on a server and a web browser supporting HTML5.

Guacamole supports multiple connection methods such as **VNC, RDP, and SSH** and is made up of two separate parts - server and client. The Guacamole server consists of the native server-side libraries required to connect to the server and the Guacamole proxy daemon (`guacd`), which accepts the user’s requests and connects to the remote desktop on their behalf.

{{< alert title="Note" color="success" >}}
The OpenNebula **binary packages** provide Guacamole proxy daemon (package `opennebula-guacd` and service `opennebula-guacd`), which is installed alongside FireEdge. In the default configuration, the Guacamole proxy daemon is automatically started along with FireEdge, and FireEdge is configured to connect to the locally-running Guacamole. No extra steps are required!{{< /alert >}} 

If Guacamole is running on a different host to the FireEdge, following FireEdge configuration parameters have to be customized:

- `guacd/host`
- `guacd/port`

<a id="fireedge-conf-service"></a>

### Service Control and Logs

Change the server running state by managing the operating system service `opennebula-fireedge`.

To start, restart or stop the server, execute one of:

```default
$ systemctl start   opennebula-fireedge
$ systemctl restart opennebula-fireedge
$ systemctl stop    opennebula-fireedge
```

To enable or disable automatic start on host boot, execute one of:

```default
$ systemctl enable  opennebula-fireedge
$ systemctl disable opennebula-fireedge
```

Server **logs** are located in `/var/log/one` in the following file:

- `/var/log/one/fireedge.log`: operational log.
- `/var/log/one/fireedge.error`: errors and exceptions log.

Other logs are also available in Journald. Use the following command to show them:

```default
$ journalctl -u opennebula-fireedge.service
```

### Troubleshooting

## Conflicting Port

A common issue when starting FireEdge is a used port:

```default
Error: listen EADDRINUSE: address already in use 0.0.0.0:2616
```

If another service is using the port, you can change FireEdge configuration (`/etc/one/fireedge-server.conf`) to use another host/port.
