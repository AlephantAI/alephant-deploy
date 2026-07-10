#!/usr/bin/env bash
# =============================================================================
# start.sh — Alephant 一键部署脚本
# 使用方式:
#   cd alephant-docker/ && bash start.sh
# =============================================================================
set -euo pipefail

S3_BASE_URL="https://image-exports.alephant.io/alephant"
COMPOSE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOWNLOAD_DIR="${COMPOSE_DIR}/.downloaded-images"

# 颜色
GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
info()  { echo -e "${BLUE}[INFO]${NC}  $*"; }
ok()    { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
err()   { echo -e "${RED}[ERROR]${NC} $*"; }

# ─── 密码/密钥生成 ──────────────────────────────────────────────────────────
gen_pswd() { openssl rand -base64 32 | tr -d '/+=' | cut -c1-24; }
gen_jwt()  { openssl rand -base64 48 | tr -d '/+='; }
gen_key()  { openssl rand -hex 32; }
gen_token(){ openssl rand -base64 32; }
gen_stripe(){ echo "sk_test_$(openssl rand -hex 32)"; }

# ─── 前置检查 ────────────────────────────────────────────────────────────────
check_prereqs() {
  local FAIL=0
  command -v docker &>/dev/null || { err "Docker 未安装"; FAIL=1; }
  docker info &>/dev/null      || { err "Docker daemon 未运行"; FAIL=1; }
  command -v openssl &>/dev/null || { err "需要 openssl"; FAIL=1; }
  command -v curl &>/dev/null || command -v wget &>/dev/null || { err "需要 curl 或 wget"; FAIL=1; }
  [ -f "${COMPOSE_DIR}/docker-compose.yml" ] || { err "缺少 docker-compose.yml"; FAIL=1; }
  [ "$FAIL" = "1" ] && exit 1
  ok "前置检查通过"
}

# ─── 生成所有环境变量文件 ──────────────────────────────────────────────────
generate_config() {
  info "生成随机密码和密钥..."

  # ── infra 密码 ──
  POSTGRES_PASSWORD=$(gen_pswd)
  CLICKHOUSE_PASSWORD=$(gen_pswd)
  VALKEY_PASSWORD=$(gen_pswd)
  QDRANT_API_KEY=$(gen_token)

  # ── 共享密钥 ──
  JWT_SECRET=$(gen_jwt)
  MASTER_KEY=$(gen_jwt)
  ENCRYPTION_KEY=$(gen_key)
  MASTER_KEY_ENCRYPTION_KEY=$(gen_key)
  NOTIFICATION_ENCRYPTION_KEY=$(gen_key)
  LOGS_COLLECTOR_X402_HTTP_AUTH_TOKEN=$(gen_token)
  PAYMENT_SERVICE_KEY=$(gen_token)
  OUTBOUND_PAYMENT_HMAC_SECRET=$(gen_jwt)
  REVENUE_WITHDRAW_HMAC_SECRET=$(gen_jwt)
  S3_ACCESS_KEY=$(gen_token)
  S3_SECRET_KEY=$(gen_jwt)
  MAIL_PASSWORD=""
  STRIPE_SECRET_KEY=""
  OAUTH_GITHUB_CLIENT_SECRET=""
  OAUTH_GOOGLE_CLIENT_SECRET=""
  PAYMENT_LEDGER_INTERNAL_TOKEN=""
  X402_SELF_HOSTED_AUTH_TOKEN=""
  PAYMENT_INTERNAL_AUTH_TOKEN=""

  # ── 1. infra.env ──
  info "  生成 infra.env"
  cat > "${COMPOSE_DIR}/infra.env" << EOF
POSTGRES_DB=alephant
POSTGRES_USER=alephant
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
CLICKHOUSE_DB=alephant
CLICKHOUSE_USER=default
CLICKHOUSE_PASSWORD=${CLICKHOUSE_PASSWORD}
VALKEY_PASSWORD=${VALKEY_PASSWORD}
QDRANT_API_KEY=${QDRANT_API_KEY}
EOF

  # ── 2. .env (compose 变量插值用) ──
  info "  生成 .env"
  cat > "${COMPOSE_DIR}/.env" << EOF
POSTGRES_USER=alephant
POSTGRES_DB=alephant
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
VALKEY_PASSWORD=${VALKEY_PASSWORD}
QDRANT_API_KEY=${QDRANT_API_KEY}
EOF

  # ── 3. saas-service.env ──
  info "  生成 saas-service.env"
  cat > "${COMPOSE_DIR}/saas-service.env" << EOF
# ===========================================================================
# saas-service.env — 由 start.sh 自动生成
# ===========================================================================
POSTGRES_DATABASE_URL=postgresql://alephant:${POSTGRES_PASSWORD}@postgres:5432/alephant
REDIS_URL=redis://default:${VALKEY_PASSWORD}@valkey:6379/0
APP_BASE_URL=http://localhost
MASTER_KEY=${MASTER_KEY}
MASTER_KEY_ENCRYPTION_KEY=${MASTER_KEY_ENCRYPTION_KEY}
JWT_SECRET=${JWT_SECRET}

# OAuth (placeholder)
OAUTH_GITHUB_CLIENT_ID=
OAUTH_GITHUB_CLIENT_SECRET=${OAUTH_GITHUB_CLIENT_SECRET}
OAUTH_GITHUB_ALLOWED_REDIRECT_URIS=http://localhost:8081/auth/github/callback
OAUTH_GOOGLE_CLIENT_ID=
OAUTH_GOOGLE_CLIENT_SECRET=${OAUTH_GOOGLE_CLIENT_SECRET}

# Mail (placeholder)
MAIL_HOST=
MAIL_PORT=587
MAIL_USERNAME=
MAIL_PASSWORD=${MAIL_PASSWORD}
MAIL_FROM_ADDRESS=noreply@example.com
MAIL_FROM_NAME=Alephant

# HMAC
OUTBOUND_PAYMENT_HMAC_SECRET=${OUTBOUND_PAYMENT_HMAC_SECRET}
REVENUE_WITHDRAW_HMAC_SECRET=${REVENUE_WITHDRAW_HMAC_SECRET}

# Logs
COLLECTOR_ANALYTICS_BASE_URL=http://logs-collector:8585
LOGS_COLLECTOR_X402_HTTP_AUTH_TOKEN=${LOGS_COLLECTOR_X402_HTTP_AUTH_TOKEN}
EOF

  # ── 4. policy-service.env ──
  info "  生成 policy-service.env"
  cat > "${COMPOSE_DIR}/policy-service.env" << EOF
POSTGRES_DATABASE_URL=postgresql://alephant:${POSTGRES_PASSWORD}@postgres:5432/alephant
REDIS_URL=redis://default:${VALKEY_PASSWORD}@valkey:6379/0
MAIL_HOST=
MAIL_PORT=587
MAIL_USERNAME=
MAIL_PASSWORD=${MAIL_PASSWORD}
MAIL_FROM_ADDRESS=noreply@example.com
MAIL_FROM_NAME=Alephant
NOTIFICATION_ENCRYPTION_KEY=${NOTIFICATION_ENCRYPTION_KEY}
EOF

  # ── 5. ai-gateway.env ──
  info "  生成 ai-gateway.env"
  cat > "${COMPOSE_DIR}/ai-gateway.env" << EOF
POSTGRES_DATABASE_URL=postgresql://alephant:${POSTGRES_PASSWORD}@postgres:5432/alephant
REDIS_URL=redis://default:${VALKEY_PASSWORD}@valkey:6379/0
CLICKHOUSE_CREDS=default:${CLICKHOUSE_PASSWORD}
AI_GATEWAY__SEMANTIC_CACHE__QDRANT__URL=http://qdrant:6333
AI_GATEWAY__SEMANTIC_CACHE__QDRANT__API_KEY=${QDRANT_API_KEY}
AI_GATEWAY__CLOUDFLARE_KV__ACCOUNT_ID=
AI_GATEWAY__CLOUDFLARE_KV__API_BASE=
AI_GATEWAY__CLOUDFLARE_KV__API_TOKEN=
AI_GATEWAY__CLOUDFLARE_KV__NAMESPACE_ID=
AI_GATEWAY__POLICY__GRPC_ENDPOINT=policy-service:9090
AI_GATEWAY__X402__PAYMENT_GRPC_ENDPOINT=
AI_GATEWAY__X402__UPSTREAM_AUTH_KEY=
AI_GATEWAY__ALEPHANT__LOG_COLLECTOR_URL=http://logs-collector:8585
S3_ENDPOINT=
S3_REGION=
S3_BUCKET_NAME=
S3_ACCESS_KEY=${S3_ACCESS_KEY}
S3_SECRET_KEY=${S3_SECRET_KEY}
JWT_SECRET=${JWT_SECRET}
ENCRYPTION_KEY=${ENCRYPTION_KEY}
MASTER_KEY_ENCRYPTION_KEY=${MASTER_KEY_ENCRYPTION_KEY}
PAYMENT_SERVICE_KEY=${PAYMENT_SERVICE_KEY}
LOGS_COLLECTOR_X402_HTTP_AUTH_TOKEN=${LOGS_COLLECTOR_X402_HTTP_AUTH_TOKEN}
ANALYTICS_RMT_MAX_RANGE_HOURS=72
EOF

  # ── 6. logs-collector.env ──
  info "  生成 logs-collector.env"
  cat > "${COMPOSE_DIR}/logs-collector.env" << EOF
POSTGRES_DATABASE_URL=postgresql://alephant:${POSTGRES_PASSWORD}@postgres:5432/alephant
REDIS_URL=redis://default:${VALKEY_PASSWORD}@valkey:6379/0
CLICKHOUSE_CREDS=default:${CLICKHOUSE_PASSWORD}
S3_ENDPOINT=
S3_REGION=
S3_BUCKET_NAME=
S3_ACCESS_KEY=${S3_ACCESS_KEY}
S3_SECRET_KEY=${S3_SECRET_KEY}
JWT_SECRET=${JWT_SECRET}
ENCRYPTION_KEY=${ENCRYPTION_KEY}
LOGS_COLLECTOR_X402_HTTP_AUTH_TOKEN=${LOGS_COLLECTOR_X402_HTTP_AUTH_TOKEN}
ANALYTICS_RMT_MAX_RANGE_HOURS=72
EOF

  ok "环境变量文件已生成"
  info "  PostgreSQL 密码: ${POSTGRES_PASSWORD}"
  info "  Valkey 密码:     ${VALKEY_PASSWORD}"
  info "  JWT 密钥:        ${JWT_SECRET}"
}

# ─── 下载业务镜像 ──────────────────────────────────────────────────────────
download_images() {
  mkdir -p "${DOWNLOAD_DIR}"
  local TOTAL=0
  for entry in \
    "app/alephantai-app-20260613081608.tar" \
    "saas-service/alephantai-saas-service-20260629121515.tar" \
    "policy-service/alephantai-policy-service-20260613220845.tar" \
    "ai-gateway/alephantai-ai-gateway-20260629120913.tar" \
    "logs-collector/alephantai-logs-collector-20260618231935.tar"; do
    
    local module="${entry%%/*}"
    local file="${entry##*/}"
    local local_path="${DOWNLOAD_DIR}/${file}"
    
    [ -f "$local_path" ] && [ -s "$local_path" ] && { ok "${file} 已存在"; TOTAL=$((TOTAL+1)); continue; }
    
    echo -n "  下载 ${file}... "
    if command -v curl &>/dev/null; then
      curl -sL -o "$local_path" "${S3_BASE_URL}/${entry}" || true
    else
      wget -q -O "$local_path" "${S3_BASE_URL}/${entry}" || true
    fi
    if [ -f "$local_path" ] && [ -s "$local_path" ]; then
      echo -e "${GREEN}✓${NC}"
      TOTAL=$((TOTAL+1))
    else
      echo -e "${RED}✗${NC}"
    fi
  done
  ok "下载完成: ${TOTAL}/5"
}

# ─── 加载业务镜像 ──────────────────────────────────────────────────────────
load_images() {
  local LOADED=0
  for file in "${DOWNLOAD_DIR}"/*.tar; do
    [ -f "$file" ] || continue
    local name
    name=$(basename "$file" .tar)
    echo -n "  加载 ${name}... "
    local output
    output=$(docker load -i "$file" 2>&1) && { echo -e "${GREEN}✓${NC}"; LOADED=$((LOADED+1)); } || { echo -e "${YELLOW}✗${NC} $output"; }
  done
  ok "加载完成: ${LOADED} 个镜像"
}

# ─── 启动服务 ──────────────────────────────────────────────────────────────
start_services() {
  # 确保所有业务镜像存在（用 alpine 占位，防止 compose 尝试从私有 registry 拉取）
  for img_spec in \
    "registry.digitalocean.com/wechart/alephantai-app:20260613081608" \
    "registry.digitalocean.com/wechart/alephantai-saas-service:20260629121515" \
    "registry.digitalocean.com/wechart/alephantai-policy-service:20260613220845" \
    "registry.digitalocean.com/wechart/alephantai-ai-gateway:20260629120913" \
    "registry.digitalocean.com/wechart/alephantai-logs-collector:20260618231935"; do
    docker image inspect "$img_spec" &>/dev/null || docker tag alpine:latest "$img_spec" 2>/dev/null || true
  done

  # 拉取中间件镜像
  info "拉取中间件镜像..."
  for img in \
    postgres:17 \
    clickhouse/clickhouse-server:24.3 \
    valkey/valkey:9.0.2 \
    qdrant/qdrant:v1.17.1; do
    if ! docker image inspect "$img" &>/dev/null; then
      echo -n "  拉取 ${img}... "
      docker pull "$img" 2>/dev/null && echo -e "${GREEN}✓${NC}" || echo -e "${YELLOW}跳过${NC}"
    fi
  done

  info "启动所有服务..."
  cd "${COMPOSE_DIR}"
  docker compose up -d --pull never 2>&1
  ok "服务已启动!"
  echo ""
  echo "  查看状态: docker compose ps"
  echo "  查看日志: docker compose logs -f"
}

# ─── 主流程 ──────────────────────────────────────────────────────────────
main() {
  echo ""
  echo "═══════════════════════════════════════════"
  echo "  Alephant 一键部署"
  echo "═══════════════════════════════════════════"
  echo ""

  check_prereqs
  generate_config
  download_images
  load_images
  start_services

  echo ""
  echo "═══════════════════════════════════════════"
  echo "  ✅ 部署完成"
  echo "═══════════════════════════════════════════"
}

main "$@"
