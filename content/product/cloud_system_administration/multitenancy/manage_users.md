---
title: "Users"
date: "2025-02-17"
description:
categories:
pageintoc: "114"
tags:
weight: "2"
---

<a id="manage-users"></a>

<a id="manage-users-users"></a>

<!--# Managing Users -->

OpenNebula supports user accounts and groups. This guide shows how to manage users; groups are explained in [their own guide]({{% relref "manage_groups#manage-groups" %}}). To manage user rights, visit the [Managing ACL Rules]({{% relref "chmod#manage-acl" %}}) guide.

A user in OpenNebula is defined by a username and a password. You don’t need to create a new Unix account in the Front-end for each OpenNebula user, they are completely different concepts. OpenNebula users are authenticated using a session string (with `<user>:<password>` format), this is included in every operation and validated by OpenNebula service.

Each user has a unique ID and belongs at least to one group.

After the installation, you will have two administrative accounts, `oneadmin` and `serveradmin`, and two default groups, `oneadmin` and `users`. You can check it using the `oneuser list` and `onegroup list` commands.

There are different user accounts in OpenNebula, depending on the default permissions granted to them:

* **Administrators**, the `oneadmin` account is created **the first time** OpenNebula is started. `oneadmin` has enough privileges to perform any operation on any object (similar to `root` user in UNIX-like systems). Any other user added to `oneadmin` group is considered an administrator user and has the same privileges as `oneadmin`.
* **Users** accounts may access most of the functionality offered by OpenNebula to manage resources.
* **Group Administrators** are similar to users but can manage user accounts and resources in their group.
* **Service Users** are used by the OpenNebula services (e.g., Sunstone web interface, OneFlow) to proxy auth request. By default, `serveradmin` user is created the first time OpenNebula service is started. This user is only intended to be used by OpenNebula services.

{{< alert title="Note" color="success" >}}
`oneadmin` credentials are set the first time OpenNebula service is started. By default, it looks for a session string in `/var/lib/one/.one/one_auth` and defines the credentials according to it.{{< /alert >}} 

<a id="manage-users-shell"></a>

## Managing Users

User accounts within the OpenNebula system are managed by `oneadmin` with the `oneuser` command. This section will show you how to manage users in OpenNebula.

### Adding Users

A new user can be easily created by running the `oneuser create` command or by using the corresponding Sunstone dialog:

```default
$ oneuser create <user_name> <password>
ID: 3
```

{{< alert title="Warning" color="warning" >}}
When defining usernames and passwords consider the following invalid characters:

```none
username = [" ", ":", "\t", "\n", "\v", "\f", "\r"]
password = [" ", "\t", "\n", "\v", "\f", "\r"]{{< /alert >}}  
```

Some auth drivers do not require passwords (ldap); in this case a user can be created without it:

```default
$ oneuser create --driver ldap <user_name>
ID: 4
```

When a user is being created with different auth driver which does not require a password

The user types listed above are mainly defined by the group to which the user belongs. So, after creating the user, you may wish to modify the user's groups. In order to do so, `oneuser chgrp` can be used:

```default
# Make <user_name> an administrator user.
$ oneuser chgrp <user_name> oneadmin
```

### Disable User

To temporarily disable a user you can use the command `oneuser disable`. To enable a user, use `oneuser enable`. Disabled users can’t execute any action and can’t log in to Sunstone.

### Deleting Users

In order to delete a user which is no longer needed, the `oneuser delete` command can be used.

## User Authentication

### Sunstone Web interface

In order to authenticate yourself as a user by using Sunstone, you just need to provide your username and password in the login page.

### CLI & APIs

In order to authenticate with OpenNebula when using the CLI or any API binding, you need a valid password or authentication token to generate the session string.

The default driver, `core`, is a simple user-password match mechanism. To configure a user account we need to put our session string in a well known place so that it can be used when needed. By default we need to put it into `$HOME/.one/one_auth`. The session string is just a single line with the format `<username>:<password>`. For example, for user `oneadmin` and password `opennebula` the file would be:

```default
$ cat $HOME/.one/one_auth
oneadmin:opennebula
```

Once configured you will be able to access the OpenNebula API and use the CLI tools:

```default
$ oneuser show
USER 0 INFORMATION
ID              : 0
NAME            : oneadmin
GROUP           : oneadmin
PASSWORD        : c24783ba96a35464632a624d9f829136edc0175e
```

{{< alert title="Note" color="success" >}}
OpenNebula does not store the plain password but a hashed version in the database, as shown by the oneuser example above.{{< /alert >}} 

Check [this guide]({{% relref "../../operation_references/configuration_references/cli#cli-shell" %}}) to discover how you can customize shell variables.

<a id="user-tokens"></a>

### Tokens

`$HOME/.one/one_auth` is protected only with the standard filesystem permissions. To improve the system security you can use authentication tokens. In this way there is no need to store plain passwords because OpenNebula can generate or use an authentication token with a given expiration time. By default, the tokens are also stored in `$HOME/.one/one_auth`.

Furthermore, if the user belongs to multiple groups, a token can be associated to one of those groups, and when the user operates with that token they will be effectively in that group, i.e., the user will only see the resources that belong to that group, and when the user creates a resource it will be placed in that group.

