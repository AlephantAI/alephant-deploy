# =============================================================================
# policy-service.env.tpl — 策略后端独有变量
# 与 shared.env 合并后生成 policy-service.env
# =============================================================================

# --- Policy ---
POLICY_USE_STREAM=true
POLICY_STREAM_BATCH_SIZE=100
POLICY_STREAM_BLOCK_MS=1000
POLICY_STREAM_CONSUMER_GROUP=<请替换>
POLICY_STREAM_CONSUMER_NAME=<请替换>
POLICY_BOOTSTRAP_REFRESH=true
POLICY_BOOTSTRAP_REFRESH_CONCURRENCY=10
POLICY_BOOTSTRAP_REFRESH_TIMEOUT_SEC=30
ENDPOINT_POLICY_CONFIG_STREAM=<请替换>
WATCHER_ENABLED=true

# --- Redis 专属 ---
REDIS_DB=0

# --- 日志 ---
LOG_LEVEL=info
