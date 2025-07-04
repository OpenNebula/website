---
title: "XML-RPC API"
date: "2025-02-17"
description:
categories:
pageintoc: "282"
tags:
weight: "2"
---

<a id="api"></a>

<!--# XML-RPC API -->

This reference documentation describes the xml-rpc methods exposed by OpenNebula. Each description consists of the method name and the input and output values.

All xml-rpc responses share a common structure.

| Type   | Data Type   | Description                                   |
|--------|-------------|-----------------------------------------------|
| OUT    | Boolean     | True or false whenever is successful or not.  |
| OUT    | String      | If an error occurs this is the error message. |
| OUT    | Int         | Error code.                                   |

The output will always consist of three values. The first and third ones are fixed, but the second one will contain the String error message only in case of failure. If the method is successful, the returned value may be of another Data Type.

The Error Code will contain one of the following values:

| Value   | Code           | Meaning                                                               |
|---------|----------------|-----------------------------------------------------------------------|
| 0x0000  | SUCCESS        | Success response.                                                     |
| 0x0100  | AUTHENTICATION | User could not be authenticated.                                      |
| 0x0200  | AUTHORIZATION  | User is not authorized to perform the requested action.               |
| 0x0400  | NO_EXISTS      | The requested resource does not exist.                                |
| 0x0800  | ACTION         | Wrong state to perform action.                                        |
| 0x1000  | XML_RPC_API    | Wrong parameters, e.g. param should be -1 or -2, but -3 was received. |
| 0x2000  | INTERNAL       | Internal error, e.g. the resource could not be loaded from the DB.    |
| 0x4000  | ALLOCATE       | The resource cannot be allocated.                                     |
| 0x8000  | LOCKED         | The resource is locked.                                               |

{{< alert title="Note" color="success" >}}
All methods expect a session string associated to the connected user as the first parameter. It has to be formed with the contents of the ONE_AUTH file, which will be `<username>:<password>` with the default ‘core’ auth driver.{{< /alert >}} 

{{< alert title="Note" color="success" >}}
Each XML-RPC request has to be authenticated and authorized. See the [Auth Subsystem documentation]({{% relref "../../../product/cloud_system_administration/multitenancy/auth_overview#auth-overview" %}}) for more information.{{< /alert >}} 

The information strings returned by the `one.*.info` methods are XML-formatted. The complete XML Schemas (XSD) reference is included at the end of this page. We encourage you to use the `-x` option of the [command line interface]({{% relref "../../../product/operation_references/configuration_references/cli#cli" %}}) to collect sample outputs from your own infrastructure.

The methods that accept XML templates require the root element to be TEMPLATE. For instance, this template:

```none
NAME = abc
MEMORY = 1024
ATT1 = value1
```

Can be also given to OpenNebula with the following XML:

```xml
<TEMPLATE>
  <NAME>abc</NAME>
  <MEMORY>1024</MEMORY>
  <ATT1>value1</ATT1>
</TEMPLATE>
```

## Authorization Requests Reference

OpenNebula features a CLI that wraps the XML-RPC requests. For each XML-RPC request, the session token is authenticated, and after that the Request Manager generates an authorization request that can include more than one operation. The following tables document these requests from the different CLI commands.

{{< alert title="Note" color="success" >}}
Commands with marked with \* are asynchronous. The success response for these commands means that all preconditions passed and the action started. To check the action result you need to inspect the resource or its state.{{< /alert >}} 

<a id="onevm-api"></a>

### onevm

| onevm command                                                                                                                                           | XML-RPC Method            | Auth. Request                                            |
|---------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------|----------------------------------------------------------|
| deploy\*                                                                                                                                                | one.vm.deploy             | VM:ADMIN<br/><br/>HOST:MANAGE                            |
| undeploy\*<br/><br/>terminate\*<br/><br/>suspend\*<br/><br/>hold<br/><br/>stop\*<br/><br/>resume<br/><br/>release<br/><br/>poweroff\*<br/><br/>reboot\* | one.vm.action             | VM:MANAGE                                                |
| resched<br/><br/>unresched                                                                                                                              | one.vm.action             | VM:ADMIN                                                 |
| migrate\*                                                                                                                                               | one.vm.migrate            | VM:ADMIN<br/><br/>HOST:MANAGE                            |
| disk-saveas\*                                                                                                                                           | one.vm.disksaveas         | VM:MANAGE<br/><br/>IMAGE:CREATE                          |
| disk-snapshot-create\*                                                                                                                                  | one.vm.disksnapshotcreate | VM:MANAGE<br/><br/>IMAGE:MANAGE                          |
| disk-snapshot-delete\*                                                                                                                                  | one.vm.disksnapshotdelete | VM:MANAGE<br/><br/>IMAGE:MANAGE                          |
| disk-snapshot-revert\*                                                                                                                                  | one.vm.disksnapshotrevert | VM:MANAGE                                                |
| disk-snapshot-rename                                                                                                                                    | one.vm.disksnapshotrename | VM:MANAGE                                                |
| disk-snapshot-list                                                                                                                                      | one.vmpool.info           | VM:USE                                                   |
| disk-attach\*                                                                                                                                           | one.vm.attach             | VM:MANAGE<br/><br/>IMAGE:USE                             |
| disk-detach\*                                                                                                                                           | one.vm.detach             | VM:MANAGE                                                |
| disk-resize\*                                                                                                                                           | one.vm.diskresize         | VM:MANAGE                                                |
| nic-attach\*                                                                                                                                            | one.vm.attachnic          | VM:MANAGE<br/><br/>NET:USE                               |
| nic-detach\*                                                                                                                                            | one.vm.detachnic          | VM:MANAGE                                                |
| nic-update\*                                                                                                                                            | one.vm.updatenic          | VM:MANAGE                                                |
| sg-attach\*                                                                                                                                             | one.vm.attachsg           | VM:MANAGE                                                |
| sg-detach\*                                                                                                                                             | one.vm.detachsg           | VM:MANAGE                                                |
| create                                                                                                                                                  | one.vm.allocate           | VM:CREATE<br/><br/>IMAGE:USE<br/><br/>NET:USE            |
| show                                                                                                                                                    | one.vm.info               | VM:USE                                                   |
| chown<br/><br/>chgrp                                                                                                                                    | one.vm.chown              | VM:MANAGE<br/><br/>[USER:MANAGE]<br/><br/>[GROUP:USE]    |
| chmod                                                                                                                                                   | one.vm.chmod              | VM:<MANAGE/ADMIN>                                        |
| rename                                                                                                                                                  | one.vm.rename             | VM:MANAGE                                                |
| snapshot-create\*                                                                                                                                       | one.vm.snapshotcreate     | VM:MANAGE                                                |
| snapshot-delete\*                                                                                                                                       | one.vm.snapshotdelete     | VM:MANAGE                                                |
| snapshot-revert\*                                                                                                                                       | one.vm.snapshotrevert     | VM:MANAGE                                                |
| snapshot-list                                                                                                                                           | one.vmpool.info           | VM:USE                                                   |
| resize\*                                                                                                                                                | one.vm.resize             | VM:MANAGE                                                |
| update                                                                                                                                                  | one.vm.update             | VM:MANAGE                                                |
| recover\*                                                                                                                                               | one.vm.recover            | VM:ADMIN                                                 |
| save\*                                                                                                                                                  | – (ruby method)           | VM:MANAGE<br/><br/>IMAGE:CREATE<br/><br/>TEMPLATE:CREATE |
| updateconf                                                                                                                                              | one.vm.updateconf         | VM:MANAGE                                                |
| list<br/>top                                                                                                                                            | one.vmpool.info           | VM:USE                                                   |
| list                                                                                                                                                    | one.vmpool.infoextended   | VM:USE                                                   |
| –                                                                                                                                                       | one.vm.monitoring         | VM:USE                                                   |
| lock                                                                                                                                                    | one.vm.lock               | VM:MANAGE                                                |
| unlock                                                                                                                                                  | one.vm.unlock             | VM:MANAGE                                                |
| create-chart<br/><br/>--schedule                                                                                                                        | one.vm.schedadd           | VM:MANAGE                                                |
| sched-update                                                                                                                                            | one.vm.schedupdate        | VM:MANAGE                                                |
| sched-delete                                                                                                                                            | one.vm.scheddelete        | VM:MANAGE                                                |
| backup <sub>\*</sub>                                                                                                                                    | one.vm.backup             | VM:ADMIN                                                 |
| backup-cancel\*                                                                                                                                         | one.vm.backupcancel       | VM:ADMIN                                                 |
| pci-attach                                                                                                                                              | one.vm.attachpci          | VM:MANAGE                                                |
| pci-detach                                                                                                                                              | one.vm.detachpci          | VM:MANAGE                                                |
| restore                                                                                                                                                 | one.vm.restore            | VM:MANAGE                                                |

{{< alert title="Note" color="success" >}}
The **deploy** action requires the user issuing the command to have VM:ADMIN rights. This user will usually be the scheduler with the oneadmin credentials.

The scheduler deploys VMs to the Hosts over which the VM owner has MANAGE rights.

The **backup** action can be done by regular users through the schedule action interface (`--schedule`).{{< /alert >}}  

### onetemplate

| onetemplate command   | XML-RPC Method           | Auth. Request                                               |
|-----------------------|--------------------------|-------------------------------------------------------------|
| update                | one.template.update      | TEMPLATE:MANAGE                                             |
| instantiate           | one.template.instantiate | TEMPLATE:USE<br/><br/>[IMAGE:USE]<br/><br/>[NET:USE]        |
| create                | one.template.allocate    | TEMPLATE:CREATE                                             |
| clone                 | one.template.clone       | TEMPLATE:CREATE<br/><br/>TEMPLATE:USE                       |
| delete                | one.template.delete      | TEMPLATE:MANAGE                                             |
| show                  | one.template.info        | TEMPLATE:USE                                                |
| chown<br/><br/>chgrp  | one.template.chown       | TEMPLATE:MANAGE<br/><br/>[USER:MANAGE]<br/><br/>[GROUP:USE] |
| chmod                 | one.template.chmod       | TEMPLATE:<MANAGE/ADMIN>                                     |
| rename                | one.template.rename      | TEMPLATE:MANAGE                                             |
| list<br/><br/>top     | one.templatepool.info    | TEMPLATE:USE                                                |
| lock                  | one.template.lock        | TEMPLATE:MANAGE                                             |
| unlock                | one.template.unlock      | TEMPLATE:MANAGE                                             |

### onehost

| onehost command                          | XML-RPC Method    | Auth. Request                        |
|------------------------------------------|-------------------|--------------------------------------|
| enable<br/><br/>disable<br/><br/>offline | one.host.status   | HOST:ADMIN                           |
| update                                   | one.host.update   | HOST:ADMIN                           |
| create                                   | one.host.allocate | HOST:CREATE<br/><br/>[CLUSTER:ADMIN] |
| delete                                   | one.host.delete   | HOST:ADMIN                           |
| rename                                   | one.host.rename   | HOST:ADMIN                           |
| show                                     | one.host.info     | HOST:USE                             |
| list<br/>top                             | one.hostpool.info | HOST:USE                             |

{{< alert title="Warning" color="warning" >}}
onehost sync is not performed by the core, it is done by the ruby command onehost.{{< /alert >}} 

### onecluster

| onecluster command   | XML-RPC Method           | Auth. Request                          |
|----------------------|--------------------------|----------------------------------------|
| create               | one.cluster.allocate     | CLUSTER:CREATE                         |
| delete               | one.cluster.delete       | CLUSTER:ADMIN                          |
| update               | one.cluster.update       | CLUSTER:MANAGE                         |
| addhost              | one.cluster.addhost      | CLUSTER:ADMIN<br/><br/>HOST:ADMIN      |
| delhost              | one.cluster.delhost      | CLUSTER:ADMIN<br/><br/>HOST:ADMIN      |
| adddatastore         | one.cluster.adddatastore | CLUSTER:ADMIN<br/><br/>DATASTORE:ADMIN |
| deldatastore         | one.cluster.deldatastore | CLUSTER:ADMIN<br/><br/>DATASTORE:ADMIN |
| addvnet              | one.cluster.addvnet      | CLUSTER:ADMIN<br/><br/>NET:ADMIN       |
| delvnet              | one.cluster.delvnet      | CLUSTER:ADMIN<br/><br/>NET:ADMIN       |
| rename               | one.cluster.rename       | CLUSTER:MANAGE                         |
| show                 | one.cluster.info         | CLUSTER:USE                            |
| list                 | one.clusterpool.info     | CLUSTER:USE                            |

### onegroup

| onegroup command   | XML-RPC Method        | Auth. Request                          |
|--------------------|-----------------------|----------------------------------------|
| create             | one.group.allocate    | GROUP:CREATE                           |
| delete             | one.group.delete      | GROUP:ADMIN                            |
| show               | one.group.info        | GROUP:USE                              |
| update             | one.group.update      | GROUP:MANAGE                           |
| addadmin           | one.group.addadmin    | GROUP:MANAGE<br/><br/>USER:MANAGE      |
| deladmin           | one.group.deladmin    | GROUP:MANAGE<br/><br/>USER:MANAGE      |
| quota              | one.group.quota       | GROUP:ADMIN                            |
| list               | one.grouppool.info    | GROUP:USE                              |
| –                  | one.groupquota.info   | –                                      |
| defaultquota       | one.groupquota.update | Only for users in the `oneadmin` group |

### onevdc

| onevdc command   | XML-RPC Method       | Auth. Request                                          |
|------------------|----------------------|--------------------------------------------------------|
| create           | one.vdc.allocate     | VDC:CREATE                                             |
| rename           | one.vdc.rename       | VDC:MANAGE                                             |
| delete           | one.vdc.delete       | VDC:ADMIN                                              |
| update           | one.vdc.update       | VDC:MANAGE                                             |
| show             | one.vdc.info         | VDC:USE                                                |
| list             | one.vdcpool.info     | VDC:USE                                                |
| addgroup         | one.vdc.addgroup     | VDC:ADMIN<br/><br/>GROUP:ADMIN                         |
| delgroup         | one.vdc.delgroup     | VDC:ADMIN<br/><br/>GROUP:ADMIN                         |
| addcluster       | one.vdc.addcluster   | VDC:ADMIN<br/><br/>CLUSTER:ADMIN<br/><br/>ZONE:ADMIN   |
| delcluster       | one.vdc.delcluster   | VDC:ADMIN<br/><br/>CLUSTER:ADMIN<br/><br/>ZONE:ADMIN   |
| addhost          | one.vdc.addhost      | VDC:ADMIN<br/><br/>HOST:ADMIN<br/><br/>ZONE:ADMIN      |
| delhost          | one.vdc.delhost      | VDC:ADMIN<br/><br/>HOST:ADMIN<br/><br/>ZONE:ADMIN      |
| adddatastore     | one.vdc.adddatastore | VDC:ADMIN<br/><br/>DATASTORE:ADMIN<br/><br/>ZONE:ADMIN |
| deldatastore     | one.vdc.deldatastore | VDC:ADMIN<br/><br/>DATASTORE:ADMIN<br/><br/>ZONE:ADMIN |
| addvnet          | one.vdc.addvnet      | VDC:ADMIN<br/><br/>NET:ADMIN<br/><br/>ZONE:ADMIN       |
| delvnet          | one.vdc.delvnet      | VDC:ADMIN<br/><br/>NET:ADMIN<br/><br/>ZONE:ADMIN       |

### onevnet

| onevnet command      | XML-RPC Method   | Auth. Request                                          |
|----------------------|------------------|--------------------------------------------------------|
| addar                | one.vn.add_ar    | NET:ADMIN                                              |
| rmar                 | one.vn.rm_ar     | NET:ADMIN                                              |
| free                 | one.vn.free_ar   | NET:MANAGE                                             |
| reserve              | one.vn.reserve   | NET:USE                                                |
| updatear             | one.vn.update_ar | NET:MANAGE                                             |
| hold                 | one.vn.hold      | NET:MANAGE                                             |
| release              | one.vn.release   | NET:MANAGE                                             |
| update               | one.vn.update    | NET:MANAGE                                             |
| create               | one.vn.allocate  | NET:CREATE<br/><br/>[CLUSTER:ADMIN]                    |
| delete\*             | one.vn.delete    | NET:MANAGE                                             |
| show                 | one.vn.info      | NET:USE                                                |
| chown<br/><br/>chgrp | one.vn.chown     | NET:MANAGE<br/><br/>[USER:MANAGE]<br/><br/>[GROUP:USE] |
| chmod                | one.vn.chmod     | NET:<MANAGE/ADMIN>                                     |
| rename               | one.vn.rename    | NET:MANAGE                                             |
| list                 | one.vnpool.info  | NET:USE                                                |
| lock                 | one.vn.lock      | NET:MANAGE                                             |
| unlock               | one.vn.unlock    | NET:MANAGE                                             |
| recover              | one.vn.recover   | NET:MANAGE                                             |

### oneuser

| oneuser command         | XML-RPC Method       | Auth. Request                          |
|-------------------------|----------------------|----------------------------------------|
| create                  | one.user.allocate    | USER:CREATE                            |
| delete                  | one.user.delete      | USER:ADMIN                             |
| show                    | one.user.info        | USER:USE                               |
| passwd                  | one.user.passwd      | USER:MANAGE                            |
| login                   | one.user.login       | USER:MANAGE                            |
| update                  | one.user.update      | USER:MANAGE                            |
| chauth                  | one.user.chauth      | USER:ADMIN                             |
| quota                   | one.user.quota       | USER:ADMIN                             |
| chgrp                   | one.user.chgrp       | USER:MANAGE<br/><br/>GROUP:MANAGE      |
| addgroup                | one.user.addgroup    | USER:MANAGE<br/><br/>GROUP:MANAGE      |
| delgroup                | one.user.delgroup    | USER:MANAGE<br/><br/>GROUP:MANAGE      |
| enable<br/><br/>disable | one.user.enable      | USER:ADMIN                             |
| encode                  | –                    | –                                      |
| list                    | one.userpool.info    | USER:USE                               |
| –                       | one.userquota.info   | –                                      |
| defaultquota            | one.userquota.update | Only for users in the `oneadmin` group |

### onedatastore

| onedatastore command    | XML-RPC Method         | Auth. Request                                                |
|-------------------------|------------------------|--------------------------------------------------------------|
| create                  | one.datastore.allocate | DATASTORE:CREATE<br/><br/>[CLUSTER:ADMIN]                    |
| delete                  | one.datastore.delete   | DATASTORE:ADMIN                                              |
| show                    | one.datastore.info     | DATASTORE:USE                                                |
| update                  | one.datastore.update   | DATASTORE:MANAGE                                             |
| rename                  | one.datastore.rename   | DATASTORE:MANAGE                                             |
| chown<br/><br/>chgrp    | one.datastore.chown    | DATASTORE:MANAGE<br/><br/>[USER:MANAGE]<br/><br/>[GROUP:USE] |
| chmod                   | one.datastore.chmod    | DATASTORE:<MANAGE / ADMIN>                                   |
| enable<br/><br/>disable | one.datastore.enable   | DATASTORE:MANAGE                                             |
| list                    | one.datastorepool.info | DATASTORE:USE                                                |

### oneimage

| oneimage command                  | XML-RPC Method            | Auth. Request                                            |
|-----------------------------------|---------------------------|----------------------------------------------------------|
| persistent<br/><br/>nonpersistent | one.image.persistent      | IMAGE:MANAGE                                             |
| enable<br/><br/>disable           | one.image.enable          | IMAGE:MANAGE                                             |
| chtype                            | one.image.chtype          | IMAGE:MANAGE                                             |
| snapshot-delete\*                 | one.image.snapshotdelete  | IMAGE:MANAGE                                             |
| snapshot-revert\*                 | one.image.snapshotrevert  | IMAGE:MANAGE                                             |
| snapshot-flatten\*                | one.image.snapshotflatten | IMAGE:MANAGE                                             |
| update                            | one.image.update          | IMAGE:MANAGE                                             |
| create                            | one.image.allocate        | IMAGE:CREATE<br/><br/>DATASTORE:USE                      |
| clone\*                           | one.image.clone           | IMAGE:CREATE<br/><br/>IMAGE:USE<br/><br/>DATASTORE:USE   |
| delete\*                          | one.image.delete          | IMAGE:MANAGE                                             |
| show                              | one.image.info            | IMAGE:USE                                                |
| chown<br/><br/>chgrp              | one.image.chown           | IMAGE:MANAGE<br/><br/>[USER:MANAGE]<br/><br/>[GROUP:USE] |
| chmod                             | one.image.chmod           | IMAGE:<MANAGE / ADMIN>                                   |
| rename                            | one.image.rename          | IMAGE:MANAGE                                             |
| list<br/><br/>top                 | one.imagepool.info        | IMAGE:USE                                                |
| lock                              | one.image.lock            | IMAGE:MANAGE                                             |
| unlock                            | one.image.unlock          | IMAGE:MANAGE                                             |
| restore                           | one.image.restore         | IMAGE:USE                                                |

### onemarket

| onemarket  command      | XML-RPC Method      | Auth. Request                                                  |
|-------------------------|---------------------|----------------------------------------------------------------|
| update                  | one.market.update   | MARKETPLACE:MANAGE                                             |
| create                  | one.market.allocate | MARKETPLACE:CREATE                                             |
| delete                  | one.market.delete   | MARKETPLACE:MANAGE                                             |
| show                    | one.market.info     | MARKETPLACE:USE                                                |
| chown<br/><br/>chgrp    | one.market.chown    | MARKETPLACE:MANAGE<br/><br/>[USER:MANAGE]<br/><br/>[GROUP:USE] |
| chmod                   | one.market.chmod    | MARKETPLACE:<MANAGE / ADMIN>                                   |
| rename                  | one.market.rename   | MARKETPLACE:MANAGE                                             |
| enable<br/><br/>disable | one.market.enable   | MARKETPLACE:MANAGE                                             |
| list                    | one.marketpool.info | MARKETPLACE:USE                                                |

### onemarketapp

| onemarketapp command    | XML-RPC Method         | Auth. Request                                                                              |
|-------------------------|------------------------|--------------------------------------------------------------------------------------------|
| create                  | one.marketapp.allocate | MARKETPLACEAPP:CREATE<br/><br/>MARKETPLACE:USE                                             |
| export\*                | – (ruby method)        | MARKETPLACEAPP:USE<br/><br/>IMAGE:CREATE<br/><br/>DATASTORE:USE<br/><br/>[TEMPLATE:CREATE] |
| download\*              | – (ruby method)        | MARKETPLACEAPP:USE                                                                         |
| enable<br/><br/>disable | one.marketapp.enable   | MARKETPLACEAPP:MANAGE                                                                      |
| update                  | one.marketapp.update   | MARKETPLACEAPP:MANAGE                                                                      |
| delete                  | one.marketapp.delete   | MARKETPLACEAPP:MANAGE                                                                      |
| show                    | one.marketapp.info     | MARKETPLACEAPP:USE                                                                         |
| chown<br/><br/>chgrp    | one.marketapp.chown    | MARKETPLACEAPP:MANAGE<br/><br/>[USER:MANAGE]<br/><br/>[GROUP:USE]                          |
| chmod                   | one.marketapp.chmod    | MARKETPLACEAPP:<MANAGE / ADMIN>                                                            |
| rename                  | one.marketapp.rename   | MARKETPLACEAPP:MANAGE                                                                      |
| list                    | one.marketapppool.info | MARKETPLACEAPP:USE                                                                         |
| lock                    | one.marketapp.lock     | MARKETPLACEAPP:MANAGE                                                                      |
| unlock                  | one.marketapp.unlock   | MARKETPLACEAPP:MANAGE                                                                      |

### onevrouter

| onevrouter command   | XML-RPC Method          | Auth. Request                                              |
|----------------------|-------------------------|------------------------------------------------------------|
| create               | one.vrouter.allocate    | VROUTER:CREATE                                             |
| update               | one.vrouter.update      | VROUTER:MANAGE                                             |
| instantiate          | one.vrouter.instantiate | TEMPLATE:USE<br/><br/>[IMAGE:USE]<br/><br/>[NET:USE]       |
| nic-attach           | one.vrouter.attachnic   | VROUTER:MANAGE<br/><br/>NET:USE                            |
| nic-detach           | one.vrouter.detachnic   | VROUTER:MANAGE                                             |
| delete               | one.vrouter.delete      | VROUTER:MANAGE                                             |
| show                 | one.vrouter.info        | VROUTER:USE                                                |
| chown<br/><br/>chgrp | one.vrouter.chown       | VROUTER:MANAGE<br/><br/>[USER:MANAGE]<br/><br/>[GROUP:USE] |
| chmod                | one.vrouter.chmod       | VROUTER:<MANAGE/ADMIN>                                     |
| rename               | one.vrouter.rename      | VROUTER:MANAGE                                             |
| list<br/><br/>top    | one.vrouterpool.info    | VROUTER:USE                                                |
| lock                 | one.vrouter.lock        | VROUTER:MANAGE                                             |
| unlock               | one.vrouter.unlock      | VROUTER:MANAGE                                             |

### onezone

