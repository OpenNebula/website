---
title: "Image Template"
date: "2025-02-17"
description:
categories:
pageintoc: "150"
tags:
weight: "2"
---

<a id="img-template"></a>

<!--# Image Template -->

This page describes how to define a new image template. An image template follows the same syntax as the [VM template]({{% relref "template#template" %}}).

{{< alert title="Warning" color="warning" >}}
Some template attributes can compromise the security of the system or the security of other VMs, and can be used **only** by users in the `oneadmin` group. These attributes can be configured in [oned.conf]({{% relref "../opennebula_services_configuration/oned#oned-conf" %}}). In the following tables, default attributes are marked with `*`. For the complete list, see the [Restricted Attributes]({{% relref "#img-template-restricted-attributes" %}}) section.{{< /alert >}} 

## Template Attributes

The following attributes can be defined in the template:

| Attribute                                       | KVM                                    | Value                                                                                                                                                                                     | Description                                                                                                                                                                                                                                                                                                                                                                                                                                       |
|-------------------------------------------------|----------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `NAME`                                          | Mandatory                              | Any string                                                                                                                                                                                | Name that the Image will get. Every image must have a unique name.                                                                                                                                                                                                                                                                                                                                                                                |
| `DESCRIPTION`                                   | Optional                               | Any string                                                                                                                                                                                | Human readable description of the image for other users.                                                                                                                                                                                                                                                                                                                                                                                          |
| `TYPE`                                          | Optional                               | `OS`, `CDROM`, `DATABLOCK` for VM disks; `KERNEL`, `RAMDISK`, `CONTEXT` for File Datastores                                                                                               | Type of the image, explained in detail in the following section. If omitted, the default value is the one defined in oned.conf (install default is OS)                                                                                                                                                                                                                                                                                            |
| `PERSISTENT`                                    | Optional                               | `YES`, `NO`                                                                                                                                                                               | Persistence of the image. If omitted, the default value is `NO`.                                                                                                                                                                                                                                                                                                                                                                                  |
| `PERSISTENT_TYPE`<br/><br/><br/><br/><br/><br/> | Optional<br/><br/><br/><br/><br/><br/> | `IMMUTABLE`, `SHAREABLE`<br/><br/><br/><br/><br/><br/>                                                                                                                                    | `IMMUTABLE` - An special persistent image, that will not be modified.<br/><br/><br/>`SHAREABLE` - Persistent image shareable by multiple VMs. Requires `raw` image `FORMAT` and shared datastore. [Virtualization driver]({{% relref "../opennebula_services_configuration/oned#oned-conf-virtualization-drivers" %}}) needs `SUPPORT_SHAREABLE = "yes"`<br/><br/><br/>This attribute should only be used for special storage configurations.<br/><br/>            |
| `DEV_PREFIX`                                    | Optional                               | Any string e.g `sd`, `hd`                                                                                                                                                                 | Prefix for the emulated device this image will be mounted at. For instance, `hd`, `sd`, or `vd` for KVM virtio. If omitted, the default value is the one defined in [oned.conf]({{% relref "../opennebula_services_configuration/oned#oned-conf" %}}) (installation default is `hd`).                                                                                                                                                                              |
| `TARGET`                                        | Optional                               | Any string                                                                                                                                                                                | Target for the emulated device this image will be mounted at. For instance, `hdb`, `sdc`. If omitted, it will be [assigned automatically]({{% relref "template#template-disks-device-mapping" %}}).                                                                                                                                                                                                                                                                |
| `FORMAT`                                        | Optional                               | `raw` or `qcow2`                                                                                                                                                                          | Format of the image backing file.                                                                                                                                                                                                                                                                                                                                                                                                                 |
| `FS`                                            | Optional                               | File system name (e.g ext4, xfs, …)                                                                                                                                                       | Specific file system type. It is used for formatting datablocks and volatile disks.                                                                                                                                                                                                                                                                                                                                                               |
| `PATH`                                          | Mandatory (if no SOURCE)               | Any string                                                                                                                                                                                | Path to the original file that will be copied to the image repository. If not specified for a `DATABLOCK` type image, an empty image will be created. Note that gzipped files are supported and OpenNebula will automatically decompress them. Bzip2 compressed files is also supported, but it’s strongly discouraged since OpenNebula will not calculate it’s size properly.                                                                    |
| `SOURCE\*`                                      | Mandatory (if no PATH)                 | Any string                                                                                                                                                                                | Source to be used in the DISK attribute. Useful for not file-based images.                                                                                                                                                                                                                                                                                                                                                                        |
| `DISK_TYPE`                                     | Optional                               | `BLOCK`, `CDROM` or `FILE` (default).                                                                                                                                                     | This is the type of the supporting media for the image: a block device (`BLOCK`) an ISO-9660 file or readonly block device (`CDROM`) or a plain file (`FILE`).                                                                                                                                                                                                                                                                                    |
| `READONLY`                                      | Optional                               | `YES`, `NO`                                                                                                                                                                               | This attribute should only be used for special storage configurations. It sets how the image is going to be exposed to the hypervisor. Images of type `CDROM` and those with PERSISTENT_TYPE set to `IMMUTABLE` will have `READONLY` set to `YES`. Otherwise, by default it is set to `NO`.                                                                                                                                                       |
| `MD5`                                           | Optional                               | An MD5 hash                                                                                                                                                                               | MD5 hash to check for image integrity.                                                                                                                                                                                                                                                                                                                                                                                                            |
| `SHA1`                                          | Optional                               | An SHA1 hash                                                                                                                                                                              | SHA1 hash to check for image integrity.                                                                                                                                                                                                                                                                                                                                                                                                           |
| `LUKS_SECRET`                                   | Optional                               | UUID value                                                                                                                                                                                | This attribute needs to be set for LUKS-encrypted images. Its value is UUID registered on hypervisor nodes as an identifier for the LUKS secret.                                                                                                                                                                                                                                                                                                  |
| `SERIAL`                                        | Optional                               | ``auto``, any string                                                                                                                                                                      | If present, a serial number will be added to virtual hard drive. If set to "auto", the serial number will be generated automatically. (<vm_id>-<disk_id>) If set to a specific value, that value will be used as the serial number.                                                                                                                                                                                                               |

