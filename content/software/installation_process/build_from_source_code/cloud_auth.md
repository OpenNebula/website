---
title: "Cloud Servers Authentication"
date: "2025-02-17"
description:
categories:
pageintoc: "308"
tags:
weight: "5"
---

<a id="cloud-auth"></a>

<!--# Cloud Servers Authentication -->

When a user interacts with [Sunstone]({{% relref "../../../product/operation_references/opennebula_services_configuration/fireedge#fireedge" %}}), the server authenticates the request and then forwards the requested operation to the OpenNebula daemon.

The forwarded requests between the server and the core daemon include the original user name and are signed with the credentials of a special `server` user.

In the current guide this request forwarding mechanism is explained, and how it is secured with a symmetric-key algorithm is also detailed.

## Server Users

The [Sunstone]({{% relref "../../../product/operation_references/opennebula_services_configuration/fireedge#fireedge" %}}) server communicates with the core using a `server` user. OpenNebula creates the **serveradmin** account at bootstrap with the authentication driver **server_cipher** (symmetric key).

This `server` user uses a special authentication mechanism that allows the servers to perform an operation on behalf of another user.

Please note that you can have as many users with a **server_**\* driver as you need.

### Configure

You must update the configuration files in `/var/lib/one/.one` if you change the serveradmin’s password, or create a different user with the **server_cipher** driver.

```default
$ ls -1 /var/lib/one/.one
sunstone_auth

$ cat /var/lib/one/.one/sunstone_auth
serveradmin:1612b78a4843647a4b541346f678f9e1b43bbcf9
```

{{< alert title="Warning" color="warning" >}}
The `serveradmin` password is hashed in the database. You can use the `--sha256` flag when issuing `oneuser passwd` command for this user.{{< /alert >}} 

{{< alert title="Warning" color="warning" >}}
When Sunstone is running in a different machine than oned you should use an SSL connection. This can be archived with an SSL proxy like stunnel or apache/nginx acting as proxy. After securing the OpenNebula XML-RPC connection, configure Sunstone to use https with the proxy port:

```yaml
:one_xmlrpc: https://frontend:2634/RPC2
```
{{< /alert >}} 

## Tuning & Extending

### Files

You can find the drivers in these paths:

* `/var/lib/one/remotes/auth/server_cipher/authenticate`
* `/var/lib/one/remotes/auth/server_server/authenticate`

### Authentication Session String

OpenNebula users with the **server_cipher** driver use a special authentication session string (the first parameter of the [XML-RPC calls]({{% relref "../../../product/integration_references/system_interfaces/api#api" %}})). A regular authentication token is in the form:

```default
username:secret
```

whereas a user with the **server_cipher**\* driver must use this token format:

```default
username:target_username:secret
```

The core daemon understands a request with this authentication session token as “perform this operation on behalf of target_user”. The `secret` part of the token is signed with the mechanism explained before.

### Two Factor Authentication

To use 2FA in FireEdge see the following [link]({{% relref "../../../product/cloud_system_administration/authentication_configuration/sunstone_auth#sunstone-2f-auth" %}})
