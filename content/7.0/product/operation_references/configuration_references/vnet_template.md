---
title: "Virtual Network Template"
date: "2025-02-17"
description:
categories:
pageintoc: "151"
tags:
weight: "3"
---

<a id="vnet-template"></a>

<!--# Virtual Network Template -->

This page describes how to define a new Virtual Network. A Virtual Network includes three different aspects:

* Physical network attributes.
* Address Range.
* Configuration attributes for the guests.

When writing a Virtual Network template in a file, it follows the same syntax as the [VM template]({{% relref "template#template" %}}).

## Physical Network Attributes

It defines the **underlying networking infrastructure** that will support the Virtual Network, such as the `VLAN ID` or the hypervisor interface to bind the Virtual Network to.

| Attribute           | Description                                                                                                                                                                    | Value                                                      | Mandatory                                       | Drivers                                                    |
|---------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------|-------------------------------------------------|------------------------------------------------------------|
| `NAME`              | Name of the Virtual Network.                                                                                                                                                   | String                                                     | **YES**                                         | All                                                        |
| `VN_MAD`            | The network driver to implement the network.                                                                                                                                   | 802.1Q<br/>fw<br/>ovswitch<br/>vxlan<br/>vcenter<br/>dummy | **YES**                                         | All                                                        |
| `BRIDGE`            | Device to attach the virtual machines to,<br/>depending on the network driver it may refer to<br/>different technologies or require host setups.                               | String                                                     | `YES` for dummy, ovswitch,<br/>fw and vcenter   | dummy<br/>802.1Q<br/>vxlan<br/>ovswitch<br/>fw<br/>        |
| `VLAN_ID`           | Identifier for the VLAN.                                                                                                                                                       | Integer                                                    | `YES` unless<br/>`AUTOMATIC_VLAN_ID` for 802.1Q | 802.1Q<br/>vxlan<br/>ovswitch<br/>                         |
| `AUTOMATIC_VLAN_ID` | If set to YES, OpenNebula will generate a VLAN ID<br/>automatically if VLAN_ID is not defined.<br/>Mandatory YES for 802.1Q if VLAN_ID is not<br/>defined, optional otherwise. | String                                                     | `YES` unless `VLAN_ID`<br/>for 802.1Q           | 802.1Q<br/>vxlan<br/>ovswitch<br/>                         |
| `PHYDEV`            | Name of the physical network device that will be<br/>attached to the bridge.                                                                                                   | String                                                     | `YES`<br/><br/>Optional for vCenter             | 802.1Q<br/>vxlan<br/>                                      |

## Quality of Service Attributes

<a id="vnet-template-qos"></a>

This set of attributes limit the bandwidth of each NIC attached to the Virtual Network. Note that the limits are applied to each NIC individually and are not averaged over all the NICs (e.g. a VM with two interfaces in the same network).

| Attribute          | Description                                                                 | Drivers                             |
|--------------------|-----------------------------------------------------------------------------|-------------------------------------|
| `INBOUND_AVG_BW`   | Average bitrate for the interface in kilobytes/second for inbound traffic.  | All                                 |
| `INBOUND_PEAK_BW`  | Maximum bitrate for the interface in kilobytes/second for inbound traffic.  | All                                 |
| `INBOUND_PEAK_KB`  | Data that can be transmitted at peak speed in kilobytes.                    | All                                 |
| `OUTBOUND_AVG_BW`  | Average bitrate for the interface in kilobytes/second for outbound traffic. | All except ovswitch                 |
| `OUTBOUND_PEAK_BW` | Maximum bitrate for the interface in kilobytes/second for outbound traffic. | All except ovswitch                 |
| `OUTBOUND_PEAK_KB` | Data that can be transmitted at peak speed in kilobytes.                    | All except ovswitch                 |

