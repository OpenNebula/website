---
title: "Command Line Interface"
linkTitle: "Commands"
date: "2025-02-17"
description:
categories:
pageintoc: "152"
tags:
weight: "3"
---

<a id="cli"></a>

<!--# Command Line Interface -->

OpenNebula provides a set of commands to interact with the system:

## CLI

* [oneacct](https://docs.opennebula.io/doc/{{< version >}}/cli/oneacct.1.html): gets accounting data from OpenNebula.
* [oneacl](https://docs.opennebula.io/doc/{{< version >}}/cli/oneacl.1.html): manages OpenNebula ACLs.
* [onecfg](https://docs.opennebula.io/doc/{{< version >}}/cli/onecfg.1.html): manages OpenNebula configuration files upgrade.
* [onecluster](https://docs.opennebula.io/doc/{{< version >}}/cli/onecluster.1.html): manages OpenNebula clusters.
* [onedatastore](https://docs.opennebula.io/doc/{{< version >}}/cli/onedatastore.1.html): manages OpenNebula datastores.
* [onedb](https://docs.opennebula.io/doc/{{< version >}}/cli/onedb.1.html): OpenNebula database migration tool.
* [onegroup](https://docs.opennebula.io/doc/{{< version >}}/cli/onegroup.1.html): manages OpenNebula groups.
* [onehook](https://docs.opennebula.io/doc/{{< version >}}/cli/onehook.1.html): manages OpenNebula hooks.
* [onehost](https://docs.opennebula.io/doc/{{< version >}}/cli/onehost.1.html): manages OpenNebula Hosts.
* [oneimage](https://docs.opennebula.io/doc/{{< version >}}/cli/oneimage.1.html): manages OpenNebula images.
* [onemarket](https://docs.opennebula.io/doc/{{< version >}}/cli/onemarket.1.html): manages internal and external Marketplaces.
* [onemarketapp](https://docs.opennebula.io/doc/{{< version >}}/cli/onemarketapp.1.html): manages appliances from Marketplaces.
* [onesecgroup](https://docs.opennebula.io/doc/{{< version >}}/cli/onesecgroup.1.html): manages OpenNebula security groups.
* [oneshowback](https://docs.opennebula.io/doc/{{< version >}}/cli/oneshowback.1.html): OpenNebula Showback tool.
* [onetemplate](https://docs.opennebula.io/doc/{{< version >}}/cli/onetemplate.1.html): manages OpenNebula templates.
* [oneuser](https://docs.opennebula.io/doc/{{< version >}}/cli/oneuser.1.html): manages OpenNebula users.
* [onevdc](https://docs.opennebula.io/doc/{{< version >}}/cli/onevdc.1.html): manages OpenNebula Virtual Datacenters.
* [onevm](https://docs.opennebula.io/doc/{{< version >}}/cli/onevm.1.html): manages OpenNebula Virtual Machines.
* [onevmgroup](https://docs.opennebula.io/doc/{{< version >}}/cli/onevmgroup.1.html): manages OpenNebula VMGroups.
* [onevnet](https://docs.opennebula.io/doc/{{< version >}}/cli/onevnet.1.html): manages OpenNebula networks.
* [onevntemplate](https://docs.opennebula.io/doc/{{< version >}}/cli/onevntemplate.1.html): manages OpenNebula networks templates.
* [onevrouter](https://docs.opennebula.io/doc/{{< version >}}/cli/onevrouter.1.html): manages OpenNebula Virtual Routers.
* [onezone](https://docs.opennebula.io/doc/{{< version >}}/cli/onezone.1.html): manages OpenNebula Zones.
* [oneirb](https://docs.opennebula.io/doc/{{< version >}}/cli/oneirb.1.html): opens an irb session.
* [onelog](https://docs.opennebula.io/doc/{{< version >}}/cli/onelog.1.html): access to OpenNebula services log files.

The output of these commands can be customized by modifying the configuration files found in `/etc/one/cli/`. They also can be customized on a per-user basis, in this case the configuration files should be placed in `$HOME/.one/cli`.

List operation for each command will open a `less` session for a better user experience. First elements will be printed right away while the rest will begin to be requested and added to a cache, providing faster response times, especially on big deployments. Less session will automatically be canceled if a pipe is used for better interaction with scripts, providing the traditional, non-interactive output.

## OneFlow Commands

* [oneflow](https://docs.opennebula.io/doc/{{< version >}}/cli/oneflow.1.html): OneFlow Service management.
* [oneflow-template](https://docs.opennebula.io/doc/{{< version >}}/cli/oneflow-template.1.html): OneFlow Service Template management.

## OneGate Commands

* [onegate](https://docs.opennebula.io/doc/{{< version >}}/cli/onegate.1.html): OneGate Service management.

