---
title: "Kernels and Files Datastore"
linktitle: "Kernels and Files"
date: "2025-02-17"
description:
categories:
pageintoc: "75"
tags:
weight: "9"
---

<a id="file-ds"></a>

<!--# The Kernels & Files Datastore -->

The Kernels and Files Datastore lets you store plain files to be used as VM kernels, ramdisks, or any other files that need to be passed to the VM through the contextualization process. The Kernels and Files Datastore does not expose any special storage mechanism but is a simple and secure way to use files within VM templates.

## Configuration

The [datastores common configuration attributes]({{% relref "datastores#datastore-common" %}}) apply to the Kernels and Files Datastores and can be defined during the creation process or updated once the datastores have been created.

The specific attributes for Kernels and Files Datastore are listed in the following table:

| Attribute   | Description   |
|-------------|---------------|
| `TYPE`      | `FILE_DS`     |
| `DS_MAD`    | `fs`          |
| `TM_MAD`    | `local`       |

{{< alert title="Note" color="success" >}}
The recommended `DS_MAD` and `TM_MAD` are the ones stated above but any other can be used to fit specific use cases. Regarding this, the same [configuration guidelines]({{% relref "datastores#datastores" %}}) defined for Image and System Datastores apply for the Kernels and Files Datastore.{{< /alert >}} 

For example, the following illustrates the creation of Kernels and Files:

```default
> cat kernels_ds.conf
NAME = kernels
DS_MAD = fs
TM_MAD = local
TYPE = FILE_DS
SAFE_DIRS = /var/tmp/files

> onedatastore create kernels_ds.conf
ID: 100

> onedatastore list
  ID NAME                      CLUSTER         IMAGES TYPE DS       TM
   0 system                    -                    0 sys  -        dummy
   1 default                   -                    0 img  dummy    dummy
   2 files                     -                    0 fil  fs       local
 100 kernels                   -                    0 fil  fs       local
```

You can check more details of the datastore by issuing the `onedatastore show <ds_id>` command.

## Host Configuration

The recommended `local` driver for the File Datastore does not need any special configuration for the Hosts. Just make sure that there is enough space under the datastore location (`/var/lib/one/datastores` by default) to hold the VM files in the Front-end and Hosts.

If different `DS_MAD` or `TM_MAD` attributes are used, refer to the corresponding node set up guide of the corresponding driver.
