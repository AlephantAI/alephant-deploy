#!/usr/bin/env bash
# =============================================================================
# download-and-run.sh — 从 S3 下载 Alephant 业务镜像并启动服务
#
# 前置条件:
#   1. Docker Engine 24+ 和 Docker Compose v2+
#   2. 已准备好 alephant-docker/ 目录（docker-compose.yml、config、.env 文件）
#   3. 已生成各服务的 .env 文件（参考 README）
#
# 使用方式:
#   cd alephant-docker/
#   ./download-and-run.sh
#
# 该脚本会:
#   1. 从 https://image-exports.alephant.io/alephant/ 下载 5 个业务镜像
#   2. docker load 加载到本地
#   3. docker compose up -d 启动全部服务
# =============================================================================
set -euo pipefail

# ─── 配置 ────────────────────────────────────────────────────────────────────
S3_BASE_URL="https://image-exports.alephant.io/alephant"
DOWNLOAD_DIR=".downloaded-images"
COMPOSE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 需要下载的镜像（模块名 / 文件名）
# 格式: MODULES[i] 对应 FILES[i]
MODULES=(app saas-service policy-service ai-gateway logs-collector)
FILES=(
  "alephantai-app-20260613081608.tar"
  "alephantai-saas-service-20260629121515.tar"
  "alephantai-policy-service-20260613220845.tar"
  "alephantai-ai-gateway-20260629120913.tar"
  "alephantai-logs-collector-20260618231935.tar"
)

