---
title: "Build Dependencies"
date: "2025-02-17"
description:
categories:
pageintoc: "306"
tags:
weight: "3"
---

<a id="build-deps"></a>

<!--# Build Dependencies -->

This page lists the **build** dependencies for OpenNebula.

* **g++** compiler (>= 5.0)
* **xmlrpc-c** development libraries (>= 1.06)
* **scons** build tool (>= 0.98)
* **sqlite3** development libraries (if compiling with sqlite support) (>= 3.6)
* **mysql** client development libraries (if compiling with mysql support) (>= 5.1, >= 5.6 is recommended for pool search)
* **libxml2** development libraries (>= 2.7)
* **libvncserver** development libraries (>= 0.9)
* **openssl** development libraries (>= 0.9.8)
* **ruby** interpreter (>= 2.0.0)

## Ubuntu 22.04, 24.04

* **bash-completion**
* **libcurl4-openssl-dev**
* **libmysqlclient-dev**
* **libnode-dev (>= 10)**
* **libnsl-dev**
* **libsqlite3-dev**
* **libssl-dev**
* **libsystemd-dev**
* **libvncserver-dev**
* **libxml2-dev**
* **libxmlrpc-c++8-dev**
* **nodejs (>= 10)**
* **npm**
* **python3**
* **python3-pip**
* **python3-setuptools**
* **rake**
* **scons**
* **unzip**
* **protobuf-compiler-grpc**
* **libgrpc++-dev**
* **libabsl-dev**
* ruby gem **grpc-tools**

For Ubuntu 22.04 is recommended a updated version of Node.js:

```shell
apt -y remove nodejs libnode-dev || true
apt -y autoremove
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
```

Install all requirements using:

```shell
apt install bash-completion libcurl4-openssl-dev libmysqlclient-dev \
    libnode-dev libnsl-dev libsqlite3-dev libssl-dev libsystemd-dev \
    libvncserver-dev libxml2-dev libxmlrpc-c++8-dev nodejs npm \
    python3 python3-pip python3-setuptools rake scons unzip \
    protobuf-compiler-grpc libgrpc++-dev libabsl-dev
gem install grpc-tools
```

## Debian 12, 13

* **bash-completion**
* **bower**
* **default-libmysqlclient-dev**
* **libcurl4-openssl-dev**
* **libnode-dev (>= 10)**
* **libnsl-dev**
* **libsqlite3-dev**
* **libssl-dev**
* **libsystemd-dev**
* **libvncserver-dev**
* **libxml2-dev**
* **libxmlrpc-c++8-dev** -> Debian 12,
* **libxmlrpc-c++9-dev** -> Debian 13
* **nodejs (>= 10)**
* **npm**
* **python3**
* **python3-pip**
* **python3-setuptools**
* **rake**
* **scons**
* **unzip**
* **protobuf-compiler-grpc**
* **libgrpc++-dev**
* **libabsl-dev**
* ruby gem **grpc-tools**

Install all requirements using:

```shell
# Debian 12
apt install bash-completion default-libmysqlclient-dev libcurl4-openssl-dev \
    libnode-dev libnsl-dev libsqlite3-dev libssl-dev libsystemd-dev \
    libvncserver-dev libxml2-dev libxmlrpc-c++8-dev nodejs npm \
    python3 python3-pip python3-setuptools rake scons unzip \
    protobuf-compiler-grpc libgrpc++-dev libabsl-dev
gem install grpc-tools
```

```shell
# Debian 13
apt install bash-completion default-libmysqlclient-dev libcurl4-openssl-dev \
    libnode-dev libnsl-dev libsqlite3-dev libssl-dev libsystemd-dev \
    libvncserver-dev libxml2-dev libxmlrpc-c++9-dev nodejs npm \
    python3 python3-pip python3-setuptools rake scons unzip \
    protobuf-compiler-grpc libgrpc++-dev libabsl-dev
gem install grpc-tools
```

## AlmaLinux/RHEL 9, 10

* **gcc-c++**
* **gnutls-devel**
* **libcurl-devel**
* **libjpeg-turbo-devel**
* **libnsl2-devel**
* **libvncserver-devel**
* **libxml2-devel**
* **mariadb-devel**
* **nodejs >= 10**
* **npm**
* **openssh**
* **openssl-devel**
* **pkgconfig**
* **python3**
* **python3-scons**
* **python3-setuptools**
* **rubygems**
* **sqlite-devel**
* **systemd**
* **systemd-devel**
* **xmlrpc-c-devel**
* **grpc-devel**
* ruby gem **grpc-tools**

Install all requirements using:

```shell
dnf config-manager --set-enabled crb
dnf install gcc-c++ gnutls-devel libcurl-devel libjpeg-turbo-devel \
    libnsl2-devel libvncserver-devel libxml2-devel mariadb-devel nodejs npm \
    openssh openssl-devel pkgconfig python3 python3-scons python3-setuptools \
    rubygems sqlite-devel systemd systemd-devel xmlrpc-c-devel grpc-devel
gem install grpc-tools
```

## Arch

They are listed in this [PKGBUILD](https://aur.archlinux.org/packages/opennebula/).
