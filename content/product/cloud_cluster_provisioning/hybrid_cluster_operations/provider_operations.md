---
title: "Managing Providers"
date: "2025-02-17"
description:
categories:
pageintoc: "222"
tags:
weight: "2"
---

<a id="provider-operations"></a>

<!--# Managing Providers -->

You can manage your Edge providers with the command `oneprovider`. This will allow you to register the provider in OpenNebula and use it. The provider will be created as part of the Edge Cluster definition when you create the Edge Cluster.

{{< alert title="Important" color="success" >}}
The information stored in providers is encrypted due to security reasons. Because of this, a user should belong to `oneadmin's` group in order to use them.{{< /alert >}} 

## Command Usage

The CLI command to manage Edge providers is `oneprovider`. It follows the same structure as the other CLI commands in OpenNebula. You can check all the available commands with the option `-h` or `--help`.

{{< alert title="Warning" color="warning" >}}
Provider information is encrypted, so it can only be managed by oneadmin or oneadmin’s group user.{{< /alert >}} 

### Create

To create a provider, use the command `oneprovider create`:

```default
$ oneprovider create /tmp/template.yml
ID: 0
```

### Check Information

To check provider information, use the command `oneprovider show`:

```default
$ oneprovider show 0
PROVIDER 0 INFORMATION
ID   : 0
NAME : aws-frankfurt

CONNECTION INFORMATION
access_key : AWS access key
secret_key : AWS secret key
region     : eu-central-1
```

{{< alert title="Warning" color="warning" >}}
Information is shown unencrypted.{{< /alert >}} 

### Update

You can update the provider information using the command `oneprovider update`.

### Delete

To delete the provider, use the command `oneprovider delete`, e.g.:

```default
$ oneprovider delete 2
```

{{< alert title="Warning" color="warning" >}}
If you try to delete a provider that is being used by a provision or provision template, you will get an error.{{< /alert >}} 

<a id="adding-provider"></a>
