---
title: "Validation of the AI Factory with LLM Inference"
linkTitle: "LLM Inference"
date: "2025-10-28"
description:
categories:
pageintoc: "68"
tags:
weight: 4
---

{{< alert title="Important" color="success" >}}
To perform the validation with LLM Inference you must comply with one of the prerequisites:
* Have an AI Factory ready to be validated; or,
* Configure an AI Factory by following one of these options:
     * [On-premises AI Factory Deployment]({{% relref "/solutions/deployment_blueprints/ai-ready_opennebula/cd_on-premises" %}})
     * [AI Factory Deployment on Scaleway Cloud]({{% relref "/solutions/deployment_blueprints/ai-ready_opennebula/cd_cloud"%}})
{{< /alert >}}

As Large Language Models (LLMs) are increasingly adopted across industries, ensuring their inference performance is optimized and validated has become a critical part of the deployment process. Efficient inference is essential to guarantee that LLMs deliver high-quality results while maintaining scalability, responsiveness, and cost-effectiveness.

The LLM Inference Benchmarks focus on measuring performance metrics during the model serving process, i.e. the efficiency of inference, rather than the quality of the generated result. Metrics assessed by this type of benchmarks typically include:
  - **Latency**: How fast the model responds to a request.
  - **Throughput**: The number of requests the model can handle per unit of time.
  - **Stability**: Model serving consistency under varying loads.

The following guide provides the necessary steps and best practices to perform LLM inference benchmarking with OpenNebula.

## The vLLM Inference Framework

