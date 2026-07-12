# Alephant K8s 部署方案

## 目录

- [前置依赖](#前置依赖)
- [快速开始](#快速开始)
- [组件说明](#组件说明)
- [基础设施依赖](#基础设施依赖)
- [基础设施部署参考](#基础设施部署参考)
- [Secrets 管理](#secrets-管理)
- [License 激活](#license-激活)
- [Ingress 路由](#ingress-路由)
- [镜像更新](#镜像更新)
- [扩缩容](#扩缩容)
- [监控与日志](#监控与日志)
- [常见问题](#常见问题)

---

## 架构概览

```
                          ┌──────────────────────────┐
                          │    Ingress Controller     │
                          │  (haproxy / nginx / ALB   │
                          │   / traefik / 你的选择)    │
                          └────┬─────┬──────┬────┬───┘
                  ┌────────────┤     │      │    │
                  ▼            ▼     ▼      ▼    ▼
          ┌──────────┐  ┌────────┐ ┌──────┐ ┌──────┐
          │ SPA App   │  │ SaaS   │ │Policy│ │  AI  │
          │(Nginx+    │  │Service │ │Service│ │Gateway│
          │ 前端静态) │  │:8080   │ │:8090 │ │:8080 │
          └──────────┘  └────────┘ └──────┘ └──────┘
                                    ┌──────┐
                                    │Logs  │
                                    │Collect│
                                    │:8585 │
                                    └──────┘

基础设施 (集群外或 Operator 管理):
  ┌────────┐ ┌────────┐ ┌──────┐ ┌────────┐ ┌────────┐ ┌──────────┐
  │Postgres│ │ClickHse│ │Valkey│ │ Qdrant │ │TiKV+PD│ │  MinIO   │
  └────────┘ └────────┘ └──────┘ └────────┘ └────────┘ └──────────┘
```

## 前置依赖

### 集群需求

| 组件 | 说明 | 推荐版本 | 必要性 |
|---|---|---|---|
| **Kubernetes 集群** | 支持 v1.25+ | ≥ v1.25 | **必需** |
| **Helm** | 包管理工具 | ≥ v3.12 | 推荐 |
| **Ingress Controller** | 对外暴露 HTTP 服务 | — | **可选**，可按需选择： |
| ├─ HAProxy Ingress | 生产级，支持 path-rewrite | — | 当前生产环境使用 |
| ├─ Nginx Ingress | 社区主流，功能丰富 | — | 常见替代方案 |
| ├─ AWS ALB / GCP LB | 云厂商负载均衡 | — | 云环境首选 |
| └─ 其他 (traefik / istio) | — | — | 按团队技术栈选择 |
| **cert-manager** | TLS 证书自动管理 | ≥ v1.12 | **可选**（不使用 TLS 或手动管理证书时可跳过） |
| **ArgoCD** | GitOps 部署工具 | ≥ v2.8 | **可选**（Helm CLI 也可直接部署） |

### 基础设施中间件

这些组件**不在本 Chart 中管理**，需提前在集群中部署就绪：

| 中间件 | 部署方式示例 | 备注 |
|---|---|---|
| **PostgreSQL** | [CNPG Operator](https://cloudnative-pg.io/) | 使用内部 `cnpg-cluster` chart |
| **ClickHouse** | [Altinity Operator](https://github.com/Altinity/clickhouse-operator) | 使用内部 `clickhouse-cluster` chart |
| **Valkey / Redis** | 官方 Helm Chart (valkey/valkey) | |
| **Qdrant** | 官方 Helm Chart (qdrant/qdrant) | |
| **TiKV + PD** | TiDB Operator 或手工 StatefulSet | 参见 `../alephantai-tikv.yaml` |
| **MinIO** | Bitnami Helm Chart (bitnami/minio) | |

### 网络连通性

各业务服务通过 **K8s Service DNS** 访问基础设施，例如：

- PostgreSQL: `alephant-postgres-rw.alephant-prod.svc.cluster.local:5432`
- ClickHouse: `ch-clickhouse.alephant-prod.svc.cluster.local:8123`
- Valkey: `alephant-valkey.alephant-prod.svc.cluster.local:6379`
- Qdrant: `alephant-prod-qdrant.alephant-prod.svc.cluster.local:6333`
- PD: `pd.alephant-prod.svc.cluster.local:2379`
- MinIO: `alephant-minio.alephant-prod.svc.cluster.local:9000`

---

## 快速开始

### 1. 准备 Helm Chart

确保 `helm-charts/charts/common` Chart 可用（或通过 Helm 仓库引用）：

```bash

# 从 Helm 仓库
helm repo add weconomy https://helm-charts.weconomy.network
helm upgrade --install alephant-prod weconomy/common \
  --version 0.1.16 \
  --namespace alephant-prod \
  --create-namespace \
  -f values.yaml
```

### 2. 创建 Secrets

业务服务的环境变量通过 K8s Secret 注入。部署前需要创建以下 4 个 Secret：

```bash
# 创建 saasService 环境变量 Secret
kubectl create secret generic alephant-saas-service-secrets \
  --from-literal=DATABASE_URL=postgresql://alephant:xxx@alephant-postgres-rw:5432/alephant \
  --from-literal=REDIS_URL=redis://default:xxx@alephant-valkey:6379/0 \
  --from-literal=JWT_SECRET=xxx \
  --from-literal=MASTER_KEY=xxx \
  --namespace alephant-prod

# 其他服务的 Secret 同理，见下方 Secrets 管理章节
```

> 各 Secret 所需的完整环境变量列表，参考 Docker Compose 的对应 `.env` 文件（`saas-service.env`、`policy-service.env`、`ai-gateway.env`、`logs-collector.env`），或由 Infisical / External Secrets Operator 自动同步。

### 3. （可选）启用 Ingress

编辑 `values.yaml`，将 `ingress.enabled` 设为 `true`，并填入你的 Ingress Controller `className` 和域名配置。

### 4. 验证部署

```bash
kubectl get pods -n alephant-prod
kubectl get svc -n alephant-prod
```

---


## 基础设施依赖

业务服务依赖以下基础设施，其连接信息通过 Secret 注入到各服务的环境变量中：

| 依赖 | 用途 | 被哪些服务使用 |
|---|---|---|
| **PostgreSQL** | 主数据库 (SaaS 业务数据) | saasService |
| **ClickHouse** | 分析数据库 (日志、统计数据) | logsCollector, saasService |
| **Valkey / Redis** | 缓存、会话 | saasService, policyService |
| **Qdrant** | 向量数据库 (AI 检索) | aiGateway |
| **TiKV + PD** | 分布式 KV 存储 (AI 网关持久化) | aiGateway |
| **MinIO** | S3 兼容对象存储 (文件、模型数据) | aiGateway |

这些组件**不在 `common` chart 中管理**，需提前部署。下面是各中间件的部署参考。

---

## 基础设施部署参考

以下基于生产环境的 Helm 命令。各中间件的完整 values 配置保存在 `middlewares/` 目录下，使用 `-f` 引用即可。

### PostgreSQL (CNPG Operator)

使用内部 `cnpg-cluster` chart 部署高可用 PostgreSQL 集群。

```bash
helm repo add weconomy https://helm-charts.weconomy.network

helm upgrade --install alephant-postgres weconomy/cnpg-cluster \
  --version 0.1.16 \
  --namespace alephant-prod \
  --create-namespace \
  -f middlewares/postgres.values.yaml
```

服务地址: `alephant-postgres-rw.alephant-prod.svc.cluster.local:5432`
数据库: `alephant`，用户: `alephant`

配置参考: [`middlewares/postgres.values.yaml`](middlewares/postgres.values.yaml)

---

### ClickHouse (Altinity Operator)

使用内部 `clickhouse-cluster` chart 部署 ClickHouse 集群（含 ClickHouse Keeper 仲裁）。

```bash
helm repo add weconomy https://helm-charts.weconomy.network

helm upgrade --install alephant-clickhouse weconomy/clickhouse-cluster \
  --version 0.1.1 \
  --namespace alephant-prod \
  --create-namespace \
  -f middlewares/clickhouse.values.yaml
```

> **注意**: 首次部署需先安装 [Altinity ClickHouse Operator](https://github.com/Altinity/clickhouse-operator)。
> **部署前请修改**: `middlewares/clickhouse.values.yaml` 中的 `default/password` 和 Pod CIDR。

服务地址:
- HTTP: `ch-clickhouse.alephant-prod.svc.cluster.local:8123`
- 原生 TCP: `ch-clickhouse.alephant-prod.svc.cluster.local:9000`

配置参考: [`middlewares/clickhouse.values.yaml`](middlewares/clickhouse.values.yaml)

---

### Valkey / Redis

使用官方 Valkey Helm Chart 部署（兼容 Redis 协议）。

```bash
helm repo add valkey https://valkey.io/valkey-helm/

helm upgrade --install alephant-valkey valkey/valkey \
  --version 0.9.4 \
  --namespace alephant-prod \
  --create-namespace \
  -f middlewares/valkey.values.yaml
```

服务地址: `alephant-valkey.alephant-prod.svc.cluster.local:6379`

配置参考: [`middlewares/valkey.values.yaml`](middlewares/valkey.values.yaml)

---

### Qdrant (向量数据库)

使用官方 Qdrant Helm Chart 部署 3 节点集群（含内网 API Key 认证）。

```bash
helm repo add qdrant https://qdrant.github.io/qdrant-helm/

helm upgrade --install alephant-prod-qdrant qdrant/qdrant \
  --version 1.17.1 \
  --namespace alephant-prod \
  --create-namespace \
  -f middlewares/qdrant.values.yaml
```

服务地址:
- HTTP: `alephant-prod-qdrant.alephant-prod.svc.cluster.local:6333`
- gRPC: `alephant-prod-qdrant.alephant-prod.svc.cluster.local:6334`

配置参考: [`middlewares/qdrant.values.yaml`](middlewares/qdrant.values.yaml)

---

### MinIO (S3 兼容对象存储)

使用 Bitnami MinIO Chart 部署。如需生产高可用，修改 `mode: distributed` 并调整副本数。

> ⚠️ **注意**: Docker Compose 中使用的是 `pgsty/minio:latest` 自定义镜像。
> 如果业务依赖 `pgsty/minio` 的特性，可以将 values 中的 `mode`/`auth` 替换为直接使用 `pgsty/minio` 镜像（参见 values 文件内的注释）。

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami

helm upgrade --install alephant-minio bitnami/minio \
  --namespace alephant-prod \
  --create-namespace \
  -f middlewares/minio.values.yaml
```

服务地址:
- S3 API: `alephant-minio.alephant-prod.svc.cluster.local:9000`
- Console: `alephant-minio.alephant-prod.svc.cluster.local:9001`

配置参考: [`middlewares/minio.values.yaml`](middlewares/minio.values.yaml)

---

### TiKV + PD (分布式 KV 存储)

TiKV + PD 在 Docker Compose 中直接使用 PingCAP 官方镜像启动。K8s 环境可通过 [TiDB Operator](https://docs.pingcap.com/tidb-in-kubernetes/) 部署 TiKV 集群，或手工创建 StatefulSet。

生产参考 values 参见: `../alephantai-tikv.yaml`

服务地址:
- PD: `pd.alephant-prod.svc.cluster.local:2379`
- TiKV: `tikv.alephant-prod.svc.cluster.local:20160`

---

## Secrets 管理

Secret 命名规范：

| Secret 名称 | 对应服务 |
|---|---|---|
| `alephant-saas-service-secrets` | saasService |
| `alephant-policy-service-secrets` | policyService |
| `alephant-ai-gateway-secrets` | aiGateway |
| `alephant-logs-collector-secrets` | logsCollector |

在 `values.yaml` 中通过 `envFrom` 引用这些 Secret，将所有键值对注入为环境变量：

```yaml
saasService:
  envFrom:
    - secretRef:
        name: alephant-saas-service-secrets
```

---

## License 激活

Alephant 私有化部署需要有效的 License 文件进行授权验证。License 通过 JWT 文件注入到 `saasService`。

### 准备工作

1. 联系 Alephant 团队获取 `license.jwt` 文件
2. 将文件放置到 `alephant-deploy/license/license.jwt`

### K8s 部署

将 License 文件创建为 ConfigMap 并挂载到 Pod：

```bash
# 1. 创建 License ConfigMap
kubectl create configmap alephant-license \
  --from-file=license.jwt=./license/license.jwt \
  -n alephant-prod

# 2. 设置工作空间拥有者邮箱（必填），编辑 values.yaml 或通过 --set 传入
#    PRIVATE_WORKSPACE_OWNER_EMAILS: "admin@example.com"
#    多个邮箱用逗号分隔: "admin@example.com,user2@example.com"
```

`values.yaml` 中 `saasService` 已预置 volume 挂载和环境变量：

```yaml
saasService:
  volumes:
    - name: license
      configMap:
        name: alephant-license
  volumeMounts:
    - name: license
      mountPath: /etc/alephant/license
      readOnly: true
  env:
    ALEPHANT_LICENSE_FILE:
      value: /etc/alephant/license/license.jwt
    PRIVATE_WORKSPACE_OWNER_EMAILS:
      value: "admin@example.com"   # ← 替换为你实际的邮箱
```

### 更新 License

```bash
# 1. 更新 ConfigMap
kubectl create configmap alephant-license \
  --from-file=license.jwt=./license/license.jwt \
  -n alephant-prod -o yaml --dry-run=client | kubectl replace -f -

# 2. 滚动重启 saasService 使新 License 生效
kubectl rollout restart deployment/alephantai-saas-service -n alephant-prod
```

### 验证 License

```bash
# 查看 saasService 日志确认 License 加载状态
kubectl logs -l app=alephantai-saas-service -n alephant-prod --tail=50 | grep -i license

# 或通过 API 验证
kubectl port-forward svc/alephantai-saas-service 8080:8080 -n alephant-prod &
curl http://localhost:8080/api/v1/health
```

---

## Ingress 路由

下面是当前生产环境的 Ingress 路由表，配置了 HAProxy Ingress + cert-manager 自动 TLS。作为参考模板，你可以按自己的 Ingress Controller 调整。

| 域名 | 路由路径 | 后端 Service | 说明 |
|---|---|---|---|
| **alephant.io** | `/api/v1` | saas-service:8080 | SaaS API |
| | `/v1/policy` | policy-service:8080 | 策略服务 |
| | `/` | app:80 (SPA) | 前端页面 |
| **ai.alephant.io** | `/v1` | ai-gateway:8080 | AI 网关 |
| **analytics.alephant.io** | `/v1` | logs-collector:8585 | 日志分析 |
| **api.alephant.io** | `/v1` → `/key_market/` (rewrite) | ai-gateway:8080 | API 市场 (带 path rewrite) |

## 扩缩容

通过 common chart 的 `replicas` 字段调整：

```yaml
saasService:
  replicas: 3   # 从 1 扩到 3
```

重新应用即可生效：

```bash
helm upgrade alephant-prod /path/to/charts/common -f k8s/values.yaml
```

或临时通过 kubectl 调整：

```bash
kubectl scale deployment alephantai-saas-service --replicas=3 -n alephant-prod
```

> **注意**: 如果使用 GitOps（ArgoCD/Flux），`kubectl scale` 的更改会在下一次同步时被覆盖。持久更改应修改 values 文件。

---
