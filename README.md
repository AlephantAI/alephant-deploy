# Alephant Docker Compose 部署

## 服务架构

```
┌──────────┐   ┌──────────┐   ┌────────────┐  ┌──────────────┐
│  saas-app │   │ postgres │   │  clickhouse │  │   valkey     │
│ (前端 SPA)│   │ (PG 17)  │   │ (OLAP)      │  │ (Redis 9)    │
│  :80      │   │  :5432   │   │  :8123/9000 │  │  :6379       │
└────┬──────┘   └────┬─────┘   └──────┬──────┘  └──────┬───────┘
     │              │                │                 │
     ▼              ▼                ▼                 ▼
┌──────────┐   ┌──────────┐   ┌────────────┐  ┌──────────────┐
│saas-     │   │policy-   │   │ai-gateway  │  │logs-collector│
│service   │   │service   │   │            │  │              │
│ :8081    │   │ :8090    │   │ :8080      │  │ :8585        │
└──────────┘   └──────────┘   └────────────┘  └──────────────┘

┌──────────┐   ┌──────────────────┐  ┌───────────────────┐
│  qdrant  │   │postgres-exporter │  │ valkey-exporter   │
│ (向量库) │   │ :9187            │  │ :9121             │
└──────────┘   └──────────────────┘  └───────────────────┘
```

## 文件结构

```
alephant-docker/
├── docker-compose.yml          # 服务编排文件
├── download-and-run.sh         # 一键下载 + 启动脚本
├── generate-envs.sh            # 环境变量生成脚本
│
├── infra.env.example           # 基础设施密码模板（复制为 infra.env）
├── shared.env                  # 公共环境变量
├── saas-service.env.tpl        # SaaS 后端环境变量模板
├── policy-service.env.tpl      # 策略后端环境变量模板
├── ai-gateway.env.tpl          # AI 网关环境变量模板
├── logs-collector.env.tpl      # 日志收集环境变量模板
│
├── config/
│   ├── nginx/nginx.conf
│   ├── clickhouse/config.d/
│   ├── clickhouse/users.d/
│   └── qdrant/production.yaml
└── README.md
```

## 前置条件

- Docker Engine 24+ 和 Docker Compose v2+
- `curl` 或 `wget`（用于下载镜像）

## 快速开始

### 第一步：配置环境变量

```bash
# 1. 基础设施密码
cp infra.env.example infra.env
vim infra.env   # 填入 PostgreSQL / ClickHouse / Valkey / Qdrant 密码
```

### 第二步：生成服务环境变量

```bash
# 2. 编辑公共变量
vim shared.env     # 填入数据库连接串、JWT 密钥、S3、邮件等公共配置

# 3. 编辑各服务独有变量
vim saas-service.env.tpl
vim policy-service.env.tpl
vim ai-gateway.env.tpl
vim logs-collector.env.tpl

# 4. 生成最终的 .env 文件
./generate-envs.sh
```

### 第三步：下载镜像并启动

```bash
#  下载业务镜像 → docker load → 拉取中间件 → docker compose up -d
./download-and-run.sh
```

> 网络较慢时可分步操作：`wget -c` 支持断点续传，重复运行脚本会跳过已下载的文件。

### 第四步：验证

```bash
docker compose ps
curl http://localhost:8080/health   # AI Gateway
curl http://localhost:8081/health   # SaaS 后端
```

## 服务清单

### 基础设施

| 服务 | 镜像 | 端口 |
|---|---|---|
| **postgres** | `postgres:17` | 5432 |
| **clickhouse** | `clickhouse/clickhouse-server:24.3` | 8123 / 9000 |
| **valkey** | `valkey/valkey:9.0.2` | 6379 |
| **qdrant** | `qdrant/qdrant:v1.17.1` | 6333 / 6334 |

### 应用服务

| 服务 | 镜像 | 端口 | 说明 |
|---|---|---|---|
| **saas-app** | `alephantai-app:20260613081608` | **80** | SaaS 前端 |
| **saas-service** | `alephantai-saas-service:20260629121515` | 8081 | SaaS 后端 API |
| **policy-service** | `alephantai-policy-service:20260613220845` | 8090 | 策略后端 |
| **ai-gateway** | `alephantai-ai-gateway:20260629120913` | 8080 | AI 网关 |
| **logs-collector** | `alephantai-logs-collector:20260618231935` | 8585 | 日志收集 |

### 辅助服务

| 服务 | 镜像 | 端口 |
|---|---|---|
| **postgres-exporter** | `prometheuscommunity/postgres-exporter:v0.15.0` | 9187 |
| **valkey-exporter** | `oliver006/redis_exporter:v1.58.0` | 9121 |

## 常用命令

```bash
# 启动 / 停止 / 重启
docker compose up -d
docker compose stop
docker compose restart <service>

# 查看状态
docker compose ps
docker compose logs -f <service>

# 进入容器
docker compose exec <service> bash

# 更新镜像后重建
docker compose pull <service>
docker compose up -d <service>

# 重建（保留数据）
docker compose down
docker compose up -d

# ⚠️ 完全清理（删除数据卷）
docker compose down -v
```

## 环境变量说明

### shared.env（公共变量）

| 变量 | 说明 |
|---|---|
| `POSTGRES_DATABASE_URL` | PostgreSQL 连接串 |
| `REDIS_URL` | Valkey/Redis 连接串 |
| `JWT_SECRET` | JWT 签名密钥 |
| `MAIL_*` | SMTP 邮件配置 |
| `S3_*` | 对象存储配置 |
| `CLICKHOUSE_CREDS` | ClickHouse 凭证 |
| `PAYMENT_SERVICE_KEY` | 支付服务密钥 |
| `STRIPE_*` | Stripe 支付配置 |
| `OAUTH_*` | OAuth 第三方登录 |

### saas-service.env.tpl（SaaS 后端独有）

| 变量 | 说明 |
|---|---|
| `STRIPE_SECRET_KEY` | Stripe 密钥 |
| `OAUTH_GITHUB_*` / `OAUTH_GOOGLE_*` | 第三方登录凭证 |
| `PAYMENT_LEDGER_*` | 支付账本配置 |
| `REDIS_KEY_PREFIX` | Redis 键前缀 |
| `JWT_*` | JWT 有效期配置 |

### policy-service.env.tpl（策略后端独有）

| 变量 | 说明 |
|---|---|
| `POLICY_USE_STREAM` | 策略流开关 |
| `POLICY_STREAM_*` | 策略流参数 |
| `WATCHER_ENABLED` | 监听器开关 |
| `LOG_LEVEL` | 日志级别 |

### ai-gateway.env.tpl（AI 网关独有）

| 变量 | 说明 |
|---|---|
| `AI_GATEWAY__CLOUDFLARE_KV__*` | Cloudflare KV 配置 |
| `AI_GATEWAY__SEMANTIC_CACHE__QDRANT__*` | Qdrant 语义缓存 |
| `AI_GATEWAY__POLICY__GRPC_ENDPOINT` | 策略服务 gRPC 地址 |
| `AI_GATEWAY__X402__*` | X402 支付网关 |

### logs-collector.env.tpl（日志收集独有）

所有变量均在 `shared.env` 中，无需额外配置。

## 故障排查

```bash
# 查看具体服务日志
docker compose logs <service>

# 检查端口是否被占用
lsof -i :80 -i :8080 -i :5432

# 验证 docker-compose.yml 语法
docker compose config

# 下载问题：重复运行脚本会续传
./download-and-run.sh
```
