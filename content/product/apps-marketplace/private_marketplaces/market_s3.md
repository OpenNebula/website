---
title: "S3 Marketplace"
date: "2025-02-17"
description:
categories:
pageintoc: "191"
tags:
weight: "3"
---

<a id="market-s3"></a>

<!--# S3 Marketplace -->

## Overview

This Marketplace uses an S3 API-capable service as the backend. This means Marketplace Appliances will be stored in the official [AWS S3 service](https://aws.amazon.com/s3/) , or in services that implement that API, like [Ceph Object Gateway S3](https://docs.ceph.com/en/latest/radosgw/s3/).

## Limitations

Since the S3 API does not provide a value for available space, this space is hard-coded into the driver file, limiting it to 1TB. See below to learn how to change the default value.

## Requirements

To use this driver you require access to an S3 API-capable service:

* If you want to use AWS Amazon S3, you can start with the [Getting Started](http://docs.aws.amazon.com/AmazonS3/latest/gsg/GetStartedWithS3.html) guide.
* For Ceph S3 you must follow the [Configuring Ceph Object Gateway](https://docs.ceph.com/en/latest/radosgw/config-ref/) guide.

Make sure you obtain both an `access_key` and a `secret_key` of a user that has access to a bucket with the exclusive purpose of storing Marketplace Apps.

## Configuration

These are the configuration attributes of a Marketplace template of the S3 kind:

| Attribute           | Required   | Description                                                                                                   |
|---------------------|------------|---------------------------------------------------------------------------------------------------------------|
| `NAME`              | **YES**    | Marketplace name that is going to be shown in OpenNebula.                                                     |
| `MARKET_MAD`        | **YES**    | Must be `s3`.                                                                                                 |
| `ACCESS_KEY_ID`     | **YES**    | The access key of the S3 user.                                                                                |
| `SECRET_ACCESS_KEY` | **YES**    | The secret key of the S3 user.                                                                                |
| `BUCKET`            | **YES**    | The bucket where the files will be stored.                                                                    |
| `REGION`            | **YES**    | The region to connect to. If you are using Ceph S3 any value here will work.                                  |
| `TOTAL_MB`          | **NO**     | This parameter defines the total size of the Marketplace in MB. It defaults to `1048576` (MB).                |
| `READ_LENGTH`       | **NO**     | Split the file into chunks of this size in MB, **never** use a value larger than 100. Defaults to `32` (MB). |

The following attributes are **required for non AWS s3 implementtions**

| Attribute           | Description                                                                                      |
|---------------------|--------------------------------------------------------------------------------------------------|
| `AWS`               | Must be `no`.                                                                                    |
| `SIGNATURE_VERSION` | Must be `s3`.                                                                                    |
| `FORCE_PATH_STYLE`  | Must be `YES`.                                                                                   |
| `ENDPOINT`          | Preferably don’t use an endpoint that includes the bucket as the leading part of the Host’s URL. |

For example, the following template illustrates the definition of a Ceph S3 Marketplace:

```default
$ cat market.conf
NAME              = S3CephMarket
ACCESS_KEY_ID     = "*********************"
SECRET_ACCESS_KEY = "*********************"
BUCKET            = "opennebula-market"
ENDPOINT          = "http://ceph-gw.opennebula.org"
FORCE_PATH_STYLE  = "YES"
MARKET_MAD        = s3
REGION            = "default"
SIGNATURE_VERSION = s3
AWS               = no
```

which is created by passing the following command:

```default
$ onemarket create market.conf
ID: 100
```

## Tuning & Extending

{{< alert title="Important" color="success" >}}
Any modification of code should be handled carefully. Although we might provide hints on how to fine-tune various parts by customizing the OpenNebula internals, in general, **it’s NOT recommended to make changes in the existing code**. Please note the changes will be lost during the OpenNebula upgrade and have to be introduced back again manually!{{< /alert >}} 

In order to change the available size of the Marketplace from 1 TB to your desired value, you can modify `/var/lib/one/remotes/market/s3/monitor` and change:

```default
TOTAL_MB_DEFAULT = 1048576 # Default maximum 1TB
```

System administrators and integrators are encouraged to modify these drivers in order to integrate them with their datacenter. Please refer to the [Market Driver Development]({{% relref "../../../product/integration_references/infrastructure_drivers_development/devel-market#devel-market" %}}) guide to learn about the driver details.
