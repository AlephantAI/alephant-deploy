# Alephant Docker Compose 部署

将 alephant-prod 从 Kubernetes (tradly-aliyun.yaml) 迁移至 Docker Compose 的部署配置。

## 架构

```
┌──────────────────────────────────────────────────────────────────┐
│                         Alephant Stack                           │
│                                                                  │
│  ┌──────────┐   ┌──────────┐   ┌────────────┐  ┌─────────────┐  │
│  │  saas-app │   │ postgres │   │  clickhouse │  │   valkey    │  │
│  │ (nginx    │   │ (PG 17)  │   │ (OLAP)      │  │ (Redis 9)   │  │
│  │  SPA)     │   │  :5432   │   │  :8123/9000 │  │  :6379      │  │
│  └────┬─────┘   └────┬─────┘   └──────┬──────┘  └──────┬──────┘  │
│       │              │                │                 │         │
│       ▼              ▼                ▼                 ▼         │
│  ┌──────────┐   ┌──────────┐   ┌────────────┐  ┌─────────────┐  │
│  │saas-     │   │policy-   │   │ai-gateway  │  │ledge-service│  │
│  │service   │   │service   │   │            │  │             │  │
│  │ :8081    │   │ :8090    │   │ :8080      │  │ :8091       │  │
│  └──────────┘   └──────────┘   └────────────┘  └─────────────┘  │
│                                                                  │
│  ┌──────────────┐  ┌─────────────────┐  ┌────────────────────┐  │
│  │logs-collector│  │postgres-exporter│  │ valkey-exporter    │  │
│  │ :8585        │  │ :9187           │  │ :9121              │  │
│  └──────────────┘  └─────────────────┘  └────────────────────┘  │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐    │
│  │            qdrant (向量数据库, 单节点)                      │    │
│  │            :6333 / :6334                                 │    │
│  └──────────────────────────────────────────────────────────┘    │
└──────────────────────────────────────────────────────────────────┘
```

## 文件结构

```
alephant-docker/
├── docker-compose.yml          # 主编排文件（14 个服务）
├── generate-envs.sh            # ← 环境变量生成脚本
│
│   # ─── 基础设施配置 ───
├── infra.env.example           # PostgreSQL / ClickHouse / Valkey / Qdrant 凭证
├── config/
│   ├── nginx/nginx.conf
│   ├── clickhouse/config.d/    # ClickHouse 服务配置（6 文件）
│   ├── clickhouse/users.d/     # ClickHouse 用户配置（1 文件）
│   └── qdrant/production.yaml  # Qdrant 配置（单节点）
│
│   # ─── 环境变量源文件 ───
│   # shared.env:    跨服务公共变量（33 个，2+ 服务共用）
│   # *.env.tpl:     各服务独有变量（合并到最终 .env 文件）
│   # *.env:         ← 由 generate-envs.sh 自动生成, 已 gitignore
├── shared.env                  # 公共变量：数据库/Redis/JWT/S3/邮件等
├── saas-service.env.tpl        # SaaS 后端独有变量 (52 vars)
├── policy-service.env.tpl      # 策略后端独有变量 (12 vars)
├── ai-gateway.env.tpl          # AI 网关独有变量   (12 vars)
├── ledge-service.env.tpl       # Ledge 服务独有变量 (42 vars)
├── logs-collector.env.tpl      # 日志收集独有变量  (0 vars, 全在 shared)
```

## 环境变量体系

**每个应用从 K8s 集群中来源独立的 Infisical Secret：**

| 服务 | K8s Secret | 变量数 | 主要类别 |
|---|---|---|---|
| **saas-service** | `alephant-saas-service-infisical-secrets` | 76 | JWT, Stripe, OAuth, Mail, Managed Wallets, Payment |
| **policy-service** | `alephant-policy-service-infisical-secrets` | 24 | Policy Stream, Mail, Notification |
| **ai-gateway** | `alephant-ai-gateway-infisical-secrets` | 27 | Cloudflare KV, Qdrant Cache, S3, gRPC 端点 |
| **ledge-service** | `alephant-ledge-service-infisical-secrets` | 56 | X402 支付, Managed Wallets, Coinbase CDP, Payment |
| **logs-collector** | `alephant-logs-collector-infisical-secrets` | 12 | S3, ClickHouse, JWT |
| **共享** | `alephant-shared-infisical-secrets` | 54 | 已包含在各服务 secret 中，无需单独处理 |

