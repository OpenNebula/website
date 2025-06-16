---
title: "Contextualization"
date: "2025-02-17"
description:
categories:
pageintoc: "99"
tags:
weight: "1"
---

<a id="kvm-contextualization"></a>

<!--# Open Cloud Contextualization -->

OpenNebula provides a set of contextualization packages for different operating systems that integrates the VM guests with the OpenNebula services. The OpenNebula contextualization process allows to automatically:

* Configure guest networking and hostname settings.
* Set up user credentials for seamless VM access.
* Define the system timezone.
* Resize disk partitions as needed.
* Execute custom actions during boot.

All the OS appliances available in the [OpenNebula Marketplace](https://marketplace.opennebula.io/appliance) come with all the software pre-installed. If you want to build these images yourself, take a look at the [OpenNebula Apps project](https://github.com/OpenNebula/one-apps).

## Install the Context Packages

Additionally you can install the packages manually in any running VM guest, just grab the [latest version of the context packages for your operating system](https://github.com/OpenNebula/one-apps/releases) and install them (don’t forget to save your changes to the VM disk!).

## Using the Context Packages

Configuration parameters are passed to the contextualization packages through the `CONTEXT` attribute of the Virtual Machine. The most common attributes are network configuration, user credentials, and startup scripts. These parameters can be added by using either the CLI or the Sunstone Template wizard. Here is an example of the context section using the CLI:

```default
CONTEXT = [
    TOKEN = "YES",
    NETWORK = "YES",
    SSH_PUBLIC_KEY = "$USER[SSH_PUBLIC_KEY]",
    START_SCRIPT = "yum install -y ntpdate"
]
```

From the following links you can learn more about:

* [Network configuration](https://github.com/OpenNebula/one-apps/wiki/linux_feature#network-configuration).
* [Setup user credentials](https://github.com/OpenNebula/one-apps/wiki/linux_feature#user-credentials).
* [Execute scripts on boot](https://github.com/OpenNebula/one-apps/wiki/linux_feature#execute-scripts-on-boot).
* [Filesystem tuning](https://github.com/OpenNebula/one-apps/wiki/linux_feature#file-system-configuration).
* [Other OS settings and OneGate](https://github.com/OpenNebula/one-apps/wiki/linux_feature#other-system-configuration).

## Contextualization Reference

The full list of options and attributes in the contextualization section are described in the [Virtual Machine Definition File reference section]({{% relref "../../operation_references/configuration_references/template#template-context" %}})
