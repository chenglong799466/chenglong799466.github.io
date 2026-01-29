---
layout:     post
title:      Kubernetes Ingress详解
subtitle:   K8s七层负载均衡与HTTP路由管理
date:       2024-02-02
author:     chenglong
description: 深入解析Kubernetes Ingress的工作原理、配置方法和最佳实践，包括路径路由、域名路由、TLS配置、重写规则等高级特性
categories: [Kubernetes, 容器编排, 网络]
header-img: img/post-bg-coffee.jpeg
catalog: true
tags:
    - Kubernetes
    - Ingress
    - 负载均衡
    - HTTP路由
    - 网络
    - DevOps
---

## 什么是Kubernetes Ingress？

在Kubernetes中，**Service**提供了四层（TCP/UDP）负载均衡能力，但对于HTTP/HTTPS应用，我们通常需要更智能的七层路由功能。**Ingress**就是为此而生的API对象。

### Ingress的核心价值

想象一下，如果没有Ingress：
- 每个服务都需要一个LoadBalancer（成本高昂）
- 无法基于域名或路径进行路由
- 难以统一管理SSL证书
- 缺少高级HTTP功能（重写、重定向等）

**Ingress解决了这些问题**，它提供：

✅ **统一入口**：一个LoadBalancer管理多个服务  
✅ **智能路由**：基于域名、路径、Header等进行路由  
✅ **SSL/TLS终止**：集中管理证书  
✅ **负载均衡**：七层负载均衡和会话保持  
✅ **高级功能**：URL重写、重定向、认证等  

---

## Ingress架构

### 核心组件

```
外部流量
    ↓
LoadBalancer (公网IP: 203.0.113.10)
    ↓
Ingress Controller (Nginx/Traefik/HAProxy)
    ↓
根据Ingress规则路由
    ↓
┌─────────────────┬─────────────────┬─────────────────┐
│ Service A       │ Service B       │ Service C       │
│ (ClusterIP)     │ (ClusterIP)     │ (ClusterIP)     │
└─────────────────┴─────────────────┴─────────────────┘
    ↓                   ↓                   ↓
Pod A1, A2, A3     Pod B1, B2         Pod C1, C2, C3
```

### 三个关键概念

1. **Ingress资源**：定义路由规则的YAML配置
2. **Ingress Controller**：实际执行路由的控制器（如Nginx Ingress Controller）
3. **后端Service**：Ingress路由到的目标服务

⚠️ **重要**：Ingress资源本身不做任何事情，必须有Ingress Controller才能工作！

---

## Ingress vs Service

| 特性 | Service (LoadBalancer) | Ingress |
|------|----------------------|---------|
| **OSI层级** | 四层（TCP/UDP） | 七层（HTTP/HTTPS） |
| **路由能力** | 仅端口转发 | 域名、路径、Header路由 |
| **成本** | 每个服务一个LB | 多个服务共享一个LB |
| **SSL终止** | 需要应用自己处理 | 统一管理证书 |
| **高级功能** | 无 | 重写、重定向、认证等 |
| **使用场景** | 非HTTP服务、简单场景 | HTTP/HTTPS应用 |

---

## 基础示例

### 1. 最简单的Ingress

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: simple-ingress
  namespace: default
spec:
  # 默认后端（可选）
  defaultBackend:
    service:
      name: default-service
      port:
        number: 80
  # 路由规则
  rules:
  - host: example.com  # 域名
    http:
      paths:
      - path: /
        pathType: Prefix  # 路径匹配类型
        backend:
          service:
            name: web-service
            port:
              number: 80
```

**访问方式**：
```bash
curl http://example.com/
# 流量路由到 web-service:80
```

### 2. 多域名路由

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: multi-host-ingress
spec:
  rules:
  # 域名1：www.example.com
  - host: www.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: website-service
            port:
              number: 80
  
  # 域名2：api.example.com
  - host: api.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 8080
  
  # 域名3：admin.example.com
  - host: admin.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: admin-service
            port:
              number: 3000
```

**路由效果**：
```bash
curl http://www.example.com/    → website-service:80
curl http://api.example.com/    → api-service:8080
curl http://admin.example.com/  → admin-service:3000
```