所有 K8s Secret 均可通过以下命令导出：
```bash
kubectl --kubeconfig=<kubeconfig> -n alephant-prod get secret <secret-name> -o json \
  | jq -r '.data | to_entries[] | "\(.key)=\(.value | @base64d)"' > <service>.env
```

## 服务清单

### 基础设施

| 服务 | 镜像 | 说明 | 持久卷 |
|---|---|---|---|
| **postgres** | `postgres:17` | 主数据库 | 50Gi |
| **clickhouse** | `clickhouse/clickhouse-server:24.3` | OLAP 分析数据库 | 50Gi |
| **valkey** | `valkey/valkey:9.0.2` | 缓存（Redis 协议兼容） | 50Gi |
| **qdrant** | `qdrant/qdrant:v1.17.1` | 向量数据库（单节点） | 50Gi |

### 应用服务

| 服务 | 镜像（原仓库） | 说明 | 对外端口 | 环境变量文件 |
|---|---|---|---|---|
| **saas-app** | `alephantai-app:20260613081608` | SaaS 前端 (Nginx SPA) | **80** | — |
| **saas-service** | `alephantai-saas-service:20260629121515` | SaaS 后端 API | 8081 | `saas-service.env` |
| **policy-service** | `alephantai-policy-service:20260613220845` | 策略后端 | 8090 | `policy-service.env` |
| **ai-gateway** | `alephantai-ai-gateway:20260629120913` | AI 网关 | 8080 | `ai-gateway.env` |
| **ledge-service** | `alephantai-ledge-service:20260629153650` | Ledge 服务 | 8091 | `ledge-service.env` |
| **logs-collector** | `alephantai-logs-collector:20260618231935` | 日志收集 | 8585 | `logs-collector.env` |

### 监控辅助

| 服务 | 镜像 | 说明 | 端口 |
|---|---|---|---|
| **postgres-exporter** | `prometheuscommunity/postgres-exporter:v0.15.0` | PG 指标 | 9187 |
| **valkey-exporter** | `oliver006/redis_exporter:v1.58.0` | Valkey 指标 | 9121 |

## 快速开始

### 前置条件

- Docker Engine 24+ (推荐 Docker Desktop 或 Docker CE)
- Docker Compose v2+
- 能够访问应用镜像的容器仓库

### 1. 准备基础设施凭证

```bash
cp infra.env.example infra.env
vim infra.env   # 填入 PostgreSQL / ClickHouse / Valkey / Qdrant 密码
```

### 2. 生成环境变量文件

**自动方式（推荐）** — 从 K8s Infisical Secret 导出后拆分：

```bash
# 先确认 K8s 命名空间
NS=alephant-prod
KF=--kubeconfig=<你的kubeconfig路径>

# 导出所有 Secret 到临时目录
mkdir -p /tmp/alephant-secrets
for secret in saas-service policy-service ai-gateway ledge-service logs-collector; do
  kubectl $KF -n $NS get secret alephant-$secret-infisical-secrets -o json \
    | jq -r '.data | to_entries[] | "\(.key)=\(.value | @base64d)"' \
    > /tmp/alephant-secrets/$secret.env
done
```

然后将各服务的数据库/Redis 地址从 K8s 内部 DNS 改为 Docker 服务名，再手动将重复变量提取到 `shared.env`、独有变量保留在 `*.env.tpl`。

**手动方式** — 直接编辑模板文件：

```bash
# 编辑公共变量（33 个跨服务共享变量）
vim shared.env     # 填入 db/redis/JWT/S3/邮件等公共值

# 编辑各服务独有变量
vim saas-service.env.tpl
vim policy-service.env.tpl
vim ai-gateway.env.tpl
vim ledge-service.env.tpl
```

