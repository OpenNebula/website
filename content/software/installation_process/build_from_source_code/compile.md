---
title: "Building from Source Code"
linkTitle: "Building"
date: "2025-02-17"
description:
categories:
pageintoc: "305"
tags:
weight: "2"
---

<a id="compile"></a>

<!--# Building from Source Code -->

This page will show you how to compile and install OpenNebula from the sources.

{{< alert title="Warning" color="warning" >}}
Do not forget to check the [Building Dependencies]({{% relref "build_deps#build-deps" %}}) for a list of specific software requirements to build OpenNebula.{{< /alert >}}

{{< alert title="Note" color="success" >}}
If you need to build customized OpenNebula packages you can find the source packages for publicly released versions available in the download repositories for easy rebuilds and customizations. If you need to access the packaging tools, please get in touch at <[community-manager@opennebula.io](mailto:community-manager@opennebula.io)>.{{< /alert >}}

## Compiling the Software

Follow these simple steps to install the OpenNebula software:

- Download and untar the OpenNebula tarball
- Change to the created folder and run scons to compile OpenNebula

```default
$ scons [OPTION=VALUE]
```

{{< alert title="Note" color="success" >}}
`scons` can parallelize the build with the `-j NUM_THREADS` parameter. For instance, to compile with 4 parallel processes execute:

```default
$ scons -j 4 [OPTION=VALUE]
```{{< /alert >}}

The argument expression [OPTION=VALUE] is used to set non-default values for :

| OPTION     | Default   | VALUE                                                     |
|------------|-----------|-----------------------------------------------------------|
| sqlite_dir |           | path-to-sqlite-install                                    |
| sqlite     | yes       | **no** if you don’t want to build Sqlite support          |
| mysql      | no        | **yes** if you want to build MySQL support                |
| parsers    | no        | **yes** if you want to rebuild Flex/Bison files.          |
| fireedge   | no        | **yes** if you want to build FireEdge minified files      |
| systemd    | no        | **yes** if you want to build systemd support              |
| rubygems   | no        | **yes** if you want to generate Ruby gems                 |
| svncterm   | yes       | **no** to skip building VNC support for LXD drivers       |
| context    | no        | **yes** to download guest contextualization packages      |
| strict     | no        | Strict C++ compiler, more warnings, treat warnings as errors |
| download   | no        | **yes** to download 3rd-party tools (Restic, Prometheus…) |
| grpc       | yes       | **yes** to build gRPC support                             |
| grpcproto  | no        | **yes** to generate C++ sources from .proto files         |
| xmlrpc_pkgconf | no    | **yes** to use pkg-config to discover xmlrpc libs dependencies, otherwise xmlrpc-c-config is used. Needed for Alma9 and RHEL9 |

- OpenNebula can be installed in two modes: `system-wide` or in `self-contained` directory. In either case, you do not need to run OpenNebula as root. These options can be specified when running the install script:

```default
./install.sh <install_options>
```

{{< alert title="Note" color="success" >}}
To install OpenNebula with the `system-wide` mode you should have super user privileges.{{< /alert >}}

{{< alert title="Warning" color="warning" >}}
The `scons` option `xmlrpc_pkgconf=yes` is mandatory for AlmaLinux 9. Otherwise the build fails.{{< /alert >}}


```default
$ sudo ./install.sh <install_options>
```

where  *<install_options>* can be one or more of:

| OPTION   | VALUE                                                                                                                                                                        |
|----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **-u**   | user that will run OpenNebula, defaults to user executing install.sh                                                                                                         |
| **-g**   | group of the user that will run OpenNebula, defaults to user executing install.sh                                                                                            |
| **-k**   | keep configuration files of existing OpenNebula installation, useful when upgrading. This flag should not be set when installing OpenNebula for the first time               |
| **-d**   | target installation directory. If defined, it will specified the path for the **self-contained** install. If not defined, the installation will be performed **system wide** |
| **-c**   | only install client utilities: OpenNebula cli and ec2 client files                                                                                                           |
| **-F**   | install only OpenNebula FireEdge                                                                                                                                             |
| **-P**   | do not install OpenNebula FireEdge non-minified files                                                                                                                        |
| **-G**   | install only OpenNebula Gate                                                                                                                                                 |
| **-f**   | install only OpenNebula Flow                                                                                                                                                 |
| **-r**   | remove Opennebula, only useful if -d was not specified, otherwise `rm -rf $ONE_LOCATION` would do the job                                                                    |
| **-l**   | creates symlinks instead of copying files, useful for development                                                                                                            |
| **-a**   | architecture of downloaded vendor artifacts, default: x86_64"                                                                                                                |
| **-h**   | prints installer help                                                                                                                                                        |

{{< alert title="Note" color="success" >}}
If you choose the `system-wide` installation, OpenNebula will be installed in the following folders:
: - /etc/one
  - /usr/lib/one
  - /usr/share/doc/one
  - /usr/share/one
  - /var/lib/one
  - /var/lock/one
  - /var/log/one
  - /var/run/one

By using `./install.sh -r`, dynamically generated files will not be removed.{{< /alert >}}

The packages do a `system-wide` installation. To create a similar environment, create a `oneadmin` user and group, and execute:

```default
oneadmin@frontend:~/ $> wget <opennebula tar gz>
oneadmin@frontend:~/ $> tar xzf <opennebula tar gz>
oneadmin@frontend:~/ $> cd opennebula-x.y.z
oneadmin@frontend:~/opennebula-x.y.z/ $> scons -j2 mysql=yes syslog=yes fireedge=yes
[ lots of compiling information ]
scons: done building targets.
oneadmin@frontend:~/opennebula-x.y.z $> sudo ./install.sh -u oneadmin -g oneadmin
```

## Ruby Dependencies

All required Ruby gems are provided by the **opennebula-rubygems** package. Please check the [Installation guide]({{% relref "front_end_installation" %}}) for more information on installing this package.

## Building Python Bindings from Source

In order to build the OpenNebula python components it is required to install pip package manager and the following pip packages:

Build Dependencies:

- **generateds**: to generate the python OCA
- **setuptools**: to generate python package
- **wheel**: to generate the python package

Run Dependencies:

- **dict2xml**: python OCA support
- **lxml**: python OCA support
- **xml2dict**: python OCA support
- **requests**: python OCA support

To build run following:

```default
root@frontend:~/ $> cd src/oca/python
root@frontend:~/ $> make
root@frontend:~/ $> make dist
root@frontend:~/ $> make install
```

## Building Sunstone from Source

```default
root@frontend:~/ $> cd ~/one/src/fireedge
root@frontend:~/ $> npm install
root@frontend:~/ $> cd ~/one
root@frontend:~/ $> scons fireedge=yes
root@frontend:~/ $> ./install.sh -F -u oneadmin -g oneadmin
```
