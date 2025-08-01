---
title: "OneFlow Server API"
date: "2025-02-17"
description:
categories:
pageintoc: "287"
tags:
weight: "7"
---

<a id="appflow-api"></a>

<!--# OneFlow Specification -->

The OpenNebula OneFlow API is a RESTful service to create, control, and monitor services composed of interconnected Virtual Machines with deployment dependencies between them. Each group of Virtual Machines is deployed and managed as a single entity, and is completely integrated with the advanced OpenNebula user and group management. There are two kind of resources: services templates and services. All data is sent and received as JSON.

This guide is intended for developers. The OpenNebula distribution includes a [cli]({{% relref "../../../product/operation_references/configuration_references/cli#cli" %}}) to interact with OneFlow and it is also fully integrated in the [Sunstone GUI]({{% relref "../../../product/operation_references/opennebula_services_configuration/oneflow#oneflow-conf-sunstone" %}}).

## Authentication & Authorization

User authentication will be [HTTP Basic access authentication](http://tools.ietf.org/html/rfc1945#section-11). The credentials passed should be the username and password.

```default
$ curl -u "username:password" https://oneflow.server
```

## Return Codes

The OneFlow API uses the following subset of HTTP Status codes:

* **200 OK** : the request has succeeded.
* **201 Created** : request was successful and a new resource has been created.
* **202 Accepted** : the request has been accepted for processing but the processing has not been completed.
* **204 No Content** : the request has been accepted for processing but no info in the response.
* **400 Bad Request** : malformed syntax.
* **401 Unauthorized** : bad authentication.
* **403 Forbidden** : bad authorization.
* **404 Not Found** : resource not found.
* **500 Internal Server Error** : the server encountered an unexpected condition which prevented it from fulfilling the request.
* **501 Not Implemented** : the functionality requested is not supported.

```default
> POST /service_template HTTP/1.1
> User-Agent: curl/7.19.7 (x86_64-redhat-linux-gnu) libcurl/7.19.7 NSS/3.14.0.0 zlib/1.2.3 libidn/1.18 libssh2/1.4.2
> Host: onflow.server:2474
>
< HTTP/1.1 400 Bad Request
< Content-Type: text/html;charset=utf-8
< Content-Type:application/json;charset=utf-8
< Content-Length: 40
<
{
  "error": {
    "message": "Role 'worker' 'cardinality' must be greater than or equal to 'min_vms'"
  }
}
```

The methods specified below are described without taking into account **4xx** (this can be inferred from the authorization information in the section above) and **5xx** errors (which are method independent). HTTP verbs not defined for a particular entity will return a **501 Not Implemented**.

## Methods

### Service

| Method     | URL                                | Meaning / Entity Body                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | Response                                                              |
|------------|------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------|
| **GET**    | `/service`                         | **List** the contents of the `SERVICE` collection.                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | **200 OK**: A JSON representation of the collection in the HTTP body. |
| **GET**    | `/service/<id>`                    | **Show** the `SERVICE` resource identified by `<id>`.                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | **200 OK**: A JSON representation of the collection in the HTTP body. |
| **DELETE** | `/service/<id>`                    | **Delete** the `SERVICE` resource identified by `<id>`.                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | **204**:                                                              |
| **POST**   | `/service/<id>/action`             | **Perform** an action on the `SERVICE` resource identified by `<id>`. Available actions: shutdown, recover, chown, chgrp, chmod, release. It can also be used to perform an action in all the Virtual Machines. Available actions: shutdown, shutdown-hard, undeploy, undeploy-hard, hold, release, stop, suspend, resume, boot, delete, delete-recreate, reboot, reboot-hard, poweroff, poweroff-hard, snapshot-create, snapshot-revert, snapshot-delete, disk-snapshot-create, disk-snapshot-revert, disk-snapshot-delete. | **204**:                                                              |
| **PUT**    | `/service/<id>`                    | **Update** the `SERVICE` resource identified by `<id>`.                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | **204**:                                                              |
| **POST**   | `/service/<id>/scale`              | **Perform** an scale operation on the `SERVICE` resource identified by `<id>`.                                                                                                                                                                                                                                                                                                                                                                                                                                               | **204**:                                                              |
| **POST**   | `/service/<id>/role/<name>/action` | **Perform** an action on all the Virtual Machines belonging to the `ROLE` identified by <name> of the `SERVICE` resource identified by `<id>`. Available actions: shutdown, shutdown-hard, undeploy, undeploy-hard, hold, release, stop, suspend, resume, boot, delete, delete-recreate, reboot, reboot-hard, poweroff, poweroff-hard, snapshot-create, snapshot-revert, snapshot-delete, disk-snapshot-create, disk-snapshot-revert, disk-snapshot-delete.                                                                  | **204**:                                                              |
| **POST**   | `/service/<id>/role_action`        | **Add** or **remove** a role from running service.                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | **204**:                                                              |

### Service Pool

| Method   | URL                        | Meaning / Entity Body                           |
|----------|----------------------------|-------------------------------------------------|
| **POST** | `/service_pool/purge_done` | **Remove** `SERVICES` that are in `DONE` state. |

### Service Template

| Method     | URL                             | Meaning / Entity Body                                                                                                             | Response                                                                                        |
|------------|---------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------|
| **GET**    | `/service_template`             | **List** the contents of the `SERVICE_TEMPLATE` collection.                                                                       | **200 OK**: A JSON representation of the collection in the HTTP body.                           |
| **GET**    | `/service_template/<id>`        | **Show** the `SERVICE_TEMPLATE` resource identified by `<id>`.                                                                      | **200 OK**: A JSON representation of the collection in the HTTP body.                           |
| **DELETE** | `/service_template/<id>`        | **Delete** the `SERVICE_TEMPLATE` resource identified by `<id>`.                                                                    | **204**:                                                                                        |
| **POST**   | `/service_template`             | **Create** a new `SERVICE_TEMPLATE` resource.                                                                                     | **201 Created**: A JSON representation of the new `SERVICE_TEMPLATE` resource in the HTTP body. |
| **PUT**    | `/service_template/<id>`        | **Update** the `SERVICE_TEMPLATE` resource identified by `<id>`.                                                                    | **200 OK**: A JSON representation of the collection in the HTTP body.                           |
| **POST**   | `/service_template/<id>/action` | **Perform** an action on the `SERVICE_TEMPLATE` resource identified by `<id>`. Available actions: instantiate, chown, chgrp, chmod. | **201**:                                                                                        |

## Resource Representation

### Service Schema

A Service is defined with JSON syntax templates.

| Attribute           | Type           | Mandatory   | Description                                                                                                                                                                                                                                                                                                      |
|---------------------|----------------|-------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `name`              | string         | **NO**      | Name of the service.                                                                                                                                                                                                                                                                                             |
| `deployment`        | string         | **NO**      | Deployment strategy:<br/>**none**: All Roles are deployed at the same time.<br/>**straight**: Each Role is deployed when all its parent Roles are running.<br/>Defaults to none.                                                                                                                                 |
| `shutdown_action`   | string         | **NO**      | VM shutdown action: ‘shutdown’ or ‘shutdown-hard’. If it is not set, the default set in `oneflow-server.conf` will be used.                                                                                                                                                                                      |
| `ready_status_gate` | boolean        | **NO**      | If ready_status_gate is set to true, a VM will only be considered to be in running state if the following points are true: VM is in running state for OpenNebula. This specifically means that LCM_STATE==3 and STATE>=3; The VM has READY=YES in the user template, this can be reported by the VM using OneGate. |
| `on_hold`           | boolean        | **NO**      | If on_hold is set to true, all VMs of the service will be created in `HOLD` state.                                                                                                                                                                                                                               |
| `user_inputs`       | hash           | **NO**      | Hash of custom attributes to use in the service.                                                                                                                                                                                                                                                                 |
| `networks`          | hash           | **NO**      | Hash of Virtual Networks to use in the service.                                                                                                                                                                                                                                                                  |
| `roles`             | array of Roles | **YES**     | Array of Roles, see below.                                                                                                                                                                                                                                                                                       |

Each Role is defined as:

| Attribute             | Type              | Mandatory                       | Description                                                                                                                                                                                                      |
|-----------------------|-------------------|---------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `name`                | string            | **YES**                         | Role name, only word characters (letter, number, underscore) are allowed.                                                                                                                                        |
| `cardinality`         | integer           | **NO**                          | Number of VMs to deploy. Defaults to 1.                                                                                                                                                                          |
| `template_id`         | integer           | **YES**                         | OpenNebula VM Template ID. See the [OpenNebula documentation for VM Templates]({{% relref "../../../product/virtual_machines_operation/virtual_machine_definitions/vm_templates#vm-guide" %}}).                                |
| `type`                | string            | **YES**                         | Defines the Role type, `vm` for VM Role and `vr` for VR Roles.                                                                                                                                                   |
| `parents`             | array of string   | **NO**                          | Names of the Roles that must be deployed before this one.                                                                                                                                                        |
| `shutdown_action`     | string            | **NO**                          | VM shutdown action: ‘shutdown’ or ‘shutdown-hard’. If it is not set, the one set for the Service will be used.                                                                                                   |
| `on_hold`             | boolean           | **NO**                          | If on_hold is set to true, all VMs of the Role (and their child Roles) will be created in `HOLD` state. If on_hold is already defined at the service level, it is not necessary to specify it at the Role level. |
| `min_vms`             | integer           | **NO** (**YES** for elasticity) | Minimum number of VMs for elasticity adjustments.                                                                                                                                                                |
| `max_vms`             | integer           | **NO** (**YES** for elasticity) | Maximum number of VMs for elasticity adjustments.                                                                                                                                                                |
| `cooldown`            | integer           | **NO**                          | Cooldown period duration after a scale operation, in seconds. If it is not set, the default set in `oneflow-server.conf` will be used.                                                                           |
| `elasticity_policies` | array of Policies | **NO**                          | Array of Elasticity Policies, see below.                                                                                                                                                                         |
| `scheduled_policies`  | array of Policies | **NO**                          | Array of Scheduled Policies, see below.                                                                                                                                                                          |

To define a elasticity policy:

| Attribute         | Type    | Mandatory   | Description                                                                                                                                                        |
|-------------------|---------|-------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `type`            | string  | **YES**     | Type of adjustment. Values: `CHANGE`, `CARDINALITY`, `PERCENTAGE_CHANGE`.                                                                                          |
| `adjust`          | integer | **YES**     | Positive or negative adjustment. Its meaning depends on ‘type’.                                                                                                    |
| `min_adjust_step` | integer | **NO**      | Optional parameter for `PERCENTAGE_CHAGE` adjustment type. If present, the policy will change the cardinality by at least the number of VMs set in this attribute. |
| `expression`      | string  | **YES**     | Expression to trigger the elasticity.                                                                                                                              |
| `period_number`   | integer | **No**      | Number of periods that the expression must be true before the elasticity is triggered.                                                                             |
| `period`          | integer | **NO**      | Duration, in seconds, of each period in `period_duration`.                                                                                                         |
| `cooldown`        | integer | **NO**      | Cooldown period duration after a scale operation, in seconds. If it is not set, the one set for the Role will be used.                                             |

And each scheduled policy is defined as:

| Attribute         | Type    | Mandatory   | Description                                                                                                                                                        |
|-------------------|---------|-------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `type`            | string  | **YES**     | Type of adjustment. Values: `CHANGE`, `CARDINALITY`, `PERCENTAGE_CHANGE`.                                                                                          |
| `adjust`          | integer | **YES**     | Positive or negative adjustment. Its meaning depends on ‘type’.                                                                                                    |
| `min_adjust_step` | integer | **NO**      | Optional parameter for `PERCENTAGE_CHAGE` adjustment type. If present, the policy will change the cardinality by at least the number of VMs set in this attribute. |
| `recurrence`      | string  | **NO**      | Time for recurring adjustments. Time is specified with the [Unix cron syntax](http://en.wikipedia.org/wiki/Cron).                                                  |
| `start_time`      | string  | **NO**      | Exact time for the adjustment.                                                                                                                                     |
| `cooldown`        | integer | **NO**      | Cooldown period duration after a scale operation, in seconds. If it is not set, the one set for the Role will be used.                                             |
```default
{
  :type => :object,
  :properties => {
      'name' => {
          :type => :string,
          :required => true
      },
      'deployment' => {
          :type => :string,
          :default => 'none'
      },
      'description' => {
          :type => :string,
          :default => ''
      },
      'shutdown_action' => {
          :type => :string,
          :required => false
      },
      'roles' => {
          :type => :array,
          :items => [],
          :required => true
      },
      'user_inputs' => {
          :type => :object,
          :properties => {},
          :required => false
      },
      'user_inputs_values' => {
          :type => :object,
          :properties => {},
          :required => false
      },
      'ready_status_gate' => {
          :type => :boolean,
          :required => false
      },
      'automatic_deletion' => {
          :type => :boolean,
          :required => false
      },
      'networks' => {
          :type => :object,
          :properties => {},
          :required => false
      },
      'networks_values' => {
          :type => :array,
          :items => {
              :type => :object,
              :properties => {}
          },
          :required => false
      },
      'on_hold' => {
          :type => :boolean,
          :required => false
      }
  }
}
```

<a id="flow-role-schema"></a>

### VM Role Schema

```default
{
  :type => :object,
  :properties => {
      'name' => {
          :type => :string,
          :required => true,
          :regex => /^\w+$/
      },
      'type' => {
          :type => :string,
          :required => true
      },
      'cardinality' => {
          :type => :integer,
          :default => 0,
          :minimum => 0
      },
      'template_id' => {
          :type => :integer,
          :required => true
      },
      'template_contents' => {
          :type => :object,
          :properties => {},
          :required => false
      },
      'user_inputs' => {
          :type => :object,
          :properties => {},
          :required => false
      },
      'user_inputs_values' => {
          :type => :object,
          :properties => {},
          :required => false
      },
      'parents' => {
          :type => :array,
          :items => {
              :type => :string
          }
      },
      'shutdown_action' => {
          :type => :string,
          :required => false
      },
      'min_vms' => {
          :type => :integer,
          :required => false,
          :minimum => 0
      },
      'max_vms' => {
          :type => :integer,
          :required => false,
          :minimum => 0
      },
      'cooldown' => {
          :type => :integer,
          :required => false,
          :minimum => 0
      },
      'on_hold' => {
          :type => :boolean,
          :required => false
      },
      'elasticity_policies' => {
          :type => :array,
          :items => {
              :type => :object,
              :properties => {
                  'type' => {
                      :type => :string,
                      :required => true
                  },
                  'adjust' => {
                      :type => :integer,
                      :required => true
                  },
                  'min_adjust_step' => {
                      :type => :integer,
                      :required => false,
                      :minimum => 1
                  },
                  'period_number' => {
                      :type => :integer,
                      :required => false,
                      :minimum => 0
                  },
                  'period' => {
                      :type => :integer,
                      :required => false,
                      :minimum => 0
                  },
                  'expression' => {
                      :type => :string,
                      :required => true
                  },
                  'cooldown' => {
                      :type => :integer,
                      :required => false,
                      :minimum => 0
                  }
              }
          }
      },
      'scheduled_policies' => {
          :type => :array,
          :items => {
              :type => :object,
              :properties => {
                  'type' => {
                      :type => :string,
                      :required => true
                  },
                  'adjust' => {
                      :type => :integer,
                      :required => true
                  },
                  'min_adjust_step' => {
                      :type => :integer,
                      :required => false,
                      :minimum => 1
                  },
                  'start_time' => {
                      :type => :string,
                      :required => false
                  },
                  'recurrence' => {
                      :type => :string,
                      :required => false
                  }
              }
          }
      }
  }
}
```

### VR Role Schema

```default
{
  :type => :object,
  :properties => {
      'name' => {
          :type => :string,
          :required => true,
          :regex => /^\w+$/
      },
      'type' => {
          :type => :string,
          :required => true
      },
      'template_id' => {
          :type => :integer,
          :required => true
      },
      'cardinality' => {
          :type => :integer,
          :default => 0,
          :minimum => 0
      },
      'template_contents' => {
          :type => :object,
          :properties => {},
          :required => false
      },
      'user_inputs' => {
          :type => :object,
          :properties => {},
          :required => false
      },
      'user_inputs_values' => {
          :type => :object,
          :properties => {},
          :required => false
      },
      'on_hold' => {
          :type => :boolean,
          :required => false
      },
      'parents' => {
          :type => :array,
          :items => {
              :type => :string
          }
      }
  }
}
```

### Action Schema

```default
{
  :type => :object,
  :properties => {
    'action' => {
      :type => :object,
      :properties => {
        'perform' => {
          :type => :string,
          :required => true
        },
        'params' => {
          :type => :object,
          :required => false,
          :propierties => {
            'merge_template' => {
                :type => object,
                :required => false
              }
            }
          }
        }
      }
    }
  }
}
```

## Examples

### Create a New Service Template

| Method   | URL                 | Meaning / Entity Body                         | Response                                                                                        |
|----------|---------------------|-----------------------------------------------|-------------------------------------------------------------------------------------------------|
| **POST** | `/service_template` | **Create** a new `SERVICE_TEMPLATE` resource. | **201 Created**: A JSON representation of the new `SERVICE_TEMPLATE` resource in the HTTP body. |
```default
curl http://127.0.0.1:2474/service_template -u 'oneadmin:password' -v --data '{
  "name":"web-application",
  "deployment":"straight",
  "roles":[
    {
      "name":"frontend",
      "cardinality":"1",
      "template_id":"0",
      "type": "vm",
      "shutdown_action":"shutdown",
      "min_vms":"1",
      "max_vms":"4",
      "cooldown":"30",
      "elasticity_policies":[
        {
          "type":"PERCENTAGE_CHANGE",
          "adjust":"20",
          "min_adjust_step":"1",
          "expression":"CUSTOM_ATT>40",
          "period":"3",
          "period_number":"30",
          "cooldown":"30"
        }
      ],
      "scheduled_policies":[
        {
          "type":"CHANGE",
          "adjust":"4",
          "recurrence":"0 2 1-10 * * "
        }
      ]
    },
    {
      "name":"worker",
      "cardinality":"2",
      "template_id":"0",
      "type": "vm",
      "shutdown_action":"shutdown",
      "parents":[
        "frontend"
      ],
      "min_vms":"2",
      "max_vms":"10",
      "cooldown":"240",
      "elasticity_policies":[
        {
          "type":"CHANGE",
          "adjust":"5",
          "expression":"ATT=3",
          "period":"5",
          "period_number":"60",
          "cooldown":"240"
        }
      ],
      "scheduled_policies":[
      ]
    }
  ],
  "shutdown_action":"shutdown"
}'
```

```default
> POST /service_template HTTP/1.1
> Authorization: Basic b25lYWRtaW46b23lbm5lYnVsYQ==
> User-Agent: curl/7.19.7 (x86_64-redhat-linux-gnu) libcurl/7.19.7 NSS/3.14.0.0 zlib/1.2.3 libidn/1.18 libssh2/1.4.2
> Host: oneflow.server:2474
> Accept: */*
> Content-Length: 771
> Content-Type: application/x-www-form-urlencoded
>
< HTTP/1.1 201 Created
< Content-Type: text/html;charset=utf-8
< X-XSS-Protection: 1; mode=block
< Content-Length: 1990
< X-Frame-Options: sameorigin
< Connection: keep-alive
< Server: thin 1.2.8 codename Black Keys
<
{
  "DOCUMENT": {
    "TEMPLATE": {
      "BODY": {
        "deployment": "straight",
        "name": "web-application",
        "roles": [
          {
            "scheduled_policies": [
              {
                "adjust": 4,
                "type": "CHANGE",
                "recurrence": "0 2 1-10 * * "
              }
            ],
            "template_id": 0,
            "type": "vm",
            "name": "frontend",
            "min_vms": 1,
            "max_vms": 4,
            "cardinality": 1,
            "cooldown": 30,
            "shutdown_action": "shutdown",
            "elasticity_policies": [
              {
                "expression": "CUSTOM_ATT>40",
                "adjust": 20,
                "min_adjust_step": 1,
                "cooldown": 30,
                "period": 3,
                "period_number": 30,
                "type": "PERCENTAGE_CHANGE"
              }
            ]
          },
          {
            "scheduled_policies": [

            ],
            "template_id": 0,
            "type": "vm",
            "name": "worker",
            "min_vms": 2,
            "max_vms": 10,
            "cardinality": 2,
            "parents": [
              "frontend"
            ],
            "cooldown": 240,
            "shutdown_action": "shutdown",
            "elasticity_policies": [
              {
                "expression": "ATT=3",
                "adjust": 5,
                "cooldown": 240,
                "period": 5,
                "period_number": 60,
                "type": "CHANGE"
              }
            ]
          }
        ],
        "shutdown_action": "shutdown"
      }
    },
    "TYPE": "101",
    "GNAME": "oneadmin",
    "NAME": "web-application",
    "GID": "0",
    "ID": "4",
    "UNAME": "oneadmin",
    "PERMISSIONS": {
      "OWNER_A": "0",
      "OWNER_M": "1",
      "OWNER_U": "1",
      "OTHER_A": "0",
      "OTHER_M": "0",
      "OTHER_U": "0",
      "GROUP_A": "0",
      "GROUP_M": "0",
      "GROUP_U": "0"
    },
    "UID": "0"
  }
```

### Get Detailed Information of a Given Service Template

| Method   | URL                      | Meaning / Entity Body                                       | Response                                                              |
|----------|--------------------------|-------------------------------------------------------------|-----------------------------------------------------------------------|
| **GET**  | `/service_template/<id>` | **Show** the `SERVICE_TEMPLATE` resource identified by `<id>` | **200 OK**: A JSON representation of the collection in the HTTP body. |
```default
curl -u 'oneadmin:password' http://127.0.0.1:2474/service_template/4 -v
```

```default
> GET /service_template/4 HTTP/1.1
> Authorization: Basic b25lYWRtaW46b3Blbm5lYnVsYQ==
> User-Agent: curl/7.19.7 (x86_64-redhat-linux-gnu) libcurl/7.19.7 NSS/3.14.0.0 zlib/1.2.3 libidn/1.18 libssh2/1.4.2
> Host: 127.0.0.1:2474
> Accept: */*
>
< HTTP/1.1 200 OK
< Content-Type: text/html;charset=utf-8
< X-XSS-Protection: 1; mode=block
< Content-Length: 1990
< X-Frame-Options: sameorigin
< Connection: keep-alive
< Server: thin 1.2.8 codename Black Keys
<
{
  "DOCUMENT": {
    "TEMPLATE": {
      "BODY": {
        "deployment": "straight",
        "name": "web-application",
        "roles": [
          {
            "scheduled_policies": [
              {
                "adjust": 4,
                "type": "CHANGE",
                "recurrence": "0 2 1-10 * * "
              }
            ],
            "template_id": 0,
            "type": "vm",
            ...
```

### List the Available Service Templates

| Method   | URL                 | Meaning / Entity Body                                       | Response                                                              |
|----------|---------------------|-------------------------------------------------------------|-----------------------------------------------------------------------|
| **GET**  | `/service_template` | **List** the contents of the `SERVICE_TEMPLATE` collection. | **200 OK**: A JSON representation of the collection in the HTTP body. |
```default
curl -u 'oneadmin:password' http://127.0.0.1:2474/service_template -v
```

```default
> GET /service_template HTTP/1.1
> Authorization: Basic b25lYWRtaW46b3Blbm5lYnVsYQ==
> User-Agent: curl/7.19.7 (x86_64-redhat-linux-gnu) libcurl/7.19.7 NSS/3.14.0.0 zlib/1.2.3 libidn/1.18 libssh2/1.4.2
> Host: 127.0.0.1:2474
> Accept: */*
>
< HTTP/1.1 200 OK
< Content-Type: text/html;charset=utf-8
< X-XSS-Protection: 1; mode=block
< Content-Length: 6929
< X-Frame-Options: sameorigin
< Connection: keep-alive
< Server: thin 1.2.8 codename Black Keys
<
{
  "DOCUMENT_POOL": {
    "DOCUMENT": [
      {
        "TEMPLATE": {
          "BODY": {
            "deployment": "straight",
            "name": "web-server",
            "roles": [
              {
                "scheduled_policies": [
                  {
                    "adjust": 4,
                    "type": "CHANGE",
                    "recurrence": "0 2 1-10 * * "
                  }
                ],
                "template_id": 0,
                "type": "vm",
                "name": "frontend",
                "min_vms": 1,
                "max_vms": 4,
                "cardinality": 1,
                "cooldown": 30,
                "shutdown_action": "shutdown",
                "elasticity_policies": [
                  {
                ...
```

### Update a Given Template

| Method   | URL                      | Meaning / Entity Body                                          | Response    |
|----------|--------------------------|----------------------------------------------------------------|-------------|
| **PUT**  | `/service_template/<id>` | **Update** the `SERVICE_TEMPLATE` resource identified by `<id>`. | **200 OK**: |
```default
curl http://127.0.0.1:2474/service_template/4 -u 'oneadmin:password' -v -X PUT --data '{
  "name":"web-application",
  "deployment":"straight",
  "roles":[
    {
      "name":"frontend",
      "cardinality":"1",
      "template_id":"0",
      "shutdown_action":"shutdown-hard",
      "min_vms":"1",
      "max_vms":"4",
      "cooldown":"30",
      "elasticity_policies":[
        {
          "type":"PERCENTAGE_CHANGE",
          "adjust":"20",
          "min_adjust_step":"1",
          "expression":"CUSTOM_ATT>40",
          "period":"3",
          "period_number":"30",
          "cooldown":"30"
        }
      ],
      "scheduled_policies":[
        {
          "type":"CHANGE",
          "adjust":"4",
          "recurrence":"0 2 1-10 * * "
        }
      ]
    },
    {
      "name":"worker",
      "cardinality":"2",
      "template_id":"0",
      "type": "vm",
      "shutdown_action":"shutdown",
      "parents":[
        "frontend"
      ],
      "min_vms":"2",
      "max_vms":"10",
      "cooldown":"240",
      "elasticity_policies":[
        {
          "type":"CHANGE",
          "adjust":"5",
          "expression":"ATT=3",
          "period":"5",
          "period_number":"60",
          "cooldown":"240"
        }
      ],
      "scheduled_policies":[
      ]
    }
  ],
  "shutdown_action":"shutdown"
}'
```

```default
> PUT /service_template/4 HTTP/1.1
> Authorization: Basic b25lYWRtaW46b3Blbm5lYnVsYQ==
> User-Agent: curl/7.19.7 (x86_64-redhat-linux-gnu) libcurl/7.19.7 NSS/3.14.0.0 zlib/1.2.3 libidn/1.18 libssh2/1.4.2
> Host: 127.0.0.1:2474
> Accept: */*
> Content-Length: 1219
> Content-Type: application/x-www-form-urlencoded
> Expect: 100-continue
>
* Done waiting for 100-continue
< HTTP/1.1 200 OK
< Content-Type: text/html;charset=utf-8
< X-XSS-Protection: 1; mode=block
< Content-Length: 1995
< X-Frame-Options: sameorigin
< Connection: keep-alive
< Server: thin 1.2.8 codename Black Keys
<
{
  "DOCUMENT": {
    "TEMPLATE": {
      "BODY": {
        "deployment": "straight",
        "name": "web-application",
        "roles": [
          {
            "scheduled_policies": [
              {
                "adjust": 4,
                "type": "CHANGE",
                "recurrence": "0 2 1-10 * * "
              }
            ],
            "template_id": 0,
            "type": "vm",
            "name": "frontend",
            "min_vms": 1,
            "max_vms": 4,
            "cardinality": 1,
            "cooldown": 30,
            "shutdown_action": "shutdown-hard",
            ...
```

### Instantiate a Given Template

| Method   | URL                             | Meaning / Entity Body                                                                                                                     | Response   |
|----------|---------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------|------------|
| **POST** | `/service_template/<id>/action` | **Perform** an action on the `SERVICE_TEMPLATE` resource identified by `<id>`. Available actions: `instantiate`, `chown`, `chgrp`, `chmod`. | **201**:   |
```default
curl http://127.0.0.1:2474/service_template/4/action -u 'oneadmin:password' -v -X POST --data '{
  "action": {
    "perform":"instantiate"
  }
}'
```

```default
> POST /service_template/4/action HTTP/1.1
> Authorization: Basic b25lYWRtaW46b3Blbm5lYnVsYQ==
> User-Agent: curl/7.19.7 (x86_64-redhat-linux-gnu) libcurl/7.19.7 NSS/3.14.0.0 zlib/1.2.3 libidn/1.18 libssh2/1.4.2
> Host: 127.0.0.1:2474
> Accept: */*
> Content-Length: 49
> Content-Type: application/x-www-form-urlencoded
>
< HTTP/1.1 201 Created
< Content-Type: text/html;charset=utf-8
< X-XSS-Protection: 1; mode=block
< Content-Length: 2015
< X-Frame-Options: sameorigin
< Connection: keep-alive
< Server: thin 1.2.8 codename Black Keys
<
{
  "DOCUMENT": {
    "TEMPLATE": {
      "BODY": {
        "deployment": "straight",
        "name": "web-application",
        "roles": [
          {
            "scheduled_policies": [
              {
                "adjust": 4,
                "type": "CHANGE",
                "recurrence": "0 2 1-10 * * "
              }
            ],
            "template_id": 0,
            "type": "vm",
```

Additional parameters can be passed using the `merge_template` inside the `params`. For example, if we want to change the name when instantiating:

```default
curl http://127.0.0.1:2474/service_template/4/action -u 'oneadmin:password' -v -X POST --data '{
  "action": {
    "perform":"instantiate",
    "params": {"merge_template":{"name":"new_name"}}
  }
}'
```

The following attributes can be also passed using the `merge_template`:

* `network_values`
* `user_inputs_values`
* `template_contents`

For example, to instantiate a service template with custom VM capacity:

```default
curl http://127.0.0.1:2474/service_template/4/action -u 'oneadmin:password' -v -X POST --data '{
  "action": {
    "perform":"instantiate",
    "params":{
      "merge_template": {
        "template_contents": {
          "HOT_RESIZE": {
            "CPU_HOT_ADD_ENABLED": "YES",
            "MEMORY_HOT_ADD_ENABLED": "YES"
          },
          "MEMORY_RESIZE_MODE": "BALLOONING",
          "VCPU_MAX": "2",
          "MEMORY_MAX": "128"
        }
      }
    }
}'
```

### Delete a Given Template

| Method     | URL                      | Meaning / Entity Body                                          | Response   |
|------------|--------------------------|----------------------------------------------------------------|------------|
| **DELETE** | `/service_template/<id>` | **Delete** the `SERVICE_TEMPLATE` resource identified by `<id>`. | **204**:   |
```default
curl http://127.0.0.1:2474/service_template/4 -u 'oneadmin:password' -v -X DELETE
```

```default
> DELETE /service_template/3 HTTP/1.1
> Authorization: Basic b25lYWRtaW46b3Blbm5lYnVsYQ==
> User-Agent: curl/7.19.7 (x86_64-redhat-linux-gnu) libcurl/7.19.7 NSS/3.14.0.0 zlib/1.2.3 libidn/1.18 libssh2/1.4.2
> Host: 127.0.0.1:2474
> Accept: */*
>
< HTTP/1.1 204 No Content
< Content-Type: text/html;charset=utf-8
< X-XSS-Protection: 1; mode=block
< Content-Length: 0
< X-Frame-Options: sameorigin
< Connection: keep-alive
< Server: thin 1.2.8 codename Black Keys
```

### Get Detailed Information of a Given Service

| Method   | URL             | Meaning / Entity Body                               | Response                                                              |
|----------|-----------------|-----------------------------------------------------|-----------------------------------------------------------------------|
| **GET**  | `/service/<id>` | **Show** the `SERVICE` resource identified by `<id>`. | **200 OK**: A JSON representation of the collection in the HTTP body. |
```default
curl http://127.0.0.1:2474/service/5 -u 'oneadmin:password' -v
```

```default
> GET /service/5 HTTP/1.1
> Authorization: Basic b25lYWRtaW46b3Blbm5lYnVsYQ==
> User-Agent: curl/7.19.7 (x86_64-redhat-linux-gnu) libcurl/7.19.7 NSS/3.14.0.0 zlib/1.2.3 libidn/1.18 libssh2/1.4.2
> Host: 127.0.0.1:2474
> Accept: */*
>
< HTTP/1.1 200 OK
< Content-Type: text/html;charset=utf-8
< X-XSS-Protection: 1; mode=block
< Content-Length: 11092
< X-Frame-Options: sameorigin
< Connection: keep-alive
< Server: thin 1.2.8 codename Black Keys
<
{
  "DOCUMENT": {
    "TEMPLATE": {
      "BODY": {
        "deployment": "straight",
        "name": "web-application",
        "roles": [
          {
            "scheduled_policies": [
              {
                "adjust": 4,
                "last_eval": 1374676803,
                "type": "CHANGE",
                "recurrence": "0 2 1-10 * * "
              }
            ],
            "template_id": 0,
            "type": "vm",
            "disposed_nodes": [

            ],
            "name": "frontend",
            "min_vms": 1,
            "nodes": [
              {
                "deploy_id": 12,
                "vm_info": {
                  "VM": {
                    "GNAME": "oneadmin",
                    "NAME": "frontend_0_(service_5)",
                    "GID": "0",
                    "ID": "12",
                    "UNAME": "oneadmin",
                    "UID": "0",
                  }
                }
              }
            ],
            "last_vmname": 1,
            "max_vms": 4,
            "cardinality": 1,
            "cooldown": 30,
            "shutdown_action": "shutdown-hard",
            "state": "2",
            "elasticity_policies": [
              {
                "expression": "CUSTOM_ATT>40",
                "true_evals": 0,
                "adjust": 20,
                "min_adjust_step": 1,
                "last_eval": 1374676803,
                "cooldown": 30,
                "expression_evaluated": "CUSTOM_ATT[--] > 40",
                "period": 3,
                "period_number": 30,
                "type": "PERCENTAGE_CHANGE"
              }
            ]
          },
          {
            "scheduled_policies": [

            ],
            "template_id": 0,
            "type": "vm",
            "disposed_nodes": [

            ],
            "name": "worker",
            "min_vms": 2,
            "nodes": [
              {
                "deploy_id": 13,
                "vm_info": {
                  "VM": {
                    "GNAME": "oneadmin",
                    "NAME": "worker_0_(service_5)",
                    "GID": "0",
                    "ID": "13",
                    "UNAME": "oneadmin",
                    "UID": "0",
                  }
                }
              },
              {
                "deploy_id": 14,
                "vm_info": {
                  "VM": {
                    "GNAME": "oneadmin",
                    "GID": "0",
                    "ID": "14",
                    "UNAME": "oneadmin",
                    "UID": "0",
                  }
                }
              }
            ],
            "last_vmname": 2,
            "max_vms": 10,
            "cardinality": 2,
            "parents": [
              "frontend"
            ],
            "cooldown": 240,
            "shutdown_action": "shutdown",
            "state": "2",
            "elasticity_policies": [
              {
                "expression": "ATT=3",
                "true_evals": 0,
                "adjust": 5,
                "last_eval": 1374676803,
                "cooldown": 240,
                "expression_evaluated": "ATT[--] = 3",
                "period": 5,
                "period_number": 60,
                "type": "CHANGE"
              }
            ]
          }
        ],
        "log": [
          {
            "message": "New state: DEPLOYING",
            "severity": "I",
            "timestamp": 1374676345
          },
          {
            "message": "New state: RUNNING",
            "severity": "I",
            "timestamp": 1374676406
          }
        ],
        "shutdown_action": "shutdown",
        "state": 2
      }
    },
    "TYPE": "100",
    "GNAME": "oneadmin",
    "NAME": "web-application",
    "GID": "0",
    "ID": "5",
    "UNAME": "oneadmin",
    "PERMISSIONS": {
      "OWNER_A": "0",
      "OWNER_M": "1",
      "OWNER_U": "1",
      "OTHER_A": "0",
      "OTHER_M": "0",
      "OTHER_U": "0",
      "GROUP_A": "0",
      "GROUP_M": "0",
      "GROUP_U": "0"
    },
    "UID": "0"
  }
```

### List the Available Services

| Method   | URL        | Meaning / Entity Body                              | Response                                                              |
|----------|------------|----------------------------------------------------|-----------------------------------------------------------------------|
| **GET**  | `/service` | **List** the contents of the `SERVICE` collection. | **200 OK**: A JSON representation of the collection in the HTTP body. |
```default
curl http://127.0.0.1:2474/service -u 'oneadmin:password' -v
```

```default
> GET /service HTTP/1.1
> Authorization: Basic b25lYWRtaW46b3Blbm5lYnVsYQ==
> User-Agent: curl/7.19.7 (x86_64-redhat-linux-gnu) libcurl/7.19.7 NSS/3.14.0.0 zlib/1.2.3 libidn/1.18 libssh2/1.4.2
> Host: 127.0.0.1:2474
> Accept: */*
>
< HTTP/1.1 200 OK
< Content-Type: text/html;charset=utf-8
< X-XSS-Protection: 1; mode=block
< Content-Length: 12456
< X-Frame-Options: sameorigin
< Connection: keep-alive
< Server: thin 1.2.8 codename Black Keys
<
{
  "DOCUMENT_POOL": {
    "DOCUMENT": [
      {
        "TEMPLATE": {
          "BODY": {
            "deployment": "straight",
            "name": "web-application",
            "roles": [
              {
                "scheduled_policies": [
                  {
                    "adjust": 4,
                    "last_eval": 1374676986,
                    "type": "CHANGE",
                    "recurrence": "0 2 1-10 * * "
                  }
                ],
                ...
```

### Perform an Action on a Given Service

| Method   | URL                    | Meaning / Entity Body                                               | Response   |
|----------|------------------------|---------------------------------------------------------------------|------------|
| **POST** | `/service/<id>/action` | **Perform** an action on the `SERVICE` resource identified by `<id>`. | **201**:   |

Available actions:

* **recover**: Recover a failed service by cleaning the failed VMs.
  : * From `FAILED_DEPLOYING` continues deploying the Service.
    * From `FAILED_SCALING` continues scaling the Service.
    * From `FAILED_UNDEPLOYING` continues shutting down the Service.
    * From `COOLDOWN` the Service is set to running, ignoring the cooldown duration.
    * `"delete" : true` in `params` will delete the service and its VMs no matter what state the service is in.
* **chown**
* **chmod**
* **chgrp**

```default
curl http://127.0.0.1:2474/service/5/action -u 'oneadmin:password' -v -X POST --data '{
  "action": {
    "perform":"chgrp",
    "params" : {
      "group_id" : 2
    }
  }
}'
```

### Perform an Action on All the VMs of a Given Role

| Method   | URL                                | Meaning / Entity Body                                                                                                                        | Response   |
|----------|------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------|------------|
| **POST** | `/service/<id>/role/<name>/action` | **Perform** an action on all the Virtual Machines belonging to the `ROLE` identified by `<name>` of the `SERVICE` resource identified by `<id>`. | **201**:   |

You can use this call to perform a VM action on all the Virtual Machines belonging to a Role. For example, if you want to suspend the Virtual Machines of the worker Role, these are the commands that can be performed:

* `shutdown`
* `shutdown-hard`
* `undeploy`
* `undeploy-hard`
* `hold`
* `release`
* `stop`
* `suspend`
* `resume`
* `boot`
* `delete`
* `delete-recreate`
* `reboot`
* `reboot-hard`
* `poweroff`
* `poweroff-hard`
* `snapshot-create`
* `snapshot-revert`
* `snapshot-delete`
* `disk-snapshot-create`
* `disk-snapshot-revert`
* `disk-snapshot-delete`

Instead of performing the action immediately on all the VMs, you can perform it on small groups of VMs with these options:

* `period`: seconds between each group of actions.
* `number`: number of VMs to apply the action to each period.

```default
curl http://127.0.0.1:2474/service/5/role/frontend/action -u 'oneadmin:password' -v -X POST --data '{
  "action": {
    "perform":"stop",
    "params" : {
      "period" : 60,
      "number" : 2
    }
  }
}'
```

### Add a Role to a Running Service

| Method   | URL                         | Meaning / Entity Body                              | Response   |
|----------|-----------------------------|----------------------------------------------------|------------|
| **POST** | `/service/<id>/role_action` | **Add** or **remove** a Role from running service. | **204**:   |
```default
curl http://127.0.0.1:2474/service/5/role_action -u 'oneadmin:password' -v -X POST --data '{
  "action": {
    "perform":"add_role",
    "params" : {
      "role" : '{
            "name": "NEW_ROLE",
            "cardinality": 1,
            "template_id": 0,
            "type": "vm",
            "min_vms": 1,
            "max_vms": 2,
            "elasticity_policies": [],
            "scheduled_policies": []
      }'
    }
  }
}'
```

### Remove a Role from a Running Service

| Method   | URL                         | Meaning / Entity Body                              | Response   |
|----------|-----------------------------|----------------------------------------------------|------------|
| **POST** | `/service/<id>/role_action` | **Add** or **remove** a Role from running service. | **204**:   |
```default
curl http://127.0.0.1:2474/service/5/role_action -u 'oneadmin:password' -v -X POST --data '{
  "action": {
    "perform":"remove_role",
    "params" : {
      "role" : 'NEW_ROLE'
    }
  }
}'
```

### Update a Service

| Method   | URL             | Meaning / Entity Body                                 | Response    |
|----------|-----------------|-------------------------------------------------------|-------------|
| **PUT**  | `/service/<id>` | **Update** the `SERVICE` resource identified by `<id>`. | **200 OK**: |

Append can be used to append information to the service, in this case the request body must include the following information:

* `append`: set to `true`.
* `template`: JSON representation of the template to append.

```default
curl http://127.0.0.1:2474/service/4 -u 'oneadmin:password' -v -X PUT --data '{
  "name":"web-application",
  "deployment":"straight",
  "roles":[
    {
      "name":"frontend",
      "cardinality":"1",
      "template_id":"0",
      "type": "vm",
      "shutdown_action":"shutdown-hard",
      "min_vms":"1",
      "max_vms":"4",
      "cooldown":"30",
      "elasticity_policies":[
        {
          "type":"PERCENTAGE_CHANGE",
          "adjust":"20",
          "min_adjust_step":"1",
          "expression":"CUSTOM_ATT>40",
          "period":"3",
          "period_number":"30",
          "cooldown":"30"
        }
      ],
      "scheduled_policies":[
        {
          "type":"CHANGE",
          "adjust":"4",
          "recurrence":"0 2 1-10 * * "
        }
      ]
    },
    {
      "name":"worker",
      "cardinality":"2",
      "template_id":"0",
      "type": "vm",
      "shutdown_action":"shutdown",
      "parents":[
        "frontend"
      ],
      "min_vms":"2",
      "max_vms":"10",
      "cooldown":"240",
      "elasticity_policies":[
        {
          "type":"CHANGE",
          "adjust":"5",
          "expression":"ATT=3",
          "period":"5",
          "period_number":"60",
          "cooldown":"240"
        }
      ],
      "scheduled_policies":[
      ]
    }
  ],
  "shutdown_action":"shutdown"
}'
```

```default
> PUT /service/4 HTTP/1.1
> Authorization: Basic b25lYWRtaW46b3Blbm5lYnVsYQ==
> User-Agent: curl/7.19.7 (x86_64-redhat-linux-gnu) libcurl/7.19.7 NSS/3.14.0.0 zlib/1.2.3 libidn/1.18 libssh2/1.4.2
> Host: 127.0.0.1:2474
> Accept: */*
> Content-Length: 1219
> Content-Type: application/x-www-form-urlencoded
> Expect: 100-continue
>
* Done waiting for 100-continue
< HTTP/1.1 200 OK
< Content-Type: text/html;charset=utf-8
< X-XSS-Protection: 1; mode=block
< Content-Length: 1995
< X-Frame-Options: sameorigin
< Connection: keep-alive
< Server: thin 1.2.8 codename Black Keys
<
{
  "DOCUMENT": {
    "TEMPLATE": {
      "BODY": {
        "deployment": "straight",
        "name": "web-application",
        "roles": [
          {
            "scheduled_policies": [
              {
                "adjust": 4,
                "type": "CHANGE",
                "recurrence": "0 2 1-10 * * "
              }
            ],
            "template_id": 0,
            "type": "vm",
            "name": "frontend",
            "min_vms": 1,
            "max_vms": 4,
            "cardinality": 1,
            "cooldown": 30,
            "shutdown_action": "shutdown-hard",
            ...
```
