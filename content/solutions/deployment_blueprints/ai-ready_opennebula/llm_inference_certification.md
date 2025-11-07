---
title: "LLM Inference for Model Certification"
linkTitle: "LLM Inference Certification"
date: "2025-10-28"
description:
categories:
pageintoc: "68"
tags:
weight: 4
---

{{< alert title="Important" color="success" >}}
As a prerequisite to perform LLM Inference for Model Certification, you must follow the procedure outlined in [Configuration and Deployment]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/configuration_and_deployment" %}}).
{{< /alert >}} 

With the rapid and widespread adoption of Large Language Models (LLMs), optimizing and validating their inference performance has become critical. Efficient inference ensures that deployed models deliver high-quality results while maintaining scalability, responsiveness, and cost efficiency.

Before deploying any LLM in production, it must be properly tested, benchmarked, and certified. There is a clear distinction between an LLM benchmark and an LLM inference benchmark:

- LLM Benchmarks: evaluate the quality of a model’s outputs — such as accuracy, reasoning, and linguistic quality — using standardized test suites. Examples: GLUE, MMLU, and SWE-bench.
- LLM Inference Benchmarks: measure performance metrics such as latency, throughput, and stability during inference. These tests assess the efficiency of model serving rather than the quality of the generated text.

This document defines the scope, methodology, and evaluation criteria for the LLM inference benchmarking process conducted by OpenNebula. The goal is to test and certify LLM deployments within OpenNebula appliances under controlled hardware and software environments.

The LLM inference benchmarking process includes the following tasks:

1. Deployment of a specific LLM using the provided appliance.  
2. Execution of performance tests using a standard benchmarking script.  
3. Comparison of collected metrics against a certified reference database built from previous benchmark runs.  


## Scope of the Testing

The objective of this benchmarking task is to evaluate LLM inference performance within a controlled OpenNebula environment, using the vLLM inference framework on a single node equipped with one or more GPUs.


## Inference Framework

Although multiple inference frameworks are available, this benchmark focuses exclusively on vLLM, a production-grade, high-performance inference engine designed for large-scale LLM serving.

The vLLM appliance will be available through the OpenNebula Marketplace for enterprise subscriptions, offering a streamlined setup process suitable for both novice and experienced users.

**Main characteristics:**

- Supports single-node deployments with one or more GPUs.  
- Uses Python’s native multiprocessing for multi-GPU inference.  
- Does not require additional frameworks, such as Ray, unless deploying across multiple nodes, which is out of scope for this benchmarking task.  



## Testing Environments

To test the vLLM appliance, the benchmark uses two distinct environments, each with specific hardware configurations:

### **Environment 1 — vgpu1**
- Two nodes running OpenNebula v7+
- Each node equipped with two NVIDIA L40S GPUs

### **Environment 2 — vgpu4**
- One node running OpenNebula v7+
- Equipped with one NVIDIA H100L GPU


## Models to Test

The certification includes two LLM architectures — Qwen and Llama — each tested in two different parameter sizes.

### Qwen Models
- `Qwen/Qwen2.5-3B-Instruct`
- `Qwen/Qwen2.5-14B-Instruct`

### Llama Models
- `meta-llama/Llama-3.2-3B-Instruct`
- `meta-llama/Llama-3.2-7B-Instruct`

Additional models will be included in future releases to expand the certification database with more benchmark results and metrics.


## Methodology

The benchmark process is based on GuideLLM, the native benchmarking tool provided by vLLM for optimizing and testing deployed models.  
GuideLLM supports OpenAPI-compatible testing of any deployed endpoint.

There are two general testing modes:

- Containerized mode: runs the benchmark inside an image or container, specifying the model and deployment details.  
- Endpoint mode: uses an API endpoint (URL) and model name to send benchmark requests directly.

For the purposes of this benchmarking, OpenNebula chooses endpoint mode for simplicity and efficiency, avoiding unnecessary container orchestration overhead.