#### Create a Token

Any user can create a token:

```default
$ oneuser token-create
File /var/lib/one/.one/one_auth exists, use --force to overwrite.
Authentication Token is:
testuser:b61010c8ef7a1e815ec2836ea7691e92c4d3f316
```

The command will try to write `$HOME/.one/one_auth` if it does not exist.

The expiration time of the token is by default 10h (36000 seconds). When requesting a token the option `--time <seconds>` can be used in order to define exactly when the token will expire. A value of `-1` disables the expiration time.

The token can be associated with one of the groups the user belongs to. If a user logs in with that token, the user will be effectively **only** in that group and will only be allowed to see the resources that belong to that group, as opposed to the default token, which allows access to all the resources available to the groups that the user belongs to. In order to specify a group, the option `--group <id|group>` can be used. When a group specific token is used, any newly created resource will be placed in that group.

#### List the Tokens

Tokens can be listed  by doing:

```default
$ oneuser show
[...]
TOKENS
     ID EGID  EGROUP     EXPIRATION
3ea673b 100   groupB     2016-09-03 03:58:51
c33ff10 100   groupB     expired
f836893 *1    users      forever
```

The asterisk in the `EGID` column means that the user’s primary group is 1 and that the token is not group specific.

#### Set (Enable) a Token

A token can be enabled by doing:

```default
$ oneuser token-set --token b6
export ONE_AUTH=/var/lib/one/.one/5ad20d96-964a-4e09-b550-9c29855e6457.token; export ONE_EGID=-1
$ export ONE_AUTH=/var/lib/one/.one/5ad20d96-964a-4e09-b550-9c29855e6457.token; export ONE_EGID=-1
```

#### Delete a Token

Similarly, a token can be removed by doing:

```default
$ oneuser token-delete b6
Token removed.
```

## User Templates

The `USER TEMPLATE` section can hold any arbitrary data. You can use the `oneuser update` command to open an editor and add, for instance, the following `DEPARTMENT` and `EMAIL` attributes:

```default
$ oneuser show 2
USER 2 INFORMATION
ID             : 2
NAME           : regularuser
GROUP          : 1
PASSWORD       : 5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8
AUTH_DRIVER    : core
ENABLED        : Yes

USER TEMPLATE
DEPARTMENT=IT
EMAIL=user@company.com
```

These attributes can be used later in the [Virtual Machine Contextualization]({{% relref "../../operation_references/configuration_references/template#template-context" %}}). For example, using contextualization the user’s public ssh key can be automatically installed in the VM:

```default
ssh_key = "$USER[SSH_KEY]"
```

The User template can be used to customize the access rights for the `VM_USE_OPERATIONS`, `VM_MANAGE_OPERATIONS`, and `VM_ADMIN_OPERATIONS`. For a description of these attributes see [VM Operations Permissions]({{% relref "../../operation_references/opennebula_services_configuration/oned#oned-conf-vm-operations" %}})

## Manage Your Own User

Users can see their account information and change their password.

For instance, as `regularuser` you could do the following:

```default
$ oneuser list
[UserPoolInfo] User [2] not authorized to perform action on user.

$ oneuser show
USER 2 INFORMATION
ID             : 2
NAME           : regularuser
GROUP          : 1
PASSWORD       : 5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8
AUTH_DRIVER    : core
ENABLED        : Yes

USER TEMPLATE
DEPARTMENT=IT
EMAIL=user@company.com

$ oneuser passwd 1 abcdpass
```

As you can see, any user can find out his or her ID using the `oneuser show` command without any arguments.

Regular users can retrieve their information in the Settings section of Sunstone:

![sunstone_user_settings](/images/sunstone_user_settings.png)

Finally some configuration attributes can be set to tune the behavior of Sunstone or OpenNebula for the user. For a description of these attributes please check [the group configuration guide]({{% relref "manage_groups#manage-users-primary-and-secondary-groups" %}}).

<a id="manage-users-sunstone"></a>

## Managing Users in Sunstone

All the described functionality is available graphically using [Sunstone]({{% relref "../../operation_references/opennebula_services_configuration/fireedge#fireedge-configuration" %}}):

![sunstone_user_list](/images/sunstone_user_list.png)

<a id="change-credentials"></a>

<a id="serveradmin-credentials"></a>

## Change Credentials for oneadmin or serveradmin

In order to change the `oneadmin` credentials you have to do the following in the Front-end node:

```default
# oneuser passwd 0 <PASSWORD>
# echo 'oneadmin:<PASSWORD>' > /var/lib/one/.one/one_auth
```

{{< alert title="Warning" color="warning" >}}
After changing the password, please restart the OpenNebula service.{{< /alert >}} 

In order to change `serveradmin` credentials you have to do the following in the Front-end [follow these steps]({{% relref "#serveradmin-credentials" %}}).

> ```default
>     # oneuser passwd 1 --sha256 <PASSWORD>
>     # echo 'serveradmin:PASSWORD' > /var/lib/one/.one/oneflow_auth
>     # echo 'serveradmin:PASSWORD' > /var/lib/one/.one/onegate_auth
>     # echo 'serveradmin:PASSWORD' > /var/lib/one/.one/sunstone_auth

> Restart Sunstone after changing the password.
> ```
