---
title: "Command Line Interface Configuration"
linkTitle: "Configuration"
date: "2025-02-17"
description:
categories:
toc: true
pageintoc: "152"
tags:
weight: "3"
---

<a id="cli-configuration"></a>

<!--# Command Line Interface Configuration -->

There are necessary environment variables and command-line arguments for OpenNebula users to authenticate and communicate with the core services, ensuring proper function of the one* CLI tools. You will also find about the use of command-line parameters (--user, --password, --endpoint) as an alternative to environment variables and notes configuration for OneFlow and OneGate services.

<a id="cli-shell"></a>

# Shell Environment

OpenNebula users should have the following environment variables set, you may want to place them in the `.bashrc` of the user’s Unix account for convenience:

* **ONE_XMLRPC**: URL where the OpenNebula Daemon is listening. If it is not set, CLI tools will use the default: `http://localhost:2633/RPC2`. See the `PORT` attribute in the [Daemon configuration file]({{% relref "../opennebula_services_configuration/oned#oned-conf" %}}) for more information.
* **ONE_XMLRPC_TIMEOUT**: number of seconds to wait before a xmlrpc request times out.
* **ONE_ZMQ**: URL to subscribe to receive ZMQ messages. If it is not set, CLI tools will use the default: `tcp://localhost:2101`.
* **ONE_AUTH**: needs to point to **a file containing a valid authentication key**, it can be:
  > * A password file with just a single line stating `username:password`.
  > * A token file with just a single line with `username:token`, where token is a valid token created with the `oneuser login` command or API call.

If `ONE_AUTH` is not defined, `$HOME/.one/one_auth` will be used instead. If no auth file is present, OpenNebula cannot work properly, as this is needed by the core, the CLI, and the cloud components as well.

* **ONE_POOL_PAGE_SIZE**: by default the OpenNebula Cloud API (CLI and Sunstone make use of it) paginates some pool responses. By default this size is 300 but it can be changed with this variable. A numeric value greater than 2 is the pool size. To disable it you can use a non-numeric value.

```default
$ export ONE_POOL_PAGE_SIZE=5000        # Sets the page size to 5000
$ export ONE_POOL_PAGE_SIZE=disabled    # Disables pool pagination
```

* **ONE_PAGER**: list commands will send their output through a pager process when in an interactive shell. By default, the pager process is set to `less` but it can be change to any other program. The pagination can be disabled using the argument `--no-pager`. It sets the `ONE_PAGER` variable to `cat`.
* **ONE_LISTCONF**: allows the user to use an alternate layout to displays lists.

```default
$ onevm list
    ID USER     GROUP    NAME            STAT UCPU    UMEM HOST             TIME
    20 oneadmin oneadmin tty-20          fail    0      0K localhost    0d 00h32
    21 oneadmin oneadmin tty-21          fail    0      0K localhost    0d 00h23
    22 oneadmin oneadmin tty-22          runn  0.0  104.7M localhost    0d 00h22

$ export ONE_LISTCONF=user
$ onevm list
    ID NAME            IP              STAT UCPU    UMEM HOST             TIME
    20 tty-20          10.3.4.20       fail    0      0K localhost    0d 00h32
    21 tty-21          10.3.4.21       fail    0      0K localhost    0d 00h23
    22 tty-22          10.3.4.22       runn  0.0  104.7M localhost    0d 00h23
```

* **ONE_CERT_DIR** and **ONE_DISABLE_SSL_VERIFY**: if OpenNebula XML-RPC endpoint is behind an SSL proxy you can specify an extra trusted certificates directory using `ONE_CERT_DIR`. Make sure that the certificate is named `<hash>.0`. You can get the hash of a certificate with this command:

```default
$ openssl x509 -in <certificate.pem> -hash
```

Alternatively you can set the environment variable `ONE_DISABLE_SSL_VERIFY` to any value to disable certificate validation. You should only use this parameter for testing as it makes the connection insecure.

For instance, a user named `regularuser` may have the following environment:

```default
$ tail ~/.bashrc

ONE_XMLRPC=http://localhost:2633/RPC2

export ONE_XMLRPC

$ cat ~/.one/one_auth
regularuser:password
```

{{< alert title="Note" color="success" >}}
Please note that the example above is intended for a user interacting with OpenNebula from the Front-end, but you can use it from any other computer. Just set the appropriate hostname and port in the `ONE_XMLRPC` variable.{{< /alert >}} 

{{< alert title="Note" color="success" >}}
If you do not want passwords to be stored in plain files, protected with basic filesystem permissions, please refer to the token-based authentication mechanism described below.{{< /alert >}} 