| onezone command         | XML-RPC Method       | Auth. Request   |
|-------------------------|----------------------|-----------------|
| create                  | one.zone.allocate    | ZONE:CREATE     |
| rename                  | one.zone.rename      | ZONE:MANAGE     |
| update                  | one.zone.update      | ZONE:MANAGE     |
| delete                  | one.zone.delete      | ZONE:ADMIN      |
| enable<br/><br/>disable | one.zone.enable      | ZONE:ADMIN      |
| server-add              | one.zone.addserver   | ZONE:ADMIN      |
| server-del              | one.zone.delserver   | ZONE:ADMIN      |
| server-reset            | one.zone.resetserver | ZONE:ADMIN      |
| show                    | one.zone.info        | ZONE:USE        |
| list                    | one.zonepool.info    | ZONE:USE        |
| set                     | –                    | ZONE:USE        |

### onesecgroup

| onesecgroup command   | XML-RPC Method        | Auth. Request                                               |
|-----------------------|-----------------------|-------------------------------------------------------------|
| create                | one.secgroup.allocate | SECGROUP:CREATE                                             |
| clone                 | one.secgroup.clone    | SECGROUP:CREATE<br/><br/>SECGROUP:USE                       |
| delete                | one.secgroup.delete   | SECGROUP:MANAGE                                             |
| chown<br/><br/>chgrp  | one.secgroup.chown    | SECGROUP:MANAGE<br/><br/>[USER:MANAGE]<br/><br/>[GROUP:USE] |
| chmod                 | one.secgroup.chmod    | SECGROUP:<MANAGE / ADMIN>                                   |
| update                | one.secgroup.update   | SECGROUP:MANAGE                                             |
| commit                | one.secgroup.commit   | SECGROUP:MANAGE                                             |
| rename                | one.secgroup.rename   | SECGROUP:MANAGE                                             |
| show                  | one.secgroup.info     | SECGROUP:USE                                                |
| list                  | one.secgrouppool.info | SECGROUP:USE                                                |

<a id="onevmgroup-api"></a>

### onevmgroup

| onevmgroup command   | XML-RPC Method         | Auth. Request                                              |
|----------------------|------------------------|------------------------------------------------------------|
| create               | one.vmgroup.allocate   | VMGROUP:CREATE                                             |
| delete               | one.vmgroup.delete     | VMGROUP:MANAGE                                             |
| chown<br/><br/>chgrp | one.vmgroup.chown      | VMGROUP:MANAGE<br/><br/>[USER:MANAGE]<br/><br/>[GROUP:USE] |
| chmod                | one.vmgroup.chmod      | VMGROUP:<MANAGE / ADMIN>                                   |
| update               | one.vmgroup.update     | VMGROUP:MANAGE                                             |
| rename               | one.vmgroup.rename     | VMGROUP:MANAGE                                             |
| show                 | one.vmgroup.info       | VMGROUP:USE                                                |
| list                 | one.vmgrouppool.info   | VMGROUP:USE                                                |
| lock                 | one.vmgroup.lock       | VMGROUP:MANAGE                                             |
| unlock               | one.vmgroup.unlock     | VMGROUP:MANAGE                                             |
| role-add             | one.vmgroup.roleadd    | VMGROUP:MANAGE                                             |
| role-delete          | one.vmgroup.roledelete | VMGROUP:MANAGE                                             |
| role-update          | one.vmgroup.roleupdate | VMGROUP:MANAGE                                             |

### oneacl

| oneacl command   | XML-RPC Method   | Auth. Request   |
|------------------|------------------|-----------------|
| create           | one.acl.addrule  | ACL:MANAGE      |
| delete           | one.acl.delrule  | ACL:MANAGE      |
| list             | one.acl.info     | ACL:MANAGE      |

### oneacct

| command   | XML-RPC Method        | Auth. Request   |
|-----------|-----------------------|-----------------|
| oneacct   | one.vmpool.accounting | VM:USE          |

### oneshowback

| command   | XML-RPC Method               | Auth. Request           |
|-----------|------------------------------|-------------------------|
| list      | one.vmpool.showback          | VM:USE                  |
| calculate | one.vmpool.calculateshowback | Only for oneadmin group |

<a id="document-api"></a>

### documents

| XML-RPC Method        | Auth. Request                                               |
|-----------------------|-------------------------------------------------------------|
| one.document.update   | DOCUMENT:MANAGE                                             |
| one.document.allocate | DOCUMENT:CREATE                                             |
| one.document.clone    | DOCUMENT:CREATE<br/><br/>DOCUMENT:USE                       |
| one.document.delete   | DOCUMENT:MANAGE                                             |
| one.document.info     | DOCUMENT:USE                                                |
| one.document.chown    | DOCUMENT:MANAGE<br/><br/>[USER:MANAGE]<br/><br/>[GROUP:USE] |
| one.document.chmod    | DOCUMENT:<MANAGE / ADMIN>                                   |
| one.document.rename   | DOCUMENT:MANAGE                                             |
| one.document.lock     | DOCUMENT:MANAGE                                             |
| one.document.unlock   | DOCUMENT:MANAGE                                             |
| one.documentpool.info | DOCUMENT:USE                                                |
| one.document.lock     | DOCUMENT:MANAGE                                             |
| one.document.unlock   | DOCUMENT:MANAGE                                             |

### system

| command   | XML-RPC Method     | Auth. Request                          |
|-----------|--------------------|----------------------------------------|
| –         | one.system.version | –                                      |
| –         | one.system.config  | Only for users in the `oneadmin` group |

### onevntemplate

| onevntemplate command   | XML-RPC Method             | Auth. Request                                                 |
|-------------------------|----------------------------|---------------------------------------------------------------|
| update                  | one.vntemplate.update      | VNTEMPLATE:MANAGE                                             |
| instantiate             | one.vntemplate.instantiate | VNTEMPLATE:USE                                                |
| create                  | one.vntemplate.allocate    | VNTEMPLATE:CREATE                                             |
| clone                   | one.vntemplate.clone       | VNTEMPLATE:CREATE<br/><br/>VNTEMPLATE:USE                     |
| delete                  | one.vntemplate.delete      | VNTEMPLATE:MANAGE                                             |
| show                    | one.vntemplate.info        | VNTEMPLATE:USE                                                |
| chown<br/><br/>chgrp    | one.vntemplate.chown       | VNTEMPLATE:MANAGE<br/><br/>[USER:MANAGE]<br/><br/>[GROUP:USE] |
| chmod                   | one.vntemplate.chmod       | VNTEMPLATE:<MANAGE/ADMIN>                                     |
| rename                  | one.vntemplate.rename      | VNTEMPLATE:MANAGE                                             |
| list<br/><br/>top       | one.vntemplatepool.info    | VNTEMPLATE:USE                                                |
| lock                    | one.vntemplate.lock        | VNTEMPLATE:MANAGE                                             |
| unlock                  | one.vntemplate.unlock      | VNTEMPLATE:MANAGE                                             |

### onehook

| onehook command   | XML-RPC Method    | Auth. Request   |
|-------------------|-------------------|-----------------|
| update            | one.hook.update   | HOOK:MANAGE     |
| create            | one.hook.allocate | HOOK:CREATE     |
| delete            | one.hook.delete   | HOOK:MANAGE     |
| show              | one.hook.info     | HOOK:USE        |
| rename            | one.hook.rename   | HOOK:MANAGE     |
| list<br/><br/>top | one.hook.info     | HOOK:USE        |
| lock              | one.hook.lock     | HOOK:MANAGE     |
| unlock            | one.hook.unlock   | HOOK:MANAGE     |
| retry             | one.hook.retry    | HOOK:MANAGE     |
| log               | one.hooklog.info  | HOOK:-          |

### onebackupjob

| onebackupjob command   | XML-RPC Method            | Auth. Request                                                |
|------------------------|---------------------------|--------------------------------------------------------------|
| create                 | one.backupjob.allocate    | BACKUPJOB:CREATE                                             |
| delete                 | one.backupjob.delete      | BACKUPJOB:MANAGE                                             |
| show                   | one.backupjob.info        | BACKUPJOB:USE                                                |
| update                 | one.backupjob.update      | BACKUPJOB:MANAGE                                             |
| rename                 | one.backupjob.rename      | BACKUPJOB:MANAGE                                             |
| chown<br/><br/>chgrp   | one.backupjob.chown       | BACKUPJOB:MANAGE<br/><br/>[USER:MANAGE]<br/><br/>[GROUP:USE] |
| chmod                  | one.backupjob.chmod       | BACKUPJOB:<MANAGE/ADMIN>                                     |
| lock                   | one.backupjob.lock        | BACKUPJOB:MANAGE                                             |
| unlock                 | one.backupjob.unlock      | BACKUPJOB:MANAGE                                             |
| backup                 | one.backupjob.backup      | BACKUPJOB:MANAGE                                             |
| cancel                 | one.backupjob.cancel      | BACKUPJOB:MANAGE                                             |
| retry                  | one.backupjob.retry       | BACKUPJOB:MANAGE                                             |
| priority               | one.backupjob.priority    | BACKUPJOB:<MANAGE/ADMIN>                                     |
| backup --schedule      | one.backupjob.schedadd    | BACKUPJOB:MANAGE                                             |
| sched-delete           | one.backupjob.scheddelete | BACKUPJOB:MANAGE                                             |
| sched-update           | one.backupjob.schedupdate | BACKUPJOB:MANAGE                                             |
| list                   | one.backupjobpool.info    | BACKUPJOB:USE                                                |

## Actions for Templates Management

### one.template.allocate

- **Description**: Allocates a new template in OpenNebula.
- **Parameters**

| Type   | Data Type   | Description                                                                                  |
|--------|-------------|----------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                          |
| IN     | String      | A string containing the template contents. Syntax can be the usual `attribute=value` or XML. |
| OUT    | Boolean     | true or false whenever is successful or not                                                  |
| OUT    | Int/String  | The allocated resource ID / The error string.                                                |
| OUT    | Int         | Error code.                                                                                  |

### one.template.clone

- **Description**: Clones an existing Virtual Machine template.
- **Parameters**

| Type   | Data Type   | Description                                                                                        |
|--------|-------------|----------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                |
| IN     | Int         | The ID of the template to be cloned.                                                               |
| IN     | String      | Name for the new template.                                                                         |
| IN     | Boolean     | true to clone the template plus any image defined in DISK. The new IMAGE_ID is set into each DISK. |
| OUT    | Boolean     | true or false whenever is successful or not                                                        |
| OUT    | Int/String  | The new template ID / The error string.                                                            |
| OUT    | Int         | Error code.                                                                                        |
| OUT    | Int         | ID of the original object that caused the error.                                                   |

### one.template.delete

- **Description**: Deletes the given template from the pool.
- **Parameters**

| Type   | Data Type   | Description                                                 |
|--------|-------------|-------------------------------------------------------------|
| IN     | String      | The session string.                                         |
| IN     | Int         | The object ID.                                              |
| IN     | Boolean     | true to delete the template plus any image defined in DISK. |
| OUT    | Boolean     | true or false whenever is successful or not                 |
| OUT    | Int/String  | The resource ID / The error string.                         |
| OUT    | Int         | Error code.                                                 |
| OUT    | Int         | ID of the object that caused the error.                     |

### one.template.instantiate

- **Description**: Instantiates a new Virtual Machine from a template.
- **Parameters**

| Type   | Data Type   | Description                                                                                                                                            |
|--------|-------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                                                    |
| IN     | Int         | The object ID.                                                                                                                                         |
| IN     | String      | Name for the new VM instance. If it is an empty string, OpenNebula will assign one automatically.                                                      |
| IN     | Boolean     | False to create the VM on pending (default), True to create it on hold.                                                                                |
| IN     | String      | A string containing an extra template to be merged with the one being instantiated. It can be empty. Syntax can be the usual `attribute=value` or XML. |
| IN     | Boolean     | true to create a private persistent copy of the template plus any image defined in DISK, and instantiate that copy.                                    |
| OUT    | Boolean     | true or false whenever is successful or not                                                                                                            |
| OUT    | Int/String  | The new virtual machine ID / The error string.                                                                                                         |
| OUT    | Int         | Error code.                                                                                                                                            |

Sample template string:

```none
MEMORY=4096\nCPU=4\nVCPU=4
```

{{< alert title="Note" color="success" >}}
Declaring a field overwrites the template. Thus, declaring `DISK=[...]` overwrites the template `DISK` attribute and as such must contain the entire `DISK` definition.{{< /alert >}} 

### one.template.update

- **Description**: Replaces the template contents.
- **Parameters**

| Type   | Data Type   | Description                                                                                      |
|--------|-------------|--------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                              |
| IN     | Int         | The object ID.                                                                                   |
| IN     | String      | The new template contents. Syntax can be the usual `attribute=value` or XML.                     |
| IN     | Int         | Update type: **0**: replace the whole template. **1**: Merge new template with the existing one. |
| OUT    | Boolean     | true or false whenever is successful or not                                                      |
| OUT    | Int/String  | The resource ID / The error string.                                                              |
| OUT    | Int         | Error code.                                                                                      |

### one.template.chmod

- **Description**: Changes the permission bits of a template.
- **Parameters**

| Type   | Data Type   | Description                                                |
|--------|-------------|------------------------------------------------------------|
| IN     | String      | The session string.                                        |
| IN     | Int         | The object ID.                                             |
| IN     | Int         | USER USE bit. If set to -1, it will not change.            |
| IN     | Int         | USER MANAGE bit. If set to -1, it will not change.         |
| IN     | Int         | USER ADMIN bit. If set to -1, it will not change.          |
| IN     | Int         | GROUP USE bit. If set to -1, it will not change.           |
| IN     | Int         | GROUP MANAGE bit. If set to -1, it will not change.        |
| IN     | Int         | GROUP ADMIN bit. If set to -1, it will not change.         |
| IN     | Int         | OTHER USE bit. If set to -1, it will not change.           |
| IN     | Int         | OTHER MANAGE bit. If set to -1, it will not change.        |
| IN     | Int         | OTHER ADMIN bit. If set to -1, it will not change.         |
| IN     | Boolean     | true to chmod the template plus any image defined in DISK. |
| OUT    | Boolean     | true or false whenever is successful or not                |
| OUT    | Int/String  | The resource ID / The error string.                        |
| OUT    | Int         | Error code.                                                |
| OUT    | Int         | ID of the object that caused the error.                    |

### one.template.chown

- **Description**: Changes the ownership of a template.
- **Parameters**

| Type   | Data Type   | Description                                                            |
|--------|-------------|------------------------------------------------------------------------|
| IN     | String      | The session string.                                                    |
| IN     | Int         | The object ID.                                                         |
| IN     | Int         | The User ID of the new owner. If set to -1, the owner is not changed.  |
| IN     | Int         | The Group ID of the new group. If set to -1, the group is not changed. |
| OUT    | Boolean     | true or false whenever is successful or not                            |
| OUT    | Int/String  | The resource ID / The error string.                                    |
| OUT    | Int         | Error code.                                                            |
| OUT    | Int         | ID of the object that caused the error.                                |

### one.template.rename

- **Description**: Renames a template.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | String      | The new name.                               |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The VM ID / The error string.               |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.template.info

- **Description**: Retrieves information for the template.
- **Parameters**

| Type   | Data Type   | Description                                                                                            |
|--------|-------------|--------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                    |
| IN     | Int         | The object ID.                                                                                         |
| IN     | Boolean     | optional flag to process the template and include extended information, such as the SIZE for each DISK |
| IN     | Boolean     | optional flag to decrypt contained secrets, valid only for admin                                       |
| OUT    | Boolean     | true or false whenever is successful or not                                                            |
| OUT    | String      | The information string / The error string.                                                             |
| OUT    | Int         | Error code.                                                                                            |
| OUT    | Int         | ID of the object that caused the error.                                                                |

### one.templatepool.info

- **Description**: Retrieves information for all or part of the resources in the pool.
- **Parameters**

| Type   | Data Type   | Description                                                                                                                                                                                                                                                       |
|--------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                                                                                                                                                               |
| IN     | Int         | Filter flag<br/><br/>* **-4**: Resources belonging to the user’s primary group<br/>* **-3**: Resources belonging to the user<br/>* **-2**: All resources<br/>* **-1**: Resources belonging to the user and any of his groups<br/>* **>= 0**: UID User’s Resources |
| IN     | Int         | When the next parameter is >= -1 this is the Range start ID.<br/>Can be -1. For smaller values this is the offset used for pagination.                                                                                                                            |
| IN     | Int         | For values >= -1 this is the Range end ID. Can be -1 to get until the<br/>last ID. For values < -1 this is the page size used for pagination.                                                                                                                     |
| OUT    | Boolean     | true or false whenever is successful or not                                                                                                                                                                                                                       |
| OUT    | String      | The information string / The error string.                                                                                                                                                                                                                        |
| OUT    | Int         | Error code.                                                                                                                                                                                                                                                       |
| OUT    | Int         | ID of the object that caused the error.                                                                                                                                                                                                                           |

The range can be used to retrieve a subset of the pool, from the ‘start’ to the ‘end’ ID. To retrieve the complete pool, use `(-1, -1)`; to retrieve all the pool from a specific ID to the last one, use `(<id>, -1)`, and to retrieve the first elements up to an ID, use `(0, <id>)`.

### one.template.lock

- **Description**: Locks a Template.
- **Parameters**

| Type   | Data Type   | Description                                                                  |
|--------|-------------|------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                          |
| IN     | Int         | The object ID.                                                               |
| IN     | Int         | Lock level: use (1), manage (2), admin (3), all (4)                          |
| IN     | Boolean     | Test: check if the object is already locked to return an error               |
| OUT    | Boolean     | true or false whenever is successful or not                                  |
| OUT    | Int         | The ID of the resource.                                                      |
| OUT    | Int         | Error code.                                                                  |
| OUT    | Int         | ID of the object that caused the error.                                      |
| OUT    | String      | Timestamp when the object was locked in case of error when using test = true |

### one.template.unlock

- **Description**: Unlocks a Template.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int         | The ID of the resource.                     |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

## Actions for Virtual Machine Management

### one.vm.allocate

- **Description**: Allocates a new Virtual Machine in OpenNebula.
- **Parameters**

| Type   | Data Type   | Description                                                                                    |
|--------|-------------|------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                            |
| IN     | String      | A string containing the template for the vm. Syntax can be the usual `attribute=value` or XML. |
| IN     | Boolean     | False to create the VM on pending (default), True to create it on hold.                        |
| OUT    | Boolean     | true or false whenever is successful or not                                                    |
| OUT    | Int/String  | The allocated resource ID / The error string.                                                  |
| OUT    | Int         | Error code.                                                                                    |
| OUT    | Int         | ID of the Cluster that caused the error.                                                       |

### one.vm.deploy

- **Description**: initiates the instance of the given vmid on the target Host.
- **Parameters**

| Type   | Data Type   | Description                                                                                                                                                 |
|--------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                                                         |
| IN     | Int         | The object ID.                                                                                                                                              |
| IN     | Int         | The Host ID of the target host where the VM will be deployed.                                                                                               |
| IN     | Boolean     | true to enforce the Host capacity is not overcommitted.                                                                                                     |
| IN     | Int         | The Datastore ID of the target system datastore where the VM will be deployed. It is optional, and can be set to -1 to let OpenNebula choose the datastore. |
| IN     | String      | Template with network scheduling results for NIC in AUTO mode.                                                                                              |
| OUT    | Boolean     | true or false whenever is successful or not                                                                                                                 |
| OUT    | Int/String  | The VM ID / The error string.                                                                                                                               |
| OUT    | Int         | Error code.                                                                                                                                                 |
| OUT    | Int         | ID of the Datastore that caused the error.                                                                                                                  |

### one.vm.action

- **Description**: submits an action to be performed on a Virtual Machine.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | String      | the action name to be performed, see below. |
| IN     | Int         | The object ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The VM ID / The error string.               |
| OUT    | Int         | Error code.                                 |

The action String must be one of the following:

* **terminate-hard**
* **terminate**
* **undeploy-hard**
* **undeploy**
* **poweroff-hard**
* **poweroff**
* **reboot-hard**
* **reboot**
* **hold**
* **release**
* **stop**
* **suspend**
* **resume**
* **resched**
* **unresched**

<a id="one-vm-migrate"></a>

### one.vm.migrate

- **Description**: migrates one Virtual Machine (vid) to the target Host (hid).
- **Parameters**

| Type   | Data Type   | Description                                                            |
|--------|-------------|------------------------------------------------------------------------|
| IN     | String      | The session string.                                                    |
| IN     | Int         | The object ID.                                                         |
| IN     | Int         | the target host id (hid) where we want to migrate the vm.              |
| IN     | Boolean     | if true we are indicating that we want livemigration, otherwise false. |
| IN     | Boolean     | true to enforce the Host capacity is not overcommitted.                |
| IN     | Int         | the target system DS id where we want to migrate the vm.               |
| IN     | Int         | The migration type (0 save, 1 poweroff, 2 poweroff hard).              |
| OUT    | Boolean     | true or false whenever is successful or not                            |
| OUT    | Int/String  | The VM ID / The error string.                                          |
| OUT    | Int         | Error code.                                                            |
| OUT    | Int         | ID of the Datastore / Host that caused the error.                      |

### one.vm.disksaveas

- **Description**: Sets the disk to be saved in the given image.
- **Parameters**

| Type   | Data Type   | Description                                                                                                                                                                                                                                                                                                                                        |
|--------|-------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                                                                                                                                                                                                                                                |
| IN     | Int         | The object ID.                                                                                                                                                                                                                                                                                                                                     |
| IN     | Int         | Disk ID of the disk we want to save.                                                                                                                                                                                                                                                                                                               |
| IN     | String      | Name for the new Image where the disk will be saved.                                                                                                                                                                                                                                                                                               |
| IN     | String      | Type for the new Image. If it is an empty string, then [the default one]({{% relref "../../../product/operation_references/opennebula_services_configuration/oned#oned-conf" %}}) will be used. See the existing types in the [Image template reference]({{% relref "../../../product/operation_references/configuration_references/img_template#img-template" %}}). |
| IN     | Int         | Id of the snapshot to export, if -1 the current image state will be used.                                                                                                                                                                                                                                                                          |
| OUT    | Boolean     | true or false whenever is successful or not                                                                                                                                                                                                                                                                                                        |
| OUT    | Int/String  | The new allocated Image ID / The error string.<br/><br/>If the Template was cloned, the new Template ID is not returned. The Template can be found by name: “<image_name>-<image_id>”                                                                                                                                                              |
| OUT    | Int         | Error code.                                                                                                                                                                                                                                                                                                                                        |
| OUT    | Int         | ID of the Image / Datastore that caused the error.                                                                                                                                                                                                                                                                                                 |

### one.vm.disksnapshotcreate

- **Description**: Takes a new snapshot of the disk image
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | Int         | Disk ID of the disk we want to snapshot.    |
| IN     | String      | Description for the snapshot.               |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The new snapshot ID / The error string.     |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the Image that caused the error.      |

### one.vm.disksnapshotdelete

- **Description**: Deletes a disk snapshot
- **Parameters**

| Type   | Data Type   | Description                                       |
|--------|-------------|---------------------------------------------------|
| IN     | String      | The session string.                               |
| IN     | Int         | The object ID.                                    |
| IN     | Int         | Disk ID of the disk we want to delete.            |
| IN     | Int         | ID of the snapshot to be deleted.                 |
| OUT    | Boolean     | true or false whenever is successful or not       |
| OUT    | Int/String  | The ID of the snapshot deleted/ The error string. |
| OUT    | Int         | Error code.                                       |
| OUT    | Int         | ID of the Image that caused the error.            |

### one.vm.disksnapshotrevert

- **Description**: Reverts disk state to a previously taken snapshot
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | Int         | Disk ID of the disk to revert its state.    |
| IN     | Int         | Snapshot ID to revert the disk state to.    |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The snapshot ID used / The error string.    |
| OUT    | Int         | Error code.                                 |

### one.vm.disksnapshotrename

- **Description**: Renames a disk snapshot
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | VM ID.                                      |
| IN     | Int         | Disk ID.                                    |
| IN     | Int         | Snapshot ID.                                |
| IN     | String      | New snapshot name.                          |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The VM ID / The error string.               |
| OUT    | Int         | Error code.                                 |

### one.vm.attach

- **Description**: Attaches a new disk to the Virtual Machine
- **Parameters**

| Type   | Data Type   | Description                                                                                           |
|--------|-------------|-------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                   |
| IN     | Int         | The object ID.                                                                                        |
| IN     | String      | A string containing a single DISK vector attribute. Syntax can be the usual `attribute=value` or XML. |
| OUT    | Boolean     | true or false whenever is successful or not                                                           |
| OUT    | Int/String  | The VM ID / The error string.                                                                         |
| OUT    | Int         | Error code.                                                                                           |

Sample DISK vector attribute:

```none
DISK=[IMAGE_ID=42, TYPE=RBD, DEV_PREFIX=vd, SIZE=123456, TARGET=vdc]
```

### one.vm.detach

- **Description**: Detaches a disk from a Virtual Machine
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | Int         | The disk ID.                                |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The VM ID / The error string.               |
| OUT    | Int         | Error code.                                 |

### one.vm.diskresize

- **Description**: Resizes a disk of a Virtual Machine
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | Int         | The disk ID.                                |
| IN     | String      | The new size string.                        |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The VM ID / The error string.               |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the Image that caused the error.      |

### one.vm.attachnic

- **Description**: Attaches a new network interface to the Virtual Machine
- **Parameters**

| Type   | Data Type   | Description                                                                                          |
|--------|-------------|------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                  |
| IN     | Int         | The object ID.                                                                                       |
| IN     | String      | A string containing a single NIC vector attribute. Syntax can be the usual `attribute=value` or XML. |
| OUT    | Boolean     | true or false whenever is successful or not                                                          |
| OUT    | Int/String  | The VM ID / The error string.                                                                        |
| OUT    | Int         | Error code.                                                                                          |
| OUT    | Int         | ID of the Virtual Machine that caused the error.                                                     |