### 3. 生成最终环境变量文件

```bash
./generate-envs.sh
```

此命令将 `shared.env` 与各 `*.env.tpl` 合并，生成最终的 `*.env` 文件供 docker compose 使用。

### 4. 准备镜像

```bash
# 拉取原仓库镜像
docker pull registry.digitalocean.com/wechart/alephantai-app:20260613081608
docker pull registry.digitalocean.com/wechart/alephantai-saas-service:20260629121515
docker pull registry.digitalocean.com/wechart/alephantai-policy-service:20260613220845
docker pull registry.digitalocean.com/wechart/alephantai-ai-gateway:20260629120913
docker pull registry.digitalocean.com/wechart/alephantai-ledge-service:20260629153650
docker pull registry.digitalocean.com/wechart/alephantai-logs-collector:20260618231935

# 打标签并推送到新仓库（可选）
docker tag registry.digitalocean.com/wechart/alephantai-app:20260613081608 your-registry/alephantai-app:latest
docker push your-registry/alephantai-app:latest
# ... 对其他镜像重复操作
```

如需使用新仓库，编辑 `docker-compose.yml` 中的镜像标签，或在 shell 中设置环境变量覆盖：
```bash
export APP_IMAGE=your-registry/alephantai-app:latest
export SAAS_SERVICE_IMAGE=your-registry/alephantai-saas-service:latest
# ...
```

### 5. 启动

```bash
# 启动全部服务
docker compose up -d

# 查看启动状态
docker compose ps

# 跟踪日志
docker compose logs -f

# 查看特定服务日志
docker compose logs -f saas-service ai-gateway
```

### 5. 验证

```bash
# 检查数据库
docker compose exec postgres pg_isready -U alephant
docker compose exec clickhouse clickhouse-client --query "SELECT 1"
docker compose exec valkey valkey-cli ping

# 检查 Qdrant
curl http://localhost:6333/readyz

# 检查应用
curl http://localhost:8080/health   # AI Gateway
curl http://localhost:8081/health   # SaaS 后端
```

## 数据迁移

### PostgreSQL

```bash
# 从 K8s 导出
kubectl --kubeconfig=<kubeconfig> -n alephant-prod exec alephant-prod-postgresql-1 -- \
  pg_dump -U alephant -d alephant --no-owner --no-acl > alephant-dump.sql

# 导入到本地
docker compose exec -T postgres psql -U alephant -d alephant < alephant-dump.sql
```

### Valkey / Redis

```bash
# 从 K8s 导出 RDB
kubectl --kubeconfig=<kubeconfig> -n alephant-prod exec alephant-prod-valkey-0 -- \
  valkey-cli -a <password> --rdb /tmp/dump.rdb
kubectl cp alephant-prod/alephant-prod-valkey-0:/tmp/dump.rdb ./dump.rdb

# 导入到本地
docker compose stop valkey
docker run --rm -v valkey-data:/data -v $(pwd):/backup alpine sh -c "cp /backup/dump.rdb /data/"
docker compose up -d valkey
```

## 环境变量参考

### saas-service.env (76 个键)

