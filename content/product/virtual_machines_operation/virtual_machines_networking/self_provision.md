---
title: "Self Provision"
date: "2025-02-17"
description:
categories:
pageintoc: "89"
tags:
weight: "4"
---

<a id="self-provision"></a>

<!--# Virtual Network Self-Provisioning -->

End users can create their own Virtual Networks in two different ways:

> - making a **reservation**
> - instantiating a **Virtual Network Template**.

<a id="vgg-vn-reservations"></a>

## Reservations

Reservations allow users to create their own networks consisting of portions of an existing Virtual Network. Each portion is called a Reservation. To implement this you need to:

- **Define a VNET** with the desired ARs and configuration attributes. These attributes will be inherited by any Reservation, so the final users do not need to deal with low-level networking details.
- **Set up access**. In order to make a Reservation, users need `USE` rights on the Virtual Network, just as if they would use it to directly provision IPs from it.
- **Make Reservations**. Users can easily request specific addresses or a number of addresses from a network. Reservations are placed in a new Virtual Network for the user.
- **Use Reservations**. Reservations are Virtual Networks and offer the same interface, so simply point any Virtual Machine to them. The number of addresses and usage stats are also shown in the same way.

### Make and Delete Reservations

To make reservations just choose the source Virtual Network, the number of addresses, and the name of the reservation. For example, to reserve 10 addresses from `Private` and place them on `MyVNET` just:

```default
$ onevnet reserve Private -n MyVNET -s 10
Reservation VNET ID: 7
```

As a result a new VNET has been created:

```default
$ onevnet list
ID USER       GROUP        NAME        CLUSTER    BRIDGE  STATE  LEASES
 0 admin      oneadmin     Private     -          vbr1    rdy        10
 7 helen      users        MyVNET      -          vbr1    rdy         0
```

Note that Private shows 10 address leases in use, those reserved by `MyVNET`. Also note that both networks share the same configuration, e.g., `BRIDGE`.

Reservations can include advanced options such as:

- The AR where you want to make the reservation from in the source Virtual Network
- The starting IP or MAC to make the reservation from

A reservation can be removed just like a regular Virtual Network:

```default
$ onevnet delete MyVNET
```

### Using Reservations

To use a reservation you can use it like any other Virtual Network, as they expose the same interface. For example, to attach a Virtual Machine to the previous reservation:

```default
NIC = [ NETWORK = "MyVNET"]
```

### Updating Reservations

A reservation can be also extended with new addresses. That is, you can add a new reservation to an existing one. This way, users can refer to their own network with a controlled and deterministic address space.

{{< alert title="Note" color="success" >}}
Reservation increase lease counters on the user and group, and they can be limited through a quota.{{< /alert >}} 

{{< alert title="Note" color="success" >}}
The reservation interface is exposed by Sunstone in a very convenient way.{{< /alert >}} 

## Virtual Network Templates

Virtual Network Templates allow end users to create their own Virtual Networks without knowledge of the underlying infrastructure. Virtual Network Templates, unlike reservations, allow end users to set the logic attributes, like address ranges, dns server, or gateway of the network. See the [Virtual Network Templates guide]({{% relref "vn_templates#vn-templates" %}}) for more information.