### one.vm.detachnic

- **Description**: Detaches a network interface from a Virtual Machine
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | Int         | The nic ID.                                 |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The VM ID / The error string.               |
| OUT    | Int         | Error code.                                 |

<a id="api-onevm-updatenic"></a>

### one.vm.updatenic

- **Description**: Updates (appends) NIC attributes
- **Parameters**

| Type   | Data Type   | Description                                                                            |
|--------|-------------|----------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                    |
| IN     | Int         | The object ID.                                                                         |
| IN     | Int         | The nic ID.                                                                            |
| IN     | String      | A string containing updated attributes for the NIC.                                    |
| IN     | Int         | Update type: **0**: Replace the whole NIC. **1**: Merge new NIC with the existing one. |
| OUT    | Boolean     | true or false whenever is successful or not                                            |
| OUT    | Int/String  | The VM ID / The error string.                                                          |
| OUT    | Int         | Error code.                                                                            |

### one.vm.attachsg

- **Description**: Attaches a security group to a network interface of a VM, if the VM is running it updates the associated rules.
- **Parameters**

| Type   | Data Type   | Description                                             |
|--------|-------------|---------------------------------------------------------|
| IN     | String      | The session string.                                     |
| IN     | Int         | The Virtual Machine ID.                                 |
| IN     | Int         | The NIC ID                                              |
| IN     | Int         | The Security Group ID, which should be added to the NIC |
| OUT    | Boolean     | true or false whenever is successful or not             |
| OUT    | Int/String  | The VM ID / The error string.                           |
| OUT    | Int         | Error code.                                             |
| OUT    | Int         | ID of the Virtual Machine that caused the error.        |

### one.vm.detachsg

- **Description**: Detaches a security group from a network interface of a VM, if the VM is running it removes the associated rules.
- **Parameters**

| Type   | Data Type   | Description                                      |
|--------|-------------|--------------------------------------------------|
| IN     | String      | The session string.                              |
| IN     | Int         | The object ID.                                   |
| IN     | Int         | The NIC ID.                                      |
| OUT    | Boolean     | true or false whenever is successful or not      |
| OUT    | Int/String  | The VM ID / The error string.                    |
| OUT    | Int         | Error code.                                      |
| OUT    | Int         | ID of the Virtual Machine that caused the error. |

### one.vm.chmod

- **Description**: Changes the permission bits of a Virtual Machine.
- **Parameters**

| Type   | Data Type   | Description                                         |
|--------|-------------|-----------------------------------------------------|
| IN     | String      | The session string.                                 |
| IN     | Int         | The object ID.                                      |
| IN     | Int         | USER USE bit. If set to -1, it will not change.     |
| IN     | Int         | USER MANAGE bit. If set to -1, it will not change.  |
| IN     | Int         | USER ADMIN bit. If set to -1, it will not change.   |
| IN     | Int         | GROUP USE bit. If set to -1, it will not change.    |
| IN     | Int         | GROUP MANAGE bit. If set to -1, it will not change. |
| IN     | Int         | GROUP ADMIN bit. If set to -1, it will not change.  |
| IN     | Int         | OTHER USE bit. If set to -1, it will not change.    |
| IN     | Int         | OTHER MANAGE bit. If set to -1, it will not change. |
| IN     | Int         | OTHER ADMIN bit. If set to -1, it will not change.  |
| OUT    | Boolean     | true or false whenever is successful or not         |
| OUT    | Int/String  | The resource ID / The error string.                 |
| OUT    | Int         | Error code.                                         |
| OUT    | Int         | ID of the object that caused the error.             |

### one.vm.chown

- **Description**: Changes the ownership of a Virtual Machine.
- **Parameters**

| Type   | Data Type   | Description                                                            |
|--------|-------------|------------------------------------------------------------------------|
| IN     | String      | The session string.                                                    |
| IN     | Int         | The object ID.                                                         |
| IN     | Int         | The User ID of the new owner. If set to -1, the owner is not changed.  |
| IN     | Int         | The Group ID of the new group. If set to -1, the group is not changed. |
| OUT    | Boolean     | true or false whenever is successful or not                            |
| OUT    | Int/String  | The resource ID / The error string.                                    |
| OUT    | Int         | Error code.                                                            |
| OUT    | Int         | ID of the object that caused the error.                                |

### one.vm.rename

- **Description**: Renames a Virtual Machine
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | String      | The new name.                               |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The VM ID / The error string.               |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.vm.snapshotcreate

- **Description**: Creates a new Virtual Machine snapshot
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | String      | The new snapshot name. It can be empty.     |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The new snapshot ID / The error string.     |
| OUT    | Int         | Error code.                                 |

### one.vm.snapshotrevert

- **Description**: Reverts a Virtual Machine to a snapshot
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | Int         | The snapshot ID.                            |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The VM ID / The error string.               |
| OUT    | Int         | Error code.                                 |

### one.vm.snapshotdelete

- **Description**: Deletes a Virtual Machine snapshot
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | Int         | The snapshot ID.                            |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The VM ID / The error string.               |
| OUT    | Int         | Error code.                                 |

### one.vm.resize

- **Description**: Changes the capacity of the Virtual Machine
- **Parameters**

| Type   | Data Type   | Description                                                                                                                                                                           |
|--------|-------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                                                                                   |
| IN     | Int         | The object ID.                                                                                                                                                                        |
| IN     | String      | Template containing the new capacity elements CPU, VCPU, MEMORY. If one of them is not present, or its value is 0, it will not be resized.                                            |
| IN     | Boolean     | true to enforce the Host capacity is not overcommitted. This parameter is only acknowledged for users in the oneadmin group, Host capacity will be always enforced for regular users. |
| OUT    | Boolean     | true or false whenever is successful or not                                                                                                                                           |
| OUT    | Int/String  | The VM ID / The error string.                                                                                                                                                         |
| OUT    | Int         | Error code.                                                                                                                                                                           |
| OUT    | Int         | ID of the Virtual Machine / Host that caused the error.                                                                                                                               |

### one.vm.update

- **Description**: Replaces the **user template** contents.
- **Parameters**

| Type   | Data Type   | Description                                                                                      |
|--------|-------------|--------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                              |
| IN     | Int         | The object ID.                                                                                   |
| IN     | String      | The new user template contents. Syntax can be the usual `attribute=value` or XML.                |
| IN     | Int         | Update type: **0**: Replace the whole template. **1**: Merge new template with the existing one. |
| OUT    | Boolean     | true or false whenever is successful or not                                                      |
| OUT    | Int/String  | The resource ID / The error string.                                                              |
| OUT    | Int         | Error code.                                                                                      |

<a id="api-onevmmupdateconf"></a>

### one.vm.updateconf

- **Description**: Updates (appends) a set of supported configuration attributes in the VM template
- **Parameters**

| Type   | Data Type   | Description                                                                                      |
|--------|-------------|--------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                              |
| IN     | Int         | The object ID.                                                                                   |
| IN     | String      | The new template contents. Syntax can be the usual `attribute=value` or XML.                     |
| IN     | Int         | Update type: **0**: Replace the whole template. **1**: Merge new template with the existing one. |
| OUT    | Boolean     | true or false whenever is successful or not                                                      |
| OUT    | Int/String  | The resource ID / The error string.                                                              |
| OUT    | Int         | Error code.                                                                                      |
| OUT    | Int         | ID of the Virtual Machine that caused the error.                                                 |

The supported attributes are:

| Attribute       | Sub-attributes                                                                                                           |
|-----------------|--------------------------------------------------------------------------------------------------------------------------|
| `OS`            | `ARCH`, `MACHINE`, `KERNEL`, `INITRD`, `BOOTLOADER`, `BOOT`,<br/>`KERNEL_CMD`, `ROOT`, `SD_DISK_BUS`, `UUID`, `FIRMWARE` |
| `CPU_MODEL`     | `MODEL`, `FEATURES`                                                                                                      |
| `FEATURES`      | `ACPI`, `PAE`, `APIC`, `LOCALTIME`, `HYPERV`, `GUEST_AGENT`,<br/>`VIRTIO_SCSI_QUEUES`, `VIRTIO_BLK_QUEUES`, `IOTHREADS`  |
| `INPUT`         | `TYPE`, `BUS`                                                                                                            |
| `GRAPHICS`      | `TYPE`, `LISTEN`, `PASSWD`, `KEYMAP`, `COMMAND`                                                                          |
| `VIDEO`         | `TYPE`, `IOMMU`, `ATS`, `VRAM`, `RESOLUTION`                                                                             |
| `RAW`           | `DATA`, `DATA_VMX`, `TYPE`, `VALIDATE`                                                                                   |
| `CONTEXT`       | Any value, except `ETH*`. **Variable substitution will be made**                                                         |
| `BACKUP_CONFIG` | `FS_FREEZE`, `KEEP_LAST`, `BACKUP_VOLATILE`, `MODE`, `INCREMENT_MODE`                                                    |

{{< alert title="Note" color="success" >}}
Visit the [Virtual Machine Template reference]({{% relref "../../../product/operation_references/configuration_references/template#template" %}}) for a complete description of each attribute{{< /alert >}} 

### one.vm.recover

- **Description**: Recovers a stuck VM that is waiting for a driver operation. The recovery may be done by failing or succeeding the pending operation. You need to manually check the vm status on the Host to decide if the operation was successful or not.
- **Parameters**

| Type   | Data Type   | Description                                                                                            |
|--------|-------------|--------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                    |
| IN     | Int         | The object ID.                                                                                         |
| IN     | Int         | Recover operation: success (1), failure (0), retry (2), delete (3), delete-recreate (4), delete-db (5) |
| OUT    | Boolean     | true or false whenever is successful or not                                                            |
| OUT    | Int/String  | The resource ID / The error string.                                                                    |
| OUT    | Int         | Error code.                                                                                            |
| OUT    | Int         | ID of the Virtual Machine that caused the error.                                                       |

### one.vm.info

- **Description**: Retrieves information for the Virtual Machine.
- **Parameters**

| Type   | Data Type   | Description                                                      |
|--------|-------------|------------------------------------------------------------------|
| IN     | String      | The session string.                                              |
| IN     | Int         | The object ID.                                                   |
| IN     | Boolean     | optional flag to decrypt contained secrets, valid only for admin |
| OUT    | Boolean     | true or false whenever is successful or not                      |
| OUT    | String      | The information string / The error string.                       |
| OUT    | Int         | Error code.                                                      |
| OUT    | Int         | ID of the VM / DS / Cluster / Host that caused the error.        |

<a id="api-onevmmonitoring"></a>

### one.vm.monitoring

- **Description**: Returns the Virtual Machine monitoring records.
- **Parameters**

| Type   | Data Type   | Description                                           |
|--------|-------------|-------------------------------------------------------|
| IN     | String      | The session string.                                   |
| IN     | Int         | The object ID.                                        |
| OUT    | Boolean     | true or false whenever is successful or not           |
| OUT    | String      | The monitoring information string / The error string. |
| OUT    | Int         | Error code.                                           |

The monitoring information returned is a list of VM elements. Each VM element contains the complete xml of the VM with the updated information returned by the poll action.

For example:

```xml
<MONITORING_DATA>
    <VM>
        ...
        <TIMESTAMP>123</TIMESTAMP>
        ...
    </VM>
    <VM>
        ...
        <TIMESTAMP>456</TIMESTAMP>
        ...
    </VM>
</MONITORING_DATA>
```

### one.vm.lock

- **Description**: Locks a Virtual Machine. Lock certain actions depending on blocking level.

> - **USE**: locks Admin, Manage and Use actions.
> - **MANAGE**: locks Manage and Use actions.
> - **ADMIN**: locks only Admin actions.
- **Parameters**

| Type   | Data Type   | Description                                                                  |
|--------|-------------|------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                          |
| IN     | Int         | The object ID.                                                               |
| IN     | Int         | Lock level: use (1), manage (2), admin (3), all (4)                          |
| IN     | Boolean     | Test: check if the object is already locked to return an error               |
| OUT    | Boolean     | true or false whenever is successful or not                                  |
| OUT    | Int         | The ID of the resource.                                                      |
| OUT    | Int         | Error code.                                                                  |
| OUT    | Int         | ID of the object that caused the error.                                      |
| OUT    | String      | Timestamp when the object was locked in case of error when using test = true |

### one.vm.unlock

- **Description**: Unlocks a Virtual Machine.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int         | The ID of the resource.                     |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.vm.schedadd

- **Description**: Add scheduled action to VM
- **Parameters**

| Type   | Data Type   | Description                                            |
|--------|-------------|--------------------------------------------------------|
| IN     | String      | The session string.                                    |
| IN     | Int         | The object ID.                                         |
| IN     | String      | Template containing the new scheduled action.          |
| OUT    | Boolean     | true or false whenever is successful or not            |
| OUT    | Int/String  | The VM ID / The error string.                          |
| OUT    | Int         | Error code.                                            |
| OUT    | Int         | ID of the Virtual Machine object that caused the error |

### one.vm.schedupdate

- **Description**: Update scheduled VM action
- **Parameters**

| Type   | Data Type   | Description                                            |
|--------|-------------|--------------------------------------------------------|
| IN     | String      | The session string.                                    |
| IN     | Int         | The object ID.                                         |
| IN     | Int         | The ID of the scheduled action.                        |
| IN     | String      | Template containing the updated scheduled action.      |
| OUT    | Boolean     | true or false whenever is successful or not            |
| OUT    | Int/String  | The VM ID / The error string.                          |
| OUT    | Int         | Error code.                                            |
| OUT    | Int         | ID of the Virtual Machine object that caused the error |

### one.vm.scheddelete

- **Description**: Delete scheduled action from VM
- **Parameters**

| Type   | Data Type   | Description                                            |
|--------|-------------|--------------------------------------------------------|
| IN     | String      | The session string.                                    |
| IN     | Int         | The object ID.                                         |
| IN     | Int         | The ID of the scheduled action.                        |
| OUT    | Boolean     | true or false whenever is successful or not            |
| OUT    | Int/String  | The VM ID / The error string.                          |
| OUT    | Int         | Error code.                                            |
| OUT    | Int         | ID of the Virtual Machine object that caused the error |

### one.vm.backup

- **Description**: Creates a new backup image for the VM
- **Parameters**

| Type   | Data Type   | Description                                            |
|--------|-------------|--------------------------------------------------------|
| IN     | String      | The session string.                                    |
| IN     | Int         | The object ID.                                         |
| IN     | Int         | The ID of the Datastore to store the backup.           |
| IN     | Boolean     | Reset flag, true to create a new incremental chain.    |
| OUT    | Boolean     | true or false whenever is successful or not            |
| OUT    | Int/String  | The VM ID / The error string.                          |
| OUT    | Int         | Error code.                                            |
| OUT    | Int         | ID of the Virtual Machine object that caused the error |

### one.vm.backupcancel

- **Description**: Try to cancel ongoing backup operation
- **Parameters**

| Type   | Data Type   | Description                                            |
|--------|-------------|--------------------------------------------------------|
| IN     | String      | The session string.                                    |
| IN     | Int         | The object ID.                                         |
| OUT    | Boolean     | true or false whenever is successful or not            |
| OUT    | Int/String  | The VM ID / The error string.                          |
| OUT    | Int         | Error code.                                            |
| OUT    | Int         | ID of the Virtual Machine object that caused the error |

### one.vm.attachpci

- **Description**: Attaches a new PCI to a Virtual Machine
- **Parameters**

| Type   | Data Type   | Description                                                                                          |
|--------|-------------|------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                  |
| IN     | Int         | The object ID.                                                                                       |
| IN     | String      | A string containing a single PCI vector attribute. Syntax can be the usual `attribute=value` or XML. |
| OUT    | Boolean     | true or false whenever is successful or not                                                          |
| OUT    | Int/String  | The VM ID / The error string.                                                                        |
| OUT    | Int         | Error code.                                                                                          |
| OUT    | Int         | ID of the Virtual Machine that caused the error.                                                     |

### one.vm.detachpci

- **Description**: Detaches a PCI from a Virtual Machine
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The Virtual Machine ID.                     |
| IN     | Int         | The PCI ID.                                 |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The VM ID / The error string.               |
| OUT    | Int         | Error code.                                 |

### one.vm.restore

- **Description**: Restore VM disks (selectively) from a backup. The VM needs to be in POWEROFF state.
- **Parameters**

| Type   | Data Type   | Description                                                                       |
|--------|-------------|-----------------------------------------------------------------------------------|
| IN     | Int         | The VM ID.                                                                        |
| IN     | Int         | The Image ID of the backup to use                                                 |
| IN     | Int         | Sets the increment to restore. Use -1 for the last increment or with full backups |
| IN     | Int         | The disk ID to restore. Use -1 to restore all disks available in the backup.      |
| OUT    | Boolean     | true or false whenever is successful or not                                       |
| OUT    | Int/String  | The VM ID / The error string.                                                     |
| OUT    | Int         | Error code.                                                                       |

### one.vmpool.info

{{< alert title="Note" color="success" >}}
Some attributes e.g. `TEMPLATE`, `USER_TEMPLATE` are limited in this call, see also `one.vmpool.infoextended`.{{< /alert >}} 

- **Description**: Retrieves information for all or part of the VMs in the pool.
- **Parameters**

| Type   | Data Type   | Description                                                                                                                                                                                                                                                       |
|--------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                                                                                                                                                               |
| IN     | Int         | Filter flag<br/><br/>* **-4**: Resources belonging to the user’s primary group<br/>* **-3**: Resources belonging to the user<br/>* **-2**: All resources<br/>* **-1**: Resources belonging to the user and any of his groups<br/>* **>= 0**: UID User’s Resources |
| IN     | Int         | When the next parameter is >= -1 this is the Range start ID.<br/>Can be -1. For smaller values this is the offset used for pagination.                                                                                                                            |
| IN     | Int         | For values >= -1 this is the Range end ID. Can be -1 to get until the<br/>last ID. For values < -1 this is the page size used for pagination.                                                                                                                     |
| IN     | Int         | VM state to filter by.                                                                                                                                                                                                                                            |
| IN     | String      | Filter in KEY=VALUE format.                                                                                                                                                                                                                                       |
| OUT    | Boolean     | true or false whenever is successful or not                                                                                                                                                                                                                       |
| OUT    | String      | Version of the VM Pool with a short VM body documents.                                                                                                                                                                                                            |
| OUT    | Int         | Error code.                                                                                                                                                                                                                                                       |
| OUT    | Int         | ID of the object that caused the error.                                                                                                                                                                                                                           |

The range can be used to retrieve a subset of the pool, from the ‘start’ to the ‘end’ ID. To retrieve the complete pool, use `(-1, -1)`; to retrieve all the pool from a specific ID to the last one, use `(<id>, -1)`, and to retrieve the first elements up to an ID, use `(0, <id>)`.

The state filter can be one of the following:

|   Value | State                     |
|---------|---------------------------|
|      -2 | Any state, including DONE |
|      -1 | Any state, except DONE    |
|       0 | INIT                      |
|       1 | PENDING                   |
|       2 | HOLD                      |
|       3 | ACTIVE                    |
|       4 | STOPPED                   |
|       5 | SUSPENDED                 |
|       6 | DONE                      |
|       8 | POWEROFF                  |
|       9 | UNDEPLOYED                |
|      10 | CLONING                   |
|      11 | CLONING_FAILURE           |

{{< alert title="Warning" color="warning" >}}
Value 7 is reserved for FAILED VMs for compatibility reasons.{{< /alert >}} 

### one.vmpool.infoextended

- **Description**: Retrieves information for all or part of the VMs in the pool.
- **Parameters**

| Type   | Data Type   | Description                                                                                                                                                                                                                                                       |
|--------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                                                                                                                                                               |
| IN     | Int         | Filter flag<br/><br/>* **-4**: Resources belonging to the user’s primary group<br/>* **-3**: Resources belonging to the user<br/>* **-2**: All resources<br/>* **-1**: Resources belonging to the user and any of his groups<br/>* **>= 0**: UID User’s Resources |
| IN     | Int         | When the next parameter is >= -1 this is the Range start ID.<br/>Can be -1. For smaller values this is the offset used for pagination.                                                                                                                            |
| IN     | Int         | For values >= -1 this is the Range end ID. Can be -1 to get until the<br/>last ID. For values < -1 this is the page size used for pagination.                                                                                                                     |
| IN     | Int         | VM state to filter by.                                                                                                                                                                                                                                            |
| IN     | String      | Filter in KEY=VALUE format.                                                                                                                                                                                                                                       |
| OUT    | Boolean     | true or false whenever is successful or not                                                                                                                                                                                                                       |
| OUT    | String      | Version of the VM Pool with a short VM body documents.                                                                                                                                                                                                            |
| OUT    | Int         | Error code.                                                                                                                                                                                                                                                       |
| OUT    | Int         | ID of the object that caused the error.                                                                                                                                                                                                                           |

The state filter can be one of the following:

|   Value | State                     |
|---------|---------------------------|
|      -2 | Any state, including DONE |
|      -1 | Any state, except DONE    |
|       0 | INIT                      |
|       1 | PENDING                   |
|       2 | HOLD                      |
|       3 | ACTIVE                    |
|       4 | STOPPED                   |
|       5 | SUSPENDED                 |
|       6 | DONE                      |
|       8 | POWEROFF                  |
|       9 | UNDEPLOYED                |
|      10 | CLONING                   |
|      11 | CLONING_FAILURE           |

{{< alert title="Warning" color="warning" >}}
Value 7 is reserved for FAILED VMs for compatibility reasons.{{< /alert >}} 

### one.vmpool.infoset

- **Description**: Retrieves information for a specific set of VMs.
- **Parameters**

| Type   | Data Type   | Description                                                                                |
|--------|-------------|--------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                        |
| IN     | String      | VMs set. A comma separated list of VMs IDs to be retrieved                                 |
| IN     | Bool        | Extended. If true the entire VM will be retrieved (similar to<br/>one.vmpool.infoextended) |
| OUT    | Boolean     | true or false whenever is successful or not                                                |
| OUT    | String      | Version of the VM Pool containing the set of VMs.                                          |
| OUT    | Int         | Error code.                                                                                |
| OUT    | Int         | ID of the object that caused the error.                                                    |

The range can be used to retrieve a subset of the pool, from the ‘start’ to the ‘end’ ID. To retrieve the complete pool, use `(-1, -1)`; to retrieve all the pool from a specific ID to the last one, use `(<id>, -1)`, and to retrieve the first elements up to an ID, use `(0, <id>)`.

### one.vmpool.monitoring

- **Description**: Returns all the Virtual Machine monitoring records.
- **Parameters**

| Type   | Data Type   | Description                                                                                                                                                                                                                                                       |
|--------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                                                                                                                                                               |
| IN     | Int         | Filter flag<br/><br/>* **-4**: Resources belonging to the user’s primary group<br/>* **-3**: Resources belonging to the user<br/>* **-2**: All resources<br/>* **-1**: Resources belonging to the user and any of his groups<br/>* **>= 0**: UID User’s Resources |
| IN     | Int         | Retrieve monitor records in the last num seconds. 0 just the<br/>last record, -1 all records.                                                                                                                                                                     |
| OUT    | Boolean     | true or false whenever is successful or not                                                                                                                                                                                                                       |
| OUT    | String      | The information string / The error string.                                                                                                                                                                                                                        |
| OUT    | Int         | Error code.                                                                                                                                                                                                                                                       |

See [one.vm.monitoring]({{% relref "#api-onevmmonitoring" %}}).

Sample output:

```xml
<MONITORING_DATA>
    <VM>
        <ID>0</ID>
        <TIMESTAMP>123</TIMESTAMP>
        ...
    </VM>
    <VM>
        <ID>0</ID>
        <TIMESTAMP>456</TIMESTAMP>
        ...
    </VM>
    <VM>
        <ID>3</ID>
        <TIMESTAMP>123</TIMESTAMP>
        ...
    </VM>
    <VM>
        <ID>3</ID>
        <TIMESTAMP>456</TIMESTAMP>
        ...
    </VM>
</MONITORING_DATA>
```

### one.vmpool.accounting

- **Description**: Returns the Virtual Machine history records.
- **Parameters**

| Type   | Data Type   | Description                                                                                                                                                                                                                                                       |
|--------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                                                                                                                                                               |
| IN     | Int         | Filter flag<br/><br/>* **-4**: Resources belonging to the user’s primary group<br/>* **-3**: Resources belonging to the user<br/>* **-2**: All resources<br/>* **-1**: Resources belonging to the user and any of his groups<br/>* **>= 0**: UID User’s Resources |
| IN     | Int         | Start time for the time interval. Can be -1, in which case the time interval won’t have a left boundary.                                                                                                                                                          |
| IN     | Int         | End time for the time interval. Can be -1, in which case the time interval won’t have a right boundary.                                                                                                                                                           |
| OUT    | Boolean     | true or false whenever is successful or not                                                                                                                                                                                                                       |
| OUT    | String      | The information string / The error string.                                                                                                                                                                                                                        |
| OUT    | Int         | Error code.                                                                                                                                                                                                                                                       |

The XML output is explained in detail in the [‘’oneacct’’ guide]({{% relref "../../../product/cloud_system_administration/multitenancy/accounting#accounting" %}}).

### one.vmpool.showback

- **Description**: Returns the Virtual Machine showback records
- **Parameters**