### 3. 路径路由

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: path-based-ingress
spec:
  rules:
  - host: myapp.com
    http:
      paths:
      # 路径1：/api/*
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 8080
      
      # 路径2：/web/*
      - path: /web
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
      
      # 路径3：/admin/*
      - path: /admin
        pathType: Prefix
        backend:
          service:
            name: admin-service
            port:
              number: 3000
      
      # 默认路径：/*
      - path: /
        pathType: Prefix
        backend:
          service:
            name: default-service
            port:
              number: 80
```

**路由效果**：
```bash
curl http://myapp.com/api/users      → api-service:8080
curl http://myapp.com/web/index.html → web-service:80
curl http://myapp.com/admin/login    → admin-service:3000
curl http://myapp.com/other          → default-service:80
```

---

## 路径匹配类型（PathType）

Kubernetes支持三种路径匹配类型：

### 1. Prefix（前缀匹配）

最常用的类型，匹配路径前缀。

```yaml
- path: /api
  pathType: Prefix
```

**匹配规则**：
- ✅ `/api` → 匹配
- ✅ `/api/` → 匹配
- ✅ `/api/users` → 匹配
- ✅ `/api/v1/users` → 匹配
- ❌ `/api2` → 不匹配
- ❌ `/apiv1` → 不匹配

### 2. Exact（精确匹配）

必须完全匹配路径。

```yaml
- path: /api
  pathType: Exact
```

**匹配规则**：
- ✅ `/api` → 匹配
- ❌ `/api/` → 不匹配
- ❌ `/api/users` → 不匹配

### 3. ImplementationSpecific（实现特定）

由Ingress Controller决定匹配规则（不推荐使用）。

```yaml
- path: /api
  pathType: ImplementationSpecific
```

---

## TLS/SSL配置

### 1. 基本TLS配置

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: tls-ingress
spec:
  tls:
  - hosts:
    - example.com
    - www.example.com
    secretName: example-tls  # 引用Secret
  rules:
  - host: example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
```

### 2. 创建TLS Secret

```bash
# 方法1：从证书文件创建
kubectl create secret tls example-tls \
  --cert=path/to/tls.crt \
  --key=path/to/tls.key

# 方法2：使用YAML
apiVersion: v1
kind: Secret
metadata:
  name: example-tls
  namespace: default
type: kubernetes.io/tls
data:
  tls.crt: <base64-encoded-cert>
  tls.key: <base64-encoded-key>
```

### 3. 使用cert-manager自动管理证书

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: auto-tls-ingress
  annotations:
    # 使用cert-manager自动申请Let's Encrypt证书
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
spec:
  tls:
  - hosts:
    - example.com
    secretName: example-tls-auto  # cert-manager会自动创建
  rules:
  - host: example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
```

**访问效果**：
```bash
# HTTP自动重定向到HTTPS
curl http://example.com/
# → 301 Redirect → https://example.com/

# HTTPS访问
curl https://example.com/
# → 正常访问，使用TLS加密
```

---

## Ingress注解（Annotations）

注解用于配置Ingress Controller的高级功能。不同的Controller支持不同的注解。

### Nginx Ingress Controller常用注解

#### 1. URL重写

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: rewrite-ingress
  annotations:
    # 重写路径
    nginx.ingress.kubernetes.io/rewrite-target: /$2
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /api(/|$)(.*)
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 8080
```

**效果**：
```bash
# 请求：http://example.com/api/users
# 转发到后端：http://api-service:8080/users
```

#### 2. 重定向

```yaml
metadata:
  annotations:
    # 永久重定向
    nginx.ingress.kubernetes.io/permanent-redirect: https://new-domain.com
    
    # 临时重定向
    nginx.ingress.kubernetes.io/temporal-redirect: https://maintenance.com
```

#### 3. CORS配置

```yaml
metadata:
  annotations:
    nginx.ingress.kubernetes.io/enable-cors: "true"
    nginx.ingress.kubernetes.io/cors-allow-origin: "https://example.com"
    nginx.ingress.kubernetes.io/cors-allow-methods: "GET, POST, PUT, DELETE"
    nginx.ingress.kubernetes.io/cors-allow-headers: "Authorization, Content-Type"
```

#### 4. 速率限制

```yaml
metadata:
  annotations:
    # 每秒10个请求
    nginx.ingress.kubernetes.io/limit-rps: "10"
    
    # 每个IP的连接数限制
    nginx.ingress.kubernetes.io/limit-connections: "5"
```

#### 5. 基本认证

