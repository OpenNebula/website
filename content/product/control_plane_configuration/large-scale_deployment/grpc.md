---
title: "gRPC"
linkTitle: "gRPC"
date: "2025-02-28"
description:
categories:
pageintoc: "44"
tags:
weight: "5"
---

<a id="one-grpc"></a>

<!--# gRPC -->

## Overview

gRPC serves as the modern communication backbone for OpenNebula, replacing XML-RPC with a faster, more efficient protocol. By using binary serialization, gRPC outperforms traditional text-based protocols in both speed and payload size. It simplifies development by providing typed contracts and multi-language support, ensuring the codebase remains scalable and easy to maintain.

## Configuration

To enable and utilize gRPC within an OpenNebula environment, configuration is required at both the daemon level (server-side) and the client level.

### Enabling the gRPC Service

The gRPC server is managed by the oned daemon and enable by default. To modify the default values, edit `/etc/one/oned.conf` and define the listening port and address:

> ```none
> GRPC_PORT = 2634
> GRPC_LISTEN_ADDRESS = "0.0.0.0"
> ```

### Using the gRPC Clients

OpenNebula 7.2 provides gRPC support for the Ruby (CLI), Go, and Python (partial). When using the Command Line Interface (CLI), you can toggle the protocol using one of the following methods:

* Flag-based: Append the `--grpc` flag to any supported command.
* Environment-based: Set `ONEAPI_PROTOCOL=grpc` in your shell profile to make gRPC the default for all commands.

By default, the client attempts to connect to the local endpoint. You can override this by specifying the target server address:

> ```Bash
> export ONE_GRPC="<IP_ADDRESS>:<PORT>"
> ```

### Integration with OneFlow

To configure the OneFlow service to communicate with oned via gRPC, update the `:one_xmlrpc` setting in `/etc/one/oneflow-server.conf` to point to the gRPC endpoint:

> ```yaml
> :one_xmlrpc: 127.0.0.1:2634
> ```

### High Availability (HA) and Federation

In distributed environments, explicit endpoint definitions are required to ensure the client can reach the active leader or the correct regional zone.

* High Availability: Define the `ENDPOINT_GRPC` attribute for every node within the cluster.
* Federation: Define the `ENDPOINT_GRPC` attribute for each Zone in the federation.

[!CAUTION] Important: If a client is configured to use gRPC but the `ENDPOINT_GRPC` is missing in an HA or Federated setup, commands may fail to route correctly, resulting in connection errors.

## Performance

This section provides a comparative analysis of response times between the legacy XML-RPC and the new gRPC protocol.

### Benchmark Methodology

To ensure realistic results, the protocols were tested against a synthetic workload designed to simulate a medium-to-large OpenNebula deployment. The core oned service was stressed in a single-zone configuration with the following environment specifications:

| Metric                   | Value   |
|--------------------------|---------|
| Number of hosts          | 1,250   |
| Number of VMs            | 20,000  |
| Average VM template size | 10 KB   |

The workload consisted of the four most common API calls, executed simultaneously to mirror the request ratio observed in production environments

### Comparative Results

The following table illustrates the average response times (in seconds) under two different load intensities: 10 requests per second (req/s) and 30 req/s.

<!--# gRPC
|---------------------|--------------------|--------------------|--------------------|--------------------|
-->

| Protocol      | XML-RPC  | gRPC     | XML-RPC  | gRPC     |
|---------------|----------|----------|----------|----------|
| API Load      | 10 req/s | 10 req/s | 30 req/s | 30 req/s |
| host.info     | 0.01     | 0.01     | 0.07     | 0.02     |
| hostpool.info | 0.07     | 0.02     | 0.17     | 0.03     |
| vm.info       | 0.02     | 0.01     | 0.07     | 0.02     |
| vmpool.info   | 0.97     | 0.43     | 2.15     | 0.94     |

For data-intensive calls like vmpool.info, gRPC reduces latency by over 50%, demonstrating the efficiency of binary serialization over text-based XML. The performance advantage of gRPC becomes more significant as the API load increases. At 30 req/s, gRPC consistently delivers responses 2 to 3 times faster than XML-RPC.

## Development

A primary advantage of gRPC is the ability to generate native client libraries for virtually any programming language using the core service definitions.

### Protocol Buffers (.proto)

The contract between the OpenNebula server and any client is defined in `.proto` files. These files describe the services, RPC methods, and data structures. You can find these definitions in the OpenNebula source tree: `src/rm/grpc/proto/`

### Generating Language Bindings

If you require support for a language not currently provided by the core team (such as Rust, Java, or C#), you can generate your own bindings using the protoc compiler and the appropriate plugin for your language.

### Example: Generating C++ Bindings

To generate the header and source files manually, you would typically use a command similar to this:

> ```Bash
> protoc -I=src/rm/grpc/proto --cpp_out=./output --grpc_out=./output \
>        --plugin=protoc-gen-grpc=`which grpc_cpp_plugin` \
>        src/rm/grpc/proto/user.proto
> ```

### Contributing

We encourage developers to explore the existing Go and Ruby implementations within the source code as templates for building new language providers.