| Type   | Data Type   | Description                                                                                                                                                                         |
|--------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                                                                                 |
| IN     | Int         | Filter flag<br/>**- < = -3**: Connected user’s resources<br/>**- -2**: All resources<br/>**- -1**: Connected user’s and his group’s resources<br/>**- > = 0**: UID User’s Resources |
| IN     | Int         | First month for the time interval. January is 1. Can be -1, in which case the time interval won’t have a left boundary.                                                             |
| IN     | Int         | First year for the time interval. Can be -1, in which case the time interval won’t have a left boundary.                                                                            |
| IN     | Int         | Last month for the time interval. January is 1. Can be -1, in which case the time interval won’t have a right boundary.                                                             |
| IN     | Int         | Last year for the time interval. Can be -1, in which case the time interval won’t have a right boundary.                                                                            |
| OUT    | Boolean     | true or false whenever is successful or not                                                                                                                                         |
| OUT    | String      | The information string / The error string.                                                                                                                                          |
| OUT    | Int         | Error code.                                                                                                                                                                         |

The XML output will be similar to this one:

```xml
<SHOWBACK_RECORDS>

  <SHOWBACK>
    <VMID>4315</VMID>
    <VMNAME>vm_4315</VMNAME>
    <UID>2467</UID>
    <GID>102</GID>
    <UNAME>cloud_user</UNAME>
    <GNAME>vdc-test</GNAME>
    <YEAR>2014</YEAR>
    <MONTH>11</MONTH>
    <CPU_COST>13</CPU_COST>
    <MEMORY_COST>21</MEMORY_COST>
    <DISK_COST>7</DISK_COST>
    <TOTAL_COST>41</TOTAL_COST>
    <HOURS>10</HOURS>
  </SHOWBACK>

  <SHOWBACK>
    ...
  </SHOWBACK>

  ...
</SHOWBACK_RECORDS>
```

### one.vmpool.calculateshowback

- **Description**: Processes all the history records, and stores the monthly cost for each VM
- **Parameters**

| Type   | Data Type   | Description                                                                                                             |
|--------|-------------|-------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                     |
| IN     | Int         | First month for the time interval. January is 1. Can be -1, in which case the time interval won’t have a left boundary. |
| IN     | Int         | First year for the time interval. Can be -1, in which case the time interval won’t have a left boundary.                |
| IN     | Int         | Last month for the time interval. January is 1. Can be -1, in which case the time interval won’t have a right boundary. |
| IN     | Int         | Last year for the time interval. Can be -1, in which case the time interval won’t have a right boundary.                |
| OUT    | Boolean     | true or false whenever is successful or not                                                                             |
| OUT    | String      | Empty / The error string.                                                                                               |
| OUT    | Int         | Error code.                                                                                                             |

## Actions for Hosts Management

### one.host.allocate

- **Description**: Allocates a new Host in OpenNebula
- **Parameters**

| Type   | Data Type   | Description                                                                                                                               |
|--------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                                       |
| IN     | String      | Hostname of the machine we want to add                                                                                                    |
| IN     | String      | The name of the information manager (im_mad_name), this values are taken from the oned.conf with the tag name IM_MAD (name)               |
| IN     | String      | The name of the virtual machine manager mad name (vmm_mad_name), this values are taken from the oned.conf with the tag name VM_MAD (name) |
| IN     | Int         | The cluster ID. If it is -1, the default one will be used.                                                                                |
| OUT    | Boolean     | true or false whenever is successful or not                                                                                               |
| OUT    | Int/String  | The allocated Host ID / The error string.                                                                                                 |
| OUT    | Int         | Error code.                                                                                                                               |
| OUT    | Int         | ID of the Cluster that caused the error.                                                                                                  |

### one.host.delete

- **Description**: Deletes the given Host from the pool
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.host.status

- **Description**: Sets the status of the Host
- **Parameters**

| Type   | Data Type   | Description                                         |
|--------|-------------|-----------------------------------------------------|
| IN     | String      | The session string.                                 |
| IN     | Int         | The Host ID.                                        |
| IN     | Int         | 0: ENABLED<br/><br/>1: DISABLED<br/><br/>2: OFFLINE |
| OUT    | Boolean     | true or false whenever is successful or not         |
| OUT    | Int/String  | The resource ID / The error string.                 |
| OUT    | Int         | Error code.                                         |
| OUT    | Int         | ID of the host that caused the error.               |

### one.host.update

- **Description**: Replaces the Host’s template contents.
- **Parameters**

| Type   | Data Type   | Description                                                                                      |
|--------|-------------|--------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                              |
| IN     | Int         | The object ID.                                                                                   |
| IN     | String      | The new template contents. Syntax can be the usual `attribute=value` or XML.                     |
| IN     | Int         | Update type: **0**: Replace the whole template. **1**: Merge new template with the existing one. |
| OUT    | Boolean     | true or false whenever is successful or not                                                      |
| OUT    | Int/String  | The resource ID / The error string.                                                              |
| OUT    | Int         | Error code.                                                                                      |

### one.host.rename

- **Description**: Renames a Host.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | String      | The new name.                               |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The VM ID / The error string.               |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.host.info

- **Description**: Retrieves information for the Host.
- **Parameters**

| Type   | Data Type   | Description                                                      |
|--------|-------------|------------------------------------------------------------------|
| IN     | String      | The session string.                                              |
| IN     | Int         | The object ID.                                                   |
| IN     | Boolean     | optional flag to decrypt contained secrets, valid only for admin |
| OUT    | Boolean     | true or false whenever is successful or not                      |
| OUT    | String      | The information string / The error string.                       |
| OUT    | Int         | Error code.                                                      |
| OUT    | Int         | ID of the object that caused the error.                          |

<a id="api-onehostmonitoring"></a>

### one.host.monitoring

- **Description**: Returns the Host monitoring records.
- **Parameters**

| Type   | Data Type   | Description                                           |
|--------|-------------|-------------------------------------------------------|
| IN     | String      | The session string.                                   |
| IN     | Int         | The object ID.                                        |
| OUT    | Boolean     | true or false whenever is successful or not           |
| OUT    | String      | The monitoring information string / The error string. |
| OUT    | Int         | Error code.                                           |

The monitoring information returned is a list of HOST elements. Each HOST element contains the complete xml of the host with the updated information returned by the poll action.

For example:

```xml
<MONITORING_DATA>
    <HOST>
        ...
        <LAST_MON_TIME>123</LAST_MON_TIME>
        ...
    </HOST>
    <HOST>
        ...
        <LAST_MON_TIME>456</LAST_MON_TIME>
        ...
    </HOST>
</MONITORING_DATA>
```

<a id="api-hostpool-info"></a>

### one.hostpool.info

- **Description**: Retrieves information for all the Hosts in the pool.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | String      | The information string / The error string.  |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.hostpool.monitoring

- **Description**: Returns all the Host monitoring records.
- **Parameters**

| Type   | Data Type   | Description                                                                                       |
|--------|-------------|---------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                               |
| IN     | Int         | Retrieve monitor records in the last num<br/>seconds. 0 just the last record,<br/>-1 all records. |
| OUT    | Boolean     | true or false whenever is successful or not                                                       |
| OUT    | String      | The information string / The error string.                                                        |
| OUT    | Int         | Error code.                                                                                       |

Sample output:

```xml
<MONITORING_DATA>
    <HOST>
        <ID>0</ID>
        <LAST_MON_TIME>123</LAST_MON_TIME>
        ...
    </HOST>
    <HOST>
        <ID>0</ID>
        <LAST_MON_TIME>456</LAST_MON_TIME>
        ...
    </HOST>
    <HOST>
        <ID>3</ID>
        <LAST_MON_TIME>123</LAST_MON_TIME>
        ...
    </HOST>
    <HOST>
        <ID>3</ID>
        <LAST_MON_TIME>456</LAST_MON_TIME>
        ...
    </HOST>
</MONITORING_DATA>
```

## Actions for Cluster Management

### one.cluster.allocate

- **Description**: Allocates a new cluster in OpenNebula.
- **Parameters**

| Type   | Data Type   | Description                                  |
|--------|-------------|----------------------------------------------|
| IN     | String      | The session string.                          |
| IN     | String      | Name for the new cluster.                    |
| OUT    | Boolean     | true or false whenever is successful or not  |
| OUT    | Int/String  | The allocated cluster ID / The error string. |
| OUT    | Int         | Error code.                                  |
| OUT    | Int         | ID of the Cluster that caused the error.     |

### one.cluster.delete

- **Description**: Deletes the given cluster from the pool.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.cluster.update

- **Description**: Replaces the cluster template contents.
- **Parameters**

| Type   | Data Type   | Description                                                                                      |
|--------|-------------|--------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                              |
| IN     | Int         | The object ID.                                                                                   |
| IN     | String      | The new template contents. Syntax can be the usual `attribute=value` or XML.                     |
| IN     | Int         | Update type: **0**: Replace the whole template. **1**: Merge new template with the existing one. |
| OUT    | Boolean     | true or false whenever is successful or not                                                      |
| OUT    | Int/String  | The resource ID / The error string.                                                              |
| OUT    | Int         | Error code.                                                                                      |
| OUT    | Int         | ID of the Object that caused the error.                                                          |

### one.cluster.addhost

- **Description**: Adds a Host to the given cluster.
- **Parameters**

| Type   | Data Type   | Description                                   |
|--------|-------------|-----------------------------------------------|
| IN     | String      | The session string.                           |
| IN     | Int         | The cluster ID.                               |
| IN     | Int         | The host ID.                                  |
| OUT    | Boolean     | true or false whenever is successful or not   |
| OUT    | Int/String  | The resource ID / The error string.           |
| OUT    | Int         | Error code.                                   |
| OUT    | Int         | ID of the Cluster/host that caused the error. |

### one.cluster.delhost

- **Description**: Removes a Host from the given cluster.
- **Parameters**

| Type   | Data Type   | Description                                   |
|--------|-------------|-----------------------------------------------|
| IN     | String      | The session string.                           |
| IN     | Int         | The cluster ID.                               |
| IN     | Int         | The host ID.                                  |
| OUT    | Boolean     | true or false whenever is successful or not   |
| OUT    | Int/String  | The resource ID / The error string.           |
| OUT    | Int         | Error code.                                   |
| OUT    | Int         | ID of the Cluster/host that caused the error. |

### one.cluster.adddatastore

- **Description**: Adds a datastore to the given cluster.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The cluster ID.                             |
| IN     | Int         | The datastore ID.                           |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the Cluster that caused the error.    |

### one.cluster.deldatastore

- **Description**: Removes a datastore from the given cluster.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The cluster ID.                             |
| IN     | Int         | The datastore ID.                           |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the Cluster that caused the error.    |

### one.cluster.addvnet

- **Description**: Adds a vnet to the given cluster.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The cluster ID.                             |
| IN     | Int         | The vnet ID.                                |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the Cluster that caused the error.    |

### one.cluster.delvnet

- **Description**: Removes a vnet from the given cluster.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The cluster ID.                             |
| IN     | Int         | The vnet ID.                                |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the Cluster that caused the error.    |

### one.cluster.rename

- **Description**: Renames a cluster.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | String      | The new name.                               |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The VM ID / The error string.               |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the Cluster that caused the error.    |

### one.cluster.info

- **Description**: Retrieves information for the cluster.
- **Parameters**

| Type   | Data Type   | Description                                                      |
|--------|-------------|------------------------------------------------------------------|
| IN     | String      | The session string.                                              |
| IN     | Int         | The object ID.                                                   |
| IN     | Boolean     | optional flag to decrypt contained secrets, valid only for admin |
| OUT    | Boolean     | true or false whenever is successful or not                      |
| OUT    | String      | The information string / The error string.                       |
| OUT    | Int         | Error code.                                                      |
| OUT    | Int         | ID of the Cluster that caused the error.                         |

### one.clusterpool.info

- **Description**: Retrieves information for all the clusters in the pool.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | String      | The information string / The error string.  |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

## Actions for Virtual Network Management

### one.vn.allocate

- **Description**: Allocates a new Virtual Network in OpenNebula.
- **Parameters**

| Type   | Data Type   | Description                                                                                                |
|--------|-------------|------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                        |
| IN     | String      | A string containing the template of the virtual network. Syntax can be the usual `attribute=value` or XML. |
| IN     | Int         | The cluster ID. If it is -1, the default one will be used.                                                 |
| OUT    | Boolean     | true or false whenever is successful or not                                                                |
| OUT    | Int/String  | The allocated resource ID / The error string.                                                              |
| OUT    | Int         | Error code.                                                                                                |
| OUT    | Int         | ID of the Cluster that caused the error.                                                                   |

### one.vn.delete

- **Description**: Deletes the given Virtual Network from the pool.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.vn.add_ar

- **Description**: Adds address ranges to a Virtual Network.
- **Parameters**

| Type   | Data Type   | Description                                                                                         |
|--------|-------------|-----------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                 |
| IN     | Int         | The object ID.                                                                                      |
| IN     | String      | template of the address ranges to add. Syntax can be the usual `attribute=value` or XML, see below. |
| OUT    | Boolean     | true or false whenever is successful or not                                                         |
| OUT    | Int/String  | The resource ID / The error string.                                                                 |
| OUT    | Int         | Error code.                                                                                         |
| OUT    | Int         | ID of the Virtual Network that caused the error.                                                    |

Examples of valid templates:

```default
AR = [
    TYPE = IP4,
    IP = 192.168.0.5,
    SIZE = 10 ]
```

```xml
<TEMPLATE>
  <AR>
    <TYPE>IP4</TYPE>
    <IP>192.168.0.5</IP>
    <SIZE>10</SIZE>
  </AR>
</TEMPLATE>
```

### one.vn.rm_ar

- **Description**: Removes an address range from a Virtual Network.
- **Parameters**

| Type   | Data Type   | Description                                      |
|--------|-------------|--------------------------------------------------|
| IN     | String      | The session string.                              |
| IN     | Int         | The object ID.                                   |
| IN     | Int         | ID of the address range to remove.               |
| IN     | Boolean     | Optional force flag, bypass consistency checks   |
| OUT    | Boolean     | true or false whenever is successful or not      |
| OUT    | Int/String  | The resource ID / The error string.              |
| OUT    | Int         | Error code.                                      |
| OUT    | Int         | ID of the Virtual Network that caused the error. |

### one.vn.update_ar

- **Description**: Updates the attributes of an address range.
- **Parameters**

| Type   | Data Type   | Description                                                                                            |
|--------|-------------|--------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                    |
| IN     | Int         | The object ID.                                                                                         |
| IN     | String      | template of the address ranges to update. Syntax can be the usual `attribute=value` or XML, see below. |
| OUT    | Boolean     | true or false whenever is successful or not                                                            |
| OUT    | Int/String  | The resource ID / The error string.                                                                    |
| OUT    | Int         | Error code.                                                                                            |
| OUT    | Int         | ID of the Virtual Network that caused the error.                                                       |

Examples of valid templates:

```default
AR = [
    AR_ID = 7,
    GATEWAY = "192.168.30.2",
    EXTRA_ATT = "VALUE",
    SIZE = 10 ]
```

```xml
<TEMPLATE>
  <AR>
    <AR_ID>7</AR_ID>
    <GATEWAY>192.168.30.2</GATEWAY>
    <EXTRA_ATT>VALUE</EXTRA_ATT>
    <SIZE>10</SIZE>
  </AR>
</TEMPLATE>
```

### one.vn.reserve

- **Description**: Reserve network addresses.
- **Parameters**

| Type   | Data Type   | Description                                      |
|--------|-------------|--------------------------------------------------|
| IN     | String      | The session string.                              |
| IN     | Int         | The virtual network to reserve from.             |
| IN     | String      | Template, see below.                             |
| OUT    | Boolean     | true or false whenever is successful or not      |
| OUT    | Int/String  | The resource ID / The error string.              |
| OUT    | Int         | Error code.                                      |
| OUT    | Int         | ID of the Virtual Network that caused the error. |

The third parameter must be an OpenNebula ATTRIBUTE=VALUE template, with these values:

| Attribute   | Description                                                                                                            | Mandatory   |
|-------------|------------------------------------------------------------------------------------------------------------------------|-------------|
| SIZE        | Size of the reservation                                                                                                | YES         |
| NAME        | If set, the reservation will be created in a new Virtual Network with this name                                        | NO          |
| AR_ID       | ID of the AR from where to take the addresses                                                                          | NO          |
| NETWORK_ID  | Instead of creating a new Virtual Network, the reservation will be added to the existing virtual network with this ID. | NO          |
| MAC         | First MAC address to start the reservation range [MAC, MAC+SIZE)                                                       | NO          |
| IP          | First IPv4 address to start the reservation range [IP, IP+SIZE)                                                        | NO          |

### one.vn.free_ar

- **Description**: Frees a reserved address range from a Virtual Network.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | Int         | ID of the address range to free.            |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the VNet that caused the error.       |

### one.vn.hold

- **Description**: Holds a Virtual Network Lease as used.
- **Parameters**

| Type   | Data Type   | Description                                                    |
|--------|-------------|----------------------------------------------------------------|
| IN     | String      | The session string.                                            |
| IN     | Int         | The object ID.                                                 |
| IN     | String      | template of the lease to hold, e.g. `LEASES=[IP=192.168.0.5]`. |
| OUT    | Boolean     | true or false whenever is successful or not                    |
| OUT    | Int/String  | The resource ID / The error string.                            |
| OUT    | Int         | Error code.                                                    |
| OUT    | Int         | ID of the VNet that caused the error.                          |

### one.vn.release

- **Description**: Releases a Virtual Network Lease on hold.
- **Parameters**

| Type   | Data Type   | Description                                                       |
|--------|-------------|-------------------------------------------------------------------|
| IN     | String      | The session string.                                               |
| IN     | Int         | The object ID.                                                    |
| IN     | String      | template of the lease to release, e.g. `LEASES=[IP=192.168.0.5]`. |
| OUT    | Boolean     | true or false whenever is successful or not                       |
| OUT    | Int/String  | The resource ID / The error string.                               |
| OUT    | Int         | Error code.                                                       |
| OUT    | Int         | ID of the VNet that caused the error.                             |

### one.vn.update

- **Description**: Replaces the Virtual Network template contents.
- **Parameters**

| Type   | Data Type   | Description                                                                                      |
|--------|-------------|--------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                              |
| IN     | Int         | The object ID.                                                                                   |
| IN     | String      | The new template contents. Syntax can be the usual `attribute=value` or XML.                     |
| IN     | Int         | Update type: **0**: Replace the whole template. **1**: Merge new template with the existing one. |
| OUT    | Boolean     | true or false whenever is successful or not                                                      |
| OUT    | Int/String  | The resource ID / The error string.                                                              |
| OUT    | Int         | Error code.                                                                                      |
| OUT    | Int         | ID of the VNet that caused the error.                                                            |

### one.vn.chmod

- **Description**: Changes the permission bits of a Virtual Network.
- **Parameters**

| Type   | Data Type   | Description                                         |
|--------|-------------|-----------------------------------------------------|
| IN     | String      | The session string.                                 |
| IN     | Int         | The object ID.                                      |
| IN     | Int         | USER USE bit. If set to -1, it will not change.     |
| IN     | Int         | USER MANAGE bit. If set to -1, it will not change.  |
| IN     | Int         | USER ADMIN bit. If set to -1, it will not change.   |
| IN     | Int         | GROUP USE bit. If set to -1, it will not change.    |
| IN     | Int         | GROUP MANAGE bit. If set to -1, it will not change. |
| IN     | Int         | GROUP ADMIN bit. If set to -1, it will not change.  |
| IN     | Int         | OTHER USE bit. If set to -1, it will not change.    |
| IN     | Int         | OTHER MANAGE bit. If set to -1, it will not change. |
| IN     | Int         | OTHER ADMIN bit. If set to -1, it will not change.  |
| OUT    | Boolean     | true or false whenever is successful or not         |
| OUT    | Int/String  | The resource ID / The error string.                 |
| OUT    | Int         | Error code.                                         |
| OUT    | Int         | ID of the object that caused the error.             |

### one.vn.chown

- **Description**: Changes the ownership of a Virtual Network.
- **Parameters**

| Type   | Data Type   | Description                                                            |
|--------|-------------|------------------------------------------------------------------------|
| IN     | String      | The session string.                                                    |
| IN     | Int         | The object ID.                                                         |
| IN     | Int         | The User ID of the new owner. If set to -1, the owner is not changed.  |
| IN     | Int         | The Group ID of the new group. If set to -1, the group is not changed. |
| OUT    | Boolean     | true or false whenever is successful or not                            |
| OUT    | Int/String  | The resource ID / The error string.                                    |
| OUT    | Int         | Error code.                                                            |
| OUT    | Int         | ID of the object that caused the error.                                |

### one.vn.rename

- **Description**: Renames a Virtual Network.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | String      | The new name.                               |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The VM ID / The error string.               |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.vn.info

- **Description**: Retrieves information for the Virtual Network.
- **Parameters**

| Type   | Data Type   | Description                                                      |
|--------|-------------|------------------------------------------------------------------|
| IN     | String      | The session string.                                              |
| IN     | Int         | The object ID.                                                   |
| IN     | Boolean     | optional flag to decrypt contained secrets, valid only for admin |
| OUT    | Boolean     | true or false whenever is successful or not                      |
| OUT    | String      | The information string / The error string.                       |
| OUT    | Int         | Error code.                                                      |
| OUT    | Int         | ID of the object that caused the error.                          |

{{< alert title="Note" color="success" >}}
The ACL rules do not apply to VNET reservations in the same way as they do to normal VNETs and other objects. Read more in the [ACL documentation guide]({{% relref "../../../product/cloud_system_administration/multitenancy/chmod#manage-acl-vnet-reservations" %}}).{{< /alert >}} 

### one.vn.lock

- **Description**: Locks a Virtual Network. Lock certain actions depending on blocking level.

> - **USE**: locks Admin, Manage and Use actions.
> - **MANAGE**: locks Manage and Use actions.
> - **ADMIN**: locks only Admin actions.
- **Parameters**

| Type   | Data Type   | Description                                                                  |
|--------|-------------|------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                          |
| IN     | Int         | The object ID.                                                               |
| IN     | Int         | Lock level: use (1), manage (2), admin (3), all (4)                          |
| IN     | Boolean     | Test: check if the object is already locked to return an error               |
| OUT    | Boolean     | true or false whenever is successful or not                                  |
| OUT    | Int         | The ID of the resource.                                                      |
| OUT    | Int         | Error code.                                                                  |
| OUT    | Int         | ID of the Object that caused the error.                                      |
| OUT    | String      | Timestamp when the object was locked in case of error when using test = true |

### one.vn.unlock

- **Description**: Unlocks a Virtual Network.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int         | The ID of the resource.                     |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the Object that caused the error.     |

<a id="api-vn-recover"></a>

### one.vn.recover

- **Description**: Recovers a stuck Virtual Network which is waiting for a driver operation. The recovery may be done by failing or succeeding the pending operation. You need to manually check the VN status to decide if the operation was successful or not.
- **Parameters**

| Type   | Data Type   | Description                                                        |
|--------|-------------|--------------------------------------------------------------------|
| IN     | String      | The session string.                                                |
| IN     | Int         | The object ID.                                                     |
| IN     | Int         | Recover operation: success (1), failure (0), delete (2), retry (3) |
| OUT    | Boolean     | true or false whenever is successful or not                        |
| OUT    | Int/String  | The resource ID / The error string.                                |
| OUT    | Int         | Error code.                                                        |
| OUT    | Int         | ID of the Virtual Network that caused the error.                   |

### one.vnpool.info

- **Description**: Retrieves information for all or part of the Virtual Networks in the pool.
- **Parameters**

| Type   | Data Type   | Description                                                                                                                                                                                                                                                       |
|--------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                                                                                                                                                               |
| IN     | Int         | Filter flag<br/><br/>* **-4**: Resources belonging to the user’s primary group<br/>* **-3**: Resources belonging to the user<br/>* **-2**: All resources<br/>* **-1**: Resources belonging to the user and any of his groups<br/>* **>= 0**: UID User’s Resources |
| IN     | Int         | When the next parameter is >= -1 this is the Range start ID.<br/>Can be -1. For smaller values this is the offset used for pagination.                                                                                                                            |
| IN     | Int         | For values >= -1 this is the Range end ID. Can be -1 to get until the<br/>last ID. For values < -1 this is the page size used for pagination.                                                                                                                     |
| OUT    | Boolean     | true or false whenever is successful or not                                                                                                                                                                                                                       |
| OUT    | String      | The information string / The error string.                                                                                                                                                                                                                        |
| OUT    | Int         | Error code.                                                                                                                                                                                                                                                       |
| OUT    | Int         | ID of the object that caused the error.                                                                                                                                                                                                                           |

The range can be used to retrieve a subset of the pool, from the ‘start’ to the ‘end’ ID. To retrieve the complete pool, use `(-1, -1)`; to retrieve all the pool from a specific ID to the last one, use `(<id>, -1)`, and to retrieve the first elements up to an ID, use `(0, <id>)`.

{{< alert title="Note" color="success" >}}
The ACL rules do not apply to VNET reservations in the same way as they do to normal VNETs and other objects. Read more in the [ACL documentation guide]({{% relref "../../../product/cloud_system_administration/multitenancy/chmod#manage-acl-vnet-reservations" %}}).{{< /alert >}} 

## Actions for Security Group Management

### one.secgroup.allocate

- **Description**: Allocates a new security group in OpenNebula.
- **Parameters**

