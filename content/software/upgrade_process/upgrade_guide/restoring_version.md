---
title: "Restoring Previous Version"
date: "2025-02-17"
description:
categories:
pageintoc: "262"
tags:
weight: "6"
---

<a id="restoring-version"></a>

<!--# Restoring Previous Version -->

If for any reason you need to restore your previous OpenNebula, follow these steps:

- With OpenNebula {{< version >}} still installed, restore the DB backup using `onedb restore -f`
- Uninstall OpenNebula {{< version >}}, and install your previous version again.
- Copy back the backup of `/etc/one` you did to restore your configuration.
