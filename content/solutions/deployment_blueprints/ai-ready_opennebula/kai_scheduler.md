---
title: KAI Scheduler
linkTitle: KAI Scheduler
weight: 6
---

{{< alert title="Important" color="success" >}}
To perform the validation with NVIDIA KAI Scheduler, you must follow the procedure outlined in [Validation with AI-Ready Kubernetes]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/ai_ready_k8s" %}}) for creating an AI-Ready Kubernetes ready for running GPU workloads.
{{< /alert >}}

[NVIDIA&reg; KAI Scheduler](https://github.com/NVIDIA/KAI-Scheduler) is an open source Kubernetes-native scheduler designed to optimize GPU resource allocation for AI and machine learning workloads at scale. It is capable of managing large GPU clusters and handling high-throughput demanding workload environments. KAI Scheduler targets both interactive jobs and large-scale training or inference tasks within the same cluster, always ensuring optimal resource allocation and fairness across different users and teams. It also operates alongside other schedulers installed in a cluster.

Some of the key features are:
- Share single or multiple GPU resources among multiple workloads for improving resource allocation.
- Batch scheduling of different types of workloads, including gang scheduling (i.e. all pods are scheduled together or none are scheduled until all resources are available).
- Effective workload priority with hierarchical queues.
- Resource distribution with custom quotas, limits, priorities and fairness policies.
- Elastic workloads with dynamic workload scalation.
- Compatibility with other autoscalers like Karpenter.

In this guide you will learn how to install the NVIDIA KAI Scheduler in a AI-Ready Kubernetes cluster and how you can efficiently share its GPU resources among different workloads.


### NVIDIA KAI Scheduler Installation

For installing the NVIDIA KAI Scheduler you need to accomplish the following prerequisites:
- An AI-Ready Kubernetes Cluster with the NVIDIA GPU Operator installed (as described [in this guide]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/ai_ready_k8s" %}})).
- Helm tool (check the installation instructions in the [official documentation](https://helm.sh/docs/intro/install/)).

1. First you need to create a dedicated namespace for the KAI Scheduler components in the Kubernetes cluster:
    ```shell
    kubectl create namespace kai-scheduler
    ```
2. Then you should install the KAI Scheduler through Helm. For doing that, check the available release versions in the [KAI Scheduler repository](https://github.com/NVIDIA/KAI-Scheduler/releases) and install it via Helm using the latest version. In case you want to use GPU resource sharing feature, set the `"global.gpuSharing=true"` flag:
    ```shell
    helm install kai-scheduler \
        https://github.com/NVIDIA/KAI-Scheduler/releases/download/v0.9.8/kai-scheduler-v0.9.8.tgz \
        -n kai-scheduler --create-namespace \
        --set "global.gpuSharing=true" \
        --set "global.resourceReservation.runtimeClassName=nvidia"
    ```

3. Check that the Helm chart has successfully installed and all the KAI Scheduler components are running:
    ```shell
    ❯ kubectl get pods -n kai-scheduler
    NAME                                   READY   STATUS    RESTARTS   AGE
    admission-55f6c958b6-sx8q6             1/1     Running   0          31s
    binder-66757b79cf-hnckr                1/1     Running   0          33s
    kai-operator-86579f5b96-nc8tl          1/1     Running   0          33s
    pod-grouper-845d589495-qxmlk           1/1     Running   0          31s
    podgroup-controller-75c6986688-7cfhs   1/1     Running   0          31s
    queue-controller-5bf44f6c4d-gwptq      1/1     Running   0          31s
    scheduler-685b9d6846-69vr4             1/1     Running   0          33s
    ```

4. For managing workloads using KAI we need to create the corresponding queues, which are the essential scheduling primitives which reflects different scheduling guarantees, like resource quota and priority. They could be assigned to different types of consumers in the cluster, e.g. users, groups, etc. A workload must belong to a queue in order to be scheduled.

    Let's create two basic scheduling queue hierarchies:
    - A `default` top level queue.
    - A `test` leaf queue that you can use for your workloads.

    ```yaml
    cat <<EOF | kubectl apply -f -
    apiVersion: scheduling.run.ai/v2
    kind: Queue
    metadata:
    name: default
    spec:
    resources:
        cpu:
        quota: -1
        limit: -1
        overQuotaWeight: 1
        gpu:
        quota: -1
        limit: -1
        overQuotaWeight: 1
        memory:
        quota: -1
        limit: -1
        overQuotaWeight: 1
    ---
    apiVersion: scheduling.run.ai/v2
    kind: Queue
    metadata:
    name: test
    spec:
    parentQueue: default
    resources:
        cpu:
        quota: -1
        limit: -1
        overQuotaWeight: 1
        gpu:
        quota: -1
        limit: -1
        overQuotaWeight: 1
        memory:
        quota: -1
        limit: -1
        overQuotaWeight: 1
    EOF
    ```

For scheduling your workloads using those queues you need to:
- Specify the queue name using the `kai.scheduler/queue: test` label.
- Specify the kai workload scheduler using the `spec.schedulerName: kai-scheduler` attribute.

Example (from the [KAI quickstart documentation](https://github.com/NVIDIA/KAI-Scheduler/blob/6ffb4252969df19491ce0902d79c0153cae944b3/docs/quickstart/pods/gpu-pod.yaml)):
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: gpu-pod
  labels:
    kai.scheduler/queue: test
spec:
  schedulerName: kai-scheduler
  containers:
    - name: main
      image: ubuntu
      command: ["bash", "-c"]
      args: ["nvidia-smi; trap 'exit 0' TERM; sleep infinity & wait"]
      resources:
        limits:
          nvidia.com/gpu: "1"
```

At this point, the KAI Scheduler is installed and ready to schedule your AI workloads.

### GPU Sharing with KAI Scheduler

One of the features of the KAI Scheduler is the GPU resource sharing, which allows multiple pods or workloads share the same GPU device efficiently, even if they reside in different namespaces.

You can request a portion of the GPU by:
- Requesting a specific GPU amount (e.g. `3Gib`).
- Requesting a portion of a GPU device memory (e.g. `0.5`).

You have to take into account that the KAI Scheduler does not enforce memory allocation limits or performs memory isolation between processes, so it's important that the running processes allocates the GPU memory up to the requested amount (e.g. vLLM workloads by defaults consume the 90% of the GPU memory, so we will need to limit this consumption using the `--gpu-memory-utilization` parameter with the corresponding memory fracton, e.g. `--gpu-memory-utilization=0.5`).

For testing the GPU sharing feature of KAI Scheduler you can follow those steps:

1. Create a namespace for the scheduled workloads:
    ```shell
    kubectl create ns ai-workloads
    ```

2. Deploy a sample workload that uses vLLM for inference serving
    ```yaml
    cat <<EOF | kubectl apply -f -
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: vllm-test-07
      namespace: ai-workloads
      labels:
        app: vllm-test-07
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: vllm-test-07
      template:
        metadata:
          labels:
            app: vllm-test-07
            kai.scheduler/queue: test
          annotations:
            gpu-fraction: "0.7"
        spec:
          schedulerName: kai-scheduler
          containers:
          - name: vllm
            image: vllm/vllm-openai:latest
            command: ["/bin/sh", "-c"]
            args: [
    	      "vllm serve Qwen/Qwen2.5-1.5B-Instruct --gpu-memory-utilization=0.7"
            ]
            ports:
            - containerPort: 8000
            resources:
              limits:
                cpu: "8"
                memory: 15G
              requests:
                cpu: "6"
                memory: 6G
            livenessProbe:
              httpGet:
                path: /health
                port: 8000
              initialDelaySeconds: 60
              periodSeconds: 10
            readinessProbe:
              httpGet:
                path: /health
                port: 8000
              initialDelaySeconds: 60
              periodSeconds: 5
    EOF
    ```

3. Verify that the deployment is allocated with the specified resources:
    ```shell
    ❯ kubectl -n ai-workloads get pods -o custom-columns="NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName,GPU-FRACTION:.metadata.annotations.gpu-fraction,GPU-GROUP:.metadata.labels.runai-gpu-group"
    NAME                            STATUS    NODE                       GPU-FRACTION   GPU-GROUP
    vllm-test-07-5979b99584-llf45   Running   k8s-gpu-md-0-wr9k6-gbtvr   0.7            407623a2-216d-4c06-b5b8-f8345bf28b5a
    ```

4. Deploy a Kubernetes service for accessing the API:
    ```yaml
    cat <<EOF | kubectl apply -f -
    apiVersion: v1
    kind: Service
    metadata:
      name: vllm-test-07
      namespace: ai-workloads
    spec:
      ports:
      - name: http
        port: 80
        protocol: TCP
        targetPort: 8000
    selector:
        app: vllm-test-07
    sessionAffinity: None
    type: ClusterIP
    EOF
    ```

    Check the service:
    ```shell
    ❯ kubectl -n ai-workloads get svc
    NAME           TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
    vllm-test-07   ClusterIP   10.43.119.6   <none>        80/TCP    39s
    ```

5. Port forward the service through kubectl:
    ```shell
    kubectl -n ai-workloads port-forward svc/vllm-test-07 9000:80 &
    ```

5. Test the deployment doing a request to the vLLM service API:
    ```shell
    curl http://localhost:9000/v1/completions \
    -H "Content-Type: application/json" \
    -d '{
            "model": "Qwen/Qwen2.5-1.5B-Instruct",
            "prompt": "San Francisco is a",
            "max_tokens": 7,
            "temperature": 0
        }' | jq .
    ```

    You should receive a response like this one:
    ```json
    {
        "id": "cmpl-173532a758894deeae63d0a073c53289",
        "object": "text_completion",
        "created": 1763393534,
        "model": "Qwen/Qwen2.5-1.5B-Instruct",
        "choices": [
            {
            "index": 0,
            "text": " city in the state of California,",
            "logprobs": null,
            "finish_reason": "length",
            "stop_reason": null,
            "token_ids": null,
            "prompt_logprobs": null,
            "prompt_token_ids": null
            }
        ],
        "service_tier": null,
        "system_fingerprint": null,
        "usage": {
            "prompt_tokens": 4,
            "total_tokens": 11,
            "completion_tokens": 7,
            "prompt_tokens_details": null
        },
        "kv_transfer_params": null
    }
    ```

You can also deploy another workload with a small GPU fraction on that node:

1. Create another workload with a GPU memory fraction of `0.2`:
    ```yaml
    cat <<EOF | kubectl apply -f -
    apiVersion: apps/v1
    kind: Deployment
    metadata:
    name: vllm-test-02
    namespace: ai-workloads
    labels:
        app: vllm-test-02
    spec:
    replicas: 1
    selector:
        matchLabels:
        app: vllm-test-02
    template:
        metadata:
        labels:
            app: vllm-test-02
            kai.scheduler/queue: test
        annotations:
            gpu-fraction: "0.2"
        spec:
        schedulerName: kai-scheduler
        containers:
        - name: vllm
            image: vllm/vllm-openai:latest
            command: ["/bin/sh", "-c"]
            args: [
            "vllm serve Qwen/Qwen2.5-1.5B-Instruct --gpu-memory-utilization=0.2"
            ]
            ports:
            - containerPort: 8000
            resources:
            limits:
                cpu: "8"
                memory: 15G
            requests:
                cpu: "6"
                memory: 6G
            livenessProbe:
            httpGet:
                path: /health
                port: 8000
            initialDelaySeconds: 60
            periodSeconds: 10
            readinessProbe:
            httpGet:
                path: /health
                port: 8000
            initialDelaySeconds: 60
            periodSeconds: 5
    EOF
    ```

2. Check that the fraction is successfully assigned and the pod is running:
    ```shell
    ❯ kubectl -n ai-workloads get pods -o custom-columns="NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName,GPU-FRACTION:.metadata.annotations.gpu-fraction,GPU-GROUP:.metadata.labels.runai-gpu-group"
    NAME                            STATUS    NODE                       GPU-FRACTION   GPU-GROUP
    vllm-test-02-79b48968bc-dtzxs   Running   k8s-gpu-md-0-wr9k6-gbtvr   0.2            407623a2-216d-4c06-b5b8-f8345bf28b5a
    vllm-test-07-5979b99584-llf45   Running   k8s-gpu-md-0-wr9k6-gbtvr   0.7            407623a2-216d-4c06-b5b8-f8345bf28b5a
    ```

With this validation we have checked how we can efficiently share fractional GPU resources between workloads in an AI-Ready Kubernetes with KAI Scheduler.

{{< alert title="Tip" color="success" >}}
Alternatively, after validating your AI Factory with NVIDIA KAI Scheduler on Kubernetes, you may choose to follow [Validation with LLM Inferencing]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/llm_inference_certification" %}}) or [Validation with NVIDIA Dynamo]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/nvidia_dynamo" %}}).
{{< /alert >}}