```yaml
metadata:
  annotations:
    nginx.ingress.kubernetes.io/auth-type: basic
    nginx.ingress.kubernetes.io/auth-secret: basic-auth
    nginx.ingress.kubernetes.io/auth-realm: "Authentication Required"
```

```bash
# 创建认证Secret
htpasswd -c auth admin
kubectl create secret generic basic-auth --from-file=auth
```

#### 6. 白名单

```yaml
metadata:
  annotations:
    nginx.ingress.kubernetes.io/whitelist-source-range: "51.4.93.0/24,6.122.255.0/24"
```

#### 7. 自定义超时

```yaml
metadata:
  annotations:
    nginx.ingress.kubernetes.io/proxy-connect-timeout: "60"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "60"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "60"
```

#### 8. 会话亲和性

```yaml
metadata:
  annotations:
    nginx.ingress.kubernetes.io/affinity: "cookie"
    nginx.ingress.kubernetes.io/session-cookie-name: "route"
    nginx.ingress.kubernetes.io/session-cookie-expires: "172800"
    nginx.ingress.kubernetes.io/session-cookie-max-age: "172800"
```

---

## 完整实战示例

### 场景：部署一个完整的Web应用

```yaml
# 1. 后端API服务
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
      - name: api
        image: myapp/api:v1.0
        ports:
        - containerPort: 8080

---
apiVersion: v1
kind: Service
metadata:
  name: api-service
spec:
  selector:
    app: api
  ports:
  - port: 8080
    targetPort: 8080

---
# 2. 前端Web服务
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: web
        image: myapp/web:v1.0
        ports:
        - containerPort: 80

---
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 80

---
# 3. Ingress配置
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: myapp-ingress
  annotations:
    # 启用HTTPS重定向
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    # API路径重写
    nginx.ingress.kubernetes.io/rewrite-target: /$2
    # 启用CORS
    nginx.ingress.kubernetes.io/enable-cors: "true"
    # 速率限制
    nginx.ingress.kubernetes.io/limit-rps: "100"
    # 自动申请证书
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - myapp.com
    - www.myapp.com
    secretName: myapp-tls
  rules:
  # 主域名
  - host: myapp.com
    http:
      paths:
      # API路由
      - path: /api(/|$)(.*)
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 8080
      # Web路由
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
  
  # www子域名
  - host: www.myapp.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
```

### 部署和验证

```bash
# 1. 部署所有资源
kubectl apply -f myapp.yaml

# 2. 查看Ingress状态
kubectl get ingress myapp-ingress
kubectl describe ingress myapp-ingress

# 3. 查看Ingress Controller日志
kubectl logs -n ingress-nginx -l app.kubernetes.io/name=ingress-nginx

# 4. 测试访问
curl https://myapp.com/
curl https://myapp.com/api/users

# 5. 测试HTTP重定向
curl -I http://myapp.com/
# 应该返回 301 或 308 重定向到 https://
```

---

## IngressClass

从Kubernetes 1.18开始，引入了IngressClass资源，用于支持多个Ingress Controller。

### 定义IngressClass

```yaml
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: nginx
  annotations:
    ingressclass.kubernetes.io/is-default-class: "true"
spec:
  controller: k8s.io/ingress-nginx
```

### 在Ingress中使用

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
spec:
  ingressClassName: nginx  # 指定使用哪个IngressClass
  rules:
  - host: example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
```

---

## 最佳实践

### 1. 使用命名空间隔离

```yaml
# 生产环境
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: prod-ingress
  namespace: production
spec:
  rules:
  - host: api.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 80

---
# 测试环境
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: test-ingress
  namespace: testing
spec:
  rules:
  - host: api-test.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 80
```

### 2. 统一管理TLS证书

```yaml
# 使用通配符证书
apiVersion: v1
kind: Secret
metadata:
  name: wildcard-tls
  namespace: default
type: kubernetes.io/tls
data:
  tls.crt: <base64-cert>
  tls.key: <base64-key>

---
# 多个Ingress共享证书
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app1-ingress
spec:
  tls:
  - hosts:
    - app1.example.com
    secretName: wildcard-tls
  rules:
  - host: app1.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app1-service
            port:
              number: 80
```

### 3. 配置健康检查

```yaml
metadata:
  annotations:
    nginx.ingress.kubernetes.io/health-check-path: "/health"
    nginx.ingress.kubernetes.io/health-check-interval: "10s"
