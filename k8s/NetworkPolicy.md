
# NetworkPolicy
NetworkPolicy 对象的名称必须是一个合法的 DNS 子域名.

```
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: access-nginx
spec:
  podSelector: # 指定了策略的作用对象，这里是选择具有标签 app: nginx 的 Pod。
    matchLabels:
      app: nginx
  ingress: # 定义了入站流量的规则，即允许哪些 Pod 发送流量到被标记为 app: nginx 的目标 Pod。
  - from: # 指定了来源的规则，这里是允许具有标签 access: "true" 的 Pod 发送流量。
    - podSelector:
        matchLabels:
          access: "true"

```

上述 YAML 配置文件定义了一个名为 "access-nginx" 的 NetworkPolicy（网络策略）资源。下面是对该配置的解释：

- `apiVersion: networking.k8s.io/v1`：指定了所使用的 Kubernetes 网络策略的 API 版本。
- `kind: NetworkPolicy`：指定了资源类型为 NetworkPolicy，表示这是一个网络策略对象。
- `metadata`：包含了关于 NetworkPolicy 对象的元数据，如名称等。
- `name: access-nginx`：指定了 NetworkPolicy 的名称为 "access-nginx"。
- `spec`：定义了 NetworkPolicy 的规范（specification）部分，包含了具体的策略规则。
- `podSelector`：指定了策略的作用对象，这里是选择具有标签 `app: nginx` 的 Pod。
- `ingress`：定义了入站流量的规则，即允许哪些 Pod 发送流量到被标记为 `app: nginx` 的目标 Pod。
- `from`：指定了来源的规则，这里是允许具有标签 `access: "true"` 的 Pod 发送流量。
- `podSelector`：指定了来源 Pod 的选择条件，这里是选择具有标签 `access: "true"` 的 Pod。

总体而言，该 NetworkPolicy 配置允许具有标签 `access: "true"` 的 Pod 发送流量到具有标签 `app: nginx` 的目标 Pod。这是一种基于标签选择器的网络策略，通过定义规则来限制和控制 Pod 之间的流量通信。