This benchmark focuses on [vLLM](https://docs.vllm.ai/en/latest/), a production-grade, high-performance inference engine designed for large-scale LLM serving.

The main characteristics of vLLM are:

- Supports single-node deployments with one or more GPUs.
- Uses Python’s native multiprocessing for multi-GPU inference.
- Does not require additional frameworks, such as Ray, unless deploying across multiple nodes, which is out of scope for this benchmarking task.

## Benchmark Environments

To test the vLLM appliance, the benchmark uses two similar environments, but with different GPU models:
- Benchmark environment 1: 1x NVIDIA L40S 48GB GPU cards
- Benchmark environment 2: 1x NVIDIA H100L 94GB GPU card

### Hardware Specification

#### Front-end Requirements

| FRONT-END  |
| :---- | :---- |
| Number of Zones | 1 |
| Cloud Manager | OpenNebula 7.0 |
| Server Specs | Supermicro Hyper A+ server, details in the [table below](#server-specifications) |
| Operating System | Ubuntu 24.04.2 LTS |
| High Availability | No (1 Front-end) |
| Authorization | Builtin |

#### Host Requirements

| VIRTUALIZATION HOSTS  |
| :---- | :---- |
| Number of Nodes | 1 |
| Server Specs | Supermicro Hyper A+ server, details in the [table below](#server-specifications) |
| Operating System | Ubuntu 24.04.2 LTS |
| Hypervisor | KVM |
| Special Devices | NVIDIA GPU cards, details in [table below](#server-specifications)|

#### Storage Specification

| STORAGE   |
| :---- | :---- |
| Type | Local disk |
| Capacity | 1 Datastore |

#### Network Requirements

| NETWORK   |
| :---- | :---- |
| Networking | bridge |
| Number of Networks | 1 networks: service |

#### Provisioning Model

| PROVISIONING MODEL  |
| :---- | :---- |
| Manual on-prem | The two servers have been manually provisioned and configured on-prem. |

#### Server Specifications

The server specifications are based on a two-server setup for each environment: one server operates as the OpenNebula frontend and the other one is the cluster for VMs host with the GPU cards attached. This setup is compatible with any OpenNebula setup having a host server with AI-ready NVIDIA GPUs.

| Parameter                | Environment 1                                 | Environment 2                                 |
|--------------------------|-----------------------------------------------|-----------------------------------------------|
| **GPU model**            | NVIDIA L40S 48GB                              | NVIDIA H100L 94GB                             |
| **Server model**         | Supermicro A+ Server AS -2025HS-TNR           | Supermicro A+ Server AS -2025HS-TNR           |
| **Architecture**         | amd64 (x86_64 bits)                           | amd64 (x86_64 bits)                           |
| **CPU Model**            | AMD(R) EPYC 9334 Processor @2.7GHz            | AMD (R) EPYC 9335 Processor @3.0GHz           |
| **CPU Vendor**           | AMD(R)                                        | AMD(R)                                        |
| **CPU Cores**            | 128 (2 socket × 32 cores, 2 threads per core) | 128 (2 socket × 32 cores, 2 threads per core) |
| **CPU Frequency**        | 2,7 GHz                                       | 3,0 GHz                                       |
| **NUMA Nodes**           | 2 (Node0: CPUs 0-63, Node1: CPUs 64-128)      | 2 (Node0: CPUs 0-63, Node1: CPUs 64-128)      |
| **L1d Cache**            | 2 MiB (64 instances)                          | 3 MiB (64 instances)                          |
| **L1i Cache**            | 2 MiB (64 instances)                          | 2 MiB (64 instances)                          |
| **L2 Cache**             | 64 MiB (64 instances)                         | 64 MiB (64 instances)                         |
| **L3 Cache**             | 256 MiB (8 instances)                         | 256 MiB (8 instances)                         |
| **BIOS Vendor**          | American Megatrends Inc. (AMI)                | American Megatrends Inc. (AMI)                |
| **BIOS Release Date**    | 10/07/2024                                    | 03/31/2025                                    |
| **BIOS Version**         | 3.0                                           | 3.5                                           |
| **BIOS Firmware Rev**    | 5.27                                          | 5.35                                          |
| **ROM Size**             | 32MB                                          | 32MB                                          |
| **Boot Mode**            | UEFI, ACPI supported                          | UEFI, ACPI supported                          |
| **Disks**                | 1 × NVMe (SAMSUNG MZQL215THBLA-00A07, 15TB)   | 1 × NVMe (KIOXIA KCD6XLUL15T3, 15TB)          |
| **Partitions**           | /boot/efi (1G), /boot (2G), LVM root (14T)    | /boot/efi (1G), /boot (2G), LVM root (14T)    |
| **Network**              | 1 × Intel X710 10G GbE                        | 1 × Intel X710 10G GbE                        |
| **RAM**                  | 1152 GB (24x48GB DDR5-4800)                   | 1536 GB (24x64GB DDR5-6400)                   |


## Benchmarks

The certification includes two LLM architectures — Qwen and Llama — each tested in two different parameter sizes.

Qwen Models:
- `Qwen/Qwen2.5-3B-Instruct`
- `Qwen/Qwen2.5-14B-Instruct`

Llama Models:
- `meta-llama/Llama-3.2-3B-Instruct`
- `meta-llama/Llama-3.2-7B-Instruct`

The benchmark process is based on [GuideLLM](https://github.com/vllm-project/guidellm), the native benchmarking tool provided by vLLM for optimizing and testing deployed models.

### Executing the Benchmarks

#### Step 1: Deploying the vLLM Appliance

The vLLM appliance is available through the OpenNebula Marketplace, offering a [streamlined setup process](https://github.com/OpenNebula/one-apps/wiki/vllm_quick) suitable for both novice and experienced users.

For deploying the vLLM appliance for benchmarking you should follow those steps:

1. Download the vLLM appliance from the marketplace
    ``` shell
    $ onemarketapp export 'service_Vllm' vllm --datastore default
    ```

2. Configure the template for configuring the [GPU PCI passthrough](../../../product/cluster_configuration/hosts_and_clusters/nvidia_gpu_passthrough.md).
    ```shell
    $ onetemplate update vllm
    ```

    In our case, we configured the template with the following parameters for doing the GPU Passthrough to the VM and configured the specific CPU-Pinning topology:
    ```shell
    CPU_MODEL=[
        MODEL="host-passthrough" ]
    OS=[
        FIRMWARE="/usr/share/OVMF/OVMF_CODE_4M.fd",
        MACHINE="pc-q35-noble" ]
    PCI=[
        CLASS="0302",
        DEVICE="26b9",
        VENDOR="10de" ]
    TOPOLOGY=[
        CORES="8",
        PIN_POLICY="THREAD",
        SOCKETS="2",
        THREADS="2" ]
    VCPU="32"
    CPU="32"
    MEMORY="32768"
    ```

3. Instantiate the template. In our case, we kept the default attributes, only changing the LLM Model through the `ONEAPP_VLLM_MODEL_ID` input for each benchmark we did, which means that you will need to instantiate a different VM with the different models for running each benchmark:
    ```shell
    $ onetemplate instantiate service_Vllm --name vllm
    ```

4. Wait until the vLLM engine has loaded the model and the application is served. You can do it by logging to the VM via SSH and checking the logs located in `/var/log/one-appliance/vllm.log`. You should see an output similar to this:
    ```shell
    [...]

    (APIServer pid=2480) INFO 11-26 11:00:33 [api_server.py:1971] Starting vLLM API server 0 on http://0.0.0.0:8000
    (APIServer pid=2480) INFO 11-26 11:00:33 [launcher.py:36] Available routes are:
    (APIServer pid=2480) INFO 11-26 11:00:33 [launcher.py:44] Route: /openapi.json, Methods: HEAD, GET
    (APIServer pid=2480) INFO 11-26 11:00:33 [launcher.py:44] Route: /docs, Methods: HEAD, GET
    (APIServer pid=2480) INFO 11-26 11:00:33 [launcher.py:44] Route: /docs/oauth2-redirect, Methods: HEAD, GET
    (APIServer pid=2480) INFO 11-26 11:00:33 [launcher.py:44] Route: /redoc, Methods: HEAD, GET
    (APIServer pid=2480) INFO 11-26 11:00:33 [launcher.py:44] Route: /health, Methods: GET
    (APIServer pid=2480) INFO 11-26 11:00:33 [launcher.py:44] Route: /load, Methods: GET
    (APIServer pid=2480) INFO 11-26 11:00:33 [launcher.py:44] Route: /ping, Methods: POST
    (APIServer pid=2480) INFO 11-26 11:00:33 [launcher.py:44] Route: /ping, Methods: GET
    (APIServer pid=2480) INFO 11-26 11:00:33 [launcher.py:44] Route: /tokenize, Methods: POST
    (APIServer pid=2480) INFO 11-26 11:00:33 [launcher.py:44] Route: /detokenize, Methods: POST
    (APIServer pid=2480) INFO 11-26 11:00:33 [launcher.py:44] Route: /v1/models, Methods: GET

    [...]

    ```

    At this point, the vLLM API should be available. You can test it through curl, pointing to the port 8000 of the VM and querying the `v1/models` path:
    ```shell
    $ curl http://localhost:8000/v1/models | jq .
    ```

    You should receive a json response with the loaded models:
    ```json
    {
        "object": "list",
        "data": [
            {
            "id": "Qwen/Qwen2.5-1.5B-Instruct",
            "object": "model",
            "created": 1764154926,
            "owned_by": "vllm",
            "root": "Qwen/Qwen2.5-1.5B-Instruct",
            "parent": null,
            "max_model_len": 1024,
            "permission": [
                {
                "id": "modelperm-431ea3199da545b2a5cba62dc373ab53",
                "object": "model_permission",
                "created": 1764154926,
                "allow_create_engine": false,
                "allow_sampling": true,
                "allow_logprobs": true,
                "allow_search_indices": false,
                "allow_view": true,
                "allow_fine_tuning": false,
                "organization": "*",
                "group": null,
                "is_blocking": false
                }
            ]
            }
        ]
    }
    ```

    Also, the appliance includes a webchat app for interacting with the vLLM chat API. This web application is exposed through the VM `5000` port:

    ![vLLM webchat](/images/solutions/deployment_blueprints/llm_inference_certification/vllm_web.svg)

    If those verifications are successful, the vLLM appliance is ready to run the benchmarks.

#### Step 2: Running the benchmark scripts

There is a `benchmark.sh` file inside the `/root` directory of the vLLM appliance that executes GuideLLM CLI. This [script](https://github.com/OpenNebula/one-apps/blob/ec3f5b740dc2a4201f8ed971f93beb195202bfef/appliances/Vllm/scripts/benchmark.sh) automatically detects environment parameters, launches the benchmark using GuideLLM, and displays live updates of progress and results through the CLI. Specifically, the benchmark script follows this procedure:

- To test performance and stability, the script sends hundreds of requests in parallel.
- The script uses synthetic data generated automatically to run this benchmark, with these values:
    - Input prompt: average 511 tokens.
    - Output prompt: average 255 tokens.
    - Total samples: 999.
- GuideLLM identifies the throughput that the inference can handle.
- Once the throughput is identified, 9 additional runs are performed at a fixed requests-per-second rate (below the identified throughput) to determine stability and final results.

In order to run the benchmark you need to follow those steps:

1. Connect to the vLLM appliance through ssh:
    ```shell
    $ onevm ssh vllm
    ```

2. Run the benchmark script:
    ```shell
    root@vllm$ ./benchmark
    ```

    The benchmark will start running and you will see this output:
    ![vLLM benchmark](/images/solutions/deployment_blueprints/llm_inference_certification/benchmark.svg)

    There are more parameters available within the benchmarking such as warmups, number of steps, and seconds per step. These parameters are fixed but can be manually adapted if needed.

3. Once finished, the process outputs the results on the terminal and generates an HTML report with all given information in the `/root/benchmark_results` directory:

    ![vLLM benchmark results](/images/solutions/deployment_blueprints/llm_inference_certification/benchmark_results.svg)


### Benchmark results

The following key performance metrics have been be tested for each model:

| Metric                            | Description                                                                              | Unit   |
|-----------------------------------|----------------------------------------------------------------------------------------  |--------|
| Request rate (throughput)         | Number of requests processed per second.                                                 | req/s  |
| Time to first token (TTFT)        | Time elapsed before the first token is generated.                                        | ms     |
| Inter-token latency (ITL or TPOT) | Average time between consecutive tokens during generation.                               | ms     |
| Latency                           | Time to process individual requests. Low latency is essential for interactive use cases. | ms     |
| Throughput                        | Number of requests handled per second. High throughput indicates good scalability.       | req/s  |

Different application types have distinct performance requirements. The following GuideLLM reference SLOs provide general benchmarks for evaluating inference quality (times for 99% of requests):

| Use Case                           | Req. Latency (ms) | TTFT (ms)  | ITL (ms) |
|------------------------------------|-------------------|------------|----------|
| **Chat Applications**              | -                 | ≤ 200      | ≤ 50     |
| **Retrieval-Augmented Generation** | -                 | ≤ 300      | ≤ 100    |
| **Agentic AI**                     | ≤ 5000            | -          | -        |
| **Content Generation**             | -                 | ≤ 600      | ≤ 200    |
| **Code Generation**                | -                 | ≤ 500      | ≤ 150    |
| **Code Completion**                | ≤ 2000            | -          | -        |

The following table contains the results of the benchmark for each model:

| Models                            | vCPUS | RAM    | GPU   | Throughput (req/s) | TTFT (ms) | ITL (ms) | TPOT (ms) | p99 TTFT (ms) | p99 ITL (ms) | p99 TPOT (ms) |
|-----------------------------------|--------|--------|-------|--------------------|------------|-----------|------------|----------------|---------------|----------------|
| Qwen/Qwen2.5-3B-Instruct          | 32     | 32 GB  | L40s  | 6.4                | 61.8       | 15.2      | 15.2       | 170            | 15.4          | 15.3           |
| Qwen/Qwen2.5-3B-Instruct          | 32     | 32 GB  | H100L | 34                 | 34         | 8.3       | 8.3        | 115            | 8.2           | 8.2            |
| Qwen/Qwen2.5-14B-Instruct         | 32     | 32 GB  | L40s  | -                  | -          | -         | -          | -              | -             | -              |
| Qwen/Qwen2.5-14B-Instruct         | 32     | 32 GB  | H100L | 20                 | 7000       | 0         | 0          | 7000           | 0             | 0              |
| meta-llama/Llama-3.1-3B-Instruct  | 32     | 32 GB  | L40s  | 3.3                | 59.7       | 13        | 12.9       | 87             | 13.1          | 13.1           |
| meta-llama/Llama-3.1-3B-Instruct  | 32     | 32 GB  | H100L | 30                 | 56         | 12        | 11.9       | 331            | 12.4          | 12.3           |


OpenNebula includes the obtained results in controlled environments, with given hardware and using specific models. This information can later be used to compare future results, assess deployments, and evaluate performance against known baselines.

{{< alert title="Tip" color="success" >}}
Alternatively, after validating your AI Factory with LLM Inference, you may choose to follow [Validation with AI-Ready Kubernetes]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/ai_ready_k8s" %}}).
{{< /alert >}}