{{< alert title="Warning" color="warning" >}}
Be careful when `PATH` points to a compressed bz2 image, since although it will work, OpenNebula will not calculate its size correctly.{{< /alert >}} 

{{< alert title="Important" color="success" >}}
All of the above KVM attributes also apply to LXC, with the exception of `DEV_PREFIX` and `TARGET`.{{< /alert >}} 

Mandatory attributes for `DATABLOCK` images with no `PATH` set:

| Attribute   | Value      | Description   |
|-------------|------------|---------------|
| `SIZE`      | An integer | Size in MB.   |

## Template Examples

Example of an `OS` image:

```default
NAME          = "Ubuntu Web Development"
PATH          = /home/one_user/images/ubuntu_desktop.img
DESCRIPTION   = "Ubuntu 10.04 desktop for Web Development students.
Contains the pdf lessons and exercises as well as all the necessary
programming tools and testing frameworks."
```

Example of a `CDROM` image:

```default
NAME          = "MATLAB install CD"
TYPE          = CDROM
PATH          = /home/one_user/images/matlab.iso
DESCRIPTION   = "Contains the MATLAB installation files. Mount it to install MATLAB on new OS images."
```

Example of a `DATABLOCK` image:

```default
NAME          = "Experiment results"
TYPE          = DATABLOCK
# No PATH set, this image will start as a new empty disk
SIZE          = 3.08
DESCRIPTION   = "Storage for my Thesis experiments."
```

<a id="img-template-restricted-attributes"></a>

## Restricted Attributes

All the **default** restricted attributes to users in the oneadmin group are summarized in the following list:

* `SOURCE`

These attributes can be configured in [oned.conf]({{% relref "../opennebula_services_configuration/oned#oned-conf" %}}).