| Type   | Data Type   | Description                                                                                               |
|--------|-------------|-----------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                       |
| IN     | String      | A string containing the template of the security group. Syntax can be the usual `attribute=value` or XML. |
| OUT    | Boolean     | true or false whenever is successful or not                                                               |
| OUT    | Int/String  | The allocated resource ID / The error string.                                                             |
| OUT    | Int         | Error code.                                                                                               |
| OUT    | Int         | ID of the Cluster that caused the error.                                                                  |

### one.secgroup.clone

- **Description**: Clones an existing security group.
- **Parameters**

| Type   | Data Type   | Description                                      |
|--------|-------------|--------------------------------------------------|
| IN     | String      | The session string.                              |
| IN     | Int         | The ID of the security group to be cloned.       |
| IN     | String      | Name for the new security group.                 |
| OUT    | Boolean     | true or false whenever is successful or not      |
| OUT    | Int/String  | The new security group ID / The error string.    |
| OUT    | Int         | Error code.                                      |
| OUT    | Int         | ID of the original object that caused the error. |

### one.secgroup.delete

- **Description**: Deletes the given security group from the pool.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.secgroup.update

- **Description**: Replaces the security group template contents.
- **Parameters**

| Type   | Data Type   | Description                                                                                      |
|--------|-------------|--------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                              |
| IN     | Int         | The object ID.                                                                                   |
| IN     | String      | The new template contents. Syntax can be the usual `attribute=value` or XML.                     |
| IN     | Int         | Update type: **0**: Replace the whole template. **1**: Merge new template with the existing one. |
| OUT    | Boolean     | true or false whenever is successful or not                                                      |
| OUT    | Int/String  | The resource ID / The error string.                                                              |
| OUT    | Int         | Error code.                                                                                      |

### one.secgroup.commit

- **Description**: Commit security group changes to associated VMs. This is intended for retrying updates of VMs or reinitializing the updating process if oned stopped or failed after a one.secgroup.update call.
- **Parameters**

| Type   | Data Type   | Description                                                                             |
|--------|-------------|-----------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                     |
| IN     | Int         | The object ID.                                                                          |
| IN     | Boolean     | I true the action will only operate on outdated and error VMs. False to update all VMs. |
| OUT    | Boolean     | true or false whenever is successful or not                                             |
| OUT    | Int/String  | The resource ID / The error string.                                                     |
| OUT    | Int         | Error code.                                                                             |
| OUT    | Int         | ID of the object that caused the error.                                                 |

### one.secgroup.chmod

- **Description**: Changes the permission bits of a security group.
- **Parameters**

| Type   | Data Type   | Description                                         |
|--------|-------------|-----------------------------------------------------|
| IN     | String      | The session string.                                 |
| IN     | Int         | The object ID.                                      |
| IN     | Int         | USER USE bit. If set to -1, it will not change.     |
| IN     | Int         | USER MANAGE bit. If set to -1, it will not change.  |
| IN     | Int         | USER ADMIN bit. If set to -1, it will not change.   |
| IN     | Int         | GROUP USE bit. If set to -1, it will not change.    |
| IN     | Int         | GROUP MANAGE bit. If set to -1, it will not change. |
| IN     | Int         | GROUP ADMIN bit. If set to -1, it will not change.  |
| IN     | Int         | OTHER USE bit. If set to -1, it will not change.    |
| IN     | Int         | OTHER MANAGE bit. If set to -1, it will not change. |
| IN     | Int         | OTHER ADMIN bit. If set to -1, it will not change.  |
| OUT    | Boolean     | true or false whenever is successful or not         |
| OUT    | Int/String  | The resource ID / The error string.                 |
| OUT    | Int         | Error code.                                         |
| OUT    | Int         | ID of the object that caused the error.             |

### one.secgroup.chown

- **Description**: Changes the ownership of a security group.
- **Parameters**

| Type   | Data Type   | Description                                                            |
|--------|-------------|------------------------------------------------------------------------|
| IN     | String      | The session string.                                                    |
| IN     | Int         | The object ID.                                                         |
| IN     | Int         | The User ID of the new owner. If set to -1, the owner is not changed.  |
| IN     | Int         | The Group ID of the new group. If set to -1, the group is not changed. |
| OUT    | Boolean     | true or false whenever is successful or not                            |
| OUT    | Int/String  | The resource ID / The error string.                                    |
| OUT    | Int         | Error code.                                                            |
| OUT    | Int         | ID of the object that caused the error.                                |

### one.secgroup.rename

- **Description**: Renames a security group.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | String      | The new name.                               |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The VM ID / The error string.               |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.secgroup.info

- **Description**: Retrieves information for the security group.
- **Parameters**

| Type   | Data Type   | Description                                                      |
|--------|-------------|------------------------------------------------------------------|
| IN     | String      | The session string.                                              |
| IN     | Int         | The object ID.                                                   |
| IN     | Boolean     | optional flag to decrypt contained secrets, valid only for admin |
| OUT    | Boolean     | true or false whenever is successful or not                      |
| OUT    | String      | The information string / The error string.                       |
| OUT    | Int         | Error code.                                                      |
| OUT    | Int         | ID of the object that caused the error.                          |

### one.secgrouppool.info

- **Description**: Retrieves information for all or part of the security groups in the pool.
- **Parameters**

| Type   | Data Type   | Description                                                                                                                                                                                                                                                       |
|--------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                                                                                                                                                               |
| IN     | Int         | Filter flag<br/><br/>* **-4**: Resources belonging to the user’s primary group<br/>* **-3**: Resources belonging to the user<br/>* **-2**: All resources<br/>* **-1**: Resources belonging to the user and any of his groups<br/>* **>= 0**: UID User’s Resources |
| IN     | Int         | When the next parameter is >= -1 this is the Range start ID.<br/>Can be -1. For smaller values this is the offset used for pagination.                                                                                                                            |
| IN     | Int         | For values >= -1 this is the Range end ID. Can be -1 to get until the<br/>last ID. For values < -1 this is the page size used for pagination.                                                                                                                     |
| OUT    | Boolean     | true or false whenever is successful or not                                                                                                                                                                                                                       |
| OUT    | String      | The information string / The error string.                                                                                                                                                                                                                        |
| OUT    | Int         | Error code.                                                                                                                                                                                                                                                       |
| OUT    | Int         | ID of the object that caused the error.                                                                                                                                                                                                                           |
| OUT    | Int         | ID of the object that caused the error.                                                                                                                                                                                                                           |

The range can be used to retrieve a subset of the pool, from the ‘start’ to the ‘end’ ID. To retrieve the complete pool, use `(-1, -1)`; to retrieve all the pool from a specific ID to the last one, use `(<id>, -1)`, and to retrieve the first elements up to an ID, use `(0, <id>)`.

## Actions for VM Group Management

### one.vmgroup.allocate

- **Description**: Allocates a new VM group in OpenNebula.
- **Parameters**

| Type   | Data Type   | Description                                                                                         |
|--------|-------------|-----------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                 |
| IN     | String      | A string containing the template of the VM Group. Syntax can be the usual `attribute=value` or XML. |
| OUT    | Boolean     | true or false whenever is successful or not                                                         |
| OUT    | Int/String  | The allocated resource ID / The error string.                                                       |
| OUT    | Int         | Error code.                                                                                         |
| OUT    | Int         | ID of the Cluster that caused the error.                                                            |

### one.vmgroup.delete

- **Description**: Deletes the given VM group from the pool.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.vmgroup.update

- **Description**: Replaces the VM group template contents.
- **Parameters**

| Type   | Data Type   | Description                                                                                      |
|--------|-------------|--------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                              |
| IN     | Int         | The object ID.                                                                                   |
| IN     | String      | The new template contents. Syntax can be the usual `attribute=value` or XML.                     |
| IN     | Int         | Update type: **0**: Replace the whole template. **1**: Merge new template with the existing one. |
| OUT    | Boolean     | true or false whenever is successful or not                                                      |
| OUT    | Int/String  | The resource ID / The error string.                                                              |
| OUT    | Int         | Error code.                                                                                      |

### one.vmgroup.chmod

- **Description**: Changes the permission bits of a VM group.
- **Parameters**

| Type   | Data Type   | Description                                         |
|--------|-------------|-----------------------------------------------------|
| IN     | String      | The session string.                                 |
| IN     | Int         | The object ID.                                      |
| IN     | Int         | USER USE bit. If set to -1, it will not change.     |
| IN     | Int         | USER MANAGE bit. If set to -1, it will not change.  |
| IN     | Int         | USER ADMIN bit. If set to -1, it will not change.   |
| IN     | Int         | GROUP USE bit. If set to -1, it will not change.    |
| IN     | Int         | GROUP MANAGE bit. If set to -1, it will not change. |
| IN     | Int         | GROUP ADMIN bit. If set to -1, it will not change.  |
| IN     | Int         | OTHER USE bit. If set to -1, it will not change.    |
| IN     | Int         | OTHER MANAGE bit. If set to -1, it will not change. |
| IN     | Int         | OTHER ADMIN bit. If set to -1, it will not change.  |
| OUT    | Boolean     | true or false whenever is successful or not         |
| OUT    | Int/String  | The resource ID / The error string.                 |
| OUT    | Int         | Error code.                                         |
| OUT    | Int         | ID of the object that caused the error.             |

### one.vmgroup.chown

- **Description**: Changes the ownership of a VM group.
- **Parameters**

| Type   | Data Type   | Description                                                            |
|--------|-------------|------------------------------------------------------------------------|
| IN     | String      | The session string.                                                    |
| IN     | Int         | The object ID.                                                         |
| IN     | Int         | The User ID of the new owner. If set to -1, the owner is not changed.  |
| IN     | Int         | The Group ID of the new group. If set to -1, the group is not changed. |
| OUT    | Boolean     | true or false whenever is successful or not                            |
| OUT    | Int/String  | The resource ID / The error string.                                    |
| OUT    | Int         | Error code.                                                            |
| OUT    | Int         | ID of the object that caused the error.                                |

### one.vmgroup.rename

- **Description**: Renames a VM group.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | String      | The new name.                               |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The VM ID / The error string.               |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.vmgroup.info

- **Description**: Retrieves information for the VM group.
- **Parameters**

| Type   | Data Type   | Description                                                      |
|--------|-------------|------------------------------------------------------------------|
| IN     | String      | The session string.                                              |
| IN     | Int         | The object ID.                                                   |
| IN     | Boolean     | optional flag to decrypt contained secrets, valid only for admin |
| OUT    | Boolean     | true or false whenever is successful or not                      |
| OUT    | String      | The information string / The error string.                       |
| OUT    | Int         | Error code.                                                      |
| OUT    | Int         | ID of the object that caused the error.                          |

### one.vmgroup.lock

- **Description**: Locks a VM Group. Lock certain actions depending on blocking level.

> - **USE**: locks Admin, Manage and Use actions.
> - **MANAGE**: locks Manage and Use actions.
> - **ADMIN**: locks only Admin actions.
- **Parameters**

| Type   | Data Type   | Description                                                                  |
|--------|-------------|------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                          |
| IN     | Int         | The object ID.                                                               |
| IN     | Int         | Lock level: use (1), manage (2), admin (3), all (4)                          |
| IN     | Boolean     | Test: check if the object is already locked to return an error               |
| OUT    | Boolean     | true or false whenever is successful or not                                  |
| OUT    | Int         | The ID of the resource.                                                      |
| OUT    | Int         | Error code.                                                                  |
| OUT    | Int         | ID of the object that caused the error.                                      |
| OUT    | String      | Timestamp when the object was locked in case of error when using test = true |

### one.vmgroup.unlock

- **Description**: Unlocks a VM Group.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int         | The ID of the resource.                     |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.vmgroup.roleadd

- **Description**: Add role to VM Group.
- **Parameters**

| Type   | Data Type   | Description                                                                                   |
|--------|-------------|-----------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                           |
| IN     | String      | A string containing the template of the VM. Syntax can be the usual `attribute=value` or XML. |
| OUT    | Boolean     | true or false whenever is successful or not                                                   |
| OUT    | Int         | The ID of the resource.                                                                       |
| OUT    | Int         | Error code.                                                                                   |
| OUT    | Int         | ID of the object that caused the error.                                                       |

### one.vmgroup.roledelete

- **Description**: Delete role from VM Group.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | Int         | The role ID.                                |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int         | The ID of the resource.                     |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.vmgroup.roleupdate

- **Description**: Update VM Group role.
- **Parameters**

| Type   | Data Type   | Description                                                                                  |
|--------|-------------|----------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                          |
| IN     | Int         | The object ID.                                                                               |
| IN     | Int         | The role ID.                                                                                 |
| IN     | String      | A string containing updated VM Group role. Syntax can be the usual `attribute=value` or XML. |
| OUT    | Boolean     | true or false whenever is successful or not                                                  |
| OUT    | Int         | The ID of the resource.                                                                      |
| OUT    | Int         | Error code.                                                                                  |
| OUT    | Int         | ID of the object that caused the error.                                                      |

### one.vmgrouppool.info

- **Description**: Retrieves information for all or part of the VM groups in the pool.
- **Parameters**

| Type   | Data Type   | Description                                                                                                                                                                                                                                                       |
|--------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                                                                                                                                                               |
| IN     | Int         | Filter flag<br/><br/>* **-4**: Resources belonging to the user’s primary group<br/>* **-3**: Resources belonging to the user<br/>* **-2**: All resources<br/>* **-1**: Resources belonging to the user and any of his groups<br/>* **>= 0**: UID User’s Resources |
| IN     | Int         | When the next parameter is >= -1 this is the Range start ID.<br/>Can be -1. For smaller values this is the offset used for pagination.                                                                                                                            |
| IN     | Int         | For values >= -1 this is the Range end ID. Can be -1 to get until the<br/>last ID. For values < -1 this is the page size used for pagination.                                                                                                                     |
| OUT    | Boolean     | true or false whenever is successful or not                                                                                                                                                                                                                       |
| OUT    | String      | The information string / The error string.                                                                                                                                                                                                                        |
| OUT    | Int         | Error code.                                                                                                                                                                                                                                                       |
| OUT    | Int         | ID of the object that caused the error.                                                                                                                                                                                                                           |

The range can be used to retrieve a subset of the pool, from the ‘start’ to the ‘end’ ID. To retrieve the complete pool, use `(-1, -1)`; to retrieve all the pool from a specific ID to the last one, use `(<id>, -1)`, and to retrieve the first elements up to an ID, use `(0, <id>)`.

## Actions for Datastore Management

### one.datastore.allocate

- **Description**: Allocates a new datastore in OpenNebula.
- **Parameters**

| Type   | Data Type   | Description                                                                                          |
|--------|-------------|------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                  |
| IN     | String      | A string containing the template of the datastore. Syntax can be the usual `attribute=value` or XML. |
| IN     | Int         | The cluster ID. If it is -1, the default one will be used.                                           |
| OUT    | Boolean     | true or false whenever is successful or not                                                          |
| OUT    | Int/String  | The allocated resource ID / The error string.                                                        |
| OUT    | Int         | Error code.                                                                                          |
| OUT    | Int         | ID of the Cluster that caused the error.                                                             |

### one.datastore.delete

- **Description**: Deletes the given datastore from the pool.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.datastore.update

- **Description**: Replaces the datastore template contents.
- **Parameters**

| Type   | Data Type   | Description                                                                                      |
|--------|-------------|--------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                              |
| IN     | Int         | The object ID.                                                                                   |
| IN     | String      | The new template contents. Syntax can be the usual `attribute=value` or XML.                     |
| IN     | Int         | Update type: **0**: Replace the whole template. **1**: Merge new template with the existing one. |
| OUT    | Boolean     | true or false whenever is successful or not                                                      |
| OUT    | Int/String  | The resource ID / The error string.                                                              |
| OUT    | Int         | Error code.                                                                                      |

### one.datastore.chmod

- **Description**: Changes the permission bits of a datastore.
- **Parameters**

| Type   | Data Type   | Description                                         |
|--------|-------------|-----------------------------------------------------|
| IN     | String      | The session string.                                 |
| IN     | Int         | The object ID.                                      |
| IN     | Int         | USER USE bit. If set to -1, it will not change.     |
| IN     | Int         | USER MANAGE bit. If set to -1, it will not change.  |
| IN     | Int         | USER ADMIN bit. If set to -1, it will not change.   |
| IN     | Int         | GROUP USE bit. If set to -1, it will not change.    |
| IN     | Int         | GROUP MANAGE bit. If set to -1, it will not change. |
| IN     | Int         | GROUP ADMIN bit. If set to -1, it will not change.  |
| IN     | Int         | OTHER USE bit. If set to -1, it will not change.    |
| IN     | Int         | OTHER MANAGE bit. If set to -1, it will not change. |
| IN     | Int         | OTHER ADMIN bit. If set to -1, it will not change.  |
| OUT    | Boolean     | true or false whenever is successful or not         |
| OUT    | Int/String  | The resource ID / The error string.                 |
| OUT    | Int         | Error code.                                         |
| OUT    | Int         | ID of the object that caused the error.             |

### one.datastore.chown

- **Description**: Changes the ownership of a datastore.
- **Parameters**

| Type   | Data Type   | Description                                                            |
|--------|-------------|------------------------------------------------------------------------|
| IN     | String      | The session string.                                                    |
| IN     | Int         | The object ID.                                                         |
| IN     | Int         | The User ID of the new owner. If set to -1, the owner is not changed.  |
| IN     | Int         | The Group ID of the new group. If set to -1, the group is not changed. |
| OUT    | Boolean     | true or false whenever is successful or not                            |
| OUT    | Int/String  | The resource ID / The error string.                                    |
| OUT    | Int         | Error code.                                                            |
| OUT    | Int         | ID of the object that caused the error.                                |

### one.datastore.rename

- **Description**: Renames a datastore.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | String      | The new name.                               |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.datastore.enable

- **Description**: Enables or disables a datastore.
- **Parameters**

| Type   | Data Type   | Description                                  |
|--------|-------------|----------------------------------------------|
| IN     | String      | The session string.                          |
| IN     | Int         | The object ID.                               |
| IN     | Boolean     | True for enabling, false for disabling.      |
| OUT    | Boolean     | true or false whenever is successful or not. |
| OUT    | Int/String  | The resource ID / The error string.          |
| OUT    | Int         | Error code.                                  |
| OUT    | Int         | ID of the Datastore that caused the error.   |

### one.datastore.info

- **Description**: Retrieves information for the datastore.
- **Parameters**

| Type   | Data Type   | Description                                                      |
|--------|-------------|------------------------------------------------------------------|
| IN     | String      | The session string.                                              |
| IN     | Int         | The object ID.                                                   |
| IN     | Boolean     | optional flag to decrypt contained secrets, valid only for admin |
| OUT    | Boolean     | true or false whenever is successful or not                      |
| OUT    | String      | The information string / The error string.                       |
| OUT    | Int         | Error code.                                                      |
| OUT    | Int         | ID of the object that caused the error.                          |

### one.datastorepool.info

- **Description**: Retrieves information for all or part of the datastores in the pool.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | String      | The information string / The error string.  |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

## Actions for Image Management

### one.image.allocate

- **Description**: Allocates a new image in OpenNebula.
- **Parameters**

| Type   | Data Type   | Description                                                                                      |
|--------|-------------|--------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                              |
| IN     | String      | A string containing the template of the image. Syntax can be the usual `attribute=value` or XML. |
| IN     | Int         | The datastore ID.                                                                                |
| IN     | Boolean     | true to avoid checking datastore capacity. Only for admins.                                      |
| OUT    | Boolean     | true or false whenever is successful or not                                                      |
| OUT    | Int/String  | The allocated resource ID / The error string.                                                    |
| OUT    | Int         | Error code.                                                                                      |
| OUT    | Int         | ID of the Datastore that caused the error.                                                       |

### one.image.clone

- **Description**: Clones an existing image.
- **Parameters**

| Type   | Data Type   | Description                                                                        |
|--------|-------------|------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                |
| IN     | Int         | The ID of the image to be cloned.                                                  |
| IN     | String      | Name for the new image.                                                            |
| IN     | Int         | The ID of the target datastore. Optional, can be set to -1 to use the current one. |
| OUT    | Boolean     | true or false whenever is successful or not                                        |
| OUT    | Int/String  | The new image ID / The error string.                                               |
| OUT    | Int         | Error code.                                                                        |
| OUT    | Int         | ID of the original Image / DS or destination DS that caused the error.             |

### one.image.delete

- **Description**: Deletes the given image from the pool.
- **Parameters**

| Type   | Data Type   | Description                                                        |
|--------|-------------|--------------------------------------------------------------------|
| IN     | String      | The session string.                                                |
| IN     | Int         | The object ID.                                                     |
| IN     | Boolean     | Force flag, remove the Image even if the DS delete operation fails |
| OUT    | Boolean     | true or false whenever is successful or not                        |
| OUT    | Int/String  | The resource ID / The error string.                                |
| OUT    | Int         | Error code.                                                        |
| OUT    | Int         | ID of the object that caused the error.                            |

### one.image.enable

- **Description**: Enables or disables an image.
- **Parameters**

| Type   | Data Type   | Description                                  |
|--------|-------------|----------------------------------------------|
| IN     | String      | The session string.                          |
| IN     | Int         | The Image ID.                                |
| IN     | Boolean     | True for enabling, false for disabling.      |
| OUT    | Boolean     | true or false whenever is successful or not. |
| OUT    | Int/String  | The Image ID / The error string.             |
| OUT    | Int         | Error code.                                  |

### one.image.persistent

- **Description**: Sets the Image as persistent or not persistent.
- **Parameters**

| Type   | Data Type   | Description                                   |
|--------|-------------|-----------------------------------------------|
| IN     | String      | The session string.                           |
| IN     | Int         | The Image ID.                                 |
| IN     | Boolean     | True for persistent, false for non-persisent. |
| OUT    | Boolean     | true or false whenever is successful or not.  |
| OUT    | Int/String  | The Image ID / The error string.              |
| OUT    | Int         | Error code.                                   |
| OUT    | Int         | ID of the image that caused the error.        |

### one.image.chtype

- **Description**: Changes the type of an Image.
- **Parameters**

| Type   | Data Type   | Description                                                                                                                                                                         |
|--------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                                                                                 |
| IN     | Int         | The Image ID.                                                                                                                                                                       |
| IN     | String      | New type for the Image. See the existing types in the [Image template reference]({{% relref "../../../product/operation_references/configuration_references/img_template#img-template" %}}). |
| OUT    | Boolean     | true or false whenever is successful or not.                                                                                                                                        |
| OUT    | Int/String  | The Image ID / The error string.                                                                                                                                                    |
| OUT    | Int         | Error code.                                                                                                                                                                         |
| OUT    | Int         | ID of the image that caused the error.                                                                                                                                              |

### one.image.update

- **Description**: Replaces the image template contents.
- **Parameters**

| Type   | Data Type   | Description                                                                                      |
|--------|-------------|--------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                              |
| IN     | Int         | The object ID.                                                                                   |
| IN     | String      | The new template contents. Syntax can be the usual `attribute=value` or XML.                     |
| IN     | Int         | Update type: **0**: Replace the whole template. **1**: Merge new template with the existing one. |
| OUT    | Boolean     | true or false whenever is successful or not                                                      |
| OUT    | Int/String  | The resource ID / The error string.                                                              |
| OUT    | Int         | Error code.                                                                                      |

### one.image.chmod

- **Description**: Changes the permission bits of an image.
- **Parameters**

| Type   | Data Type   | Description                                         |
|--------|-------------|-----------------------------------------------------|
| IN     | String      | The session string.                                 |
| IN     | Int         | The object ID.                                      |
| IN     | Int         | USER USE bit. If set to -1, it will not change.     |
| IN     | Int         | USER MANAGE bit. If set to -1, it will not change.  |
| IN     | Int         | USER ADMIN bit. If set to -1, it will not change.   |
| IN     | Int         | GROUP USE bit. If set to -1, it will not change.    |
| IN     | Int         | GROUP MANAGE bit. If set to -1, it will not change. |
| IN     | Int         | GROUP ADMIN bit. If set to -1, it will not change.  |
| IN     | Int         | OTHER USE bit. If set to -1, it will not change.    |
| IN     | Int         | OTHER MANAGE bit. If set to -1, it will not change. |
| IN     | Int         | OTHER ADMIN bit. If set to -1, it will not change.  |
| OUT    | Boolean     | true or false whenever is successful or not         |
| OUT    | Int/String  | The resource ID / The error string.                 |
| OUT    | Int         | Error code.                                         |
| OUT    | Int         | ID of the object that caused the error.             |

### one.image.chown

- **Description**: Changes the ownership of an image.
- **Parameters**

| Type   | Data Type   | Description                                                            |
|--------|-------------|------------------------------------------------------------------------|
| IN     | String      | The session string.                                                    |
| IN     | Int         | The object ID.                                                         |
| IN     | Int         | The User ID of the new owner. If set to -1, the owner is not changed.  |
| IN     | Int         | The Group ID of the new group. If set to -1, the group is not changed. |
| OUT    | Boolean     | true or false whenever is successful or not                            |
| OUT    | Int/String  | The resource ID / The error string.                                    |
| OUT    | Int         | Error code.                                                            |
| OUT    | Int         | ID of the object that caused the error.                                |

### one.image.rename

- **Description**: Renames an image.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | String      | The new name.                               |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The VM ID / The error string.               |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.image.snapshotdelete

- **Description**: Deletes a snapshot from the image
- **Parameters**

