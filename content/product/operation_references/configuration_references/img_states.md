---
title: "Image States Reference"
date: "2025-02-17"
description:
categories:
pageintoc: "154"
tags:
weight: "6"
---

<a id="img-states"></a>

<!--# Image States Reference -->

This page is a complete reference of all the Image states that will be useful for developers and administrators doing troubleshooting.

The simplified life-cycle is explained in the [Virtual Machines Images guide]({{% relref "../../virtual_machines_operation/virtual_machines/images#images-states" %}}). This simplified diagram uses a smaller number of state names. That section should be enough for end users and everyday administration tasks.

## List of States

OpenNebula’s images define their state using the `STATE` variable. The state can be seen from the CLI (`oneimage show`) and from Sunstone (Info panel for the Image).

|   # | State            | Short State Alias   | Meaning                                           |
|-----|------------------|---------------------|---------------------------------------------------|
|   0 | INIT             | `init`              | Initialization state                              |
|   1 | READY            | `rdy`               | Image ready to use                                |
|   2 | USED             | `used`              | The image is being used by other VM               |
|   3 | DISABLED         | `disa`              | Image can not be instantiated by a VM             |
|   4 | LOCKED           | `lock`              | FS operation for the Image in process             |
|   5 | ERROR            | `err`               | Error state the operation FAILED                  |
|   6 | CLONE            | `clon`              | Image is being cloned                             |
|   7 | DELETE           | `dele`              | DS is deleting the image                          |
|   8 | USED_PERS        | `used`              | Image is in use and persistent                    |
|   9 | LOCKED_USED      | `lock`              | FS operation in progress, VMs waiting             |
|  10 | LOCKED_USED_PERS | `lock`              | FS operation in progress, VMs waiting. Persistent |