```

### 4. 设置资源限制

```yaml
# Ingress Controller的资源限制
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-ingress-controller
spec:
  template:
    spec:
      containers:
      - name: nginx-ingress-controller
        resources:
          requests:
            cpu: 100m
            memory: 90Mi
          limits:
            cpu: 1000m
            memory: 512Mi
```

### 5. 监控和日志

```yaml
metadata:
  annotations:
    # 启用访问日志
    nginx.ingress.kubernetes.io/enable-access-log: "true"
    
    # 自定义日志格式
    nginx.ingress.kubernetes.io/configuration-snippet: |
      access_log /var/log/nginx/access.log main;
```

---

## 常见问题排查

### 1. Ingress无法访问

```bash
# 检查Ingress状态
kubectl get ingress
kubectl describe ingress <ingress-name>

# 检查Ingress Controller
kubectl get pods -n ingress-nginx
kubectl logs -n ingress-nginx <controller-pod>

# 检查Service
kubectl get svc
kubectl get endpoints <service-name>

# 测试DNS解析
nslookup example.com
```

### 2. 502 Bad Gateway

**常见原因**：
- 后端Service不存在
- 后端Pod未就绪
- 端口配置错误

**排查步骤**：
```bash
# 检查Service和Endpoints
kubectl get svc <service-name>
kubectl get endpoints <service-name>

# 检查Pod状态
kubectl get pods -l app=<label>
kubectl describe pod <pod-name>

# 直接测试Service
kubectl run test --image=busybox --rm -it -- wget -O- http://<service-name>
```

### 3. TLS证书问题

```bash
# 检查Secret
kubectl get secret <tls-secret>
kubectl describe secret <tls-secret>

# 验证证书
kubectl get secret <tls-secret> -o jsonpath='{.data.tls\.crt}' | base64 -d | openssl x509 -text -noout

# 测试HTTPS
curl -v https://example.com/
openssl s_client -connect example.com:443 -servername example.com
```

### 4. 路径路由不生效

**检查路径顺序**：路径匹配是按顺序的，更具体的路径应该放在前面。

```yaml
# ✅ 正确：具体路径在前
paths:
- path: /api/v2
  pathType: Prefix
  backend: ...
- path: /api
  pathType: Prefix
  backend: ...
- path: /
  pathType: Prefix
  backend: ...

# ❌ 错误：通用路径在前会拦截所有请求
paths:
- path: /
  pathType: Prefix
  backend: ...
- path: /api
  pathType: Prefix
  backend: ...  # 永远不会匹配到
```

---

## 性能优化

### 1. 启用连接复用

```yaml
metadata:
  annotations:
    nginx.ingress.kubernetes.io/upstream-keepalive-connections: "100"
    nginx.ingress.kubernetes.io/upstream-keepalive-timeout: "60"
```

### 2. 启用压缩

```yaml
metadata:
  annotations:
    nginx.ingress.kubernetes.io/enable-gzip: "true"
    nginx.ingress.kubernetes.io/gzip-types: "text/plain text/css application/json application/javascript"
```

### 3. 配置缓存

```yaml
metadata:
  annotations:
    nginx.ingress.kubernetes.io/configuration-snippet: |
      location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
        expires 7d;
        add_header Cache-Control "public, immutable";
      }
```

### 4. 调整缓冲区大小

```yaml
metadata:
  annotations:
    nginx.ingress.kubernetes.io/proxy-buffer-size: "8k"
    nginx.ingress.kubernetes.io/proxy-buffers-number: "4"
```

---

## 总结

Kubernetes Ingress是管理HTTP/HTTPS流量的强大工具：

✅ **统一入口**：一个LoadBalancer管理多个服务，降低成本  
✅ **智能路由**：基于域名、路径、Header等灵活路由  
✅ **TLS管理**：集中管理SSL证书，支持自动续期  
✅ **高级功能**：重写、重定向、认证、限流等丰富特性  

掌握Ingress是构建生产级Kubernetes应用的必备技能，结合Ingress Controller可以实现企业级的流量管理。

---

## 下一步

- 学习**Ingress Controller**的部署和配置
- 了解不同Ingress Controller的特性对比
- 探索Service Mesh（如Istio）提供的更高级流量管理

---

## 参考资料

- [Kubernetes官方文档 - Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
- [Nginx Ingress Controller文档](https://kubernetes.github.io/ingress-nginx/)
- [cert-manager文档](https://cert-manager.io/docs/)
