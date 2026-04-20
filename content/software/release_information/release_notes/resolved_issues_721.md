---
title: "Resolved Issues in 7.2.1"
date: "2026-03-31"
---

A complete list of solved issues for 7.2.1 are listed in the [project development portal](https://github.com/OpenNebula/one/milestone/88).

## Backported Issues

The following new features have been backported to 7.2.1:

* Place first new feature here

## Resolved Issues

The following issues have been solved in 7.2.1:

* Fix a `onehem-server` crash caused by a race condition between hook delete and update API calls [#7561](https://github.com/OpenNebula/one-ee/pull/7561).
* Fix a  empty `--resource` for `onegroup create` CLI command [#7458](https://github.com/OpenNebula/one/issues/7458).
* Fix race condition in `oneflow` server in cancel actions [#7570](https://github.com/OpenNebula/one/issues/7570).
* Fix S3 marketplace `SIGNATURE_VERSION` parameter hardcoded to `s3` version [7437](https://github.com/OpenNebula/one/issues/7437).
* Fix race condition in `oneflow` server in cancel actions [#7570](https://github.com/OpenNebula/one/issues/7570)
* Fix usage of network lease in case of VM deploy failure [#7349](https://github.com/OpenNebula/one/issues/7349)
* Fix authentication drivers for users with empty password [#7606](https://github.com/OpenNebula/one/issues/7606)

