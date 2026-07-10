# =============================================================================
# ai-gateway.env.tpl — AI 网关独有变量
# 与 shared.env 合并后生成 ai-gateway.env
# =============================================================================

# --- 数据库 (网关有独立的 URL 格式) ---
AI_GATEWAY__DATABASE__URL=postgresql://alephant:<数据库密码>@postgres:5432/alephant

# --- Qdrant 语义缓存 ---
AI_GATEWAY__SEMANTIC_CACHE__QDRANT__URL=http://qdrant:6333
AI_GATEWAY__SEMANTIC_CACHE__QDRANT__API_KEY=<Qdrant API Key>

# --- Cloudflare KV ---
AI_GATEWAY__CLOUDFLARE_KV__ACCOUNT_ID=<请替换>
AI_GATEWAY__CLOUDFLARE_KV__API_BASE=<请替换>
AI_GATEWAY__CLOUDFLARE_KV__API_TOKEN=<请替换>
AI_GATEWAY__CLOUDFLARE_KV__NAMESPACE_ID=<请替换>

# --- 内部服务 gRPC 端点 ---
AI_GATEWAY__POLICY__GRPC_ENDPOINT=policy-service:9090
AI_GATEWAY__ALEPHANT__LOG_COLLECTOR_URL=http://logs-collector:8585
AI_GATEWAY__REQUEST_LOG__TRANSPORT=log_collector
