---
title: NVIDIA Dynamo on Kubernetes
linkTitle: NVIDIA Dynamo
weight: 5
---

<a id="nvidia_dynamo_on_k8s"></a>

{{< alert title="Important" color="success" >}}
To perform the validation with NVIDIA Dynamo Cloud Platform, you must follow the procedure outlined in [Validation with AI-Ready Kubernetes]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/ai_ready_k8s" %}}) for creating an AI-Ready Kubernetes ready for running GPU workloads.
{{< /alert >}}

[NVIDIA&reg; Dynamo](https://docs.nvidia.com/dynamo/latest/index.html) is a high-performant inference framework for serving AI models in an agnostic way, such as across any framework, architecture or deployment scale, as well as in multi-node distributed environments. Being an agnostic inference engine, it supports different backends like TRT-LLM, vLLM, SGLang, etc. Dynamo also allows you to declare inference graphs which deploy different containerized components in a disaggregated way- like an API frontend, a prefill worker, a decode worker, a K/V cache, and others - and to let them interact to efficiently respond to the user queries.

Encapsulating the different inference engines, AI models and dependencies into a single container improves the workload portability and isolation. With this approach, each container is deployed consistently across different environments, including all its dependencies, avoiding conflicts and reproducibility issues.

In this guide you will learn how to combine the GPU powered Kubernetes Cluster with the NVIDIA Dynamo Cloud Platform for provisioning a secure, robust and scalable solution for our AI workloads on top of the NVIDIA Dynamo framework powered by the OpenNebula cloud platform.

### NVIDIA Dynamo Cloud Platform Installation

As a prerequisite, you need a storage provider installed to supply PersistentVolumes to the platform. For testing purposes, use the [rancher local-path-provisioner](https://github.com/rancher/local-path-provisioner) that references to a local path from the pod host as storage, and creates a Default storage class using it:

1. To install the provisioner, deploy the manifest from the GitHub repository:

```shell
laptop$ kubectl apply -f \
https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.32/deploy/local-path-storage.yaml
```

2. Check that the storage provisioner is up and running:

```shell
laptop$ kubectl -n local-path-storage get deploy,pods
>>>
NAME                                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/local-path-provisioner   1/1     1            1           7d2h

NAME                                          READY   STATUS    RESTARTS   AGE
pod/local-path-provisioner-7f57b55d56-7qb42   1/1     Running   0          7d2h
```

3. Create the following storageClass and set it as default.

If you want to modify the `nodePath` parameter, ensure that it is available in the `nodePathMap` field of the provider config as indicated in the [Customize the configmap](https://github.com/rancher/local-path-provisioner?tab=readme-ov-file#customize-the-configmap) guide.

```shell
laptop$ cat <<EOF > storageClass.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-path
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: rancher.io/local-path
parameters:
  nodePath: /opt/local-path-provisioner
  pathPattern: "{{ .PVC.Namespace }}/{{ .PVC.Name }}"
volumeBindingMode: WaitForFirstConsumer
reclaimPolicy: Delete
EOF

laptop$ kubectl apply -f storageClass.yaml
```

4. Check that this storage class is the default:

```shell
laptop$ kubectl get storageClass

---
NAME                   PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION
local-path (default)   rancher.io/local-path   Delete          WaitForFirstConsumer   false
```

At this point, the Dynamo Cloud platform is ready for installation. Configure your cluster in a declarative way, by using the containers and helm charts in the [NVIDIA NGC catalog](https://catalog.ngc.nvidia.com/orgs/nvidia/teams/ai-dynamo/collections/ai-dynamo), and follow these steps:

1. Install the CRDs:

```shell
laptop$ helm install dynamo-crds \
https://helm.ngc.nvidia.com/nvidia/ai-dynamo/charts/dynamo-crds-0.4.1.tgz \
  --namespace dynamo-cloud --create-namespace \
  --wait --atomic
```

2. Install the operator, using the latest version available in the catalog.:

```shell
laptop$ helm install dynamo-platform https://helm.ngc.nvidia.com/nvidia/ai-dynamo/charts/dynamo-platform-0.4.1.tgz \
  --namespace dynamo-cloud \
  --create-namespace \
  --set "dynamo-operator.controllerManager.manager.image.repository=nvcr.io/nvidia/ai-dynamo/kubernetes-operator" \
  --set "dynamo-operator.controllerManager.manager.image.tag=0.4.1"
```

3. Check if the operator is up and running:

```shell
laptop$ kubectl -n dynamo-cloud get deploy,pod,svc
<<<
NAME                                                                 READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/dynamo-platform-dynamo-operator-controller-manager   1/1     1            1           27h
deployment.apps/dynamo-platform-nats-box                             1/1     1            1           27h

NAME                                                                  READY   STATUS      RESTARTS   AGE
pod/dynamo-platform-dynamo-operator-controller-manager-75fd6b7cdvlt   2/2     Running     0          26h
pod/dynamo-platform-etcd-0                                            1/1     Running     0          27h
pod/dynamo-platform-etcd-pre-upgrade-g5cjm                            0/1     Completed   0          27h
pod/dynamo-platform-nats-0                                            2/2     Running     0          27h
pod/dynamo-platform-nats-box-57c9cf4c7b-vbgpg                         1/1     Running     0          27h

NAME                                    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
service/dynamo-platform-etcd            ClusterIP   10.43.157.193   <none>        2379/TCP,2380/TCP   27h
service/dynamo-platform-etcd-headless   ClusterIP   None            <none>        2379/TCP,2380/TCP   27h
service/dynamo-platform-nats            ClusterIP   10.43.175.109   <none>        4222/TCP            27h
service/dynamo-platform-nats-headless   ClusterIP   None            <none>        4222/TCP,8222/TCP   27h
```

4. To use some LLM models in the platform, you need a HuggingFace token for authenticating against the API. For this purpose, create a secret for that token that could be later referenced by Dynamo:

```shell
laptop$ cat<<EOF > hf-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: hf-token-secret
  namespace: dynamo-cloud
type: Opaque
stringData:
  token: "<token>"
EOF

laptop$ kubectl apply -f hf-secret.yaml
```

## Deployment of Dynamo Inference Graphs

NVIDIA Dynamo orchestrates the deployment of inference graphs [through the Dynamo CLI](https://docs.nvidia.com/dynamo/latest/guides/dynamo_deploy/README.html) or by deploying manifests following the specific [Dynamo CRDs](https://docs.nvidia.com/dynamo/latest/guides/dynamo_deploy/dynamo_operator.html) directly in the cluster, which are recognized and managed by the Dynamo Kubernetes Operator.

The instructions of this guide do not expose the Dynamo API externally. You benefit from the Dynamo Kubernetes Operator by deploying the manifests of the inference graphs directly on the cluster.

To access the Kubernetes cluster where Dynamo is deployed:

- Ensure that you have an updated HuggingFace token set as Kubernetes secret with the `hf-token-secret` name and add the `runtimeClassName: nvidia` in the `spec.VllmDecodeWorker.extraPodSpec` field to assign a GPU to the worker pod.
- Follow the instructions in [Accessing vGpu servers](https://docs.google.com/document/d/1nrXfr8zV7bD_6fkyU8fE5lj6mS1qqin0YRVGy6yjSZs/edit?tab=t.0#heading=h.d6bnzujacz4u) and [Connecting to workload Kubernetes API locally](https://docs.google.com/document/d/1nrXfr8zV7bD_6fkyU8fE5lj6mS1qqin0YRVGy6yjSZs/edit?tab=t.0#heading=h.avcvbins67bl).

Once you access the Kubernetes API, proceed to deploy the inference graphs you defined in the corresponding manifest.

The latest vllm-runtime image is located in [`nvcr.io/nvidia/ai-dynamo/vllm-runtime:0.4.1`](http://nvcr.io/nvidia/ai-dynamo/vllm-runtime:0.4.1), but you can build your own runtime image following the [instructions](https://github.com/ai-dynamo/dynamo/blob/main/components/backends/vllm/README.md) in the Dynamo repository.

An example of a disaggregated deployment graph is available in the [NVIDIA Dynamo’s github repository](https://github.com/ai-dynamo/dynamo/tree/v0.4.1/components/backends/vllm/deploy). For this guide, the example was adapted to work for a validated container runtime:

```yaml
apiVersion: nvidia.com/v1alpha1
kind: DynamoGraphDeployment
metadata:
  name: vllm-v1-disagg-router
spec:
  services:
    Frontend:
      dynamoNamespace: vllm-v1-disagg-router
      componentType: frontend
      replicas: 1
      livenessProbe:
        httpGet:
          path: /health
          port: 8000
        initialDelaySeconds: 20
        periodSeconds: 5
        timeoutSeconds: 5
        failureThreshold: 3
      readinessProbe:
        exec:
          command:
            - /bin/sh
            - -c
            - 'curl -s http://localhost:8000/health | jq -e ".status == \"healthy\""'
        initialDelaySeconds: 60
        periodSeconds: 60
        timeoutSeconds: 30
        failureThreshold: 10
      resources:
        requests:
          cpu: "1"
          memory: "2Gi"
        limits:
          cpu: "1"
          memory: "2Gi"
      extraPodSpec:
        mainContainer:
          image: nvcr.io/nvidia/ai-dynamo/vllm-runtime:0.4.1
          workingDir: /workspace/components/backends/vllm
          command:
            - /bin/sh
            - -c
          args:
            - "python3 -m dynamo.frontend --http-port 8000 --router-mode kv"
    VllmDecodeWorker:
      dynamoNamespace: vllm-v1-disagg-router
      envFromSecret: hf-token-secret
      componentType: worker
      replicas: 1
      livenessProbe:
        httpGet:
          path: /live
          port: 9090
        periodSeconds: 5
        timeoutSeconds: 30
        failureThreshold: 1
      readinessProbe:
        httpGet:
          path: /health
          port: 9090
        periodSeconds: 10
        timeoutSeconds: 30
        failureThreshold: 60
      resources:
        requests:
          cpu: "10"
          memory: "20Gi"
          gpu: "1"
        limits:
          cpu: "10"
          memory: "20Gi"
          gpu: "1"
      envs:
        - name: DYN_SYSTEM_ENABLED
          value: "true"
        - name: DYN_SYSTEM_USE_ENDPOINT_HEALTH_STATUS
          value: "[\"generate\"]"
      extraPodSpec:
        runtimeClassName: nvidia
        mainContainer:
          startupProbe:
            httpGet:
              path: /health
              port: 9090
            periodSeconds: 10
            failureThreshold: 60
          image: nvcr.io/nvidia/ai-dynamo/vllm-runtime:0.4.1
          workingDir: /workspace/components/backends/vllm
          command:
            - /bin/sh
            - -c
          args:
            - python3 -m dynamo.vllm --model Qwen/Qwen3-0.6B  2>&1 | tee /tmp/vllm.log
    VllmPrefillWorker:
      dynamoNamespace: vllm-v1-disagg-router
      envFromSecret: hf-token-secret
      componentType: worker
      replicas: 1
      livenessProbe:
        httpGet:
          path: /live
          port: 9090
        periodSeconds: 5
        timeoutSeconds: 30
        failureThreshold: 1
      readinessProbe:
        httpGet:
          path: /health
          port: 9090
        periodSeconds: 10
        timeoutSeconds: 30
        failureThreshold: 60
      resources:
        requests:
          cpu: "10"
          memory: "20Gi"
          gpu: "1"
        limits:
          cpu: "10"
          memory: "20Gi"
          gpu: "1"
      envs:
        - name: DYN_SYSTEM_ENABLED
          value: "true"
        - name: DYN_SYSTEM_USE_ENDPOINT_HEALTH_STATUS
          value: "[\"generate\"]"
        - name: DYN_SYSTEM_PORT
          value: "9090"
      extraPodSpec:
        runtimeClassName: nvidia
        mainContainer:
          startupProbe:
            httpGet:
              path: /health
              port: 9090
            periodSeconds: 10
            failureThreshold: 60
          image: nvcr.io/nvidia/ai-dynamo/vllm-runtime:0.4.0
          workingDir: /workspace/components/backends/vllm
          command:
            - /bin/sh
            - -c
          args:
            - python3 -m dynamo.vllm --model Qwen/Qwen3-0.6B  --is-prefill-worker 2>&1 | tee /tmp/vllm.log
```

Deploy the disaggregated deployment graph with kubectl:

```shell
kubectl -n dynamo-cloud apply -f disagg_custom.yaml
```

After some minutes (pulling the vllm runtime image takes its time), check that the pods are up and running:

```shell
kubectl -n dynamo-cloud get pods,svc
---
NAME                                                                  READY   STATUS      RESTARTS   AGE
pod/disagg-frontend-65646b6f7b-dwfr2                                  1/1     Running     0          27m
pod/disagg-prefillworker-5b784c677c-42pts                             1/1     Running     0          27m
pod/disagg-vllmworker-d494976f6-78hr7                                 1/1     Running     0          33m
[...]

NAME                                    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
service/disagg-frontend                 ClusterIP   10.43.92.113    <none>        8000/TCP            33m
[...]
```

## (Optional) Querying the API Locally

In case you want to query the API client locally, forward the vllm frontend service through Kubernetes with this command:

```shell
laptop$ kubectl port-forward svc/<frontend_service> <local_port>:8000 &
```

Example:

```shell
laptop$ kubectl port-forward svc/vllm-v1-disagg-router-frontend 9000:8000 &
```

 To test the loaded models, run requests to the frontend via curl:

```shell
laptop$ curl localhost:9000/v1/models | jq .
```

```json
{
  "object": "list",
  "data": [
    {
      "id": "Qwen/Qwen3-0.6B",
      "object": "object",
      "created": 1756908946,
      "owned_by": "nvidia"
    }
  ]
}
```

And also submit inference requests:

```shell
laptop$ curl localhost:9000/v1/completions   -H "Content-Type: application/json"   -d '{
    "model": "Qwen/Qwen3-0.6B",
    "prompt": "What is opennebula?",
    "stream": false,
    "max_tokens": 300
  }' | jq
```

You will receive a response like this:

```json
{
  "id": "cmpl-2c749514-9a81-4864-a119-d195d39a235b",
  "choices": [
    {
      "text": "<think>\nOkay, the user is asking about OpenNebula. First, I need to make sure I understand what OpenNebula is. From what I remember, OpenNebula is an open-source orchestration system used for managing virtual machines (VMs) in cloud environments. It's often used in Linux-based cloud infrastructures like AWS or Azure. \n\nI should start by defining OpenNebula. It's a tool that helps manage and orchestrate virtual machines on a cloud platform. The key features include providing a way to manage VMs, resources, and services in a centralized manner. OpenNebula is designed to be flexible and scalable, allowing for easy integration with various cloud providers.\n\nWait, are there any specific use cases or industries where OpenNebula is commonly used? I think it's often used in enterprise environments for managing VMs, especially in environments where automation and resource management are critical. It's also used in hybrid cloud setups where VMs can be managed between on-premises and cloud environments.\n\nI should mention that OpenNebula is open-source, which is important to highlight. It's developed by a community and is licensed under a specific open-source license. Maybe include something about how it simplifies VM orchestration and management.\n\nAre there any common misconceptions about OpenNebula? Perhaps users might confuse it with other cloud management tools. I should clarify that it's specifically for orchestration rather than just managing VMs.",
      "index": 0,
      "logprobs": null,
      "finish_reason": "stop"
    }
  ],
  "created": 1755169608,
  "model": "Qwen/Qwen3-0.6B",
  "system_fingerprint": null,
  "object": "text_completion",
  "usage": {
    "prompt_tokens": 15,
    "completion_tokens": 299,
    "total_tokens": 314,
    "prompt_tokens_details": null,
    "completion_tokens_details": null
  }
}
```

If you want to test the response in stream mode, set the parameter `stream: true` and delete the `jq` tool piping to that call:

```shell
laptop$ curl localhost:9000/v1/completions   -H "Content-Type: application/json"   -d '{
    "model": "Qwen/Qwen3-0.6B",
    "prompt": "What is opennebula?",
    "stream": true,
    "max_tokens": 300
  }
```

You will see this streamed output:

```shell
data: {"id":"cmpl-84041acf-79d1-4ec4-b913-c492fa4f3379","choices":[{"text":"<think>","index":0,"logprobs":null,"finish_reason":null}],"created":1756908478,"model":"Qwen/Qwen3-0.6B","system_fingerprint":null,"object":"text_completion","usage":{"prompt_tokens":15,"completion_tokens":1,"total_tokens":16,"prompt_tokens_details":null,"completion_tokens_details":null}}

data: {"id":"cmpl-84041acf-79d1-4ec4-b913-c492fa4f3379","choices":[{"text":"\n","index":0,"logprobs":null,"finish_reason":null}],"created":1756908478,"model":"Qwen/Qwen3-0.6B","system_fingerprint":null,"object":"text_completion","usage":{"prompt_tokens":15,"completion_tokens":2,"total_tokens":17,"prompt_tokens_details":null,"completion_tokens_details":null}}

data: {"id":"cmpl-84041acf-79d1-4ec4-b913-c492fa4f3379","choices":[{"text":"Okay","index":0,"logprobs":null,"finish_reason":null}],"created":1756908478,"model":"Qwen/Qwen3-0.6B","system_fingerprint":null,"object":"text_completion","usage":{"prompt_tokens":15,"completion_tokens":3,"total_tokens":18,"prompt_tokens_details":null,"completion_tokens_details":null}}

[...]
```

In the streamed output, you will receive multiple JSON responses with the response tokens in the `text` field, with some metadata included.

{{< alert title="Tip" color="success" >}}
Alternatively, after validating your AI Factory with NVIDIA Dynamo on Kubernetes, you may choose to follow [Validation with LLM Inferencing]({{% relref "solutions/deployment_blueprints/ai-ready_opennebula/llm_inference_certification" %}}).
llm_inference_certification" %}}).
{{< /alert >}}