After the deployment of the LLM is deployed, the next step is to execute the `benchmark.sh` script located in the appliance’s root directory. This script automatically detects environment parameters, launches the benchmark using GuideLLM, and displays live updates of progress and results through the CLI; similar to the example below:

![GuideLLM with progress updates through the CLI](https://raw.githubusercontent.com/vllm-project/guidellm/main/docs/assets/sample-benchmarks.gif)

GuideLLM CLI updates the results and the steps along the benchmarking process, based on this procedure:

- To test performance and stability, the script sends hundreds of requests in parallel.  
- OpenNebula uses synthetic data generated automatically to run this benchmark, with these values:
    - Input prompt: average 512 tokens.
    - Output prompt: average 256 tokens.
    - Total samples: 1000.

- GuideLLM identifies the throughput that the inference can handle.  
- Once the throughput is identified, 10 additional runs are performed at a fixed requests-per-second rate (below the identified throughput) to determine stability and final results.

As a result, the process generates an HTML report with all given information and produces an output with metrics. There are more parameters available within the benchmarking such as warmups*, number of steps, and seconds per step. These parameters are fixed but can be manually adapted if needed.


## Metrics

Each tested model produces the following key performance metrics:

- Request rate (throughput): number of requests processed per second (req/s).  
- Time to first token (TTFT): time elapsed before the first token is generated (ms).  
- Inter-token latency (ITL): average time between consecutive tokens during generation (ms).  
- Latency: time to process individual requests. Low latency is essential for interactive use cases.  
- Throughput: number of requests handled per second. High throughput indicates good scalability.  
- Cost Efficiency: cost per request, determined by GPU utilization and throughput. Optimization often requires balancing cost and latency.  


## Service Level Objectives (SLOs)

Different application types have distinct performance requirements. The following GuideLLM reference SLOs provide general benchmarks for evaluating inference quality (times for 99% of requests):

| Use Case | Req. Latency (ms) | TTFT (ms) | ITL (ms) |
|-----------|------------------|------------|-----------|
| **Chat Applications** | - | ≤ 200 | ≤ 50 |
| **Retrieval-Augmented Generation** | - | ≤ 300 | ≤ 100 |
| **Agentic AI** | ≤ 5000 | - | - |
| **Content Generation** | - | ≤ 600 | ≤ 200 |
| **Code Generation** | - | ≤ 500 | ≤ 150 |
| **Code Completion** | ≤ 2000 | - | - |


## Results

All results are saved in this table: 

| Models                            | vCPUS | RAM    | GPU   | Throughput (req/s) | TTFT (ms) | ITL (ms) | TPOT (ms) | p99 TTFT (ms) | p99 ITL (ms) | p99 TPOT (ms) |
|-----------------------------------|--------|--------|-------|--------------------|------------|-----------|------------|----------------|---------------|----------------|
| Qwen/Qwen2.5-3B-Instruct          | 32     | 32 GB  | L40s  | 6.4                | 61.8       | 15.2      | 15.2       | 170            | 15.4          | 15.3           |
| Qwen/Qwen2.5-3B-Instruct          | 32     | 32 GB  | H100L | 34                 | 34         | 8.3       | 8.3        | 115            | 8.2           | 8.2            |
| Qwen/Qwen2.5-14B-Instruct         | 32     | 32 GB  | L40s  | -                  | -          | -         | -          | -              | -             | -              |
| Qwen/Qwen2.5-14B-Instruct         | 32     | 32 GB  | H100L | 20                 | 7000       | 0         | 0          | 7000           | 0             | 0              |
| meta-llama/Llama-3.1-3B-Instruct  | 32     | 32 GB  | L40s  | 3.3                | 59.7       | 13        | 12.9       | 87             | 13.1          | 13.1           |
| meta-llama/Llama-3.1-3B-Instruct  | 32     | 32 GB  | H100L | 30                 | 56         | 12        | 11.9       | 331            | 12.4          | 12.3           |


OpenNebula includes the obtained results in controlled environments, with given hardware and using specific models. This information can later be used to compare future results, assess deployments, and evaluate performance against known baselines.
