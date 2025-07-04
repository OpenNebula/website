---
title: "Python OpenNebula Cloud API"
date: "2025-02-17"
description:
categories:
pageintoc: "284"
tags:
weight: "4"
---

<a id="python"></a>

<!--# PyONE: OpenNebula Python Bindings -->

PyONE is an implementation of OpenNebula XML-RPC bindings in Python. It has been designed as a wrapper for the [XML-RPC methods]({{% relref "api#api" %}}), with some basic helpers. This means that you should be familiar with the XML-RPC API and the XML formats returned by the OpenNebula core. As stated in the [XML-RPC documentation]({{% relref "api#api" %}}), you can download the [XML Schemas (XSD) here]({{% relref "api#api-xsd-reference" %}}).

## API Documentation

As long as the code is generated, the main source of the documentation is still the [XML-RPC doc]({{% relref "api#api" %}})

## Download and installation

You can either use the system package `python3-pyone` or install it using `pip install pyone`.

## Usage

You need to configure your XML-RPC Server endpoint and credentials when instantiating the OneServer class:

```python
import pyone
one = pyone.OneServer("http://one:2633/RPC2", session="oneadmin:onepass")
```

If you are connecting to a test platform with a self-signed certificate you can disable
certificate verification as:

```python
import pyone
import ssl
one = pyone.OneServer("https://one:8443/RPC2", session="oneadmin:onepass", https_verify=False)
```

It is also possible to modify the default connection timeout, but note that the setting will modify the TCP socket default timeout of your Python VM. Ensure that the chosen timeout is suitable for any other connections running in your project.

### Making Calls

Calls match the API documentation provided by OpenNebula, so for example the following code corresponds to XML api call [one.hostpool.info]({{% relref "api#api-hostpool-info" %}}):

```python
import pyone

one = pyone.OneServer("http://one:2633/RPC2", session="oneadmin:onepass" )
hostpool = one.hostpool.info()
host = hostpool.HOST[0]
id = host.ID
```

Note that the session parameter is automatically included as well as the “one.” prefix to the method.

### Returned Objects

The returned types have been generated with generateDS and closely match the XSD specification.  You can use the XSD specification and  XML-RPC as primary documentation.

```python
marketpool = one.marketpool.info()
m0 = marketpool.MARKETPLACE[0]
print "Marketplace name is " + m0.NAME
```

### Structured Parameters

When making calls, the library will translate flat dictionaries into attribute=value vectors, such as:

```python
one.host.update(0,  {"LABELS": "HD"}, 1)
```

When the provided dictionary has a “root” dictionary, it is considered to be root
element and it will be translated to XML:

```python
one.vm.update(1,
  {
    'TEMPLATE': {
      'NAME': 'abc',
      'MEMORY': '1024',
      'ATT1': 'value1'
    }
  }, 1)
```

When there are multiple entries with the same key like DISK or NIC, you can use array (from the version 6.8+).

```python
one.vm.update(1,
  {
    'TEMPLATE': {
      'NAME': 'test100',
      'MEMORY': '1024',
      'DISK': [
        { 'IMAGE_ID': 1 },
        { 'IMAGE_ID': 2 },
      ]
    }
  }, 1)
```

In any case, it’s always possible to pass the template directly in OpenNebula format:

```python
one.template.allocate(
  '''NAME="test100"
     MEMORY="1024"
     DISK=[ IMAGE_ID= "1" ]
     DISK=[ IMAGE_ID= "2" ]
     CPU="1"
     VCPU="2"
  ''')
```

generateDS creates members from most returned parameters, however, some elements in the XSD are marked as anyType and generateDS cannot generate members automatically, TEMPLATE and USER_TEMPLATE are the common ones. PyONE will allow its contents to be accessed as a plain python dictionary:

```python
host = one.host.info(0)
arch = host.TEMPLATE['ARCH']
```

This makes it possible to read a TEMPLATE as dictionary, modify it, and use it as parameter for an update method, as in the following:

```python
host = one.host.info(0)
host.TEMPLATE['NOTES']="Just updated"
one.host.update(0,host.TEMPLATE,1)
```

### Constants

Some methods will return encoded values such as those representing the STATE of a resource. Constants are provided to better handle those:

```python
from pyone import MARKETPLACEAPP_STATES
if app.STATE == MARKETPLACEAPP_STATES.READY:
  # action that assumes app ready
```

### More examples

```python
import pyone
one = pyone.OneServer("http://one:2633/RPC2", session="oneadmin:onepass" )
```

Allocate localhost as new host:

```python
one.host.allocate('localhost', 'kvm', 'kvm', 0)
```

See host template:

```python
host = one.hostpool.info().HOST[0]
dict(host.TEMPLATE)
```

See VM template:

```python
vm_template = one.templatepool.info(-1, -1, -1).VMTEMPLATE[0]
vm_template.get_ID()
vm_template.get_NAME()
```

Instantiate it:

```python
one.template.instantiate(0, "my_VM")
```

See it:

```python
my_vm = one.vmpool.info(-1,-1,-1,-1).VM[0]
my_vm.get_ID()
my_vm.get_NAME()
my_vm.get_TEMPLATE()
```

Terminate it:

```python
one.vm.action('terminate', 0)
```

## Credits

Python bindings were ported to upstream from stand-alone PyONE addon made by *Rafael del Valle* [PyONE](https://pypi.org/project/pyone/1.0.5/).