| Type   | Data Type   | Description                                  |
|--------|-------------|----------------------------------------------|
| IN     | String      | The session string.                          |
| IN     | Int         | The object ID.                               |
| IN     | Int         | ID of the snapshot to delete                 |
| OUT    | Boolean     | true or false whenever is successful or not  |
| OUT    | Int/String  | ID of the deleted snapshot/The error string. |
| OUT    | Int         | Error code.                                  |

### one.image.snapshotrevert

- **Description**: Reverts image state to a previous snapshot
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | Int         | ID of the snapshot to revert to             |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | ID of the snapshot/The error string.        |
| OUT    | Int         | Error code.                                 |

### one.image.snapshotflatten

- **Description**: Flattens the snapshot of image and discards others
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | Int         | ID of the snapshot to flatten               |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | ID of the snapshot/The error string.        |
| OUT    | Int         | Error code.                                 |

### one.image.info

- **Description**: Retrieves information for the image.
- **Parameters**

| Type   | Data Type   | Description                                                      |
|--------|-------------|------------------------------------------------------------------|
| IN     | String      | The session string.                                              |
| IN     | Int         | The object ID.                                                   |
| IN     | Boolean     | optional flag to decrypt contained secrets, valid only for admin |
| OUT    | Boolean     | true or false whenever is successful or not                      |
| OUT    | String      | The information string / The error string.                       |
| OUT    | Int         | Error code.                                                      |
| OUT    | Int         | ID of the object that caused the error.                          |

### one.image.lock

- **Description**: Locks an Image. Lock certain actions depending on blocking level

> - **USE**: locks Admin, Manage and Use actions.
> - **MANAGE**: locks Manage and Use actions.
> - **ADMIN**: locks only Admin actions.
- **Parameters**

| Type   | Data Type   | Description                                                                  |
|--------|-------------|------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                          |
| IN     | Int         | The object ID.                                                               |
| IN     | Int         | Lock level: use (1), manage (2), admin (3), all (4)                          |
| IN     | Boolean     | Test: check if the object is already locked to return an error               |
| OUT    | Boolean     | true or false whenever is successful or not                                  |
| OUT    | Int         | The ID of the resource.                                                      |
| OUT    | Int         | Error code.                                                                  |
| OUT    | Int         | ID of the object that caused the error.                                      |
| OUT    | String      | Timestamp when the object was locked in case of error when using test = true |

### one.image.unlock

- **Description**: Unlocks an Image.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int         | The ID of the resource.                     |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.image.restore

- **Description**: Restores a VM backup
- **Parameters**

| Type   | Data Type   | Description                                                                                                                                                                                                                                                                                                                                            |
|--------|-------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                                                                                                                                                                                                                                                    |
| IN     | Int         | The object ID.                                                                                                                                                                                                                                                                                                                                         |
| IN     | Int         | Datastore ID to store the disk images restored from the backup                                                                                                                                                                                                                                                                                         |
| IN     | String      | Template (KEY=VALUE) with restore options:<br/>: - NO_IP (YES/NO) to restore IP and MAC addresses<br/>  - NO_NIC (YES/NO) to restore NIC attributes<br/>  - NAME (string) name of the restored template and image<br/>  - INCREMENT_ID (int) id of the incremental backup<br/>  - DISK_ID (int) ID of the disk to restore, do not restore the template |
| OUT    | Boolean     | true or false whenever is successful or not                                                                                                                                                                                                                                                                                                            |
| OUT    | String      | Blank separated list of restored objects IDs. The first one is the VM Template ID.                                                                                                                                                                                                                                                                     |
| OUT    | Int         | Error code.                                                                                                                                                                                                                                                                                                                                            |
| OUT    | Int         | ID of the object that caused the error.                                                                                                                                                                                                                                                                                                                |

### one.imagepool.info

- **Description**: Retrieves information for all or part of the images in the pool.
- **Parameters**

| Type   | Data Type   | Description                                                                                                                                                                                                                                                       |
|--------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                                                                                                                                                               |
| IN     | Int         | Filter flag<br/><br/>* **-4**: Resources belonging to the user’s primary group<br/>* **-3**: Resources belonging to the user<br/>* **-2**: All resources<br/>* **-1**: Resources belonging to the user and any of his groups<br/>* **>= 0**: UID User’s Resources |
| IN     | Int         | When the next parameter is >= -1 this is the Range start ID.<br/>Can be -1. For smaller values this is the offset used for pagination.                                                                                                                            |
| IN     | Int         | For values >= -1 this is the Range end ID. Can be -1 to get until the<br/>last ID. For values < -1 this is the page size used for pagination.                                                                                                                     |
| OUT    | Boolean     | true or false whenever is successful or not                                                                                                                                                                                                                       |
| OUT    | String      | The information string / The error string.                                                                                                                                                                                                                        |
| OUT    | Int         | Error code.                                                                                                                                                                                                                                                       |
| OUT    | Int         | ID of the object that caused the error.                                                                                                                                                                                                                           |

The range can be used to retrieve a subset of the pool, from the ‘start’ to the ‘end’ ID. To retrieve the complete pool, use `(-1, -1)`; to retrieve all the pool from a specific ID to the last one, use `(<id>, -1)`, and to retrieve the first elements up to an ID, use `(0, <id>)`.

## Actions for Marketplace Management

### one.market.allocate

- **Description**: Allocates a new Marketplace in OpenNebula.
- **Parameters**

| Type   | Data Type   | Description                                                                                            |
|--------|-------------|--------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                    |
| IN     | String      | A string containing the template of the marketplace. Syntax can be the usual `attribute=value` or XML. |
| OUT    | Boolean     | true or false whenever is successful or not                                                            |
| OUT    | Int/String  | The allocated resource ID / The error string.                                                          |
| OUT    | Int         | Error code.                                                                                            |
| OUT    | Int         | ID of the Cluster that caused the error.                                                               |

### one.market.delete

- **Description**: Deletes the given Marketplace from the pool.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.market.update

- **Description**: Replaces the Marketplace template contents.
- **Parameters**

| Type   | Data Type   | Description                                                                                      |
|--------|-------------|--------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                              |
| IN     | Int         | The object ID.                                                                                   |
| IN     | String      | The new template contents. Syntax can be the usual `attribute=value` or XML.                     |
| IN     | Int         | Update type: **0**: Replace the whole template. **1**: Merge new template with the existing one. |
| OUT    | Boolean     | true or false whenever is successful or not                                                      |
| OUT    | Int/String  | The resource ID / The error string.                                                              |
| OUT    | Int         | Error code.                                                                                      |

### one.market.chmod

- **Description**: Changes the permission bits of a Marketplace.
- **Parameters**

| Type   | Data Type   | Description                                         |
|--------|-------------|-----------------------------------------------------|
| IN     | String      | The session string.                                 |
| IN     | Int         | The object ID.                                      |
| IN     | Int         | USER USE bit. If set to -1, it will not change.     |
| IN     | Int         | USER MANAGE bit. If set to -1, it will not change.  |
| IN     | Int         | USER ADMIN bit. If set to -1, it will not change.   |
| IN     | Int         | GROUP USE bit. If set to -1, it will not change.    |
| IN     | Int         | GROUP MANAGE bit. If set to -1, it will not change. |
| IN     | Int         | GROUP ADMIN bit. If set to -1, it will not change.  |
| IN     | Int         | OTHER USE bit. If set to -1, it will not change.    |
| IN     | Int         | OTHER MANAGE bit. If set to -1, it will not change. |
| IN     | Int         | OTHER ADMIN bit. If set to -1, it will not change.  |
| OUT    | Boolean     | true or false whenever is successful or not         |
| OUT    | Int/String  | The resource ID / The error string.                 |
| OUT    | Int         | Error code.                                         |
| OUT    | Int         | ID of the object that caused the error.             |

### one.market.chown

- **Description**: Changes the ownership of a Marketplace.
- **Parameters**

| Type   | Data Type   | Description                                                            |
|--------|-------------|------------------------------------------------------------------------|
| IN     | String      | The session string.                                                    |
| IN     | Int         | The object ID.                                                         |
| IN     | Int         | The User ID of the new owner. If set to -1, the owner is not changed.  |
| IN     | Int         | The Group ID of the new group. If set to -1, the group is not changed. |
| OUT    | Boolean     | true or false whenever is successful or not                            |
| OUT    | Int/String  | The resource ID / The error string.                                    |
| OUT    | Int         | Error code.                                                            |
| OUT    | Int         | ID of the object that caused the error.                                |

### one.market.rename

- **Description**: Renames a Marketplace.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | String      | The new name.                               |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.market.enable

- **Description**: Enable/disable the Marketplace.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The Marketplace ID.                         |
| IN     | Boolean     | True for enabling, false for disabling.     |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.market.info

- **Description**: Retrieves information for the Marketplace.
- **Parameters**

| Type   | Data Type   | Description                                                      |
|--------|-------------|------------------------------------------------------------------|
| IN     | String      | The session string.                                              |
| IN     | Int         | The object ID.                                                   |
| IN     | Boolean     | optional flag to decrypt contained secrets, valid only for admin |
| OUT    | Boolean     | true or false whenever is successful or not                      |
| OUT    | String      | The information string / The error string.                       |
| OUT    | Int         | Error code.                                                      |
| OUT    | Int         | ID of the object that caused the error.                          |

### one.marketpool.info

- **Description**: Retrieves information for all or part of the Marketplaces in the pool.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | String      | The information string / The error string.  |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

## Actions for MarketplaceApp Management

### one.marketapp.allocate

- **Description**: Allocates a new Marketplace app in OpenNebula.
- **Parameters**

| Type   | Data Type   | Description                                                                                                |
|--------|-------------|------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                        |
| IN     | String      | A string containing the template of the marketplace app. Syntax can be the usual `attribute=value` or XML. |
| IN     | Int         | The Marketplace ID.                                                                                        |
| OUT    | Boolean     | true or false whenever is successful or not                                                                |
| OUT    | Int/String  | The allocated resource ID / The error string.                                                              |
| OUT    | Int         | Error code.                                                                                                |
| OUT    | Int         | ID of the Cluster that caused the error.                                                                   |

### one.marketapp.delete

- **Description**: Deletes the given Marketplace app from the pool.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.marketapp.enable

- **Description**: Enables or disables a Marketplace app.
- **Parameters**

| Type   | Data Type   | Description                                  |
|--------|-------------|----------------------------------------------|
| IN     | String      | The session string.                          |
| IN     | Int         | The marketplace app ID.                      |
| IN     | Boolean     | True for enabling, false for disabling.      |
| OUT    | Boolean     | true or false whenever is successful or not. |
| OUT    | Int/String  | The marketplace app ID / The error string.   |
| OUT    | Int         | Error code.                                  |
| OUT    | Int         | ID of the market that caused the error.      |

### one.marketapp.update

- **Description**: Replaces the Marketplace app template contents.
- **Parameters**

| Type   | Data Type   | Description                                                                                      |
|--------|-------------|--------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                              |
| IN     | Int         | The object ID.                                                                                   |
| IN     | String      | The new template contents. Syntax can be the usual `attribute=value` or XML.                     |
| IN     | Int         | Update type: **0**: Replace the whole template. **1**: Merge new template with the existing one. |
| OUT    | Boolean     | true or false whenever is successful or not                                                      |
| OUT    | Int/String  | The resource ID / The error string.                                                              |
| OUT    | Int         | Error code.                                                                                      |

### one.marketapp.chmod

- **Description**: Changes the permission bits of a Marketplace app.
- **Parameters**

| Type   | Data Type   | Description                                         |
|--------|-------------|-----------------------------------------------------|
| IN     | String      | The session string.                                 |
| IN     | Int         | The object ID.                                      |
| IN     | Int         | USER USE bit. If set to -1, it will not change.     |
| IN     | Int         | USER MANAGE bit. If set to -1, it will not change.  |
| IN     | Int         | USER ADMIN bit. If set to -1, it will not change.   |
| IN     | Int         | GROUP USE bit. If set to -1, it will not change.    |
| IN     | Int         | GROUP MANAGE bit. If set to -1, it will not change. |
| IN     | Int         | GROUP ADMIN bit. If set to -1, it will not change.  |
| IN     | Int         | OTHER USE bit. If set to -1, it will not change.    |
| IN     | Int         | OTHER MANAGE bit. If set to -1, it will not change. |
| IN     | Int         | OTHER ADMIN bit. If set to -1, it will not change.  |
| OUT    | Boolean     | true or false whenever is successful or not         |
| OUT    | Int/String  | The resource ID / The error string.                 |
| OUT    | Int         | Error code.                                         |
| OUT    | Int         | ID of the object that caused the error.             |

### one.marketapp.chown

- **Description**: Changes the ownership of a Marketplace app.
- **Parameters**

| Type   | Data Type   | Description                                                            |
|--------|-------------|------------------------------------------------------------------------|
| IN     | String      | The session string.                                                    |
| IN     | Int         | The object ID.                                                         |
| IN     | Int         | The User ID of the new owner. If set to -1, the owner is not changed.  |
| IN     | Int         | The Group ID of the new group. If set to -1, the group is not changed. |
| OUT    | Boolean     | true or false whenever is successful or not                            |
| OUT    | Int/String  | The resource ID / The error string.                                    |
| OUT    | Int         | Error code.                                                            |
| OUT    | Int         | ID of the object that caused the error.                                |

### one.marketapp.rename

- **Description**: Renames a Marketplace app.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | String      | The new name.                               |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The VM ID / The error string.               |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.marketapp.info

- **Description**: Retrieves information for the Marketplace app.
- **Parameters**

| Type   | Data Type   | Description                                                      |
|--------|-------------|------------------------------------------------------------------|
| IN     | String      | The session string.                                              |
| IN     | Int         | The object ID.                                                   |
| IN     | Boolean     | optional flag to decrypt contained secrets, valid only for admin |
| OUT    | Boolean     | true or false whenever is successful or not                      |
| OUT    | String      | The information string / The error string.                       |
| OUT    | Int         | Error code.                                                      |
| OUT    | Int         | ID of the object that caused the error.                          |

### one.marketapp.lock

- **Description**: Locks a Marketplace app. Lock certain actions depending on blocking level

> - **USE**: locks Admin, Manage and Use actions.
> - **MANAGE**: locks Manage and Use actions.
> - **ADMIN**: locks only Admin actions.
- **Parameters**

| Type   | Data Type   | Description                                                                  |
|--------|-------------|------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                          |
| IN     | Int         | The object ID.                                                               |
| IN     | Int         | Lock level: use (1), manage (2), admin (3), all (4)                          |
| IN     | Boolean     | Test: check if the object is already locked to return an error               |
| OUT    | Boolean     | true or false whenever is successful or not                                  |
| OUT    | Int         | The ID of the resource.                                                      |
| OUT    | Int         | Error code.                                                                  |
| OUT    | Int         | ID of the object that caused the error.                                      |
| OUT    | String      | Timestamp when the object was locked in case of error when using test = true |

### one.marketapp.unlock

- **Description**: Unlocks a Marketplace app.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int         | The ID of the resource.                     |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.marketapppool.info

- **Description**: Retrieves information for all or part of the Marketplace apps in the pool.
- **Parameters**

| Type   | Data Type   | Description                                                                                                                                                                                                                                                       |
|--------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                                                                                                                                                               |
| IN     | Int         | Filter flag<br/><br/>* **-4**: Resources belonging to the user’s primary group<br/>* **-3**: Resources belonging to the user<br/>* **-2**: All resources<br/>* **-1**: Resources belonging to the user and any of his groups<br/>* **>= 0**: UID User’s Resources |
| IN     | Int         | When the next parameter is >= -1 this is the Range start ID.<br/>Can be -1. For smaller values this is the offset used for pagination.                                                                                                                            |
| IN     | Int         | For values >= -1 this is the Range end ID. Can be -1 to get until the<br/>last ID. For values < -1 this is the page size used for pagination.                                                                                                                     |
| OUT    | Boolean     | true or false whenever is successful or not                                                                                                                                                                                                                       |
| OUT    | String      | The information string / The error string.                                                                                                                                                                                                                        |
| OUT    | Int         | Error code.                                                                                                                                                                                                                                                       |
| OUT    | Int         | ID of the object that caused the error.                                                                                                                                                                                                                           |

The range can be used to retrieve a subset of the pool, from the ‘start’ to the ‘end’ ID. To retrieve the complete pool, use `(-1, -1)`; to retrieve all the pool from a specific ID to the last one, use `(<id>, -1)`, and to retrieve the first elements up to an ID, use `(0, <id>)`.

## Actions for Virtual Routers Management

### one.vrouter.allocate

- **Description**: Allocates a new virtual router in OpenNebula.
- **Parameters**

| Type   | Data Type   | Description                                                                                        |
|--------|-------------|----------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                |
| IN     | String      | A string containing the virtual router contents. Syntax can be the usual `attribute=value` or XML. |
| OUT    | Boolean     | true or false whenever is successful or not                                                        |
| OUT    | Int/String  | The allocated resource ID / The error string.                                                      |
| OUT    | Int         | Error code.                                                                                        |
| OUT    | Int         | ID of the Cluster that caused the error.                                                           |

### one.vrouter.delete

- **Description**: Deletes the given virtual router from the pool.
- **Parameters**

| Type   | Data Type   | Description                                                       |
|--------|-------------|-------------------------------------------------------------------|
| IN     | String      | The session string.                                               |
| IN     | Int         | The object ID.                                                    |
| IN     | Boolean     | true to delete the virtual router plus any image defined in DISK. |
| OUT    | Boolean     | true or false whenever is successful or not                       |
| OUT    | Int/String  | The resource ID / The error string.                               |
| OUT    | Int         | Error code.                                                       |
| OUT    | Int         | ID of the object that caused the error.                           |

### one.vrouter.instantiate

- **Description**: Instantiates a new Virtual Machine from a virtual router.
- **Parameters**

| Type   | Data Type   | Description                                                                                                                                            |
|--------|-------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                                                    |
| IN     | Int         | The object ID.                                                                                                                                         |
| IN     | Int         | Number of VMs to instantiate.                                                                                                                          |
| IN     | Int         | VM Template id to instantiate.                                                                                                                         |
| IN     | String      | Name for the VM instances. If it is an empty string OpenNebula will set a default name. Wildcard %i can be used.                                       |
| IN     | Boolean     | False to create the VM on pending (default), True to create it on hold.                                                                                |
| IN     | String      | A string containing an extra template to be merged with the one being instantiated. It can be empty. Syntax can be the usual `attribute=value` or XML. |
| OUT    | Boolean     | true or false whenever is successful or not                                                                                                            |
| OUT    | Int/String  | ID of the Virtual Router that instantiated the VMs / The error string.                                                                                 |
| OUT    | Int         | Error code.                                                                                                                                            |
| OUT    | Int         | ID of the Virtual Router that caused the error.                                                                                                        |

Sample template string:

```none
MEMORY=4096\nCPU=4\nVCPU=4
```

{{< alert title="Note" color="success" >}}
Declaring a field overwrites the template. Thus, declaring `DISK=[...]` overwrites the template `DISK` attribute and as such, must contain the entire `DISK` definition.{{< /alert >}} 

### one.vrouter.attachnic

- **Description**: Attaches a new network interface to the virtual router and the Virtual Machines
- **Parameters**

| Type   | Data Type   | Description                                                                                          |
|--------|-------------|------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                  |
| IN     | Int         | The object ID.                                                                                       |
| IN     | String      | A string containing a single NIC vector attribute. Syntax can be the usual `attribute=value` or XML. |
| OUT    | Boolean     | true or false whenever is successful or not                                                          |
| OUT    | Int/String  | The VM ID / The error string.                                                                        |
| OUT    | Int         | Error code.                                                                                          |
| OUT    | Int         | ID of the Virtual Router that caused the error.                                                      |

### one.vrouter.detachnic

- **Description**: Detaches a network interface from the virtual router and the Virtual Machines
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | Int         | The nic ID.                                 |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The VM ID / The error string.               |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the VRouter that caused the error.    |

### one.vrouter.update

- **Description**: Replaces the template contents.
- **Parameters**

| Type   | Data Type   | Description                                                                                      |
|--------|-------------|--------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                              |
| IN     | Int         | The object ID.                                                                                   |
| IN     | String      | The new template contents. Syntax can be the usual `attribute=value` or XML.                     |
| IN     | Int         | Update type: **0**: replace the whole template. **1**: Merge new template with the existing one. |
| OUT    | Boolean     | true or false whenever is successful or not                                                      |
| OUT    | Int/String  | The resource ID / The error string.                                                              |
| OUT    | Int         | Error code.                                                                                      |

### one.vrouter.chmod

- **Description**: Changes the permission bits of a virtual router.
- **Parameters**

| Type   | Data Type   | Description                                         |
|--------|-------------|-----------------------------------------------------|
| IN     | String      | The session string.                                 |
| IN     | Int         | The object ID.                                      |
| IN     | Int         | USER USE bit. If set to -1, it will not change.     |
| IN     | Int         | USER MANAGE bit. If set to -1, it will not change.  |
| IN     | Int         | USER ADMIN bit. If set to -1, it will not change.   |
| IN     | Int         | GROUP USE bit. If set to -1, it will not change.    |
| IN     | Int         | GROUP MANAGE bit. If set to -1, it will not change. |
| IN     | Int         | GROUP ADMIN bit. If set to -1, it will not change.  |
| IN     | Int         | OTHER USE bit. If set to -1, it will not change.    |
| IN     | Int         | OTHER MANAGE bit. If set to -1, it will not change. |
| IN     | Int         | OTHER ADMIN bit. If set to -1, it will not change.  |
| OUT    | Boolean     | true or false whenever is successful or not         |
| OUT    | Int/String  | The resource ID / The error string.                 |
| OUT    | Int         | Error code.                                         |
| OUT    | Int         | ID of the object that caused the error.             |

### one.vrouter.chown

- **Description**: Changes the ownership of a virtual router.
- **Parameters**

| Type   | Data Type   | Description                                                            |
|--------|-------------|------------------------------------------------------------------------|
| IN     | String      | The session string.                                                    |
| IN     | Int         | The object ID.                                                         |
| IN     | Int         | The User ID of the new owner. If set to -1, the owner is not changed.  |
| IN     | Int         | The Group ID of the new group. If set to -1, the group is not changed. |
| OUT    | Boolean     | true or false whenever is successful or not                            |
| OUT    | Int/String  | The resource ID / The error string.                                    |
| OUT    | Int         | Error code.                                                            |
| OUT    | Int         | ID of the object that caused the error.                                |

### one.vrouter.rename

- **Description**: Renames a virtual router.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | String      | The new name.                               |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The VM ID / The error string.               |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.vrouter.info

- **Description**: Retrieves information for the virtual router.
- **Parameters**

| Type   | Data Type   | Description                                                      |
|--------|-------------|------------------------------------------------------------------|
| IN     | String      | The session string.                                              |
| IN     | Int         | The object ID.                                                   |
| IN     | Boolean     | optional flag to decrypt contained secrets, valid only for admin |
| OUT    | Boolean     | true or false whenever is successful or not                      |
| OUT    | String      | The information string / The error string.                       |
| OUT    | Int         | Error code.                                                      |
| OUT    | Int         | ID of the object that caused the error.                          |

### one.vrouter.lock

- **Description**: Locks a virtual router. Lock certain actions depending on blocking level

> - **USE**: locks Admin, Manage and Use actions.
> - **MANAGE**: locks Manage and Use actions.
> - **ADMIN**: locks only Admin actions.
- **Parameters**

| Type   | Data Type   | Description                                                                  |
|--------|-------------|------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                          |
| IN     | Int         | The object ID.                                                               |
| IN     | Int         | Lock level: use (1), manage (2), admin (3), all (4)                          |
| IN     | Boolean     | Test: check if the object is already locked to return an error               |
| OUT    | Boolean     | true or false whenever is successful or not                                  |
| OUT    | Int         | The ID of the resource.                                                      |
| OUT    | Int         | Error code.                                                                  |
| OUT    | Int         | ID of the object that caused the error.                                      |
| OUT    | String      | Timestamp when the object was locked in case of error when using test = true |

### one.vrouter.unlock

- **Description**: Unlocks a virtual router.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int         | The ID of the resource.                     |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.vrouterpool.info

- **Description**: Retrieves information for all or part of the resources in the pool.
- **Parameters**

| Type   | Data Type   | Description                                                                                                                                                                                                                                                       |
|--------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                                                                                                                                                               |
| IN     | Int         | Filter flag<br/><br/>* **-4**: Resources belonging to the user’s primary group<br/>* **-3**: Resources belonging to the user<br/>* **-2**: All resources<br/>* **-1**: Resources belonging to the user and any of his groups<br/>* **>= 0**: UID User’s Resources |
| IN     | Int         | When the next parameter is >= -1 this is the Range start ID.<br/>Can be -1. For smaller values this is the offset used for pagination.                                                                                                                            |
| IN     | Int         | For values >= -1 this is the Range end ID. Can be -1 to get until the<br/>last ID. For values < -1 this is the page size used for pagination.                                                                                                                     |
| OUT    | Boolean     | true or false whenever is successful or not                                                                                                                                                                                                                       |
| OUT    | String      | The information string / The error string.                                                                                                                                                                                                                        |
| OUT    | Int         | Error code.                                                                                                                                                                                                                                                       |
| OUT    | Int         | ID of the object that caused the error.                                                                                                                                                                                                                           |

