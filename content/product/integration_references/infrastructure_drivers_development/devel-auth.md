---
title: "Authentication Driver"
date: "2025-02-17"
description:
categories:
pageintoc: "296"
tags:
weight: "6"
---

<a id="devel-auth"></a>

<!--# Authentication Driver -->

This guide will show you how to develop a new driver for OpenNebula to interact with an external authentication service.

OpenNebula comes with an internal user/password way of authentication, this is called `core`. To be able to use other auth methods there is a system that performs authentication with external systems. Authentication drivers are responsible for getting the user credentials from the OpenNebula database and they login and answer whether the authentication is correct or not.

In the OpenNebula database there are two values saved for every user, these are `username` and `password`. When the driver used for authentication is core (authenticated without an external auth driver) the password value holds the SHA256 hash of the user’s password. In case we are using another authentication method this `password` field can contain any other information we can use to recognize a user, for example, for x509 authentication this field contains the user’s public key.

## Authentication Driver

Authentication drivers are located at `/var/lib/one/remotes/auth`. There is a directory for each authentication driver with an executable inside called `authenticate`. The name of the directory has to be the same as the user’s auth driver we want to authenticate. For example, if a user has as an auth driver `x509` OpenNebula will execute the file `/var/lib/one/remotes/auth/x509/authenticate` when the user performs an OpenNebula action.

The authentication driver expects parameters passed on the standard input as the XML document with the following structure:

```xml
<AUTHN>
    <USERNAME>VALUE</USERNAME>
    <PASSWORD>VALUE</PASSWORD>
    <SECRET>VALUE</SECRET>
</AUTHN>
```

In this example:

- `USERNAME`: name of the user who wants to authenticate.
- `PASSWORD`: value of the password field for the user that is trying to authenticate. This can be `-` when the user does not exist in the OpenNebula database.
- `SECRET`: value provided in the password field of the authentication string.

{{< alert title="Warning" color="warning" >}}
Before OpenNebula 5.6, the parameters were passed as command line parameters. Now all the data is passed using only the standard input!{{< /alert >}} 

For example, we can create a new authentication method that just checks the length of the password. For this we can store in the password field the number of characters accepted, for example 5, and user name test. Here are some example calls to the driver with several passwords:

```default
echo '<AUTHN><USERNAME>test</USERNAME><PASSWORD>5</PASSWORD><SECRET>testpassword</SECRET></AUTHN>' | \
    authenticate

echo '<AUTHN><USERNAME>test</USERNAME><PASSWORD>5</PASSWORD><SECRET>another_try</SECRET></AUTHN>' | \
    authenticate

echo '<AUTHN><USERNAME>test</USERNAME><PASSWORD>5</PASSWORD><SECRET>12345</SECRET></AUTHN>' | \
    authenticate
```

The script should exit with a non 0 status when the authentication is not correct and write in `stderr` the error. When the authentication is correct it should return:

- Name of the driver. This is used when the user does not exist, this will be written to the user’s the auth driver field.
- User name.
- Text to write in the user’s password field in case the user does not exist.

The code for the `/var/lib/one/remotes/auth/length/authenticate` executable can be:

```default
#!/bin/bash

data=$(cat -)

username=$(echo "${data}" | xmllint --xpath '//AUTHN/USERNAME/text()' -)
password=$(echo "${data}" | xmllint --xpath '//AUTHN/PASSWORD/text()' -)
secret=$(echo "${data}" | xmllint --xpath '//AUTHN/SECRET/text()' -)

length=$(echo -n "$secret" | wc -c | tr -d ' ')

if [ $length = $password ]; then
    echo "length $username $secret"
else
    echo "Invalid password"
    exit 255
fi
```

## Enabling the Driver

To be able to use the new driver we need to add its name to the list of enabled drivers in `oned.conf`:

```default
AUTH_MAD = [
    executable = "one_auth_mad",
    authn = "ssh,x509,ldap,server_cipher,server_x509,length"
]
```

## Managed Groups

The authentication driver may also assign users to groups, this requires the `DRIVER_MANAGED_GROUPS` option to be set to `YES`, e.g., like for the `ldap` driver

```default
AUTH_MAD_CONF = [
    NAME = "ldap",
    PASSWORD_CHANGE = "YES",
    DRIVER_MANAGED_GROUPS = "YES",
    DRIVER_MANAGED_GROUP_ADMIN = "YES",
    MAX_TOKEN_TIME = "86400"
]
```

The driver then needs to pass the space-separated group ids right after the username and the secret.

The driver response then looks like the following line:

```default
ldap userx CN=userx,CN=Users,DC=opennebula,DC=org *100 101
```

Optionally, the group id might be marked by a preceding asterix char \*. In that case, the user will be assigned to the group as an admin. See [group admins]({{% relref "../../../product/cloud_system_administration/multitenancy/manage_groups#manage-groups-permissions" %}}) for details.
