# Alephant 一键部署

```bash
cd alephant-docker/
bash start.sh
```

自动完成：
1. 生成随机密码和密钥
2. 填充所有环境变量文件
3. 交互式收集 License 信息（邮箱 + license.jwt）
4. 拉取镜像并启动全部服务

## 前置依赖

| 依赖 | 版本要求 | 说明 |
|---|---|---|
| **Docker** | ≥ 24.x | 容器运行时，需包含 **Compose plugin**（`docker compose` 命令） |
| **openssl** | 任意版本 | 用于生成随机密码和密钥 |
| **curl** 或 **wget** | 任意版本 | 用于从 S3 下载业务镜像 |
| **bash** | ≥ 4.x | 运行部署脚本（macOS 需 `brew install bash` 升级） |

### 系统要求

- **操作系统**：Linux（推荐 Ubuntu 22.04+ / Debian 12+）或 macOS
- **CPU**：≥ 4 核
- **内存**：≥ 12 GB（12 个服务合计）
- **磁盘**：≥ 50 GB 可用空间（含业务镜像 ~2 GB + 各中间件数据卷）
- **网络**：需能够访问以下地址：
  - `https://image-exports.alephant.io/alephant` — 下载业务镜像
  - Docker Hub（`docker.io`）— 拉取中间件镜像

### 安装检查

```bash
# 检查 Docker
docker info && docker compose version

# 检查 openssl
openssl version

# 检查下载工具
curl --version || wget --version
```

## License 激活

Alephant 私有化部署需要有效的 License 文件进行授权验证。

### 首次激活（使用 start.sh）

`bash start.sh` 会**自动提示**输入 License 信息，无需手动操作：

```bash
bash start.sh
```

脚本执行过程中会依次提示：

```
═══════════════════════════════════════════
  License 激活
═══════════════════════════════════════════

  请输入工作空间拥有者邮箱 (多个用逗号分隔): admin@example.com

  请将从 Alephant 团队获取的 JWT 内容粘贴到下方，
  粘贴完成后按 Ctrl+D (EOF) 结束:
  <粘贴 license.jwt 内容>
```

脚本自动完成：
1. 将邮箱写入 `.env` 文件
2. 将 JWT 内容写入 `license/license.jwt`

### 手动激活

如果希望跳过交互式提示，也可以提前准备：

```bash
# 1. 准备 license 文件
mkdir -p license
cat > license/license.jwt << 'EOF'
<从 Alephant 团队获取的 JWT 内容>
EOF

# 2. 设置邮箱（写入 .env 供 docker compose 读取）
echo 'PRIVATE_WORKSPACE_OWNER_EMAILS=admin@example.com' >> .env

# 3. 运行脚本（将跳过 License 交互步骤）
bash start.sh
```

### 更新 License

如需续期或更换 License：

```bash
# 重新运行脚本（会提示重新输入）
bash start.sh

# 或手动覆盖后重启
cat > license/license.jwt << 'EOF'
<新的 JWT 内容>
EOF
docker compose restart saas-service
```

## 服务

| 服务 | 说明 | 端口 |
|---|---|---|
| **saas-app** | SaaS 前端 | **80** |
| **saas-service** | SaaS 后端 API | 8081 |
| **policy-service** | 策略后端 | 8090 |
| **ai-gateway** | AI 网关 | 8080 |
| **logs-collector** | 日志收集 | 8585 |
| **postgres** | 数据库 | 5432 |
| **clickhouse** | OLAP 分析 | 8123 / 9000 |
| **valkey** | 缓存 | 6379 |
| **pd** | TiKV 集群管理 (Placement Driver) | 2379 |
| **tikv** | 分布式 KV 存储 | 20160 |
| **minio** | S3 兼容对象存储（S3 API/Console） | 9000 / 9001 |
| **qdrant** | 向量数据库 | 6333 / 6334 |

## 可访问地址

部署后通过 Nginx 反向代理（`config/nginx/nginx.conf`）提供以下入口：

| 端口 | server | 路径 | 后端服务 | 说明 |
|---|---|---|---|---|
| **80** | `_` (默认) | `/api/v1/` → | saas-service:8080 | SaaS 后端 API |
| | | `/v1/policy` → | policy-service:8090 | 策略服务 |
| | | `/` → | SPA (root /app) | SaaS 前端页面 |
| **81** | `_` (默认) | `/v1/` → | ai-gateway:8080 | AI 网关 API |
| | | 其余路径 | 404 | |
| **82** | `_` (默认) | `/v1/` → | logs-collector:8585 | 日志收集与分析 API |
| | | 其余路径 | 404 | |

各后端服务也直接暴露在 `127.0.0.1` 上（仅本机可访问），便于调试：

```bash
curl http://127.0.0.1:80/api/v1/...     # SaaS API (通过 Nginx)
curl http://127.0.0.1:81/v1/...         # AI Gateway (通过 Nginx)
curl http://127.0.0.1:82/v1/...         # Logs Collector (通过 Nginx)
```

## 域名接入

如需通过域名访问（如 `your-custom-domain.com` → `http://localhost`），有两种方式：

### 方式一：上游反向代理（推荐）

在外部部署 Nginx / Cloudflare / haproxy，负责 TLS 终止和域名路由，将请求转发到本机的对应端口：

```nginx
# 示例：上游 Nginx
server {
    listen 443 ssl;
    server_name your-custom-domain.com;
    ssl_certificate     /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    location / {
        proxy_pass http://<本机IP>:80;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
}
server {
    listen 443 ssl;
    server_name ai.your-custom-domain.com;
    ...
    location / {
        proxy_pass http://<本机IP>:81;   # AI Gateway
    }
}
server {
    listen 443 ssl;
    server_name analytics-your-custom-domain.com;
    ...
    location / {
        proxy_pass http://<本机IP>:82;   # Analytics
    }
}
```

### 方式二：修改 nginx.conf 添加 server_name

在 `config/nginx/nginx.conf` 中为每个端口对应的 server 块添加域名：

```nginx
server {
    listen 80;
    server_name your-custom-domain.com;          # ← Web 应用 (SPA + API)
    ...
}
server {
    listen 81;
    server_name ai.your-custom-domain.com;       # ← AI Gateway
    ...
}
server {
    listen 82;
    server_name analytics.your-custom-domain.com; # ← Analytics
    ...
}
```

修改后重启生效：

```bash
docker compose restart saas-app
```

> **注意**：此方式需自行处理 TLS（SSL 证书）。如需 HTTPS，建议配合 Cloudflare（边缘证书 + DNS 代理）或使用方式一在上游反向代理中终止 TLS。

## 常用命令

```bash
docker compose ps                    # 查看状态
docker compose logs -f <service>     # 查看日志
docker compose restart <service>     # 重启服务
docker compose down                  # 停止
bash start.sh                        # 重新部署
```

## .env 文件说明

脚本生成的密码记录在终端输出中，也可直接查看文件：

```bash
cat infra.env          # 基础设施密码
cat saas-service.env   # SaaS 后端配置
```

> `PRIVATE_WORKSPACE_OWNER_EMAILS` 和 `license.jwt` 通过 `bash start.sh` 交互式输入，无需手动编辑。