An alternative method to specify credentials and OpenNebula endpoint is using command line parameters. Most of the commands can understand the following parameters:

| `--user name`         | User name used to connect to OpenNebula   |
|-----------------------|-------------------------------------------|
| `--password password` | Password to authenticate with OpenNebula  |
| `--endpoint endpoint` | URL of OpenNebula XML-RPC Front-end       |

If `user` is specified but not `password` the user will be prompted for the password. `endpoint` has the same meaning and gets the same value as `ONE_XMLRPC`. For example:

```default
$ onevm list --user my_user --endpoint http://one.frontend.com:2633/RPC2
Password:
[...]
```

{{< alert title="Warning" color="warning" >}}
You shouldn't use `--password` parameter in a shared machine. Process parameters can be seen by any user with the command `ps` so it is highly insecure.{{< /alert >}} 

* **ONE_SUNSTONE**: URL of the Sunstone portal, used for downloading Marketplace Apps streamed through Sunstone. If this is not specified, it will be inferred from `ONE_XMLRPC` (by changing the port to 9869), and if that ENV variable is undefined as well, it will default to `http://localhost:9869`.
* **ONEFLOW_URL**, **ONEFLOW_USER** and **ONEFLOW_PASSWORD**: these variables are used by the [OneFlow]({{% relref "../../virtual_machines_operation/multi-vm_workflows/overview#oneflow-overview" %}}) command line tools. If not set, the default OneFlow URL will be `http://localhost:2474`. The user and password will be taken from the `ONE_AUTH` file if the environment variables are not found.

<a id="cli-views"></a>

# CLI views

You can customize how certain commands are displayed by default. Each command has a yaml file associated to it, located at `/etc/one/cli/`

```default
root@supermicro9:~# tree /etc/one/cli/
/etc/one/cli/
├── oneacct.yaml
├── oneacl.yaml
├── onecluster.yaml
├── onedatastore.yaml
├── oneflowtemplate.yaml
├── oneflow.yaml
├── onegroup.yaml
├── onehook.yaml
├── onehost.yaml
├── oneimage.yaml
├── onemarketapp.yaml
├── onemarket.yaml
├── oneprovider.yaml
├── onesecgroup.yaml
├── oneshowback.yaml
├── onetemplate.yaml
├── oneuser.yaml
├── onevdc.yaml
├── onevmgroup.yaml
├── onevm.yaml
├── onevnet.yaml
├── onevntemplate.yaml
├── onevrouter.yaml
└── onezone.yaml
```

For example, in the case of `onevm list`, by default it looks like this:

```default
root@supermicro9:~# onevm list
  ID USER     GROUP    NAME                                                                        STAT  CPU     MEM HOST                                                     TIME
9234 oneadmin oneadmin alma8-alma8-6-7-80-e3f1f4b2-6a26f4bd-1825.build                             unde  0.5      8G                                                      0d 05h57
9233 nhansen  users    alma8-kvm-local-6-6-pkofu-2.test                                            runn  0.5    1.3G localhost                                            0d 07h04
9232 nhansen  users    alma8-kvm-local-6-6-pkofu-1.test                                            runn  0.5    1.3G localhost                                            0d 07h04
9231 nhansen  users    alma8-kvm-local-6-6-pkofu-0.test                                            runn  0.5    1.8G localhost                                            0d 07h04
```

But you can change the default columns, increase the column width and disable expansion to make it look like this:

```default
 ~  onevm list
  ID NAME                             STAT IP
9188 minione-9188                     runn 172.20.0.65
9184 ubuntu2204-func-6-7-1lbob-0.test unde 172.20.0.61,192.168.150.1
9183 ubuntu2204-func-6-7-xjz0p-0.test unde 172.20.0.59,192.168.150.1
9182 ubuntu2204-func-6-7-q1okq-0.test unde 172.20.0.55,192.168.150.1
8705 bots                             poff 172.20.0.20
6460 tmux                             poff 172.20.0.5
5947 market-builder-5947              poff 172.20.0.26
```



## Shell Environment for Self-Contained Installations

If OpenNebula was installed from sources in **self-contained mode** (this is not the default, and not recommended), these two variables must be also set. These are not needed if you installed from packages, or performed a system-wide installation from sources.

* **ONE_LOCATION**: it must point to the installation `<destination_folder>`.
* **PATH**: the OpenNebula bin files must be added to the path:

```default
$ export PATH=$ONE_LOCATION/bin:$PATH
```
