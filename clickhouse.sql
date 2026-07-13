-- agent_events_rmt DDL
CREATE TABLE IF NOT EXISTS `agent_events_rmt` (
	`event_id` String,
	`workspace_id` UUID,
	`workspace_type` LowCardinality(String) DEFAULT '',
	`alephant_agent_id` String DEFAULT '',
	`alephant_agent_name` String DEFAULT '',
	`alephant_run_id` String DEFAULT '',
	`alephant_step_id` String DEFAULT '',
	`alephant_parent_step_id` String DEFAULT '',
	`event_type` LowCardinality(String),
	`event_source` LowCardinality(String) DEFAULT '',
	`event_time` DateTime64(3, 'UTC'),
	`observed_at` DateTime64(3, 'UTC'),
	`step_kind` LowCardinality(String) DEFAULT '',
	`step_source` LowCardinality(String) DEFAULT '',
	`step_confidence` LowCardinality(String) DEFAULT '',
	`agent_trust_level` LowCardinality(String) DEFAULT '',
	`graph_node` LowCardinality(String) DEFAULT '',
	`tool_call_id` String DEFAULT '',
	`tool_name` String DEFAULT '',
	`status` LowCardinality(String) DEFAULT '',
	`severity` LowCardinality(String) DEFAULT '',
	`model` LowCardinality(String) DEFAULT '',
	`provider` LowCardinality(String) DEFAULT '',
	`latency_ms` Nullable(Int64),
	`duration_ms` Nullable(Int64),
	`cost` UInt64 DEFAULT 0,
	`policy_allowed` Nullable(Bool),
	`policy_reason` String DEFAULT '',
	`policy_blocked_by` String DEFAULT '',
	`policy_id` String DEFAULT '',
	`policy_scope` LowCardinality(String) DEFAULT '',
	`policy_snapshot_revision` Int64 DEFAULT 0,
	`input_hash` String DEFAULT '',
	`attempt` UInt32 DEFAULT 0,
	`request_id` Nullable(UUID),
	`metadata` String DEFAULT '',
	`raw_event` String DEFAULT '',
	`created_at` DateTime64(3, 'UTC') DEFAULT now64(3),
	`updated_at` DateTime64(3, 'UTC') DEFAULT now64(3)
) ENGINE = ReplacingMergeTree ORDER BY (`workspace_id`,`event_id`) PARTITION BY (toYYYYMM(event_time)) PRIMARY KEY (`workspace_id`,`event_id`) SETTINGS index_granularity = 8192;
ALTER TABLE `agent_events_rmt` 
ADD INDEX IF NOT EXISTS `idx_agent_run` (alephant_agent_id, alephant_run_id) TYPE bloom_filter(0.01) GRANULARITY 1,
ADD INDEX IF NOT EXISTS `idx_step_id` alephant_step_id TYPE bloom_filter(0.01) GRANULARITY 1,
ADD INDEX IF NOT EXISTS `idx_tool_call_id` tool_call_id TYPE bloom_filter(0.01) GRANULARITY 1,
ADD INDEX IF NOT EXISTS `idx_event_type` event_type TYPE set(128) GRANULARITY 4,
ADD INDEX IF NOT EXISTS `idx_step_kind` step_kind TYPE set(64) GRANULARITY 4;
-- cache_metrics DDL
CREATE TABLE IF NOT EXISTS `cache_metrics` (
	`organization_id` UUID,
	`date` Date,
	`hour` UInt8,
	`request_id` String,
	`model` String,
	`provider` String,
	`cache_hit_count` SimpleAggregateFunction(sum, UInt64),
	`saved_latency_ms` SimpleAggregateFunction(sum, UInt64),
	`saved_completion_tokens` SimpleAggregateFunction(sum, UInt64),
	`saved_prompt_tokens` SimpleAggregateFunction(sum, UInt64),
	`saved_completion_audio_tokens` SimpleAggregateFunction(sum, UInt64),
	`saved_prompt_audio_tokens` SimpleAggregateFunction(sum, UInt64),
	`saved_prompt_cache_write_tokens` SimpleAggregateFunction(sum, UInt64),
	`saved_prompt_cache_read_tokens` SimpleAggregateFunction(sum, UInt64),
	`last_hit` SimpleAggregateFunction(max, DateTime64(3)),
	`first_hit` SimpleAggregateFunction(min, DateTime64(3)),
	`request_body` String DEFAULT '',
	`response_body` String DEFAULT ''
) ENGINE = AggregatingMergeTree ORDER BY (`organization_id`) PRIMARY KEY (`organization_id`) SETTINGS index_granularity = 8192;
-- helicone_migrations DDL
CREATE TABLE IF NOT EXISTS `helicone_migrations` (
	`migration_name` String,
	`applied_date` DateTime DEFAULT now()
) ENGINE = MergeTree ORDER BY (`migration_name`) PRIMARY KEY (`migration_name`) SETTINGS index_granularity = 8192;
-- hidden_property_keys DDL
CREATE TABLE IF NOT EXISTS `hidden_property_keys` (
	`organization_id` UUID,
	`key` String,
	`is_hidden` UInt8 DEFAULT 1
) ENGINE = MergeTree ORDER BY (`organization_id`) PRIMARY KEY (`organization_id`) SETTINGS index_granularity = 8192;
-- hidden_props DDL
CREATE TABLE IF NOT EXISTS `hidden_props` (
	`organization_id` UUID,
	`key` String,
	`is_hidden` UInt8
) ENGINE = MergeTree ORDER BY (`organization_id`, `key`) PRIMARY KEY (`organization_id`);
-- jawn_http_logs DDL
CREATE TABLE IF NOT EXISTS `jawn_http_logs` (
	`organization_id` UUID,
	`method` String,
	`url` String,
	`status` UInt16,
	`duration` UInt32,
	`user_agent` String,
	`created_at` DateTime64(3, 'UTC') DEFAULT now(),
	`properties` Map(String, String)
) ENGINE = MergeTree ORDER BY (`organization_id`) PARTITION BY (toYYYYMM(created_at)) PRIMARY KEY (`organization_id`) TTL toDateTime(created_at) + toIntervalDay(90) SETTINGS index_granularity = 8192;
-- key_market_usage_application_model_month DDL
CREATE TABLE IF NOT EXISTS `key_market_usage_application_model_month` (
	`month_start` DateTime('UTC'),
	`account_id` String,
	`workspace_id` String,
	`application_id` String,
	`model` LowCardinality(String),
	`cost_sum` AggregateFunction(sum, UInt64),
	`prompt_token_sum` AggregateFunction(sum, UInt64),
	`completion_token_sum` AggregateFunction(sum, UInt64),
	`request_count` AggregateFunction(count)
) ENGINE = AggregatingMergeTree ORDER BY (`account_id`,`month_start`) PARTITION BY (toYYYYMM(month_start)) PRIMARY KEY (`account_id`,`month_start`) SETTINGS index_granularity = 8192;
-- key_market_usage_cost_by_upstream_month DDL
CREATE TABLE IF NOT EXISTS `key_market_usage_cost_by_upstream_month` (
	`month_start` DateTime('UTC'),
	`account_id` String,
	`upstream_id` String,
	`provider` LowCardinality(String),
	`model` LowCardinality(String),
	`cost_sum` AggregateFunction(sum, UInt64)
) ENGINE = AggregatingMergeTree ORDER BY (`account_id`,`month_start`) PARTITION BY (toYYYYMM(month_start)) PRIMARY KEY (`account_id`,`month_start`) SETTINGS index_granularity = 8192;
-- key_market_usage_health_by_model_provider DDL
CREATE TABLE IF NOT EXISTS `key_market_usage_health_by_model_provider` (
	`bucket_start` DateTime('UTC'),
	`provider` LowCardinality(String),
	`model` LowCardinality(String),
	`total_count` AggregateFunction(count),
	`success_count` AggregateFunction(countIf, UInt8),
	`failed_count` AggregateFunction(countIf, UInt8),
	`other_count` AggregateFunction(countIf, UInt8)
) ENGINE = AggregatingMergeTree ORDER BY (`provider`,`bucket_start`) PARTITION BY (toYYYYMM(bucket_start)) PRIMARY KEY (`provider`,`bucket_start`) SETTINGS index_granularity = 8192;
-- key_market_usage_health_by_router_model_provider DDL
CREATE TABLE IF NOT EXISTS `key_market_usage_health_by_router_model_provider` (
	`bucket_start` DateTime('UTC'),
	`provider` LowCardinality(String),
	`model` LowCardinality(String),
	`router_id` LowCardinality(String),
	`total_count` AggregateFunction(count),
	`success_count` AggregateFunction(countIf, UInt8),
	`failed_count` AggregateFunction(countIf, UInt8),
	`other_count` AggregateFunction(countIf, UInt8)
) ENGINE = AggregatingMergeTree ORDER BY (`provider`,`bucket_start`) PARTITION BY (toYYYYMM(bucket_start)) PRIMARY KEY (`provider`,`bucket_start`) SETTINGS index_granularity = 8192;
-- key_market_usage_latency_by_model_provider DDL
CREATE TABLE IF NOT EXISTS `key_market_usage_latency_by_model_provider` (
	`provider` LowCardinality(String),
	`model` LowCardinality(String),
	`latency_min` AggregateFunction(min, UInt64),
	`latency_max` AggregateFunction(max, UInt64),
	`latency_p50` AggregateFunction(quantileTDigest(0.5), UInt64)
) ENGINE = AggregatingMergeTree ORDER BY (`provider`) PRIMARY KEY (`provider`) SETTINGS index_granularity = 8192;
-- key_market_usage_logs DDL
CREATE TABLE IF NOT EXISTS `key_market_usage_logs` (
	`account_id` String,
	`workspace_id` String DEFAULT '',
	`provider` String DEFAULT '',
	`time` DateTime64(3, 'UTC'),
	`model` LowCardinality(String),
	`prompt_token` UInt64,
	`completion_token` UInt64,
	`cost` UInt64,
	`latency` UInt64 DEFAULT 0,
	`router_id` String DEFAULT '',
	`fallback_reason` String DEFAULT '',
	`router_function` LowCardinality(String) DEFAULT '',
	`router_owner_type` LowCardinality(String) DEFAULT '',
	`router_version` UInt32 DEFAULT 0,
	`router_owner_fallback_reason` String DEFAULT '',
	`status` String DEFAULT 'success',
	`failure_reason` String DEFAULT '',
	`upstream_id` String DEFAULT '',
	`partner_id` String DEFAULT '',
	`commission_rate` Decimal(9, 4) DEFAULT 0,
	`commission_amount` UInt64 DEFAULT 0,
	`request_id` String,
	`api_key_id` String DEFAULT '',
	`application_id` String DEFAULT ''
) ENGINE = MergeTree ORDER BY (`account_id`) PARTITION BY (toYYYYMM(time)) PRIMARY KEY (`account_id`) SETTINGS index_granularity = 8192;
-- key_market_usage_partner_month DDL
CREATE TABLE IF NOT EXISTS `key_market_usage_partner_month` (
	`month_start` DateTime('UTC'),
	`account_id` String,
	`partner_id` String,
	`cost_sum` AggregateFunction(sum, UInt64),
	`commission_sum` AggregateFunction(sum, UInt64),
	`request_count` AggregateFunction(count)
) ENGINE = AggregatingMergeTree ORDER BY (`partner_id`,`month_start`) PARTITION BY (toYYYYMM(month_start)) PRIMARY KEY (`partner_id`,`month_start`) SETTINGS index_granularity = 8192;
-- organization_properties DDL
CREATE TABLE IF NOT EXISTS `organization_properties` (
	`organization_id` UUID,
	`property_key` String
) ENGINE = ReplacingMergeTree ORDER BY (`organization_id`) PRIMARY KEY (`organization_id`) SETTINGS index_granularity = 8192;
-- organization_ptb_spend DDL
CREATE TABLE IF NOT EXISTS `organization_ptb_spend` (
	`organization_id` UUID,
	`spend` UInt64
) ENGINE = SummingMergeTree ORDER BY (`organization_id`) PRIMARY KEY (`organization_id`) SETTINGS index_granularity = 8192;
-- prompt_usage_daily DDL
CREATE TABLE IF NOT EXISTS `prompt_usage_daily` (
	`date` Date,
	`workspace_id` UUID,
	`prompt_id` String,
	`prompt_version` String,
	`entity_type` String,
	`entity_id` UUID,
	`request_count` UInt64,
	`cost_sum` Float64,
	`prompt_tokens_sum` UInt64,
	`completion_tokens_sum` UInt64,
	`reasoning_tokens_sum` UInt64,
	`latency_ms_sum` UInt64,
	`success_count` UInt64,
	`error_count` UInt64
) ENGINE = SummingMergeTree ORDER BY (`date`) PARTITION BY (toYYYYMM(date)) PRIMARY KEY (`date`) SETTINGS index_granularity = 8192;
-- properties_v3 DDL
CREATE TABLE IF NOT EXISTS `properties_v3` (
	`organization_id` UUID,
	`key` String,
	`value` String,
	`created_at` DateTime64(3),
	`id` Int64,
	`request_id` UUID
) ENGINE = MergeTree ORDER BY (`organization_id`) PRIMARY KEY (`organization_id`) SETTINGS index_granularity = 8192, allow_nullable_key = 1;
-- property_with_response_v1 DDL
CREATE TABLE IF NOT EXISTS `property_with_response_v1` (
	`response_id` Nullable(UUID),
	`response_created_at` Nullable(DateTime64(3)),
	`latency` Nullable(Int64),
	`status` Int64,
	`completion_tokens` Nullable(Int64),
	`prompt_tokens` Nullable(Int64),
	`model` String,
	`request_id` UUID,
	`request_created_at` DateTime64(3),
	`auth_hash` String,
	`user_id` String,
	`organization_id` UUID,
	`threat` Nullable(Bool),
	`time_to_first_token` Nullable(Int64),
	`provider` Nullable(String),
	`country_code` Nullable(String),
	`property_key` String,
	`property_value` String
) ENGINE = MergeTree ORDER BY (`organization_id`,`response_id`) PRIMARY KEY (`organization_id`,`response_id`) SETTINGS index_granularity = 8192, allow_nullable_key = 1;
-- request_response_log DDL
CREATE TABLE IF NOT EXISTS `request_response_log` (
	`response_id` Nullable(UUID),
	`response_created_at` Nullable(DateTime64(3)),
	`latency` Nullable(Int64),
	`status` Int64,
	`completion_tokens` Nullable(Int64),
	`prompt_tokens` Nullable(Int64),
	`model` String,
	`request_id` UUID,
	`request_created_at` DateTime64(3),
	`auth_hash` String,
	`user_id` String,
	`organization_id` UUID,
	`proxy_key_id` Nullable(UUID),
	`node_id` Nullable(UUID),
	`job_id` Nullable(UUID),
	`threat` Nullable(Bool),
	`time_to_first_token` Nullable(Int64),
	`provider` Nullable(String),
	`target_url` Nullable(String),
	`request_ip` Nullable(String),
	`country_code` Nullable(String),
	`created_at` DateTime DEFAULT now()
) ENGINE = MergeTree ORDER BY (`organization_id`,`response_id`) PRIMARY KEY (`organization_id`,`response_id`) SETTINGS index_granularity = 8192, allow_nullable_key = 1;
-- request_response_rmt DDL
CREATE TABLE IF NOT EXISTS `request_response_rmt` (
	`response_id` Nullable(UUID),
	`response_created_at` Nullable(DateTime64(3)),
	`latency` Nullable(Int64),
	`status` Int64,
	`completion_tokens` Nullable(Int64),
	`completion_audio_tokens` Int64,
	`cache_reference_id` String DEFAULT '00000000-0000-0000-0000-000000000000',
	`request_referrer` String,
	`is_passthrough_billing` Bool,
	`prompt_tokens` Nullable(Int64),
	`prompt_cache_write_tokens` Int64,
	`prompt_cache_read_tokens` Int64,
	`prompt_audio_tokens` Int64,
	`model` LowCardinality(String),
	`ai_gateway_body_mapping` String,
	`gateway_endpoint_version` String,
	`request_id` UUID,
	`request_created_at` DateTime64(3),
	`user_id` LowCardinality(String),
	`proxy_key_id` Nullable(UUID),
	`threat` Nullable(Bool),
	`time_to_first_token` Nullable(Int64),
	`provider` LowCardinality(String),
	`target_url` Nullable(String),
	`country_code` Nullable(String),
	`cache_enabled` Bool,
	`properties` Map(LowCardinality(String), String),
	`scores` Map(LowCardinality(String), Int64),
	`request_body` String DEFAULT '' TTL toDateTime(request_created_at) + toIntervalDay(greatest(1, least(730, coalesce(body_ttl_days, 90)))),
	`response_body` String DEFAULT '' TTL toDateTime(request_created_at) + toIntervalDay(greatest(1, least(730, coalesce(body_ttl_days, 90)))),
	`cost` UInt64,
	`prompt_id` String,
	`prompt_version` String,
	`assets` Array(String),
	`updated_at` DateTime64(3, 'UTC'),
	`storage_location` LowCardinality(String),
	`size_bytes` UInt32,
	`reasoning_tokens` Int64,
	`department_id` UUID,
	`entity_type` LowCardinality(String),
	`entity_id` UUID,
	`entity_name` LowCardinality(String),
	`body_ttl_days` UInt16,
	`workspace_id` UUID,
	`master_key_id` Nullable(UUID),
	`proxy_key_name` LowCardinality(String) DEFAULT '',
	`proxy_key_prefix` LowCardinality(String) DEFAULT '',
	`department_name` LowCardinality(String) DEFAULT '',
	`session_id` String DEFAULT '',
	`body_hash` UInt64 DEFAULT 0,
	`save_prompt_tokens` Int64 DEFAULT 0,
	`cache_saved_cost` UInt64 DEFAULT 0,
	`step_id` String DEFAULT '',
	`parent_step_id` String DEFAULT '',
	`policy_event_type` LowCardinality(String) DEFAULT '',
	`policy_event_severity` LowCardinality(String) DEFAULT '',
	`policy_event_description` String DEFAULT '',
	`alephant_agent_id` String DEFAULT '',
	`alephant_agent_name` String DEFAULT '',
	`alephant_run_id` String DEFAULT '',
	`alephant_step_id` String DEFAULT '',
	`alephant_graph_node` LowCardinality(String) DEFAULT '',
	`alephant_step_kind` LowCardinality(String) DEFAULT '',
	`alephant_step_source` LowCardinality(String) DEFAULT '',
	`alephant_step_confidence` LowCardinality(String) DEFAULT '',
	`alephant_agent_trust_level` LowCardinality(String) DEFAULT '',
	`workspace_type` LowCardinality(String) DEFAULT ''
) ENGINE = ReplacingMergeTree ORDER BY (`workspace_id`,`response_id`) PARTITION BY (toYYYYMM(request_created_at)) PRIMARY KEY (`workspace_id`,`response_id`) SETTINGS index_granularity = 8192, allow_nullable_key = 1;
ALTER TABLE `request_response_rmt` 
ADD INDEX IF NOT EXISTS `idx_properties_key` mapKeys(properties) TYPE bloom_filter(0.01) GRANULARITY 1,
ADD INDEX IF NOT EXISTS `idx_properties_value` mapValues(properties) TYPE bloom_filter(0.01) GRANULARITY 1,
ADD INDEX IF NOT EXISTS `idx_scores_key` mapKeys(scores) TYPE bloom_filter(0.01) GRANULARITY 1,
ADD INDEX IF NOT EXISTS `idx_scores_value` mapValues(scores) TYPE bloom_filter(0.01) GRANULARITY 1,
ADD INDEX IF NOT EXISTS `idx_request_body_bloom` request_body TYPE ngrambf_v1(4, 1024, 1, 0) GRANULARITY 1,
ADD INDEX IF NOT EXISTS `idx_response_body_bloom` response_body TYPE ngrambf_v1(4, 1024, 1, 0) GRANULARITY 1,
ADD INDEX IF NOT EXISTS `idx_org_passthrough_billing` (workspace_id, is_passthrough_billing) TYPE set(2) GRANULARITY 4,
ADD INDEX IF NOT EXISTS `idx_request_id_bf` request_id TYPE bloom_filter(0.01) GRANULARITY 1;
-- request_response_versioned DDL
CREATE TABLE IF NOT EXISTS `request_response_versioned` (
	`response_id` Nullable(UUID),
	`response_created_at` Nullable(DateTime64(3)),
	`latency` Nullable(Int64),
	`status` Int64,
	`completion_tokens` Nullable(Int64),
	`prompt_tokens` Nullable(Int64),
	`model` String,
	`request_id` UUID,
	`request_created_at` DateTime64(3),
	`user_id` String,
	`organization_id` UUID,
	`proxy_key_id` Nullable(UUID),
	`threat` Nullable(Bool),
	`time_to_first_token` Nullable(Int64),
	`provider` String,
	`target_url` Nullable(String),
	`country_code` Nullable(String),
	`sign` Int8,
	`version` UInt32,
	`properties` Map(LowCardinality(String), String) CODEC(ZSTD(1)),
	`scores` Map(LowCardinality(String), Int64) CODEC(ZSTD(1)),
	`assets` Array(String) CODEC(ZSTD(1)),
	`response_body` String DEFAULT '' TTL toDateTime(request_created_at) + toIntervalMonth(3),
	`request_body` String DEFAULT '' TTL toDateTime(request_created_at) + toIntervalMonth(3)
) ENGINE = VersionedCollapsingMergeTree(sign, version) ORDER BY (`organization_id`,`response_id`) PRIMARY KEY (`organization_id`,`response_id`) SETTINGS index_granularity = 8192, allow_nullable_key = 1;
ALTER TABLE `request_response_versioned` 
ADD INDEX IF NOT EXISTS `idx_properties_key` mapKeys(properties) TYPE bloom_filter(0.01) GRANULARITY 1,
ADD INDEX IF NOT EXISTS `idx_properties_value` mapValues(properties) TYPE bloom_filter(0.01) GRANULARITY 1,
ADD INDEX IF NOT EXISTS `idx_scores_key` mapKeys(scores) TYPE bloom_filter(0.01) GRANULARITY 1,
ADD INDEX IF NOT EXISTS `idx_scores_value` mapValues(scores) TYPE bloom_filter(0.01) GRANULARITY 1,
ADD INDEX IF NOT EXISTS `idx_request_body_bloom` request_body TYPE ngrambf_v1(4, 1024, 1, 0) GRANULARITY 1,
ADD INDEX IF NOT EXISTS `idx_response_body_bloom` response_body TYPE ngrambf_v1(4, 1024, 1, 0) GRANULARITY 1;
-- request_stats DDL
CREATE TABLE IF NOT EXISTS `request_stats` (
	`hour` DateTime,
	`model` LowCardinality(String),
	`provider` LowCardinality(String),
	`is_passthrough_billing` Bool,
	`total_prompt_tokens` SimpleAggregateFunction(sum, Int64),
	`total_completion_tokens` SimpleAggregateFunction(sum, Int64),
	`total_completion_audio_tokens` SimpleAggregateFunction(sum, Int64),
	`total_prompt_audio_tokens` SimpleAggregateFunction(sum, Int64),
	`total_prompt_cache_write_tokens` SimpleAggregateFunction(sum, Int64),
	`total_prompt_cache_read_tokens` SimpleAggregateFunction(sum, Int64),
	`latency_sum` SimpleAggregateFunction(sum, Int64),
	`ttft_sum` SimpleAggregateFunction(sum, Int64),
	`total_requests` SimpleAggregateFunction(sum, UInt64),
	`successful_requests` SimpleAggregateFunction(sum, UInt64)
) ENGINE = SummingMergeTree ORDER BY (`hour`) PRIMARY KEY (`hour`) SETTINGS index_granularity = 8192, allow_nullable_key = 1;
-- tags DDL
CREATE TABLE IF NOT EXISTS `tags` (
	`organization_id` UUID,
	`entity_type` String,
	`entity_id` String,
	`tag` String,
	`created_at` DateTime DEFAULT now()
) ENGINE = ReplacingMergeTree ORDER BY (`organization_id`) PRIMARY KEY (`organization_id`) SETTINGS index_granularity = 8192, allow_nullable_key = 1;
-- usage_aggregates_daily DDL
CREATE TABLE IF NOT EXISTS `usage_aggregates_daily` (
	`date` Date,
	`workspace_id` UUID,
	`department_id` UUID DEFAULT '00000000-0000-0000-0000-000000000000',
	`entity_type` LowCardinality(String) DEFAULT '',
	`entity_id` UUID DEFAULT '00000000-0000-0000-0000-000000000000',
	`model` LowCardinality(String) DEFAULT '',
	`provider` LowCardinality(String) DEFAULT '',
	`master_key_id` UUID DEFAULT '00000000-0000-0000-0000-000000000000',
	`request_count` UInt64 DEFAULT 0,
	`cost_sum` UInt64 DEFAULT 0,
	`prompt_tokens_sum` UInt64 DEFAULT 0,
	`completion_tokens_sum` UInt64 DEFAULT 0,
	`reasoning_tokens_sum` UInt64 DEFAULT 0,
	`latency_ms_sum` UInt64 DEFAULT 0,
	`success_count` UInt64 DEFAULT 0,
	`error_count` UInt64 DEFAULT 0,
	`last_event_at` SimpleAggregateFunction(max, DateTime64(3)),
	`prompt_cache_read_tokens_sum` Int64,
	`entity_name` SimpleAggregateFunction(anyLast, String)
) ENGINE = SummingMergeTree ORDER BY (`workspace_id`,`date`) PARTITION BY (toYYYYMM(date)) PRIMARY KEY (`workspace_id`,`date`) SETTINGS index_granularity = 8192;
-- usage_aggregates_hourly DDL
CREATE TABLE IF NOT EXISTS `usage_aggregates_hourly` (
	`bucket_hour` DateTime,
	`workspace_id` UUID,
	`department_id` UUID DEFAULT '00000000-0000-0000-0000-000000000000',
	`entity_type` LowCardinality(String) DEFAULT '',
	`entity_id` UUID DEFAULT '00000000-0000-0000-0000-000000000000',
	`model` LowCardinality(String) DEFAULT '',
	`provider` LowCardinality(String) DEFAULT '',
	`master_key_id` UUID DEFAULT '00000000-0000-0000-0000-000000000000',
	`request_count` UInt64 DEFAULT 0,
	`cost_sum` UInt64 DEFAULT 0,
	`prompt_tokens_sum` UInt64 DEFAULT 0,
	`completion_tokens_sum` UInt64 DEFAULT 0,
	`reasoning_tokens_sum` UInt64 DEFAULT 0,
	`prompt_cache_read_tokens_sum` UInt64 DEFAULT 0,
	`cache_hit_count` UInt64 DEFAULT 0,
	`cache_miss_count` UInt64 DEFAULT 0,
	`cache_saved_cost_sum` UInt64 DEFAULT 0,
	`last_event_at` SimpleAggregateFunction(max, DateTime64(3)),
	`entity_name` SimpleAggregateFunction(anyLast, String),
	`cache_saved_cost_corrected_sum` UInt64 DEFAULT 0
) ENGINE = SummingMergeTree ORDER BY (`workspace_id`,`bucket_hour`) PARTITION BY (toYYYYMM(bucket_hour)) PRIMARY KEY (`workspace_id`,`bucket_hour`) SETTINGS index_granularity = 8192;
-- x402_activity_fact DDL
CREATE TABLE IF NOT EXISTS `x402_activity_fact` (
	`event_time` DateTime64(3),
	`workspace_id` UUID,
	`activity_id` UUID,
	`endpoint_id` UUID,
	`agent_id` UUID,
	`trace_id` String,
	`direction` LowCardinality(String),
	`payment_status` LowCardinality(String),
	`settlement_status` LowCardinality(String),
	`settled_at` Nullable(DateTime64(3)),
	`service_status` LowCardinality(String),
	`available_at` Nullable(DateTime64(3)),
	`ledger_status` LowCardinality(String),
	`source` LowCardinality(String),
	`facilitator` LowCardinality(String),
	`network` LowCardinality(String),
	`asset` LowCardinality(String),
	`gross_revenue` Float64,
	`alephant_fee` Float64,
	`net_revenue` Float64,
	`ai_cost` Float64,
	`tx_hash` String,
	`platform_receive_wallet_address` String,
	`seller_receive_wallet_address` String,
	`fee_wallet_address` String,
	`buyer_wallet` String,
	`fund_status` LowCardinality(String),
	`trace_status` LowCardinality(String),
	`agent_session_id` String,
	`failure_reason` String,
	`created_at` DateTime64(3),
	`verify_time` Nullable(DateTime64(3))
) ENGINE = MergeTree ORDER BY (`workspace_id`,`event_time`) PARTITION BY (toYYYYMM(event_time)) PRIMARY KEY (`workspace_id`,`event_time`) SETTINGS index_granularity = 8192;
-- x402_revenue_daily DDL
CREATE TABLE IF NOT EXISTS `x402_revenue_daily` (
	`date` Date,
	`workspace_id` UUID,
	`endpoint_id` UUID DEFAULT '00000000-0000-0000-0000-000000000000',
	`agent_id` UUID DEFAULT '00000000-0000-0000-0000-000000000000',
	`facilitator` LowCardinality(String) DEFAULT '',
	`network` LowCardinality(String) DEFAULT '',
	`asset` LowCardinality(String) DEFAULT '',
	`request_count` UInt64 DEFAULT 0,
	`success_count` UInt64 DEFAULT 0,
	`verified_count` UInt64 DEFAULT 0,
	`gross_revenue_sum` Float64 DEFAULT 0,
	`alephant_fee_sum` Float64 DEFAULT 0,
	`net_revenue_sum` Float64 DEFAULT 0,
	`ai_cost_sum` Float64 DEFAULT 0,
	`last_event_at` SimpleAggregateFunction(max, DateTime64(3))
) ENGINE = SummingMergeTree ORDER BY (`workspace_id`,`date`) PARTITION BY (toYYYYMM(date)) PRIMARY KEY (`workspace_id`,`date`) SETTINGS index_granularity = 8192;
-- x402_settlement_events DDL
CREATE TABLE IF NOT EXISTS `x402_settlement_events` (
	`event_time` DateTime64(3),
	`workspace_id` UUID,
	`settlement_id` UUID,
	`activity_id` UUID,
	`endpoint_id` UUID,
	`network` LowCardinality(String),
	`status` LowCardinality(String),
	`gross_amount` Float64,
	`fee_amount` Float64,
	`net_amount` Float64,
	`fee_bps` UInt16,
	`tx_hash` String,
	`block_number` UInt64,
	`platform_receive_wallet_address` String,
	`seller_receive_wallet_address` String,
	`fee_wallet_address` String,
	`fund_status` LowCardinality(String),
	`available_at` Nullable(DateTime64(3)),
	`held_amount` Float64,
	`held_reason` String,
	`failure_reason` String,
	`created_at` DateTime64(3),
	`completed_at` Nullable(DateTime64(3)),
	`confirmation_count` UInt16,
	`settlement_latency_ms` UInt32,
	`retry_count` UInt16,
	`facilitator` LowCardinality(String),
	`chain_id` String,
	`gas_fee_amount` Float64,
	`explorer_url` String
) ENGINE = MergeTree ORDER BY (`workspace_id`,`event_time`) PARTITION BY (toYYYYMM(event_time)) PRIMARY KEY (`workspace_id`,`event_time`) SETTINGS index_granularity = 8192;
-- agent_events_rmt Constraints
;
-- cache_metrics Constraints
;
-- helicone_migrations Constraints
;
-- hidden_property_keys Constraints
;
-- hidden_props Constraints
;
-- jawn_http_logs Constraints
;
-- key_market_usage_application_model_month Constraints
;
-- key_market_usage_cost_by_upstream_month Constraints
;
-- key_market_usage_health_by_model_provider Constraints
;
-- key_market_usage_health_by_router_model_provider Constraints
;
-- key_market_usage_latency_by_model_provider Constraints
;
-- key_market_usage_logs Constraints
;
-- key_market_usage_partner_month Constraints
;
-- organization_properties Constraints
;
-- organization_ptb_spend Constraints
;
-- prompt_usage_daily Constraints
;
-- properties_v3 Constraints
;
-- property_with_response_v1 Constraints
;
-- request_response_log Constraints
;
-- request_response_rmt Constraints
;
-- request_response_versioned Constraints
;
-- request_stats Constraints
;
-- tags Constraints
;
-- usage_aggregates_daily Constraints
;
-- usage_aggregates_hourly Constraints
;
-- x402_activity_fact Constraints
;
-- x402_revenue_daily Constraints
;
-- x402_settlement_events Constraints
;


