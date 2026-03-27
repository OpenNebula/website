---
title: "OpenNebula Repositories for Enterprise Edition"
date: "2025-02-17"
description:
categories:
pageintoc: "172"
tags:
weight: "4"
show_card: false
---

OpenNebula Systems provides an OpenNebula Enterprise Edition to customers with an active support subscription. To distribute the packages of the Enterprise Edition there is a private enterprise repository accessible only to those customers that contains all packages (including major, minor, and maintenance releases). You only need to change your repository configuration on Front-end once per major release and you’ll be able to get every package in that series. Private repositories contain all OpenNebula released packages.

{{< alert title="Important" color="success" >}}
You should have received the customer repository credentials (username and password) to access these repositories. Replace `<user>` and `<password>` in the examples below with your customer-specific credentials.{{< /alert >}}

### AlmaLinux/RHEL

Some dependencies require enabling the CodeReady Linux Builder repository:

```default
crb enable
```

To add the OpenNebula enterprise repository, execute the following as user `root`:

**RHEL 9, 10**

```default
cat << "EOT" > /etc/yum.repos.d/opennebula.repo
[opennebula]
name=OpenNebula Enterprise Edition
baseurl=https://enterprise.opennebula.io/repo/{{< release >}}/RedHat/$releasever/$basearch
username=<user>
password=<password>
enabled=1
gpgkey=https://downloads.opennebula.io/repo/repo2.key
gpgcheck=1
repo_gpgcheck=1
EOT
chmod 600 /etc/yum.repos.d/opennebula.repo
dnf makecache
```

**AlmaLinux 9, 10**

```default
cat << "EOT" > /etc/yum.repos.d/opennebula.repo
[opennebula]
name=OpenNebula Enterprise Edition
baseurl=https://enterprise.opennebula.io/repo/{{< release >}}/AlmaLinux/$releasever/$basearch
username=<user>
password=<password>
enabled=1
gpgkey=https://downloads.opennebula.io/repo/repo2.key
gpgcheck=1
repo_gpgcheck=1
EOT
chmod 600 /etc/yum.repos.d/opennebula.repo
dnf makecache
```

### Debian/Ubuntu

{{< alert title="Note" color="success" >}}
If the commands below fail, ensure you have `gnupg`, `wget` and `apt-transport-https` packages installed and retry. E.g.,

```default
apt-get update
apt-get -y install gnupg wget apt-transport-https
```{{< /alert >}}

First, add the repository signing GPG key on the Front-end by executing as user `root`:

{{< alert title="Note" color="success" >}}
If `/etc/apt/keyrings` does not exist, create it:

```default
mkdir -p /etc/apt/keyrings
```{{< /alert >}}

```default
wget -q -O- https://downloads.opennebula.io/repo/repo2.key | gpg --dearmor --yes --output /etc/apt/keyrings/opennebula.gpg
```

and then continue with repository configuration:

**Debian 12**

```default
cat << "EOT" > /etc/apt/auth.conf.d/opennebula.conf
machine enterprise.opennebula.io
login <user>
password <password>
EOT
chmod 600 /etc/apt/auth.conf.d/opennebula.conf
echo "deb [signed-by=/etc/apt/keyrings/opennebula.gpg] https://enterprise.opennebula.io/repo/{{< release >}}/Debian/12 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
apt-get update
```

**Debian 13**

```default
cat << "EOT" > /etc/apt/auth.conf.d/opennebula.conf
machine enterprise.opennebula.io
login <user>
password <password>
EOT
chmod 600 /etc/apt/auth.conf.d/opennebula.conf
echo "deb [signed-by=/etc/apt/keyrings/opennebula.gpg] https://enterprise.opennebula.io/repo/{{< release >}}/Debian/13 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
apt-get update
```

**Ubuntu 22.04**

```default
cat << "EOT" > /etc/apt/auth.conf.d/opennebula.conf
machine enterprise.opennebula.io
login <user>
password <password>
EOT
chmod 600 /etc/apt/auth.conf.d/opennebula.conf
echo "deb [signed-by=/etc/apt/keyrings/opennebula.gpg] https://enterprise.opennebula.io/repo/{{< release >}}/Ubuntu/22.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
apt-get update
```

**Ubuntu 24.04**

```default
cat << "EOT" > /etc/apt/auth.conf.d/opennebula.conf
machine enterprise.opennebula.io
login <user>
password <password>
EOT
chmod 600 /etc/apt/auth.conf.d/opennebula.conf
echo "deb [signed-by=/etc/apt/keyrings/opennebula.gpg] https://enterprise.opennebula.io/repo/{{< release >}}/Ubuntu/24.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
apt-get update
```

### SUSE

#### SUSE Linux Enterprise Server 15 SP7

Execute the following as user `root`:

```default
arch=$(uname -m)

SUSEConnect -p PackageHub/15.7/$arch
SUSEConnect -p sle-module-desktop-applications/15.7/$arch
SUSEConnect -p sle-module-public-cloud/15.7/$arch

mkdir -p /etc/zypp/credentials.d
cat << "EOT" > /etc/zypp/credentials.d/opennebula.conf
username=<user>
password=<password>
EOT
chmod 600 /etc/zypp/credentials.d/opennebula.conf

zypper ar -f 'https://enterprise.opennebula.io/repo/{{< release >}}/SLES/15/'"$arch"'?credentials=opennebula.conf' opennebula

zypper refresh
```

#### openSUSE Leap 16.0

openSUSE Leap 16.0 requires the OpenNebula repository and the openSUSE Science repository for SciPy. Execute the following as user `root`:

```default
arch=$(uname -m)

mkdir -p /etc/zypp/credentials.d
cat << "EOT" > /etc/zypp/credentials.d/opennebula.conf
username=<user>
password=<password>
EOT
chmod 600 /etc/zypp/credentials.d/opennebula.conf

zypper ar -f 'https://enterprise.opennebula.io/repo/{{< release >}}/openSUSE/16/'"$arch"'?credentials=opennebula.conf' opennebula
zypper ar -f https://download.opensuse.org/repositories/science/openSUSE_Leap_16.0/ science
zypper refresh
```

{{< alert title="Note" color="success" >}}
You can point to a specific 7.2.x version by changing the occurrence of shorter version 7.2 in any of the above commands to the particular full 3 components version number (X.Y.Z). For instance, to point to version 7.2.1 on Ubuntu 22.04, use the following command:{{< /alert >}}

> ```default
> cat << "EOT" > /etc/apt/auth.conf.d/opennebula.conf
> machine enterprise.opennebula.io
> login <user>
> password <password>
> EOT
> chmod 600 /etc/apt/auth.conf.d/opennebula.conf
> echo "deb [signed-by=/etc/apt/keyrings/opennebula.gpg] https://enterprise.opennebula.io/repo/7.2.1/Ubuntu/22.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
> apt-get update
> ```
