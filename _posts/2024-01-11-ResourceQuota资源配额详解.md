---
layout:     post
title:      ResourceQuota 资源配额详解
subtitle:   Detailed explanation of Kubernetes ResourceQuota
date:       2024-01-11
author:     chenglong
description: Kubernetes ResourceQuota资源配额完整指南，涵盖计算资源、存储资源、对象数量配额配置，以及多环境实际应用场景和最佳实践
categories: [Kubernetes, 容器编排]
header-img: img/post-bg-coffee.jpeg
catalog: true
tags:
    - Kubernetes
    - ResourceQuota
    - 资源管理
    - 容器编排
    - DevOps
    - 多租户
---

# ResourceQuota 是什么？

ResourceQuota 是 Kubernetes 中用于限制命名空间级别资源使用总量的对象。它可以防止单个命名空间消耗过多集群资源，确保资源的公平分配和集群的稳定性。

![ResourceQuota 资源配额](https://kubernetes.io/images/docs/resourcequota.svg)
*图：ResourceQuota 控制命名空间资源总量示意图*

# ResourceQuota 的核心功能

- **计算资源配额**：限制命名空间内所有 Pod 的 CPU 和内存使用总量
- **存储资源配额**：限制命名空间内 PersistentVolumeClaim 的总存储容量
- **对象数量配额**：限制命名空间内特定类型资源对象的数量

# 计算资源配额配置

## 基本 CPU 和内存配额

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-resources
  namespace: production
spec:
  hard:
    requests.cpu: "2"
    requests.memory: 4Gi
    limits.cpu: "4"
    limits.memory: 8Gi
```

**解释：**
- `requests.cpu: "2"`：命名空间内所有 Pod 的 CPU 请求总量不超过 2 个 CPU 核心
- `requests.memory: 4Gi`：内存请求总量不超过 4 GiB
- `limits.cpu: "4"`：CPU 限制总量不超过 4 个核心
- `limits.memory: 8Gi`：内存限制总量不超过 8 GiB

## 扩展计算资源配额

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: extended-compute-resources
  namespace: development
spec:
  hard:
    # 请求资源总量
    requests.cpu: "4"
    requests.memory: 8Gi
    
    # 限制资源总量
    limits.cpu: "8"
    limits.memory: 16Gi
    
    # 特定资源类型的请求和限制
    pods.requests.cpu: "2"
    pods.requests.memory: 4Gi
    pods.limits.cpu: "4"
    pods.limits.memory: 8Gi
```

# 存储资源配额配置

## 存储容量配额

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: storage-resources
  namespace: data
spec:
  hard:
    requests.storage: 100Gi
    persistentvolumeclaims: "10"
```

**解释：**
- `requests.storage: 100Gi`：所有 PVC 的总存储请求不超过 100 GiB
- `persistentvolumeclaims: "10"`：PVC 对象数量不超过 10 个

## 存储类特定配额

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: storage-class-quota
  namespace: backup
spec:
  hard:
    # 快速存储配额
    fast.storageclass.storage.k8s.io/requests.storage: 50Gi
    fast.storageclass.storage.k8s.io/persistentvolumeclaims: "5"
    
    # 慢速存储配额
    slow.storageclass.storage.k8s.io/requests.storage: 200Gi
    slow.storageclass.storage.k8s.io/persistentvolumeclaims: "20"
```

# 对象数量配额配置

## 限制资源对象数量

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: object-counts
  namespace: test
spec:
  hard:
    # Pod 数量限制
    pods: "20"
    
    # 服务数量限制
    services: "10"
    services.loadbalancers: "2"
    services.nodeports: "5"
    
    # 其他资源对象
    configmaps: "50"
    secrets: "50"
    persistentvolumeclaims: "15"
    replicationcontrollers: "10"
    resourcequotas: "1"
```

## 工作负载控制器配额

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: workload-quota
  namespace: production
spec:
  hard:
    # 工作负载控制器数量
    deployments.apps: "10"
    replicasets.apps: "20"
    statefulsets.apps: "5"
    daemonsets.apps: "3"
    jobs.batch: "5"
    cronjobs.batch: "3"
```

# 实际应用场景

## 多租户环境配额管理

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: tenant-a-quota
  namespace: tenant-a
spec:
  hard:
    # 计算资源
    requests.cpu: "8"
    requests.memory: 16Gi
    limits.cpu: "16"
    limits.memory: 32Gi
    
    # 存储资源
    requests.storage: 200Gi
    persistentvolumeclaims: "20"
    
    # 对象数量
    pods: "50"
    services: "15"
    deployments.apps: "10"
```

## 开发环境资源限制

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: dev-environment
  namespace: development
spec:
  hard:
    # 宽松的计算资源
    requests.cpu: "4"
    requests.memory: 8Gi
    limits.cpu: "8"
    limits.memory: 16Gi
    
    # 限制对象数量防止资源浪费
    pods: "30"
    services: "10"
    persistentvolumeclaims: "5"
```

## 生产环境严格配额

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: production-strict
  namespace: production
spec:
  hard:
    # 严格的计算资源限制
    requests.cpu: "16"
    requests.memory: 32Gi
    limits.cpu: "32"
    limits.memory: 64Gi
    
    # 关键资源对象限制
    pods: "100"
    services.loadbalancers: "5"
    persistentvolumeclaims: "30"
```

# ResourceQuota 与 LimitRange 的配合使用

## 组合配置示例

```yaml
# LimitRange - 设置单个容器的资源限制
apiVersion: v1
kind: LimitRange
metadata:
  name: container-limits
  namespace: production
spec:
  limits:
  - type: Container
    default:
      cpu: "500m"
      memory: "512Mi"
    defaultRequest:
      cpu: "250m"
      memory: "256Mi"
    max:
      cpu: "2"
      memory: "2Gi"
```

```yaml
# ResourceQuota - 设置命名空间资源总量
apiVersion: v1
kind: ResourceQuota
metadata:
  name: namespace-quota
  namespace: production
spec:
  hard:
    requests.cpu: "10"
    requests.memory: 20Gi
    limits.cpu: "20"
    limits.memory: 40Gi
    pods: "50"
```

# 管理和监控

## 查看 ResourceQuota

```bash
# 查看所有命名空间的 ResourceQuota
kubectl get resourcequotas --all-namespaces

# 查看特定命名空间的 ResourceQuota
kubectl get resourcequota -n production

# 查看 ResourceQuota 详情
kubectl describe resourcequota compute-resources -n production
```

## 监控资源使用情况

```bash
# 查看命名空间资源使用
kubectl top pods --namespace=production

# 查看 ResourceQuota 使用比例
kubectl get resourcequota -o yaml
```

## 资源使用情况示例输出

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-resources
  namespace: production
spec:
  hard:
    requests.cpu: "2"
    requests.memory: 4Gi
    limits.cpu: "4"
    limits.memory: 8Gi
status:
  hard:
    requests.cpu: "2"
    requests.memory: 4Gi
    limits.cpu: "4"
    limits.memory: 8Gi
  used:
    requests.cpu: "1.5"
    requests.memory: 3Gi
    limits.cpu: "3"
    limits.memory: 6Gi
```

# 最佳实践

## 配额规划策略
- **按环境设置**：为不同环境设置不同的配额策略
- **渐进式调整**：根据实际使用情况逐步调整配额
- **预留缓冲**：为突发需求预留一定的资源缓冲

## 监控和告警
- 设置资源使用率告警阈值（如 80%）
- 定期审查配额使用情况
- 建立配额调整流程

## 多租户管理
- 为每个租户分配独立的命名空间
- 根据业务重要性设置不同的配额
- 建立租户资源申请和审批流程

# 常见问题排查

## Pod 创建失败
```bash
# 查看 ResourceQuota 限制
kubectl describe resourcequota -n <namespace>

# 查看错误信息
kubectl describe pod <pod-name>
```

## 资源配额不足
```bash
# 查看当前资源使用情况
kubectl get resourcequota -o yaml

# 查看命名空间资源使用详情
kubectl top pods -n <namespace>
```

## 配额调整
```bash
# 编辑 ResourceQuota
kubectl edit resourcequota <quota-name> -n <namespace>

# 或者使用 apply 更新
kubectl apply -f resourcequota.yaml
```

ResourceQuota 是 Kubernetes 多租户管理和资源控制的核心工具，合理使用可以确保集群资源的公平分配和稳定运行。