-- entity_token_dist_daily view
CREATE MATERIALIZED VIEW IF NOT EXISTS default.entity_token_dist_daily (`workspace_id` UUID, `entity_id` UUID, `date` Date, `token_bucket` String, `bucket_count` UInt64) ENGINE = AggregatingMergeTree PARTITION BY toYYYYMM(date) ORDER BY (workspace_id, entity_id, token_bucket) SETTINGS index_granularity = 8192 AS SELECT workspace_id, entity_id, toDate(request_created_at) AS date, multiIf((prompt_tokens + completion_tokens) < 100, '0-100', (prompt_tokens + completion_tokens) < 500, '100-500', (prompt_tokens + completion_tokens) < 2000, '500-2000', '2000+') AS token_bucket, count() AS bucket_count FROM default.request_response_rmt WHERE request_created_at >= (now() - toIntervalDay(31)) GROUP BY workspace_id, entity_id, date, token_bucket;
-- key_market_usage_application_model_month_mv view
CREATE MATERIALIZED VIEW IF NOT EXISTS default.key_market_usage_application_model_month_mv TO default.key_market_usage_application_model_month (`month_start` Date, `account_id` String, `workspace_id` String, `application_id` String, `model` LowCardinality(String), `cost_sum` AggregateFunction(sum, UInt64), `prompt_token_sum` AggregateFunction(sum, UInt64), `completion_token_sum` AggregateFunction(sum, UInt64), `request_count` AggregateFunction(count)) AS SELECT toStartOfMonth(time) AS month_start, account_id, workspace_id, application_id, model, sumState(cost) AS cost_sum, sumState(prompt_token) AS prompt_token_sum, sumState(completion_token) AS completion_token_sum, countState() AS request_count FROM default.key_market_usage_logs WHERE (application_id != '') AND ((status = 'success') OR (status = '')) GROUP BY month_start, account_id, workspace_id, application_id, model;
-- key_market_usage_cost_by_upstream_month_mv view
CREATE MATERIALIZED VIEW IF NOT EXISTS default.key_market_usage_cost_by_upstream_month_mv TO default.key_market_usage_cost_by_upstream_month (`month_start` Date, `account_id` String, `upstream_id` String, `provider` String, `model` LowCardinality(String), `cost_sum` AggregateFunction(sum, UInt64)) AS SELECT toStartOfMonth(time) AS month_start, account_id, upstream_id, provider, model, sumState(cost) AS cost_sum FROM default.key_market_usage_logs WHERE (upstream_id != '') AND ((status = 'success') OR (status = '')) GROUP BY month_start, account_id, upstream_id, provider, model;
-- key_market_usage_health_by_model_provider_mv view
CREATE MATERIALIZED VIEW IF NOT EXISTS default.key_market_usage_health_by_model_provider_mv TO default.key_market_usage_health_by_model_provider (`bucket_start` DateTime('UTC'), `provider` String, `model` LowCardinality(String), `total_count` AggregateFunction(count), `success_count` AggregateFunction(countIf, UInt8), `failed_count` AggregateFunction(countIf, UInt8), `other_count` AggregateFunction(countIf, UInt8)) AS WITH multiIf((status = '') OR (status = 'success'), 'success', status = 'failed', 'failed', 'other') AS normalized_status SELECT toStartOfHour(time) AS bucket_start, provider, model, countState() AS total_count, countIfState(normalized_status = 'success') AS success_count, countIfState(normalized_status = 'failed') AS failed_count, countIfState(normalized_status = 'other') AS other_count FROM default.key_market_usage_logs GROUP BY bucket_start, provider, model;
-- key_market_usage_health_by_router_model_provider_mv view
CREATE MATERIALIZED VIEW IF NOT EXISTS default.key_market_usage_health_by_router_model_provider_mv TO default.key_market_usage_health_by_router_model_provider (`bucket_start` DateTime('UTC'), `provider` String, `model` LowCardinality(String), `router_id` String, `total_count` AggregateFunction(count), `success_count` AggregateFunction(countIf, UInt8), `failed_count` AggregateFunction(countIf, UInt8), `other_count` AggregateFunction(countIf, UInt8)) AS WITH multiIf((status = '') OR (status = 'success'), 'success', status = 'failed', 'failed', 'other') AS normalized_status SELECT toStartOfHour(time) AS bucket_start, provider, model, router_id, countState() AS total_count, countIfState(normalized_status = 'success') AS success_count, countIfState(normalized_status = 'failed') AS failed_count, countIfState(normalized_status = 'other') AS other_count FROM default.key_market_usage_logs WHERE router_id != '' GROUP BY bucket_start, provider, model, router_id;
-- key_market_usage_latency_by_model_provider_mv view
CREATE MATERIALIZED VIEW IF NOT EXISTS default.key_market_usage_latency_by_model_provider_mv TO default.key_market_usage_latency_by_model_provider (`provider` String, `model` LowCardinality(String), `latency_min` AggregateFunction(min, UInt64), `latency_max` AggregateFunction(max, UInt64), `latency_p50` AggregateFunction(quantileTDigest(0.5), UInt64)) AS SELECT provider, model, minState(latency) AS latency_min, maxState(latency) AS latency_max, quantileTDigestState(0.5)(latency) AS latency_p50 FROM default.key_market_usage_logs GROUP BY provider, model;
-- key_market_usage_partner_month_mv view
CREATE MATERIALIZED VIEW IF NOT EXISTS default.key_market_usage_partner_month_mv TO default.key_market_usage_partner_month (`month_start` Date, `account_id` String, `partner_id` String, `cost_sum` AggregateFunction(sum, UInt64), `commission_sum` AggregateFunction(sum, UInt64), `request_count` AggregateFunction(count)) AS SELECT toStartOfMonth(time) AS month_start, account_id, partner_id, sumState(cost) AS cost_sum, sumState(commission_amount) AS commission_sum, countState() AS request_count FROM default.key_market_usage_logs WHERE (partner_id != '') AND ((status = 'success') OR (status = '')) GROUP BY month_start, account_id, partner_id;
-- organization_properties_mv view
CREATE MATERIALIZED VIEW IF NOT EXISTS default.organization_properties_mv TO default.organization_properties (`organization_id` UUID, `property_key` String) AS SELECT workspace_id AS organization_id, arrayJoin(mapKeys(properties)) AS property_key FROM default.request_response_rmt WHERE length(mapKeys(properties)) > 0;
-- organization_ptb_spend_mv view
CREATE MATERIALIZED VIEW IF NOT EXISTS default.organization_ptb_spend_mv TO default.organization_ptb_spend (`organization_id` UUID, `spend` UInt64) AS SELECT workspace_id AS organization_id, sum(cost) AS spend FROM default.request_response_rmt WHERE is_passthrough_billing = true GROUP BY workspace_id;
-- prompt_usage_daily_mv view
CREATE MATERIALIZED VIEW IF NOT EXISTS default.prompt_usage_daily_mv TO default.prompt_usage_daily (`date` Date, `workspace_id` UUID, `prompt_id` String, `prompt_version` String, `entity_type` String, `entity_id` UUID, `request_count` UInt64, `cost_sum` UInt64, `prompt_tokens_sum` Int64, `completion_tokens_sum` Int64, `reasoning_tokens_sum` Int64, `latency_ms_sum` Int64, `success_count` UInt64, `error_count` UInt64) AS SELECT toDate(request_created_at) AS date, workspace_id, prompt_id, coalesce(nullIf(prompt_version, ''), 'unknown') AS prompt_version, if(entity_type = '', 'unknown', entity_type) AS entity_type, ifNull(entity_id, toUUID('00000000-0000-0000-0000-000000000000')) AS entity_id, count() AS request_count, sum(cost) AS cost_sum, sum(coalesce(prompt_tokens, 0)) AS prompt_tokens_sum, sum(coalesce(completion_tokens, 0)) AS completion_tokens_sum, sum(coalesce(reasoning_tokens, 0)) AS reasoning_tokens_sum, sum(coalesce(latency, 0)) AS latency_ms_sum, countIf((status >= 200) AND (status <= 299)) AS success_count, countIf(status >= 400) AS error_count FROM default.request_response_rmt WHERE (prompt_id != '') AND (prompt_id IS NOT NULL) GROUP BY date, workspace_id, prompt_id, prompt_version, entity_type, entity_id;
-- request_stats_mv view
CREATE MATERIALIZED VIEW IF NOT EXISTS default.request_stats_mv TO default.request_stats (`hour` DateTime, `model` LowCardinality(String), `provider` LowCardinality(String), `is_passthrough_billing` Bool, `total_prompt_tokens` Int64, `total_completion_tokens` Int64, `total_completion_audio_tokens` Int64, `total_prompt_audio_tokens` Int64, `total_prompt_cache_write_tokens` Int64, `total_prompt_cache_read_tokens` Int64, `latency_sum` Int64, `ttft_sum` Int64, `total_requests` UInt64, `successful_requests` UInt64) AS SELECT toStartOfHour(request_created_at) AS hour, model, provider, is_passthrough_billing, sum(coalesce(prompt_tokens, 0)) AS total_prompt_tokens, sum(coalesce(completion_tokens, 0)) AS total_completion_tokens, sum(completion_audio_tokens) AS total_completion_audio_tokens, sum(prompt_audio_tokens) AS total_prompt_audio_tokens, sum(prompt_cache_write_tokens) AS total_prompt_cache_write_tokens, sum(prompt_cache_read_tokens) AS total_prompt_cache_read_tokens, sum(coalesce(latency, 0)) AS latency_sum, sum(coalesce(time_to_first_token, 0)) AS ttft_sum, count(*) AS total_requests, countIf((status >= 200) AND (status <= 299)) AS successful_requests FROM default.request_response_rmt WHERE request_referrer = 'ai-gateway' GROUP BY hour, model, provider, is_passthrough_billing;
-- usage_aggregates_daily_mv view
CREATE MATERIALIZED VIEW IF NOT EXISTS default.usage_aggregates_daily_mv TO default.usage_aggregates_daily (`date` Date, `workspace_id` UUID, `department_id` UUID, `entity_type` String, `entity_id` UUID, `model` LowCardinality(String), `provider` LowCardinality(String), `master_key_id` UUID, `entity_name` LowCardinality(String), `request_count` UInt64, `cost_sum` UInt64, `prompt_tokens_sum` Int64, `prompt_cache_read_tokens_sum` Int64, `completion_tokens_sum` Int64, `reasoning_tokens_sum` Int64, `latency_ms_sum` Int64, `success_count` UInt64, `error_count` UInt64, `last_event_at` DateTime64(3)) AS SELECT toDate(request_created_at) AS date, workspace_id, department_id, if(entity_type = '', 'unknown', entity_type) AS entity_type, entity_id, model, provider, ifNull(master_key_id, toUUID('00000000-0000-0000-0000-000000000000')) AS master_key_id, coalesce(nullIf(trimBoth(coalesce(entity_name, '')), ''), '') AS entity_name, count() AS request_count, sum(cost) AS cost_sum, sum(coalesce(prompt_tokens, 0)) AS prompt_tokens_sum, sum(coalesce(prompt_cache_read_tokens, 0)) AS prompt_cache_read_tokens_sum, sum(coalesce(completion_tokens, 0)) AS completion_tokens_sum, sum(coalesce(reasoning_tokens, 0)) AS reasoning_tokens_sum, sum(coalesce(latency, 0)) AS latency_ms_sum, countIf((status >= 200) AND (status <= 299)) AS success_count, countIf(status >= 400) AS error_count, max(now64(3)) AS last_event_at FROM default.request_response_rmt GROUP BY date, workspace_id, department_id, entity_type, entity_id, model, provider, master_key_id, entity_name;
-- usage_aggregates_hourly_mv view
CREATE MATERIALIZED VIEW IF NOT EXISTS default.usage_aggregates_hourly_mv TO default.usage_aggregates_hourly (`bucket_hour` DateTime, `workspace_id` UUID, `department_id` UUID, `entity_type` String, `entity_id` UUID, `entity_name` String, `model` LowCardinality(String), `provider` LowCardinality(String), `master_key_id` UUID, `request_count` UInt64, `cost_sum` UInt64, `prompt_tokens_sum` Int64, `completion_tokens_sum` Int64, `reasoning_tokens_sum` Int64, `prompt_cache_read_tokens_sum` Int64, `cache_hit_count` UInt64, `cache_miss_count` UInt64, `cache_saved_cost_sum` UInt64, `last_event_at` DateTime64(3)) AS SELECT bucket_hour, workspace_id, department_id, entity_type, entity_id, anyLast(r.entity_name) AS entity_name, model, provider, master_key_id, count() AS request_count, sum(cost) AS cost_sum, sum(coalesce(prompt_tokens, 0)) AS prompt_tokens_sum, sum(coalesce(completion_tokens, 0)) AS completion_tokens_sum, sum(coalesce(reasoning_tokens, 0)) AS reasoning_tokens_sum, sum(coalesce(prompt_cache_read_tokens, 0)) AS prompt_cache_read_tokens_sum, countIf(is_cache_hit) AS cache_hit_count, countIf(NOT is_cache_hit) AS cache_miss_count, sum(cache_saved_cost) AS cache_saved_cost_sum, max(now64(3)) AS last_event_at FROM (SELECT toStartOfHour(request_created_at) AS bucket_hour, workspace_id, department_id, if(entity_type = '', 'unknown', entity_type) AS entity_type, entity_id, coalesce(nullIf(trimBoth(coalesce(entity_name, '')), ''), '') AS entity_name, model, provider, ifNull(master_key_id, toUUID('00000000-0000-0000-0000-000000000000')) AS master_key_id, cost, cache_saved_cost, prompt_tokens, completion_tokens, reasoning_tokens, prompt_cache_read_tokens, cache_enabled, cache_reference_id, cache_enabled AND (cache_reference_id != '00000000-0000-0000-0000-000000000000') AS is_cache_hit FROM default.request_response_rmt) AS r GROUP BY bucket_hour, workspace_id, department_id, entity_type, entity_id, model, provider, master_key_id;
-- x402_revenue_daily_mv view
CREATE MATERIALIZED VIEW IF NOT EXISTS default.x402_revenue_daily_mv TO default.x402_revenue_daily (`date` Date, `workspace_id` UUID, `endpoint_id` UUID, `agent_id` UUID, `facilitator` LowCardinality(String), `network` LowCardinality(String), `asset` LowCardinality(String), `request_count` UInt64, `success_count` UInt64, `verified_count` UInt64, `gross_revenue_sum` Float64, `alephant_fee_sum` Float64, `net_revenue_sum` Float64, `ai_cost_sum` Float64, `last_event_at` DateTime64(3)) AS SELECT date, workspace_id, endpoint_id, agent_id, facilitator, network, asset, count(activity_id) AS request_count, countIf(service_status = 'succeeded') AS success_count, countIf(payment_status = 'verified') AS verified_count, sumIf(gross_revenue, (payment_status = 'verified') AND (settlement_status = 'settled')) AS gross_revenue_sum, sumIf(alephant_fee, (payment_status = 'verified') AND (settlement_status = 'settled')) AS alephant_fee_sum, sumIf(net_revenue, (payment_status = 'verified') AND (settlement_status = 'settled')) AS net_revenue_sum, sumIf(ai_cost, (payment_status = 'verified') AND (settlement_status = 'settled')) AS ai_cost_sum, max(now64(3)) AS last_event_at FROM (SELECT toDate(event_time) AS date, workspace_id, endpoint_id, agent_id, facilitator, network, asset, activity_id, service_status, payment_status, settlement_status, gross_revenue, alephant_fee, net_revenue, ai_cost FROM default.x402_activity_fact) AS activity GROUP BY date, workspace_id, endpoint_id, agent_id, facilitator, network, asset;