{{< alert title="Warning" color="warning" >}}
For Outbound QoS when using Open vSwitch, you can leverage the [Open vSwitch QoS](https://docs.openvswitch.org/en/latest/faq/qos/) capabilities.{{< /alert >}} 

## The Address Range

<a id="vnet-template-ar4"></a>

### IPv4 Address Range

| Attribute   | Description                                                                                                   | Mandatory   |
|-------------|---------------------------------------------------------------------------------------------------------------|-------------|
| `TYPE`      | `IP4`                                                                                                         | **YES**     |
| `IP`        | First `IP` in the range in dot notation.                                                                      | **YES**     |
| `MAC`       | First `MAC`, if not provided it will be<br/>generated using the `IP` and the `MAC_PREFIX`<br/>in `oned.conf`. | **NO**      |
| `SIZE`      | Number of addresses in this range.                                                                            | **YES**     |

<a id="vnet-template-ar6"></a>

### IPv6 Address Range

{{< alert title="Important" color="success" >}}
IPv6 Address Ranges can use SIZE up to 2^128. However note that a MAC address (48 bits)  is also assigned to each lease. MAC addresses will be reused when the number of IPv6 addresses is bigger than 2^48.{{< /alert >}} 

| Attribute       | Description                                                                          | Mandatory   |
|-----------------|--------------------------------------------------------------------------------------|-------------|
| `TYPE`          | `IP6`                                                                                | **YES**     |
| `MAC`           | First `MAC`, if not provided it will be generated.                                   | **NO**      |
| `GLOBAL_PREFIX` | A `/64` globally routable prefix.                                                    | **NO**      |
| `ULA_PREFIX`    | A `/64` unique local address (ULA)<br/>prefix corresponding to the `fd00::/8` block. | **NO**      |
| `SIZE`          | Number of addresses in this range.                                                   | **YES**     |

<a id="vn-template-ar6-nslaac"></a>

### IPv6 Address Range (no-SLAAC)

| Attribute       | Description                                                                                     | Mandatory   |
|-----------------|-------------------------------------------------------------------------------------------------|-------------|
| `TYPE`          | `IP6_STATIC`                                                                                    | **YES**     |
| `MAC`           | First `MAC`, if not provided it will be generated.                                              | **NO**      |
| `IP6`           | First `IP6` (full 128 bits) in the range .                                                      | **YES**     |
| `PREFIX_LENGTH` | Length of the prefix to configure VM interfaces.                                                | **YES**     |
| `SIZE`          | Number of addresses in this range. If not provided<br/>it will be computed from `PREFIX_LENGTH` | **NO**      |

<a id="vnet-template-ar46"></a>

### Dual IPv4-IPv6 Address Range

For the IPv6 SLAAC version the following attributes are supported:

| Attribute       | Description                                                                                                   | Mandatory   |
|-----------------|---------------------------------------------------------------------------------------------------------------|-------------|
| `TYPE`          | `IP4_6`                                                                                                       | **YES**     |
| `IP`            | First IPv4 in the range in dot notation.                                                                      | **YES**     |
| `MAC`           | First `MAC`, if not provided it will be<br/>generated using the `IP` and the `MAC_PREFIX`<br/>in `oned.conf`. | **NO**      |
| `GLOBAL_PREFIX` | A `/64` globally routable prefix.                                                                             | **NO**      |
| `ULA_PREFIX`    | A `/64` unique local address (ULA)<br/>prefix corresponding to the `fd00::/8` block                           | **NO**      |
| `SIZE`          | Number of addresses in this range.                                                                            | **YES**     |

The no-SLAAC IPv6 version supports the following attributes:

| Attribute       | Description                                                                                                   | Mandatory   |
|-----------------|---------------------------------------------------------------------------------------------------------------|-------------|
| `TYPE`          | `IP4_6_STATIC`                                                                                                | **YES**     |
| `IP`            | First `IPv4` in the range in dot notation.                                                                    | **YES**     |
| `MAC`           | First `MAC`, if not provided it will be<br/>generated using the `IP` and the `MAC_PREFIX`<br/>in `oned.conf`. | **NO**      |
| `IP6`           | First `IP6` (full 128 bits) in the range.                                                                     | **YES**     |
| `PREFIX_LENGTH` | Length of the prefix to configure VM interfaces.                                                              | **YES**     |
| `SIZE`          | Number of addresses in this range. If not provided<br/>it will be computed from `PREFIX_LENGTH`               | **NO**      |

<a id="vnet-template-eth"></a>

### Ethernet Address Range

| Attribute   | Description                                                     | Mandatory   |
|-------------|-----------------------------------------------------------------|-------------|
| `TYPE`      | `ETHER`                                                         | **YES**     |
| `MAC`       | First `MAC`, if not provided it will be<br/>generated randomly. | **NO**      |
| `SIZE`      | Number of addresses in this range.                              | **YES**     |

<a id="vnet-template-context"></a>

## Contextualization Attributes

| Attribute         | Description                                           |
|-------------------|-------------------------------------------------------|
| `NETWORK_ADDRESS` | Base network address.                                 |
| `NETWORK_MASK`    | Network mask.                                         |
| `GATEWAY`         | Default gateway for the network.                      |
| `GATEWAY6`        | IPv6 router for this network.                         |
| `DNS`             | DNS servers, a space separated list of servers.       |
| `GUEST_MTU`       | Sets the `MTU` for the NICs in this network.          |
| `METRIC`          | Route metric for default IPv4 gateway.                |
| `IP6_METRIC`      | Route metric for default IPv6 gateway.                |
| `METHOD`          | Sets IPv4 guest conf. method for NIC in this network. |
| `IP6_METHOD`      | Sets IPv6 guest conf. method for NIC in this network. |
| `SEARCH_DOMAIN`   | Default search domains for DNS resolution.            |

These attributes can be set in the (in precedence order): VM Template NIC section, Address Range (AR) and Virtual Network Template.

<a id="vnet-template-interface-creation"></a>

## Interface Creation Options

For `802.1Q`, `VXLAN` and `Open vSwitch` drivers you can specify parameters in the VNET template. Option can be overridden or added per network.

| Attribute         | Description                                  |
|-------------------|----------------------------------------------|
| `CONF`            | Driver configuration options.                |
| `BRIDGE_CONF`     | Parameters for Linux bridge creation.        |
| `OVS_BRIDGE_CONF` | Parameters for Open vSwitch bridge creation. |
| `IP_LINK_CONF`    | Parameters for link creation.                |
```default
CONF="vxlan_mc=239.0.100.0,test=false,validate_vlan_id=true"
BRIDGE_CONF="sethello=6"
OVS_BRIDGE_CONF="stp_enable=true"
IP_LINK_CONF="tos=10,udpcsum=,udp6zerocsumrx=__delete__"
```

Options can have empty value when they don’t need a parameter. Also the special value “_\_delete_\_” can be used to delete parameters set here.

You can find more information about these parameters in [802.1Q]({{% relref "../../cloud_clusters_infrastructure_configuration/networking_system_configuration/vlan#hm-vlan" %}}) and [VXLAN]({{% relref "../../cloud_clusters_infrastructure_configuration/networking_system_configuration/vxlan#vxlan" %}}) documentation.

<a id="vnet-template-example"></a>

## Virtual Network Definition Examples

Sample IPv4 VNet:

```default
# Configuration attributes (dummy driver)
NAME        = "Private Network"
DESCRIPTION = "A private network for VM inter-communication"

BRIDGE = "bond-br0"

# Context attributes
NETWORK_ADDRESS = "10.0.0.0"
NETWORK_MASK    = "255.255.255.0"
DNS             = "10.0.0.1"
GATEWAY         = "10.0.0.1"

#Address Ranges, only these addresses will be assigned to the VMs
AR=[TYPE = "IP4", IP = "10.0.0.10", SIZE = "100" ]

AR=[TYPE = "IP4", IP = "10.0.0.200", SIZE = "10" ]
```

Sample IPv4 VNet, using AR of just one IP:

```default
# Configuration attributes (OpenvSwitch driver)
NAME        = "Public"
DESCRIPTION = "Network with public IPs"

BRIDGE  = "br1"
VLAN    = "YES"
VLAN_ID = 12

DNS           = "8.8.8.8"
GATEWAY       = "130.56.23.1"
LOAD_BALANCER = 130.56.23.2

AR=[ TYPE = "IP4", IP = "130.56.23.2", SIZE = "1"]
AR=[ TYPE = "IP4", IP = "130.56.23.34", SIZE = "1"]
AR=[ TYPE = "IP4", IP = "130.56.23.24", SIZE = "1"]
AR=[ TYPE = "IP4", IP = "130.56.23.17", MAC= "50:20:20:20:20:21", SIZE = "1"]
AR=[ TYPE = "IP4", IP = "130.56.23.12", SIZE = "1"]
```