# ─── 颜色 ────────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "${BLUE}[INFO]${NC}  $*"; }
ok()    { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
err()   { echo -e "${RED}[ERROR]${NC} $*"; }

# ─── 检查前置条件 ────────────────────────────────────────────────────────────
check_prereqs() {
  if ! command -v docker &>/dev/null; then
    err "Docker 未安装，请先安装 Docker Engine 24+"
    exit 1
  fi

  if ! docker info &>/dev/null; then
    err "Docker daemon 未运行，请先启动 Docker"
    exit 1
  fi

  if ! command -v curl &>/dev/null && ! command -v wget &>/dev/null; then
    err "需要 curl 或 wget，请安装其一"
    exit 1
  fi

  if [ ! -f "${COMPOSE_DIR}/docker-compose.yml" ]; then
    err "未找到 docker-compose.yml"
    err "请确保在 alephant-docker 目录中运行此脚本"
    info "当前目录: ${COMPOSE_DIR}"
    exit 1
  fi

  # 检查是否已有 .env 文件（提醒但没有 .env 也可以继续，compose 会报更具体错误）
  local MISSING=0
  for svc in saas-service policy-service ai-gateway logs-collector; do
    if [ ! -f "${COMPOSE_DIR}/${svc}.env" ]; then
      warn "缺少 ${svc}.env — 请运行 ./generate-envs.sh 生成"
      MISSING=1
    fi
  done
  if [ ! -f "${COMPOSE_DIR}/infra.env" ]; then
    warn "缺少 infra.env — 请复制 infra.env.example 并填入密码"
    MISSING=1
  fi
  if [ "$MISSING" -eq 1 ]; then
    echo ""
    info "请先配置环境变量后再运行"
    info "  快速开始: cp infra.env.example infra.env && vim infra.env"
    info "  然后:     ./generate-envs.sh"
  fi
}

# ─── 下载镜像 ────────────────────────────────────────────────────────────────
download_images() {
  mkdir -p "${COMPOSE_DIR}/${DOWNLOAD_DIR}"

  local TOTAL=${#MODULES[@]}
  local COUNT=0

  echo ""
  info "开始下载 ${TOTAL} 个业务镜像..."
  echo ""

  for i in "${!MODULES[@]}"; do
    local module="${MODULES[$i]}"
    local local_file="${FILES[$i]}"
    local local_path="${COMPOSE_DIR}/${DOWNLOAD_DIR}/${local_file}"
    local url="${S3_BASE_URL}/${module}/${local_file}"

    # 跳过已下载的文件
    if [ -f "$local_path" ] && [ -s "$local_path" ]; then
      local size=$(du -h "$local_path" | cut -f1)
      ok "${module}: 已存在 (${size})，跳过下载"
      COUNT=$((COUNT + 1))
      continue
    fi

    echo -n "  下载 ${module}... "

    if command -v curl &>/dev/null; then
      curl -sL -o "$local_path" "$url" 2>&1
    elif command -v wget &>/dev/null; then
      wget -q -O "$local_path" "$url" 2>&1
    fi

    if [ -f "$local_path" ] && [ -s "$local_path" ]; then
      local size=$(du -h "$local_path" | cut -f1)
      echo -e "${GREEN}✓${NC} (${size})"
      COUNT=$((COUNT + 1))
    else
      echo -e "${RED}✗ 下载失败${NC}"
      err "请检查 URL: ${url}"
      warn "可手动下载后放入 ${DOWNLOAD_DIR}/ 目录重试"
    fi
  done

  echo ""
  ok "下载完成: ${COUNT}/${TOTAL}"
}

# ─── 加载镜像 ────────────────────────────────────────────────────────────────
load_images() {
  echo ""
  info "加载镜像到 Docker..."

  local LOADED=0
  for i in "${!MODULES[@]}"; do
    local module="${MODULES[$i]}"
    local local_file="${FILES[$i]}"
    local local_path="${COMPOSE_DIR}/${DOWNLOAD_DIR}/${local_file}"

    if [ ! -f "$local_path" ]; then
      warn "${module}: tar 文件不存在，跳过加载"
      continue
    fi

    echo -n "  加载 ${module}... "
    local output
    output=$(docker load -i "$local_path" 2>&1)
    if echo "$output" | grep -q "Loaded image"; then
      local img_name
      img_name=$(echo "$output" | grep "Loaded image" | sed 's/.*Loaded image: //')
      echo -e "${GREEN}✓${NC} ${img_name}"
      LOADED=$((LOADED + 1))
    else
      echo -e "${YELLOW}?${NC} $output"
    fi
  done

  echo ""
  ok "加载完成: ${LOADED} 个镜像"
}

# ─── 拉取基础设施镜像 ─────────────────────────────────────────────────────────
pull_infra_images() {
  echo ""
  info "拉取基础设施镜像（数据库/中间件）..."

  # 从 docker-compose.yml 中提取基础设施镜像
  local infra_images
  infra_images=$(grep -E '^\s+image:' "${COMPOSE_DIR}/docker-compose.yml" \
    | grep -v 'alephantai' \
    | sed 's/.*image: //' \
    | tr -d '"' \
    | sort -u)

  local COUNT=0
  local TOTAL=0
  for img in $infra_images; do
    TOTAL=$((TOTAL + 1))
    echo -n "  拉取 ${img}... "
    if docker pull --quiet "$img" 2>/dev/null; then
      echo -e "${GREEN}✓${NC}"
      COUNT=$((COUNT + 1))
    else
      echo -e "${RED}✗ 失败${NC}"
    fi
  done

  echo ""
  ok "基础设施镜像: ${COUNT}/${TOTAL}"
}

# ─── 启动服务 ────────────────────────────────────────────────────────────────
start_services() {
  echo ""
  info "启动所有服务..."
  echo ""

  cd "${COMPOSE_DIR}"
  docker compose up -d 2>&1

  echo ""
  ok "服务已启动!"
  echo ""
  echo "  查看状态: docker compose ps"
  echo "  查看日志: docker compose logs -f"
  echo "  验证:     curl http://localhost:8080/health"
}

# ─── 主流程 ──────────────────────────────────────────────────────────────────
main() {
  echo ""
  echo "═══════════════════════════════════════════"
  echo "  Alephant 镜像下载与部署工具"
  echo "═══════════════════════════════════════════"
  echo ""

  check_prereqs
  download_images
  load_images
  pull_infra_images
  start_services

  echo ""
  echo "═══════════════════════════════════════════"
  echo "  ✅ 部署完成"
  echo "═══════════════════════════════════════════"
}

main "$@"
