---
title: "OpenNebula Repositories for Community Edition"
date: "2025-02-17"
description:
categories:
pageintoc: "172"
tags:
weight: "5"
show_card: false
---

The community edition of OpenNebula offers the full functionality of the Cloud Management Platform. You can configure the community repositories as follows:

### AlmaLinux/RHEL

Some dependencies require enabling the CodeReady Linux Builder repository:

```default
crb enable
```

To add OpenNebula repository, execute the following as user `root`:

**RHEL 9, 10**

```default
cat << "EOT" > /etc/yum.repos.d/opennebula.repo
[opennebula]
name=OpenNebula Community Edition
baseurl=https://downloads.opennebula.io/repo/{{< release >}}/RedHat/$releasever/$basearch
enabled=1
gpgkey=https://downloads.opennebula.io/repo/repo2.key
gpgcheck=1
repo_gpgcheck=1
EOT
yum makecache
```

**AlmaLinux 9, 10**

```default
cat << "EOT" > /etc/yum.repos.d/opennebula.repo
[opennebula]
name=OpenNebula Community Edition
baseurl=https://downloads.opennebula.io/repo/{{< release >}}/AlmaLinux/$releasever/$basearch
enabled=1
gpgkey=https://downloads.opennebula.io/repo/repo2.key
gpgcheck=1
repo_gpgcheck=1
EOT
yum makecache
```

### Debian/Ubuntu

{{< alert title="Note" color="success" >}}
If the commands below fail, ensure you have `gnupg`, `wget` and `apt-transport-https` packages installed and retry. E.g.,{{< /alert >}}

```default
apt-get update
apt-get -y install gnupg wget apt-transport-https
```

First, add the repository signing GPG key on the Front-end by executing as user `root`:

{{< alert title="Note" color="success" >}}
If `/etc/apt/keyrings` does not exist, create it:

```default
mkdir -p /etc/apt/keyrings
```{{< /alert >}}

```default
wget -q -O- https://downloads.opennebula.io/repo/repo2.key | gpg --dearmor --yes --output /etc/apt/keyrings/opennebula.gpg
```

**Debian 12**

```default
echo "deb [signed-by=/etc/apt/keyrings/opennebula.gpg] https://downloads.opennebula.io/repo/{{< release >}}/Debian/12 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
apt-get update
```

**Debian 13**

```default
echo "deb [signed-by=/etc/apt/keyrings/opennebula.gpg] https://downloads.opennebula.io/repo/{{< release >}}/Debian/13 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
apt-get update
```

**Ubuntu 22.04**

```default
echo "deb [signed-by=/etc/apt/keyrings/opennebula.gpg] https://downloads.opennebula.io/repo/{{< release >}}/Ubuntu/22.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
apt-get update
```

**Ubuntu 24.04**

```default
echo "deb [signed-by=/etc/apt/keyrings/opennebula.gpg] https://downloads.opennebula.io/repo/{{< release >}}/Ubuntu/24.04 stable opennebula" > /etc/apt/sources.list.d/opennebula.list
apt-get update
```

### SUSE

#### SUSE Linux Enterprise Server 15 SP7

Execute the following as user `root`:

```default
arch=$(uname -m)

SUSEConnect -p PackageHub/15.7/$arch
SUSEConnect -p sle-module-public-cloud/15.7/$arch
SUSEConnect -p sle-module-desktop-applications/15.7/$arch

zypper ar -f https://downloads.opennebula.io/repo/{{< release >}}/SLES/15/$arch opennebula

zypper refresh
```

#### openSUSE Leap 16.0

openSUSE Leap 16.0 requires the OpenNebula repository and the openSUSE Science repository for SciPy. Execute the following as user `root`:

```default
arch=$(uname -m)

zypper ar -f https://downloads.opennebula.io/repo/{{< release >}}/openSUSE/16/$arch opennebula
zypper ar -f https://download.opensuse.org/repositories/science/openSUSE_Leap_16.0/ science
zypper refresh
```
