---
title: "SSH Authentication"
date: "2025-02-17"
description:
categories:
pageintoc: "123"
tags:
weight: "2"
---

<a id="ssh-auth"></a>

<!--# SSH Authentication -->

This guide will show you how to enable and use the SSH authentication with the OpenNebula CLI with authentication driver `ssh`. Using this method, users log in to the OpenNebula with a token encrypted with their private SSH keys.

## Requirements

No additional installation required.

## Considerations & Limitations

This authentication method works only for interaction with OpenNebula **over CLI**.

## Configuration

This authentication mechanism is enabled by default. If it doesn’t work, make sure you have the authentication method `ssh` enabled in the `AUTH_MAD` section of your [/etc/one/oned.conf]({{% relref "../../operation_references/opennebula_services_configuration/oned#oned-conf" %}}). For example:

```default
AUTH_MAD = [
    EXECUTABLE = "one_auth_mad",
    AUTHN = "ssh,x509,ldap,server_cipher,server_x509"
]
```

## Usage

### Create New Users

This authentication method uses standard SSH RSA key pairs for authentication. Users can create these files (if they don’t exist) using this command:

```default
$ ssh-keygen -t rsa
```

OpenNebula commands look for the generated SSH keys in the standard location `$HOME/.ssh/id_rsa`, so it is a good idea not to change the default path. It’s recommended to protect the private key with a password!

Users requesting a new account have to get a **public key** by running `oneuser key`. For example:

```default
$ oneuser key
Enter PEM pass phrase:
MIIBCAKCAQEApUO+JISjSf02rFVtDr1yar/34EoUoVETx0n+RqWNav+5wi+gHiPp3e03AfEkXzjDYi8F
voS4a4456f1OUQlQddfyPECn59OeX8Zu4DH3gp1VUuDeeE8WJWyAzdK5hg6F+RdyP1pT26mnyunZB8Xd
bll8seoIAQiOS6tlVfA8FrtwLGmdEETfttS9ukyGxw5vdTplse/fcam+r9AXBR06zjc77x+DbRFbXcgI
1XIdpVrjCFL0fdN53L0aU7kTE9VNEXRxK8sPv1Nfx+FQWpX/HtH8ICs5WREsZGmXPAO/IkrSpMVg5taS
jie9JAQOMesjFIwgTWBUh6cNXuYsQ/5wIwIBIw==
```

The string written to the console must be sent to the cloud administrator so they can create the new user in a similar way to the default user/password authentication users.

The following example command creates new user with username `johndoe`, assuming that the previous **public key** is saved in the text file `/tmp/pub_key` (instead of using the `--read-file` option, the public key could be specified as the second parameter):

```default
$ oneuser create johndoe --ssh --read-file /tmp/pub_key
```

If the administrator has access to the user’s **private ssh key**, they can create new users with the following command:

```default
$ oneuser create johndoe --ssh --key /home/newuser/.ssh/id_rsa
```

### Update Existing Users to SSH

Change the authentication method of an existing user to SSH with the following commands:

```default
$ oneuser chauth <id|name> ssh
$ oneuser passwd <id|name> --ssh --read-file /tmp/pub_key
```

As with the `create` command, you can specify the public key as the second parameter or use the user’s private key with the `--key` option.

### User Login

Before using the OpenNebula CLI, users must execute the `oneuser login` command to generate a login token. The token will be stored in the filename set by `$ONE_AUTH` environment variable (which defaults to `$HOME/.one/one_auth`). The command requires the OpenNebula username and the argument `--ssh` specifying the authentication method.  For example:

```default
$ oneuser login johndoe --ssh
```

The default SSH key is assumed to be in `$HOME/.ssh/id_rsa`, otherwise the path can be specified with the `--key` option.

The generated token has a default **expiration time** of 10 hours. You can change that with the `--time` option.
