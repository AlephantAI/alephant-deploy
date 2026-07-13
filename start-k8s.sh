#!/usr/bin/env bash
# =============================================================================
# start-k8s.sh — Alephant K8s Secrets + ConfigMap + DB Init 脚本
# =============================================================================
# 自动生成随机密码/密钥，创建 K8s Secret/ConfigMap 资源，初始化数据库。
#
# 用法:
#   cd alephant-docker/ && bash start-k8s.sh
#
# 前置条件:
#   - kubectl 已配置到目标集群
#   - ${NAMESPACE} namespace 已存在
#   - 中间件（postgres / valkey / qdrant / minio / pd / clickhouse）已部署
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NAMESPACE="${NAMESPACE:-alephant-prod}"

# 颜色
GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
info()  { echo -e "${BLUE}[INFO]${NC}  $*"; }
ok()    { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
err()   { echo -e "${RED}[ERROR]${NC} $*"; }

# ─── 密码/密钥生成 ──
gen_pswd() { openssl rand -base64 32 | tr -d '/+=' | cut -c1-24; }
gen_jwt()  { openssl rand -base64 48 | tr -d '/+='; }
gen_key()  { openssl rand -base64 32; }
gen_token(){ openssl rand -base64 32; }

# ─── 跨平台 sed -i ──
sed_i() {
  if [[ "$(uname -s)" == "Darwin" ]]; then
    sed -i '' "$@"
  else
    sed -i "$@"
  fi
}

# ─── 前置检查 ────────────────────────────────────────────────────────────────
check_prereqs() {
  local FAIL=0
  command -v kubectl &>/dev/null || { err "kubectl 未安装"; FAIL=1; }
  command -v openssl &>/dev/null || { err "需要 openssl"; FAIL=1; }
  command -v curl &>/dev/null || command -v wget &>/dev/null || { err "需要 curl 或 wget"; FAIL=1; }
  [ -d "${SCRIPT_DIR}/sql" ] || { err "缺少 sql/ 目录"; FAIL=1; }
  [ -f "${SCRIPT_DIR}/sql/pgsql.sql" ] || { err "缺少 sql/pgsql.sql"; FAIL=1; }
  [ -f "${SCRIPT_DIR}/sql/clickhouse.sql" ] || { err "缺少 sql/clickhouse.sql"; FAIL=1; }
  [ "$FAIL" = "1" ] && exit 1
  ok "前置检查通过"
}

# ─── 生成随机密码和密钥 ──────────────────────────────────────────────────
generate_secrets() {
  info "生成随机密码和密钥..."

  # ── 基础设施密码 ──
  POSTGRES_PASSWORD=$(gen_pswd)
  CLICKHOUSE_PASSWORD=$(gen_pswd)
  VALKEY_PASSWORD=$(gen_pswd)
  QDRANT_API_KEY=$(gen_token)
  MINIO_ROOT_USER="${MINIO_ROOT_USER:-minioadmin}"
  MINIO_ROOT_PASSWORD=$(gen_pswd)

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
  S3_ACCESS_KEY=${MINIO_ROOT_USER}
  S3_SECRET_KEY=${MINIO_ROOT_PASSWORD}

  echo ""
  echo "═══════════════════════════════════════════"
  echo "  生成的密码 (请保存)"
  echo "═══════════════════════════════════════════"
  echo "  PostgreSQL:    ${POSTGRES_PASSWORD}"
  echo "  Valkey:        ${VALKEY_PASSWORD}"
  echo "  JWT Secret:    ${JWT_SECRET}"
  echo "═══"
}

# ─── 从 API 拉取最新镜像标签 ──────────────────────────────────────────────
VALUES_YAML="${SCRIPT_DIR}/k8s/values.yaml"

fetch_latest_tags() {
  info "获取最新镜像标签..."
  local API_URL="https://image-versions.alephant.io/alephant/images/latest"
  local RESPONSE=""

  if command -v curl &>/dev/null; then
    RESPONSE=$(curl -sf --connect-timeout 5 "$API_URL" 2>/dev/null || true)
  elif command -v wget &>/dev/null; then
    RESPONSE=$(wget -qO- --timeout=5 "$API_URL" 2>/dev/null || true)
  fi

  if [ -z "$RESPONSE" ]; then
    warn "无法获取最新镜像标签，将保持 values.yaml 中的现有标签"
    return
  fi

  # API 返回完整镜像 URL: "saas-app": "registry.openmodels.link/alephant/alephant-app:20260713224933"
  APP_IMAGE_VAL=$(echo "$RESPONSE" | grep -o '"saas-app": *"[^"]*"' | cut -d'"' -f4 || true)
  SAAS_SERVICE_IMAGE_VAL=$(echo "$RESPONSE" | grep -o '"saas-service": *"[^"]*"' | cut -d'"' -f4 || true)
  POLICY_SERVICE_IMAGE_VAL=$(echo "$RESPONSE" | grep -o '"policy-service": *"[^"]*"' | cut -d'"' -f4 || true)
  AI_GATEWAY_IMAGE_VAL=$(echo "$RESPONSE" | grep -o '"ai-gateway": *"[^"]*"' | cut -d'"' -f4 || true)
  LOGS_COLLECTOR_IMAGE_VAL=$(echo "$RESPONSE" | grep -o '"logs-collector": *"[^"]*"' | cut -d'"' -f4 || true)

  # 从完整 URL 中切出 tag（冒号后的部分）给 values.yaml 用
  SAAS_APP_TAG="${APP_IMAGE_VAL##*:}"
  SAAS_SERVICE_TAG="${SAAS_SERVICE_IMAGE_VAL##*:}"
  POLICY_SERVICE_TAG="${POLICY_SERVICE_IMAGE_VAL##*:}"
  AI_GATEWAY_TAG="${AI_GATEWAY_IMAGE_VAL##*:}"
  LOGS_COLLECTOR_TAG="${LOGS_COLLECTOR_IMAGE_VAL##*:}"

  ok "镜像已更新: ${APP_IMAGE_VAL:-默认值}"
  [ -n "$SAAS_SERVICE_IMAGE_VAL" ] && ok "          ${SAAS_SERVICE_IMAGE_VAL}"
  [ -n "$POLICY_SERVICE_IMAGE_VAL" ] && ok "          ${POLICY_SERVICE_IMAGE_VAL}"
  [ -n "$AI_GATEWAY_IMAGE_VAL" ] && ok "          ${AI_GATEWAY_IMAGE_VAL}"
  [ -n "$LOGS_COLLECTOR_IMAGE_VAL" ] && ok "          ${LOGS_COLLECTOR_IMAGE_VAL}"
}

# ─── 更新 values.yaml 中的镜像标签 ────────────────────────────────────────
update_values_yaml() {
  [ -f "$VALUES_YAML" ] || { warn "values.yaml 不存在: ${VALUES_YAML}"; return; }

  local updated=0

  # 用 sed 范围匹配: 从每个服务的 repository 行到下一个顶层 key 之间替换 tag
  if [ -n "${SAAS_APP_TAG:-}" ]; then
    sed_i '/repository: alephant-app$/,/^[a-z]/ s/^\(    tag: \).*$/\1"'"${SAAS_APP_TAG}"'"/' "$VALUES_YAML" && updated=1
  fi
  if [ -n "${SAAS_SERVICE_TAG:-}" ]; then
    sed_i '/repository: alephant-saas-service$/,/^[a-z]/ s/^\(    tag: \).*$/\1"'"${SAAS_SERVICE_TAG}"'"/' "$VALUES_YAML" && updated=1
  fi
  if [ -n "${POLICY_SERVICE_TAG:-}" ]; then
    sed_i '/repository: alephant-policy-service$/,/^[a-z]/ s/^\(    tag: \).*$/\1"'"${POLICY_SERVICE_TAG}"'"/' "$VALUES_YAML" && updated=1
  fi
  if [ -n "${AI_GATEWAY_TAG:-}" ]; then
    sed_i '/repository: alephant-ai-gateway$/,/^[a-z]/ s/^\(    tag: \).*$/\1"'"${AI_GATEWAY_TAG}"'"/' "$VALUES_YAML" && updated=1
  fi
  if [ -n "${LOGS_COLLECTOR_TAG:-}" ]; then
    sed_i '/repository: alephant-logs-collector$/,/^[a-z]/ s/^\(    tag: \).*$/\1"'"${LOGS_COLLECTOR_TAG}"'"/' "$VALUES_YAML" && updated=1
  fi

  if [ "$updated" = "1" ]; then
    ok "values.yaml 镜像标签已更新"
  fi
}

# ─── License 激活信息收集 ────────────────────────────────────────────────
collect_license() {
  echo ""
  echo "═══════════════════════════════════════════"
  echo "  License 激活"
  echo "═══════════════════════════════════════════"
  echo ""

  # ── 1. 工作空间拥有者邮箱 ──
  while [ -z "${PRIVATE_WORKSPACE_OWNER_EMAILS:-}" ]; do
    read -r -p "  请输入工作空间拥有者邮箱 (多个用逗号分隔): " PRIVATE_WORKSPACE_OWNER_EMAILS
    [ -z "${PRIVATE_WORKSPACE_OWNER_EMAILS}" ] && warn "邮箱不能为空，请重新输入"
  done

  # ── 2. license.jwt ──
  local LICENSE_DIR="${SCRIPT_DIR}/license"
  if [ ! -d "${LICENSE_DIR}" ]; then
    mkdir -p "${LICENSE_DIR}"
  fi

  if [ -f "${LICENSE_DIR}/license.jwt" ] && [ -s "${LICENSE_DIR}/license.jwt" ]; then
    local OVERWRITE
    read -r -p "  license/license.jwt 已存在，是否覆盖? (y/N): " OVERWRITE
    if [[ ! "${OVERWRITE}" =~ ^[Yy]$ ]]; then
      ok "保留已有 license.jwt"
    else
      write_license_file "${LICENSE_DIR}"
    fi
  else
    write_license_file "${LICENSE_DIR}"
  fi

  echo ""
  ok "License 配置完成"
}

write_license_file() {
  local dir="$1"
  echo ""
  echo "  请将从 Alephant 团队获取的 JWT 内容粘贴到下方，"
  echo "  粘贴完成后按 Ctrl+D (EOF) 结束:"
  echo ""
  local content
  content=$(cat) || true
  if [ -n "${content}" ]; then
    echo "${content}" > "${dir}/license.jwt"
    ok "license.jwt 已写入 (${#content} 字符)"
  else
    warn "内容为空，跳过 license.jwt 写入"
  fi
}

# ─── 创建 Secret 资源 ──────────────────────────────────────────────────────
create_secret() {
  local name="$1"; shift
  kubectl create secret generic "${name}" \
    --namespace "${NAMESPACE}" \
    "$@" \
    --dry-run=client -o yaml | kubectl apply -f -
}

create_all_secrets() {
  local PG_HOST="${PG_HOST:-alephant-postgres-rw}"
  local VALKEY_HOST="${VALKEY_HOST:-alephant-valkey}"

  info "创建 K8s Secret..."

  # 1. saas-service-secrets
  create_secret alephant-saas-service-secrets \
    --from-literal=POSTGRES_DATABASE_URL="postgresql://alephant:${POSTGRES_PASSWORD}@${PG_HOST}:5432/alephant" \
    --from-literal=REDIS_URL="redis://default:${VALKEY_PASSWORD}@${VALKEY_HOST}:6379/0" \
    --from-literal=APP_BASE_URL="http://localhost" \
    --from-literal=MASTER_KEY="${MASTER_KEY}" \
    --from-literal=MASTER_KEY_ENCRYPTION_KEY="${MASTER_KEY_ENCRYPTION_KEY}" \
    --from-literal=JWT_SECRET="${JWT_SECRET}" \
    --from-literal=ENABLE_SWAGGER_UI="true" \
    --from-literal=JWT_ACCESS_TTL="900" \
    --from-literal=JWT_REFRESH_TTL="604800" \
    --from-literal=CSRF_TOKEN_TTL="86400" \
    --from-literal=REDIS_KEY_PREFIX="alephant:" \
    --from-literal=REDIS_LOCK_DEFAULT_TTL_SECONDS="30" \
    --from-literal=REDIS_LOCK_RENEW_INTERVAL_SECONDS="10" \
    --from-literal=REDIS_STRONG_COORDINATION="true" \
    --from-literal=IDEMPOTENCY_TTL_SECONDS="86400" \
    --from-literal=LAST_USED_DEBOUNCE_SECONDS="5" \
    --from-literal=ENV="development" \
    --from-literal=REFRESH_COOKIE_NAME="refresh_token" \
    --from-literal=REFRESH_COOKIE_HTTP_ONLY="true" \
    --from-literal=REFRESH_COOKIE_SAME_SITE="lax" \
    --from-literal=REFRESH_COOKIE_SECURE="false" \
    --from-literal=ENFORCE_TRIAL_ONCE_PER_USER="false" \
    --from-literal=AUTH_RATE_LIMIT_PER_MIN="60" \
    --from-literal=SALES_LEAD_EMAIL="admin@example.com" \
    --from-literal=OAUTH_GITHUB_CLIENT_ID="" \
    --from-literal=OAUTH_GITHUB_CLIENT_SECRET="" \
    --from-literal=OAUTH_GITHUB_ALLOWED_REDIRECT_URIS="http://localhost:8080/auth/github/callback" \
    --from-literal=OAUTH_GOOGLE_CLIENT_ID="" \
    --from-literal=OAUTH_GOOGLE_CLIENT_SECRET="" \
    --from-literal=MAIL_HOST="" \
    --from-literal=MAIL_PORT="587" \
    --from-literal=MAIL_USERNAME="" \
    --from-literal=MAIL_PASSWORD="" \
    --from-literal=MAIL_FROM_ADDRESS="noreply@example.com" \
    --from-literal=MAIL_FROM_NAME="Alephant" \
    --from-literal=PAYMENT_SERVICE_BASE_URL="http://ledge-service:8080" \
    --from-literal=PAYMENT_SERVICE_KEY="${PAYMENT_SERVICE_KEY}" \
    --from-literal=PAYMENT_LEDGER_GRPC_ADDR="ledge-service:9090" \
    --from-literal=PAYMENT_LEDGER_INTERNAL_TOKEN="" \
    --from-literal=NOTIFICATION_ENCRYPTION_KEY="${NOTIFICATION_ENCRYPTION_KEY}" \
    --from-literal=OUTBOUND_PAYMENT_HMAC_SECRET="${OUTBOUND_PAYMENT_HMAC_SECRET}" \
    --from-literal=REVENUE_WITHDRAW_HMAC_SECRET="${REVENUE_WITHDRAW_HMAC_SECRET}" \
    --from-literal=COLLECTOR_ANALYTICS_BASE_URL="http://alephant-logs-collector:8585" \
    --from-literal=LOGS_COLLECTOR_X402_HTTP_AUTH_TOKEN="${LOGS_COLLECTOR_X402_HTTP_AUTH_TOKEN}"

  # 2. policy-service-secrets
  create_secret alephant-policy-service-secrets \
    --from-literal=POSTGRES_DATABASE_URL="postgresql://alephant:${POSTGRES_PASSWORD}@${PG_HOST}:5432/alephant" \
    --from-literal=REDIS_URL="redis://default:${VALKEY_PASSWORD}@${VALKEY_HOST}:6379/0" \
    --from-literal=POLICY_CONFIG_STREAM="alephant-policy" \
    --from-literal=POLICY_NOTIFY_CHANNEL="alephant-notify" \
    --from-literal=POLICY_USE_STREAM="true" \
    --from-literal=POLICY_STREAM_BATCH_SIZE="100" \
    --from-literal=POLICY_STREAM_BLOCK_MS="1000" \
    --from-literal=POLICY_STREAM_CONSUMER_GROUP="policy-consumer" \
    --from-literal=POLICY_STREAM_CONSUMER_NAME="policy-node-0" \
    --from-literal=POLICY_BOOTSTRAP_REFRESH="true" \
    --from-literal=POLICY_BOOTSTRAP_REFRESH_CONCURRENCY="10" \
    --from-literal=POLICY_BOOTSTRAP_REFRESH_TIMEOUT_SEC="30" \
    --from-literal=ENDPOINT_POLICY_CONFIG_STREAM="alephant-policy" \
    --from-literal=WATCHER_ENABLED="true" \
    --from-literal=NOTIFICATION_ENCRYPTION_KEY="${NOTIFICATION_ENCRYPTION_KEY}" \
    --from-literal=NOTIFICATION_OUTBOX_NOTIFY_CHANNEL="alephant-notification" \
    --from-literal=LOG_LEVEL="info" \
    --from-literal=MAIL_HOST="" \
    --from-literal=MAIL_PORT="587" \
    --from-literal=MAIL_USERNAME="" \
    --from-literal=MAIL_PASSWORD="" \
    --from-literal=MAIL_FROM_ADDRESS="noreply@example.com" \
    --from-literal=MAIL_FROM_NAME="Alephant"

  # 3. ai-gateway-secrets
  create_secret alephant-ai-gateway-secrets \
    --from-literal=POSTGRES_DATABASE_URL="postgresql://alephant:${POSTGRES_PASSWORD}@${PG_HOST}:5432/alephant" \
    --from-literal=REDIS_URL="redis://default:${VALKEY_PASSWORD}@${VALKEY_HOST}:6379/0" \
    --from-literal=CLICKHOUSE_CREDS="default:${CLICKHOUSE_PASSWORD}" \
    --from-literal=AI_GATEWAY__SEMANTIC_CACHE__QDRANT__URL="http://alephant-prod-qdrant:6333" \
    --from-literal=AI_GATEWAY__SEMANTIC_CACHE__QDRANT__API_KEY="${QDRANT_API_KEY}" \
    --from-literal=AI_GATEWAY__TIKV_KV__PD_ENDPOINTS='["pd:2379"]' \
    --from-literal=AI_GATEWAY__TIKV_KV__CA_CERT_PATH="" \
    --from-literal=AI_GATEWAY__POLICY__GRPC_ENDPOINT="alephant-policy-service:9090" \
    --from-literal=AI_GATEWAY__X402__PAYMENT_GRPC_ENDPOINT="" \
    --from-literal=AI_GATEWAY__X402__UPSTREAM_AUTH_KEY="" \
    --from-literal=AI_GATEWAY__ALEPHANT__LOG_COLLECTOR_URL="http://alephant-logs-collector:8585" \
    --from-literal=AI_GATEWAY__REQUEST_LOG__TRANSPORT="http" \
    --from-literal=S3_ENDPOINT="http://alephant-minio:9000" \
    --from-literal=S3_REGION="us-east-1" \
    --from-literal=S3_BUCKET_NAME="alephant" \
    --from-literal=S3_ACCESS_KEY="${S3_ACCESS_KEY}" \
    --from-literal=S3_SECRET_KEY="${S3_SECRET_KEY}" \
    --from-literal=JWT_SECRET="${JWT_SECRET}" \
    --from-literal=ENCRYPTION_KEY="${ENCRYPTION_KEY}" \
    --from-literal=MASTER_KEY_ENCRYPTION_KEY="${MASTER_KEY_ENCRYPTION_KEY}" \
    --from-literal=PAYMENT_SERVICE_KEY="${PAYMENT_SERVICE_KEY}" \
    --from-literal=LOGS_COLLECTOR_X402_HTTP_AUTH_TOKEN="${LOGS_COLLECTOR_X402_HTTP_AUTH_TOKEN}" \
    --from-literal=KEY_MARKET_API_KEY_HASH_SECRET="${MASTER_KEY_ENCRYPTION_KEY}" \
    --from-literal=ANALYTICS_RMT_MAX_RANGE_HOURS="72"

  # 4. logs-collector-secrets
  create_secret alephant-logs-collector-secrets \
    --from-literal=POSTGRES_DATABASE_URL="postgresql://alephant:${POSTGRES_PASSWORD}@${PG_HOST}:5432/alephant" \
    --from-literal=REDIS_URL="redis://default:${VALKEY_PASSWORD}@${VALKEY_HOST}:6379/0" \
    --from-literal=CLICKHOUSE_CREDS="default:${CLICKHOUSE_PASSWORD}" \
    --from-literal=S3_ENDPOINT="http://alephant-minio:9000" \
    --from-literal=S3_REGION="us-east-1" \
    --from-literal=S3_BUCKET_NAME="alephant" \
    --from-literal=S3_ACCESS_KEY="${S3_ACCESS_KEY}" \
    --from-literal=S3_SECRET_KEY="${S3_SECRET_KEY}" \
    --from-literal=JWT_SECRET="${JWT_SECRET}" \
    --from-literal=ENCRYPTION_KEY="${ENCRYPTION_KEY}" \
    --from-literal=LOGS_COLLECTOR_X402_HTTP_AUTH_TOKEN="${LOGS_COLLECTOR_X402_HTTP_AUTH_TOKEN}" \
    --from-literal=ANALYTICS_RMT_MAX_RANGE_HOURS="72"

  ok "Secrets 创建完成"
}

# ─── 创建 ConfigMap 资源 ──────────────────────────────────────────────────
create_all_configmaps() {
  info "创建 ConfigMap..."

  # 1. alephant-license-config — license.jwt + 拥有者邮箱
  local LICENSE_DIR="${SCRIPT_DIR}/license"
  if [ -f "${LICENSE_DIR}/license.jwt" ]; then
    kubectl delete configmap --namespace "${NAMESPACE}" alephant-license-config --ignore-not-found &>/dev/null
    kubectl create configmap alephant-license-config \
      --namespace "${NAMESPACE}" \
      --from-file=license.jwt="${LICENSE_DIR}/license.jwt" \
      --from-literal=PRIVATE_WORKSPACE_OWNER_EMAILS="${PRIVATE_WORKSPACE_OWNER_EMAILS:-}" \
      --save-config=false 2>&1 | grep -v "Warning:" || true
    ok "  ConfigMap alephant-license-config 已创建"
  else
    warn "  license.jwt 不存在，跳过 alephant-license-config"
  fi

  # 2. alephant-sql-config — SQL 文件
  kubectl delete configmap --namespace "${NAMESPACE}" alephant-sql-config --ignore-not-found &>/dev/null
  kubectl create configmap alephant-sql-config \
    --namespace "${NAMESPACE}" \
    --from-file=pgsql.sql="${SCRIPT_DIR}/sql/pgsql.sql" \
    --from-file=clickhouse.sql="${SCRIPT_DIR}/sql/clickhouse.sql" \
    --save-config=false 2>&1 | grep -v "Warning:" || true
  ok "  ConfigMap alephant-sql-config 已创建"

  ok "ConfigMap 创建完成"
}

# ─── 数据库初始化 ──────────────────────────────────────────────────────────
init_databases() {
  info "初始化数据库..."

  # ── 等待 PostgreSQL 就绪 ──
  info "  等待 PostgreSQL 就绪..."
  local RETRIES=30
  local WAIT=2
  local i=0
  local PG_POD
  while [ $i -lt $RETRIES ]; do
    PG_POD=$(kubectl get pod -n "${NAMESPACE}" -l 'app.kubernetes.io/instance=alephant-postgres' -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)
    if [ -n "${PG_POD}" ] && kubectl exec -n "${NAMESPACE}" "${PG_POD}" -- pg_isready -U alephant &>/dev/null; then
      ok "  PostgreSQL 就绪 (${PG_POD})"
      break
    fi
    i=$((i + 1))
    sleep $WAIT
  done
  if [ $i -ge $RETRIES ]; then
    err "PostgreSQL 未能就绪，跳过初始化"
    return 1
  fi

  # ── 检查是否已有表 ──
  local TABLE_COUNT
  TABLE_COUNT=$(kubectl exec -n "${NAMESPACE}" "${PG_POD}" -- psql -U alephant -d alephant -t -c "SELECT count(*) FROM information_schema.tables WHERE table_schema='public';" 2>/dev/null | tr -d ' ')
  if [ -n "${TABLE_COUNT}" ] && [ "${TABLE_COUNT}" -gt 0 ] 2>/dev/null; then
    ok "  数据库已有 ${TABLE_COUNT} 张表，跳过初始化"
  else
    info "  导入 pgsql.sql..."
    kubectl exec -n "${NAMESPACE}" -i "${PG_POD}" -- bash -c "PGPASSWORD='${POSTGRES_PASSWORD}' psql -U alephant -h localhost -d alephant" < "${SCRIPT_DIR}/sql/pgsql.sql" 2>&1 | grep -E "ERROR|CREATE TABLE|INSERT" || true
    ok "  pgsql.sql 导入完成"
  fi

  # ── 等待 ClickHouse 就绪 ──
  info "  等待 ClickHouse 就绪..."
  i=0
  local CH_POD
  while [ $i -lt $RETRIES ]; do
    CH_POD=$(kubectl get pod -n "${NAMESPACE}" -l 'app.kubernetes.io/instance=alephant-clickhouse' -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)
    if [ -n "${CH_POD}" ] && kubectl exec -n "${NAMESPACE}" "${CH_POD}" -- clickhouse-client --user default --password "${CLICKHOUSE_PASSWORD}" --query "SELECT 1" &>/dev/null; then
      ok "  ClickHouse 就绪 (${CH_POD})"
      break
    fi
    i=$((i + 1))
    sleep $WAIT
  done
  if [ $i -ge $RETRIES ]; then
    warn "ClickHouse 未能就绪，跳过初始化"
    return
  fi

  # ── ClickHouse 初始化 ──
  local CH_TABLES
  CH_TABLES=$(kubectl exec -n "${NAMESPACE}" "${CH_POD}" -- clickhouse-client --user default --password "${CLICKHOUSE_PASSWORD}" --query "SHOW TABLES" 2>/dev/null | wc -l | tr -d ' ')
  if [ -n "${CH_TABLES}" ] && [ "${CH_TABLES}" -gt 0 ] 2>/dev/null; then
    ok "  ClickHouse 已有 ${CH_TABLES} 张表，跳过初始化"
  else
    info "  导入 clickhouse.sql..."
    kubectl exec -n "${NAMESPACE}" -i "${CH_POD}" -- clickhouse-client --user default --password "${CLICKHOUSE_PASSWORD}" < "${SCRIPT_DIR}/sql/clickhouse.sql" 2>&1 | grep -v "DB::Exception" || true
    ok "  clickhouse.sql 导入完成"
  fi
}

# ─── 确保 namespace 存在 ────────────────────────────────────────────────
ensure_namespace() {
  if ! kubectl get namespace "${NAMESPACE}" &>/dev/null; then
    info "namespace ${NAMESPACE} 不存在，正在创建..."
    kubectl create namespace "${NAMESPACE}" &>/dev/null || { err "创建 namespace ${NAMESPACE} 失败"; exit 1; }
    ok "namespace ${NAMESPACE} 已创建"
  fi
}

# ─── 主流程 ──────────────────────────────────────────────────────────────
main() {
  echo ""
  echo "═══════════════════════════════════════════"
  echo "  Alephant K8s 部署"
  echo "═══════════════════════════════════════════"
  echo ""

  # 1. 前置检查（仅工具 + 文件）
  check_prereqs

  # 2. 收集 License（邮箱 + JWT）
  collect_license

  # 3. 询问 namespace
  local input_namespace
  read -r -p "  请输入目标 namespace (默认: alephant-prod): " input_namespace
  NAMESPACE="${input_namespace:-alephant-prod}"
  ok "namespace: ${NAMESPACE}"

  # 4. 生成密钥 + 更新 values.yaml（只动本地文件，不需要 kubectl）
  generate_secrets
  fetch_latest_tags
  update_values_yaml

  # 5. 显示计划并确认
  echo ""
  echo "═══════════════════════════════════════════"
  echo "  即将执行以下操作:"
  echo "  · 确保 namespace 存在"
  echo "  · 创建 K8s Secret  x4"
  echo "  · 创建 ConfigMap   x2"
  echo "  · 初始化数据库"
  echo "═══════════════════════════════════════════"
  echo ""
  local confirm
  read -r -p "  是否开始执行? (y/N): " confirm
  if [[ ! "${confirm}" =~ ^[Yy]$ ]]; then
    info "已取消"
    exit 0
  fi

  # 6. 执行（需要 kubectl）
  ensure_namespace
  create_all_secrets
  create_all_configmaps
  init_databases

  echo ""
  echo "═══════════════════════════════════════════"
  echo "  ✅ 部署完成"
  echo "═══════════════════════════════════════════"
  echo ""
  echo "  如需查看生成的密码:"
  echo "    kubectl get secret alephant-saas-service-secrets -n ${NAMESPACE} -o jsonpath='{.data.POSTGRES_DATABASE_URL}' | base64 -d"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
