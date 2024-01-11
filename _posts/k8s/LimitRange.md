LimitRange 对象

# 设置默认的request和limit

## 内存示例
```
apiVersion: v1
kind: LimitRange
metadata:
name: mem-limit-range
spec:
limits:
- default:
  memory: 512Mi
  defaultRequest:
  memory: 256Mi
  type: Container
```

这是一个 Kubernetes 的配置文件，用于定义一个资源限制范围（LimitRange）。根据该配置文件的内容，以下是对其的解释：

- `apiVersion: v1`: 这指定了 Kubernetes API 的版本，该配置文件使用的是 v1 版本的 API。

- `kind: LimitRange`: 这表明该配置文件定义了一个 LimitRange 对象，用于限制容器资源的使用。

- `metadata: name: mem-limit-range`: 这指定了 LimitRange 对象的元数据，其中 `name` 字段为 "mem-limit-range"，表示该 LimitRange 对象的名称。

- `spec: limits:`: 这是配置文件的主体部分，定义了资源限制的规则。

    - `- default:`: 这定义了默认的资源限制规则。

        - `memory: 512Mi`: 这表示默认的内存限制为 512 MiB，即容器的最大可用内存限制。

    - `defaultRequest:`: 这定义了默认的资源请求规则。

        - `memory: 256Mi`: 这表示默认的内存请求为 256 MiB，即容器在调度时请求的内存资源。

    - `type: Container`: 这指定了该资源限制范围适用于容器级别的资源。

根据以上解释，该配置文件定义了一个名为 "mem-limit-range" 的 LimitRange 对象，在该对象中，容器的默认内存限制为 512MiB，容器的默认内存请求为 256MiB，并且这些限制适用于容器级别的资源。

## cpu 示例
```
apiVersion: v1
kind: LimitRange
metadata:
name: cpu-limit-range
spec:
limits:
- default:
  cpu: 1
  defaultRequest:
  cpu: 0.5
  type: Container
```


- 如果 LimitRange 对象定义了某个资源的默认request或默认limit，而 Pod 没有显式声明该资源的请求或限制，那么将应用默认值。如果 LimitRange 对象定义了某个资源的默认请求和默认限制，
并且 Pod 显式声明了该资源的请求和限制，那么将应用 Pod 中声明的值。

# 设置最大和最小的约束

## 内存约束
```
apiVersion: v1
kind: LimitRange
metadata:
  name: mem-min-max-demo-lr
spec:
  limits:
  - max: # 这里设置了最大值和最小值约束，即使没有设置默认值，默认值也会生成
      memory: 1Gi
    min:
      memory: 500Mi
    type: Container
```

刚才的设置相当于以下

```
  limits:
  - default:
      memory: 1Gi
    defaultRequest:
      memory: 1Gi
    max:
      memory: 1Gi
    min:
      memory: 500Mi
    type: Container
```

- 如果pod申明的request或者limit设置大于小于约束，创建会报错:
```Error from server (Forbidden): error when creating "examples/admin/resource/memory-constraints-pod-2.yaml":pods "constraints-mem-demo-2" is forbidden: maximum memory usage per Container is 1Gi, but limit is 1536Mi.```

## cpu约束
```
apiVersion: v1
kind: LimitRange
metadata:
  name: cpu-min-max-demo-lr
spec:
  limits:
  - max: # 这里设置了最大值和最小值约束，即使没有设置默认值，默认值也会生成
      cpu: "800m"
    min:
      cpu: "200m"
    type: Container
```

等同于

```
limits:
- default:
    cpu: 800m
  defaultRequest:
    cpu: 800m
  max:
    cpu: 800m
  min:
    cpu: 200m
  type: Container

```