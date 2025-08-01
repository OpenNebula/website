---
title: "Federation Usage"
date: "2025-02-17"
description:
categories:
pageintoc: "38"
tags:
weight: "3"
---

<a id="federationmng"></a>

<!--# Federation Usage -->

A user will have access to all the Zones where at least one of his or her groups has VDC resources. This access be can done through Sunstone or the CLI.

## Sunstone

In the upper right corner of the Sunstone page, users will see a globe icon next to the name of the Zone currently being used. If the user clicks on that, he or she will get a dropdown with all the accessible Zones. Clicking on any of the Zones in the dropdown will get the user to that Zone.

What’s happening behind the scenes is that the Sunstone server you are using is redirecting its requests to the OpenNebula oned process present in the other Zone. In the example above, if the user clicks on **ZoneB**, Sunstone contacts the OpenNebula listening at `http://zoneb.opennebula.front-end.server:2633/RPC2`.

![zoneswitchsunstone](/images/zoneswitchsunstone.png)

{{< alert title="Warning" color="warning" >}}
Uploading Virtual Machine Images over Sunstone works only for the main Zone to which the particular Sunstone instance belongs, not with other Zones users can switch to.{{< /alert >}} 

<a id="cli-federation-usage"></a>

## CLI

Users can show and switch Zones through the command line using the [onezone](https://docs.opennebula.io/doc/{{< version >}}/cli/onezone.1.html) command. See following examples to understand the Zone management through the CLI.

```default
$ onezone list
C    ID NAME                      ENDPOINT
*     0 OpenNebula                http://localhost:2633/RPC2
    104 ZoneB                     http://ultron.c12g.com:2634/RPC2
```

We can see in the above command output that the user has access to Zones **OpenNebula** and **ZoneB**, and is currently using the **OpenNebula** Zone. The active Zone can be changed by `set` subcommand of [onezone](https://docs.opennebula.io/doc/{{< version >}}/cli/onezone.1.html):

```none
$ onezone set 104
Endpoint changed to "http://ultron.c12g.com:2634/RPC2" in /home/<username>/.one/one_endpoint

$ onezone list
C    ID NAME                      ENDPOINT
      0 OpenNebula                http://localhost:2633/RPC2
*   104 ZoneB                     http://ultron.c12g.com:2634/RPC2
```

All the subsequent CLI commands executed would connect to the OpenNebula listening at `http://zoneb.opennebula.front-end.server:2633/RPC2`.