The range can be used to retrieve a subset of the pool, from the ‘start’ to the ‘end’ ID. To retrieve the complete pool, use `(-1, -1)`; to retrieve all the pool from a specific ID to the last one, use `(<id>, -1)`, and to retrieve the first elements up to an ID, use `(0, <id>)`.

## Actions for User Management

### one.user.allocate

- **Description**: Allocates a new user in OpenNebula
- **Parameters**

| Type   | Data Type   | Description                                                                                                                            |
|--------|-------------|----------------------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                                    |
| IN     | String      | username for the new user                                                                                                              |
| IN     | String      | password for the new user                                                                                                              |
| IN     | String      | authentication driver for the new user. If it is an empty string, then the default (‘core’) is used                                    |
| IN     | Array       | array of Group IDs. The first ID will be used as the main group. This array can be empty, in which case the default group will be used |
| OUT    | Boolean     | true or false whenever is successful or not                                                                                            |
| OUT    | Int/String  | The allocated User ID / The error string.                                                                                              |
| OUT    | Int         | Error code.                                                                                                                            |
| OUT    | Int         | ID of the Group that caused the error.                                                                                                 |

### one.user.delete

- **Description**: Deletes the given user from the pool.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.user.passwd

- **Description**: Changes the password for the given user.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | String      | The new password                            |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The User ID / The error string.             |
| OUT    | Int         | Error code.                                 |

### one.user.login

- **Description**: Generates or sets a login token.
- **Parameters**

| Type   | Data Type   | Description                                                                               |
|--------|-------------|-------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                       |
| IN     | String      | The user name to generate the token for                                                   |
| IN     | String      | The token, if empty oned will generate one                                                |
| IN     | Int         | Valid period in seconds; 0 reset the token and -1 for a non-expiring token.               |
| IN     | Int         | Effective GID to use with this token. To use the current GID and user groups set it to -1 |
| OUT    | Boolean     | true or false whenever is successful or not                                               |
| OUT    | String      | The new token / The error string.                                                         |
| OUT    | Int         | Error code.                                                                               |

### one.user.update

- **Description**: Replaces the user template contents.
- **Parameters**

| Type   | Data Type   | Description                                                                                      |
|--------|-------------|--------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                              |
| IN     | Int         | The object ID.                                                                                   |
| IN     | String      | The new template contents. Syntax can be the usual `attribute=value` or XML.                     |
| IN     | Int         | Update type: **0**: Replace the whole template. **1**: Merge new template with the existing one. |
| OUT    | Boolean     | true or false whenever is successful or not                                                      |
| OUT    | Int/String  | The resource ID / The error string.                                                              |
| OUT    | Int         | Error code.                                                                                      |

### one.user.chauth

- **Description**: Changes the authentication driver and the password for the given user.
- **Parameters**

| Type   | Data Type   | Description                                                              |
|--------|-------------|--------------------------------------------------------------------------|
| IN     | String      | The session string.                                                      |
| IN     | Int         | The object ID.                                                           |
| IN     | String      | The new authentication driver.                                           |
| IN     | String      | The new password. If it is an empty string, the password is not changed. |
| OUT    | Boolean     | true or false whenever is successful or not                              |
| OUT    | Int/String  | The User ID / The error string.                                          |
| OUT    | Int         | Error code.                                                              |

### one.user.quota

- **Description**: Sets the user quota limits.
- **Parameters**

| Type   | Data Type   | Description                                                                        |
|--------|-------------|------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                |
| IN     | Int         | The object ID.                                                                     |
| IN     | String      | The new quota template contents. Syntax can be the usual `attribute=value` or XML. |
| OUT    | Boolean     | true or false whenever is successful or not                                        |
| OUT    | Int/String  | The resource ID / The error string.                                                |
| OUT    | Int         | Error code.                                                                        |

### one.user.chgrp

- **Description**: Changes the group of the given user.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The User ID.                                |
| IN     | Int         | The Group ID of the new group.              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The User ID / The error string.             |
| OUT    | Int         | Error code.                                 |

### one.user.addgroup

- **Description**: Adds the user to a secondary group.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The User ID.                                |
| IN     | Int         | The Group ID of the new group.              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The User ID / The error string.             |
| OUT    | Int         | Error code.                                 |

### one.user.delgroup

- **Description**: Removes the user from a secondary group
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The User ID.                                |
| IN     | Int         | The Group ID.                               |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The User ID / The error string.             |
| OUT    | Int         | Error code.                                 |

### one.user.enable

- **Description**: Enables or disables a user.
- **Parameters**

| Type   | Data Type   | Description                                  |
|--------|-------------|----------------------------------------------|
| IN     | String      | The session string.                          |
| IN     | Int         | The User ID.                                 |
| IN     | Boolean     | True for enabling, false for disabling.      |
| OUT    | Boolean     | true or false whenever is successful or not. |
| OUT    | Int/String  | The resource ID / The error string.          |
| OUT    | Int         | Error code.                                  |
| OUT    | Int         | ID of the User that caused the error.        |

### one.user.info

- **Description**: Retrieves information for the user.
- **Parameters**

| Type   | Data Type   | Description                                                                     |
|--------|-------------|---------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                             |
| IN     | Int         | The object ID. If it is -1, then the connected user’s own info info is returned |
| IN     | Boolean     | optional flag to decrypt contained secrets, valid only for admin                |
| OUT    | Boolean     | true or false whenever is successful or not                                     |
| OUT    | String      | The information string / The error string.                                      |
| OUT    | Int         | Error code.                                                                     |
| OUT    | Int         | ID of the object that caused the error.                                         |

### one.userpool.info

- **Description**: Retrieves information for all the users in the pool.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | String      | The information string / The error string.  |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.userquota.info

- **Description**: Returns the default user quota limits.
- **Parameters**

| Type   | Data Type   | Description                                     |
|--------|-------------|-------------------------------------------------|
| IN     | String      | The session string.                             |
| OUT    | Boolean     | true or false whenever is successful or not     |
| OUT    | String      | The quota template contents / The error string. |
| OUT    | Int         | Error code.                                     |

### one.userquota.update

- **Description**: Updates the default user quota limits.
- **Parameters**

| Type   | Data Type   | Description                                                                        |
|--------|-------------|------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                |
| IN     | String      | The new quota template contents. Syntax can be the usual `attribute=value` or XML. |
| OUT    | Boolean     | true or false whenever is successful or not                                        |
| OUT    | String      | The quota template contents / The error string.                                    |
| OUT    | Int         | Error code.                                                                        |

## Actions for Group Management

### one.group.allocate

- **Description**: Allocates a new group in OpenNebula.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | String      | Name for the new group.                     |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The allocated Group ID / The error string.  |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the Cluster that caused the error.    |

### one.group.delete

- **Description**: Deletes the given group from the pool.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.group.info

- **Description**: Retrieves information for the group.
- **Parameters**

| Type   | Data Type   | Description                                                                       |
|--------|-------------|-----------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                               |
| IN     | Int         | The object ID. If it is -1, then the connected user’s group info info is returned |
| IN     | Boolean     | optional flag to decrypt contained secrets, valid only for admin                  |
| OUT    | Boolean     | true or false whenever is successful or not                                       |
| OUT    | String      | The information string / The error string.                                        |
| OUT    | Int         | Error code.                                                                       |
| OUT    | Int         | ID of the object that caused the error.                                           |

### one.group.update

- **Description**: Replaces the group template contents.
- **Parameters**

| Type   | Data Type   | Description                                                                                      |
|--------|-------------|--------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                              |
| IN     | Int         | The object ID.                                                                                   |
| IN     | String      | The new template contents. Syntax can be the usual `attribute=value` or XML.                     |
| IN     | Int         | Update type: **0**: Replace the whole template. **1**: Merge new template with the existing one. |
| OUT    | Boolean     | true or false whenever is successful or not                                                      |
| OUT    | Int/String  | The resource ID / The error string.                                                              |
| OUT    | Int         | Error code.                                                                                      |

### one.group.addadmin

- **Description**: Adds a user to the Group administrators set
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The group ID.                               |
| IN     | Int         | The user ID.                                |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |

### one.group.deladmin

- **Description**: Removes a user from the Group administrators set
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The group ID.                               |
| IN     | Int         | The user ID.                                |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |

### one.group.quota

- **Description**: Sets the group quota limits.
- **Parameters**

| Type   | Data Type   | Description                                                                        |
|--------|-------------|------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                |
| IN     | Int         | The object ID.                                                                     |
| IN     | String      | The new quota template contents. Syntax can be the usual `attribute=value` or XML. |
| OUT    | Boolean     | true or false whenever is successful or not                                        |
| OUT    | Int/String  | The resource ID / The error string.                                                |
| OUT    | Int         | Error code.                                                                        |
| OUT    | Int         | ID of the group that caused the error.                                             |

### one.grouppool.info

- **Description**: Retrieves information for all the groups in the pool.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | String      | The information string / The error string.  |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.groupquota.info

- **Description**: Returns the default group quota limits.
- **Parameters**

| Type   | Data Type   | Description                                     |
|--------|-------------|-------------------------------------------------|
| IN     | String      | The session string.                             |
| OUT    | Boolean     | true or false whenever is successful or not     |
| OUT    | String      | The quota template contents / The error string. |
| OUT    | Int         | Error code.                                     |

### one.groupquota.update

- **Description**: Updates the default group quota limits.
- **Parameters**

| Type   | Data Type   | Description                                                                        |
|--------|-------------|------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                |
| IN     | String      | The new quota template contents. Syntax can be the usual `attribute=value` or XML. |
| OUT    | Boolean     | true or false whenever is successful or not                                        |
| OUT    | String      | The quota template contents / The error string.                                    |
| OUT    | Int         | Error code.                                                                        |

## Actions for VDC Management

### one.vdc.allocate

- **Description**: Allocates a new VDC in OpenNebula.
- **Parameters**

| Type   | Data Type   | Description                                                                      |
|--------|-------------|----------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                              |
| IN     | String      | A string containing the template of the VDC. Only `NAME` attribute is supported. |
| OUT    | Boolean     | true or false whenever is successful or not                                      |
| OUT    | Int/String  | The allocated resource ID / The error string.                                    |
| OUT    | Int         | Error code.                                                                      |
| OUT    | Int         | ID of the Cluster that caused the error.                                         |

### one.vdc.delete

- **Description**: Deletes the given VDC from the pool.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.vdc.update

- **Description**: Replaces the VDC template contents.
- **Parameters**

| Type   | Data Type   | Description                                                                                      |
|--------|-------------|--------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                              |
| IN     | Int         | The object ID.                                                                                   |
| IN     | String      | The new template contents. Syntax can be the usual `attribute=value` or XML.                     |
| IN     | Int         | Update type: **0**: Replace the whole template. **1**: Merge new template with the existing one. |
| OUT    | Boolean     | true or false whenever is successful or not                                                      |
| OUT    | Int/String  | The resource ID / The error string.                                                              |
| OUT    | Int         | Error code.                                                                                      |

### one.vdc.rename

- **Description**: Renames a VDC.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | String      | The new name.                               |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The VM ID / The error string.               |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.vdc.info

- **Description**: Retrieves information for the VDC.
- **Parameters**

| Type   | Data Type   | Description                                                                     |
|--------|-------------|---------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                             |
| IN     | Int         | The object ID. If it is -1, then the connected user’s VDC info info is returned |
| IN     | Boolean     | optional flag to decrypt contained secrets, valid only for admin                |
| OUT    | Boolean     | true or false whenever is successful or not                                     |
| OUT    | String      | The information string / The error string.                                      |
| OUT    | Int         | Error code.                                                                     |
| OUT    | Int         | ID of the object that caused the error.                                         |

### one.vdcpool.info

- **Description**: Retrieves information for all the VDCs in the pool.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | String      | The information string / The error string.  |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.vdc.addgroup

- **Description**: Adds a group to the VDC
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The VDC ID.                                 |
| IN     | Int         | The group ID.                               |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |

### one.vdc.delgroup

- **Description**: Deletes a group from the VDC
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The VDC ID.                                 |
| IN     | Int         | The group ID.                               |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |

### one.vdc.addcluster

- **Description**: Adds a cluster to the VDC
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The VDC ID.                                 |
| IN     | Int         | The Zone ID.                                |
| IN     | Int         | The Cluster ID.                             |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |

### one.vdc.delcluster

- **Description**: Deletes a cluster from the VDC
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The VDC ID.                                 |
| IN     | Int         | The Zone ID.                                |
| IN     | Int         | The Cluster ID.                             |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |

### one.vdc.addhost

- **Description**: Adds a Host to the VDC
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The VDC ID.                                 |
| IN     | Int         | The Zone ID.                                |
| IN     | Int         | The Host ID.                                |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |

### one.vdc.delhost

- **Description**: Deletes a Host from the VDC
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The VDC ID.                                 |
| IN     | Int         | The Zone ID.                                |
| IN     | Int         | The Host ID.                                |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |

### one.vdc.adddatastore

- **Description**: Adds a datastore to the VDC
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The VDC ID.                                 |
| IN     | Int         | The Zone ID.                                |
| IN     | Int         | The Datastore ID.                           |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |

### one.vdc.deldatastore

- **Description**: Deletes a datastore from the VDC
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The VDC ID.                                 |
| IN     | Int         | The Zone ID.                                |
| IN     | Int         | The Datastore ID.                           |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |

### one.vdc.addvnet

- **Description**: Adds a vnet to the VDC
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The VDC ID.                                 |
| IN     | Int         | The Zone ID.                                |
| IN     | Int         | The Vnet ID.                                |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |

### one.vdc.delvnet

- **Description**: Deletes a vnet from the VDC
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The VDC ID.                                 |
| IN     | Int         | The Zone ID.                                |
| IN     | Int         | The Vnet ID.                                |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |

## Actions for Zone Management

### one.zone.allocate

- **Description**: Allocates a new zone in OpenNebula.
- **Parameters**

| Type   | Data Type   | Description                                                                                     |
|--------|-------------|-------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                             |
| IN     | String      | A string containing the template of the zone. Syntax can be the usual `attribute=value` or XML. |
| OUT    | Boolean     | true or false whenever is successful or not                                                     |
| OUT    | Int/String  | The allocated resource ID / The error string.                                                   |
| OUT    | Int         | Error code.                                                                                     |
| OUT    | Int         | ID of the Cluster that caused the error.                                                        |

### one.zone.delete

- **Description**: Deletes the given zone from the pool.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.zone.enable

- **Description**: Enable/disable the given zone.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The Zone ID.                                |
| IN     | Boolean     | True for enabling, false for disabling.     |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.zone.update

- **Description**: Replaces the zone template contents.
- **Parameters**

| Type   | Data Type   | Description                                                                                      |
|--------|-------------|--------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                              |
| IN     | Int         | The object ID.                                                                                   |
| IN     | String      | The new template contents. Syntax can be the usual `attribute=value` or XML.                     |
| IN     | Int         | Update type: **0**: Replace the whole template. **1**: Merge new template with the existing one. |
| OUT    | Boolean     | true or false whenever is successful or not                                                      |
| OUT    | Int/String  | The resource ID / The error string.                                                              |
| OUT    | Int         | Error code.                                                                                      |
| OUT    | Int         | ID of the Zone that caused the error.                                                            |

### one.zone.rename

- **Description**: Renames a zone.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | String      | The new name.                               |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.zone.addserver

- **Description**: Add server to zone.
- **Parameters**

| Type   | Data Type   | Description                                                                                                                       |
|--------|-------------|-----------------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                               |
| IN     | Int         | The object ID.                                                                                                                    |
| IN     | String      | A string containing the template of the server. Syntax can be the usual `attribute=value` or XML.                               | |
| OUT    | Boolean     | True or false whenever is successful or not.                                                                                      |
| OUT    | Int/String  | The resource ID / The error string.                                                                                               |
| OUT    | Int         | Error code.                                                                                                                       |
| OUT    | Int         | ID of the object that caused the error.                                                                                           |

### one.zone.delserver

- **Description**: Delete a server from zone.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | Int         | The server ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.zone.resetserver

- **Description**: Reset follower log index. This should be trigger when a follower DB has been reset.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | Int         | The server ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.zone.info

- **Description**: Retrieves information for the zone.
- **Parameters**

| Type   | Data Type   | Description                                                      |
|--------|-------------|------------------------------------------------------------------|
| IN     | String      | The session string.                                              |
| IN     | Int         | The object ID.                                                   |
| IN     | Boolean     | optional flag to decrypt contained secrets, valid only for admin |
| OUT    | Boolean     | true or false whenever is successful or not                      |
| OUT    | String      | The information string / The error string.                       |
| OUT    | Int         | Error code.                                                      |
| OUT    | Int         | ID of the object that caused the error.                          |

### one.zone.raftstatus

- **Description**: Retrieves raft status one servers.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | String      | The information string / The error string.  |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.zonepool.info

- **Description**: Retrieves information for all the zones in the pool.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | String      | The information string / The error string.  |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

## Actions for ACL Rules Management

### one.acl.addrule

- **Description**: Adds a new ACL rule.
- **Parameters**

| Type   | Data Type   | Description                                                                |
|--------|-------------|----------------------------------------------------------------------------|
| IN     | String      | The session string.                                                        |
| IN     | String      | User component of the new rule. A string containing a hex number.          |
| IN     | String      | Resource component of the new rule. A string containing a hex number.      |
| IN     | String      | Rights component of the new rule. A string containing a hex number.        |
| IN     | String      | Optional zone component of the new rule. A string containing a hex number. |
| OUT    | Boolean     | true or false whenever is successful or not                                |
| OUT    | Int/String  | The allocated ACL rule ID / The error string.                              |
| OUT    | Int         | Error code.                                                                |

