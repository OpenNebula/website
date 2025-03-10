---
title: "On-Premise Provider"
date: "2025-02-17"
description:
categories:
pageintoc: "208"
tags:
weight: "5"
---

<a id="onprem-provider"></a>

<!--# On-Premises Provider -->

The `onprem` provider is a convenient abstraction to represent your local resources. This provider can be used to automatically configure and install OpenNebula clusters using your on-premises servers. It needs no special configuration as it will retrieve the FQDNs or IP addresses of the hosts while creating the provisions.

## How to Create the On-Premises Provider

You just need to create the on-premises provider once, simply run the following command:

```default
$ oneprovider create /usr/share/one/oneprovision/edge-clusters/metal/providers/onprem/onprem.yml
```

The `onprem` provider can also be shown by running the command below:

```default
$ oneprovider show onprem
PROVIDER 0 INFORMATION
ID   : 0
NAME : onprem
```

{{< alert title="Note" color="success" >}}
OpenNebula front-end node requires ssh root access to the hosts that are going to be configured using `onprem` provider.{{< /alert >}} 
