---
title: "Overview"
date: "2025-02-17"
description:
categories:
pageintoc: "122"
tags:
weight: "1"
---

<a id="external-auth"></a>

<!--# Overview -->

OpenNebula comes with a default internal user authentication system based on username/password, where information and secrets are stored in the OpenNebula (see the [Users & Groups Subsystem guide]({{% relref "../multitenancy/auth_overview#auth-overview" %}})). Dedicated external user authentication drivers can be used to leverage additional authentication mechanisms or sources of information about the users (e.g., LDAP). This chapter describes the available user authentication and management options.

## Authentication

![image0](/images/auth_options_350.png)

In this figure you can see three authentication configurations you can customize in OpenNebula.

**a) CLI/API Authentication**

You can choose from the following authentication drivers to access OpenNebula from the command line:

- [Built-in User/Password and token authentication]({{% relref "../multitenancy/manage_users#manage-users" %}})
- [SSH Authentication]({{% relref "ssh#ssh-auth" %}})
- [X.509 Authentication]({{% relref "x509#x509-auth" %}})
- [LDAP Authentication]({{% relref "ldap#ldap" %}})

**b) Sunstone Authentication**

By default, any authentication driver configured to work with OpenNebula can be used out-of-the-box with Sunstone. Additionally you can add a TLS-proxy to secure Sunstone. See:

- [Sunstone Authentication]({{% relref "sunstone_auth#sunstone-auth" %}})

**c) Server Authentication**

This method is designed to delegate the authentication process to high level tools interacting with OpenNebula. You’ll be interested in this method if you are developing your own servers.

OpenNebula ships with a GUI server - [Sunstone]({{% relref "../../operation_references/opennebula_services_configuration/fireedge#fireedge-setup" %}}). When a user interacts with one of them, the server authenticates the request and then forwards the requested operation to the OpenNebula Daemon. The forwarded requests are encrypted using a symmetric key. The following guide shows how to strengthen the security of these requests using X.509 certificates. This is especially relevant if you are running your server in a machine other than the Front-end.

- [Cloud Servers Authentication]({{% relref "../../../software/installation_process/build_from_source_code/cloud_auth#cloud-auth" %}})

## How Should I Read This Chapter

When designing the architecture of your cloud you will have to choose where to store users’ credentials. Different authentication methods can be configured at the same time and selected on a ‘per user’ basis. A major difference between various authentication methods is their ability to be used either by API, CLI and/or only Sunstone (the web interface). You can read the relevant sections based on your requirements.

Usable with API, CLI and Sunstone:

* [Built-in User/Password and token authentication]({{% relref "../multitenancy/manage_users#manage-users" %}})
* [LDAP Authentication]({{% relref "ldap#ldap" %}})

Usable only with API and CLI:

* [SSH Authentication]({{% relref "ssh#ssh-auth" %}})

Usable only with Sunstone:

* [Sunstone Authentication]({{% relref "sunstone_auth#sunstone-auth" %}})

## Hypervisor Compatibility

This chapter applies to supported hypervisors.
