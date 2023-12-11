ResourceQuota对象

Quota -定额，限额；

## 示例：配置命名空间的内存，cpu的配额
https://kubernetes.io/zh-cn/docs/tasks/administer-cluster/manage-resources/quota-memory-cpu-namespace/

```
apiVersion: v1
kind: ResourceQuota
metadata:
  name: mem-cpu-demo
spec:
  hard:
    requests.cpu: "1"
    requests.memory: 1Gi
    limits.cpu: "2"
    limits.memory: 2Gi
```

这是一个 Kubernetes 的配置文件，用于定义一个资源配额（ResourceQuota）。根据该配置文件的内容，以下是对其的解释：

- `apiVersion: v1`: 这指定了 Kubernetes API 的版本，该配置文件使用的是 v1 版本的 API。

- `kind: ResourceQuota`: 这表明该配置文件定义了一个 ResourceQuota 对象，用于**限制命名空间中的资源使用**。

- `metadata: name: mem-cpu-demo`: 这指定了 ResourceQuota 对象的元数据，其中 `name` 字段为 "mem-cpu-demo"，表示该 ResourceQuota 对象的名称。

- `spec: hard:`: 这是配置文件的主体部分，定义了资源的硬限制规则。

    - `requests.cpu: "1"`: 这表示请求的 CPU 资源的硬限制为 1 核。这限制了在命名空间中所有 Pod 的 CPU **请求总和**不能超过 1 核。

    - `requests.memory: 1Gi`: 这表示请求的内存资源的硬限制为 1 GiB。这限制了在命名空间中所有 Pod 的内存请求总和不能超过 1 GiB。

    - `limits.cpu: "2"`: 这表示限制的 CPU 资源的硬限制为 2 核。这限制了在命名空间中所有 Pod 的 CPU 限制总和不能超过 2 核。

    - `limits.memory: 2Gi`: 这表示限制的内存资源的硬限制为 2 GiB。这限制了在命名空间中所有 Pod 的内存限制总和不能超过 2 GiB。

根据以上解释，该配置文件定义了一个名为 "mem-cpu-demo" 的 ResourceQuota 对象，在该对象中，命名空间中所有 Pod 的 CPU 请求总和不能超过 1 核，内存请求总和不能超过 1 GiB，CPU 限制总和不能超过 2 核，内存限制总和不能超过 2 GiB。

这个配置文件可以被应用到 Kubernetes 集群中的命名空间中，以确保在该命名空间中的 Pod 的资源使用遵守预定义的硬限制规则。

## 示例：配置命名空间的pod的peie

```
apiVersion: v1
kind: ResourceQuota
metadata:
  name: pod-demo
spec:
  hard:
    pods: "2" # pod的peih
```