To build the hex. numbers required to create a new rule we recommend you to read the [ruby](https://github.com/OpenNebula/one/blob/master/src/oca/ruby/opennebula/acl.rb) or [java](https://github.com/OpenNebula/one/blob/master/src/oca/java/src/org/opennebula/client/acl/Acl.java) code.

### one.acl.delrule

- **Description**: Deletes an ACL rule.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | ACL rule ID.                                |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The ACL rule ID / The error string.         |
| OUT    | Int         | Error code.                                 |

### one.acl.info

- **Description**: Returns the complete ACL rule set.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | String      | The information string / The error string.  |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

## Actions for Document Management

### one.document.allocate

- **Description**: Allocates a new document in OpenNebula.
- **Parameters**

| Type   | Data Type   | Description                                                                                           |
|--------|-------------|-------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                   |
| IN     | String      | A string containing the document template contents. Syntax can be the usual `attribute=value` or XML. |
| IN     | Int         | The document type (\*).                                                                               |
| OUT    | Boolean     | true or false whenever is successful or not                                                           |
| OUT    | Int/String  | The allocated resource ID / The error string.                                                         |
| OUT    | Int         | Error code.                                                                                           |
| OUT    | Int         | ID of the Cluster that caused the error.                                                              |

(\*) Type is an integer value used to allow dynamic pools compartmentalization.

Let’s say you want to store documents representing Chef recipes, and EC2 security groups; you would allocate documents of each kind with a different type. This type is then used in the one.documentpool.info method to filter the results.

### one.document.clone

- **Description**: Clones an existing document.
- **Parameters**

| Type   | Data Type   | Description                                      |
|--------|-------------|--------------------------------------------------|
| IN     | String      | The session string.                              |
| IN     | Int         | The ID of the document to be cloned.             |
| IN     | String      | Name for the new document.                       |
| OUT    | Boolean     | true or false whenever is successful or not      |
| OUT    | Int/String  | The new document ID / The error string.          |
| OUT    | Int         | Error code.                                      |
| OUT    | Int         | ID of the original object that caused the error. |

### one.document.delete

- **Description**: Deletes the given document from the pool.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.document.update

- **Description**: Replaces the document template contents.
- **Parameters**

| Type   | Data Type   | Description                                                                                      |
|--------|-------------|--------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                              |
| IN     | Int         | The object ID.                                                                                   |
| IN     | String      | The new document template contents. Syntax can be the usual `attribute=value` or XML.            |
| IN     | Int         | Update type: **0**: Replace the whole template. **1**: Merge new template with the existing one. |
| OUT    | Boolean     | true or false whenever is successful or not                                                      |
| OUT    | Int/String  | The resource ID / The error string.                                                              |
| OUT    | Int         | Error code.                                                                                      |

### one.document.chmod

- **Description**: Changes the permission bits of a document.
- **Parameters**

| Type   | Data Type   | Description                                         |
|--------|-------------|-----------------------------------------------------|
| IN     | String      | The session string.                                 |
| IN     | Int         | The object ID.                                      |
| IN     | Int         | USER USE bit. If set to -1, it will not change.     |
| IN     | Int         | USER MANAGE bit. If set to -1, it will not change.  |
| IN     | Int         | USER ADMIN bit. If set to -1, it will not change.   |
| IN     | Int         | GROUP USE bit. If set to -1, it will not change.    |
| IN     | Int         | GROUP MANAGE bit. If set to -1, it will not change. |
| IN     | Int         | GROUP ADMIN bit. If set to -1, it will not change.  |
| IN     | Int         | OTHER USE bit. If set to -1, it will not change.    |
| IN     | Int         | OTHER MANAGE bit. If set to -1, it will not change. |
| IN     | Int         | OTHER ADMIN bit. If set to -1, it will not change.  |
| OUT    | Boolean     | true or false whenever is successful or not         |
| OUT    | Int/String  | The resource ID / The error string.                 |
| OUT    | Int         | Error code.                                         |
| OUT    | Int         | ID of the object that caused the error.             |

### one.document.chown

- **Description**: Changes the ownership of a document.
- **Parameters**

| Type   | Data Type   | Description                                                            |
|--------|-------------|------------------------------------------------------------------------|
| IN     | String      | The session string.                                                    |
| IN     | Int         | The object ID.                                                         |
| IN     | Int         | The User ID of the new owner. If set to -1, the owner is not changed.  |
| IN     | Int         | The Group ID of the new group. If set to -1, the group is not changed. |
| OUT    | Boolean     | true or false whenever is successful or not                            |
| OUT    | Int/String  | The resource ID / The error string.                                    |
| OUT    | Int         | Error code.                                                            |
| OUT    | Int         | ID of the object that caused the error.                                |

### one.document.rename

- **Description**: Renames a document.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | String      | The new name.                               |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The VM ID / The error string.               |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.document.info

- **Description**: Retrieves information for the document.
- **Parameters**

| Type   | Data Type   | Description                                                      |
|--------|-------------|------------------------------------------------------------------|
| IN     | String      | The session string.                                              |
| IN     | Int         | The object ID.                                                   |
| IN     | Boolean     | optional flag to decrypt contained secrets, valid only for admin |
| OUT    | Boolean     | true or false whenever is successful or not                      |
| OUT    | String      | The information string / The error string.                       |
| OUT    | Int         | Error code.                                                      |
| OUT    | Int         | ID of the object that caused the error.                          |

### one.document.lock

- **Description**: Locks a document. Lock certain actions depending on blocking level:

> - **USE**: locks Admin, Manage and Use actions.
> - **MANAGE**: locks Manage and Use actions.
> - **ADMIN**: locks only Admin actions.
- **Parameters**

| Type   | Data Type   | Description                                                                  |
|--------|-------------|------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                          |
| IN     | Int         | The object ID.                                                               |
| IN     | Int         | Lock level: use (1), manage (2), admin (3), all (4)                          |
| IN     | Boolean     | Test: check if the object is already locked to return an error               |
| OUT    | Boolean     | true or false whenever is successful or not                                  |
| OUT    | Int         | The ID of the resource.                                                      |
| OUT    | Int         | Error code.                                                                  |
| OUT    | Int         | ID of the object that caused the error.                                      |
| OUT    | String      | Timestamp when the object was locked in case of error when using test = true |

### one.document.unlock

- **Description**: Unlocks a document.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int         | The ID of the resource.                     |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.documentpool.info

- **Description**: Retrieves information for all or part of the resources in the pool.
- **Parameters**

| Type   | Data Type   | Description                                                                                                                                                                                                                                                       |
|--------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                                                                                                                                                               |
| IN     | Int         | Filter flag<br/><br/>* **-4**: Resources belonging to the user’s primary group<br/>* **-3**: Resources belonging to the user<br/>* **-2**: All resources<br/>* **-1**: Resources belonging to the user and any of his groups<br/>* **>= 0**: UID User’s Resources |
| IN     | Int         | When the next parameter is >= -1 this is the Range start ID.<br/>Can be -1. For smaller values this is the offset used for pagination.                                                                                                                            |
| IN     | Int         | For values >= -1 this is the Range end ID. Can be -1 to get until the<br/>last ID. For values < -1 this is the page size used for pagination.                                                                                                                     |
| IN     | Int         | The document type.                                                                                                                                                                                                                                                |
| OUT    | Boolean     | true or false whenever is successful or not                                                                                                                                                                                                                       |
| OUT    | String      | The information string / The error string.                                                                                                                                                                                                                        |
| OUT    | Int         | Error code.                                                                                                                                                                                                                                                       |

The range can be used to retrieve a subset of the pool, from the ‘start’ to the ‘end’ ID. To retrieve the complete pool, use `(-1, -1)`; to retrieve all the pool from a specific ID to the last one, use `(<id>, -1)`, and to retrieve the first elements up to an ID, use `(0, <id>)`.

## System Methods

### one.system.version

- **Description**: Returns the OpenNebula core version
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | String      | The OpenNebula version, e.g. `4.4.0`        |
| OUT    | Int         | Error code.                                 |

### one.system.config

- **Description**: Returns the OpenNebula configuration
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | String      | The loaded oned.conf file, in XML form      |
| OUT    | Int         | Error code.                                 |

## Actions for Virtual Network Templates Management

### one.vntemplate.allocate

- **Description**: Allocates a new vntemplate in OpenNebula.
- **Parameters**

| Type   | Data Type   | Description                                                                                    |
|--------|-------------|------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                            |
| IN     | String      | A string containing the vntemplate contents. Syntax can be the usual `attribute=value` or XML. |
| OUT    | Boolean     | true or false whenever is successful or not                                                    |
| OUT    | Int/String  | The allocated resource ID / The error string.                                                  |
| OUT    | Int         | Error code.                                                                                    |

### one.vntemplate.clone

- **Description**: Clones an existing Virtual Network template.
- **Parameters**

| Type   | Data Type   | Description                                      |
|--------|-------------|--------------------------------------------------|
| IN     | String      | The session string.                              |
| IN     | Int         | The ID of the vntemplate to be cloned.           |
| IN     | String      | Name for the new vntemplate.                     |
| OUT    | Boolean     | true or false whenever is successful or not      |
| OUT    | Int/String  | The new vntemplate ID / The error string.        |
| OUT    | Int         | Error code.                                      |
| OUT    | Int         | ID of the original object that caused the error. |

### one.vntemplate.delete

- **Description**: Deletes the given vntemplate from the pool.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.vntemplate.instantiate

- **Description**: Instantiates a new Virtual Network from a vntemplate.
- **Parameters**

| Type   | Data Type   | Description                                                                                                                                              |
|--------|-------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                                                      |
| IN     | Int         | The object ID.                                                                                                                                           |
| IN     | String      | Name for the new Virtual Network. If it is an empty string, OpenNebula will assign one automatically.                                                    |
| IN     | String      | A string containing an extra vntemplate to be merged with the one being instantiated. It can be empty. Syntax can be the usual `attribute=value` or XML. |
| OUT    | Boolean     | true or false whenever is successful or not                                                                                                              |
| OUT    | Int/String  | The new virtual machine ID / The error string.                                                                                                           |
| OUT    | Int         | Error code.                                                                                                                                              |

Sample vntemplate string:

```none
VN_MAD=bridge\nVLAN_ID=4
```

{{< alert title="Note" color="success" >}}
Declaring a field overwrites the vntemplate. Thus, declaring `VN_MAD=[...]` overwrites the vntemplate `VN_MAD` attribute.{{< /alert >}} 

### one.vntemplate.update

- **Description**: Replaces the vntemplate contents.
- **Parameters**

| Type   | Data Type   | Description                                                                                          |
|--------|-------------|------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                  |
| IN     | Int         | The object ID.                                                                                       |
| IN     | String      | The new vntemplate contents. Syntax can be the usual `attribute=value` or XML.                       |
| IN     | Int         | Update type: **0**: replace the whole vntemplate. **1**: Merge new vntemplate with the existing one. |
| OUT    | Boolean     | true or false whenever is successful or not                                                          |
| OUT    | Int/String  | The resource ID / The error string.                                                                  |
| OUT    | Int         | Error code.                                                                                          |

### one.vntemplate.chmod

- **Description**: Changes the permission bits of a vntemplate.
- **Parameters**

| Type   | Data Type   | Description                                         |
|--------|-------------|-----------------------------------------------------|
| IN     | String      | The session string.                                 |
| IN     | Int         | The object ID.                                      |
| IN     | Int         | USER USE bit. If set to -1, it will not change.     |
| IN     | Int         | USER MANAGE bit. If set to -1, it will not change.  |
| IN     | Int         | USER ADMIN bit. If set to -1, it will not change.   |
| IN     | Int         | GROUP USE bit. If set to -1, it will not change.    |
| IN     | Int         | GROUP MANAGE bit. If set to -1, it will not change. |
| IN     | Int         | GROUP ADMIN bit. If set to -1, it will not change.  |
| IN     | Int         | OTHER USE bit. If set to -1, it will not change.    |
| IN     | Int         | OTHER MANAGE bit. If set to -1, it will not change. |
| IN     | Int         | OTHER ADMIN bit. If set to -1, it will not change.  |
| OUT    | Boolean     | true or false whenever is successful or not         |
| OUT    | Int/String  | The resource ID / The error string.                 |
| OUT    | Int         | Error code.                                         |
| OUT    | Int         | ID of the object that caused the error.             |

### one.vntemplate.chown

- **Description**: Changes the ownership of a vntemplate.
- **Parameters**

| Type   | Data Type   | Description                                                            |
|--------|-------------|------------------------------------------------------------------------|
| IN     | String      | The session string.                                                    |
| IN     | Int         | The object ID.                                                         |
| IN     | Int         | The User ID of the new owner. If set to -1, the owner is not changed.  |
| IN     | Int         | The Group ID of the new group. If set to -1, the group is not changed. |
| OUT    | Boolean     | true or false whenever is successful or not                            |
| OUT    | Int/String  | The resource ID / The error string.                                    |
| OUT    | Int         | Error code.                                                            |
| OUT    | Int         | ID of the object that caused the error.                                |

### one.vntemplate.rename

- **Description**: Renames a vntemplate.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | String      | The new name.                               |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The VM ID / The error string.               |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.vntemplate.info

- **Description**: Retrieves information for the vntemplate.
- **Parameters**

| Type   | Data Type   | Description                                                      |
|--------|-------------|------------------------------------------------------------------|
| IN     | String      | The session string.                                              |
| IN     | Int         | The object ID.                                                   |
| IN     | Boolean     | optional flag to decrypt contained secrets, valid only for admin |
| OUT    | Boolean     | true or false whenever is successful or not                      |
| OUT    | String      | The information string / The error string.                       |
| OUT    | Int         | Error code.                                                      |
| OUT    | Int         | ID of the object that caused the error.                          |

### one.vntemplate.lock

- **Description**: Locks a vntemplate.
- **Parameters**

| Type   | Data Type   | Description                                                                  |
|--------|-------------|------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                          |
| IN     | Int         | The object ID.                                                               |
| IN     | Int         | Lock level: use (1), manage (2), admin (3), all (4)                          |
| IN     | Boolean     | Test: check if the object is already locked to return an error               |
| OUT    | Boolean     | true or false whenever is successful or not                                  |
| OUT    | Int         | The ID of the resource.                                                      |
| OUT    | Int         | Error code.                                                                  |
| OUT    | Int         | ID of the object that caused the error.                                      |
| OUT    | String      | Timestamp when the object was locked in case of error when using test = true |

### one.vntemplate.unlock

- **Description**: Unlocks a vntemplate.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int         | The ID of the resource.                     |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.vntemplatepool.info

- **Description**: Retrieves information for all or part of the resources in the pool.
- **Parameters**

| Type   | Data Type   | Description                                                                                                                                                                                                                                                       |
|--------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                                                                                                                                                               |
| IN     | Int         | Filter flag<br/><br/>* **-4**: Resources belonging to the user’s primary group<br/>* **-3**: Resources belonging to the user<br/>* **-2**: All resources<br/>* **-1**: Resources belonging to the user and any of his groups<br/>* **>= 0**: UID User’s Resources |
| IN     | Int         | When the next parameter is >= -1 this is the Range start ID.<br/>Can be -1. For smaller values this is the offset used for pagination.                                                                                                                            |
| IN     | Int         | For values >= -1 this is the Range end ID. Can be -1 to get until the<br/>last ID. For values < -1 this is the page size used for pagination.                                                                                                                     |
| OUT    | Boolean     | true or false whenever is successful or not                                                                                                                                                                                                                       |
| OUT    | String      | The information string / The error string.                                                                                                                                                                                                                        |
| OUT    | Int         | Error code.                                                                                                                                                                                                                                                       |
| OUT    | Int         | ID of the object that caused the error.                                                                                                                                                                                                                           |

The range can be used to retrieve a subset of the pool, from the ‘start’ to the ‘end’ ID. To retrieve the complete pool, use `(-1, -1)`; to retrieve all the pool from a specific ID to the last one, use `(<id>, -1)`, and to retrieve the first elements up to an ID, use `(0, <id>)`.

## Actions for Hook Management

### one.hook.allocate

- **Description**: Allocates a new hook in OpenNebula.
- **Parameters**

| Type   | Data Type   | Description                                                                              |
|--------|-------------|------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                      |
| IN     | String      | A string containing the hook contents. Syntax can be the usual `attribute=value` or XML. |
| OUT    | Boolean     | true or false whenever is successful or not                                              |
| OUT    | Int/String  | The allocated resource ID / The error string.                                            |
| OUT    | Int         | Error code.                                                                              |

### one.hook.delete

- **Description**: Deletes the given hook from the pool.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int/String  | The resource ID / The error string.         |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.hook.update

- **Description**: Replaces the hook contents.
- **Parameters**

| Type   | Data Type   | Description                                                                                                |
|--------|-------------|------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                        |
| IN     | Int         | The object ID.                                                                                             |
| IN     | String      | The new hook contents. Syntax can be the usual `attribute=value` or XML.                                   |
| IN     | Int         | Update type: **0**: replace the whole hook template. **1**: Merge new hook template with the existing one. |
| OUT    | Boolean     | true or false whenever is successful or not                                                                |
| OUT    | Int/String  | The resource ID / The error string.                                                                        |
| OUT    | Int         | Error code.                                                                                                |

### one.hook.rename

- **Description**: Renames a hook.
- **Parameters**

| Type   | Data Type   | Description                                  |
|--------|-------------|----------------------------------------------|
| IN     | String      | The session string.                          |
| IN     | Int         | The object ID.                               |
| IN     | String      | The new name.                                |
| OUT    | Boolean     | true or false whenever is successful or not. |
| OUT    | Int/String  | The VM ID / The error string.                |
| OUT    | Int         | Error code.                                  |
| OUT    | Int         | ID of the object that caused the error.      |

### one.hook.info

- **Description**: Retrieves information for the hook.
- **Parameters**

| Type   | Data Type   | Description                                                      |
|--------|-------------|------------------------------------------------------------------|
| IN     | String      | The session string.                                              |
| IN     | Int         | The object ID.                                                   |
| IN     | Boolean     | optional flag to decrypt contained secrets, valid only for admin |
| OUT    | Boolean     | true or false whenever is successful or not                      |
| OUT    | String      | The information string / The error string.                       |
| OUT    | Int         | Error code.                                                      |
| OUT    | Int         | ID of the object that caused the error.                          |

### one.hook.lock

- **Description**: Locks a hook.
- **Parameters**

| Type   | Data Type   | Description                                                                  |
|--------|-------------|------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                          |
| IN     | Int         | The object ID.                                                               |
| IN     | Int         | Lock level: use (1), manage (2), admin (3), all (4)                          |
| IN     | Boolean     | Test: check if the object is already locked to return an error               |
| OUT    | Boolean     | true or false whenever is successful or not                                  |
| OUT    | Int         | The ID of the resource.                                                      |
| OUT    | Int         | Error code.                                                                  |
| OUT    | Int         | ID of the object that caused the error.                                      |
| OUT    | String      | Timestamp when the object was locked in case of error when using test = true |

### one.hook.unlock

- **Description**: Unlocks a hook.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int         | The ID of the resource.                     |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.hook.retry

- **Description**: Retries a hook execution.
- **Parameters**

| Type   | Data Type   | Description                                 |
|--------|-------------|---------------------------------------------|
| IN     | String      | The session string.                         |
| IN     | Int         | The object ID.                              |
| IN     | Int         | The execution ID.                           |
| OUT    | Boolean     | true or false whenever is successful or not |
| OUT    | Int         | The ID of the resource.                     |
| OUT    | Int         | Error code.                                 |
| OUT    | Int         | ID of the object that caused the error.     |

### one.hookpool.info

- **Description**: Retrieves information for all or part of the resources in the pool.
- **Parameters**

| Type   | Data Type   | Description                                                                                                                                                                                                                                                       |
|--------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                                                                                                                                                               |
| IN     | Int         | Filter flag<br/><br/>* **-4**: Resources belonging to the user’s primary group<br/>* **-3**: Resources belonging to the user<br/>* **-2**: All resources<br/>* **-1**: Resources belonging to the user and any of his groups<br/>* **>= 0**: UID User’s Resources |
| IN     | Int         | When the next parameter is >= -1 this is the Range start ID.<br/>Can be -1. For smaller values this is the offset used for pagination.                                                                                                                            |
| IN     | Int         | For values >= -1 this is the Range end ID. Can be -1 to get until the<br/>last ID. For values < -1 this is the page size used for pagination.                                                                                                                     |
| OUT    | Boolean     | true or false whenever is successful or not                                                                                                                                                                                                                       |
| OUT    | String      | The information string / The error string.                                                                                                                                                                                                                        |
| OUT    | Int         | Error code.                                                                                                                                                                                                                                                       |
| OUT    | Int         | ID of the object that caused the error.                                                                                                                                                                                                                           |

The range can be used to retrieve a subset of the pool, from the ‘start’ to the ‘end’ ID. To retrieve the complete pool, use `(-1, -1)`; to retrieve all the pool from a specific ID to the last one, use `(<id>, -1)`, and to retrieve the first elements up to an ID, use `(0, <id>)`.

### one.hooklog.info

- **Description**: Retrieves information from the hook execution log.
- **Parameters**

| Type   | Data Type   | Description                                                     |
|--------|-------------|-----------------------------------------------------------------|
| IN     | String      | The session string.                                             |
| IN     | Int         | Minimum date for filtering hook execution log records.          |
| IN     | Int         | Maximum date for filtering hook execution log records.          |
| IN     | Int         | Hook id for filtering hook execution log records.               |
| IN     | Int         | Hook execution return code (`-1` ERROR, `0` ALL , `1` SUCCESS). |
| OUT    | Boolean     | true or false whenever is successful or not                     |
| OUT    | String      | The information string / The error string.                      |
| OUT    | Int         | Error code.                                                     |
| OUT    | Int         | ID of the object that caused the error.                         |

## Actions for Backup Job Management

### one.backupjob.allocate

- **Description**: Allocates a new Backup Job in OpenNebula.
- **Parameters**

| Type   | Data Type   | Description                                                                                    |
|--------|-------------|------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                            |
| IN     | String      | A string containing the Backup Job contents. Syntax can be the usual `attribute=value` or XML. |
| OUT    | Boolean     | True or false whenever is successful or not.                                                   |
| OUT    | Int/String  | The allocated resource ID / The error string.                                                  |
| OUT    | Int         | Error code.                                                                                    |

### one.backupjob.delete

- **Description**: Deletes the given Backup Job from the pool.
- **Parameters**

| Type   | Data Type   | Description                                  |
|--------|-------------|----------------------------------------------|
| IN     | String      | The session string.                          |
| IN     | Int         | The object ID.                               |
| IN     | Boolean     | Delete the Backup Job                        |
| OUT    | Boolean     | True or false whenever is successful or not. |
| OUT    | Int/String  | The resource ID / The error string.          |
| OUT    | Int         | Error code.                                  |
| OUT    | Int         | ID of the object that caused the error.      |

### one.backupjob.info

- **Description**: Retrieves information for the Backup Job.
- **Parameters**

| Type   | Data Type   | Description                                  |
|--------|-------------|----------------------------------------------|
| IN     | String      | The session string.                          |
| IN     | Int         | The object ID.                               |
| OUT    | Boolean     | True or false whenever is successful or not. |
| OUT    | String      | The information string / The error string.   |
| OUT    | Int         | Error code.                                  |
| OUT    | Int         | ID of the object that caused the error.      |

### one.backupjob.update

- **Description**: Replaces the Backup Job content.
- **Parameters**

| Type   | Data Type   | Description                                                                                      |
|--------|-------------|--------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                              |
| IN     | Int         | The object ID.                                                                                   |
| IN     | String      | The new Backup Job content. Syntax can be the usual `attribute=value` or XML.                    |
| IN     | Int         | Update type: **0**: Replace the whole template. **1**: Merge new template with the existing one. |
| OUT    | Boolean     | True or false whenever is successful or not.                                                     |
| OUT    | Int/String  | The resource ID / The error string.                                                              |
| OUT    | Int         | Error code.                                                                                      |

### one.backupjob.rename

- **Description**: Renames a Backup Job.
- **Parameters**

| Type   | Data Type   | Description                                  |
|--------|-------------|----------------------------------------------|
| IN     | String      | The session string.                          |
| IN     | Int         | The object ID.                               |
| IN     | String      | The new name.                                |
| OUT    | Boolean     | True or false whenever is successful or not. |
| OUT    | Int/String  | The resource ID / The error string.          |
| OUT    | Int         | Error code.                                  |
| OUT    | Int         | ID of the object that caused the error.      |

### one.backupjob.chown

- **Description**: Changes the ownership of a Backup Job.
- **Parameters**

| Type   | Data Type   | Description                                                            |
|--------|-------------|------------------------------------------------------------------------|
| IN     | String      | The session string.                                                    |
| IN     | Int         | The object ID.                                                         |
| IN     | Int         | The User ID of the new owner. If set to -1, the owner is not changed.  |
| IN     | Int         | The Group ID of the new group. If set to -1, the group is not changed. |
| OUT    | Boolean     | True or false whenever is successful or not.                           |
| OUT    | Int/String  | The resource ID / The error string.                                    |
| OUT    | Int         | Error code.                                                            |
| OUT    | Int         | ID of the object that caused the error.                                |

### one.backupjob.chmod

- **Description**: Changes the permission bits of a Backup Job.
- **Parameters**

| Type   | Data Type   | Description                                                |
|--------|-------------|------------------------------------------------------------|
| IN     | String      | The session string.                                        |
| IN     | Int         | The object ID.                                             |
| IN     | Int         | USER USE bit. If set to -1, it will not change.            |
| IN     | Int         | USER MANAGE bit. If set to -1, it will not change.         |
| IN     | Int         | USER ADMIN bit. If set to -1, it will not change.          |
| IN     | Int         | GROUP USE bit. If set to -1, it will not change.           |
| IN     | Int         | GROUP MANAGE bit. If set to -1, it will not change.        |
| IN     | Int         | GROUP ADMIN bit. If set to -1, it will not change.         |
| IN     | Int         | OTHER USE bit. If set to -1, it will not change.           |
| IN     | Int         | OTHER MANAGE bit. If set to -1, it will not change.        |
| IN     | Int         | OTHER ADMIN bit. If set to -1, it will not change.         |
| IN     | Boolean     | True to chmod the template plus any image defined in DISK. |
| OUT    | Boolean     | True or false whenever is successful or not.               |
| OUT    | Int/String  | The resource ID / The error string.                        |
| OUT    | Int         | Error code.                                                |
| OUT    | Int         | ID of the object that caused the error.                    |

### one.backupjob.lock

- **Description**: Locks a Backup Job.
- **Parameters**

| Type   | Data Type   | Description                                                                  |
|--------|-------------|------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                          |
| IN     | Int         | The object ID.                                                               |
| IN     | Int         | Lock level: use (1), manage (2), admin (3), all (4)                          |
| IN     | Boolean     | Test: check if the object is already locked to return an error               |
| OUT    | Boolean     | True or false whenever is successful or not.                                 |
| OUT    | Int         | The ID of the resource.                                                      |
| OUT    | Int         | Error code.                                                                  |
| OUT    | Int         | ID of the object that caused the error.                                      |
| OUT    | String      | Timestamp when the object was locked in case of error when using test = true |

### one.backupjob.unlock

- **Description**: Unlocks a Backup Job.
- **Parameters**

| Type   | Data Type   | Description                                  |
|--------|-------------|----------------------------------------------|
| IN     | String      | The session string.                          |
| IN     | Int         | The object ID.                               |
| OUT    | Boolean     | True or false whenever is successful or not. |
| OUT    | Int         | The ID of the resource.                      |
| OUT    | Int         | Error code.                                  |
| OUT    | Int         | ID of the object that caused the error.      |

### one.backupjob.backup

- **Description**: Executes a Backup Job, starts individual VM backups with respect to max backup limits.
- **Parameters**

| Type   | Data Type   | Description                                  |
|--------|-------------|----------------------------------------------|
| IN     | String      | The session string.                          |
| IN     | Int         | The object ID.                               |
| OUT    | Boolean     | True or false whenever is successful or not. |
| OUT    | Int         | The ID of the resource.                      |
| OUT    | Int         | Error code.                                  |
| OUT    | Int         | ID of the object that caused the error.      |

### one.backupjob.cancel

- **Description**: Cancel ongoing Backup Job
- **Parameters**

| Type   | Data Type   | Description                                  |
|--------|-------------|----------------------------------------------|
| IN     | String      | The session string.                          |
| IN     | Int         | The object ID.                               |
| OUT    | Boolean     | True or false whenever is successful or not. |
| OUT    | Int         | The ID of the resource.                      |
| OUT    | Int         | Error code.                                  |
| OUT    | Int         | ID of the object that caused the error.      |

### one.backupjob.retry

- **Description**: Retry previously failed VM backups.
- **Parameters**

| Type   | Data Type   | Description                                  |
|--------|-------------|----------------------------------------------|
| IN     | String      | The session string.                          |
| IN     | Int         | The object ID.                               |
| OUT    | Boolean     | True or false whenever is successful or not. |
| OUT    | Int         | The ID of the resource.                      |
| OUT    | Int         | Error code.                                  |
| OUT    | Int         | ID of the object that caused the error.      |

### one.backupjob.priority

- **Description**: Set new priority for Backup Job.
- **Parameters**

| Type   | Data Type   | Description                                             |
|--------|-------------|---------------------------------------------------------|
| IN     | String      | The session string.                                     |
| IN     | Int         | The object ID.                                          |
| IN     | Int         | New priority value, only oneadmin may set priority > 50 |
| OUT    | Boolean     | True or false whenever is successful or not.            |
| OUT    | Int         | The ID of the resource.                                 |
| OUT    | Int         | Error code.                                             |
| OUT    | Int         | ID of the object that caused the error.                 |

### one.backupjob.schedadd

- **Description**: Add Scheduled Action to Backup Job.
- **Parameters**

| Type   | Data Type   | Description                                                                                          |
|--------|-------------|------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                  |
| IN     | Int         | The object ID.                                                                                       |
| IN     | String      | A string containing the Scheduled Action contents. Syntax can be the usual `attribute=value` or XML. |
| OUT    | Boolean     | True or false whenever is successful or not.                                                         |
| OUT    | Int         | The ID of the resource / The error string.                                                           |
| OUT    | Int         | Error code.                                                                                          |
| OUT    | Int         | ID of the object that caused the error.                                                              |

### one.backupjob.schedupdate

- **Description**: Update Backup Job Scheduled Action.
- **Parameters**

| Type   | Data Type   | Description                                                                                          |
|--------|-------------|------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                  |
| IN     | Int         | The object ID.                                                                                       |
| IN     | Int         | The Scheduled Action ID.                                                                             |
| IN     | String      | Template containing the updated Scheduled Action.. Syntax can be the usual `attribute=value` or XML. |
| OUT    | Boolean     | True or false whenever is successful or not.                                                         |
| OUT    | Int         | The ID of the resource / The error string.                                                           |
| OUT    | Int         | Error code.                                                                                          |
| OUT    | Int         | ID of the object that caused the error.                                                              |

### one.backupjob.scheddelete

- **Description**: Delete Scheduled Action from Backup Job.
- **Parameters**

| Type   | Data Type   | Description                                  |
|--------|-------------|----------------------------------------------|
| IN     | String      | The session string.                          |
| IN     | Int         | The object ID.                               |
| IN     | Int         | The Scheduled Action ID.                     |
| OUT    | Boolean     | True or false whenever is successful or not. |
| OUT    | Int         | The ID of the resource / The error string.   |
| OUT    | Int         | Error code.                                  |
| OUT    | Int         | ID of the object that caused the error.      |

### one.backupjobpool.info

- **Description**: Retrieves information for all or part of the Backup Jobs in the pool.
- **Parameters**

| Type   | Data Type   | Description                                                                                                                                                                                                                                                       |
|--------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| IN     | String      | The session string.                                                                                                                                                                                                                                               |
| IN     | Int         | Filter flag<br/><br/>* **-4**: Resources belonging to the user’s primary group<br/>* **-3**: Resources belonging to the user<br/>* **-2**: All resources<br/>* **-1**: Resources belonging to the user and any of his groups<br/>* **>= 0**: UID User’s Resources |
| IN     | Int         | When the next parameter is >= -1 this is the Range start ID. Can be -1. For smaller values this is the offset used for pagination.                                                                                                                                |
| IN     | Int         | For values >= -1 this is the Range end ID. Can be -1 to get until the last ID. For values < -1 this is the page size used for pagination.                                                                                                                         |
| OUT    | Boolean     | True or false whenever is successful or not.                                                                                                                                                                                                                      |
| OUT    | String      | The information string / The error string.                                                                                                                                                                                                                        |
| OUT    | Int         | Error code.                                                                                                                                                                                                                                                       |
| OUT    | Int         | ID of the object that caused the error.                                                                                                                                                                                                                           |

The range can be used to retrieve a subset of the pool, from the ‘start’ to the ‘end’ ID. To retrieve the complete pool, use `(-1, -1)`; to retrieve all the pool from a specific ID to the last one, use `(<id>, -1)`, and to retrieve the first elements up to an ID, use `(0, <id>)`.

<a id="api-xsd-reference"></a>

## XSD Reference

The XML schema files that describe the XML documents returned by the one.\*.info methods [can be found here](https://github.com/OpenNebula/one/tree/master/share/doc/xsd).
