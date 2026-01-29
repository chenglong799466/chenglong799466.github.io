---
layout:     post
title:      NetworkPolicy 网络策略详解
subtitle:   Kubernetes NetworkPolicy Detailed Guide
date:       2024-01-13
author:     chenglong
description: Kubernetes NetworkPolicy网络策略完整指南，涵盖入站/出站流量控制、标签选择器、命名空间隔离、IP地址块控制等网络安全配置
categories: [Kubernetes, 网络安全]
header-img: img/post-bg-coffee.jpeg
catalog: true
tags:
    - Kubernetes
    - NetworkPolicy
    - 网络安全
    - 网络隔离
    - 微服务安全
    - DevOps
---

# NetworkPolicy 网络策略详解

## NetworkPolicy 简介

NetworkPolicy 是 Kubernetes 中用于控制 Pod 之间网络通信的资源对象。它允许你定义精细的网络访问规则，实现 Kubernetes 集群内部的网络安全隔离。

![NetworkPolicy 示意图](https://kubernetes.io/images/docs/network-policy.svg)
*图：NetworkPolicy 控制 Pod 间网络流量示意图*

## NetworkPolicy 基本概念

### 1. 默认行为
- 如果没有定义 NetworkPolicy，所有 Pod 之间可以自由通信
- 一旦为某个命名空间定义了 NetworkPolicy，该命名空间的所有 Pod 将默认拒绝所有入站流量
- 出站流量默认允许，除非明确拒绝

### 2. 选择器机制
NetworkPolicy 使用标签选择器来选择要应用策略的 Pod：
- `podSelector`: 选择应用策略的目标 Pod
- `namespaceSelector`: 选择允许通信的命名空间
- `ipBlock`: 基于 IP 地址块进行控制

## NetworkPolicy 配置示例

### 1. 基本示例：允许特定 Pod 访问

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-backend
  namespace: production
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend
    ports:
    - protocol: TCP
      port: 8080
```

这个策略允许带有 `app: frontend` 标签的 Pod 访问带有 `app: backend` 标签的 Pod 的 8080 端口。

### 2. 命名空间级别的访问控制

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-monitoring-namespace
  namespace: production
spec:
  podSelector:
    matchLabels:
      app: database
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: monitoring
    ports:
    - protocol: TCP
      port: 5432
```

这个策略允许 `monitoring` 命名空间中的所有 Pod 访问 `production` 命名空间中带有 `app: database` 标签的 Pod 的 5432 端口。

### 3. 多源访问控制

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: multi-source-access
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: api
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend
    - namespaceSelector:
        matchLabels:
          name: staging
    ports:
    - protocol: TCP
      port: 80
    - protocol: TCP
      port: 443
```

### 4. IP 地址块控制

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-external-ips
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: web
  policyTypes:
  - Ingress
  ingress:
  - from:
    - ipBlock:
        cidr: 192.168.1.0/24
        except:
        - 192.168.1.100/32
    ports:
    - protocol: TCP
      port: 80
```

这个策略允许来自 192.168.1.0/24 网段（除了 192.168.1.100）的流量访问 Web Pod 的 80 端口。

## 出站策略（Egress）

### 1. 限制出站流量

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: restrict-egress
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: restricted
  policyTypes:
  - Egress
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: database
    ports:
    - protocol: TCP
      port: 3306
  - to:
    - ipBlock:
        cidr: 8.8.8.8/32
    ports:
    - protocol: UDP
      port: 53
```

这个策略限制带有 `app: restricted` 标签的 Pod 只能：
- 访问带有 `app: database` 标签的 Pod 的 3306 端口
- 访问 DNS 服务器 8.8.8.8 的 53 端口

## 实际应用场景

### 1. 微服务架构安全

```yaml
# API 服务只允许前端访问
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: api-service-policy
  namespace: microservices
spec:
  podSelector:
    matchLabels:
      app: api-service
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend
    ports:
    - protocol: TCP
      port: 8080
```

### 2. 数据库隔离

```yaml
# 数据库只允许特定应用访问
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: database-isolation
  namespace: data
spec:
  podSelector:
    matchLabels:
      app: mysql
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: backend-api
    ports:
    - protocol: TCP
      port: 3306
```

## 管理和调试

### 1. 查看 NetworkPolicy

```bash
# 查看所有 NetworkPolicy
kubectl get networkpolicies --all-namespaces

# 查看特定命名空间的 NetworkPolicy
kubectl get networkpolicies -n default

# 查看 NetworkPolicy 详情
kubectl describe networkpolicy <policy-name> -n <namespace>
```

### 2. 测试网络连通性

```bash
# 在 Pod 内测试网络连通性
kubectl exec -it <pod-name> -- nc -zv <target-pod-ip> <port>

# 使用 busybox 进行网络测试
kubectl run test-pod --image=busybox --rm -it -- /bin/sh
```

## 最佳实践

1. **最小权限原则**: 只允许必要的网络访问
2. **标签标准化**: 使用一致的标签命名规范
3. **命名空间隔离**: 合理使用命名空间进行逻辑隔离
4. **渐进式实施**: 从关键服务开始逐步实施网络策略
5. **监控和日志**: 配置网络策略的监控和日志记录

## 常见问题

### 1. NetworkPolicy 不生效
- 检查网络插件是否支持 NetworkPolicy
- 验证 Pod 标签是否正确
- 确认策略的命名空间是否正确

### 2. 策略冲突
- 多个 NetworkPolicy 会叠加生效
- 使用 `kubectl describe` 查看策略详情
- 按优先级顺序应用策略

NetworkPolicy 是 Kubernetes 网络安全的重要组成部分，合理使用可以有效提升集群的安全性。