| 类别 | 变量 | 说明 |
|---|---|---|
| 数据库 | `POSTGRES_DATABASE_URL` | PostgreSQL 连接串 |
| Redis | `REDIS_URL`, `REDIS_KEY_PREFIX`, `REDIS_LOCK_*` | 缓存连接与锁配置 |
| JWT | `JWT_SECRET`, `JWT_ACCESS_TTL`, `JWT_REFRESH_TTL` | 认证令牌 |
| Stripe | `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `STRIPE_PRICE_*` | 支付配置 |
| OAuth | `OAUTH_GITHUB_*`, `OAUTH_GOOGLE_*` | 第三方登录 |
| 邮件 | `MAIL_*` | SMTP 邮件发送 |
| Payment | `PAYMENT_SERVICE_BASE_URL`, `PAYMENT_LEDGER_*` | 支付账本 |
| Managed Wallets | `MANAGED_WALLETS_*` | 托管钱包 |

### policy-service.env (24 个键)

| 类别 | 变量 | 说明 |
|---|---|---|
| 数据库 | `POSTGRES_DATABASE_URL` | PostgreSQL 连接串 |
| Redis | `REDIS_URL`, `REDIS_DB` | 缓存连接 |
| Policy | `POLICY_CONFIG_STREAM`, `POLICY_STREAM_*` | 策略流配置 |
| Notification | `NOTIFICATION_ENCRYPTION_KEY`, `NOTIFICATION_OUTBOX_*` | 通知加密 |
| 邮件 | `MAIL_*` | SMTP 邮件发送 |

### ai-gateway.env (27 个键)

| 类别 | 变量 | 说明 |
|---|---|---|
| 数据库 | `POSTGRES_DATABASE_URL`, `AI_GATEWAY__DATABASE__URL` | PostgreSQL 连接串 |
| Redis | `REDIS_URL` | 缓存连接 |
| ClickHouse | `CLICKHOUSE_CREDS` | 日志存储 |
| Qdrant | `AI_GATEWAY__SEMANTIC_CACHE__QDRANT__*` | 语义缓存 |
| Cloudflare KV | `AI_GATEWAY__CLOUDFLARE_KV__*` | KV 存储 |
| 内部 gRPC | `AI_GATEWAY__POLICY__GRPC_ENDPOINT`, `AI_GATEWAY__X402__PAYMENT_GRPC_ENDPOINT` | 服务间调用 |
| S3 | `S3_*` | 对象存储 |
| Security | `JWT_SECRET`, `ENCRYPTION_KEY`, `MASTER_KEY_ENCRYPTION_KEY` | 密钥 |

### ledge-service.env (56 个键)

| 类别 | 变量 | 说明 |
|---|---|---|
| 数据库 | `POSTGRES_DATABASE_URL` | PostgreSQL 连接串 |
| Redis | `REDIS_URL` | 缓存连接 |
| X402 | `X402_*` | 支付框架配置 |
| Managed Wallets | `MANAGED_WALLETS_*` | 钱包链上配置 |
| CDP Wallet | `CDP_WALLET_*` | Coinbase 开发者平台 |
| Payment | `PAYMENT_*` | 支付服务配置 |

### logs-collector.env (12 个键)

| 类别 | 变量 | 说明 |
|---|---|---|
| 数据库 | `POSTGRES_DATABASE_URL` | PostgreSQL 连接串 |
| Redis | `REDIS_URL` | 缓存连接 |
| ClickHouse | `CLICKHOUSE_CREDS` | OLAP 存储 |
| S3 | `S3_*` | 对象存储 |
| Security | `JWT_SECRET`, `ENCRYPTION_KEY` | 密钥 |

## 与 K8s 部署的关键差异

| 维度 | K8s (tradly-aliyun) | Docker Compose |
|---|---|---|
| **PostgreSQL** | CloudNativePG 主从自动切换 | 单实例 |
| **Qdrant** | Raft 3 节点集群 | **单节点** (`cluster.enabled: false`) |
| **环境变量** | Infisical Operator → K8s Secret → `envFrom` | 每个服务独立的 `.env` 文件 |
| **服务发现** | K8s DNS `svc.cluster.local` | Docker 服务名（`postgres`, `valkey` 等） |
| **网络隔离** | K8s NetworkPolicy | Docker bridge + `127.0.0.1` 端口绑定 |
| **Secret 管理** | Infisical 自动注入 | 手动维护 env 文件（**建议 gitignore**） |
| **资源限制** | 部分服务 `resources: {}` | 全部已设置合理 limits |
| **备份** | CronJob (PG/CH/Qdrant/Valkey) | 需自行配置 |

## 故障排查

```bash
# 查看具体服务日志
docker compose logs <service>

# 检查端口冲突
lsof -i :80 -i :8080 -i :5432

# 验证 compose 语法
docker compose config

# 重建但保留数据
docker compose down
docker compose up -d

# ⚠️ 清理所有数据
docker compose down -v
```
