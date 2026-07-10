--
-- PostgreSQL database dump
--

\restrict b5n4ijRYtgdDoXrJNkjxGVAsnNiqUwz57yWAn8bnd3v1F6eZiXwvvmj5dvKM5MR

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: key_market_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.key_market_accounts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    status public.key_market_account_status_enum DEFAULT 'active'::public.key_market_account_status_enum NOT NULL,
    balance_micro_usd bigint DEFAULT 0 NOT NULL,
    reserved_micro_usd bigint DEFAULT 0 NOT NULL,
    stripe_customer_id text,
    coinbase_customer_ref text,
    restricted_reason text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT key_market_accounts_balance_check CHECK ((balance_micro_usd >= '-9223372036854770000'::bigint)),
    CONSTRAINT key_market_accounts_reserved_check CHECK ((reserved_micro_usd >= 0))
);


--
-- Name: key_market_alephant_observability_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.key_market_alephant_observability_links (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    key_market_api_key_id uuid CONSTRAINT key_market_alephant_observabilit_key_market_api_key_id_not_null NOT NULL,
    account_id uuid NOT NULL,
    workspace_id uuid NOT NULL,
    alephant_workspace_id uuid CONSTRAINT key_market_alephant_observabilit_alephant_workspace_id_not_null NOT NULL,
    alephant_master_key_id uuid CONSTRAINT key_market_alephant_observabili_alephant_master_key_id_not_null NOT NULL,
    alephant_agent_id uuid CONSTRAINT key_market_alephant_observability_li_alephant_agent_id_not_null NOT NULL,
    alephant_agent_name text CONSTRAINT key_market_alephant_observability__alephant_agent_name_not_null NOT NULL,
    alephant_virtual_key_id uuid CONSTRAINT key_market_alephant_observabil_alephant_virtual_key_id_not_null NOT NULL,
    alephant_virtual_key_name text CONSTRAINT key_market_alephant_observab_alephant_virtual_key_name_not_null NOT NULL,
    alephant_virtual_key_prefix text CONSTRAINT key_market_alephant_observa_alephant_virtual_key_prefi_not_null NOT NULL,
    alephant_department_id uuid,
    alephant_department_name text,
    input_output_logging_enabled boolean DEFAULT false CONSTRAINT key_market_alephant_observa_input_output_logging_enabl_not_null NOT NULL,
    status public.key_market_alephant_observability_status_enum DEFAULT 'active'::public.key_market_alephant_observability_status_enum NOT NULL,
    last_sync_error text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT key_market_alephant_observability_nonzero_uuid_check CHECK (((key_market_api_key_id <> '00000000-0000-0000-0000-000000000000'::uuid) AND (account_id <> '00000000-0000-0000-0000-000000000000'::uuid) AND (workspace_id <> '00000000-0000-0000-0000-000000000000'::uuid) AND (alephant_workspace_id <> '00000000-0000-0000-0000-000000000000'::uuid) AND (alephant_master_key_id <> '00000000-0000-0000-0000-000000000000'::uuid) AND (alephant_agent_id <> '00000000-0000-0000-0000-000000000000'::uuid) AND (alephant_virtual_key_id <> '00000000-0000-0000-0000-000000000000'::uuid) AND ((alephant_department_id IS NULL) OR (alephant_department_id <> '00000000-0000-0000-0000-000000000000'::uuid))))
);


--
-- Name: key_market_api_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.key_market_api_keys (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    account_id uuid NOT NULL,
    workspace_id uuid NOT NULL,
    label text NOT NULL,
    key_prefix text NOT NULL,
    key_hash bytea NOT NULL,
    masked_key text NOT NULL,
    status public.key_market_api_key_status_enum DEFAULT 'active'::public.key_market_api_key_status_enum NOT NULL,
    last_used_at timestamp with time zone,
    revoked_at timestamp with time zone,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    spend_limit_micro_usd bigint,
    encrypted_plaintext_key bytea,
    plaintext_key_nonce bytea,
    CONSTRAINT key_market_api_keys_label_len CHECK (((char_length(TRIM(BOTH FROM label)) >= 1) AND (char_length(TRIM(BOTH FROM label)) <= 120))),
    CONSTRAINT key_market_api_keys_plaintext_material_pair_check CHECK ((((encrypted_plaintext_key IS NULL) AND (plaintext_key_nonce IS NULL)) OR ((encrypted_plaintext_key IS NOT NULL) AND (plaintext_key_nonce IS NOT NULL)))),
    CONSTRAINT key_market_api_keys_spend_limit_micro_usd_check CHECK (((spend_limit_micro_usd IS NULL) OR (spend_limit_micro_usd > 0)))
);


--
-- Name: key_market_auto_reload_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.key_market_auto_reload_settings (
    account_id uuid NOT NULL,
    workspace_id uuid NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    threshold_micro_usd bigint DEFAULT 5000000 NOT NULL,
    reload_amount_micro_usd bigint DEFAULT 25000000 CONSTRAINT key_market_auto_reload_setting_reload_amount_micro_usd_not_null NOT NULL,
    stripe_payment_method_id text,
    max_reload_per_day integer DEFAULT 5 NOT NULL,
    max_reload_per_month integer DEFAULT 50 NOT NULL,
    last_triggered_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    cooldown_until timestamp with time zone,
    failure_count integer DEFAULT 0 NOT NULL,
    last_error_code text,
    last_failed_at timestamp with time zone,
    CONSTRAINT key_market_auto_reload_amounts_check CHECK (((threshold_micro_usd >= 0) AND (reload_amount_micro_usd > 0))),
    CONSTRAINT key_market_auto_reload_failure_count_nonnegative CHECK ((failure_count >= 0))
);


--
-- Name: key_market_cdp_deposit_destinations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.key_market_cdp_deposit_destinations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    topup_id uuid NOT NULL,
    account_id uuid NOT NULL,
    workspace_id uuid NOT NULL,
    cdp_account_id text NOT NULL,
    deposit_destination_id text CONSTRAINT key_market_cdp_deposit_destinat_deposit_destination_id_not_null NOT NULL,
    address text NOT NULL,
    network text NOT NULL,
    asset text DEFAULT 'USDC'::text NOT NULL,
    expected_amount_minor bigint CONSTRAINT key_market_cdp_deposit_destinati_expected_amount_minor_not_null NOT NULL,
    received_amount_minor bigint,
    transfer_id text,
    tx_hash text,
    status public.key_market_cdp_deposit_destination_status_enum DEFAULT 'created'::public.key_market_cdp_deposit_destination_status_enum NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    provider_payload jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    confirmed_at timestamp with time zone,
    provider text DEFAULT 'cdp'::text NOT NULL,
    review_reason text,
    last_reconciled_at timestamp with time zone,
    next_reconcile_at timestamp with time zone,
    reconciliation_attempts integer DEFAULT 0 CONSTRAINT key_market_cdp_deposit_destina_reconciliation_attempts_not_null NOT NULL,
    post_success_anomaly_count integer DEFAULT 0 CONSTRAINT key_market_cdp_deposit_dest_post_success_anomaly_count_not_null NOT NULL,
    last_post_success_anomaly_at timestamp with time zone,
    CONSTRAINT key_market_cdp_destinations_asset_check CHECK ((asset = 'USDC'::text)),
    CONSTRAINT key_market_cdp_destinations_expected_positive CHECK ((expected_amount_minor > 0)),
    CONSTRAINT key_market_cdp_destinations_provider_check CHECK ((provider = ANY (ARRAY['cdp'::text, 'helio'::text]))),
    CONSTRAINT key_market_cdp_destinations_received_nonnegative CHECK (((received_amount_minor IS NULL) OR (received_amount_minor >= 0)))
);


--
-- Name: key_market_ledger_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.key_market_ledger_entries (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    account_id uuid NOT NULL,
    workspace_id uuid NOT NULL,
    entry_type public.key_market_ledger_entry_type_enum NOT NULL,
    amount_micro_usd bigint NOT NULL,
    balance_after_micro_usd bigint NOT NULL,
    reserved_after_micro_usd bigint NOT NULL,
    idempotency_key text NOT NULL,
    source_table text NOT NULL,
    source_id uuid,
    actor_user_id uuid,
    reason text,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: key_market_model_prices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.key_market_model_prices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    public_model text NOT NULL,
    provider text NOT NULL,
    prompt bigint NOT NULL,
    completion bigint NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    badge text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    currency text DEFAULT 'USD'::text NOT NULL,
    billing_type text DEFAULT 'usage_flat'::text NOT NULL,
    billing_unit text DEFAULT 'token'::text NOT NULL,
    modalities text[] DEFAULT ARRAY['chat'::text] NOT NULL,
    context_window_tokens bigint,
    max_output_tokens bigint,
    cache_creation_prompt bigint,
    cache_read_prompt bigint,
    pricing_tiers jsonb DEFAULT '[]'::jsonb NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    supported_features text[] DEFAULT ARRAY[]::text[] NOT NULL,
    model_release_date date,
    actual_prompt bigint NOT NULL,
    actual_completion bigint NOT NULL,
    discount_bps integer DEFAULT 10000 NOT NULL,
    provider_kind text DEFAULT 'third_party'::text NOT NULL,
    is_lowest_price boolean DEFAULT false NOT NULL,
    provider_logo_url text DEFAULT ''::text NOT NULL,
    partner_price_multiplier_bps integer DEFAULT 10500 NOT NULL,
    partner_prompt bigint DEFAULT 0 NOT NULL,
    partner_completion bigint DEFAULT 0 NOT NULL,
    partner_cache_creation_prompt bigint,
    partner_cache_read_prompt bigint,
    CONSTRAINT key_market_model_prices_actual_amount_check CHECK (((actual_prompt >= 0) AND (actual_completion >= 0))),
    CONSTRAINT key_market_model_prices_amount_check CHECK (((prompt >= 0) AND (completion >= 0))),
    CONSTRAINT key_market_model_prices_billing_type_check CHECK ((billing_type = ANY (ARRAY['usage_flat'::text, 'usage_tiered'::text, 'per_request'::text, 'duration'::text, 'per_image'::text]))),
    CONSTRAINT key_market_model_prices_billing_unit_check CHECK ((billing_unit = ANY (ARRAY['token'::text, 'request'::text, 'second'::text, 'minute'::text, 'image'::text]))),
    CONSTRAINT key_market_model_prices_currency_check CHECK ((currency = ANY (ARRAY['USD'::text, 'CNY'::text]))),
    CONSTRAINT key_market_model_prices_discount_bps_check CHECK (((discount_bps >= 0) AND (discount_bps <= 1000000))),
    CONSTRAINT key_market_model_prices_metadata_amount_check CHECK ((((context_window_tokens IS NULL) OR (context_window_tokens >= 0)) AND ((max_output_tokens IS NULL) OR (max_output_tokens >= 0)) AND ((cache_creation_prompt IS NULL) OR (cache_creation_prompt >= 0)) AND ((cache_read_prompt IS NULL) OR (cache_read_prompt >= 0)))),
    CONSTRAINT key_market_model_prices_modalities_check CHECK (((cardinality(modalities) > 0) AND (array_position(modalities, NULL::text) IS NULL))),
    CONSTRAINT key_market_model_prices_partner_price_multiplier_bps_check CHECK (((partner_price_multiplier_bps >= 0) AND (partner_price_multiplier_bps <= 1000000))),
    CONSTRAINT key_market_model_prices_pricing_tiers_array_check CHECK ((jsonb_typeof(pricing_tiers) = 'array'::text)),
    CONSTRAINT key_market_model_prices_supported_features_check CHECK (((array_position(supported_features, NULL::text) IS NULL) AND (supported_features <@ ARRAY['tool_calling'::text, 'reasoning'::text, 'content_caching'::text, 'structured_outputs'::text, 'json_mode'::text, 'vision'::text, 'image_generation'::text, 'audio_input'::text, 'audio_output'::text, 'embeddings'::text, 'reranking'::text])))
);


--
-- Name: key_market_model_routes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.key_market_model_routes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    public_model text NOT NULL,
    upstream_model text NOT NULL,
    provider text NOT NULL,
    upstream_key_id uuid,
    status public.key_market_route_status_enum DEFAULT 'active'::public.key_market_route_status_enum NOT NULL,
    priority integer DEFAULT 100 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    model_price_id uuid NOT NULL,
    is_default_route boolean DEFAULT false NOT NULL
);


--
-- Name: key_market_payment_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.key_market_payment_events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    account_id uuid,
    workspace_id uuid,
    topup_id uuid,
    provider public.key_market_payment_provider_enum NOT NULL,
    event_type text NOT NULL,
    event_dedupe_key text NOT NULL,
    economic_event_key text,
    provider_event_id text,
    provider_object_id text,
    status text NOT NULL,
    amount_minor bigint,
    currency text,
    received_at timestamp with time zone DEFAULT now() NOT NULL,
    processed_at timestamp with time zone,
    payload jsonb DEFAULT '{}'::jsonb NOT NULL,
    CONSTRAINT key_market_payment_events_topup_account_workspace_null_check CHECK ((((topup_id IS NULL) AND (account_id IS NULL) AND (workspace_id IS NULL)) OR ((topup_id IS NOT NULL) AND (account_id IS NOT NULL) AND (workspace_id IS NOT NULL))))
);


--
-- Name: key_market_provider_bridge_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.key_market_provider_bridge_links (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    account_id uuid NOT NULL,
    workspace_id uuid NOT NULL,
    key_market_api_key_id uuid NOT NULL,
    master_key_id uuid NOT NULL,
    status public.key_market_bridge_status_enum NOT NULL,
    error_message text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: key_market_reservations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.key_market_reservations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    account_id uuid NOT NULL,
    workspace_id uuid NOT NULL,
    api_key_id uuid NOT NULL,
    request_id text NOT NULL,
    model text NOT NULL,
    estimated_cost_micro_usd bigint NOT NULL,
    final_cost_micro_usd bigint,
    status public.key_market_reservation_status_enum DEFAULT 'reserved'::public.key_market_reservation_status_enum NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    committed_at timestamp with time zone,
    released_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT key_market_reservations_estimated_nonnegative CHECK ((estimated_cost_micro_usd >= 0)),
    CONSTRAINT key_market_reservations_final_nonnegative CHECK (((final_cost_micro_usd IS NULL) OR (final_cost_micro_usd >= 0)))
);


--
-- Name: key_market_topup_bonus_claims; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.key_market_topup_bonus_claims (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    account_id uuid NOT NULL,
    workspace_id uuid NOT NULL,
    topup_id uuid NOT NULL,
    topup_amount_micro_usd bigint NOT NULL,
    bonus_amount_micro_usd bigint DEFAULT 0 NOT NULL,
    tier_min_micro_usd bigint,
    awarded boolean DEFAULT false NOT NULL,
    config_end_at_utc timestamp with time zone,
    ledger_entry_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT key_market_topup_bonus_claims_award_consistency CHECK ((((awarded = false) AND (bonus_amount_micro_usd = 0) AND (tier_min_micro_usd IS NULL) AND (config_end_at_utc IS NULL) AND (ledger_entry_id IS NULL)) OR ((awarded = true) AND (bonus_amount_micro_usd > 0) AND (tier_min_micro_usd > 0) AND (config_end_at_utc IS NOT NULL) AND (ledger_entry_id IS NOT NULL)))),
    CONSTRAINT key_market_topup_bonus_claims_bonus_nonnegative CHECK ((bonus_amount_micro_usd >= 0)),
    CONSTRAINT key_market_topup_bonus_claims_topup_amount_positive CHECK ((topup_amount_micro_usd > 0))
);


--
-- Name: key_market_topups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.key_market_topups (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    account_id uuid NOT NULL,
    workspace_id uuid NOT NULL,
    provider public.key_market_payment_provider_enum NOT NULL,
    status public.key_market_topup_status_enum DEFAULT 'created'::public.key_market_topup_status_enum NOT NULL,
    trigger_type text DEFAULT 'manual'::text NOT NULL,
    requested_amount_micro_usd bigint NOT NULL,
    credited_amount_micro_usd bigint DEFAULT 0 NOT NULL,
    provider_currency text NOT NULL,
    provider_requested_amount_minor bigint NOT NULL,
    provider_received_amount_minor bigint,
    fx_rate_source text NOT NULL,
    fx_rate_usd_cny numeric(18,8) NOT NULL,
    converted_cny_amount_minor bigint NOT NULL,
    stripe_checkout_session_id text,
    stripe_payment_intent_id text,
    stripe_charge_id text,
    coinbase_charge_id text,
    coinbase_network text,
    coinbase_tx_hash text,
    return_path text NOT NULL,
    provider_payload jsonb DEFAULT '{}'::jsonb NOT NULL,
    failure_code text,
    failure_message text,
    stripe_dispute_id text,
    dispute_amount_units bigint,
    dispute_currency text,
    dispute_reason text,
    dispute_status text,
    dispute_opened_at timestamp with time zone,
    dispute_resolved_at timestamp with time zone,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    succeeded_at timestamp with time zone,
    stripe_invoice_id text,
    CONSTRAINT key_market_topups_converted_cny_positive CHECK ((converted_cny_amount_minor > 0)),
    CONSTRAINT key_market_topups_credited_nonnegative CHECK ((credited_amount_micro_usd >= 0)),
    CONSTRAINT key_market_topups_fx_rate_positive CHECK ((fx_rate_usd_cny > (0)::numeric)),
    CONSTRAINT key_market_topups_requested_positive CHECK ((requested_amount_micro_usd > 0))
);


--
-- Name: key_market_upstream_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.key_market_upstream_keys (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider text NOT NULL,
    label text NOT NULL,
    base_url text NOT NULL,
    auth_type text DEFAULT 'Authorization'::text NOT NULL,
    encrypted_api_key bytea NOT NULL,
    nonce bytea NOT NULL,
    masked_key text NOT NULL,
    status public.key_market_upstream_key_status_enum DEFAULT 'active'::public.key_market_upstream_key_status_enum NOT NULL,
    weight integer DEFAULT 100 NOT NULL,
    cost_multiplier_bps integer DEFAULT 10000 NOT NULL,
    last_health_status text,
    last_health_checked_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT key_market_upstream_auth_type_len CHECK (((char_length(TRIM(BOTH FROM auth_type)) >= 1) AND (char_length(TRIM(BOTH FROM auth_type)) <= 80))),
    CONSTRAINT key_market_upstream_cost_multiplier_bps_check CHECK (((cost_multiplier_bps >= 0) AND (cost_multiplier_bps <= 10000))),
    CONSTRAINT key_market_upstream_weight_check CHECK ((weight >= 0))
);


--
-- Name: key_market_usage_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.key_market_usage_records (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    account_id uuid NOT NULL,
    workspace_id uuid NOT NULL,
    api_key_id uuid NOT NULL,
    reservation_id uuid NOT NULL,
    request_id text NOT NULL,
    occurred_at timestamp with time zone NOT NULL,
    model text NOT NULL,
    upstream_provider text,
    input_tokens bigint NOT NULL,
    output_tokens bigint NOT NULL,
    cost_micro_usd bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT key_market_usage_cost_check CHECK ((cost_micro_usd >= 0)),
    CONSTRAINT key_market_usage_tokens_check CHECK (((input_tokens >= 0) AND (output_tokens >= 0)))
);


--
-- Name: key_market_video_task_ledgers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.key_market_video_task_ledgers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    task_id text NOT NULL,
    upstream_task_id text NOT NULL,
    endpoint text NOT NULL,
    query_path text NOT NULL,
    api_key_id uuid NOT NULL,
    api_key_hash text NOT NULL,
    account_id uuid NOT NULL,
    public_model text NOT NULL,
    upstream_model text NOT NULL,
    upstream_id uuid NOT NULL,
    reservation_id text NOT NULL,
    request_id text NOT NULL,
    idempotency_key text,
    input_mode text NOT NULL,
    resolution text NOT NULL,
    price_completion bigint NOT NULL,
    fx_rate_usd_cny numeric(20,8) NOT NULL,
    minimum_authorization_micro_usd bigint CONSTRAINT key_market_video_task_ledge_minimum_authorization_micr_not_null NOT NULL,
    reserved_micro_usd bigint NOT NULL,
    settled_micro_usd bigint,
    task_status text DEFAULT 'queued'::text NOT NULL,
    billing_status text DEFAULT 'reserved'::text NOT NULL,
    upstream_status text,
    result_video_url text,
    error_code text,
    error_message text,
    response_body jsonb,
    retrieval_status text DEFAULT 'not_ready'::text NOT NULL,
    retrieved_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    next_poll_at timestamp with time zone,
    finalized_at timestamp with time zone,
    estimated_prompt_tokens bigint DEFAULT 0 NOT NULL,
    estimated_completion_tokens bigint DEFAULT 0 CONSTRAINT key_market_video_task_ledge_estimated_completion_token_not_null NOT NULL,
    estimate_micro_usd bigint DEFAULT 0 NOT NULL,
    estimate_cost_cny text DEFAULT '0'::text NOT NULL,
    billing_type text DEFAULT 'usage_flat'::text NOT NULL,
    billing_unit text DEFAULT 'token'::text NOT NULL,
    billing_quantity text DEFAULT '0'::text NOT NULL,
    billing_quantity_source text DEFAULT 'request_body'::text NOT NULL,
    settlement_basis text DEFAULT 'prepared_estimate'::text NOT NULL,
    measurement_version integer DEFAULT 1 NOT NULL,
    matched_tier text,
    ratio text DEFAULT '16:9'::text NOT NULL,
    width bigint DEFAULT 0 NOT NULL,
    height bigint DEFAULT 0 NOT NULL,
    fps bigint DEFAULT 24 NOT NULL,
    duration_seconds bigint DEFAULT 0 NOT NULL,
    generate_audio boolean DEFAULT false NOT NULL,
    measurement_metadata jsonb DEFAULT '{}'::jsonb NOT NULL
);


--
-- Name: openmodel_account_subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.openmodel_account_subscriptions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    account_id uuid NOT NULL,
    plan_code text NOT NULL,
    status text NOT NULL,
    stripe_customer_id text,
    stripe_subscription_id text,
    current_period_start timestamp with time zone,
    current_period_end timestamp with time zone,
    cancel_at_period_end boolean DEFAULT false NOT NULL,
    canceled_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    product_type text DEFAULT 'credits'::text NOT NULL
);


--
-- Name: openmodel_subscription_invoices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.openmodel_subscription_invoices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    account_id uuid NOT NULL,
    subscription_id uuid,
    plan_code text NOT NULL,
    stripe_invoice_id text NOT NULL,
    stripe_subscription_id text,
    stripe_customer_id text,
    stripe_payment_intent_id text,
    stripe_invoice_status text,
    stripe_billing_reason text,
    currency text DEFAULT 'usd'::text NOT NULL,
    stripe_amount_paid_minor bigint DEFAULT 0 CONSTRAINT openmodel_subscription_invoic_stripe_amount_paid_minor_not_null NOT NULL,
    recharge_amount_micro_usd bigint CONSTRAINT openmodel_subscription_invoi_recharge_amount_micro_usd_not_null NOT NULL,
    bonus_amount_micro_usd bigint DEFAULT 0 NOT NULL,
    credited_amount_micro_usd bigint CONSTRAINT openmodel_subscription_invoi_credited_amount_micro_usd_not_null NOT NULL,
    payment_ledger_entry_id uuid,
    bonus_ledger_entry_id uuid,
    credited_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    product_type text DEFAULT 'credits'::text NOT NULL,
    CONSTRAINT openmodel_subscription_invoices_bonus_amount_micro_usd_check CHECK ((bonus_amount_micro_usd >= 0)),
    CONSTRAINT openmodel_subscription_invoices_credited_amount_micro_usd_check CHECK ((credited_amount_micro_usd >= 0)),
    CONSTRAINT openmodel_subscription_invoices_recharge_amount_micro_usd_check CHECK ((recharge_amount_micro_usd >= 0))
);


--
-- Name: openmodel_subscription_plans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.openmodel_subscription_plans (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code text NOT NULL,
    name text NOT NULL,
    amount_usd integer NOT NULL,
    amount_micro_usd bigint NOT NULL,
    bonus_amount_micro_usd bigint DEFAULT 0 NOT NULL,
    stripe_price_id text NOT NULL,
    active boolean DEFAULT true NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    product_type text DEFAULT 'credits'::text NOT NULL,
    CONSTRAINT openmodel_subscription_plans_amount_micro_usd_check CHECK ((amount_micro_usd > 0)),
    CONSTRAINT openmodel_subscription_plans_amount_usd_check CHECK ((amount_usd > 0)),
    CONSTRAINT openmodel_subscription_plans_bonus_amount_micro_usd_check CHECK ((bonus_amount_micro_usd >= 0))
);


--
-- Name: openmodels_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.openmodels_accounts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email character varying(255) NOT NULL,
    password_hash text NOT NULL,
    display_name character varying(100) NOT NULL,
    avatar_url text,
    status text DEFAULT 'active'::text NOT NULL,
    oauth_provider text DEFAULT 'email'::text NOT NULL,
    two_factor_enabled boolean DEFAULT false NOT NULL,
    totp_secret_encrypted bytea,
    totp_backup_codes_hash text,
    totp_pending_secret_encrypted bytea,
    totp_pending_backup_codes_hash text,
    password_reset_token_hash text,
    password_reset_expires_at timestamp with time zone,
    email_otp_hash text,
    email_otp_expires_at timestamp with time zone,
    email_otp_token_hash text,
    email_otp_token_expires_at timestamp with time zone,
    last_seen_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    referral_code text,
    referrer_account_id uuid,
    referral_status text DEFAULT 'none'::text NOT NULL,
    partner_id text,
    CONSTRAINT openmodels_accounts_oauth_provider_check CHECK ((oauth_provider = ANY (ARRAY['email'::text, 'google'::text, 'github'::text]))),
    CONSTRAINT openmodels_accounts_referral_status_check CHECK ((referral_status = ANY (ARRAY['none'::text, 'pending'::text, 'credited'::text, 'invalid'::text]))),
    CONSTRAINT openmodels_accounts_referral_status_referrer_check CHECK ((((referral_status = 'none'::text) AND (referrer_account_id IS NULL)) OR ((referral_status = ANY (ARRAY['pending'::text, 'credited'::text, 'invalid'::text])) AND (referrer_account_id IS NOT NULL)))),
    CONSTRAINT openmodels_accounts_referrer_not_self CHECK (((referrer_account_id IS NULL) OR (referrer_account_id <> id))),
    CONSTRAINT openmodels_accounts_status_check CHECK ((status = ANY (ARRAY['active'::text, 'suspended'::text, 'disabled'::text])))
);


--
-- Name: openmodels_referral_cashback_awards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.openmodels_referral_cashback_awards (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    referred_account_id uuid CONSTRAINT openmodels_referral_cashback_award_referred_account_id_not_null NOT NULL,
    referrer_account_id uuid CONSTRAINT openmodels_referral_cashback_award_referrer_account_id_not_null NOT NULL,
    trigger_topup_id uuid,
    referred_cumulative_topup_micro_usd bigint CONSTRAINT openmodels_referral_cashbac_referred_cumulative_topup__not_null NOT NULL,
    entitled_cashback_micro_usd bigint CONSTRAINT openmodels_referral_cashbac_entitled_cashback_micro_us_not_null NOT NULL,
    previous_awarded_micro_usd bigint CONSTRAINT openmodels_referral_cashbac_previous_awarded_micro_usd_not_null NOT NULL,
    award_amount_micro_usd bigint CONSTRAINT openmodels_referral_cashback_aw_award_amount_micro_usd_not_null NOT NULL,
    ledger_entry_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    trigger_source_table text CONSTRAINT openmodels_referral_cashback_awar_trigger_source_table_not_null NOT NULL,
    trigger_source_id uuid NOT NULL,
    CONSTRAINT openmodels_referral_cashback_awards_amount_positive CHECK ((award_amount_micro_usd > 0)),
    CONSTRAINT openmodels_referral_cashback_awards_not_self CHECK ((referred_account_id <> referrer_account_id)),
    CONSTRAINT openmodels_referral_cashback_awards_totals_valid CHECK (((referred_cumulative_topup_micro_usd >= 0) AND (entitled_cashback_micro_usd >= 0) AND (previous_awarded_micro_usd >= 0) AND (entitled_cashback_micro_usd > previous_awarded_micro_usd) AND (award_amount_micro_usd = (entitled_cashback_micro_usd - previous_awarded_micro_usd)))),
    CONSTRAINT openmodels_referral_cashback_awards_trigger_source_valid CHECK ((((trigger_source_table = 'key_market_topups'::text) AND (trigger_topup_id IS NOT NULL) AND (trigger_source_id = trigger_topup_id)) OR ((trigger_source_table = 'openmodel_subscription_invoices'::text) AND (trigger_topup_id IS NULL))))
);


--
-- Name: openmodels_referral_rewards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.openmodels_referral_rewards (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    referred_account_id uuid NOT NULL,
    referrer_account_id uuid NOT NULL,
    account_id uuid NOT NULL,
    role text NOT NULL,
    amount_micro_usd bigint NOT NULL,
    ledger_entry_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT openmodels_referral_rewards_account_role_check CHECK ((((role = 'referrer'::text) AND (account_id = referrer_account_id)) OR ((role = 'referred'::text) AND (account_id = referred_account_id)))),
    CONSTRAINT openmodels_referral_rewards_amount_positive CHECK ((amount_micro_usd > 0)),
    CONSTRAINT openmodels_referral_rewards_not_self CHECK ((referred_account_id <> referrer_account_id)),
    CONSTRAINT openmodels_referral_rewards_role_check CHECK ((role = ANY (ARRAY['referrer'::text, 'referred'::text])))
);


--
-- Name: openmodels_refresh_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.openmodels_refresh_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    account_id uuid NOT NULL,
    token_hash character varying(64) NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    revoked_at timestamp with time zone,
    user_agent text,
    ip_address inet,
    location text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: key_market_accounts key_market_accounts_id_workspace_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_accounts
    ADD CONSTRAINT key_market_accounts_id_workspace_unique UNIQUE (id, workspace_id);


--
-- Name: key_market_accounts key_market_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_accounts
    ADD CONSTRAINT key_market_accounts_pkey PRIMARY KEY (id);


--
-- Name: key_market_accounts key_market_accounts_workspace_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_accounts
    ADD CONSTRAINT key_market_accounts_workspace_unique UNIQUE (workspace_id);


--
-- Name: key_market_alephant_observability_links key_market_alephant_observability_lin_key_market_api_key_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_alephant_observability_links
    ADD CONSTRAINT key_market_alephant_observability_lin_key_market_api_key_id_key UNIQUE (key_market_api_key_id);


--
-- Name: key_market_alephant_observability_links key_market_alephant_observability_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_alephant_observability_links
    ADD CONSTRAINT key_market_alephant_observability_links_pkey PRIMARY KEY (id);


--
-- Name: key_market_api_keys key_market_api_keys_hash_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_api_keys
    ADD CONSTRAINT key_market_api_keys_hash_unique UNIQUE (key_hash);


--
-- Name: key_market_api_keys key_market_api_keys_id_account_workspace_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_api_keys
    ADD CONSTRAINT key_market_api_keys_id_account_workspace_unique UNIQUE (id, account_id, workspace_id);


--
-- Name: key_market_api_keys key_market_api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_api_keys
    ADD CONSTRAINT key_market_api_keys_pkey PRIMARY KEY (id);


--
-- Name: key_market_auto_reload_settings key_market_auto_reload_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_auto_reload_settings
    ADD CONSTRAINT key_market_auto_reload_settings_pkey PRIMARY KEY (account_id);


--
-- Name: key_market_provider_bridge_links key_market_bridge_key_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_provider_bridge_links
    ADD CONSTRAINT key_market_bridge_key_unique UNIQUE (key_market_api_key_id);


--
-- Name: key_market_provider_bridge_links key_market_bridge_master_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_provider_bridge_links
    ADD CONSTRAINT key_market_bridge_master_unique UNIQUE (master_key_id);


--
-- Name: key_market_cdp_deposit_destinations key_market_cdp_deposit_destinations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_cdp_deposit_destinations
    ADD CONSTRAINT key_market_cdp_deposit_destinations_pkey PRIMARY KEY (id);


--
-- Name: key_market_cdp_deposit_destinations key_market_cdp_destinations_provider_destination_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_cdp_deposit_destinations
    ADD CONSTRAINT key_market_cdp_destinations_provider_destination_unique UNIQUE (provider, deposit_destination_id);


--
-- Name: key_market_cdp_deposit_destinations key_market_cdp_destinations_topup_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_cdp_deposit_destinations
    ADD CONSTRAINT key_market_cdp_destinations_topup_unique UNIQUE (topup_id);


--
-- Name: key_market_ledger_entries key_market_ledger_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_ledger_entries
    ADD CONSTRAINT key_market_ledger_entries_pkey PRIMARY KEY (id);


--
-- Name: key_market_ledger_entries key_market_ledger_idempotency_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_ledger_entries
    ADD CONSTRAINT key_market_ledger_idempotency_unique UNIQUE (idempotency_key);


--
-- Name: key_market_model_prices key_market_model_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_model_prices
    ADD CONSTRAINT key_market_model_prices_pkey PRIMARY KEY (id);


--
-- Name: key_market_model_prices key_market_model_prices_public_provider_billing_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_model_prices
    ADD CONSTRAINT key_market_model_prices_public_provider_billing_unique UNIQUE (public_model, provider, billing_type, billing_unit);


--
-- Name: key_market_model_routes key_market_model_routes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_model_routes
    ADD CONSTRAINT key_market_model_routes_pkey PRIMARY KEY (id);


--
-- Name: key_market_payment_events key_market_payment_events_dedupe_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_payment_events
    ADD CONSTRAINT key_market_payment_events_dedupe_unique UNIQUE (provider, event_dedupe_key);


--
-- Name: key_market_payment_events key_market_payment_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_payment_events
    ADD CONSTRAINT key_market_payment_events_pkey PRIMARY KEY (id);


--
-- Name: key_market_provider_bridge_links key_market_provider_bridge_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_provider_bridge_links
    ADD CONSTRAINT key_market_provider_bridge_links_pkey PRIMARY KEY (id);


--
-- Name: key_market_reservations key_market_reservations_id_account_workspace_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_reservations
    ADD CONSTRAINT key_market_reservations_id_account_workspace_unique UNIQUE (id, account_id, workspace_id);


--
-- Name: key_market_reservations key_market_reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_reservations
    ADD CONSTRAINT key_market_reservations_pkey PRIMARY KEY (id);


--
-- Name: key_market_reservations key_market_reservations_request_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_reservations
    ADD CONSTRAINT key_market_reservations_request_unique UNIQUE (request_id);


--
-- Name: key_market_topup_bonus_claims key_market_topup_bonus_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_topup_bonus_claims
    ADD CONSTRAINT key_market_topup_bonus_claims_pkey PRIMARY KEY (id);


--
-- Name: key_market_topup_bonus_claims key_market_topup_bonus_claims_topup_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_topup_bonus_claims
    ADD CONSTRAINT key_market_topup_bonus_claims_topup_unique UNIQUE (topup_id);


--
-- Name: key_market_topup_bonus_claims key_market_topup_bonus_claims_user_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_topup_bonus_claims
    ADD CONSTRAINT key_market_topup_bonus_claims_user_unique UNIQUE (user_id);


--
-- Name: key_market_topups key_market_topups_id_account_workspace_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_topups
    ADD CONSTRAINT key_market_topups_id_account_workspace_unique UNIQUE (id, account_id, workspace_id);


--
-- Name: key_market_topups key_market_topups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_topups
    ADD CONSTRAINT key_market_topups_pkey PRIMARY KEY (id);


--
-- Name: key_market_upstream_keys key_market_upstream_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_upstream_keys
    ADD CONSTRAINT key_market_upstream_keys_pkey PRIMARY KEY (id);


--
-- Name: key_market_usage_records key_market_usage_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_usage_records
    ADD CONSTRAINT key_market_usage_records_pkey PRIMARY KEY (id);


--
-- Name: key_market_usage_records key_market_usage_request_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_usage_records
    ADD CONSTRAINT key_market_usage_request_unique UNIQUE (request_id);


--
-- Name: key_market_video_task_ledgers key_market_video_task_ledgers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_video_task_ledgers
    ADD CONSTRAINT key_market_video_task_ledgers_pkey PRIMARY KEY (id);


--
-- Name: openmodel_account_subscriptions openmodel_account_subscriptions_account_product_type_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodel_account_subscriptions
    ADD CONSTRAINT openmodel_account_subscriptions_account_product_type_unique UNIQUE (account_id, product_type);


--
-- Name: openmodel_account_subscriptions openmodel_account_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodel_account_subscriptions
    ADD CONSTRAINT openmodel_account_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: openmodel_subscription_invoices openmodel_subscription_invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodel_subscription_invoices
    ADD CONSTRAINT openmodel_subscription_invoices_pkey PRIMARY KEY (id);


--
-- Name: openmodel_subscription_invoices openmodel_subscription_invoices_stripe_invoice_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodel_subscription_invoices
    ADD CONSTRAINT openmodel_subscription_invoices_stripe_invoice_id_key UNIQUE (stripe_invoice_id);


--
-- Name: openmodel_subscription_plans openmodel_subscription_plans_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodel_subscription_plans
    ADD CONSTRAINT openmodel_subscription_plans_code_key UNIQUE (code);


--
-- Name: openmodel_subscription_plans openmodel_subscription_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodel_subscription_plans
    ADD CONSTRAINT openmodel_subscription_plans_pkey PRIMARY KEY (id);


--
-- Name: openmodel_subscription_plans openmodel_subscription_plans_stripe_price_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodel_subscription_plans
    ADD CONSTRAINT openmodel_subscription_plans_stripe_price_id_key UNIQUE (stripe_price_id);


--
-- Name: openmodels_accounts openmodels_accounts_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodels_accounts
    ADD CONSTRAINT openmodels_accounts_email_key UNIQUE (email);


--
-- Name: openmodels_accounts openmodels_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodels_accounts
    ADD CONSTRAINT openmodels_accounts_pkey PRIMARY KEY (id);


--
-- Name: openmodels_referral_cashback_awards openmodels_referral_cashback_awards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodels_referral_cashback_awards
    ADD CONSTRAINT openmodels_referral_cashback_awards_pkey PRIMARY KEY (id);


--
-- Name: openmodels_referral_rewards openmodels_referral_rewards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodels_referral_rewards
    ADD CONSTRAINT openmodels_referral_rewards_pkey PRIMARY KEY (id);


--
-- Name: openmodels_referral_rewards openmodels_referral_rewards_referred_role_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodels_referral_rewards
    ADD CONSTRAINT openmodels_referral_rewards_referred_role_unique UNIQUE (referred_account_id, role);


--
-- Name: openmodels_refresh_sessions openmodels_refresh_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodels_refresh_sessions
    ADD CONSTRAINT openmodels_refresh_sessions_pkey PRIMARY KEY (id);


--
-- Name: idx_key_market_alephant_observability_workspace; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_key_market_alephant_observability_workspace ON public.key_market_alephant_observability_links USING btree (workspace_id, status);


--
-- Name: key_market_api_keys_workspace_created_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX key_market_api_keys_workspace_created_idx ON public.key_market_api_keys USING btree (workspace_id, created_at DESC);


--
-- Name: key_market_auto_reload_pending_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX key_market_auto_reload_pending_unique ON public.key_market_topups USING btree (account_id) WHERE ((trigger_type = 'auto_reload'::text) AND (status = ANY (ARRAY['created'::public.key_market_topup_status_enum, 'pending_provider'::public.key_market_topup_status_enum])));


--
-- Name: key_market_cdp_destinations_helio_reconcile_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX key_market_cdp_destinations_helio_reconcile_idx ON public.key_market_cdp_deposit_destinations USING btree (provider, status, next_reconcile_at, created_at) WHERE ((provider = 'helio'::text) AND (status = ANY (ARRAY['created'::public.key_market_cdp_deposit_destination_status_enum, 'waiting_funds'::public.key_market_cdp_deposit_destination_status_enum, 'payment_seen'::public.key_market_cdp_deposit_destination_status_enum])));


--
-- Name: key_market_cdp_destinations_pending_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX key_market_cdp_destinations_pending_idx ON public.key_market_cdp_deposit_destinations USING btree (status, created_at) WHERE (status = ANY (ARRAY['created'::public.key_market_cdp_deposit_destination_status_enum, 'waiting_funds'::public.key_market_cdp_deposit_destination_status_enum, 'transfer_seen'::public.key_market_cdp_deposit_destination_status_enum]));


--
-- Name: key_market_cdp_destinations_transfer_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX key_market_cdp_destinations_transfer_unique ON public.key_market_cdp_deposit_destinations USING btree (transfer_id) WHERE (transfer_id IS NOT NULL);


--
-- Name: key_market_cdp_destinations_tx_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX key_market_cdp_destinations_tx_unique ON public.key_market_cdp_deposit_destinations USING btree (network, tx_hash) WHERE (tx_hash IS NOT NULL);


--
-- Name: key_market_ledger_account_created_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX key_market_ledger_account_created_idx ON public.key_market_ledger_entries USING btree (account_id, created_at DESC);


--
-- Name: key_market_model_prices_one_lowest_active_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX key_market_model_prices_one_lowest_active_idx ON public.key_market_model_prices USING btree (public_model, billing_type, billing_unit) WHERE ((is_active = true) AND (is_lowest_price = true));


--
-- Name: key_market_model_routes_model_price_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX key_market_model_routes_model_price_idx ON public.key_market_model_routes USING btree (model_price_id);


--
-- Name: key_market_model_routes_no_upstream_key_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX key_market_model_routes_no_upstream_key_unique ON public.key_market_model_routes USING btree (model_price_id, provider, upstream_model) WHERE (upstream_key_id IS NULL);


--
-- Name: key_market_model_routes_one_default_per_public_model; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX key_market_model_routes_one_default_per_public_model ON public.key_market_model_routes USING btree (public_model) WHERE (is_default_route = true);


--
-- Name: key_market_model_routes_public_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX key_market_model_routes_public_status_idx ON public.key_market_model_routes USING btree (public_model, status);


--
-- Name: key_market_model_routes_upstream_key_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX key_market_model_routes_upstream_key_unique ON public.key_market_model_routes USING btree (model_price_id, provider, upstream_model, upstream_key_id) WHERE (upstream_key_id IS NOT NULL);


--
-- Name: key_market_payment_events_economic_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX key_market_payment_events_economic_unique ON public.key_market_payment_events USING btree (provider, economic_event_key) WHERE (economic_event_key IS NOT NULL);


--
-- Name: key_market_topup_bonus_claims_ledger_entry_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX key_market_topup_bonus_claims_ledger_entry_unique ON public.key_market_topup_bonus_claims USING btree (ledger_entry_id) WHERE (ledger_entry_id IS NOT NULL);


--
-- Name: key_market_topups_coinbase_credit_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX key_market_topups_coinbase_credit_unique ON public.key_market_topups USING btree (coinbase_charge_id, coinbase_network, coinbase_tx_hash) WHERE ((coinbase_charge_id IS NOT NULL) AND (coinbase_network IS NOT NULL) AND (coinbase_tx_hash IS NOT NULL));


--
-- Name: key_market_topups_created_by_succeeded_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX key_market_topups_created_by_succeeded_idx ON public.key_market_topups USING btree (created_by, succeeded_at, id) WHERE ((status = 'succeeded'::public.key_market_topup_status_enum) AND (created_by IS NOT NULL));


--
-- Name: key_market_topups_stripe_invoice_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX key_market_topups_stripe_invoice_id_idx ON public.key_market_topups USING btree (stripe_invoice_id) WHERE (stripe_invoice_id IS NOT NULL);


--
-- Name: key_market_topups_stripe_pi_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX key_market_topups_stripe_pi_unique ON public.key_market_topups USING btree (stripe_payment_intent_id) WHERE (stripe_payment_intent_id IS NOT NULL);


--
-- Name: key_market_topups_workspace_created_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX key_market_topups_workspace_created_idx ON public.key_market_topups USING btree (workspace_id, created_at DESC);


--
-- Name: key_market_usage_records_workspace_time_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX key_market_usage_records_workspace_time_idx ON public.key_market_usage_records USING btree (workspace_id, occurred_at DESC);


--
-- Name: key_market_video_task_ledgers_account_task_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX key_market_video_task_ledgers_account_task_idx ON public.key_market_video_task_ledgers USING btree (account_id, endpoint, task_id);


--
-- Name: key_market_video_task_ledgers_api_key_task_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX key_market_video_task_ledgers_api_key_task_idx ON public.key_market_video_task_ledgers USING btree (api_key_id, endpoint, task_id);


--
-- Name: key_market_video_task_ledgers_compensation_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX key_market_video_task_ledgers_compensation_idx ON public.key_market_video_task_ledgers USING btree (billing_status, task_status, next_poll_at, expires_at);


--
-- Name: key_market_video_task_ledgers_endpoint_task_uq; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX key_market_video_task_ledgers_endpoint_task_uq ON public.key_market_video_task_ledgers USING btree (endpoint, task_id);


--
-- Name: key_market_video_task_ledgers_reservation_uq; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX key_market_video_task_ledgers_reservation_uq ON public.key_market_video_task_ledgers USING btree (reservation_id);


--
-- Name: openmodel_account_subscriptions_customer_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX openmodel_account_subscriptions_customer_idx ON public.openmodel_account_subscriptions USING btree (stripe_customer_id) WHERE (stripe_customer_id IS NOT NULL);


--
-- Name: openmodel_account_subscriptions_stripe_sub_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX openmodel_account_subscriptions_stripe_sub_unique ON public.openmodel_account_subscriptions USING btree (stripe_subscription_id) WHERE (stripe_subscription_id IS NOT NULL);


--
-- Name: openmodel_subscription_invoices_account_created_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX openmodel_subscription_invoices_account_created_idx ON public.openmodel_subscription_invoices USING btree (account_id, created_at DESC);


--
-- Name: openmodels_accounts_partner_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX openmodels_accounts_partner_id_idx ON public.openmodels_accounts USING btree (partner_id) WHERE (partner_id IS NOT NULL);


--
-- Name: openmodels_accounts_referral_code_lower_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX openmodels_accounts_referral_code_lower_unique ON public.openmodels_accounts USING btree (lower(referral_code)) WHERE (referral_code IS NOT NULL);


--
-- Name: openmodels_accounts_referrer_status_created_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX openmodels_accounts_referrer_status_created_idx ON public.openmodels_accounts USING btree (referrer_account_id, referral_status, created_at DESC);


--
-- Name: openmodels_referral_cashback_awards_ledger_entry_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX openmodels_referral_cashback_awards_ledger_entry_unique ON public.openmodels_referral_cashback_awards USING btree (ledger_entry_id) WHERE (ledger_entry_id IS NOT NULL);


--
-- Name: openmodels_referral_cashback_awards_referred_created_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX openmodels_referral_cashback_awards_referred_created_idx ON public.openmodels_referral_cashback_awards USING btree (referred_account_id, created_at DESC);


--
-- Name: openmodels_referral_cashback_awards_referrer_created_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX openmodels_referral_cashback_awards_referrer_created_idx ON public.openmodels_referral_cashback_awards USING btree (referrer_account_id, created_at DESC);


--
-- Name: openmodels_referral_cashback_awards_topup_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX openmodels_referral_cashback_awards_topup_unique ON public.openmodels_referral_cashback_awards USING btree (trigger_topup_id) WHERE (trigger_topup_id IS NOT NULL);


--
-- Name: openmodels_referral_cashback_awards_trigger_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX openmodels_referral_cashback_awards_trigger_unique ON public.openmodels_referral_cashback_awards USING btree (trigger_source_table, trigger_source_id);


--
-- Name: openmodels_referral_rewards_ledger_entry_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX openmodels_referral_rewards_ledger_entry_unique ON public.openmodels_referral_rewards USING btree (ledger_entry_id) WHERE (ledger_entry_id IS NOT NULL);


--
-- Name: openmodels_referral_rewards_referrer_role_created_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX openmodels_referral_rewards_referrer_role_created_idx ON public.openmodels_referral_rewards USING btree (referrer_account_id, role, created_at DESC);


--
-- Name: openmodels_refresh_sessions_account_exp_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX openmodels_refresh_sessions_account_exp_idx ON public.openmodels_refresh_sessions USING btree (account_id, expires_at) WHERE (revoked_at IS NULL);


--
-- Name: openmodels_refresh_sessions_token_hash_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX openmodels_refresh_sessions_token_hash_unique ON public.openmodels_refresh_sessions USING btree (token_hash);


--
-- Name: key_market_alephant_observability_links key_market_alephant_observabi_key_market_api_key_id_accoun_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_alephant_observability_links
    ADD CONSTRAINT key_market_alephant_observabi_key_market_api_key_id_accoun_fkey FOREIGN KEY (key_market_api_key_id, account_id, workspace_id) REFERENCES public.key_market_api_keys(id, account_id, workspace_id) ON DELETE CASCADE;


--
-- Name: key_market_api_keys key_market_api_keys_account_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_api_keys
    ADD CONSTRAINT key_market_api_keys_account_fk FOREIGN KEY (account_id, workspace_id) REFERENCES public.key_market_accounts(id, workspace_id) ON DELETE CASCADE;


--
-- Name: key_market_auto_reload_settings key_market_auto_reload_account_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_auto_reload_settings
    ADD CONSTRAINT key_market_auto_reload_account_fk FOREIGN KEY (account_id, workspace_id) REFERENCES public.key_market_accounts(id, workspace_id) ON DELETE CASCADE;


--
-- Name: key_market_provider_bridge_links key_market_bridge_account_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_provider_bridge_links
    ADD CONSTRAINT key_market_bridge_account_fk FOREIGN KEY (account_id, workspace_id) REFERENCES public.key_market_accounts(id, workspace_id) ON DELETE CASCADE;


--
-- Name: key_market_provider_bridge_links key_market_bridge_api_key_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_provider_bridge_links
    ADD CONSTRAINT key_market_bridge_api_key_fk FOREIGN KEY (key_market_api_key_id, account_id, workspace_id) REFERENCES public.key_market_api_keys(id, account_id, workspace_id) ON DELETE CASCADE;


--
-- Name: key_market_cdp_deposit_destinations key_market_cdp_destinations_topup_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_cdp_deposit_destinations
    ADD CONSTRAINT key_market_cdp_destinations_topup_fk FOREIGN KEY (topup_id, account_id, workspace_id) REFERENCES public.key_market_topups(id, account_id, workspace_id) ON DELETE CASCADE;


--
-- Name: key_market_ledger_entries key_market_ledger_account_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_ledger_entries
    ADD CONSTRAINT key_market_ledger_account_fk FOREIGN KEY (account_id, workspace_id) REFERENCES public.key_market_accounts(id, workspace_id) ON DELETE CASCADE;


--
-- Name: key_market_model_routes key_market_model_routes_model_price_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_model_routes
    ADD CONSTRAINT key_market_model_routes_model_price_id_fkey FOREIGN KEY (model_price_id) REFERENCES public.key_market_model_prices(id) ON DELETE CASCADE;


--
-- Name: key_market_model_routes key_market_model_routes_upstream_key_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_model_routes
    ADD CONSTRAINT key_market_model_routes_upstream_key_id_fkey FOREIGN KEY (upstream_key_id) REFERENCES public.key_market_upstream_keys(id) ON DELETE SET NULL;


--
-- Name: key_market_payment_events key_market_payment_events_account_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_payment_events
    ADD CONSTRAINT key_market_payment_events_account_fk FOREIGN KEY (account_id, workspace_id) REFERENCES public.key_market_accounts(id, workspace_id) ON DELETE SET NULL;


--
-- Name: key_market_payment_events key_market_payment_events_topup_account_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_payment_events
    ADD CONSTRAINT key_market_payment_events_topup_account_fk FOREIGN KEY (topup_id, account_id, workspace_id) REFERENCES public.key_market_topups(id, account_id, workspace_id) ON DELETE SET NULL;


--
-- Name: key_market_provider_bridge_links key_market_provider_bridge_links_master_key_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_provider_bridge_links
    ADD CONSTRAINT key_market_provider_bridge_links_master_key_id_fkey FOREIGN KEY (master_key_id) REFERENCES public.master_keys(id) ON DELETE CASCADE;


--
-- Name: key_market_reservations key_market_reservations_account_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_reservations
    ADD CONSTRAINT key_market_reservations_account_fk FOREIGN KEY (account_id, workspace_id) REFERENCES public.key_market_accounts(id, workspace_id) ON DELETE CASCADE;


--
-- Name: key_market_reservations key_market_reservations_api_key_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_reservations
    ADD CONSTRAINT key_market_reservations_api_key_fk FOREIGN KEY (api_key_id, account_id, workspace_id) REFERENCES public.key_market_api_keys(id, account_id, workspace_id) ON DELETE RESTRICT;


--
-- Name: key_market_topup_bonus_claims key_market_topup_bonus_claims_ledger_entry_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_topup_bonus_claims
    ADD CONSTRAINT key_market_topup_bonus_claims_ledger_entry_id_fkey FOREIGN KEY (ledger_entry_id) REFERENCES public.key_market_ledger_entries(id);


--
-- Name: key_market_topup_bonus_claims key_market_topup_bonus_claims_topup_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_topup_bonus_claims
    ADD CONSTRAINT key_market_topup_bonus_claims_topup_fk FOREIGN KEY (topup_id, account_id, workspace_id) REFERENCES public.key_market_topups(id, account_id, workspace_id) ON DELETE CASCADE;


--
-- Name: key_market_topups key_market_topups_account_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_topups
    ADD CONSTRAINT key_market_topups_account_fk FOREIGN KEY (account_id, workspace_id) REFERENCES public.key_market_accounts(id, workspace_id) ON DELETE CASCADE;


--
-- Name: key_market_usage_records key_market_usage_account_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_usage_records
    ADD CONSTRAINT key_market_usage_account_fk FOREIGN KEY (account_id, workspace_id) REFERENCES public.key_market_accounts(id, workspace_id) ON DELETE CASCADE;


--
-- Name: key_market_usage_records key_market_usage_api_key_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_usage_records
    ADD CONSTRAINT key_market_usage_api_key_fk FOREIGN KEY (api_key_id, account_id, workspace_id) REFERENCES public.key_market_api_keys(id, account_id, workspace_id) ON DELETE RESTRICT;


--
-- Name: key_market_usage_records key_market_usage_reservation_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.key_market_usage_records
    ADD CONSTRAINT key_market_usage_reservation_fk FOREIGN KEY (reservation_id, account_id, workspace_id) REFERENCES public.key_market_reservations(id, account_id, workspace_id) ON DELETE RESTRICT;


--
-- Name: openmodel_account_subscriptions openmodel_account_subscriptions_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodel_account_subscriptions
    ADD CONSTRAINT openmodel_account_subscriptions_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.openmodels_accounts(id) ON DELETE CASCADE;


--
-- Name: openmodel_account_subscriptions openmodel_account_subscriptions_plan_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodel_account_subscriptions
    ADD CONSTRAINT openmodel_account_subscriptions_plan_code_fkey FOREIGN KEY (plan_code) REFERENCES public.openmodel_subscription_plans(code);


--
-- Name: openmodel_subscription_invoices openmodel_subscription_invoices_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodel_subscription_invoices
    ADD CONSTRAINT openmodel_subscription_invoices_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.openmodels_accounts(id) ON DELETE CASCADE;


--
-- Name: openmodel_subscription_invoices openmodel_subscription_invoices_bonus_ledger_entry_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodel_subscription_invoices
    ADD CONSTRAINT openmodel_subscription_invoices_bonus_ledger_entry_id_fkey FOREIGN KEY (bonus_ledger_entry_id) REFERENCES public.key_market_ledger_entries(id);


--
-- Name: openmodel_subscription_invoices openmodel_subscription_invoices_payment_ledger_entry_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodel_subscription_invoices
    ADD CONSTRAINT openmodel_subscription_invoices_payment_ledger_entry_id_fkey FOREIGN KEY (payment_ledger_entry_id) REFERENCES public.key_market_ledger_entries(id);


--
-- Name: openmodel_subscription_invoices openmodel_subscription_invoices_plan_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodel_subscription_invoices
    ADD CONSTRAINT openmodel_subscription_invoices_plan_code_fkey FOREIGN KEY (plan_code) REFERENCES public.openmodel_subscription_plans(code);


--
-- Name: openmodel_subscription_invoices openmodel_subscription_invoices_subscription_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodel_subscription_invoices
    ADD CONSTRAINT openmodel_subscription_invoices_subscription_id_fkey FOREIGN KEY (subscription_id) REFERENCES public.openmodel_account_subscriptions(id) ON DELETE SET NULL;


--
-- Name: openmodels_accounts openmodels_accounts_partner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodels_accounts
    ADD CONSTRAINT openmodels_accounts_partner_id_fkey FOREIGN KEY (partner_id) REFERENCES public.partner_profiles(partner_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: openmodels_accounts openmodels_accounts_referrer_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodels_accounts
    ADD CONSTRAINT openmodels_accounts_referrer_account_id_fkey FOREIGN KEY (referrer_account_id) REFERENCES public.openmodels_accounts(id);


--
-- Name: openmodels_referral_cashback_awards openmodels_referral_cashback_awards_ledger_entry_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodels_referral_cashback_awards
    ADD CONSTRAINT openmodels_referral_cashback_awards_ledger_entry_id_fkey FOREIGN KEY (ledger_entry_id) REFERENCES public.key_market_ledger_entries(id);


--
-- Name: openmodels_referral_cashback_awards openmodels_referral_cashback_awards_referred_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodels_referral_cashback_awards
    ADD CONSTRAINT openmodels_referral_cashback_awards_referred_account_id_fkey FOREIGN KEY (referred_account_id) REFERENCES public.openmodels_accounts(id);


--
-- Name: openmodels_referral_cashback_awards openmodels_referral_cashback_awards_referrer_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodels_referral_cashback_awards
    ADD CONSTRAINT openmodels_referral_cashback_awards_referrer_account_id_fkey FOREIGN KEY (referrer_account_id) REFERENCES public.openmodels_accounts(id);


--
-- Name: openmodels_referral_cashback_awards openmodels_referral_cashback_awards_trigger_topup_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodels_referral_cashback_awards
    ADD CONSTRAINT openmodels_referral_cashback_awards_trigger_topup_id_fkey FOREIGN KEY (trigger_topup_id) REFERENCES public.key_market_topups(id);


--
-- Name: openmodels_referral_rewards openmodels_referral_rewards_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodels_referral_rewards
    ADD CONSTRAINT openmodels_referral_rewards_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.openmodels_accounts(id);


--
-- Name: openmodels_referral_rewards openmodels_referral_rewards_ledger_entry_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodels_referral_rewards
    ADD CONSTRAINT openmodels_referral_rewards_ledger_entry_id_fkey FOREIGN KEY (ledger_entry_id) REFERENCES public.key_market_ledger_entries(id);


--
-- Name: openmodels_referral_rewards openmodels_referral_rewards_referred_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodels_referral_rewards
    ADD CONSTRAINT openmodels_referral_rewards_referred_account_id_fkey FOREIGN KEY (referred_account_id) REFERENCES public.openmodels_accounts(id);


--
-- Name: openmodels_referral_rewards openmodels_referral_rewards_referrer_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodels_referral_rewards
    ADD CONSTRAINT openmodels_referral_rewards_referrer_account_id_fkey FOREIGN KEY (referrer_account_id) REFERENCES public.openmodels_accounts(id);


--
-- Name: openmodels_refresh_sessions openmodels_refresh_sessions_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openmodels_refresh_sessions
    ADD CONSTRAINT openmodels_refresh_sessions_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.openmodels_accounts(id) ON DELETE CASCADE;



SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: insights_signal_definition; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.insights_signal_definition (signal_id, signal_family, veto_cap_role, default_display_name, default_description, default_severity, default_sort_order, default_score_weight, default_enabled, default_ui_meta, is_system, created_at, updated_at) VALUES ('W1', 'waste', NULL, 'Context Bloat', 'context_tokens > 85% × model_limit, ≥3 consecutive', NULL, 10, 10.00, true, '{"badge": "W1", "showInIssues": true}', true, '2026-04-29 06:13:09.261136+00', '2026-04-29 06:13:09.261136+00');
INSERT INTO public.insights_signal_definition (signal_id, signal_family, veto_cap_role, default_display_name, default_description, default_severity, default_sort_order, default_score_weight, default_enabled, default_ui_meta, is_system, created_at, updated_at) VALUES ('W2', 'waste', NULL, 'Prompt Churn', 'prompt edit distance > 40%, round_count > 2', NULL, 20, 15.00, true, '{"badge": "W2", "showInIssues": true}', true, '2026-04-29 06:13:09.261136+00', '2026-04-29 06:13:09.261136+00');
INSERT INTO public.insights_signal_definition (signal_id, signal_family, veto_cap_role, default_display_name, default_description, default_severity, default_sort_order, default_score_weight, default_enabled, default_ui_meta, is_system, created_at, updated_at) VALUES ('W3', 'waste', 'critical', 'Agent Thrashing', 'agent loop > 5× in 60s or tool_call_rate > 10/min', 'critical', 30, 35.00, true, '{"badge": "W3", "showInIssues": true}', true, '2026-04-29 06:13:09.261136+00', '2026-04-29 06:13:09.261136+00');
INSERT INTO public.insights_signal_definition (signal_id, signal_family, veto_cap_role, default_display_name, default_description, default_severity, default_sort_order, default_score_weight, default_enabled, default_ui_meta, is_system, created_at, updated_at) VALUES ('W4', 'waste', NULL, 'Low Info Density', 'output < 50 tokens for > 800 input tokens, ≥30%', NULL, 40, 10.00, true, '{"badge": "W4", "showInIssues": true}', true, '2026-04-29 06:13:09.261136+00', '2026-04-29 06:13:09.261136+00');
INSERT INTO public.insights_signal_definition (signal_id, signal_family, veto_cap_role, default_display_name, default_description, default_severity, default_sort_order, default_score_weight, default_enabled, default_ui_meta, is_system, created_at, updated_at) VALUES ('W5', 'waste', 'warning', 'Off-Hours Burst', 'hour ≥22 or weekend, callRate > 3× daily avg', 'warning', 50, 20.00, true, '{"badge": "W5", "showInIssues": true}', true, '2026-04-29 06:13:09.261136+00', '2026-04-29 06:13:09.261136+00');
INSERT INTO public.insights_signal_definition (signal_id, signal_family, veto_cap_role, default_display_name, default_description, default_severity, default_sort_order, default_score_weight, default_enabled, default_ui_meta, is_system, created_at, updated_at) VALUES ('W6', 'waste', NULL, 'Model Mismatch', 'task_complexity < 0.3, premium model, ≥20% calls', NULL, 60, 12.00, true, '{"badge": "W6", "showInIssues": true}', true, '2026-04-29 06:13:09.261136+00', '2026-04-29 06:13:09.261136+00');
INSERT INTO public.insights_signal_definition (signal_id, signal_family, veto_cap_role, default_display_name, default_description, default_severity, default_sort_order, default_score_weight, default_enabled, default_ui_meta, is_system, created_at, updated_at) VALUES ('W7', 'waste', NULL, 'Redundant Calls', 'semantic similarity > 0.92, delta_time < 5s', NULL, 70, 8.00, true, '{"badge": "W7", "showInIssues": true}', true, '2026-04-29 06:13:09.261136+00', '2026-04-29 06:13:09.261136+00');
INSERT INTO public.insights_signal_definition (signal_id, signal_family, veto_cap_role, default_display_name, default_description, default_severity, default_sort_order, default_score_weight, default_enabled, default_ui_meta, is_system, created_at, updated_at) VALUES ('W8', 'waste', NULL, 'Session Shape Shift', 'KL divergence > 2.3 vs 30d baseline', NULL, 80, 15.00, true, '{"badge": "W8", "showInIssues": true}', true, '2026-04-29 06:13:09.261136+00', '2026-04-29 06:13:09.261136+00');
INSERT INTO public.insights_signal_definition (signal_id, signal_family, veto_cap_role, default_display_name, default_description, default_severity, default_sort_order, default_score_weight, default_enabled, default_ui_meta, is_system, created_at, updated_at) VALUES ('V1', 'value', NULL, 'First-Shot Success', 'round 1 complete, ≥60% of sessions', NULL, 90, 20.00, true, '{"badge": "V1", "showInIssues": true}', true, '2026-04-29 06:13:09.261136+00', '2026-04-29 06:13:09.261136+00');
INSERT INTO public.insights_signal_definition (signal_id, signal_family, veto_cap_role, default_display_name, default_description, default_severity, default_sort_order, default_score_weight, default_enabled, default_ui_meta, is_system, created_at, updated_at) VALUES ('V2', 'value', NULL, 'Cache Leverage', 'cache hit rate > 25% in rolling 24h window', NULL, 100, 15.00, true, '{"badge": "V2", "showInIssues": true}', true, '2026-04-29 06:13:09.261136+00', '2026-04-29 06:13:09.261136+00');
INSERT INTO public.insights_signal_definition (signal_id, signal_family, veto_cap_role, default_display_name, default_description, default_severity, default_sort_order, default_score_weight, default_enabled, default_ui_meta, is_system, created_at, updated_at) VALUES ('V3', 'value', NULL, 'Structured Output', 'structured output used, parse success > 95%', NULL, 110, 10.00, true, '{"badge": "V3", "showInIssues": true}', true, '2026-04-29 06:13:09.261136+00', '2026-04-29 06:13:09.261136+00');


--
-- Data for Name: providers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('2b5b4c79-74de-455d-a96c-9132e25f102b', 'platform', 'Alephant Credits', NULL, NULL, 'https://payment-api-dev.alephant.io/v1', 8, true, '2026-06-12 08:07:53.187671+00', '2026-06-13 14:51:11.548912+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('db1cbfcb-8d6d-4a55-9ddb-c1e638738b38', 'openmodels', 'OpenModels', NULL, NULL, 'https://api.getopenmodels.com/v1', 1, true, '2026-07-08 13:05:16.464902+00', '2026-07-08 13:05:16.464902+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('7d889675-918b-40b2-b337-6d43004b4019', 'mistral', 'mistral', NULL, NULL, 'https://api.mistral.ai/', 8, true, '2026-05-21 13:43:24.987357+00', '2026-05-21 13:43:24.987357+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen', 'qwen', NULL, NULL, 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1/', 8, true, '2026-05-06 08:32:17.800282+00', '2026-07-10 09:00:23.098781+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('ade284c2-0774-4471-b455-1810cd5375b5', 'qwen-beijing', 'qwen-beijing', NULL, NULL, 'https://dashscope.aliyuncs.com/compatible-mode/v1', 8, true, '2026-05-19 17:03:48.539066+00', '2026-07-10 09:00:23.105701+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen-us', 'qwen-us', NULL, NULL, 'https://dashscope-us.aliyuncs.com/compatible-mode/v1', 8, true, '2026-05-19 17:03:48.65322+00', '2026-07-10 09:00:23.11267+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('0d835d66-6c7d-4f9b-b5a9-82d36c3dfc14', 'meituan', 'meituan', NULL, NULL, 'https://api.longcat.chat/openai/v1/', 8, true, '2026-05-21 13:43:25.166417+00', '2026-05-21 13:43:25.166417+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('f909fcfd-d284-4f5d-ac08-20b37eeb918a', 'opencode-go', 'opencode-go', NULL, NULL, 'https://opencode.ai/zen/go/v1', 8, true, '2026-05-21 13:43:25.222229+00', '2026-05-21 13:43:25.222229+00', true, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('a857c7ef-6007-4ff5-a1e7-87b833525a69', 'opencode-zen', 'opencode-zen', NULL, NULL, 'https://opencode.ai/zen/v1', 8, true, '2026-05-21 13:43:25.252905+00', '2026-05-21 13:43:25.252905+00', true, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('27f7f92a-9500-41da-af16-e616e40de3f9', 'reka', 'reka', NULL, NULL, 'https://api.reka.ai/v1/', 8, true, '2026-05-21 13:43:25.540595+00', '2026-05-21 13:43:25.540595+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('24363ca8-5240-42b3-b704-10d21ee03be0', 'custom', 'Custom', NULL, NULL, NULL, 7, true, '2026-04-29 08:28:31.218629+00', '2026-04-29 08:28:31.218629+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('52afc118-ced4-4665-b25d-05f4948065e3', 'essentialai', 'essentialai', NULL, NULL, 'https://api.essentialai.com/v1', 8, true, '2026-05-06 08:32:18.764079+00', '2026-06-23 14:00:54.175874+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('568aa6a0-7312-4d9c-b2bf-e71cadb3df82', 'prime-intellect', 'prime-intellect', NULL, NULL, 'https://api.prime-intellect.com/v1', 8, true, '2026-05-06 08:32:18.841103+00', '2026-06-23 13:00:52.202439+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('23a280b6-2fe9-4fef-aac0-a19818a5134c', 'alibaba', 'alibaba', NULL, NULL, 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1/', 8, true, '2026-05-06 08:32:19.154177+00', '2026-05-25 07:00:26.782558+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('afa9fcb3-49b1-4b68-b916-44eea386d9ea', 'sakana', 'sakana', NULL, NULL, NULL, 8, true, '2026-06-24 05:00:17.676074+00', '2026-07-10 09:00:20.17249+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('517cf0cb-27a2-4452-8696-cd902a9c0bee', 'nex-agi', 'nex-agi', NULL, NULL, 'https://api.nex-agi.com/v1', 8, true, '2026-05-06 08:32:18.756921+00', '2026-07-10 09:00:20.251708+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('f6a87e1d-825a-4a89-9231-daef28b59db5', 'perceptron', 'perceptron', NULL, NULL, 'https://api.perceptron.inc/v1', 8, true, '2026-05-12 16:00:28.127129+00', '2026-07-10 09:00:20.381671+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('09b4c6f6-ff86-4c84-97b1-4a03ce281453', 'xiaomi', 'xiaomi', NULL, NULL, 'https://api.xiaomimimo.com/v1', 8, true, '2026-05-06 08:32:17.890286+00', '2026-07-10 09:00:20.629473+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('98f229c5-42ef-4167-91b1-47846b4f381e', 'x-ai', 'x-ai', NULL, NULL, 'https://api.x.ai/', 8, true, '2026-05-06 08:32:17.663488+00', '2026-07-10 09:00:20.774769+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('d5041374-7609-493f-8ef4-65459cd94869', 'kwaipilot', 'kwaipilot', NULL, NULL, 'https://api.kwaipilot.com/v1', 8, true, '2026-05-06 08:32:18.287339+00', '2026-07-10 09:00:20.796066+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('917d8043-1301-4b63-ba4b-8d12603dae39', 'inception', 'inception', NULL, NULL, 'https://api.inceptionlabs.ai/v1/', 8, true, '2026-05-06 08:32:18.394993+00', '2026-07-10 09:00:20.920681+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('aab4161e-3e3f-440f-8815-415689b823ca', 'stepfun', 'stepfun', NULL, NULL, 'https://api.stepfun.com/v1/', 8, true, '2026-05-06 08:32:18.570018+00', '2026-07-10 09:00:21.21126+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('9ea37c4f-52b1-4489-9f79-eba4bbd3ecf7', 'upstage', 'upstage', NULL, NULL, 'https://api.upstage.ai/v2/', 8, true, '2026-05-06 08:32:18.592426+00', '2026-07-10 09:00:21.232639+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('09290c5f-fa5f-48d0-b6cb-0f1ce91323c7', 'writer', 'writer', NULL, NULL, 'https://api.writer.com/v1', 8, true, '2026-05-06 08:32:18.606785+00', '2026-07-10 09:00:21.254499+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('39e2c759-ca87-4a6d-bb13-95d83824f8ea', 'liquid', 'liquid', NULL, NULL, 'https://api.liquid.ai/v1', 8, true, '2026-05-06 08:32:18.463009+00', '2026-07-10 09:00:21.269015+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('d76d415e-972f-4cf9-9727-78e092ce5c56', 'bytedance-seed', 'bytedance-seed', NULL, NULL, 'https://ark.cn-beijing.volces.com/api/v3/', 8, true, '2026-05-06 08:32:18.36122+00', '2026-07-10 09:00:21.324876+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('b9612f06-8f03-4c21-a921-d0397c107d63', 'deepcogito', 'deepcogito', NULL, NULL, 'https://api.together.xyz/v1', 8, true, '2026-05-31 23:00:38.500148+00', '2026-07-10 09:00:21.531803+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('1220c61f-f41a-4985-9b71-a3b10efed282', 'ibm-granite', 'ibm-granite', NULL, NULL, 'https://api.ibm.com/granite/ai/v1', 8, true, '2026-05-06 08:32:17.671389+00', '2026-07-10 09:00:21.643628+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('3aae62b8-1e09-46bf-b98d-7068befbc2fe', 'relace', 'relace', NULL, NULL, 'https://api.relace.run/', 8, true, '2026-05-06 08:32:18.742956+00', '2026-07-10 09:00:21.827115+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('3b6bbaa2-d1ec-40c6-8a74-2371398db82e', 'nvidia', 'nvidia', NULL, NULL, 'https://integrate.api.nvidia.com/v1', 8, true, '2026-05-06 08:32:17.697909+00', '2026-07-10 09:00:22.062242+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('4edbacf8-cea6-4696-b47a-4f83ff9c6c9c', 'ai21', 'ai21', NULL, NULL, 'https://api.ai21.com/studio/v1/', 8, true, '2026-05-06 08:32:19.294267+00', '2026-07-10 09:00:22.14522+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('55857a3a-55f0-4879-b39f-cd252a8bcbf9', 'z-ai', 'z-ai', NULL, NULL, 'https://api.z.ai/api/paas/v4/', 8, true, '2026-05-06 08:32:18.213793+00', '2026-07-10 09:00:22.2835+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('38f5b8d7-54ae-4be3-9f15-d7c67a355134', 'z-ai-cn', 'z-ai-cn', NULL, NULL, 'https://open.bigmodel.cn/api/paas/v4', 8, true, '2026-05-19 17:03:49.207347+00', '2026-07-10 09:00:22.290297+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('f5522dbf-cdff-469d-b78b-b68f3e28b83c', 'z-ai-coding-cn', 'z-ai-coding-cn', NULL, NULL, 'https://open.bigmodel.cn/api/coding/paas/v4', 8, true, '2026-05-19 17:03:49.215415+00', '2026-07-10 09:00:22.297057+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('502f3435-16b3-4f68-b4dc-07dbe66861ab', 'bytedance', 'bytedance', NULL, NULL, 'https://ark.cn-beijing.volces.com/api/v3/', 8, true, '2026-05-06 08:32:19.421431+00', '2026-07-10 09:00:22.366575+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('4d50bc54-56de-46a6-97db-46362130d4b8', 'moonshotai', 'moonshotai', NULL, NULL, 'https://api.moonshot.ai/v1/', 8, true, '2026-05-06 08:32:17.735489+00', '2026-07-10 09:00:22.400623+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('b0fa945d-ac33-4b5f-99e8-30c52a526c61', 'cognitivecomputations', 'cognitivecomputations', NULL, NULL, 'https://api.venice.ai/api/v1/', 8, true, '2026-05-06 08:32:19.462185+00', '2026-07-10 09:00:22.414269+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('59f22d14-a479-4667-86e5-7e7d7433603e', 'tencent', 'tencent', NULL, NULL, 'https://hunyuan.tencentcloudapi.com', 8, true, '2026-05-06 08:32:17.885731+00', '2026-07-10 09:00:22.421411+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('05720ed1-8c9a-4e3e-885e-2025e5337770', 'morph', 'morph', NULL, NULL, 'https://api.morph.ai/v1', 8, true, '2026-05-06 08:32:19.482269+00', '2026-07-10 09:00:22.43657+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('7951f113-58d7-4802-80c0-365f624b7483', 'baidu', 'baidu', NULL, NULL, 'https://qianfan.baidubce.com/v2/', 8, true, '2026-05-06 08:32:17.621415+00', '2026-07-10 09:00:22.443817+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('fee873f7-15b7-4809-b9ba-2737224b15ed', 'arcee-ai', 'arcee-ai', NULL, NULL, 'https://api.arcee.ai/v1', 8, true, '2026-05-06 08:32:18.257522+00', '2026-07-10 09:00:22.551665+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('fddcd474-2972-4c83-aefa-3403ab2e386c', 'rekaai', 'rekaai', NULL, NULL, 'https://api.reka.ai/v1/', 8, true, '2026-05-06 08:32:18.294339+00', '2026-07-10 09:00:22.789098+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('3865ca54-b799-4bb8-b769-9ea883771901', 'aion-labs', 'aion-labs', NULL, NULL, 'https://api.aion-labs.ai/v1', 8, true, '2026-05-06 08:32:18.485463+00', '2026-07-10 09:00:22.83762+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('1f21a50f-a00a-4669-82d2-ac6d2c05081f', 'perplexity', 'perplexity', NULL, NULL, 'https://api.perplexity.ai', 8, true, '2026-05-06 08:32:18.921357+00', '2026-07-10 09:00:22.900613+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('2810aca3-c2e5-426d-a8c8-2bddc1ff480d', 'minimax', 'minimax', NULL, NULL, 'https://api.minimax.io/v1/', 8, true, '2026-05-06 08:32:18.315142+00', '2026-07-10 09:00:22.922166+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('ec126a88-8820-4ab3-ba63-7cd1c1b1aaf2', 'minimax-cn', 'minimax-cn', NULL, NULL, 'https://api.minimaxi.com/v1', 8, true, '2026-05-19 17:03:49.816416+00', '2026-07-10 09:00:22.929209+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('493b150e-48c0-4fd4-9866-56bd3d915c46', 'deepseek', 'deepseek', NULL, NULL, 'https://api.deepseek.com', 8, true, '2026-05-06 08:32:17.870469+00', '2026-07-10 09:00:22.943264+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('680a6550-c76c-44d2-b9c4-1d1022880732', 'amazon', 'amazon', NULL, NULL, 'https://bedrock-runtime.us-east-1.amazonaws.com/', 8, true, '2026-05-06 08:32:18.781814+00', '2026-07-10 09:00:22.99288+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('8602ce14-e8dc-435a-8d40-c42e1b094488', 'nousresearch', 'nousresearch', NULL, NULL, 'https://api.nousresearch.com/v1/', 8, true, '2026-05-06 08:32:19.236644+00', '2026-07-10 09:00:23.159674+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('9f5cef8f-06f8-4500-8091-e046a5d4c384', 'google', 'google', NULL, NULL, 'https://generativelanguage.googleapis.com', 8, true, '2026-04-29 03:22:21.6267+00', '2026-07-10 09:00:23.213769+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('64647d14-f1cd-4965-926c-476e20bcb1c3', 'meta-llama', 'meta-llama', NULL, NULL, 'https://api.llama.com/v1/', 8, true, '2026-05-06 08:32:19.651628+00', '2026-07-10 09:00:23.235217+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('d63d8b65-111d-4030-900c-a7b439c9473a', 'microsoft', 'microsoft', NULL, NULL, 'https://api.copilot.microsoft.com/v1', 8, true, '2026-05-06 08:32:18.973485+00', '2026-07-10 09:00:23.249581+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('09b94796-8f59-4775-976b-ee85a5a6d927', 'anthropic', 'anthropic', NULL, NULL, 'https://api.anthropic.com', 8, true, '2026-05-06 08:32:17.706441+00', '2026-07-10 09:00:23.264358+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('004533f3-71af-47b3-a4b4-9dcd2eeff9b8', 'mistralai', 'mistralai', NULL, NULL, 'https://api.mistral.ai/', 8, true, '2026-05-06 08:32:17.684088+00', '2026-07-10 09:00:23.271558+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('2be846df-8b85-4d9e-b94e-3f0c5cc3d223', 'openrouter', 'OpenRouter', NULL, NULL, 'https://openrouter.ai/api/v1', 8, true, '2026-04-29 03:22:19.236899+00', '2026-07-10 09:00:23.293215+00', true, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('bb05b8a1-9856-4ac2-bcdd-2c132e94e795', 'mancer', 'mancer', NULL, NULL, 'https://api.mancer.xyz/v1', 8, true, '2026-05-06 08:32:20.89091+00', '2026-07-10 09:00:23.313975+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('adc9aced-1855-42e4-bbed-916b90e7d6b6', 'openai', 'openai', NULL, NULL, 'https://api.openai.com/v1', 8, true, '2026-04-29 03:22:28.002192+00', '2026-07-10 09:00:23.328214+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('036cfc6e-0a26-4786-b7b6-7a5739ea6d5b', 'inflection', 'inflection', NULL, NULL, 'https://api.inflection.ai/v1', 8, true, '2026-05-06 08:32:20.47314+00', '2026-07-10 09:00:23.063117+00', false, NULL);
INSERT INTO public.providers (id, code, name, icon_url, logo_url, default_base_url, sort_order, enabled, created_at, updated_at, is_router, cn_base_url) VALUES ('47927a94-7043-4921-b67e-8389985f9aab', 'cohere', 'cohere', NULL, NULL, 'https://api.cohere.com/', 8, true, '2026-05-06 08:32:19.894224+00', '2026-07-10 09:00:23.135803+00', false, NULL);


--
-- Data for Name: provider_models; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('746829d7-7d42-43e7-ae44-3f61e35df4a7', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3-coder:free', NULL, true, '2026-06-07 15:16:16.706061+00', '2026-07-10 09:00:22.328448+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1753230546, "schema_version": 1, "max_context_tokens": 1048576, "max_completion_tokens": 262000, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('455109cf-61a8-4cc2-bbd9-cae593f7fef8', '3865ca54-b799-4bb8-b769-9ea883771901', 'aion-1.0', NULL, false, '2026-05-06 08:32:20.085352+00', '2026-07-08 13:38:02.694842+00', '{"tag": "", "prompt": 0.000004, "completion": 0.000008, "create_time": 1738697557, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 32768, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('1d5489f2-36de-4a56-b732-546be9619be2', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-4o-mini-search-preview', NULL, true, '2026-05-06 08:32:19.911966+00', '2026-07-10 09:00:22.778156+00', '{"tag": "", "prompt": 0.00000015, "completion": 0.0000006, "web_search": 0.0275, "create_time": 1741818122, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": 16384, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('393646d8-7d7a-49e3-bf2d-f6535d94ea22', '004533f3-71af-47b3-a4b4-9dcd2eeff9b8', 'ministral-14b-2512', NULL, true, '2026-05-06 08:32:18.793684+00', '2026-07-10 09:00:21.4783+00', '{"tag": "", "prompt": 0.0000002, "completion": 0.0000002, "create_time": 1764681735, "schema_version": 1, "input_cache_read": 0.00000002, "max_context_tokens": 262144, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('1a34731f-ecd1-4dbd-8d6d-763a29fb5b3a', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5.6-luna-pro', NULL, true, '2026-07-09 18:00:23.003501+00', '2026-07-10 09:00:20.067037+00', '{"tag": "Latest", "prompt": 0.000001, "completion": 0.000006, "web_search": 0.01, "create_time": 1783590867, "schema_version": 1, "input_cache_read": 0.0000001, "input_cache_write": 0.00000125, "max_context_tokens": 1050000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('6a4497e9-ea14-4f28-9b66-f6362df44478', '517cf0cb-27a2-4452-8696-cd902a9c0bee', 'Nex-N2-Pro:free', NULL, true, '2026-06-08 18:00:23.598949+00', '2026-06-08 18:00:23.598949+00', '{"tag": "Latest", "prompt": 0, "completion": 0, "create_time": 1780937140, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 262144, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('83b2afd9-960b-4a27-b499-cc2be5b87a43', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3-vl-8b-instruct', NULL, true, '2026-05-19 17:03:51.860023+00', '2026-07-10 09:00:21.703069+00', '{"tag": "", "prompt": 0.000000117, "completion": 0.000000455, "create_time": 1760463308, "schema_version": 1, "max_context_tokens": 256000, "max_completion_tokens": 32768, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('81b04e93-c87a-4557-ab0a-f8bd52e1a213', '09b94796-8f59-4775-976b-ee85a5a6d927', 'claude-haiku-latest', NULL, true, '2026-05-06 08:32:17.710254+00', '2026-07-10 09:00:20.434847+00', '{"tag": "", "prompt": 0.000001, "completion": 0.000005, "web_search": 0.01, "create_time": 1777318492, "schema_version": 1, "input_cache_read": 0.0000001, "input_cache_write": 0.00000125, "max_context_tokens": 200000, "input_cache_write_1h": 0.000002, "max_completion_tokens": 64000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('cd59dad9-af69-43d2-b53c-6d0e68e63655', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3.5-27b', NULL, true, '2026-05-06 08:32:18.444141+00', '2026-07-10 09:00:20.979941+00', '{"tag": "", "prompt": 0.000000195, "completion": 0.00000156, "create_time": 1772053810, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('701b8ef0-4927-47d9-9e24-ba4ad07d069d', '2be846df-8b85-4d9e-b94e-3f0c5cc3d223', 'owl-alpha', NULL, true, '2026-06-07 15:16:14.639932+00', '2026-06-30 12:00:45.436556+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1777398589, "schema_version": 1, "max_context_tokens": 1048756, "max_completion_tokens": 262144, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('c181a64b-5733-4c42-a43e-40ac884eba32', '38f5b8d7-54ae-4be3-9f15-d7c67a355134', 'glm-4.6', NULL, true, '2026-05-19 17:03:52.132132+00', '2026-07-10 09:00:21.803706+00', '{"tag": "", "prompt": 0.00000043, "completion": 0.00000174, "create_time": 1759235576, "schema_version": 1, "input_cache_read": 0.00000008, "max_context_tokens": 202752, "max_completion_tokens": 131072, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('0bd6206f-900b-4d6b-ac13-cade10f23356', 'f5522dbf-cdff-469d-b78b-b68f3e28b83c', 'glm-4.7', NULL, true, '2026-05-19 17:03:51.075605+00', '2026-07-10 09:00:21.362739+00', '{"tag": "", "prompt": 0.0000004, "completion": 0.00000175, "create_time": 1766378014, "schema_version": 1, "input_cache_read": 0.00000008, "max_context_tokens": 202752, "max_completion_tokens": 131072, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('dc99144d-5555-4ab0-a386-998cfff515d3', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3.5-122b-a10b', NULL, true, '2026-05-19 17:03:50.276791+00', '2026-07-10 09:00:21.008239+00', '{"tag": "", "prompt": 0.00000026, "completion": 0.00000208, "create_time": 1772053789, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 262144, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('c5582cdd-a616-4812-8606-9a15e2c62da5', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3-next-80b-a3b-thinking', NULL, true, '2026-05-19 17:03:52.586985+00', '2026-07-10 09:00:21.967211+00', '{"tag": "", "prompt": 0.0000000975, "completion": 0.00000078, "create_time": 1757612284, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 32768, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('4b7dabf9-673f-499b-905a-8beb4c62204f', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemini-3.1-flash-image-preview', NULL, true, '2026-05-06 08:32:18.429619+00', '2026-07-10 09:00:20.952278+00', '{"tag": "", "prompt": 0.0000005, "completion": 0.000003, "web_search": 0.014, "create_time": 1772119558, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 32768, "model_interaction_type": "image"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('57e2d6cb-93a3-46b9-896e-df947ebd8faa', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3.5-flash-02-23', NULL, true, '2026-05-06 08:32:18.459551+00', '2026-07-10 09:00:21.022567+00', '{"tag": "", "prompt": 0.000000065, "completion": 0.00000026, "create_time": 1772053776, "schema_version": 1, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('2b316e34-b9a9-4486-a64f-5ac295084d1c', '38f5b8d7-54ae-4be3-9f15-d7c67a355134', 'glm-5v-turbo', NULL, true, '2026-05-19 17:03:49.429946+00', '2026-07-10 09:00:20.751057+00', '{"tag": "", "prompt": 0.0000012, "completion": 0.000004, "create_time": 1775061458, "schema_version": 1, "input_cache_read": 0.00000024, "max_context_tokens": 202752, "max_completion_tokens": 131072, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('a47ce3dc-e5eb-43f8-b609-28ab09647ea8', '98f229c5-42ef-4167-91b1-47846b4f381e', 'grok-4.20', NULL, true, '2026-05-06 08:32:18.275574+00', '2026-07-10 09:00:20.778354+00', '{"tag": "", "prompt": 0.00000125, "completion": 0.0000025, "web_search": 0.005, "create_time": 1774979019, "schema_version": 1, "input_cache_read": 0.0000002, "max_context_tokens": 2000000, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('5852d8f9-6748-49f9-8eb3-ed7d1ee74afb', '4d50bc54-56de-46a6-97db-46362130d4b8', 'kimi-k2.7-code:free', NULL, true, '2026-06-19 18:00:26.166309+00', '2026-06-19 18:00:53.101671+00', '{"tag": "Latest", "prompt": 0, "completion": 0, "create_time": 1781266361, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 262144, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('d5291b03-6d73-45e6-bacf-aab8c0136dd6', '517cf0cb-27a2-4452-8696-cd902a9c0bee', 'nex-n2-pro:free', NULL, true, '2026-06-08 19:00:38.97269+00', '2026-06-22 14:01:00.32452+00', '{"tag": "Latest", "prompt": 0, "completion": 0, "create_time": 1780937140, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 256000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('911891eb-d925-4020-a167-5a5ee6860604', '004533f3-71af-47b3-a4b4-9dcd2eeff9b8', 'mistral-small-24b-instruct-2501', NULL, true, '2026-05-06 08:32:20.209371+00', '2026-07-10 09:00:22.897394+00', '{"tag": "", "prompt": 0.00000005, "completion": 0.00000008, "create_time": 1738255409, "schema_version": 1, "max_context_tokens": 32768, "max_completion_tokens": 16384, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('1bb3b0d8-202a-4ff4-b231-ed1810d39bb8', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5.4-pro', NULL, true, '2026-05-06 08:32:18.380049+00', '2026-07-10 09:00:20.910434+00', '{"tag": "", "prompt": 0.00003, "completion": 0.00018, "web_search": 0.01, "create_time": 1772734366, "schema_version": 1, "max_context_tokens": 1050000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('c4fa57fb-14aa-44e4-ab74-929c93f3e1ce', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemma-3-4b-it', NULL, true, '2026-05-06 08:32:19.877623+00', '2026-07-10 09:00:22.756061+00', '{"tag": "", "prompt": 0.00000005, "completion": 0.0000001, "create_time": 1741905510, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 16384, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('1428007c-ba42-4ad2-886a-721248db76ce', 'd5041374-7609-493f-8ef4-65459cd94869', 'kat-coder-pro-v2', NULL, true, '2026-05-06 08:32:18.290972+00', '2026-07-10 09:00:20.799534+00', '{"tag": "Latest", "prompt": 0.0000003, "completion": 0.0000012, "create_time": 1774649310, "schema_version": 1, "input_cache_read": 0.00000006, "max_context_tokens": 256000, "max_completion_tokens": 80000, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('545cd1e2-ce5a-4c83-a9c6-55d8ef9efb5f', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3-vl-235b-a22b-instruct', NULL, true, '2026-05-19 17:03:52.299493+00', '2026-07-10 09:00:21.874181+00', '{"tag": "", "prompt": 0.0000002, "completion": 0.00000088, "create_time": 1758668687, "schema_version": 1, "input_cache_read": 0.00000011, "max_context_tokens": 262144, "max_completion_tokens": 16384, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('4cbcb06d-2e74-4c72-86fd-7d9b240c416d', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3-next-80b-a3b-instruct', NULL, true, '2026-05-19 17:03:52.666454+00', '2026-07-10 09:00:22.008717+00', '{"tag": "", "prompt": 0.00000009, "completion": 0.0000011, "create_time": 1757612213, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 16384, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('48fcb49e-50ee-4c81-bfa4-b1383f9fa019', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3-vl-8b-thinking', NULL, true, '2026-05-19 17:03:51.810476+00', '2026-07-10 09:00:21.681746+00', '{"tag": "", "prompt": 0.000000117, "completion": 0.000001365, "create_time": 1760463746, "schema_version": 1, "max_context_tokens": 256000, "max_completion_tokens": 32768, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('c003e770-9b1e-4b59-a631-cb9c1f962ba6', '3b6bbaa2-d1ec-40c6-8a74-2371398db82e', 'nemotron-3-nano-30b-a3b', NULL, true, '2026-05-06 08:32:18.71037+00', '2026-07-10 09:00:21.383877+00', '{"tag": "", "prompt": 0.00000005, "completion": 0.0000002, "create_time": 1765731275, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 228000, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('ed223d7c-2d3e-4776-af20-4f47ea9fcf04', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3.5-122b-a10b', NULL, true, '2026-05-19 17:03:50.292431+00', '2026-07-10 09:00:21.015593+00', '{"tag": "", "prompt": 0.00000026, "completion": 0.00000208, "create_time": 1772053789, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 262144, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('3ba89784-82c9-4a22-8ec3-86f4296b51ca', 'fee873f7-15b7-4809-b9ba-2737224b15ed', 'virtuoso-large', NULL, true, '2026-05-06 08:32:19.640936+00', '2026-07-10 09:00:22.548215+00', '{"tag": "", "prompt": 0.00000075, "completion": 0.0000012, "create_time": 1746478885, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 64000, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('16fa9bfc-cbaa-41c3-b689-ac277b1bd106', '036cfc6e-0a26-4786-b7b6-7a5739ea6d5b', 'inflection-3-pi', NULL, true, '2026-05-06 08:32:20.490619+00', '2026-07-10 09:00:23.066618+00', '{"tag": "Latest", "prompt": 0.0000025, "completion": 0.00001, "create_time": 1728604800, "schema_version": 1, "max_context_tokens": 8000, "max_completion_tokens": 1024, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('0c76bffb-403a-4da3-a57e-170e569ea80b', '3865ca54-b799-4bb8-b769-9ea883771901', 'aion-3.0-mini', NULL, true, '2026-07-07 20:00:01.751506+00', '2026-07-10 09:00:20.12482+00', '{"tag": "Latest", "prompt": 0.0000007, "completion": 0.0000014, "create_time": 1783443096, "schema_version": 1, "input_cache_read": 0.00000018, "max_context_tokens": 131072, "max_completion_tokens": 32768, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('69558902-989f-462b-aa2e-a05bdc8eb7a4', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemini-3.5-flash', NULL, true, '2026-05-19 18:00:26.909048+00', '2026-07-10 09:00:20.370309+00', '{"tag": "", "audio": 0.000003, "image": 0.0000015, "prompt": 0.0000015, "completion": 0.000009, "web_search": 0.014, "create_time": 1779193800, "schema_version": 1, "input_cache_read": 0.00000015, "input_cache_write": 0.00000008333333333333334, "internal_reasoning": 0.000009, "max_context_tokens": 1048576, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('c7a97942-0221-46e8-9d6d-c14d6314f499', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3-235b-a22b-2507', NULL, true, '2026-05-19 17:03:53.614978+00', '2026-07-10 09:00:22.397218+00', '{"tag": "", "prompt": 0.00000009, "completion": 0.0000001, "create_time": 1753119555, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 16384, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('c8e0fa8f-9767-464d-9591-d93b20ef6f3d', '55857a3a-55f0-4879-b39f-cd252a8bcbf9', 'glm-4.7-flash', NULL, true, '2026-05-06 08:32:18.64695+00', '2026-07-10 09:00:21.293033+00', '{"tag": "", "prompt": 0.00000006, "completion": 0.0000004, "create_time": 1768833913, "schema_version": 1, "input_cache_read": 0.00000001, "max_context_tokens": 202752, "max_completion_tokens": 16384, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('9b5f9e2c-a724-4e0e-80eb-47ba8ed29762', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5.6-luna', NULL, true, '2026-07-09 18:00:23.016006+00', '2026-07-10 09:00:20.074289+00', '{"tag": "", "prompt": 0.000001, "completion": 0.000006, "web_search": 0.01, "create_time": 1783590864, "schema_version": 1, "input_cache_read": 0.0000001, "input_cache_write": 0.00000125, "max_context_tokens": 1050000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('bf39fce8-cbc5-4a2b-886b-6bac697b9fae', '09b94796-8f59-4775-976b-ee85a5a6d927', 'claude-opus-4.5', NULL, true, '2026-05-06 08:32:18.851916+00', '2026-07-10 09:00:21.52143+00', '{"tag": "", "prompt": 0.000005, "completion": 0.000025, "web_search": 0.01, "create_time": 1764010580, "schema_version": 1, "input_cache_read": 0.0000005, "input_cache_write": 0.00000625, "max_context_tokens": 200000, "input_cache_write_1h": 0.00001, "max_completion_tokens": 64000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('56ab6729-bbf5-4a0e-b3df-b90ee6414dca', '004533f3-71af-47b3-a4b4-9dcd2eeff9b8', 'mistral-small-3.2-24b-instruct', NULL, true, '2026-05-06 08:32:19.513058+00', '2026-07-10 09:00:22.454185+00', '{"tag": "", "prompt": 0.000000075, "completion": 0.0000002, "create_time": 1750443016, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": 16384, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('47d29942-1bd7-434c-a158-3ab96ed311c0', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3.5-flash-02-23', NULL, true, '2026-05-19 17:03:50.334524+00', '2026-07-10 09:00:21.037426+00', '{"tag": "", "prompt": 0.000000065, "completion": 0.00000026, "create_time": 1772053776, "schema_version": 1, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('a144082a-7d7d-4435-b96b-95f79cab6357', 'aab4161e-3e3f-440f-8815-415689b823ca', 'step-3.5-flash', NULL, true, '2026-05-06 08:32:18.573545+00', '2026-07-10 09:00:21.214819+00', '{"tag": "", "prompt": 0.0000001, "completion": 0.0000003, "create_time": 1769728337, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 65536, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('5da73e4f-14d6-4af4-a594-f6051b70ccda', '55857a3a-55f0-4879-b39f-cd252a8bcbf9', 'glm-5-turbo', NULL, true, '2026-05-06 08:32:18.346723+00', '2026-07-10 09:00:20.848002+00', '{"tag": "", "prompt": 0.0000012, "completion": 0.000004, "create_time": 1773583573, "schema_version": 1, "input_cache_read": 0.00000024, "max_context_tokens": 262144, "max_completion_tokens": 131072, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('341727c4-59f8-4991-9c70-7c01cb2a4041', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'o1', NULL, true, '2026-05-06 08:32:20.309526+00', '2026-07-10 09:00:22.953738+00', '{"tag": "", "prompt": 0.000015, "completion": 0.00006, "web_search": 0.01, "create_time": 1734459999, "schema_version": 1, "input_cache_read": 0.0000075, "max_context_tokens": 200000, "max_completion_tokens": 100000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('47b97880-06ab-4600-96b3-41319b7adce6', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemini-2.0-flash-001', NULL, true, '2026-05-06 08:32:20.062655+00', '2026-06-01 13:00:23.969214+00', '{"tag": "", "audio": 0.0000007, "image": 0.0000001, "prompt": 0.0000001, "completion": 0.0000004, "web_search": 0.014, "create_time": 1738769413, "schema_version": 1, "input_cache_read": 0.000000025, "input_cache_write": 0.00000008333333333333334, "internal_reasoning": 0.0000004, "max_context_tokens": 1048576, "max_completion_tokens": 8192, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('9a9df2af-3388-4d5e-92b5-2956567cc5d6', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'o4-mini-high', NULL, true, '2026-05-06 08:32:19.728249+00', '2026-07-10 09:00:22.674941+00', '{"tag": "", "prompt": 0.0000011, "completion": 0.0000044, "web_search": 0.01, "create_time": 1744824212, "schema_version": 1, "input_cache_read": 0.000000275, "max_context_tokens": 200000, "max_completion_tokens": 100000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('efed506f-caa9-474b-9f87-2e38a7943a38', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5.4-mini', NULL, true, '2026-05-06 08:32:18.332677+00', '2026-07-10 09:00:20.833905+00', '{"tag": "", "prompt": 0.00000075, "completion": 0.0000045, "web_search": 0.01, "create_time": 1773748178, "schema_version": 1, "input_cache_read": 0.000000075, "max_context_tokens": 400000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('c60f7276-f0cf-4de0-b342-d01a420d82cf', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemini-2.5-flash-image', NULL, true, '2026-05-06 08:32:19.04753+00', '2026-07-10 09:00:21.741008+00', '{"tag": "", "audio": 0.000001, "image": 0.0000003, "prompt": 0.0000003, "completion": 0.0000025, "web_search": 0.014, "create_time": 1759870431, "schema_version": 1, "input_cache_read": 0.00000003, "input_cache_write": 0.00000008333333333333334, "internal_reasoning": 0.0000025, "max_context_tokens": 32768, "max_completion_tokens": 32768, "model_interaction_type": "image"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('19d4700f-484c-48ef-9d6f-bc8773fc4f15', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3-235b-a22b', NULL, true, '2026-05-19 17:03:54.557021+00', '2026-07-10 09:00:22.668138+00', '{"tag": "", "prompt": 0.000000455, "completion": 0.00000182, "create_time": 1745875757, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 8192, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('4a4aeac1-f96b-448b-a739-7c4689e15884', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3-vl-235b-a22b-instruct', NULL, true, '2026-05-06 08:32:19.115747+00', '2026-07-10 09:00:21.858272+00', '{"tag": "", "prompt": 0.0000002, "completion": 0.00000088, "create_time": 1758668687, "schema_version": 1, "input_cache_read": 0.00000011, "max_context_tokens": 262144, "max_completion_tokens": 16384, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('a641bcbb-451a-44fa-92a8-3e5ee1c9fdc9', '09b94796-8f59-4775-976b-ee85a5a6d927', 'claude-opus-4.1', NULL, true, '2026-05-06 08:32:19.352253+00', '2026-07-10 09:00:22.210872+00', '{"tag": "", "prompt": 0.000015, "completion": 0.000075, "web_search": 0.01, "create_time": 1754411591, "schema_version": 1, "input_cache_read": 0.0000015, "input_cache_write": 0.00001875, "max_context_tokens": 200000, "input_cache_write_1h": 0.00003, "max_completion_tokens": 32000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('e36ec2ff-1d37-4bfa-9228-2eca33d06de2', '004533f3-71af-47b3-a4b4-9dcd2eeff9b8', 'mistral-small-2603', NULL, true, '2026-05-06 08:32:18.33954+00', '2026-07-10 09:00:20.841088+00', '{"tag": "", "prompt": 0.00000015, "completion": 0.0000006, "create_time": 1773695685, "schema_version": 1, "input_cache_read": 0.000000015, "max_context_tokens": 262144, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('9cbe80f0-4bf4-463a-a958-936548c7c069', '4d50bc54-56de-46a6-97db-46362130d4b8', 'kimi-k2-thinking', NULL, true, '2026-05-06 08:32:18.910877+00', '2026-07-10 09:00:21.570583+00', '{"tag": "", "prompt": 0.0000006, "completion": 0.0000025, "create_time": 1762440622, "schema_version": 1, "input_cache_read": 0.00000015, "max_context_tokens": 262144, "max_completion_tokens": 100352, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('9f5e14b4-b849-47e8-be4c-6ab82bece62c', 'f5522dbf-cdff-469d-b78b-b68f3e28b83c', 'glm-5-turbo', NULL, true, '2026-05-19 17:03:49.939007+00', '2026-07-10 09:00:20.861807+00', '{"tag": "", "prompt": 0.0000012, "completion": 0.000004, "create_time": 1773583573, "schema_version": 1, "input_cache_read": 0.00000024, "max_context_tokens": 262144, "max_completion_tokens": 131072, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('5aca306f-8bcc-42f3-850f-645834d70e80', '3b6bbaa2-d1ec-40c6-8a74-2371398db82e', 'nemotron-3-super-120b-a12b:free', NULL, true, '2026-06-07 15:16:15.053853+00', '2026-07-10 09:00:20.868878+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1773245239, "schema_version": 1, "max_context_tokens": 1000000, "max_completion_tokens": 262144, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('82a35197-1df2-4586-899e-0a6000ced53f', '2810aca3-c2e5-426d-a8c8-2bddc1ff480d', 'minimax-m2.7', NULL, true, '2026-05-06 08:32:18.318618+00', '2026-07-10 09:00:20.813045+00', '{"tag": "", "prompt": 0.00000024, "completion": 0.00000096, "create_time": 1773836697, "schema_version": 1, "max_context_tokens": 204800, "max_completion_tokens": 196608, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('0faa0d03-334f-4d29-baba-0ce07de25837', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-4o-2024-08-06', NULL, true, '2026-05-06 08:32:20.611302+00', '2026-07-10 09:00:23.175018+00', '{"tag": "", "prompt": 0.0000025, "completion": 0.00001, "create_time": 1722902400, "schema_version": 1, "input_cache_read": 0.00000125, "max_context_tokens": 128000, "max_completion_tokens": 16384, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('b1a1c28d-b431-4509-aead-88ab9028554b', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5.4-nano', NULL, true, '2026-05-06 08:32:18.325847+00', '2026-07-10 09:00:20.827085+00', '{"tag": "", "prompt": 0.0000002, "completion": 0.00000125, "web_search": 0.01, "create_time": 1773748187, "schema_version": 1, "input_cache_read": 0.00000002, "max_context_tokens": 400000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('133bf83c-be7e-4251-9a6f-13f21763fa5c', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5.6-terra-pro', NULL, true, '2026-07-09 18:00:23.023105+00', '2026-07-10 09:00:20.081267+00', '{"tag": "", "prompt": 0.0000025, "completion": 0.000015, "web_search": 0.01, "create_time": 1783590861, "schema_version": 1, "input_cache_read": 0.00000025, "input_cache_write": 0.000003125, "max_context_tokens": 1050000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('0a911a73-25da-4f28-81f6-3ec4ae6c7fc5', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen-2.5-coder-32b-instruct', NULL, true, '2026-05-19 17:03:55.483493+00', '2026-07-10 09:00:23.03147+00', '{"tag": "", "prompt": 0.00000066, "completion": 0.000001, "create_time": 1731368400, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": 32768, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('34ff6f9d-ef6d-42aa-ac59-1d08ee7d95d1', '38f5b8d7-54ae-4be3-9f15-d7c67a355134', 'glm-5-turbo', NULL, true, '2026-05-19 17:03:49.925352+00', '2026-07-10 09:00:20.85483+00', '{"tag": "", "prompt": 0.0000012, "completion": 0.000004, "create_time": 1773583573, "schema_version": 1, "input_cache_read": 0.00000024, "max_context_tokens": 262144, "max_completion_tokens": 131072, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('603562f5-12a9-4e8a-b83f-dc7bb8215300', '47927a94-7043-4921-b67e-8389985f9aab', 'command-r-plus-08-2024', NULL, true, '2026-05-06 08:32:20.556298+00', '2026-07-10 09:00:23.139519+00', '{"tag": "", "prompt": 0.0000025, "completion": 0.00001, "create_time": 1724976000, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": 4000, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('1b68986d-3c7d-4ccf-a25a-d9afe151d0ff', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemma-4-26b-a4b-it:free', NULL, true, '2026-06-07 15:16:14.896568+00', '2026-07-10 09:00:20.695947+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1775227989, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 32768, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('660a0c2d-871a-4521-b737-2737b09e0e9f', 'f5522dbf-cdff-469d-b78b-b68f3e28b83c', 'glm-5.1', NULL, true, '2026-05-21 16:00:32.59082+00', '2026-07-10 09:00:20.688684+00', '{"tag": "", "prompt": 0.000000966, "completion": 0.000003036, "create_time": 1775578025, "schema_version": 1, "input_cache_read": 0.0000001794, "max_context_tokens": 202752, "max_completion_tokens": 128000, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('12f8767d-5cff-440a-b036-466164521dc5', '8602ce14-e8dc-435a-8d40-c42e1b094488', 'hermes-3-llama-3.1-70b', NULL, true, '2026-05-06 08:32:20.581991+00', '2026-07-10 09:00:23.148226+00', '{"tag": "", "prompt": 0.0000007, "completion": 0.0000007, "create_time": 1723939200, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 16384, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('6481fafb-07e2-4014-a9a2-cfa6cfb5a34f', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3.5-9b', NULL, true, '2026-05-19 17:03:50.014312+00', '2026-07-10 09:00:20.896369+00', '{"tag": "", "prompt": 0.0000001, "completion": 0.00000015, "create_time": 1773152396, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 262144, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('6ad163ae-e518-40f1-915c-27b2dfb53099', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3.5-plus-02-15', NULL, true, '2026-05-06 08:32:18.513582+00', '2026-07-10 09:00:21.080792+00', '{"tag": "", "prompt": 0.00000026, "completion": 0.00000156, "create_time": 1771229416, "schema_version": 1, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('3ba65a1f-bd0c-4680-975e-c12a4883c07c', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemma-3n-e4b-it', NULL, true, '2026-05-06 08:32:19.601427+00', '2026-07-10 09:00:22.526046+00', '{"tag": "", "prompt": 0.00000006, "completion": 0.00000012, "create_time": 1747776824, "schema_version": 1, "max_context_tokens": 32768, "max_completion_tokens": null, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('faa387bc-728d-4c42-9479-2f2502ff5e1f', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5.6-sol-pro', NULL, true, '2026-07-09 18:00:23.037421+00', '2026-07-10 09:00:20.095963+00', '{"tag": "", "prompt": 0.000005, "completion": 0.00003, "web_search": 0.01, "create_time": 1783590854, "schema_version": 1, "input_cache_read": 0.0000005, "input_cache_write": 0.00000625, "max_context_tokens": 1050000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('abea2a37-f23d-4591-b2c7-2f9bb341666e', 'd76d415e-972f-4cf9-9727-78e092ce5c56', 'seed-2.0-lite', NULL, true, '2026-05-06 08:32:18.365441+00', '2026-07-10 09:00:20.882592+00', '{"tag": "Latest", "prompt": 0.00000025, "completion": 0.000002, "create_time": 1773157231, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 131072, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('737f18ea-2732-44e5-b824-39f70f8e584d', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5.6-terra', NULL, true, '2026-07-09 18:00:23.030211+00', '2026-07-10 09:00:20.088599+00', '{"tag": "", "prompt": 0.0000025, "completion": 0.000015, "web_search": 0.01, "create_time": 1783590857, "schema_version": 1, "input_cache_read": 0.00000025, "input_cache_write": 0.000003125, "max_context_tokens": 1050000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('ecb71098-11c4-4f36-8d50-ce004a735709', '3b6bbaa2-d1ec-40c6-8a74-2371398db82e', 'nemotron-nano-9b-v2', NULL, true, '2026-05-06 08:32:19.206475+00', '2026-06-11 13:00:48.734941+00', '{"tag": "", "prompt": 0.00000004, "completion": 0.00000016, "create_time": 1757106807, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 16384, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('f854651b-7642-4c1d-8ffe-149963451561', '8602ce14-e8dc-435a-8d40-c42e1b094488', 'hermes-3-llama-3.1-405b:free', NULL, true, '2026-06-07 15:16:17.434548+00', '2026-07-10 09:00:23.156085+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1723766400, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": null, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('ca1acdda-d3eb-464a-b180-ef72a7e90a0a', 'ec126a88-8820-4ab3-ba63-7cd1c1b1aaf2', 'minimax-m2.7', NULL, true, '2026-05-19 17:03:49.823398+00', '2026-07-10 09:00:20.819906+00', '{"tag": "", "prompt": 0.00000024, "completion": 0.00000096, "create_time": 1773836697, "schema_version": 1, "max_context_tokens": 204800, "max_completion_tokens": 196608, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('bf18d1e2-96f2-495a-99f5-97d3b9dea97e', '004533f3-71af-47b3-a4b4-9dcd2eeff9b8', 'mistral-medium-3', NULL, true, '2026-05-06 08:32:19.608846+00', '2026-07-10 09:00:22.532832+00', '{"tag": "", "prompt": 0.0000004, "completion": 0.000002, "create_time": 1746627341, "schema_version": 1, "input_cache_read": 0.00000004, "max_context_tokens": 131072, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('31a208e1-77be-4fda-a2fe-ac747ef5a272', 'fddcd474-2972-4c83-aefa-3403ab2e386c', 'reka-edge', NULL, true, '2026-05-06 08:32:18.297824+00', '2026-07-10 09:00:20.806364+00', '{"tag": "Latest", "prompt": 0.0000001, "completion": 0.0000001, "create_time": 1774026965, "schema_version": 1, "max_context_tokens": 16384, "max_completion_tokens": 16384, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('2260e89f-f738-44fc-94e5-d3793757d67c', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3.5-9b', NULL, true, '2026-05-06 08:32:18.372774+00', '2026-07-10 09:00:20.889425+00', '{"tag": "", "prompt": 0.0000001, "completion": 0.00000015, "create_time": 1773152396, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 262144, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('5ed34117-97ee-4d09-b706-e959bda8a375', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-4o-search-preview', NULL, true, '2026-05-06 08:32:19.923635+00', '2026-07-10 09:00:22.785446+00', '{"tag": "", "prompt": 0.0000025, "completion": 0.00001, "web_search": 0.035, "create_time": 1741817949, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": 16384, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('ca0456af-c0f2-481a-8e1c-276c7d267a1b', '8602ce14-e8dc-435a-8d40-c42e1b094488', 'hermes-3-llama-3.1-405b', NULL, true, '2026-05-06 08:32:20.599344+00', '2026-07-10 09:00:23.163183+00', '{"tag": "", "prompt": 0.000001, "completion": 0.000001, "create_time": 1723766400, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 16384, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('eac98572-708c-4228-bbfb-6484c22ee32a', '3b6bbaa2-d1ec-40c6-8a74-2371398db82e', 'nemotron-3-super-120b-a12b', NULL, true, '2026-05-06 08:32:18.357606+00', '2026-07-10 09:00:20.875716+00', '{"tag": "", "prompt": 0.00000008, "completion": 0.00000045, "create_time": 1773245239, "schema_version": 1, "max_context_tokens": 1000000, "max_completion_tokens": null, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('46e9c1cc-8d90-4aee-b51d-860d37058963', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3-vl-30b-a3b-thinking', NULL, true, '2026-05-19 17:03:51.984053+00', '2026-07-10 09:00:21.755412+00', '{"tag": "", "prompt": 0.00000013, "completion": 0.00000156, "create_time": 1759794479, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 32768, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('d11dfa75-6d37-49b0-b7b3-144b3e626aae', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3.5-35b-a3b', NULL, true, '2026-05-06 08:32:18.437132+00', '2026-07-10 09:00:20.959102+00', '{"tag": "", "prompt": 0.00000014, "completion": 0.000001, "create_time": 1772053822, "schema_version": 1, "input_cache_read": 0.00000005, "max_context_tokens": 262144, "max_completion_tokens": 81920, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('6f118b3a-a171-4ffb-924b-296e4e132624', 'ec126a88-8820-4ab3-ba63-7cd1c1b1aaf2', 'minimax-m2-her', NULL, true, '2026-05-19 17:03:50.849135+00', '2026-07-10 09:00:21.250782+00', '{"tag": "", "prompt": 0.0000003, "completion": 0.0000012, "create_time": 1769177239, "schema_version": 1, "input_cache_read": 0.00000003, "max_context_tokens": 65536, "max_completion_tokens": 2048, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('13cfee04-9a35-4ddd-af1b-32b2be16696a', '55857a3a-55f0-4879-b39f-cd252a8bcbf9', 'glm-4.5-air:free', NULL, true, '2026-06-07 15:16:16.634746+00', '2026-06-09 22:00:15.517638+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1753471258, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 96000, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('dcb3bac0-a9ef-425a-87da-c76b04d48b5e', '38f5b8d7-54ae-4be3-9f15-d7c67a355134', 'glm-4.5-air:free', NULL, true, '2026-06-07 15:16:16.64088+00', '2026-06-09 22:00:15.523058+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1753471258, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 96000, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('ac4f8f63-9c99-4e38-902a-b1238612f788', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen-plus-2025-07-28:thinking', NULL, true, '2026-05-19 17:03:52.718485+00', '2026-07-10 09:00:22.037156+00', '{"tag": "", "prompt": 0.00000026, "completion": 0.00000078, "create_time": 1757347599, "schema_version": 1, "input_cache_write": 0.000000325, "max_context_tokens": 1000000, "max_completion_tokens": 32768, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('1fb588ca-e152-47ca-b8b7-a9b1fb8e1486', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3.5-35b-a3b', NULL, true, '2026-05-19 17:03:50.18246+00', '2026-07-10 09:00:20.972977+00', '{"tag": "", "prompt": 0.00000014, "completion": 0.000001, "create_time": 1772053822, "schema_version": 1, "input_cache_read": 0.00000005, "max_context_tokens": 262144, "max_completion_tokens": 81920, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('7a81d2de-7ab7-4431-8ad5-19683d74fdb5', '98f229c5-42ef-4167-91b1-47846b4f381e', 'grok-latest', NULL, true, '2026-07-08 16:00:02.063669+00', '2026-07-10 09:00:20.117475+00', '{"tag": "", "prompt": 0.000002, "completion": 0.000006, "web_search": 0.005, "create_time": 1783519360, "schema_version": 1, "input_cache_read": 0.0000005, "max_context_tokens": 500000, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('c884fb51-12bf-422a-9d6b-aa80b56f91f5', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3.5-35b-a3b', NULL, true, '2026-05-19 17:03:50.165775+00', '2026-07-10 09:00:20.966266+00', '{"tag": "", "prompt": 0.00000014, "completion": 0.000001, "create_time": 1772053822, "schema_version": 1, "input_cache_read": 0.00000005, "max_context_tokens": 262144, "max_completion_tokens": 81920, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('3dee02b5-9b99-48cd-b025-384c277bf26b', '517cf0cb-27a2-4452-8696-cd902a9c0bee', 'nex-n2-mini', NULL, true, '2026-07-06 20:00:14.663862+00', '2026-07-10 09:00:20.168963+00', '{"tag": "Latest", "prompt": 0.000000025, "completion": 0.0000001, "create_time": 1782312964, "schema_version": 1, "input_cache_read": 0.0000000025, "max_context_tokens": 262144, "max_completion_tokens": 262144, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('ed2441ef-c0b6-415a-8c54-c9731e4df2b4', 'f5522dbf-cdff-469d-b78b-b68f3e28b83c', 'glm-4.5-air:free', NULL, true, '2026-06-07 15:16:16.646741+00', '2026-06-09 22:00:15.528358+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1753471258, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 96000, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('83b378df-6754-410f-becb-bf4841166c8a', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3.5-flash-02-23', NULL, true, '2026-05-19 17:03:50.321883+00', '2026-07-10 09:00:21.030059+00', '{"tag": "", "prompt": 0.000000065, "completion": 0.00000026, "create_time": 1772053776, "schema_version": 1, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('a65fdd78-ba93-403c-ab37-6e0dcb7f31a9', '59f22d14-a479-4667-86e5-7e7d7433603e', 'hy3', NULL, true, '2026-07-06 15:00:25.350259+00', '2026-07-10 09:00:20.147397+00', '{"tag": "Latest", "prompt": 0.00000014, "completion": 0.00000058, "create_time": 1783344048, "schema_version": 1, "input_cache_read": 0.000000035, "max_context_tokens": 262144, "max_completion_tokens": null, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('69bcf8c6-bdd6-41ce-aef0-570eb13950a5', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5.3-chat', NULL, true, '2026-05-06 08:32:18.408018+00', '2026-07-10 09:00:20.93105+00', '{"tag": "", "prompt": 0.00000175, "completion": 0.000014, "web_search": 0.01, "create_time": 1772564061, "schema_version": 1, "input_cache_read": 0.000000175, "max_context_tokens": 128000, "max_completion_tokens": 16384, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('123621f2-8dc0-43ca-ac7b-b70ae99b0903', 'b0fa945d-ac33-4b5f-99e8-30c52a526c61', 'dolphin-mistral-24b-venice-edition', NULL, true, '2026-07-10 01:00:07.936618+00', '2026-07-10 09:00:22.417915+00', '{"tag": "Latest", "prompt": 0.0000002, "completion": 0.0000009, "create_time": 1752094966, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": 8192, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('f6b56f01-b9ca-4a46-9221-d485805b34d0', '39e2c759-ca87-4a6d-bb13-95d83824f8ea', 'lfm-2-24b-a2b', NULL, true, '2026-05-06 08:32:18.466421+00', '2026-07-09 06:00:49.668579+00', '{"tag": "Latest", "prompt": 0.00000003, "completion": 0.00000012, "create_time": 1772048711, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": null, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('52fa66a2-9e2f-4898-80b9-71b965f73886', 'd76d415e-972f-4cf9-9727-78e092ce5c56', 'seed-2.0-mini', NULL, true, '2026-05-06 08:32:18.422411+00', '2026-07-10 09:00:20.945224+00', '{"tag": "", "prompt": 0.0000001, "completion": 0.0000004, "create_time": 1772131107, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 131072, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('d4963c1e-824a-463f-8f6e-3beba579b397', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5.6-sol', NULL, true, '2026-07-09 18:00:23.044518+00', '2026-07-10 09:00:20.102966+00', '{"tag": "", "prompt": 0.000005, "completion": 0.00003, "web_search": 0.01, "create_time": 1783590850, "schema_version": 1, "input_cache_read": 0.0000005, "input_cache_write": 0.00000625, "max_context_tokens": 1050000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('5ea9098a-a85b-4184-87a9-7b2770148b1f', '3865ca54-b799-4bb8-b769-9ea883771901', 'aion-3.0', NULL, true, '2026-07-07 20:00:01.781411+00', '2026-07-10 09:00:20.132373+00', '{"tag": "", "prompt": 0.000003, "completion": 0.000006, "create_time": 1783443095, "schema_version": 1, "input_cache_read": 0.00000075, "max_context_tokens": 131072, "max_completion_tokens": 32768, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('da89c843-eebf-405e-98ee-d8b6fda2b06d', '98f229c5-42ef-4167-91b1-47846b4f381e', 'grok-4.5', NULL, true, '2026-07-08 18:00:13.04503+00', '2026-07-10 09:00:20.110291+00', '{"tag": "Latest", "prompt": 0.000002, "completion": 0.000006, "web_search": 0.005, "create_time": 1783523154, "schema_version": 1, "input_cache_read": 0.0000005, "max_context_tokens": 500000, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('960a9740-085a-465d-99bf-62fb5df305a3', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3-vl-8b-thinking', NULL, true, '2026-05-19 17:03:51.798386+00', '2026-07-10 09:00:21.674963+00', '{"tag": "", "prompt": 0.000000117, "completion": 0.000001365, "create_time": 1760463746, "schema_version": 1, "max_context_tokens": 256000, "max_completion_tokens": 32768, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('25db07f9-317d-4da8-aafd-1ea652310c34', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3-vl-30b-a3b-instruct', NULL, true, '2026-05-19 17:03:52.033794+00', '2026-07-10 09:00:21.783181+00', '{"tag": "", "prompt": 0.00000013, "completion": 0.00000052, "create_time": 1759794476, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 32768, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('439436d7-9224-4848-86ff-8caf1b45033e', 'f5522dbf-cdff-469d-b78b-b68f3e28b83c', 'glm-4.6', NULL, true, '2026-05-19 17:03:52.148803+00', '2026-07-10 09:00:21.810394+00', '{"tag": "", "prompt": 0.00000043, "completion": 0.00000174, "create_time": 1759235576, "schema_version": 1, "input_cache_read": 0.00000008, "max_context_tokens": 202752, "max_completion_tokens": 131072, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('95824521-d3c3-414a-a565-4c3996c616b1', '004533f3-71af-47b3-a4b4-9dcd2eeff9b8', 'mistral-medium-3-5', NULL, true, '2026-05-06 08:32:17.688456+00', '2026-07-10 09:00:20.420893+00', '{"tag": "Latest", "prompt": 0.0000015, "completion": 0.0000075, "create_time": 1777570439, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('e3c5fbf7-9e30-4e97-873a-5c53827d085c', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3-vl-30b-a3b-instruct', NULL, true, '2026-05-06 08:32:19.061247+00', '2026-07-10 09:00:21.769158+00', '{"tag": "", "prompt": 0.00000013, "completion": 0.00000052, "create_time": 1759794476, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 32768, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('d5635217-1a2e-49ec-bc01-4beda699e33b', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3-vl-8b-instruct', NULL, true, '2026-05-19 17:03:51.841143+00', '2026-07-10 09:00:21.695859+00', '{"tag": "", "prompt": 0.000000117, "completion": 0.000000455, "create_time": 1760463308, "schema_version": 1, "max_context_tokens": 256000, "max_completion_tokens": 32768, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('af480972-f024-4df8-bcb3-5c84ba994063', '09290c5f-fa5f-48d0-b6cb-0f1ce91323c7', 'palmyra-x5', NULL, true, '2026-05-06 08:32:18.610322+00', '2026-07-10 09:00:21.257981+00', '{"tag": "Latest", "prompt": 0.0000006, "completion": 0.000006, "create_time": 1769003823, "schema_version": 1, "max_context_tokens": 1040000, "max_completion_tokens": 8192, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('cc4380cf-51d5-4d8d-b061-9fd4c26f3492', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5-pro', NULL, true, '2026-05-06 08:32:19.068263+00', '2026-07-10 09:00:21.789979+00', '{"tag": "", "prompt": 0.000015, "completion": 0.00012, "web_search": 0.01, "create_time": 1759776663, "schema_version": 1, "max_context_tokens": 400000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('1ad204c2-7eed-4621-ac17-e30dec431de6', '55857a3a-55f0-4879-b39f-cd252a8bcbf9', 'glm-4.6', NULL, true, '2026-05-06 08:32:19.074859+00', '2026-07-10 09:00:21.796851+00', '{"tag": "", "prompt": 0.00000043, "completion": 0.00000174, "create_time": 1759235576, "schema_version": 1, "input_cache_read": 0.00000008, "max_context_tokens": 202752, "max_completion_tokens": 131072, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('3c45e828-b144-4c5c-8bd6-d1ea0d6fcb65', '4d50bc54-56de-46a6-97db-46362130d4b8', 'kimi-k2.7-code', NULL, true, '2026-06-12 13:00:32.344047+00', '2026-07-10 09:00:20.233305+00', '{"tag": "Latest", "prompt": 0.00000072, "completion": 0.00000349, "create_time": 1781266361, "schema_version": 1, "input_cache_read": 0.000000159, "max_context_tokens": 262144, "max_completion_tokens": 262144, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('0b9fa552-e93d-4704-9547-f545e72fc721', '09b94796-8f59-4775-976b-ee85a5a6d927', 'claude-fable-latest', NULL, true, '2026-06-09 19:00:53.857357+00', '2026-07-10 09:00:20.240625+00', '{"tag": "", "prompt": 0.00001, "completion": 0.00005, "web_search": 0.01, "create_time": 1781029944, "schema_version": 1, "input_cache_read": 0.000001, "input_cache_write": 0.0000125, "max_context_tokens": 1000000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('806c023a-e316-4da5-8298-bc77a2d21b12', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5.3-codex', NULL, true, '2026-05-06 08:32:18.481638+00', '2026-07-10 09:00:21.051968+00', '{"tag": "", "prompt": 0.00000175, "completion": 0.000014, "web_search": 0.01, "create_time": 1771959164, "schema_version": 1, "input_cache_read": 0.000000175, "max_context_tokens": 400000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('07238411-1548-402c-935e-a00cc63bd257', '98f229c5-42ef-4167-91b1-47846b4f381e', 'grok-4.1-fast', NULL, true, '2026-05-06 08:32:18.867262+00', '2026-05-15 18:00:42.290181+00', '{"tag": "", "prompt": 0.0000002, "completion": 0.0000005, "web_search": 0.005, "create_time": 1763587502, "schema_version": 1, "input_cache_read": 0.00000005, "max_context_tokens": 2000000, "max_completion_tokens": 30000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('396f4d34-3531-4e90-a027-754941b65157', '3b6bbaa2-d1ec-40c6-8a74-2371398db82e', 'llama-3.3-nemotron-super-49b-v1.5', NULL, true, '2026-05-06 08:32:19.033413+00', '2026-07-10 09:00:21.73224+00', '{"tag": "", "prompt": 0.0000004, "completion": 0.0000004, "create_time": 1760101395, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 16384, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('b992fd7d-7e3f-427d-b5c1-ed22c9444fc1', '09b94796-8f59-4775-976b-ee85a5a6d927', 'claude-haiku-4.5', NULL, true, '2026-05-06 08:32:18.990699+00', '2026-07-10 09:00:21.660934+00', '{"tag": "", "prompt": 0.000001, "completion": 0.000005, "web_search": 0.01, "create_time": 1760547638, "schema_version": 1, "input_cache_read": 0.0000001, "input_cache_write": 0.00000125, "max_context_tokens": 200000, "input_cache_write_1h": 0.000002, "max_completion_tokens": 64000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('f5ec1866-1f74-4299-bd98-1535cc0c3309', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3-vl-30b-a3b-thinking', NULL, true, '2026-05-06 08:32:19.054379+00', '2026-07-10 09:00:21.748128+00', '{"tag": "", "prompt": 0.00000013, "completion": 0.00000156, "create_time": 1759794479, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 32768, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('d58dcf24-1e57-48f2-a963-600bf4e5a586', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3-vl-8b-instruct', NULL, true, '2026-05-06 08:32:19.005486+00', '2026-07-10 09:00:21.689044+00', '{"tag": "", "prompt": 0.000000117, "completion": 0.000000455, "create_time": 1760463308, "schema_version": 1, "max_context_tokens": 256000, "max_completion_tokens": 32768, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('c7f7725c-526f-405e-93f3-3a93617882dc', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3-vl-30b-a3b-thinking', NULL, true, '2026-05-19 17:03:51.996047+00', '2026-07-10 09:00:21.762213+00', '{"tag": "", "prompt": 0.00000013, "completion": 0.00000156, "create_time": 1759794479, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 32768, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('a534ce88-9f69-4daa-9f91-f0da8ae282f1', '09b94796-8f59-4775-976b-ee85a5a6d927', 'claude-sonnet-4.5', NULL, true, '2026-05-06 08:32:19.081772+00', '2026-07-10 09:00:21.816991+00', '{"tag": "", "prompt": 0.000003, "completion": 0.000015, "web_search": 0.01, "create_time": 1759161676, "schema_version": 1, "input_cache_read": 0.0000003, "input_cache_write": 0.00000375, "max_context_tokens": 1000000, "input_cache_write_1h": 0.000006, "max_completion_tokens": 64000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('746d8646-1c0e-40c3-a80f-e8128e3dc414', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3-vl-30b-a3b-instruct', NULL, true, '2026-05-19 17:03:52.01948+00', '2026-07-10 09:00:21.776259+00', '{"tag": "", "prompt": 0.00000013, "completion": 0.00000052, "create_time": 1759794476, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 32768, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('28721378-7540-4ce6-a583-2b33cb485c22', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3.6-flash', NULL, true, '2026-05-19 17:03:48.788733+00', '2026-07-10 09:00:20.520151+00', '{"tag": "", "prompt": 0.0000001875, "completion": 0.000001125, "create_time": 1777261362, "schema_version": 1, "input_cache_write": 0.000000234375, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('fc829dc8-6d78-4f5c-a948-479ec2389ad0', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3-next-80b-a3b-instruct:free', NULL, true, '2026-06-07 15:16:16.376282+00', '2026-07-10 09:00:21.994854+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1757612213, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": null, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('d71c9305-20e4-4463-817e-1be9ddebe567', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3-vl-8b-thinking', NULL, true, '2026-05-06 08:32:18.997525+00', '2026-07-10 09:00:21.667802+00', '{"tag": "", "prompt": 0.000000117, "completion": 0.000001365, "create_time": 1760463746, "schema_version": 1, "max_context_tokens": 256000, "max_completion_tokens": 32768, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('2659d1a6-e036-4317-b210-7c0cc12a92a0', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3-next-80b-a3b-thinking', NULL, true, '2026-05-19 17:03:52.599426+00', '2026-07-10 09:00:21.974552+00', '{"tag": "", "prompt": 0.0000000975, "completion": 0.00000078, "create_time": 1757612284, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 32768, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('fb1a66e2-b81d-491b-9888-39f70abb062e', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3-vl-235b-a22b-thinking', NULL, true, '2026-05-19 17:03:52.236163+00', '2026-07-10 09:00:21.844181+00', '{"tag": "", "prompt": 0.00000026, "completion": 0.0000026, "create_time": 1758668690, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 32768, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('2eed2ea2-b394-42f1-b2e6-6937b248175f', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3-coder-plus', NULL, true, '2026-05-06 08:32:19.129671+00', '2026-07-10 09:00:21.901802+00', '{"tag": "", "prompt": 0.00000065, "completion": 0.00000325, "create_time": 1758662707, "schema_version": 1, "input_cache_read": 0.00000013, "input_cache_write": 0.0000008125, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('eb367b17-3f23-4784-a974-4c6f928e056b', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3-coder-plus', NULL, true, '2026-05-19 17:03:52.396038+00', '2026-07-10 09:00:21.918207+00', '{"tag": "", "prompt": 0.00000065, "completion": 0.00000325, "create_time": 1758662707, "schema_version": 1, "input_cache_read": 0.00000013, "input_cache_write": 0.0000008125, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('4bf6c921-01db-4d90-80ed-ae4dbe315218', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5-codex', NULL, true, '2026-05-06 08:32:19.136487+00', '2026-07-10 09:00:21.925122+00', '{"tag": "", "prompt": 0.00000125, "completion": 0.00001, "web_search": 0.01, "create_time": 1758643403, "schema_version": 1, "input_cache_read": 0.000000125, "max_context_tokens": 400000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('471f10da-3f2c-48ef-b893-99cdd473770b', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3-coder-flash', NULL, true, '2026-05-19 17:03:52.563729+00', '2026-07-10 09:00:21.953242+00', '{"tag": "", "prompt": 0.000000195, "completion": 0.000000975, "create_time": 1758115536, "schema_version": 1, "input_cache_read": 0.000000039, "input_cache_write": 0.00000024375, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('8a72f179-67bf-4f9d-afd0-cb250eb10013', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3-coder-flash', NULL, true, '2026-05-19 17:03:52.545636+00', '2026-07-10 09:00:21.94591+00', '{"tag": "", "prompt": 0.000000195, "completion": 0.000000975, "create_time": 1758115536, "schema_version": 1, "input_cache_read": 0.000000039, "input_cache_write": 0.00000024375, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('796d9741-c3a5-49ad-b09e-b02acce3ef08', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3-next-80b-a3b-thinking', NULL, true, '2026-05-06 08:32:19.170863+00', '2026-07-10 09:00:21.960177+00', '{"tag": "", "prompt": 0.0000000975, "completion": 0.00000078, "create_time": 1757612284, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 32768, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('d56ee8e2-1caf-403a-8602-44173beda35d', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3-coder-plus', NULL, true, '2026-05-19 17:03:52.383169+00', '2026-07-10 09:00:21.908504+00', '{"tag": "", "prompt": 0.00000065, "completion": 0.00000325, "create_time": 1758662707, "schema_version": 1, "input_cache_read": 0.00000013, "input_cache_write": 0.0000008125, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('739889da-8d07-429a-8396-da0ca0b6ca19', '493b150e-48c0-4fd4-9866-56bd3d915c46', 'deepseek-v3.1-terminus', NULL, true, '2026-05-06 08:32:19.143239+00', '2026-07-10 09:00:21.931821+00', '{"tag": "", "prompt": 0.00000027, "completion": 0.00000095, "create_time": 1758548275, "schema_version": 1, "input_cache_read": 0.00000013, "max_context_tokens": 163840, "max_completion_tokens": 32768, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('3f0ce3ae-6a03-49f0-8c06-1fe64eb52dd1', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3-next-80b-a3b-instruct:free', NULL, true, '2026-06-07 15:16:16.360772+00', '2026-07-10 09:00:21.981513+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1757612213, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": null, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('bd9caed4-7ec7-4579-b493-537866c295df', '09b94796-8f59-4775-976b-ee85a5a6d927', 'claude-fable-5', NULL, true, '2026-06-09 18:00:05.58984+00', '2026-07-10 09:00:20.247959+00', '{"tag": "", "prompt": 0.00001, "completion": 0.00005, "web_search": 0.01, "create_time": 1781007515, "schema_version": 1, "input_cache_read": 0.000001, "input_cache_write": 0.0000125, "max_context_tokens": 1000000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('54579b8a-cfec-4a50-a9de-850df42c2120', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3-max', NULL, true, '2026-05-19 17:03:52.32869+00', '2026-07-10 09:00:21.888226+00', '{"tag": "", "prompt": 0.00000078, "completion": 0.0000039, "create_time": 1758662808, "schema_version": 1, "input_cache_read": 0.000000156, "input_cache_write": 0.000000975, "max_context_tokens": 262144, "max_completion_tokens": 32768, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('e6ed7868-bacd-4d9e-9074-f57df7ff14af', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3-max', NULL, true, '2026-05-06 08:32:19.122332+00', '2026-07-10 09:00:21.881595+00', '{"tag": "", "prompt": 0.00000078, "completion": 0.0000039, "create_time": 1758662808, "schema_version": 1, "input_cache_read": 0.000000156, "input_cache_write": 0.000000975, "max_context_tokens": 262144, "max_completion_tokens": 32768, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('197f3e23-1a1f-43e6-8d2a-fa1f25ab21aa', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3-next-80b-a3b-instruct:free', NULL, true, '2026-06-07 15:16:16.366826+00', '2026-07-10 09:00:21.98821+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1757612213, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": null, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('232cc92f-94ff-48b9-974f-346b152e56b5', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3-max', NULL, true, '2026-05-19 17:03:52.358145+00', '2026-07-10 09:00:21.895007+00', '{"tag": "", "prompt": 0.00000078, "completion": 0.0000039, "create_time": 1758662808, "schema_version": 1, "input_cache_read": 0.000000156, "input_cache_write": 0.000000975, "max_context_tokens": 262144, "max_completion_tokens": 32768, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('8d9569fb-066a-4bef-b8bd-46847f29a8c3', '98f229c5-42ef-4167-91b1-47846b4f381e', 'grok-4-fast', NULL, true, '2026-05-06 08:32:19.15064+00', '2026-05-15 18:00:42.591528+00', '{"tag": "", "prompt": 0.0000002, "completion": 0.0000005, "web_search": 0.005, "create_time": 1758240090, "schema_version": 1, "input_cache_read": 0.00000005, "max_context_tokens": 2000000, "max_completion_tokens": 30000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('aee9c11c-47a3-4e6c-b88a-ce3ab8a4c9bc', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemma-4-26b-a4b-it', NULL, true, '2026-05-06 08:32:18.228197+00', '2026-07-10 09:00:20.702799+00', '{"tag": "", "prompt": 0.00000006, "completion": 0.00000033, "create_time": 1775227989, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('1b4d8dca-774f-40b3-8809-f36de8528d22', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen-plus-2025-07-28', NULL, true, '2026-05-06 08:32:19.195604+00', '2026-07-10 09:00:22.044246+00', '{"tag": "", "prompt": 0.00000026, "completion": 0.00000078, "create_time": 1757347599, "schema_version": 1, "max_context_tokens": 1000000, "max_completion_tokens": 32768, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('9544347d-d652-473e-8495-901ea47fba4e', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3.5-plus-02-15', NULL, true, '2026-05-19 17:03:50.460237+00', '2026-07-10 09:00:21.087779+00', '{"tag": "", "prompt": 0.00000026, "completion": 0.00000156, "create_time": 1771229416, "schema_version": 1, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('b58700c0-b432-4cbe-bd56-1f4b78d6896e', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3-30b-a3b-thinking-2507', NULL, true, '2026-05-06 08:32:19.222846+00', '2026-07-10 09:00:22.079415+00', '{"tag": "", "prompt": 0.00000013, "completion": 0.00000156, "create_time": 1756399192, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 32768, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('da75a8ea-68ec-4cb7-b5fb-651a260b5b73', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemini-3.1-pro-preview-customtools', NULL, true, '2026-05-06 08:32:18.474036+00', '2026-07-10 09:00:21.04452+00', '{"tag": "", "audio": 0.000002, "image": 0.000002, "prompt": 0.000002, "completion": 0.000012, "web_search": 0.014, "create_time": 1772045923, "schema_version": 1, "input_cache_read": 0.0000002, "input_cache_write": 0.000000375, "internal_reasoning": 0.000012, "max_context_tokens": 1048756, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('4df8b9ce-e82f-4e46-b11a-93b9fde692ef', '4d50bc54-56de-46a6-97db-46362130d4b8', 'kimi-k2-0905', NULL, true, '2026-05-06 08:32:19.21385+00', '2026-07-10 09:00:22.072558+00', '{"tag": "", "prompt": 0.0000006, "completion": 0.0000025, "create_time": 1757021147, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 100352, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('9ebd828e-83a7-477b-8cd4-66a00338a610', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemini-2.5-pro-preview', NULL, true, '2026-05-06 08:32:19.573222+00', '2026-07-10 09:00:22.49806+00', '{"tag": "", "audio": 0.00000125, "image": 0.00000125, "prompt": 0.00000125, "completion": 0.00001, "web_search": 0.014, "create_time": 1749137257, "schema_version": 1, "input_cache_read": 0.000000125, "input_cache_write": 0.000000375, "internal_reasoning": 0.00001, "max_context_tokens": 1048576, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('ee1cce33-f28e-44bd-9968-0c03278765e9', '55857a3a-55f0-4879-b39f-cd252a8bcbf9', 'glm-5', NULL, true, '2026-05-06 08:32:18.540506+00', '2026-07-10 09:00:21.137439+00', '{"tag": "", "prompt": 0.0000006, "completion": 0.00000192, "create_time": 1770829182, "schema_version": 1, "input_cache_read": 0.00000012, "max_context_tokens": 202752, "max_completion_tokens": null, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('c64eac75-34fc-4bc3-8fcc-1d1513c1b7fd', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3-vl-235b-a22b-thinking', NULL, true, '2026-05-19 17:03:52.263292+00', '2026-07-10 09:00:21.850866+00', '{"tag": "", "prompt": 0.00000026, "completion": 0.0000026, "create_time": 1758668690, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 32768, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('98835a2e-c86f-4776-8260-868faf794f89', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3.5-plus-02-15', NULL, true, '2026-05-19 17:03:50.475377+00', '2026-07-10 09:00:21.094912+00', '{"tag": "", "prompt": 0.00000026, "completion": 0.00000156, "create_time": 1771229416, "schema_version": 1, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('d43fd5cf-259e-4814-8674-d7b9ece64d79', '98f229c5-42ef-4167-91b1-47846b4f381e', 'grok-code-fast-1', NULL, true, '2026-05-06 08:32:19.229831+00', '2026-05-15 18:00:42.69633+00', '{"tag": "", "prompt": 0.0000002, "completion": 0.0000015, "web_search": 0.005, "create_time": 1756238927, "schema_version": 1, "input_cache_read": 0.00000002, "max_context_tokens": 256000, "max_completion_tokens": 10000, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('0a12149a-545e-4f9b-bbd6-fab664eb085f', '517cf0cb-27a2-4452-8696-cd902a9c0bee', 'nex-n2-pro', NULL, true, '2026-06-22 01:00:29.419763+00', '2026-07-10 09:00:20.255564+00', '{"tag": "", "prompt": 0.00000025, "completion": 0.000001, "create_time": 1780937140, "schema_version": 1, "input_cache_read": 0.000000025, "max_context_tokens": 262144, "max_completion_tokens": 262144, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('3977a0f8-11ba-46f7-8e4a-d7437c166f7a', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3.5-397b-a17b', NULL, true, '2026-05-06 08:32:18.520549+00', '2026-07-10 09:00:21.10219+00', '{"tag": "", "prompt": 0.000000385, "completion": 0.00000245, "create_time": 1771223018, "schema_version": 1, "input_cache_read": 0.000000111, "max_context_tokens": 256000, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('36bb09cf-2662-4796-8177-978aa5db072b', '38f5b8d7-54ae-4be3-9f15-d7c67a355134', 'glm-5', NULL, true, '2026-05-19 17:03:50.588363+00', '2026-07-10 09:00:21.144565+00', '{"tag": "", "prompt": 0.0000006, "completion": 0.00000192, "create_time": 1770829182, "schema_version": 1, "input_cache_read": 0.00000012, "max_context_tokens": 202752, "max_completion_tokens": null, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('e015b523-ff86-4d46-a46d-40c4de66e255', 'ec126a88-8820-4ab3-ba63-7cd1c1b1aaf2', 'minimax-m2.5', NULL, true, '2026-05-19 17:03:50.555663+00', '2026-07-10 09:00:21.130445+00', '{"tag": "", "prompt": 0.00000015, "completion": 0.0000009, "create_time": 1770908502, "schema_version": 1, "input_cache_read": 0.00000005, "max_context_tokens": 204800, "max_completion_tokens": 196608, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('06be0dcc-4e70-4681-b1c5-f797b01124ae', 'f5522dbf-cdff-469d-b78b-b68f3e28b83c', 'glm-5', NULL, true, '2026-05-19 17:03:50.606416+00', '2026-07-10 09:00:21.151818+00', '{"tag": "", "prompt": 0.0000006, "completion": 0.00000192, "create_time": 1770829182, "schema_version": 1, "input_cache_read": 0.00000012, "max_context_tokens": 202752, "max_completion_tokens": null, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('85381a22-2e1a-4a55-9b16-feba45012af8', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3-max-thinking', NULL, true, '2026-05-06 08:32:18.548054+00', '2026-07-10 09:00:21.158847+00', '{"tag": "", "prompt": 0.00000078, "completion": 0.0000039, "create_time": 1770671901, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 32768, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('508e336b-7259-434a-9cea-4965ed656417', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3-next-80b-a3b-instruct', NULL, true, '2026-05-06 08:32:19.181835+00', '2026-07-10 09:00:22.001833+00', '{"tag": "", "prompt": 0.00000009, "completion": 0.0000011, "create_time": 1757612213, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 16384, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('541b9d22-b932-4a95-9d61-4fd43cd7ddd1', '3b6bbaa2-d1ec-40c6-8a74-2371398db82e', 'nemotron-3.5-content-safety:free', NULL, true, '2026-06-07 15:16:14.481576+00', '2026-07-10 09:00:20.26267+00', '{"tag": "Latest", "prompt": 0, "completion": 0, "create_time": 1780581864, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": 8192, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('9fcce912-74dc-48d1-a887-ec30ad66e22e', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-mini-latest', NULL, true, '2026-05-06 08:32:17.720327+00', '2026-07-10 09:00:20.441827+00', '{"tag": "", "prompt": 0.00000075, "completion": 0.0000045, "web_search": 0.01, "create_time": 1777318471, "schema_version": 1, "input_cache_read": 0.000000075, "max_context_tokens": 400000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('2034857c-088c-458e-bf10-fde2656d32b0', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3.5-27b', NULL, true, '2026-05-19 17:03:50.22336+00', '2026-07-10 09:00:20.986949+00', '{"tag": "", "prompt": 0.000000195, "completion": 0.00000156, "create_time": 1772053810, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('71dfb73b-c59b-4a9d-ba75-064ddcc69af7', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-oss-120b:free', NULL, true, '2026-06-07 15:16:16.542712+00', '2026-07-10 09:00:22.183143+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1754414231, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 131072, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('39a996cf-4537-4edc-b65e-aa1935efc5bd', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3.7-max', NULL, true, '2026-05-21 16:00:32.137203+00', '2026-07-10 09:00:20.348606+00', '{"tag": "", "prompt": 0.00000125, "completion": 0.00000375, "create_time": 1779376861, "schema_version": 1, "input_cache_read": 0.00000025, "input_cache_write": 0.0000015625, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('0bf806e3-0fa6-4ea2-a595-dea61e76f0d8', 'aab4161e-3e3f-440f-8815-415689b823ca', 'step-3.7-flash', NULL, true, '2026-05-29 00:15:00.036195+00', '2026-07-10 09:00:20.319969+00', '{"tag": "Latest", "prompt": 0.0000002, "completion": 0.00000115, "create_time": 1779985069, "schema_version": 1, "input_cache_read": 0.00000004, "max_context_tokens": 256000, "max_completion_tokens": 256000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('93652333-7b3c-458d-8a3f-e0c53ea4197d', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3-vl-32b-instruct', NULL, true, '2026-05-19 17:03:51.706646+00', '2026-07-10 09:00:21.64013+00', '{"tag": "", "prompt": 0.000000104, "completion": 0.000000416, "create_time": 1761231332, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 32768, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('0629b672-1eef-4c2c-bd9d-22027552d2da', '4d50bc54-56de-46a6-97db-46362130d4b8', 'kimi-k2.6:free', NULL, true, '2026-06-07 15:16:14.850465+00', '2026-06-10 17:00:05.528569+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1776699402, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('b27bf397-8ec7-49f9-9ede-28b79723e37a', '1220c61f-f41a-4985-9b71-a3b10efed282', 'granite-4.0-h-micro', NULL, true, '2026-05-06 08:32:18.970287+00', '2026-07-10 09:00:21.647027+00', '{"tag": "", "prompt": 0.000000017, "completion": 0.000000112, "create_time": 1760927695, "schema_version": 1, "max_context_tokens": 131000, "max_completion_tokens": 131000, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('ff882ab6-802b-4e78-8172-992895c68222', '493b150e-48c0-4fd4-9866-56bd3d915c46', 'deepseek-v3.2-exp', NULL, true, '2026-05-06 08:32:19.088375+00', '2026-07-10 09:00:21.823745+00', '{"tag": "", "prompt": 0.00000027, "completion": 0.00000041, "create_time": 1759150481, "schema_version": 1, "max_context_tokens": 163840, "max_completion_tokens": 65536, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('66a740d6-3b29-4e06-840a-ad7daf2e6b84', '98f229c5-42ef-4167-91b1-47846b4f381e', 'grok-build-0.1', NULL, true, '2026-05-20 18:00:39.271319+00', '2026-07-10 09:00:20.36293+00', '{"tag": "", "prompt": 0.000001, "completion": 0.000002, "web_search": 0.005, "create_time": 1779298123, "schema_version": 1, "input_cache_read": 0.0000002, "max_context_tokens": 256000, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('025726d3-556f-40d0-bf1c-42514ba08360', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemini-3.1-pro-preview', NULL, true, '2026-05-06 08:32:18.498187+00', '2026-07-10 09:00:21.066504+00', '{"tag": "", "audio": 0.000002, "image": 0.000002, "prompt": 0.000002, "completion": 0.000012, "web_search": 0.014, "create_time": 1771509627, "schema_version": 1, "input_cache_read": 0.0000002, "input_cache_write": 0.000000375, "internal_reasoning": 0.000012, "max_context_tokens": 1048576, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('6b392f0d-927e-4f95-87ae-a3b6fd40039a', '3b6bbaa2-d1ec-40c6-8a74-2371398db82e', 'nemotron-3-nano-omni-30b-a3b-reasoning:free', NULL, true, '2026-06-07 15:16:14.64598+00', '2026-07-10 09:00:20.427898+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1777393095, "schema_version": 1, "max_context_tokens": 256000, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('2bc9f3a7-cd1a-4891-9a4b-46dc589252ac', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5-image-mini', NULL, true, '2026-05-06 08:32:18.983599+00', '2026-07-10 09:00:21.65399+00', '{"tag": "", "prompt": 0.0000025, "completion": 0.000002, "web_search": 0.01, "create_time": 1760624583, "schema_version": 1, "input_cache_read": 0.00000025, "max_context_tokens": 400000, "max_completion_tokens": 128000, "model_interaction_type": "image"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('1f3137c0-90c2-4433-aca3-e45946ca9450', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemini-flash-latest', NULL, true, '2026-05-06 08:32:17.764856+00', '2026-07-10 09:00:20.463191+00', '{"tag": "", "audio": 0.000003, "image": 0.0000015, "prompt": 0.0000015, "completion": 0.000009, "web_search": 0.014, "create_time": 1777318398, "schema_version": 1, "input_cache_read": 0.00000015, "input_cache_write": 0.00000008333333333333334, "internal_reasoning": 0.000009, "max_context_tokens": 1048576, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('874d6455-4396-4055-ad37-cf4f7eae156a', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3.7-max', NULL, true, '2026-05-21 16:00:32.167565+00', '2026-07-10 09:00:20.35575+00', '{"tag": "", "prompt": 0.00000125, "completion": 0.00000375, "create_time": 1779376861, "schema_version": 1, "input_cache_read": 0.00000025, "input_cache_write": 0.0000015625, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('0e3345a8-52f3-4da9-b9d3-eb463c871bb7', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3-coder-flash', NULL, true, '2026-05-06 08:32:19.164384+00', '2026-07-10 09:00:21.938774+00', '{"tag": "", "prompt": 0.000000195, "completion": 0.000000975, "create_time": 1758115536, "schema_version": 1, "input_cache_read": 0.000000039, "input_cache_write": 0.00000024375, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('97fa8204-d964-4d8d-a4f6-46cace1a484a', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3-vl-235b-a22b-thinking', NULL, true, '2026-05-06 08:32:19.109113+00', '2026-07-10 09:00:21.837422+00', '{"tag": "", "prompt": 0.00000026, "completion": 0.0000026, "create_time": 1758668690, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 32768, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('1eeaec3e-fe9c-489d-9014-9c50c84b5a56', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3.6-35b-a3b', NULL, true, '2026-05-19 17:03:48.814375+00', '2026-07-10 09:00:20.534711+00', '{"tag": "", "prompt": 0.00000014, "completion": 0.000001, "create_time": 1777260255, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 262144, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('da62a581-0576-4ece-9e81-6575af7d6f12', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3.6-max-preview', NULL, true, '2026-05-19 17:03:48.86752+00', '2026-07-10 09:00:20.555854+00', '{"tag": "", "prompt": 0.00000104, "completion": 0.00000624, "create_time": 1777260242, "schema_version": 1, "input_cache_write": 0.0000013, "max_context_tokens": 262144, "max_completion_tokens": 65536, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('f4fff8af-5903-49f1-a8fc-e4316d2e4daa', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3.6-35b-a3b', NULL, true, '2026-05-19 17:03:48.831307+00', '2026-07-10 09:00:20.541906+00', '{"tag": "", "prompt": 0.00000014, "completion": 0.000001, "create_time": 1777260255, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 262144, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('a7180275-611d-4a28-b1be-c320d4f21802', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3.6-max-preview', NULL, true, '2026-05-06 08:32:17.834527+00', '2026-07-10 09:00:20.548719+00', '{"tag": "", "prompt": 0.00000104, "completion": 0.00000624, "create_time": 1777260242, "schema_version": 1, "input_cache_write": 0.0000013, "max_context_tokens": 262144, "max_completion_tokens": 65536, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('4c1ab55b-6d79-4545-8518-e96e69cfe78d', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3.6-max-preview', NULL, true, '2026-05-19 17:03:48.879862+00', '2026-07-10 09:00:20.562748+00', '{"tag": "", "prompt": 0.00000104, "completion": 0.00000624, "create_time": 1777260242, "schema_version": 1, "input_cache_write": 0.0000013, "max_context_tokens": 262144, "max_completion_tokens": 65536, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('361d06bd-dde2-438a-ae11-13066c42b742', '98f229c5-42ef-4167-91b1-47846b4f381e', 'grok-3', NULL, true, '2026-05-06 08:32:19.555983+00', '2026-05-15 18:00:43.09176+00', '{"tag": "", "prompt": 0.000003, "completion": 0.000015, "web_search": 0.005, "create_time": 1749582908, "schema_version": 1, "input_cache_read": 0.00000075, "max_context_tokens": 131072, "max_completion_tokens": null, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('5a16ef43-8731-446a-9aee-f0d5a660915b', '09b4c6f6-ff86-4c84-97b1-4a03ce281453', 'mimo-v2-omni', NULL, true, '2026-05-06 08:32:18.304892+00', '2026-05-31 13:00:10.328949+00', '{"tag": "", "prompt": 0.0000004, "completion": 0.000002, "create_time": 1773863703, "schema_version": 1, "input_cache_read": 0.00000008, "max_context_tokens": 262144, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('f1207aee-0ae5-455e-bde4-7a0b3005640c', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3.6-27b', NULL, true, '2026-05-06 08:32:17.851045+00', '2026-07-10 09:00:20.56969+00', '{"tag": "", "prompt": 0.000000285, "completion": 0.0000024, "create_time": 1777255064, "schema_version": 1, "input_cache_read": 0.00000015, "max_context_tokens": 262144, "max_completion_tokens": 262140, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('cb4991c3-766d-4656-b0c2-de89e591a013', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3.5-27b', NULL, true, '2026-05-19 17:03:50.237938+00', '2026-07-10 09:00:20.994141+00', '{"tag": "", "prompt": 0.000000195, "completion": 0.00000156, "create_time": 1772053810, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('92faac4f-bbb2-43a8-97f6-587d305db3f4', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3.5-122b-a10b', NULL, true, '2026-05-06 08:32:18.451613+00', '2026-07-10 09:00:21.001143+00', '{"tag": "", "prompt": 0.00000026, "completion": 0.00000208, "create_time": 1772053789, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 262144, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('89c4bd1b-4b9c-4a2b-90c4-fa281fd863be', '98f229c5-42ef-4167-91b1-47846b4f381e', 'grok-4', NULL, true, '2026-05-06 08:32:19.47218+00', '2026-05-15 18:00:42.996151+00', '{"tag": "", "prompt": 0.000003, "completion": 0.000015, "web_search": 0.005, "create_time": 1752087689, "schema_version": 1, "input_cache_read": 0.00000075, "max_context_tokens": 256000, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('aac3b621-bd2e-4181-b757-8b8c6fea88fc', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemini-pro-latest', NULL, true, '2026-05-06 08:32:17.73178+00', '2026-07-10 09:00:20.448947+00', '{"tag": "", "audio": 0.000002, "image": 0.000002, "prompt": 0.000002, "completion": 0.000012, "web_search": 0.014, "create_time": 1777318451, "schema_version": 1, "input_cache_read": 0.0000002, "input_cache_write": 0.000000375, "internal_reasoning": 0.000012, "max_context_tokens": 1048576, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('5597f2af-995c-41f0-bbb3-d78ca59f486f', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3.5-plus-20260420', NULL, true, '2026-05-19 17:03:48.574401+00', '2026-07-10 09:00:20.491137+00', '{"tag": "", "prompt": 0.0000003, "completion": 0.0000018, "create_time": 1777261368, "schema_version": 1, "input_cache_write": 0.000000375, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('4bcc26e4-57d2-48fa-bc4b-9ed3f3c95267', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3.6-flash', NULL, true, '2026-05-06 08:32:17.813195+00', '2026-07-10 09:00:20.505461+00', '{"tag": "", "prompt": 0.0000001875, "completion": 0.000001125, "create_time": 1777261362, "schema_version": 1, "input_cache_write": 0.000000234375, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('d7c1ce15-4f3c-4e93-bb09-661eef90e8c0', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3.5-plus-20260420', NULL, true, '2026-05-19 17:03:48.659795+00', '2026-07-10 09:00:20.498347+00', '{"tag": "", "prompt": 0.0000003, "completion": 0.0000018, "create_time": 1777261368, "schema_version": 1, "input_cache_write": 0.000000375, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('d67ce7ed-1ca2-4bc0-b662-193e1b1821fb', '4d50bc54-56de-46a6-97db-46362130d4b8', 'kimi-latest', NULL, true, '2026-05-06 08:32:17.741408+00', '2026-07-10 09:00:20.45604+00', '{"tag": "", "prompt": 0.00000066, "completion": 0.00000341, "create_time": 1777318428, "schema_version": 1, "input_cache_read": 0.00000015, "max_context_tokens": 262144, "max_completion_tokens": 262144, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('9435faad-1ede-4ac4-980f-acc9c8c8e8d8', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3.6-flash', NULL, true, '2026-05-19 17:03:48.774135+00', '2026-07-10 09:00:20.512614+00', '{"tag": "", "prompt": 0.0000001875, "completion": 0.000001125, "create_time": 1777261362, "schema_version": 1, "input_cache_write": 0.000000234375, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('76bf3c36-c51d-4d5f-b8aa-d6711c093a0c', '98f229c5-42ef-4167-91b1-47846b4f381e', 'grok-3-mini', NULL, true, '2026-05-06 08:32:19.548318+00', '2026-05-15 18:00:43.085836+00', '{"tag": "", "prompt": 0.0000003, "completion": 0.0000005, "web_search": 0.005, "create_time": 1749583245, "schema_version": 1, "input_cache_read": 0.000000075, "max_context_tokens": 131072, "max_completion_tokens": null, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('87662b61-73e5-42b0-9207-418301f1f6da', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3.6-35b-a3b', NULL, true, '2026-05-06 08:32:17.827022+00', '2026-07-10 09:00:20.527576+00', '{"tag": "", "prompt": 0.00000014, "completion": 0.000001, "create_time": 1777260255, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 262144, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('cfafb53a-6da0-45c9-aa2c-8430818aadc9', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5.5', NULL, true, '2026-05-06 08:32:17.866067+00', '2026-07-10 09:00:20.597982+00', '{"tag": "", "prompt": 0.000005, "completion": 0.00003, "web_search": 0.01, "create_time": 1777051893, "schema_version": 1, "input_cache_read": 0.0000005, "max_context_tokens": 1050000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('19ded15a-1551-41ad-b99b-bc79ab410bfc', '09b4c6f6-ff86-4c84-97b1-4a03ce281453', 'mimo-v2-pro', NULL, true, '2026-05-06 08:32:18.311777+00', '2026-05-31 13:00:10.336889+00', '{"tag": "", "prompt": 0.000001, "completion": 0.000003, "create_time": 1773863643, "schema_version": 1, "input_cache_read": 0.0000002, "max_context_tokens": 1048576, "max_completion_tokens": 131072, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('8cd630a9-93a8-4d31-8384-7718df745ff5', '55857a3a-55f0-4879-b39f-cd252a8bcbf9', 'glm-4.5v', NULL, true, '2026-05-06 08:32:19.290684+00', '2026-07-10 09:00:22.127834+00', '{"tag": "", "prompt": 0.0000006, "completion": 0.0000018, "create_time": 1754922288, "schema_version": 1, "input_cache_read": 0.00000011, "max_context_tokens": 65536, "max_completion_tokens": 16384, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('6a6bdc49-2e20-42ad-ab42-d4e45bce7f01', '493b150e-48c0-4fd4-9866-56bd3d915c46', 'deepseek-v4-pro', NULL, true, '2026-05-06 08:32:17.874273+00', '2026-07-10 09:00:20.605493+00', '{"tag": "Latest", "prompt": 0.000000435, "completion": 0.00000087, "create_time": 1777000679, "schema_version": 1, "input_cache_read": 0.000000003625, "max_context_tokens": 1048576, "max_completion_tokens": 384000, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('0d3c2b0d-8a4f-407a-af2c-1dc59a23fe36', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3.6-27b', NULL, true, '2026-05-19 17:03:48.903256+00', '2026-07-10 09:00:20.576659+00', '{"tag": "", "prompt": 0.000000285, "completion": 0.0000024, "create_time": 1777255064, "schema_version": 1, "input_cache_read": 0.00000015, "max_context_tokens": 262144, "max_completion_tokens": 262140, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('7bf968ca-f7fe-46d7-8ef4-06503912fef8', '38f5b8d7-54ae-4be3-9f15-d7c67a355134', 'glm-4.5v', NULL, true, '2026-05-19 17:03:52.981691+00', '2026-07-10 09:00:22.135039+00', '{"tag": "", "prompt": 0.0000006, "completion": 0.0000018, "create_time": 1754922288, "schema_version": 1, "input_cache_read": 0.00000011, "max_context_tokens": 65536, "max_completion_tokens": 16384, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('d9db1e83-daa3-45f6-b18d-e0d801e63e67', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3.5-397b-a17b', NULL, true, '2026-05-19 17:03:50.513409+00', '2026-07-10 09:00:21.116625+00', '{"tag": "", "prompt": 0.000000385, "completion": 0.00000245, "create_time": 1771223018, "schema_version": 1, "input_cache_read": 0.000000111, "max_context_tokens": 256000, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('eda6057c-dc7a-4e31-bd51-16d4a1c26eca', '004533f3-71af-47b3-a4b4-9dcd2eeff9b8', 'pixtral-large-2411', NULL, true, '2026-05-06 08:32:20.419571+00', '2026-05-31 12:00:11.056059+00', '{"tag": "", "prompt": 0.000002, "completion": 0.000006, "create_time": 1731977388, "schema_version": 1, "input_cache_read": 0.0000002, "max_context_tokens": 131072, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('48ddbef1-e5b1-4fc1-8724-cb85e9931f51', '004533f3-71af-47b3-a4b4-9dcd2eeff9b8', 'mistral-large-2411', NULL, true, '2026-05-06 08:32:20.395859+00', '2026-05-31 12:00:11.045252+00', '{"tag": "", "prompt": 0.000002, "completion": 0.000006, "create_time": 1731978685, "schema_version": 1, "input_cache_read": 0.0000002, "max_context_tokens": 131072, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('bc94b7ee-9912-4d42-b694-2c6f97c6f6a6', '2810aca3-c2e5-426d-a8c8-2bddc1ff480d', 'minimax-m2.5', NULL, true, '2026-05-06 08:32:18.532894+00', '2026-07-10 09:00:21.123424+00', '{"tag": "", "prompt": 0.00000015, "completion": 0.0000009, "create_time": 1770908502, "schema_version": 1, "input_cache_read": 0.00000005, "max_context_tokens": 204800, "max_completion_tokens": 196608, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('05927eb4-a87f-4df6-b0ad-fb10eb93ad4e', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3.6-27b', NULL, true, '2026-05-19 17:03:48.914736+00', '2026-07-10 09:00:20.583658+00', '{"tag": "", "prompt": 0.000000285, "completion": 0.0000024, "create_time": 1777255064, "schema_version": 1, "input_cache_read": 0.00000015, "max_context_tokens": 262144, "max_completion_tokens": 262140, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('fd5f3ee2-3252-4949-9aab-f3ea04133c03', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5.5-pro', NULL, true, '2026-05-06 08:32:17.858827+00', '2026-07-10 09:00:20.590606+00', '{"tag": "", "prompt": 0.00003, "completion": 0.00018, "web_search": 0.01, "create_time": 1777051896, "schema_version": 1, "max_context_tokens": 1050000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('465f1a51-eb77-45ca-a186-038a166b7cee', '8602ce14-e8dc-435a-8d40-c42e1b094488', 'hermes-4-405b', NULL, true, '2026-05-06 08:32:19.248201+00', '2026-07-10 09:00:22.1072+00', '{"tag": "", "prompt": 0.000001, "completion": 0.000003, "create_time": 1756235463, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": null, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('609cafe2-9516-4893-bbbd-4d4412f07ed7', '493b150e-48c0-4fd4-9866-56bd3d915c46', 'deepseek-chat-v3.1', NULL, true, '2026-05-06 08:32:19.25568+00', '2026-07-10 09:00:22.114054+00', '{"tag": "", "prompt": 0.00000021, "completion": 0.00000079, "create_time": 1755779628, "schema_version": 1, "input_cache_read": 0.00000013, "max_context_tokens": 163840, "max_completion_tokens": 32768, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('a5495f33-51f8-498d-a256-9eba4c7ae515', 'f5522dbf-cdff-469d-b78b-b68f3e28b83c', 'glm-4.5v', NULL, true, '2026-05-19 17:03:52.993005+00', '2026-07-10 09:00:22.141689+00', '{"tag": "", "prompt": 0.0000006, "completion": 0.0000018, "create_time": 1754922288, "schema_version": 1, "input_cache_read": 0.00000011, "max_context_tokens": 65536, "max_completion_tokens": 16384, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('8c556f40-3c0c-4bef-a5f9-31f60ccd0676', '004533f3-71af-47b3-a4b4-9dcd2eeff9b8', 'mistral-medium-3.1', NULL, true, '2026-05-06 08:32:19.26972+00', '2026-07-10 09:00:22.120967+00', '{"tag": "", "prompt": 0.0000004, "completion": 0.000002, "create_time": 1755095639, "schema_version": 1, "input_cache_read": 0.00000004, "max_context_tokens": 131072, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('d91cee0b-325a-465c-83ea-a9fafcb53581', '4edbacf8-cea6-4696-b47a-4f83ff9c6c9c', 'jamba-large-1.7', NULL, true, '2026-05-06 08:32:19.297725+00', '2026-07-10 09:00:22.148679+00', '{"tag": "Latest", "prompt": 0.000002, "completion": 0.000008, "create_time": 1754669020, "schema_version": 1, "max_context_tokens": 256000, "max_completion_tokens": 4096, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('d22dbe4d-a1ad-4c88-b0da-f863c4d75d2f', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5', NULL, true, '2026-05-06 08:32:19.311565+00', '2026-07-10 09:00:22.162424+00', '{"tag": "", "prompt": 0.00000125, "completion": 0.00001, "web_search": 0.01, "create_time": 1754587413, "schema_version": 1, "input_cache_read": 0.000000125, "max_context_tokens": 400000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('7bf017b6-31bd-4301-885b-5426c9911823', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5-mini', NULL, true, '2026-05-06 08:32:19.317961+00', '2026-07-10 09:00:22.169522+00', '{"tag": "", "prompt": 0.00000025, "completion": 0.000002, "web_search": 0.01, "create_time": 1754587407, "schema_version": 1, "input_cache_read": 0.000000025, "max_context_tokens": 400000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('95bd6408-1fb9-44ec-a530-0e777b2e1570', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemini-3.1-flash-lite-preview', NULL, true, '2026-05-06 08:32:18.415303+00', '2026-07-10 09:00:20.938236+00', '{"tag": "", "audio": 0.0000005, "image": 0.00000025, "prompt": 0.00000025, "completion": 0.0000015, "web_search": 0.014, "create_time": 1772512673, "schema_version": 1, "input_cache_read": 0.000000025, "input_cache_write": 0.00000008333333333333334, "internal_reasoning": 0.0000015, "max_context_tokens": 1048576, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('aaf7d9c6-4d74-495b-991a-0edc74af6a49', '7951f113-58d7-4802-80c0-365f624b7483', 'ernie-4.5-21b-a3b-thinking', NULL, true, '2026-05-06 08:32:19.040483+00', '2026-05-31 00:00:13.492362+00', '{"tag": "Latest", "prompt": 0.00000007, "completion": 0.00000028, "create_time": 1760048887, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 65536, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('17747dce-f68e-46ef-bf2a-68689d84d0a3', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3-max-thinking', NULL, true, '2026-05-19 17:03:50.637513+00', '2026-07-10 09:00:21.165947+00', '{"tag": "", "prompt": 0.00000078, "completion": 0.0000039, "create_time": 1770671901, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 32768, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('824d0fa9-7311-443b-9988-fd1a5ab4809e', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3-max-thinking', NULL, true, '2026-05-19 17:03:50.650884+00', '2026-07-10 09:00:21.173136+00', '{"tag": "", "prompt": 0.00000078, "completion": 0.0000039, "create_time": 1770671901, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 32768, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('be4ab1b1-a6d7-47dd-b658-a5a4ca06bfbc', '09b94796-8f59-4775-976b-ee85a5a6d927', 'claude-opus-4.6', NULL, true, '2026-05-06 08:32:18.555811+00', '2026-07-10 09:00:21.180172+00', '{"tag": "", "prompt": 0.000005, "completion": 0.000025, "web_search": 0.01, "create_time": 1770219050, "schema_version": 1, "input_cache_read": 0.0000005, "input_cache_write": 0.00000625, "max_context_tokens": 1000000, "input_cache_write_1h": 0.00001, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('e81e5d23-3594-4ef6-af9a-d7d799df9fe4', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen-max', NULL, true, '2026-05-06 08:32:20.185552+00', '2026-05-13 00:00:26.895148+00', '{"tag": "", "prompt": 0.00000104, "completion": 0.00000416, "create_time": 1738402289, "schema_version": 1, "input_cache_read": 0.000000208, "max_context_tokens": 32768, "max_completion_tokens": 8192, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('f0579a01-8974-45fc-9dcb-b84d270c5d4b', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3-coder-next', NULL, true, '2026-05-06 08:32:18.562741+00', '2026-07-10 09:00:21.187179+00', '{"tag": "", "prompt": 0.00000011, "completion": 0.0000008, "create_time": 1770164101, "schema_version": 1, "input_cache_read": 0.00000007, "max_context_tokens": 262144, "max_completion_tokens": 262144, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('f9f2e376-3dab-4ab6-aca0-26509ecfad53', '3b6bbaa2-d1ec-40c6-8a74-2371398db82e', 'nemotron-nano-12b-v2-vl', NULL, true, '2026-05-06 08:32:18.94958+00', '2026-05-07 00:00:18.549278+00', '{"tag": "", "prompt": 0.0000002, "completion": 0.0000006, "create_time": 1761675565, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 16384, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('df776561-9268-402c-a431-74670ba08e80', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3-coder-next', NULL, true, '2026-05-19 17:03:50.693381+00', '2026-07-10 09:00:21.194069+00', '{"tag": "", "prompt": 0.00000011, "completion": 0.0000008, "create_time": 1770164101, "schema_version": 1, "input_cache_read": 0.00000007, "max_context_tokens": 262144, "max_completion_tokens": 262144, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('e9057023-c67e-4d87-b298-f9974eff5937', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3-coder-next', NULL, true, '2026-05-19 17:03:50.708592+00', '2026-07-10 09:00:21.201149+00', '{"tag": "", "prompt": 0.00000011, "completion": 0.0000008, "create_time": 1770164101, "schema_version": 1, "input_cache_read": 0.00000007, "max_context_tokens": 262144, "max_completion_tokens": 262144, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('6e8ea1f2-2144-4beb-8077-e8b2d7fec921', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5-nano', NULL, true, '2026-05-06 08:32:19.324607+00', '2026-07-10 09:00:22.17642+00', '{"tag": "", "prompt": 0.00000005, "completion": 0.0000004, "web_search": 0.01, "create_time": 1754587402, "schema_version": 1, "input_cache_read": 0.00000001, "max_context_tokens": 400000, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('e6319860-2ca4-49c9-a78c-c100bf036ec1', '59f22d14-a479-4667-86e5-7e7d7433603e', 'hy3:free', NULL, true, '2026-07-06 14:00:18.85371+00', '2026-07-10 09:00:20.140425+00', '{"tag": "Latest", "prompt": 0, "completion": 0, "create_time": 1783344048, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 262144, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('777a286b-2c38-470e-b24f-a8dd3a077066', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3.5-397b-a17b', NULL, true, '2026-05-19 17:03:50.50115+00', '2026-07-10 09:00:21.109306+00', '{"tag": "", "prompt": 0.000000385, "completion": 0.00000245, "create_time": 1771223018, "schema_version": 1, "input_cache_read": 0.000000111, "max_context_tokens": 256000, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('d4be964c-a48e-432c-b88a-1ec60e610940', '98f229c5-42ef-4167-91b1-47846b4f381e', 'grok-3-mini-beta', NULL, true, '2026-05-06 08:32:19.797618+00', '2026-05-15 19:00:17.208486+00', '{"tag": "", "prompt": 0.0000003, "completion": 0.0000005, "web_search": 0.005, "create_time": 1744240195, "schema_version": 1, "input_cache_read": 0.000000075, "max_context_tokens": 131072, "max_completion_tokens": null, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('0b378edd-5b20-4b72-99c7-53dd3f224e56', '98f229c5-42ef-4167-91b1-47846b4f381e', 'grok-3-beta', NULL, true, '2026-05-06 08:32:19.808892+00', '2026-05-15 19:00:17.21495+00', '{"tag": "", "prompt": 0.000003, "completion": 0.000015, "web_search": 0.005, "create_time": 1744240068, "schema_version": 1, "input_cache_read": 0.00000075, "max_context_tokens": 131072, "max_completion_tokens": null, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('bca22363-1a29-4380-aefa-bd45eb2d9e09', '09b94796-8f59-4775-976b-ee85a5a6d927', 'claude-3.7-sonnet:thinking', NULL, true, '2026-05-06 08:32:20.015305+00', '2026-05-11 00:01:00.212859+00', '{"tag": "", "prompt": 0.000003, "completion": 0.000015, "web_search": 0.01, "create_time": 1740422110, "schema_version": 1, "input_cache_read": 0.0000003, "input_cache_write": 0.00000375, "max_context_tokens": 200000, "max_completion_tokens": 64000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('3cc96681-35a9-4c82-a9c8-27fde30f414c', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5-chat', NULL, true, '2026-05-06 08:32:19.304879+00', '2026-07-10 09:00:22.155555+00', '{"tag": "", "prompt": 0.00000125, "completion": 0.00001, "web_search": 0.01, "create_time": 1754587837, "schema_version": 1, "input_cache_read": 0.000000125, "max_context_tokens": 128000, "max_completion_tokens": 16384, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('dcd33a66-6bf4-4a79-b668-2e7e82a89ee5', '09b94796-8f59-4775-976b-ee85a5a6d927', 'claude-3.7-sonnet', NULL, true, '2026-05-06 08:32:20.004247+00', '2026-05-11 00:01:00.205148+00', '{"tag": "", "prompt": 0.000003, "completion": 0.000015, "web_search": 0.01, "create_time": 1740422110, "schema_version": 1, "input_cache_read": 0.0000003, "input_cache_write": 0.00000375, "max_context_tokens": 200000, "max_completion_tokens": 64000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('27e4a64e-3408-4fb0-ad90-9abc82924fe8', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen-vl-plus', NULL, true, '2026-05-06 08:32:20.073846+00', '2026-05-13 00:00:26.822042+00', '{"tag": "", "prompt": 0.0000001365, "completion": 0.0000004095, "create_time": 1738731255, "schema_version": 1, "input_cache_read": 0.0000000273, "max_context_tokens": 131072, "max_completion_tokens": 8192, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('738b3c43-8adf-4ea9-9fad-22e6ee0407cc', 'fee873f7-15b7-4809-b9ba-2737224b15ed', 'spotlight', NULL, true, '2026-05-06 08:32:19.624186+00', '2026-06-06 14:00:28.526543+00', '{"tag": "", "prompt": 0.00000018, "completion": 0.00000018, "create_time": 1746481552, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 65537, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('05b97c5e-e73c-41c9-954d-8bb5b7fc6e0e', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen-vl-max', NULL, true, '2026-05-06 08:32:20.120753+00', '2026-05-13 00:00:26.868398+00', '{"tag": "", "prompt": 0.00000052, "completion": 0.00000208, "create_time": 1738434304, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 32768, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('dc22ef97-53cc-4081-b852-bea7383675fc', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen-turbo', NULL, true, '2026-05-06 08:32:20.133145+00', '2026-05-13 00:00:26.875216+00', '{"tag": "", "prompt": 0.0000000325, "completion": 0.00000013, "create_time": 1738410974, "schema_version": 1, "input_cache_read": 0.0000000065, "max_context_tokens": 131072, "max_completion_tokens": 8192, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('7744641b-bf3a-4c55-87f6-bf46af0a42a7', '3b6bbaa2-d1ec-40c6-8a74-2371398db82e', 'llama-3.1-nemotron-70b-instruct', NULL, true, '2026-05-06 08:32:20.466836+00', '2026-05-08 00:00:42.88742+00', '{"tag": "Deperciate", "prompt": 0.0000012, "completion": 0.0000012, "create_time": 1728950400, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 16384, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('6857f47a-608c-4b6c-be87-9eac1066a05c', '493b150e-48c0-4fd4-9866-56bd3d915c46', 'deepseek-r1-distill-qwen-32b', NULL, true, '2026-05-06 08:32:20.221171+00', '2026-06-16 08:00:19.391878+00', '{"tag": "", "prompt": 0.00000029, "completion": 0.00000029, "create_time": 1738194830, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": 32768, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('663637fa-91cc-4a64-87a3-91b62edfd8d0', '004533f3-71af-47b3-a4b4-9dcd2eeff9b8', 'mixtral-8x7b-instruct', NULL, true, '2026-05-06 08:32:20.830677+00', '2026-05-08 00:00:43.111918+00', '{"tag": "Deperciate", "prompt": 0.00000054, "completion": 0.00000054, "create_time": 1702166400, "schema_version": 1, "max_context_tokens": 32768, "max_completion_tokens": 16384, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('1a710a8b-f4fa-42c5-8c33-e13170824209', 'fee873f7-15b7-4809-b9ba-2737224b15ed', 'trinity-large-preview', NULL, true, '2026-05-06 08:32:18.581061+00', '2026-05-21 13:00:28.217846+00', '{"tag": "", "prompt": 0.00000015, "completion": 0.00000045, "create_time": 1769552670, "schema_version": 1, "max_context_tokens": 131000, "max_completion_tokens": null, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('b1cbff9e-989c-40a1-a330-36a72dc822f7', '09b4c6f6-ff86-4c84-97b1-4a03ce281453', 'mimo-v2-flash', NULL, true, '2026-05-06 08:32:18.699292+00', '2026-06-17 16:00:12.088399+00', '{"tag": "", "prompt": 0.0000001, "completion": 0.0000003, "create_time": 1765731308, "schema_version": 1, "input_cache_read": 0.00000001, "max_context_tokens": 262144, "max_completion_tokens": 65536, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('555200f8-25e0-4486-afc3-15b88ef8055b', '23a280b6-2fe9-4fef-aac0-a19818a5134c', 'tongyi-deepresearch-30b-a3b', NULL, true, '2026-05-06 08:32:19.157836+00', '2026-05-25 07:00:26.786902+00', '{"tag": "Latest", "prompt": 0.00000009, "completion": 0.00000045, "create_time": 1758210804, "schema_version": 1, "input_cache_read": 0.00000009, "max_context_tokens": 131072, "max_completion_tokens": 131072, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('942bae56-fabe-4bf0-9f9f-38f53a25af41', '52afc118-ced4-4665-b25d-05f4948065e3', 'rnj-1-instruct', NULL, true, '2026-05-06 08:32:18.767444+00', '2026-06-23 14:00:54.179214+00', '{"tag": "Latest", "prompt": 0.00000015, "completion": 0.00000015, "create_time": 1765094847, "schema_version": 1, "max_context_tokens": 32768, "max_completion_tokens": null, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('e8b1bc5b-2ba9-40f4-874c-318e92788e8f', '517cf0cb-27a2-4452-8696-cd902a9c0bee', 'deepseek-v3.1-nex-n1', NULL, true, '2026-05-06 08:32:18.760603+00', '2026-06-08 13:00:50.196402+00', '{"tag": "Latest", "prompt": 0.000000135, "completion": 0.0000005, "create_time": 1765204393, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 163840, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('b2792333-b796-494c-a43f-a2cd65c9a16a', '7951f113-58d7-4802-80c0-365f624b7483', 'qianfan-ocr-fast', NULL, true, '2026-05-14 15:00:46.595596+00', '2026-05-28 13:00:25.364505+00', '{"tag": "Latest", "prompt": 0.00000068, "completion": 0.00000281, "create_time": 1776707472, "schema_version": 1, "max_context_tokens": 65536, "max_completion_tokens": 28672, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('ba2f3789-9019-4ac4-8936-28e32c0211bd', '09b94796-8f59-4775-976b-ee85a5a6d927', 'claude-opus-4.6-fast', NULL, true, '2026-05-06 08:32:18.210456+00', '2026-06-29 13:00:39.36299+00', '{"tag": "", "prompt": 0.00003, "completion": 0.00015, "web_search": 0.01, "create_time": 1775592472, "schema_version": 1, "input_cache_read": 0.000003, "input_cache_write": 0.0000375, "max_context_tokens": 1000000, "input_cache_write_1h": 0.00006, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('020b094e-bc1f-4e4b-a84c-064591d8bd7c', '568aa6a0-7312-4d9c-b2bf-e71cadb3df82', 'intellect-3', NULL, true, '2026-05-06 08:32:18.844918+00', '2026-06-23 13:00:52.206358+00', '{"tag": "Latest", "prompt": 0.0000002, "completion": 0.0000011, "create_time": 1764212534, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 131072, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('6dc27f9c-6c3e-458a-9007-d013b54e182b', '493b150e-48c0-4fd4-9866-56bd3d915c46', 'deepseek-v3.2-speciale', NULL, true, '2026-05-06 08:32:18.829938+00', '2026-05-29 02:00:27.002892+00', '{"tag": "", "prompt": 0.000000287, "completion": 0.000000431, "create_time": 1764594837, "schema_version": 1, "input_cache_read": 0.000000058, "max_context_tokens": 163840, "max_completion_tokens": 163840, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('3df507bf-6dfd-468a-91dd-e387e2793dc2', 'd63d8b65-111d-4030-900c-a7b439c9473a', 'phi-4-mini-instruct', NULL, true, '2026-05-06 08:32:18.977049+00', '2026-06-30 19:00:17.675081+00', '{"tag": "Latest", "prompt": 0.00000008, "completion": 0.00000035, "create_time": 1760726049, "schema_version": 1, "input_cache_read": 0.00000008, "max_context_tokens": 131072, "max_completion_tokens": 128000, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('c3db859f-56e9-4104-ba03-8583302b2268', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5.1', NULL, true, '2026-05-06 08:32:18.882841+00', '2026-07-10 09:00:21.542422+00', '{"tag": "", "prompt": 0.00000125, "completion": 0.00001, "web_search": 0.01, "create_time": 1763060305, "schema_version": 1, "input_cache_read": 0.00000013, "max_context_tokens": 400000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('1d44ab2d-59c9-495f-a38d-6a002f4002cc', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5.1-chat', NULL, true, '2026-05-06 08:32:18.889848+00', '2026-07-10 09:00:21.549788+00', '{"tag": "", "prompt": 0.00000125, "completion": 0.00001, "web_search": 0.01, "create_time": 1763060302, "schema_version": 1, "input_cache_read": 0.00000013, "max_context_tokens": 128000, "max_completion_tokens": 32000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('c900eee6-fa29-401a-82f6-87d5c1a0623f', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5.1-codex', NULL, true, '2026-05-06 08:32:18.897276+00', '2026-07-10 09:00:21.556773+00', '{"tag": "", "prompt": 0.00000125, "completion": 0.00001, "web_search": 0.01, "create_time": 1763060298, "schema_version": 1, "input_cache_read": 0.00000013, "max_context_tokens": 400000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('9654a390-55d0-484a-9bc3-914803cce7b1', '004533f3-71af-47b3-a4b4-9dcd2eeff9b8', 'voxtral-small-24b-2507', NULL, true, '2026-05-06 08:32:18.931922+00', '2026-07-10 09:00:21.59082+00', '{"tag": "", "audio": 0.0001, "prompt": 0.0000001, "completion": 0.0000003, "create_time": 1761835144, "schema_version": 1, "input_cache_read": 0.00000001, "max_context_tokens": 32000, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('2f0f0905-daf4-4cac-b5bb-a5d69f9c19c6', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-oss-safeguard-20b', NULL, true, '2026-05-06 08:32:18.938947+00', '2026-07-10 09:00:21.598085+00', '{"tag": "", "prompt": 0.000000075, "completion": 0.0000003, "create_time": 1761752836, "schema_version": 1, "input_cache_read": 0.0000000375, "max_context_tokens": 131072, "max_completion_tokens": 65536, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('e0cf6916-c848-4f2a-b016-bd66c2d43465', 'f5522dbf-cdff-469d-b78b-b68f3e28b83c', 'glm-4-32b', NULL, true, '2026-05-19 17:03:53.466019+00', '2026-06-09 22:00:15.581401+00', '{"tag": "", "prompt": 0.0000001, "completion": 0.0000001, "create_time": 1753376617, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": null, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('51708500-0982-489d-b54f-38fa87ec86a3', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3.5-9b', NULL, true, '2026-05-19 17:03:50.026524+00', '2026-07-10 09:00:20.903278+00', '{"tag": "", "prompt": 0.0000001, "completion": 0.00000015, "create_time": 1773152396, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 262144, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('da3087d6-a4cb-4762-b6ff-84b9ea86f4c3', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-4o-audio-preview', NULL, true, '2026-05-06 08:32:19.262886+00', '2026-05-29 23:00:12.048768+00', '{"tag": "", "audio": 0.00004, "prompt": 0.0000025, "completion": 0.00001, "create_time": 1755233061, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": 16384, "model_interaction_type": "audio"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('0ce9eaf2-492a-456e-9cdd-282857098e08', '7951f113-58d7-4802-80c0-365f624b7483', 'ernie-4.5-21b-a3b', NULL, true, '2026-05-06 08:32:19.276333+00', '2026-05-31 00:00:13.828471+00', '{"tag": "", "prompt": 0.00000007, "completion": 0.00000028, "create_time": 1755034167, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 8000, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('c89da2bf-c037-430a-aba9-0bb158c480fe', '7951f113-58d7-4802-80c0-365f624b7483', 'ernie-4.5-vl-28b-a3b', NULL, true, '2026-05-06 08:32:19.282851+00', '2026-06-06 14:00:28.093456+00', '{"tag": "Latest", "prompt": 0.00000014, "completion": 0.00000056, "create_time": 1755032836, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 8000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('dd9cb185-33ec-4380-ab80-06749c50a58d', '3aae62b8-1e09-46bf-b98d-7068befbc2fe', 'relace-apply-3', NULL, true, '2026-05-06 08:32:19.095182+00', '2026-07-10 09:00:21.830565+00', '{"tag": "", "prompt": 0.00000085, "completion": 0.00000125, "create_time": 1758891572, "schema_version": 1, "max_context_tokens": 256000, "max_completion_tokens": 128000, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('9e0d4a34-0be5-4279-9b9a-be3c93f7fa7e', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemini-2.5-flash-lite-preview-09-2025', NULL, true, '2026-05-06 08:32:19.102102+00', '2026-07-09 13:00:51.414258+00', '{"tag": "", "audio": 0.0000003, "image": 0.0000001, "prompt": 0.0000001, "completion": 0.0000004, "web_search": 0.014, "create_time": 1758819686, "schema_version": 1, "input_cache_read": 0.00000001, "input_cache_write": 0.00000008333333333333334, "internal_reasoning": 0.0000004, "max_context_tokens": 1048576, "max_completion_tokens": 65535, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('19ba9a93-eb42-4e6f-8e7d-5708d5a140df', 'fee873f7-15b7-4809-b9ba-2737224b15ed', 'maestro-reasoning', NULL, true, '2026-05-06 08:32:19.633927+00', '2026-06-09 14:00:36.814775+00', '{"tag": "", "prompt": 0.0000009, "completion": 0.0000033, "create_time": 1746481269, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 32000, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('fe12b755-dabf-44ab-b655-d771c57a7c0d', '004533f3-71af-47b3-a4b4-9dcd2eeff9b8', 'devstral-medium', NULL, true, '2026-05-06 08:32:19.451902+00', '2026-05-31 12:00:10.521564+00', '{"tag": "", "prompt": 0.0000004, "completion": 0.000002, "create_time": 1752161321, "schema_version": 1, "input_cache_read": 0.00000004, "max_context_tokens": 131072, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('3483a34c-ceb8-4625-bda4-2c466e6eddeb', '7951f113-58d7-4802-80c0-365f624b7483', 'ernie-4.5-300b-a47b', NULL, true, '2026-05-06 08:32:19.505953+00', '2026-06-02 06:00:05.598386+00', '{"tag": "", "prompt": 0.00000028, "completion": 0.0000011, "create_time": 1751300139, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 12000, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('6d3426de-652b-4d1e-ab76-209d16ef4cc8', '55857a3a-55f0-4879-b39f-cd252a8bcbf9', 'glm-4-32b', NULL, true, '2026-05-06 08:32:19.406069+00', '2026-06-09 22:00:15.569943+00', '{"tag": "", "prompt": 0.0000001, "completion": 0.0000001, "create_time": 1753376617, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": null, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('f65ad7d9-038f-4c4d-bfb4-7ae1756ce984', '38f5b8d7-54ae-4be3-9f15-d7c67a355134', 'glm-4-32b', NULL, true, '2026-05-19 17:03:53.421973+00', '2026-06-09 22:00:15.575807+00', '{"tag": "", "prompt": 0.0000001, "completion": 0.0000001, "create_time": 1753376617, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": null, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('2c0f046e-61e2-4e51-bd8b-a7cbb3ee61b5', '004533f3-71af-47b3-a4b4-9dcd2eeff9b8', 'devstral-small', NULL, true, '2026-05-06 08:32:19.458891+00', '2026-05-31 12:00:10.52764+00', '{"tag": "", "prompt": 0.0000001, "completion": 0.0000003, "create_time": 1752160751, "schema_version": 1, "input_cache_read": 0.00000001, "max_context_tokens": 131072, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('a6f32024-e9cd-4dc9-88b8-e60db15535b6', '64647d14-f1cd-4965-926c-476e20bcb1c3', 'llama-guard-3-8b', NULL, true, '2026-05-06 08:32:20.038788+00', '2026-06-12 14:00:04.458291+00', '{"tag": "", "prompt": 0.000000484, "completion": 0.00000003, "create_time": 1739401318, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 131072, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('163f1973-af1e-498d-adec-210ff71d3c50', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemini-2.0-flash-lite-001', NULL, true, '2026-05-06 08:32:19.992778+00', '2026-06-01 13:00:23.937296+00', '{"tag": "", "audio": 0.000000075, "image": 0.000000075, "prompt": 0.000000075, "completion": 0.0000003, "web_search": 0.014, "create_time": 1740506212, "schema_version": 1, "internal_reasoning": 0.0000003, "max_context_tokens": 1048576, "max_completion_tokens": 8192, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('27b39af3-fadd-4913-8de7-5711afca9063', '09b94796-8f59-4775-976b-ee85a5a6d927', 'claude-3.5-haiku', NULL, true, '2026-05-06 08:32:20.442886+00', '2026-06-22 00:00:37.22392+00', '{"tag": "", "prompt": 0.0000008, "completion": 0.000004, "web_search": 0.01, "create_time": 1730678400, "schema_version": 1, "input_cache_read": 0.00000008, "input_cache_write": 0.000001, "max_context_tokens": 200000, "max_completion_tokens": 8192, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('72c94fab-87e7-4607-b0b0-2b468c5f64a1', '64647d14-f1cd-4965-926c-476e20bcb1c3', 'llama-3-70b-instruct', NULL, true, '2026-05-06 08:32:20.739304+00', '2026-06-19 13:01:01.450379+00', '{"tag": "", "prompt": 0.00000051, "completion": 0.00000074, "create_time": 1713398400, "schema_version": 1, "max_context_tokens": 8192, "max_completion_tokens": 8000, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('70f48314-2722-4e72-abd0-9c9f2d68e94b', '8602ce14-e8dc-435a-8d40-c42e1b094488', 'hermes-2-pro-llama-3-8b', NULL, true, '2026-05-06 08:32:20.692738+00', '2026-06-05 13:00:42.90647+00', '{"tag": "", "prompt": 0.00000014, "completion": 0.00000014, "create_time": 1716768000, "schema_version": 1, "max_context_tokens": 8192, "max_completion_tokens": 8192, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('251e48f6-4830-4589-adb6-33174295f6c8', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-4-0314', NULL, true, '2026-05-06 08:32:20.908779+00', '2026-06-04 03:19:38.938625+00', '{"tag": "", "prompt": 0.00003, "completion": 0.00006, "create_time": 1685232000, "schema_version": 1, "max_context_tokens": 8191, "max_completion_tokens": 4096, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('69bd0e41-3a50-42f9-ad39-dbd8381e4fa0', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3-30b-a3b', NULL, true, '2026-05-19 17:03:54.285675+00', '2026-07-10 09:00:22.576132+00', '{"tag": "", "prompt": 0.00000012, "completion": 0.0000005, "create_time": 1745878604, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 16384, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('17a2036f-ec91-47b6-b7e8-5bf42074a9d8', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3-30b-a3b', NULL, true, '2026-05-19 17:03:54.314956+00', '2026-07-10 09:00:22.582897+00', '{"tag": "", "prompt": 0.00000012, "completion": 0.0000005, "create_time": 1745878604, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 16384, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('e4d85d9c-6b95-42d8-af08-f1b6697db632', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3-8b', NULL, true, '2026-05-06 08:32:19.679949+00', '2026-07-10 09:00:22.589857+00', '{"tag": "", "prompt": 0.000000117, "completion": 0.000000455, "create_time": 1745876632, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 8192, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('f47757a0-24ae-467f-8f10-b4fec361da82', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3-8b', NULL, true, '2026-05-19 17:03:54.382072+00', '2026-07-10 09:00:22.596574+00', '{"tag": "", "prompt": 0.000000117, "completion": 0.000000455, "create_time": 1745876632, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 8192, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('a6f0fa42-58c4-4821-9c7b-d169f9b65c2a', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3-8b', NULL, true, '2026-05-19 17:03:54.399377+00', '2026-07-10 09:00:22.603468+00', '{"tag": "", "prompt": 0.000000117, "completion": 0.000000455, "create_time": 1745876632, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 8192, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('80db1433-7579-446c-856b-1deb35edf5d0', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3-14b', NULL, true, '2026-05-06 08:32:19.689633+00', '2026-07-10 09:00:22.610561+00', '{"tag": "", "prompt": 0.0000001, "completion": 0.00000024, "create_time": 1745876478, "schema_version": 1, "max_context_tokens": 131702, "max_completion_tokens": 40960, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('2477cdfb-149d-4cf0-8445-83142fc8de77', '004533f3-71af-47b3-a4b4-9dcd2eeff9b8', 'mistral-7b-instruct-v0.1', NULL, true, '2026-05-06 08:32:20.874059+00', '2026-05-30 13:00:19.6859+00', '{"tag": "", "prompt": 0.00000011, "completion": 0.00000019, "create_time": 1695859200, "schema_version": 1, "max_context_tokens": 4096, "max_completion_tokens": 2824, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('68347d33-4414-4058-8f1c-eeec8ab89d35', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-4-1106-preview', NULL, true, '2026-05-06 08:32:20.850535+00', '2026-06-06 14:00:29.304074+00', '{"tag": "", "prompt": 0.00001, "completion": 0.00003, "web_search": 0.01, "create_time": 1699228800, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": 4096, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('41e8551d-f31c-47e4-980b-c6968eb80d4e', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3-32b', NULL, true, '2026-05-06 08:32:19.696633+00', '2026-07-10 09:00:22.632721+00', '{"tag": "", "prompt": 0.00000008, "completion": 0.00000028, "create_time": 1745875945, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 16384, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('523308c4-67b9-4fcb-a780-d7e964e12349', '3b6bbaa2-d1ec-40c6-8a74-2371398db82e', 'nemotron-3-ultra-550b-a55b:free', NULL, true, '2026-06-07 15:16:14.492037+00', '2026-07-10 09:00:20.269649+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1780551208, "schema_version": 1, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('e191ad9e-041d-427e-a9e7-0e1f7db74758', '3b6bbaa2-d1ec-40c6-8a74-2371398db82e', 'nemotron-3-ultra-550b-a55b', NULL, true, '2026-06-04 17:00:03.344862+00', '2026-07-10 09:00:20.276721+00', '{"tag": "", "prompt": 0.0000005, "completion": 0.0000022, "create_time": 1780551208, "schema_version": 1, "input_cache_read": 0.0000001, "max_context_tokens": 1000000, "max_completion_tokens": 16384, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('ff30a7e9-703c-4408-aecb-fd580e3fc4b6', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3.7-plus', NULL, true, '2026-06-03 14:00:16.351465+00', '2026-07-10 09:00:20.284101+00', '{"tag": "Latest", "prompt": 0.00000032, "completion": 0.00000128, "create_time": 1780491783, "schema_version": 1, "input_cache_read": 0.000000064, "input_cache_write": 0.0000004, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('6851f978-e4d6-4036-a2b0-df23275fb59d', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3.7-plus', NULL, true, '2026-06-03 14:00:16.383238+00', '2026-07-10 09:00:20.291363+00', '{"tag": "Latest", "prompt": 0.00000032, "completion": 0.00000128, "create_time": 1780491783, "schema_version": 1, "input_cache_read": 0.000000064, "input_cache_write": 0.0000004, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('cd645b2d-6b7a-453b-807e-00de456eb66f', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3.7-plus', NULL, true, '2026-06-03 14:00:16.390736+00', '2026-07-10 09:00:20.298634+00', '{"tag": "Latest", "prompt": 0.00000032, "completion": 0.00000128, "create_time": 1780491783, "schema_version": 1, "input_cache_read": 0.000000064, "input_cache_write": 0.0000004, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('cbd3def7-1da2-4ad1-a2e9-6d0bf303fe13', '2810aca3-c2e5-426d-a8c8-2bddc1ff480d', 'minimax-m3', NULL, true, '2026-06-01 01:00:05.533476+00', '2026-07-10 09:00:20.30579+00', '{"tag": "Latest", "prompt": 0.0000003, "completion": 0.0000012, "create_time": 1780245374, "schema_version": 1, "input_cache_read": 0.00000006, "max_context_tokens": 1048576, "max_completion_tokens": 131072, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('8a6d3e38-f7e8-4292-a83a-10c385e194c0', 'ec126a88-8820-4ab3-ba63-7cd1c1b1aaf2', 'minimax-m3', NULL, true, '2026-06-01 01:00:05.541222+00', '2026-07-10 09:00:20.312952+00', '{"tag": "Latest", "prompt": 0.0000003, "completion": 0.0000012, "create_time": 1780245374, "schema_version": 1, "input_cache_read": 0.00000006, "max_context_tokens": 1048576, "max_completion_tokens": 131072, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('18bbd656-c133-4166-b5ff-b9d1b277ed2b', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen-plus-2025-07-28', NULL, true, '2026-05-19 17:03:52.76525+00', '2026-07-10 09:00:22.051313+00', '{"tag": "", "prompt": 0.00000026, "completion": 0.00000078, "create_time": 1757347599, "schema_version": 1, "max_context_tokens": 1000000, "max_completion_tokens": 32768, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('f38e409e-3e14-4f25-a405-384ff108fff4', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen-plus-2025-07-28', NULL, true, '2026-05-19 17:03:52.776787+00', '2026-07-10 09:00:22.058711+00', '{"tag": "", "prompt": 0.00000026, "completion": 0.00000078, "create_time": 1757347599, "schema_version": 1, "max_context_tokens": 1000000, "max_completion_tokens": 32768, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('c7f06ae0-e4bf-40ab-b5eb-b1486a1b3e42', '3b6bbaa2-d1ec-40c6-8a74-2371398db82e', 'nemotron-nano-9b-v2:free', NULL, true, '2026-06-07 15:16:16.434819+00', '2026-07-10 09:00:22.0658+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1757106807, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": null, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('a347e563-9877-47e2-861d-14e4005c83df', '09b94796-8f59-4775-976b-ee85a5a6d927', 'claude-sonnet-5', NULL, true, '2026-06-30 19:00:01.240942+00', '2026-07-10 09:00:20.154486+00', '{"tag": "Latest", "prompt": 0.000002, "completion": 0.00001, "web_search": 0.01, "create_time": 1782843083, "schema_version": 1, "input_cache_read": 0.0000002, "input_cache_write": 0.0000025, "max_context_tokens": 1000000, "input_cache_write_1h": 0.000004, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('d1f88f05-69ec-49c7-afb0-314a046a1e09', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemini-3.1-flash-lite-image', NULL, true, '2026-06-30 17:00:38.349087+00', '2026-07-10 09:00:20.161546+00', '{"tag": "Latest", "prompt": 0.00000025, "completion": 0.0000015, "web_search": 0.014, "create_time": 1782837225, "schema_version": 1, "max_context_tokens": 65536, "max_completion_tokens": 66000, "model_interaction_type": "image"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('a93af034-aa3e-4228-99cc-338422d86fb9', 'afa9fcb3-49b1-4b68-b916-44eea386d9ea', 'fugu-ultra', NULL, false, '2026-06-24 05:00:17.679959+00', '2026-07-10 09:00:20.176407+00', '{"tag": "Latest", "prompt": 0.000005, "completion": 0.00003, "web_search": 0.01, "create_time": 1782276303, "schema_version": 1, "input_cache_read": 0.0000005, "max_context_tokens": 1000000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('ab8f82e4-bfe9-4dac-977b-6df688466369', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemini-3.1-flash-image', NULL, true, '2026-06-18 05:00:42.545032+00', '2026-07-10 09:00:20.183481+00', '{"tag": "", "prompt": 0.0000005, "completion": 0.000003, "web_search": 0.014, "create_time": 1781754065, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 32768, "model_interaction_type": "image"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('6a85740b-f976-4146-875c-cd3000482146', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-oss-20b', NULL, true, '2026-05-06 08:32:19.345565+00', '2026-07-10 09:00:22.203631+00', '{"tag": "", "prompt": 0.000000029, "completion": 0.00000014, "create_time": 1754414229, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": null, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('1c25138e-86b7-404d-86f2-9af1bdb9cc9d', '004533f3-71af-47b3-a4b4-9dcd2eeff9b8', 'codestral-2508', NULL, true, '2026-05-06 08:32:19.360505+00', '2026-07-10 09:00:22.217696+00', '{"tag": "", "prompt": 0.0000003, "completion": 0.0000009, "create_time": 1754079630, "schema_version": 1, "input_cache_read": 0.00000003, "max_context_tokens": 256000, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('c086b657-1517-469d-8f4b-1726996f2183', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3-coder-30b-a3b-instruct', NULL, true, '2026-05-19 17:03:53.177113+00', '2026-07-10 09:00:22.231626+00', '{"tag": "", "prompt": 0.00000007, "completion": 0.00000027, "create_time": 1753972379, "schema_version": 1, "max_context_tokens": 160000, "max_completion_tokens": 32768, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('ca841c5f-9c18-412b-a6e4-a16c6b6fa4c6', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3-coder-30b-a3b-instruct', NULL, true, '2026-05-19 17:03:53.189798+00', '2026-07-10 09:00:22.23858+00', '{"tag": "", "prompt": 0.00000007, "completion": 0.00000027, "create_time": 1753972379, "schema_version": 1, "max_context_tokens": 160000, "max_completion_tokens": 32768, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('c6db6c21-bda5-4454-a4ea-a201f16472f1', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3-30b-a3b-instruct-2507', NULL, true, '2026-05-06 08:32:19.373823+00', '2026-07-10 09:00:22.245414+00', '{"tag": "", "prompt": 0.00000004815, "completion": 0.00000019305, "create_time": 1753806965, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 32000, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('1b69b503-36de-49ab-9bc2-9cd3dcb5c236', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3-30b-a3b-instruct-2507', NULL, true, '2026-05-19 17:03:53.223881+00', '2026-07-10 09:00:22.252332+00', '{"tag": "", "prompt": 0.00000004815, "completion": 0.00000019305, "create_time": 1753806965, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 32000, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('997a0211-e53e-44db-bbb9-0064f869cb0b', '38f5b8d7-54ae-4be3-9f15-d7c67a355134', 'glm-5.2', NULL, true, '2026-06-16 18:00:42.132609+00', '2026-07-10 09:00:20.212197+00', '{"tag": "Latest", "prompt": 0.00000093, "completion": 0.000003, "create_time": 1781631930, "schema_version": 1, "input_cache_read": 0.00000018, "max_context_tokens": 1048576, "max_completion_tokens": 32768, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('e186ea3d-5024-471f-a6f7-adbaf0525485', 'f5522dbf-cdff-469d-b78b-b68f3e28b83c', 'glm-5.2', NULL, true, '2026-06-16 18:00:42.139497+00', '2026-07-10 09:00:20.219038+00', '{"tag": "Latest", "prompt": 0.00000093, "completion": 0.000003, "create_time": 1781631930, "schema_version": 1, "input_cache_read": 0.00000018, "max_context_tokens": 1048576, "max_completion_tokens": 32768, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('8b3b3650-046b-4bfc-ba93-7c0c315e8955', '2be846df-8b85-4d9e-b94e-3f0c5cc3d223', 'fusion', NULL, true, '2026-06-07 15:16:14.588554+00', '2026-07-10 09:00:20.226206+00', '{"tag": "Latest", "prompt": 0, "completion": 0, "create_time": 1781371647, "schema_version": 1, "max_context_tokens": 1000000, "max_completion_tokens": null, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('781a8a13-62fa-4493-a1cb-54aeed4dea83', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3-coder', NULL, true, '2026-05-19 17:03:53.519474+00', '2026-07-10 09:00:22.356204+00', '{"tag": "", "prompt": 0.00000022, "completion": 0.0000018, "create_time": 1753230546, "schema_version": 1, "max_context_tokens": 1048576, "max_completion_tokens": 65536, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('7109efc8-56bd-400a-9ca7-628f199b4b1b', '502f3435-16b3-4f68-b4dc-07dbe66861ab', 'ui-tars-1.5-7b', NULL, true, '2026-05-06 08:32:19.424786+00', '2026-07-10 09:00:22.37003+00', '{"tag": "Latest", "prompt": 0.0000001, "completion": 0.0000002, "create_time": 1753205056, "schema_version": 1, "input_cache_read": 0.0000001, "max_context_tokens": 128000, "max_completion_tokens": 2048, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('c0d0fe19-4fa3-4b04-bb3a-4a0e53954a61', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemini-2.5-flash-lite', NULL, true, '2026-05-06 08:32:19.431427+00', '2026-07-10 09:00:22.376947+00', '{"tag": "", "audio": 0.0000003, "image": 0.0000001, "prompt": 0.0000001, "completion": 0.0000004, "web_search": 0.014, "create_time": 1753200276, "schema_version": 1, "input_cache_read": 0.00000001, "input_cache_write": 0.00000008333333333333334, "internal_reasoning": 0.0000004, "max_context_tokens": 1048576, "max_completion_tokens": 65535, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('66ac5eb4-f5fa-421d-a020-ae1f58276501', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemini-3-pro-image', NULL, true, '2026-06-18 05:00:42.616757+00', '2026-07-10 09:00:20.190888+00', '{"tag": "", "audio": 0.000002, "image": 0.000002, "prompt": 0.000002, "completion": 0.000012, "web_search": 0.014, "create_time": 1781754054, "schema_version": 1, "input_cache_read": 0.0000002, "input_cache_write": 0.000000375, "internal_reasoning": 0.000012, "max_context_tokens": 65536, "max_completion_tokens": 32768, "model_interaction_type": "image"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('d8618d78-53dd-4083-95b9-7c55634d67cf', '47927a94-7043-4921-b67e-8389985f9aab', 'north-mini-code:free', NULL, true, '2026-06-17 22:00:08.763548+00', '2026-07-10 09:00:20.198125+00', '{"tag": "Latest", "prompt": 0, "completion": 0, "create_time": 1781723748, "schema_version": 1, "max_context_tokens": 256000, "max_completion_tokens": 64000, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('ac676c49-54ca-4a1a-9a69-ec8895ccc519', '55857a3a-55f0-4879-b39f-cd252a8bcbf9', 'glm-5.2', NULL, true, '2026-06-16 18:00:42.123525+00', '2026-07-10 09:00:20.2051+00', '{"tag": "Latest", "prompt": 0.00000093, "completion": 0.000003, "create_time": 1781631930, "schema_version": 1, "input_cache_read": 0.00000018, "max_context_tokens": 1048576, "max_completion_tokens": 32768, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('cbc721de-c186-4f00-ab40-133d4bf2590b', '98f229c5-42ef-4167-91b1-47846b4f381e', 'grok-4.3', NULL, true, '2026-05-06 08:32:17.667564+00', '2026-07-10 09:00:20.406784+00', '{"tag": "", "prompt": 0.00000125, "completion": 0.0000025, "web_search": 0.005, "create_time": 1777591821, "schema_version": 1, "input_cache_read": 0.0000002, "max_context_tokens": 1000000, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('c3536204-98ef-4a69-8b04-d3b6d20b6276', '09b94796-8f59-4775-976b-ee85a5a6d927', 'claude-opus-4.8-fast', NULL, true, '2026-05-28 18:00:18.161773+00', '2026-07-10 09:00:20.327172+00', '{"tag": "", "prompt": 0.00001, "completion": 0.00005, "web_search": 0.01, "create_time": 1779913703, "schema_version": 1, "input_cache_read": 0.000001, "input_cache_write": 0.0000125, "max_context_tokens": 1000000, "input_cache_write_1h": 0.00002, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('ef53f31f-6f13-48b0-a2a0-cb6e5740bda7', '1220c61f-f41a-4985-9b71-a3b10efed282', 'granite-4.1-8b', NULL, true, '2026-05-06 08:32:17.679161+00', '2026-07-10 09:00:20.413725+00', '{"tag": "Latest", "prompt": 0.00000005, "completion": 0.0000001, "create_time": 1777577071, "schema_version": 1, "input_cache_read": 0.00000005, "max_context_tokens": 131072, "max_completion_tokens": 131072, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('3d78c004-6109-4569-80f0-cb7d5c80d896', '09b94796-8f59-4775-976b-ee85a5a6d927', 'claude-opus-4.8', NULL, true, '2026-05-28 18:00:18.171718+00', '2026-07-10 09:00:20.334392+00', '{"tag": "", "prompt": 0.000005, "completion": 0.000025, "web_search": 0.01, "create_time": 1779905091, "schema_version": 1, "input_cache_read": 0.0000005, "input_cache_write": 0.00000625, "max_context_tokens": 1000000, "input_cache_write_1h": 0.00001, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('b724473a-91fe-49b4-97e8-89af53e8d766', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3.7-max', NULL, true, '2026-05-21 16:00:32.080617+00', '2026-07-10 09:00:20.341535+00', '{"tag": "", "prompt": 0.00000125, "completion": 0.00000375, "create_time": 1779376861, "schema_version": 1, "input_cache_read": 0.00000025, "input_cache_write": 0.0000015625, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('d2ac6498-96b7-4b04-956b-d872367e9014', '09b94796-8f59-4775-976b-ee85a5a6d927', 'claude-opus-4.7-fast', NULL, true, '2026-05-12 20:00:42.366358+00', '2026-07-10 09:00:20.377665+00', '{"tag": "", "prompt": 0.00003, "completion": 0.00015, "web_search": 0.01, "create_time": 1778613011, "schema_version": 1, "input_cache_read": 0.000003, "input_cache_write": 0.0000375, "max_context_tokens": 1000000, "input_cache_write_1h": 0.00006, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('fb7f621f-21f9-4f6f-84bf-aa4de16582a4', 'f6a87e1d-825a-4a89-9231-daef28b59db5', 'perceptron-mk1', NULL, true, '2026-05-12 16:00:28.13683+00', '2026-07-10 09:00:20.385153+00', '{"tag": "Latest", "prompt": 0.00000015, "completion": 0.0000015, "create_time": 1778597029, "schema_version": 1, "max_context_tokens": 32768, "max_completion_tokens": 8192, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('2afde105-8cf5-4c86-b3d9-47f921a83803', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemini-3.1-flash-lite', NULL, true, '2026-05-07 17:00:22.450706+00', '2026-07-10 09:00:20.392602+00', '{"tag": "", "audio": 0.0000005, "image": 0.00000025, "prompt": 0.00000025, "completion": 0.0000015, "web_search": 0.014, "create_time": 1778168828, "schema_version": 1, "input_cache_read": 0.000000025, "input_cache_write": 0.00000008333333333333334, "internal_reasoning": 0.0000015, "max_context_tokens": 1048576, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('24ddc231-903e-473d-8524-71a47070c5b2', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-chat-latest', NULL, true, '2026-05-06 08:32:17.65443+00', '2026-07-10 09:00:20.399828+00', '{"tag": "", "prompt": 0.000005, "completion": 0.00003, "web_search": 0.01, "create_time": 1778000212, "schema_version": 1, "input_cache_read": 0.0000005, "max_context_tokens": 400000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('0a238991-e5f7-4f23-8642-9e4588a42175', '09b94796-8f59-4775-976b-ee85a5a6d927', 'claude-sonnet-latest', NULL, true, '2026-05-06 08:32:17.787649+00', '2026-07-10 09:00:20.469985+00', '{"tag": "", "prompt": 0.000002, "completion": 0.00001, "web_search": 0.01, "create_time": 1777318368, "schema_version": 1, "input_cache_read": 0.0000002, "input_cache_write": 0.0000025, "max_context_tokens": 1000000, "input_cache_write_1h": 0.000004, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('04cdc3f5-396b-4a23-b8f4-44c89478d265', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-latest', NULL, true, '2026-05-06 08:32:17.795804+00', '2026-07-10 09:00:20.476742+00', '{"tag": "", "prompt": 0.000005, "completion": 0.00003, "web_search": 0.01, "create_time": 1777318334, "schema_version": 1, "input_cache_read": 0.0000005, "input_cache_write": 0.00000625, "max_context_tokens": 1050000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('8ebde093-2cb9-47f2-a21b-465fe07d8269', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3.5-plus-20260420', NULL, true, '2026-05-06 08:32:17.804282+00', '2026-07-10 09:00:20.483803+00', '{"tag": "", "prompt": 0.0000003, "completion": 0.0000018, "create_time": 1777261368, "schema_version": 1, "input_cache_write": 0.000000375, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('ce5107f7-a957-4ec5-bcb9-c7944c33e61c', '59f22d14-a479-4667-86e5-7e7d7433603e', 'hy3-preview', NULL, true, '2026-05-08 23:00:58.563928+00', '2026-07-10 09:00:20.6193+00', '{"tag": "", "prompt": 0.000000063, "completion": 0.00000021, "create_time": 1776878150, "schema_version": 1, "input_cache_read": 0.000000021, "max_context_tokens": 262144, "max_completion_tokens": null, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('2e686c55-717c-4e9f-a01d-6882034389e0', '09b4c6f6-ff86-4c84-97b1-4a03ce281453', 'mimo-v2.5', NULL, true, '2026-05-06 08:32:18.037059+00', '2026-07-10 09:00:20.632835+00', '{"tag": "", "prompt": 0.000000105, "completion": 0.00000028, "create_time": 1776874269, "schema_version": 1, "input_cache_read": 0.000000028, "max_context_tokens": 1048576, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('c7e1bc34-6ab0-41ed-b5af-0705c98691fc', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3.6-plus', NULL, true, '2026-05-19 17:03:49.320458+00', '2026-07-10 09:00:20.73732+00', '{"tag": "", "prompt": 0.000000325, "completion": 0.00000195, "create_time": 1775133557, "schema_version": 1, "input_cache_write": 0.00000040625, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('1ceee3e2-1961-4497-89e1-e4888ba7b730', '09b94796-8f59-4775-976b-ee85a5a6d927', 'claude-opus-latest', NULL, true, '2026-05-06 08:32:18.18037+00', '2026-07-10 09:00:20.646792+00', '{"tag": "", "prompt": 0.000005, "completion": 0.000025, "web_search": 0.01, "create_time": 1776795361, "schema_version": 1, "input_cache_read": 0.0000005, "input_cache_write": 0.00000625, "max_context_tokens": 1000000, "input_cache_write_1h": 0.00001, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('34bc0e33-8986-42cd-a1f9-a6100faf168e', '4d50bc54-56de-46a6-97db-46362130d4b8', 'kimi-k2.6', NULL, true, '2026-05-06 08:32:18.196246+00', '2026-07-10 09:00:20.66068+00', '{"tag": "", "prompt": 0.00000066, "completion": 0.00000341, "create_time": 1776699402, "schema_version": 1, "input_cache_read": 0.00000015, "max_context_tokens": 262144, "max_completion_tokens": 262144, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('e3df637f-93f9-47f7-b5fc-a8d5bad8f43f', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemma-4-31b-it:free', NULL, true, '2026-06-07 15:16:14.909347+00', '2026-07-10 09:00:20.709565+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1775148486, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 8192, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('a42ad014-2b91-48bf-a561-1b254d386aa8', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemma-4-31b-it', NULL, true, '2026-05-06 08:32:18.238965+00', '2026-07-10 09:00:20.716538+00', '{"tag": "", "prompt": 0.00000012, "completion": 0.00000035, "create_time": 1775148486, "schema_version": 1, "input_cache_read": 0.00000009, "max_context_tokens": 262144, "max_completion_tokens": 262144, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('2b1191e8-c117-4fcc-88d9-408b6380474f', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3.6-plus', NULL, true, '2026-05-06 08:32:18.246568+00', '2026-07-10 09:00:20.723383+00', '{"tag": "", "prompt": 0.000000325, "completion": 0.00000195, "create_time": 1775133557, "schema_version": 1, "input_cache_write": 0.00000040625, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('70867a81-cdf0-4ae0-8327-e25ea0983dbb', '09b4c6f6-ff86-4c84-97b1-4a03ce281453', 'mimo-v2.5-pro', NULL, true, '2026-05-06 08:32:17.893937+00', '2026-07-10 09:00:20.626032+00', '{"tag": "Latest", "prompt": 0.000000435, "completion": 0.00000087, "create_time": 1776874273, "schema_version": 1, "input_cache_read": 0.0000000036, "max_context_tokens": 1048576, "max_completion_tokens": 131072, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('7b2af97d-58de-42a9-98fd-dd4a42be58aa', '09b94796-8f59-4775-976b-ee85a5a6d927', 'claude-opus-4.7', NULL, true, '2026-05-06 08:32:18.202994+00', '2026-07-10 09:00:20.66756+00', '{"tag": "", "prompt": 0.000005, "completion": 0.000025, "web_search": 0.01, "create_time": 1776351100, "schema_version": 1, "input_cache_read": 0.0000005, "input_cache_write": 0.00000625, "max_context_tokens": 1000000, "input_cache_write_1h": 0.00001, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('51daf846-ba27-4749-9fd6-e307205fc96c', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3.6-plus', NULL, true, '2026-05-19 17:03:49.308225+00', '2026-07-10 09:00:20.730462+00', '{"tag": "", "prompt": 0.000000325, "completion": 0.00000195, "create_time": 1775133557, "schema_version": 1, "input_cache_write": 0.00000040625, "max_context_tokens": 1000000, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('6b2eb087-af14-45ea-9e70-02b0cd482ac6', '2be846df-8b85-4d9e-b94e-3f0c5cc3d223', 'pareto-code', NULL, true, '2026-06-07 15:16:14.844503+00', '2026-07-10 09:00:20.653732+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1776747900, "schema_version": 1, "max_context_tokens": 2000000, "max_completion_tokens": null, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('bbeeb41a-32a5-4fcd-b8dc-1e6901114321', '493b150e-48c0-4fd4-9866-56bd3d915c46', 'deepseek-v4-flash', NULL, true, '2026-05-06 08:32:17.88174+00', '2026-07-10 09:00:20.61246+00', '{"tag": "", "prompt": 0.00000009, "completion": 0.00000018, "create_time": 1777000666, "schema_version": 1, "input_cache_read": 0.000000018, "max_context_tokens": 1048576, "max_completion_tokens": 65536, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('d35eaa3f-df68-4925-bcc7-dcc82d447449', '55857a3a-55f0-4879-b39f-cd252a8bcbf9', 'glm-5.1', NULL, true, '2026-05-21 16:00:32.574419+00', '2026-07-10 09:00:20.674564+00', '{"tag": "", "prompt": 0.000000966, "completion": 0.000003036, "create_time": 1775578025, "schema_version": 1, "input_cache_read": 0.0000001794, "max_context_tokens": 202752, "max_completion_tokens": 128000, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('1347db06-1ad6-4e30-ab25-177b258e315d', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5.4-image-2', NULL, true, '2026-05-06 08:32:18.131604+00', '2026-07-10 09:00:20.639888+00', '{"tag": "", "prompt": 0.000008, "completion": 0.000015, "web_search": 0.01, "create_time": 1776797528, "schema_version": 1, "input_cache_read": 0.000002, "max_context_tokens": 272000, "max_completion_tokens": 128000, "model_interaction_type": "image"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('67b2d4b8-cea8-45aa-a723-045db1c13d0f', '38f5b8d7-54ae-4be3-9f15-d7c67a355134', 'glm-5.1', NULL, true, '2026-05-21 16:00:32.582759+00', '2026-07-10 09:00:20.681978+00', '{"tag": "", "prompt": 0.000000966, "completion": 0.000003036, "create_time": 1775578025, "schema_version": 1, "input_cache_read": 0.0000001794, "max_context_tokens": 202752, "max_completion_tokens": 128000, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('9d88ee99-f0dc-48a3-af73-2a36bbf71472', '55857a3a-55f0-4879-b39f-cd252a8bcbf9', 'glm-5v-turbo', NULL, true, '2026-05-06 08:32:18.254146+00', '2026-07-10 09:00:20.74417+00', '{"tag": "", "prompt": 0.0000012, "completion": 0.000004, "create_time": 1775061458, "schema_version": 1, "input_cache_read": 0.00000024, "max_context_tokens": 202752, "max_completion_tokens": 131072, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('5e8513bc-6dac-4192-bccc-8d3ab9298728', 'f5522dbf-cdff-469d-b78b-b68f3e28b83c', 'glm-5v-turbo', NULL, true, '2026-05-19 17:03:49.450174+00', '2026-07-10 09:00:20.757651+00', '{"tag": "", "prompt": 0.0000012, "completion": 0.000004, "create_time": 1775061458, "schema_version": 1, "input_cache_read": 0.00000024, "max_context_tokens": 202752, "max_completion_tokens": 131072, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('a15e0268-22e6-40d3-a512-11fb7b0b0f76', 'fee873f7-15b7-4809-b9ba-2737224b15ed', 'trinity-large-thinking', NULL, true, '2026-05-06 08:32:18.261724+00', '2026-07-10 09:00:20.764589+00', '{"tag": "Latest", "prompt": 0.00000025, "completion": 0.0000008, "create_time": 1775058318, "schema_version": 1, "input_cache_read": 0.00000006, "max_context_tokens": 262144, "max_completion_tokens": 80000, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('5f9c1f54-3c31-4bfa-be0e-4c9136b7b6ec', '98f229c5-42ef-4167-91b1-47846b4f381e', 'grok-4.20-multi-agent', NULL, true, '2026-05-06 08:32:18.268507+00', '2026-07-10 09:00:20.771261+00', '{"tag": "", "prompt": 0.00000125, "completion": 0.0000025, "web_search": 0.005, "create_time": 1774979158, "schema_version": 1, "input_cache_read": 0.0000002, "max_context_tokens": 2000000, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('cc458db6-4ff0-4631-8805-4f05d1028218', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'lyria-3-pro-preview', NULL, true, '2026-06-07 15:16:14.980401+00', '2026-07-10 09:00:20.785467+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1774907286, "schema_version": 1, "max_context_tokens": 1048576, "max_completion_tokens": 65536, "model_interaction_type": "audio"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('3b580a3b-2e01-4d07-b7b8-6a049f8dc85b', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'lyria-3-clip-preview', NULL, true, '2026-06-07 15:16:14.98658+00', '2026-07-10 09:00:20.792559+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1774907255, "schema_version": 1, "max_context_tokens": 1048576, "max_completion_tokens": 65536, "model_interaction_type": "audio"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('4aee3b84-8348-4f6e-9ef2-453b2f8d4c12', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5.4', NULL, true, '2026-05-06 08:32:18.391431+00', '2026-07-10 09:00:20.917328+00', '{"tag": "", "prompt": 0.0000025, "completion": 0.000015, "web_search": 0.01, "create_time": 1772734352, "schema_version": 1, "input_cache_read": 0.00000025, "max_context_tokens": 1050000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('c599c160-be05-47fc-a92f-2e6c6b607b8a', '917d8043-1301-4b63-ba4b-8d12603dae39', 'mercury-2', NULL, true, '2026-05-06 08:32:18.398753+00', '2026-07-10 09:00:20.924174+00', '{"tag": "Latest", "prompt": 0.00000025, "completion": 0.00000075, "create_time": 1772636275, "schema_version": 1, "input_cache_read": 0.000000025, "max_context_tokens": 128000, "max_completion_tokens": 50000, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('f1494d5c-5db9-4f12-8819-d3c16a394564', '3865ca54-b799-4bb8-b769-9ea883771901', 'aion-2.0', NULL, true, '2026-05-06 08:32:18.490337+00', '2026-07-10 09:00:21.059276+00', '{"tag": "", "prompt": 0.0000008, "completion": 0.0000016, "create_time": 1771881306, "schema_version": 1, "input_cache_read": 0.0000002, "max_context_tokens": 131072, "max_completion_tokens": 32768, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('71ce4815-5450-40ab-9a4f-0a8b06ef0a62', '09b94796-8f59-4775-976b-ee85a5a6d927', 'claude-sonnet-4.6', NULL, true, '2026-05-06 08:32:18.506367+00', '2026-07-10 09:00:21.073151+00', '{"tag": "", "prompt": 0.000003, "completion": 0.000015, "web_search": 0.01, "create_time": 1771342990, "schema_version": 1, "input_cache_read": 0.0000003, "input_cache_write": 0.00000375, "max_context_tokens": 1000000, "input_cache_write_1h": 0.000006, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('203287b6-f4b2-40a1-91fb-fb038b46cbc5', '38f5b8d7-54ae-4be3-9f15-d7c67a355134', 'glm-4.7-flash', NULL, true, '2026-05-19 17:03:50.951811+00', '2026-07-10 09:00:21.300251+00', '{"tag": "", "prompt": 0.00000006, "completion": 0.0000004, "create_time": 1768833913, "schema_version": 1, "input_cache_read": 0.00000001, "max_context_tokens": 202752, "max_completion_tokens": 16384, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('b62d34d8-d171-4360-885e-e2c903976df7', '39e2c759-ca87-4a6d-bb13-95d83824f8ea', 'lfm-2.5-1.2b-thinking:free', NULL, true, '2026-06-07 15:16:15.39357+00', '2026-07-10 09:00:21.265571+00', '{"tag": "Latest", "prompt": 0, "completion": 0, "create_time": 1768927527, "schema_version": 1, "max_context_tokens": 32768, "max_completion_tokens": null, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('bb52580c-164c-42f9-9212-a24ca678efb5', '55857a3a-55f0-4879-b39f-cd252a8bcbf9', 'glm-4.7', NULL, true, '2026-05-06 08:32:18.684773+00', '2026-07-10 09:00:21.349168+00', '{"tag": "", "prompt": 0.0000004, "completion": 0.00000175, "create_time": 1766378014, "schema_version": 1, "input_cache_read": 0.00000008, "max_context_tokens": 202752, "max_completion_tokens": 131072, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('487b61eb-df74-4bef-b52c-ecc28a38cef6', '2be846df-8b85-4d9e-b94e-3f0c5cc3d223', 'free', NULL, true, '2026-06-07 15:16:15.349685+00', '2026-07-10 09:00:21.207832+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1769917427, "schema_version": 1, "max_context_tokens": 200000, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('5c93e450-122c-4907-b48f-86d4d60309b3', 'd76d415e-972f-4cf9-9727-78e092ce5c56', 'seed-1.6-flash', NULL, true, '2026-05-06 08:32:18.662358+00', '2026-07-10 09:00:21.321342+00', '{"tag": "", "prompt": 0.000000075, "completion": 0.0000003, "create_time": 1766505011, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 32768, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('7f5ae2a1-fbd4-42c7-a6a3-fc521bb4817b', '39e2c759-ca87-4a6d-bb13-95d83824f8ea', 'lfm-2.5-1.2b-instruct:free', NULL, true, '2026-06-07 15:16:15.399379+00', '2026-07-10 09:00:21.272587+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1768927521, "schema_version": 1, "max_context_tokens": 32768, "max_completion_tokens": null, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('76c0d590-2ce8-4e78-a5a6-fc97bea572c1', 'f5522dbf-cdff-469d-b78b-b68f3e28b83c', 'glm-4.7-flash', NULL, true, '2026-05-19 17:03:50.964457+00', '2026-07-10 09:00:21.307055+00', '{"tag": "", "prompt": 0.00000006, "completion": 0.0000004, "create_time": 1768833913, "schema_version": 1, "input_cache_read": 0.00000001, "max_context_tokens": 202752, "max_completion_tokens": 16384, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('6f30c4d8-4a4a-42ac-99d0-3c84067de1ad', 'd76d415e-972f-4cf9-9727-78e092ce5c56', 'seed-1.6', NULL, true, '2026-05-06 08:32:18.669324+00', '2026-07-10 09:00:21.328329+00', '{"tag": "", "prompt": 0.00000025, "completion": 0.000002, "create_time": 1766504997, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 32768, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('c95812a0-275c-462e-9600-ada55766c1bb', '38f5b8d7-54ae-4be3-9f15-d7c67a355134', 'glm-4.7', NULL, true, '2026-05-19 17:03:51.057713+00', '2026-07-10 09:00:21.35584+00', '{"tag": "", "prompt": 0.0000004, "completion": 0.00000175, "create_time": 1766378014, "schema_version": 1, "input_cache_read": 0.00000008, "max_context_tokens": 202752, "max_completion_tokens": 131072, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('cfc1511f-38a1-4434-8e08-8850c3f496ac', '4d50bc54-56de-46a6-97db-46362130d4b8', 'kimi-k2.5', NULL, true, '2026-05-06 08:32:18.588877+00', '2026-07-10 09:00:21.229179+00', '{"tag": "", "prompt": 0.000000375, "completion": 0.000002025, "create_time": 1769487076, "schema_version": 1, "input_cache_read": 0.000000203, "max_context_tokens": 262144, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('c7b5411e-b296-49ff-8a27-a40494956258', '9ea37c4f-52b1-4489-9f79-eba4bbd3ecf7', 'solar-pro-3', NULL, true, '2026-05-06 08:32:18.595881+00', '2026-07-10 09:00:21.236278+00', '{"tag": "Latest", "prompt": 0.00000015, "completion": 0.0000006, "create_time": 1769481200, "schema_version": 1, "input_cache_read": 0.000000015, "max_context_tokens": 128000, "max_completion_tokens": null, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('977690d4-a2c3-445e-94be-d2ab70228930', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-audio', NULL, true, '2026-05-06 08:32:18.624865+00', '2026-07-10 09:00:21.279322+00', '{"tag": "", "audio": 0.000032, "prompt": 0.0000025, "completion": 0.00001, "create_time": 1768862569, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": 16384, "model_interaction_type": "audio"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('c5ee2814-0d17-4826-9678-b201395da534', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5.2-codex', NULL, true, '2026-05-06 08:32:18.65464+00', '2026-07-10 09:00:21.313857+00', '{"tag": "", "prompt": 0.00000175, "completion": 0.000014, "web_search": 0.01, "create_time": 1768409315, "schema_version": 1, "input_cache_read": 0.000000175, "max_context_tokens": 400000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('9f5489e5-bc8c-4052-b394-7faf7d5dde12', '2810aca3-c2e5-426d-a8c8-2bddc1ff480d', 'minimax-m2-her', NULL, true, '2026-05-06 08:32:18.603254+00', '2026-07-10 09:00:21.243675+00', '{"tag": "", "prompt": 0.0000003, "completion": 0.0000012, "create_time": 1769177239, "schema_version": 1, "input_cache_read": 0.00000003, "max_context_tokens": 65536, "max_completion_tokens": 2048, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('c1ca65ed-e17b-43e0-9543-1aa00e15ed71', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-audio-mini', NULL, true, '2026-05-06 08:32:18.631979+00', '2026-07-10 09:00:21.285959+00', '{"tag": "", "audio": 0.0000006, "prompt": 0.0000006, "completion": 0.0000024, "create_time": 1768859419, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": 16384, "model_interaction_type": "audio"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('08e64a8f-e6a2-4385-b131-dcfe76f022bb', '2810aca3-c2e5-426d-a8c8-2bddc1ff480d', 'minimax-m2.1', NULL, true, '2026-05-06 08:32:18.677489+00', '2026-07-10 09:00:21.335182+00', '{"tag": "", "prompt": 0.0000003, "completion": 0.0000012, "create_time": 1766454997, "schema_version": 1, "input_cache_read": 0.00000003, "max_context_tokens": 204800, "max_completion_tokens": 131072, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('ed4b4884-2aaf-495d-8a1d-ee04e39ae44e', 'ec126a88-8820-4ab3-ba63-7cd1c1b1aaf2', 'minimax-m2.1', NULL, true, '2026-05-19 17:03:51.026597+00', '2026-07-10 09:00:21.342004+00', '{"tag": "", "prompt": 0.0000003, "completion": 0.0000012, "create_time": 1766454997, "schema_version": 1, "input_cache_read": 0.00000003, "max_context_tokens": 204800, "max_completion_tokens": 131072, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('593a8735-0b46-4df0-a5e5-84b6740a0e2a', 'f5522dbf-cdff-469d-b78b-b68f3e28b83c', 'glm-4.6v', NULL, true, '2026-05-19 17:03:51.241653+00', '2026-07-10 09:00:21.440692+00', '{"tag": "", "prompt": 0.0000003, "completion": 0.0000009, "create_time": 1765207462, "schema_version": 1, "input_cache_read": 0.000000055, "max_context_tokens": 131072, "max_completion_tokens": 32768, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('9e5894eb-b1b7-4b0d-9ca8-44770a9f3bdb', '493b150e-48c0-4fd4-9866-56bd3d915c46', 'deepseek-v3.2', NULL, true, '2026-05-06 08:32:18.837633+00', '2026-07-10 09:00:21.514572+00', '{"tag": "", "prompt": 0.0000002145, "completion": 0.00000032175, "create_time": 1764594642, "schema_version": 1, "input_cache_read": 0.00000002145, "max_context_tokens": 131072, "max_completion_tokens": 64000, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('633acb8c-6107-46c3-8d80-d64adc35e862', '2be846df-8b85-4d9e-b94e-3f0c5cc3d223', 'bodybuilder', NULL, true, '2026-06-07 15:16:15.568089+00', '2026-07-10 09:00:21.450206+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1764903653, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": null, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('f2003101-112d-460d-9f7c-85bc83ebabe1', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5.2-pro', NULL, true, '2026-05-06 08:32:18.724695+00', '2026-07-10 09:00:21.398258+00', '{"tag": "", "prompt": 0.000021, "completion": 0.000168, "web_search": 0.01, "create_time": 1765389780, "schema_version": 1, "max_context_tokens": 400000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('4b6df1f8-ee78-4f13-9cb4-944ac0e74526', '004533f3-71af-47b3-a4b4-9dcd2eeff9b8', 'ministral-8b-2512', NULL, true, '2026-05-06 08:32:18.800644+00', '2026-07-10 09:00:21.485627+00', '{"tag": "", "prompt": 0.00000015, "completion": 0.00000015, "create_time": 1764681654, "schema_version": 1, "input_cache_read": 0.000000015, "max_context_tokens": 262144, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('de160dd6-46b3-4e6b-b64f-cfcf086d0169', '004533f3-71af-47b3-a4b4-9dcd2eeff9b8', 'ministral-3b-2512', NULL, true, '2026-05-06 08:32:18.808242+00', '2026-07-10 09:00:21.492741+00', '{"tag": "", "prompt": 0.0000001, "completion": 0.0000001, "create_time": 1764681560, "schema_version": 1, "input_cache_read": 0.00000001, "max_context_tokens": 131072, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('e5b30284-329c-4c53-b2ab-2626114cc3ed', '004533f3-71af-47b3-a4b4-9dcd2eeff9b8', 'mistral-large-2512', NULL, true, '2026-05-06 08:32:18.815201+00', '2026-07-10 09:00:21.5002+00', '{"tag": "", "prompt": 0.0000005, "completion": 0.0000015, "create_time": 1764624472, "schema_version": 1, "input_cache_read": 0.00000005, "max_context_tokens": 262144, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('e6c55c04-16f2-4495-86c9-71819421aa29', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemini-3-flash-preview', NULL, true, '2026-05-06 08:32:18.692097+00', '2026-07-10 09:00:21.369784+00', '{"tag": "", "audio": 0.000001, "image": 0.0000005, "prompt": 0.0000005, "completion": 0.000003, "web_search": 0.014, "create_time": 1765987078, "schema_version": 1, "input_cache_read": 0.00000005, "input_cache_write": 0.00000008333333333333334, "internal_reasoning": 0.000003, "max_context_tokens": 1048576, "max_completion_tokens": 65535, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('3a2fb270-67d3-4e41-80e2-cc2b87754eea', '3b6bbaa2-d1ec-40c6-8a74-2371398db82e', 'nemotron-3-nano-30b-a3b:free', NULL, true, '2026-06-07 15:16:15.495468+00', '2026-07-10 09:00:21.376816+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1765731275, "schema_version": 1, "max_context_tokens": 256000, "max_completion_tokens": null, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('80213f7c-f808-4691-b21d-f0d1bbe0519e', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5.2-chat', NULL, true, '2026-05-06 08:32:18.717462+00', '2026-07-10 09:00:21.391329+00', '{"tag": "", "prompt": 0.00000175, "completion": 0.000014, "web_search": 0.01, "create_time": 1765389783, "schema_version": 1, "input_cache_read": 0.000000175, "max_context_tokens": 128000, "max_completion_tokens": 16384, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('ece06f51-4717-4d74-925c-3bfd44876ede', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5.2', NULL, true, '2026-05-06 08:32:18.732357+00', '2026-07-10 09:00:21.405088+00', '{"tag": "", "prompt": 0.00000175, "completion": 0.000014, "web_search": 0.01, "create_time": 1765389775, "schema_version": 1, "input_cache_read": 0.000000175, "max_context_tokens": 400000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('221294ea-c0b7-42da-9dfc-9e27562a53ea', 'fee873f7-15b7-4809-b9ba-2737224b15ed', 'trinity-mini', NULL, true, '2026-05-06 08:32:18.822531+00', '2026-07-10 09:00:21.507224+00', '{"tag": "", "prompt": 0.000000045, "completion": 0.00000015, "create_time": 1764601720, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 131072, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('487ee153-98b6-485e-8f55-3eb0814d3e8f', '004533f3-71af-47b3-a4b4-9dcd2eeff9b8', 'devstral-2512', NULL, true, '2026-05-06 08:32:18.739273+00', '2026-07-10 09:00:21.412004+00', '{"tag": "", "prompt": 0.0000004, "completion": 0.000002, "create_time": 1765285419, "schema_version": 1, "input_cache_read": 0.00000004, "max_context_tokens": 262144, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('98a68791-f1ef-431b-a48c-10e5f5556d0c', '3aae62b8-1e09-46bf-b98d-7068befbc2fe', 'relace-search', NULL, true, '2026-05-06 08:32:18.746637+00', '2026-07-10 09:00:21.419091+00', '{"tag": "Latest", "prompt": 0.000001, "completion": 0.000003, "create_time": 1765213560, "schema_version": 1, "max_context_tokens": 256000, "max_completion_tokens": 128000, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('c2269389-2c22-4c08-ac71-b8814507dda0', '55857a3a-55f0-4879-b39f-cd252a8bcbf9', 'glm-4.6v', NULL, true, '2026-05-06 08:32:18.753512+00', '2026-07-10 09:00:21.426236+00', '{"tag": "", "prompt": 0.0000003, "completion": 0.0000009, "create_time": 1765207462, "schema_version": 1, "input_cache_read": 0.000000055, "max_context_tokens": 131072, "max_completion_tokens": 32768, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('b2fc50b7-71e5-47ff-ac8e-bc569b058bca', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5.1-codex-max', NULL, true, '2026-05-06 08:32:18.778024+00', '2026-07-10 09:00:21.45888+00', '{"tag": "", "prompt": 0.00000125, "completion": 0.00001, "web_search": 0.01, "create_time": 1764878934, "schema_version": 1, "input_cache_read": 0.000000125, "max_context_tokens": 400000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('b2a7c432-3af7-47f1-9cbc-bae4e29a9779', '680a6550-c76c-44d2-b9c4-1d1022880732', 'nova-2-lite-v1', NULL, true, '2026-05-06 08:32:18.786493+00', '2026-07-10 09:00:21.46732+00', '{"tag": "Latest", "prompt": 0.0000003, "completion": 0.0000025, "create_time": 1764696672, "schema_version": 1, "max_context_tokens": 1000000, "max_completion_tokens": 65535, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('43052662-97ab-4efa-bdfc-6e421d8888cb', '38f5b8d7-54ae-4be3-9f15-d7c67a355134', 'glm-4.6v', NULL, true, '2026-05-19 17:03:51.225542+00', '2026-07-10 09:00:21.43332+00', '{"tag": "", "prompt": 0.0000003, "completion": 0.0000009, "create_time": 1765207462, "schema_version": 1, "input_cache_read": 0.000000055, "max_context_tokens": 131072, "max_completion_tokens": 32768, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('ab57ba23-9ed5-4244-aae2-34e24b67b472', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemini-3-pro-image-preview', NULL, true, '2026-05-06 08:32:18.859506+00', '2026-07-10 09:00:21.528243+00', '{"tag": "", "audio": 0.000002, "image": 0.000002, "prompt": 0.000002, "completion": 0.000012, "web_search": 0.014, "create_time": 1763653797, "schema_version": 1, "input_cache_read": 0.0000002, "input_cache_write": 0.000000375, "internal_reasoning": 0.000012, "max_context_tokens": 65536, "max_completion_tokens": 32768, "model_interaction_type": "image"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('ab39df82-684a-4815-b7a0-fe9680efac1c', 'b9612f06-8f03-4c21-a921-d0397c107d63', 'cogito-v2.1-671b', NULL, true, '2026-05-31 23:00:39.539316+00', '2026-07-10 09:00:21.535324+00', '{"tag": "Latest", "prompt": 0.00000125, "completion": 0.00000125, "create_time": 1763071233, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": null, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('cc5c5ec2-ec3a-4ea9-b90e-3277527179cf', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5.1-codex-mini', NULL, true, '2026-05-06 08:32:18.90416+00', '2026-07-10 09:00:21.563509+00', '{"tag": "", "prompt": 0.00000025, "completion": 0.000002, "web_search": 0.01, "create_time": 1763057820, "schema_version": 1, "input_cache_read": 0.000000025, "max_context_tokens": 400000, "max_completion_tokens": 100000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('6a7ed829-81b3-4d84-a3c6-fb9a667259d8', '680a6550-c76c-44d2-b9c4-1d1022880732', 'nova-premier-v1', NULL, true, '2026-05-06 08:32:18.917783+00', '2026-07-10 09:00:21.577421+00', '{"tag": "", "prompt": 0.0000025, "completion": 0.0000125, "create_time": 1761950332, "schema_version": 1, "input_cache_read": 0.000000625, "max_context_tokens": 1000000, "max_completion_tokens": 32000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('c0a80de0-7ef4-4b1d-9be9-58d809f57ccb', '1f21a50f-a00a-4669-82d2-ac6d2c05081f', 'sonar-pro-search', NULL, true, '2026-05-06 08:32:18.924902+00', '2026-07-10 09:00:21.584203+00', '{"tag": "Latest", "prompt": 0.000003, "completion": 0.000015, "web_search": 0.018, "create_time": 1761854366, "schema_version": 1, "max_context_tokens": 200000, "max_completion_tokens": 8000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('4287057a-edcc-4fd2-bfb9-1779d3dbe140', '3b6bbaa2-d1ec-40c6-8a74-2371398db82e', 'nemotron-nano-12b-v2-vl:free', NULL, true, '2026-06-07 15:16:15.702078+00', '2026-07-10 09:00:21.604974+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1761675565, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('f607407d-66f5-427b-b42c-9ee095ace213', '2810aca3-c2e5-426d-a8c8-2bddc1ff480d', 'minimax-m2', NULL, true, '2026-05-06 08:32:18.956388+00', '2026-07-10 09:00:21.612011+00', '{"tag": "", "prompt": 0.000000255, "completion": 0.00000102, "create_time": 1761252093, "schema_version": 1, "max_context_tokens": 204800, "max_completion_tokens": 131072, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('9ab88d05-f107-4dbf-bac3-cbf11b6d8af9', 'ec126a88-8820-4ab3-ba63-7cd1c1b1aaf2', 'minimax-m2', NULL, true, '2026-05-19 17:03:51.658692+00', '2026-07-10 09:00:21.618913+00', '{"tag": "", "prompt": 0.000000255, "completion": 0.00000102, "create_time": 1761252093, "schema_version": 1, "max_context_tokens": 204800, "max_completion_tokens": 131072, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('6e9d4ddf-e94e-4280-860c-830db57d3953', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3-vl-32b-instruct', NULL, true, '2026-05-06 08:32:18.963705+00', '2026-07-10 09:00:21.625978+00', '{"tag": "", "prompt": 0.000000104, "completion": 0.000000416, "create_time": 1761231332, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 32768, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('7e7553f7-47d8-4de5-9641-a3481e32fb59', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3-vl-32b-instruct', NULL, true, '2026-05-19 17:03:51.691293+00', '2026-07-10 09:00:21.633057+00', '{"tag": "", "prompt": 0.000000104, "completion": 0.000000416, "create_time": 1761231332, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 32768, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('ca267bd7-2266-4539-82c4-a323203a3edc', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-5-image', NULL, true, '2026-05-06 08:32:19.01246+00', '2026-07-10 09:00:21.710438+00', '{"tag": "", "prompt": 0.00001, "completion": 0.00001, "web_search": 0.01, "create_time": 1760447986, "schema_version": 1, "input_cache_read": 0.00000125, "max_context_tokens": 400000, "max_completion_tokens": 128000, "model_interaction_type": "image"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('1222d1ae-f590-4575-bd89-906960a894b5', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'o3-deep-research', NULL, true, '2026-05-06 08:32:19.019544+00', '2026-07-10 09:00:21.718049+00', '{"tag": "", "prompt": 0.00001, "completion": 0.00004, "web_search": 0.01, "create_time": 1760129661, "schema_version": 1, "input_cache_read": 0.0000025, "max_context_tokens": 200000, "max_completion_tokens": 100000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('bc9ffad4-425e-4d89-9a97-e39ea2143d52', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'o4-mini-deep-research', NULL, true, '2026-05-06 08:32:19.026622+00', '2026-07-10 09:00:21.725229+00', '{"tag": "", "prompt": 0.000002, "completion": 0.000008, "web_search": 0.01, "create_time": 1760129642, "schema_version": 1, "input_cache_read": 0.0000005, "max_context_tokens": 200000, "max_completion_tokens": 100000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('999e5c5b-26c7-4a42-8a5e-85db58a17096', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3-vl-235b-a22b-instruct', NULL, true, '2026-05-19 17:03:52.287632+00', '2026-07-10 09:00:21.865605+00', '{"tag": "", "prompt": 0.0000002, "completion": 0.00000088, "create_time": 1758668687, "schema_version": 1, "input_cache_read": 0.00000011, "max_context_tokens": 262144, "max_completion_tokens": 16384, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('4426e8c3-e6b4-47ac-8988-c6c271d6dee8', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3-next-80b-a3b-instruct', NULL, true, '2026-05-19 17:03:52.678772+00', '2026-07-10 09:00:22.015715+00', '{"tag": "", "prompt": 0.00000009, "completion": 0.0000011, "create_time": 1757612213, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 16384, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('16359dfe-07fb-45da-9240-8e602aa509f9', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen-plus-2025-07-28:thinking', NULL, true, '2026-05-06 08:32:19.188662+00', '2026-07-10 09:00:22.022869+00', '{"tag": "", "prompt": 0.00000026, "completion": 0.00000078, "create_time": 1757347599, "schema_version": 1, "input_cache_write": 0.000000325, "max_context_tokens": 1000000, "max_completion_tokens": 32768, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('38023337-b533-442c-9a12-3522b6be7dd1', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen-plus-2025-07-28:thinking', NULL, true, '2026-05-19 17:03:52.704708+00', '2026-07-10 09:00:22.029858+00', '{"tag": "", "prompt": 0.00000026, "completion": 0.00000078, "create_time": 1757347599, "schema_version": 1, "input_cache_write": 0.000000325, "max_context_tokens": 1000000, "max_completion_tokens": 32768, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('f1098dc4-2dec-48bc-8d5e-5fee0eec2b78', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3-30b-a3b-thinking-2507', NULL, true, '2026-05-19 17:03:52.837952+00', '2026-07-10 09:00:22.086011+00', '{"tag": "", "prompt": 0.00000013, "completion": 0.00000156, "create_time": 1756399192, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 32768, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('06a89f69-0b93-4539-bd30-85c7d1f5ee5d', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3-30b-a3b-thinking-2507', NULL, true, '2026-05-19 17:03:52.854702+00', '2026-07-10 09:00:22.093064+00', '{"tag": "", "prompt": 0.00000013, "completion": 0.00000156, "create_time": 1756399192, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 32768, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('d9c3b85a-32cc-463d-a1e1-790fa8be950a', '8602ce14-e8dc-435a-8d40-c42e1b094488', 'hermes-4-70b', NULL, true, '2026-05-06 08:32:19.2412+00', '2026-07-10 09:00:22.100323+00', '{"tag": "Latest", "prompt": 0.00000013, "completion": 0.0000004, "create_time": 1756236182, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": null, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('eeb7b021-81c6-4057-b5fb-eba3194225b9', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3-30b-a3b-instruct-2507', NULL, true, '2026-05-19 17:03:53.251915+00', '2026-07-10 09:00:22.259222+00', '{"tag": "", "prompt": 0.00000004815, "completion": 0.00000019305, "create_time": 1753806965, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 32000, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('53dd7393-b68c-497b-bccd-1289009157a6', '38f5b8d7-54ae-4be3-9f15-d7c67a355134', 'glm-4.5', NULL, true, '2026-05-19 17:03:53.275856+00', '2026-07-10 09:00:22.273061+00', '{"tag": "", "prompt": 0.0000006, "completion": 0.0000022, "create_time": 1753471347, "schema_version": 1, "input_cache_read": 0.00000011, "max_context_tokens": 131072, "max_completion_tokens": 98304, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('852cf85e-3959-4dec-a6a1-33eff121df1a', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3-235b-a22b-thinking-2507', NULL, true, '2026-05-19 17:03:53.388197+00', '2026-07-10 09:00:22.314137+00', '{"tag": "", "prompt": 0.0000001495, "completion": 0.000001495, "create_time": 1753449557, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": null, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('94b7a56e-2c5b-43fd-998c-f12941fe07b7', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-oss-20b:free', NULL, true, '2026-06-07 15:16:16.555316+00', '2026-07-10 09:00:22.196732+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1754414229, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 32768, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('31e2863a-8754-45ba-bfd5-b33f8e466a84', '55857a3a-55f0-4879-b39f-cd252a8bcbf9', 'glm-4.5-air', NULL, true, '2026-05-06 08:32:19.391157+00', '2026-07-10 09:00:22.286872+00', '{"tag": "", "prompt": 0.00000013, "completion": 0.00000085, "create_time": 1753471258, "schema_version": 1, "input_cache_read": 0.000000025, "max_context_tokens": 131072, "max_completion_tokens": 98304, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('a78c3af9-5b8f-4d8a-a9fa-c7d3d438ad32', 'f5522dbf-cdff-469d-b78b-b68f3e28b83c', 'glm-4.5-air', NULL, true, '2026-05-19 17:03:53.363998+00', '2026-07-10 09:00:22.300402+00', '{"tag": "", "prompt": 0.00000013, "completion": 0.00000085, "create_time": 1753471258, "schema_version": 1, "input_cache_read": 0.000000025, "max_context_tokens": 131072, "max_completion_tokens": 98304, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('ee5d3a5f-7371-421c-aaf5-db6fd676b4db', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3-coder:free', NULL, true, '2026-06-07 15:16:16.712045+00', '2026-07-10 09:00:22.335343+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1753230546, "schema_version": 1, "max_context_tokens": 1048576, "max_completion_tokens": 262000, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('be07fc40-5fac-434a-943a-626f463b1468', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3-coder', NULL, true, '2026-05-06 08:32:19.417623+00', '2026-07-10 09:00:22.34925+00', '{"tag": "", "prompt": 0.00000022, "completion": 0.0000018, "create_time": 1753230546, "schema_version": 1, "max_context_tokens": 1048576, "max_completion_tokens": 65536, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('bd0fa977-796a-419a-b1a5-b66b4a392400', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3-235b-a22b-2507', NULL, true, '2026-05-06 08:32:19.438239+00', '2026-07-10 09:00:22.383675+00', '{"tag": "", "prompt": 0.00000009, "completion": 0.0000001, "create_time": 1753119555, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 16384, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('b838fb36-0475-42bc-aa0c-bea64e0c4cb9', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3-235b-a22b-2507', NULL, true, '2026-05-19 17:03:53.602681+00', '2026-07-10 09:00:22.390264+00', '{"tag": "", "prompt": 0.00000009, "completion": 0.0000001, "create_time": 1753119555, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 16384, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('5c044140-736c-4bc2-94c7-dc5ed508276c', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3-coder-30b-a3b-instruct', NULL, true, '2026-05-06 08:32:19.3672+00', '2026-07-10 09:00:22.22473+00', '{"tag": "", "prompt": 0.00000007, "completion": 0.00000027, "create_time": 1753972379, "schema_version": 1, "max_context_tokens": 160000, "max_completion_tokens": 32768, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('6723008b-912c-4a1c-8bbd-1d24496fd53d', '55857a3a-55f0-4879-b39f-cd252a8bcbf9', 'glm-4.5', NULL, true, '2026-05-06 08:32:19.380609+00', '2026-07-10 09:00:22.266236+00', '{"tag": "", "prompt": 0.0000006, "completion": 0.0000022, "create_time": 1753471347, "schema_version": 1, "input_cache_read": 0.00000011, "max_context_tokens": 131072, "max_completion_tokens": 98304, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('f7f0fca8-9f5f-4bc0-8986-98406b2124c3', 'f5522dbf-cdff-469d-b78b-b68f3e28b83c', 'glm-4.5', NULL, true, '2026-05-19 17:03:53.28739+00', '2026-07-10 09:00:22.279761+00', '{"tag": "", "prompt": 0.0000006, "completion": 0.0000022, "create_time": 1753471347, "schema_version": 1, "input_cache_read": 0.00000011, "max_context_tokens": 131072, "max_completion_tokens": 98304, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('a2b64729-9d9f-4c9d-ba8b-b92614d787ba', '38f5b8d7-54ae-4be3-9f15-d7c67a355134', 'glm-4.5-air', NULL, true, '2026-05-19 17:03:53.351377+00', '2026-07-10 09:00:22.293742+00', '{"tag": "", "prompt": 0.00000013, "completion": 0.00000085, "create_time": 1753471258, "schema_version": 1, "input_cache_read": 0.000000025, "max_context_tokens": 131072, "max_completion_tokens": 98304, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('208ea236-7d76-4d64-b47e-9f18840bd128', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3-235b-a22b-thinking-2507', NULL, true, '2026-05-06 08:32:19.398759+00', '2026-07-10 09:00:22.307342+00', '{"tag": "", "prompt": 0.0000001495, "completion": 0.000001495, "create_time": 1753449557, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": null, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('eb38f211-87b1-4c30-b778-fc00705d829b', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3-235b-a22b-thinking-2507', NULL, true, '2026-05-19 17:03:53.399285+00', '2026-07-10 09:00:22.321237+00', '{"tag": "", "prompt": 0.0000001495, "completion": 0.000001495, "create_time": 1753449557, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": null, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('277a98ba-e1f6-478a-ba22-f2e8798bf8be', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3-coder:free', NULL, true, '2026-06-07 15:16:16.717939+00', '2026-07-10 09:00:22.342347+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1753230546, "schema_version": 1, "max_context_tokens": 1048576, "max_completion_tokens": 262000, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('68c17128-7925-49f1-b9d1-7e5d49b7d5f8', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3-coder', NULL, true, '2026-05-19 17:03:53.549436+00', '2026-07-10 09:00:22.363057+00', '{"tag": "", "prompt": 0.00000022, "completion": 0.0000018, "create_time": 1753230546, "schema_version": 1, "max_context_tokens": 1048576, "max_completion_tokens": 65536, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('929934d3-2f0f-4014-88c8-74764c16f1d6', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-oss-120b', NULL, true, '2026-05-06 08:32:19.334942+00', '2026-07-10 09:00:22.190064+00', '{"tag": "", "prompt": 0.000000036, "completion": 0.00000018, "create_time": 1754414231, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": null, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('c4bc00dc-867e-4194-a11a-88b6344686fb', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'o3-pro', NULL, true, '2026-05-06 08:32:19.541527+00', '2026-07-10 09:00:22.489375+00', '{"tag": "", "prompt": 0.00002, "completion": 0.00008, "web_search": 0.01, "create_time": 1749598352, "schema_version": 1, "max_context_tokens": 200000, "max_completion_tokens": 100000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('1dd197dd-e647-4dfc-9747-969d3db1e741', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemini-2.5-pro-preview-05-06', NULL, true, '2026-05-06 08:32:19.616075+00', '2026-07-10 09:00:22.539795+00', '{"tag": "", "audio": 0.00000125, "image": 0.00000125, "prompt": 0.00000125, "completion": 0.00001, "web_search": 0.014, "create_time": 1746578513, "schema_version": 1, "input_cache_read": 0.000000125, "input_cache_write": 0.000000375, "internal_reasoning": 0.00001, "max_context_tokens": 1048576, "max_completion_tokens": 65535, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('5fcd54cd-0dee-418c-b048-807503818851', '4d50bc54-56de-46a6-97db-46362130d4b8', 'kimi-k2', NULL, true, '2026-05-06 08:32:19.445025+00', '2026-07-10 09:00:22.404092+00', '{"tag": "", "prompt": 0.00000057, "completion": 0.0000023, "create_time": 1752263252, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 100352, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('a523a7a3-e7f0-4854-91e3-2efa053c6560', '05720ed1-8c9a-4e3e-885e-2025e5337770', 'morph-v3-large', NULL, true, '2026-05-06 08:32:19.485905+00', '2026-07-10 09:00:22.432998+00', '{"tag": "Latest", "prompt": 0.0000009, "completion": 0.0000019, "create_time": 1751910858, "schema_version": 1, "max_context_tokens": 262144, "max_completion_tokens": 131072, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('3e479e38-9532-4341-a93c-f991d209795d', '05720ed1-8c9a-4e3e-885e-2025e5337770', 'morph-v3-fast', NULL, true, '2026-05-06 08:32:19.492936+00', '2026-07-10 09:00:22.44044+00', '{"tag": "", "prompt": 0.0000008, "completion": 0.0000012, "create_time": 1751910002, "schema_version": 1, "max_context_tokens": 81920, "max_completion_tokens": 38000, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('4bf85209-2c0c-4d48-9ffb-47072201a1a7', 'ec126a88-8820-4ab3-ba63-7cd1c1b1aaf2', 'minimax-m1', NULL, true, '2026-05-19 17:03:53.782724+00', '2026-07-10 09:00:22.468487+00', '{"tag": "", "prompt": 0.0000004, "completion": 0.0000022, "create_time": 1750200414, "schema_version": 1, "max_context_tokens": 1000000, "max_completion_tokens": 40000, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('2dc94c2f-1fad-4fe5-9e4e-d3fd796c5967', '493b150e-48c0-4fd4-9866-56bd3d915c46', 'deepseek-r1-0528', NULL, true, '2026-05-06 08:32:19.580221+00', '2026-07-10 09:00:22.50518+00', '{"tag": "", "prompt": 0.0000005, "completion": 0.00000215, "create_time": 1748455170, "schema_version": 1, "input_cache_read": 0.00000035, "max_context_tokens": 163840, "max_completion_tokens": 32768, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('4a3669c0-07d1-4ea5-951c-af2c74d6a586', '09b94796-8f59-4775-976b-ee85a5a6d927', 'claude-opus-4', NULL, true, '2026-05-06 08:32:19.587465+00', '2026-07-10 09:00:22.512218+00', '{"tag": "", "prompt": 0.000015, "completion": 0.000075, "web_search": 0.01, "create_time": 1747931245, "schema_version": 1, "input_cache_read": 0.0000015, "input_cache_write": 0.00001875, "max_context_tokens": 200000, "input_cache_write_1h": 0.00003, "max_completion_tokens": 32000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('58c8ef2c-fcfd-4d28-a6e9-daf516e4b5e4', '7951f113-58d7-4802-80c0-365f624b7483', 'ernie-4.5-vl-424b-a47b', NULL, true, '2026-05-06 08:32:19.499531+00', '2026-07-10 09:00:22.447318+00', '{"tag": "Latest", "prompt": 0.00000042, "completion": 0.00000125, "create_time": 1751300903, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 16000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('95f99504-54ae-4ea9-a107-68f314d2ffff', '2810aca3-c2e5-426d-a8c8-2bddc1ff480d', 'minimax-m1', NULL, true, '2026-05-06 08:32:19.51997+00', '2026-07-10 09:00:22.461433+00', '{"tag": "", "prompt": 0.0000004, "completion": 0.0000022, "create_time": 1750200414, "schema_version": 1, "max_context_tokens": 1000000, "max_completion_tokens": 40000, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('23adc894-16b4-44a7-bd19-7d151420a735', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemini-2.5-flash', NULL, true, '2026-05-06 08:32:19.527464+00', '2026-07-10 09:00:22.475374+00', '{"tag": "", "audio": 0.000001, "image": 0.0000003, "prompt": 0.0000003, "completion": 0.0000025, "web_search": 0.014, "create_time": 1750172488, "schema_version": 1, "input_cache_read": 0.00000003, "input_cache_write": 0.00000008333333333333334, "internal_reasoning": 0.0000025, "max_context_tokens": 1048576, "max_completion_tokens": 65535, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('76a772c1-cfd5-4903-b1c9-22d0236db693', 'b0fa945d-ac33-4b5f-99e8-30c52a526c61', 'dolphin-mistral-24b-venice-edition:free', NULL, true, '2026-06-07 15:16:16.778208+00', '2026-07-10 09:00:22.410816+00', '{"tag": "Latest", "prompt": 0, "completion": 0, "create_time": 1752094966, "schema_version": 1, "max_context_tokens": 32768, "max_completion_tokens": null, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('7d1ad4e5-048c-424d-bb00-5d096fad0ff1', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemini-2.5-pro', NULL, true, '2026-05-06 08:32:19.534354+00', '2026-07-10 09:00:22.482233+00', '{"tag": "", "audio": 0.00000125, "image": 0.00000125, "prompt": 0.00000125, "completion": 0.00001, "web_search": 0.014, "create_time": 1750169544, "schema_version": 1, "input_cache_read": 0.000000125, "input_cache_write": 0.000000375, "internal_reasoning": 0.00001, "max_context_tokens": 1048576, "max_completion_tokens": 65536, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('db1fd9bf-1659-4939-bd08-f7dacd7d38a3', '59f22d14-a479-4667-86e5-7e7d7433603e', 'hunyuan-a13b-instruct', NULL, true, '2026-05-06 08:32:19.479038+00', '2026-07-10 09:00:22.425014+00', '{"tag": "", "prompt": 0.00000014, "completion": 0.00000057, "create_time": 1751987664, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 131072, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('e754e995-c677-4197-9236-96450c2d470d', '09b94796-8f59-4775-976b-ee85a5a6d927', 'claude-sonnet-4', NULL, true, '2026-05-06 08:32:19.59486+00', '2026-07-10 09:00:22.519149+00', '{"tag": "", "prompt": 0.000003, "completion": 0.000015, "web_search": 0.01, "create_time": 1747930371, "schema_version": 1, "input_cache_read": 0.0000003, "input_cache_write": 0.00000375, "max_context_tokens": 1000000, "input_cache_write_1h": 0.000006, "max_completion_tokens": 64000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('894bedf2-a57f-44e2-a888-13a856f5cf0a', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3-32b', NULL, true, '2026-05-19 17:03:54.497263+00', '2026-07-10 09:00:22.640189+00', '{"tag": "", "prompt": 0.00000008, "completion": 0.00000028, "create_time": 1745875945, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 16384, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('8a4b7268-a6bc-43a5-a88b-907ace3fb018', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'o1-pro', NULL, true, '2026-05-06 08:32:19.854554+00', '2026-07-10 09:00:22.741497+00', '{"tag": "", "prompt": 0.00015, "completion": 0.0006, "web_search": 0.01, "create_time": 1742423211, "schema_version": 1, "max_context_tokens": 200000, "max_completion_tokens": 100000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('a97909fc-37cc-4f4c-b562-e28fcebbe62f', '64647d14-f1cd-4965-926c-476e20bcb1c3', 'llama-guard-4-12b', NULL, true, '2026-05-06 08:32:19.656686+00', '2026-07-10 09:00:22.562691+00', '{"tag": "Latest", "prompt": 0.00000018, "completion": 0.00000018, "create_time": 1745975193, "schema_version": 1, "max_context_tokens": 163840, "max_completion_tokens": 16384, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('caaa718a-5dec-4102-9cea-1d41cfd38423', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3-235b-a22b', NULL, true, '2026-05-06 08:32:19.708422+00', '2026-07-10 09:00:22.654455+00', '{"tag": "", "prompt": 0.000000455, "completion": 0.00000182, "create_time": 1745875757, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 8192, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('362e3ef8-53d9-4cf5-aced-7ca7a17d1c30', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'o3', NULL, true, '2026-05-06 08:32:19.739694+00', '2026-07-10 09:00:22.682018+00', '{"tag": "", "prompt": 0.000002, "completion": 0.000008, "web_search": 0.01, "create_time": 1744823457, "schema_version": 1, "input_cache_read": 0.0000005, "max_context_tokens": 200000, "max_completion_tokens": 100000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('78377b7b-87be-41af-8dde-019bc08ea7ee', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'o4-mini', NULL, true, '2026-05-06 08:32:19.750992+00', '2026-07-10 09:00:22.689745+00', '{"tag": "", "prompt": 0.0000011, "completion": 0.0000044, "web_search": 0.01, "create_time": 1744820942, "schema_version": 1, "input_cache_read": 0.000000275, "max_context_tokens": 200000, "max_completion_tokens": 100000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('7f626e83-9da9-4184-a1bf-450afabfb224', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-4.1', NULL, true, '2026-05-06 08:32:19.762288+00', '2026-07-10 09:00:22.696837+00', '{"tag": "", "prompt": 0.000002, "completion": 0.000008, "web_search": 0.01, "create_time": 1744651385, "schema_version": 1, "input_cache_read": 0.0000005, "max_context_tokens": 1047576, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('6167a9c2-ddbb-48d7-843b-79c16bbe0b52', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-4.1-nano', NULL, true, '2026-05-06 08:32:19.785896+00', '2026-07-10 09:00:22.711833+00', '{"tag": "", "prompt": 0.0000001, "completion": 0.0000004, "web_search": 0.01, "create_time": 1744651369, "schema_version": 1, "input_cache_read": 0.000000025, "max_context_tokens": 1047576, "max_completion_tokens": 32768, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('30329224-809a-42a8-9bc8-304e4ac4369b', '64647d14-f1cd-4965-926c-476e20bcb1c3', 'llama-4-scout', NULL, true, '2026-05-06 08:32:19.831741+00', '2026-07-10 09:00:22.727768+00', '{"tag": "", "prompt": 0.0000001, "completion": 0.0000003, "create_time": 1743881519, "schema_version": 1, "max_context_tokens": 10000000, "max_completion_tokens": 16384, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('619cd3b4-0dee-4303-835b-a24cfa014392', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen3-30b-a3b', NULL, true, '2026-05-06 08:32:19.669712+00', '2026-07-10 09:00:22.56942+00', '{"tag": "", "prompt": 0.00000012, "completion": 0.0000005, "create_time": 1745878604, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 16384, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('8ede105b-804b-4672-9721-8e77375a8364', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3-14b', NULL, true, '2026-05-19 17:03:54.428498+00', '2026-07-10 09:00:22.617786+00', '{"tag": "", "prompt": 0.0000001, "completion": 0.00000024, "create_time": 1745876478, "schema_version": 1, "max_context_tokens": 131702, "max_completion_tokens": 40960, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('e9633ccb-83ee-448a-9f66-32d5eb077521', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3-32b', NULL, true, '2026-05-19 17:03:54.507628+00', '2026-07-10 09:00:22.647545+00', '{"tag": "", "prompt": 0.00000008, "completion": 0.00000028, "create_time": 1745875945, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 16384, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('ed84da3e-f951-4e34-8533-436ee7385d34', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-4.1-mini', NULL, true, '2026-05-06 08:32:19.774595+00', '2026-07-10 09:00:22.704533+00', '{"tag": "", "prompt": 0.0000004, "completion": 0.0000016, "web_search": 0.01, "create_time": 1744651381, "schema_version": 1, "input_cache_read": 0.0000001, "max_context_tokens": 1047576, "max_completion_tokens": 32768, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('36b3fa07-dbd3-408d-af72-25004d3b900a', '64647d14-f1cd-4965-926c-476e20bcb1c3', 'llama-4-maverick', NULL, true, '2026-05-06 08:32:19.820553+00', '2026-07-10 09:00:22.719041+00', '{"tag": "", "prompt": 0.00000015, "completion": 0.0000006, "create_time": 1743881822, "schema_version": 1, "max_context_tokens": 1048576, "max_completion_tokens": 16384, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('328e37f6-0ecf-4412-b7cf-9bd57b7bee69', '493b150e-48c0-4fd4-9866-56bd3d915c46', 'deepseek-chat-v3-0324', NULL, true, '2026-05-06 08:32:19.843274+00', '2026-07-10 09:00:22.734652+00', '{"tag": "", "prompt": 0.00000024, "completion": 0.0000009, "create_time": 1742824755, "schema_version": 1, "input_cache_read": 0.000000135, "max_context_tokens": 163840, "max_completion_tokens": 16384, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('0dadee1c-c0da-4211-bd66-b69d31c5a887', '004533f3-71af-47b3-a4b4-9dcd2eeff9b8', 'mistral-small-3.1-24b-instruct', NULL, true, '2026-05-06 08:32:19.865937+00', '2026-07-10 09:00:22.748949+00', '{"tag": "", "prompt": 0.000000351, "completion": 0.000000555, "create_time": 1742238937, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('d79f75fc-b985-41fa-8528-683d693ea379', 'fee873f7-15b7-4809-b9ba-2737224b15ed', 'coder-large', NULL, true, '2026-05-06 08:32:19.648168+00', '2026-07-10 09:00:22.555286+00', '{"tag": "", "prompt": 0.0000005, "completion": 0.0000008, "create_time": 1746478663, "schema_version": 1, "max_context_tokens": 32768, "max_completion_tokens": null, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('ef716329-c9eb-4b9b-85a6-4ecdff17274a', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen3-14b', NULL, true, '2026-05-19 17:03:54.454591+00', '2026-07-10 09:00:22.625139+00', '{"tag": "", "prompt": 0.0000001, "completion": 0.00000024, "create_time": 1745876478, "schema_version": 1, "max_context_tokens": 131702, "max_completion_tokens": 40960, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('3fa1ee09-6aa8-45e8-b113-9f298ae8100a', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen3-235b-a22b', NULL, true, '2026-05-19 17:03:54.534896+00', '2026-07-10 09:00:22.661474+00', '{"tag": "", "prompt": 0.000000455, "completion": 0.00000182, "create_time": 1745875757, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 8192, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('53e1bc23-4cc9-4610-a2f1-b28e38312942', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen2.5-vl-72b-instruct', NULL, true, '2026-05-19 17:03:55.076883+00', '2026-07-10 09:00:22.855372+00', '{"tag": "", "prompt": 0.0000008, "completion": 0.000001, "create_time": 1738410311, "schema_version": 1, "input_cache_read": 0.0000004, "max_context_tokens": 131072, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('b804c1f1-c6df-401e-bae4-4cd44e245e43', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemma-3-27b-it', NULL, true, '2026-05-06 08:32:19.946654+00', '2026-07-10 09:00:22.799603+00', '{"tag": "", "prompt": 0.00000008, "completion": 0.00000016, "create_time": 1741756359, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 16384, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('8bfb74e9-e75e-418e-b8f8-274e8b82c809', '1f21a50f-a00a-4669-82d2-ac6d2c05081f', 'sonar-pro', NULL, true, '2026-05-06 08:32:19.969578+00', '2026-07-10 09:00:22.813395+00', '{"tag": "", "prompt": 0.000003, "completion": 0.000015, "web_search": 0.005, "create_time": 1741312423, "schema_version": 1, "max_context_tokens": 200000, "max_completion_tokens": 8000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('aa01df8f-edef-44f6-aea0-d39d3e2612b2', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen-plus', NULL, true, '2026-05-19 17:03:55.149408+00', '2026-07-10 09:00:22.883485+00', '{"tag": "", "prompt": 0.00000026, "completion": 0.00000078, "create_time": 1738409840, "schema_version": 1, "input_cache_read": 0.000000052, "input_cache_write": 0.000000325, "max_context_tokens": 1000000, "max_completion_tokens": 32768, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('5abeff27-c19f-4d77-ba6e-14686053249a', '004533f3-71af-47b3-a4b4-9dcd2eeff9b8', 'mistral-saba', NULL, true, '2026-05-06 08:32:20.02723+00', '2026-07-10 09:00:22.827073+00', '{"tag": "", "prompt": 0.0000002, "completion": 0.0000006, "create_time": 1739803239, "schema_version": 1, "input_cache_read": 0.00000002, "max_context_tokens": 32768, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('9adfcc72-2250-4c32-8136-2e7d3337cac1', '3865ca54-b799-4bb8-b769-9ea883771901', 'aion-rp-llama-3.1-8b', NULL, true, '2026-05-06 08:32:20.109154+00', '2026-07-10 09:00:22.841278+00', '{"tag": "", "prompt": 0.0000008, "completion": 0.0000016, "create_time": 1738696718, "schema_version": 1, "max_context_tokens": 32768, "max_completion_tokens": 32768, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('62abba82-6238-4663-aa78-f1dc8650201d', '47927a94-7043-4921-b67e-8389985f9aab', 'command-a', NULL, true, '2026-05-06 08:32:19.899863+00', '2026-07-10 09:00:22.770584+00', '{"tag": "", "prompt": 0.0000025, "completion": 0.00001, "create_time": 1741894342, "schema_version": 1, "max_context_tokens": 256000, "max_completion_tokens": 8192, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('bce8ac8b-5811-4981-99d0-65ed25ae0912', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen-plus', NULL, true, '2026-05-06 08:32:20.171063+00', '2026-07-10 09:00:22.869263+00', '{"tag": "", "prompt": 0.00000026, "completion": 0.00000078, "create_time": 1738409840, "schema_version": 1, "input_cache_read": 0.000000052, "input_cache_write": 0.000000325, "max_context_tokens": 1000000, "max_completion_tokens": 32768, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('1e070a25-af33-4e5b-87dd-37d283a70e1b', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen2.5-vl-72b-instruct', NULL, true, '2026-05-19 17:03:55.099113+00', '2026-07-10 09:00:22.862451+00', '{"tag": "", "prompt": 0.0000008, "completion": 0.000001, "create_time": 1738410311, "schema_version": 1, "input_cache_read": 0.0000004, "max_context_tokens": 131072, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('f417b4c0-916a-4601-a0e1-4e36c4ffc785', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemma-3-12b-it', NULL, true, '2026-05-06 08:32:19.888847+00', '2026-07-10 09:00:22.763438+00', '{"tag": "", "prompt": 0.00000005, "completion": 0.00000015, "create_time": 1741902625, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 16384, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('8ac67330-1913-4587-a8a7-259dfb4cd6fc', 'fddcd474-2972-4c83-aefa-3403ab2e386c', 'reka-flash-3', NULL, true, '2026-05-06 08:32:19.934842+00', '2026-07-10 09:00:22.792459+00', '{"tag": "", "prompt": 0.0000001, "completion": 0.0000002, "create_time": 1741812813, "schema_version": 1, "max_context_tokens": 65536, "max_completion_tokens": 65536, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('767b40f5-01d2-4474-aa7c-fee089ef88fa', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'o3-mini-high', NULL, true, '2026-05-06 08:32:20.050835+00', '2026-07-10 09:00:22.83423+00', '{"tag": "", "prompt": 0.0000011, "completion": 0.0000044, "web_search": 0.01, "create_time": 1739372611, "schema_version": 1, "input_cache_read": 0.00000055, "max_context_tokens": 200000, "max_completion_tokens": 100000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('0f6adb8b-7580-4e0a-b8f3-7a6f0315b1ef', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen2.5-vl-72b-instruct', NULL, true, '2026-05-06 08:32:20.155678+00', '2026-07-10 09:00:22.848357+00', '{"tag": "", "prompt": 0.0000008, "completion": 0.000001, "create_time": 1738410311, "schema_version": 1, "input_cache_read": 0.0000004, "max_context_tokens": 131072, "max_completion_tokens": 128000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('432b132d-7e9c-4198-b8fc-65cb92603a55', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen-plus', NULL, true, '2026-05-19 17:03:55.12477+00', '2026-07-10 09:00:22.876224+00', '{"tag": "", "prompt": 0.00000026, "completion": 0.00000078, "create_time": 1738409840, "schema_version": 1, "input_cache_read": 0.000000052, "input_cache_write": 0.000000325, "max_context_tokens": 1000000, "max_completion_tokens": 32768, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('d823796c-e8a8-4b0d-b452-b59cb944ad42', '3865ca54-b799-4bb8-b769-9ea883771901', 'aion-1.0-mini', NULL, false, '2026-05-06 08:32:20.097546+00', '2026-07-08 13:38:40.187399+00', '{"tag": "", "prompt": 0.0000007, "completion": 0.0000014, "create_time": 1738697107, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 32768, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('0d38acad-263a-4ac6-b612-adfe0256ea9f', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'o3-mini', NULL, true, '2026-05-06 08:32:20.197647+00', '2026-07-10 09:00:22.890211+00', '{"tag": "", "prompt": 0.0000011, "completion": 0.0000044, "web_search": 0.01, "create_time": 1738351721, "schema_version": 1, "input_cache_read": 0.00000055, "max_context_tokens": 200000, "max_completion_tokens": 100000, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('068011a6-5a59-43fa-a9e5-3e94ffb150e7', '1f21a50f-a00a-4669-82d2-ac6d2c05081f', 'sonar-reasoning-pro', NULL, true, '2026-05-06 08:32:19.957735+00', '2026-07-10 09:00:22.806271+00', '{"tag": "", "prompt": 0.000002, "completion": 0.000008, "web_search": 0.005, "create_time": 1741313308, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('003b6d68-0b37-497f-a148-c7e3b578d358', '1f21a50f-a00a-4669-82d2-ac6d2c05081f', 'sonar-deep-research', NULL, true, '2026-05-06 08:32:19.98119+00', '2026-07-10 09:00:22.820292+00', '{"tag": "", "prompt": 0.000002, "completion": 0.000008, "web_search": 0.005, "create_time": 1741311246, "schema_version": 1, "internal_reasoning": 0.000003, "max_context_tokens": 128000, "max_completion_tokens": null, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('218323b6-a4b3-4512-8d02-8b5bf92a0dc3', 'ec126a88-8820-4ab3-ba63-7cd1c1b1aaf2', 'minimax-01', NULL, true, '2026-05-19 17:03:55.265152+00', '2026-07-10 09:00:22.932811+00', '{"tag": "", "prompt": 0.0000002, "completion": 0.0000011, "create_time": 1736915462, "schema_version": 1, "max_context_tokens": 1000192, "max_completion_tokens": 1000192, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('b67445ac-d6c4-4244-a9aa-3c63086d1dd4', '493b150e-48c0-4fd4-9866-56bd3d915c46', 'deepseek-chat', NULL, true, '2026-05-06 08:32:20.298158+00', '2026-07-10 09:00:22.946681+00', '{"tag": "", "prompt": 0.0000002002, "completion": 0.0000008001, "create_time": 1735241320, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 16000, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('d27c09e9-ea57-44d8-b2c6-72a7be687552', '47927a94-7043-4921-b67e-8389985f9aab', 'command-r7b-12-2024', NULL, true, '2026-05-06 08:32:20.321677+00', '2026-07-10 09:00:22.96074+00', '{"tag": "", "prompt": 0.0000000375, "completion": 0.00000015, "create_time": 1734158152, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": 4000, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('5764ae63-0ccd-4dec-b495-28fab17add84', '493b150e-48c0-4fd4-9866-56bd3d915c46', 'deepseek-r1', NULL, true, '2026-05-06 08:32:20.25974+00', '2026-07-10 09:00:22.918699+00', '{"tag": "", "prompt": 0.0000007, "completion": 0.0000025, "create_time": 1737381095, "schema_version": 1, "max_context_tokens": 163840, "max_completion_tokens": 16000, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('b50eef3c-5421-4b61-8d02-2492ed4e6060', '64647d14-f1cd-4965-926c-476e20bcb1c3', 'llama-3.3-70b-instruct:free', NULL, true, '2026-06-07 15:16:17.275187+00', '2026-07-10 09:00:22.96797+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1733506137, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": null, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('2077b9bd-645f-4168-9158-738c815d87dd', '64647d14-f1cd-4965-926c-476e20bcb1c3', 'llama-3.3-70b-instruct', NULL, true, '2026-05-06 08:32:20.339569+00', '2026-07-10 09:00:22.975335+00', '{"tag": "", "prompt": 0.0000001, "completion": 0.00000032, "create_time": 1733506137, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 16384, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('3b29fc89-21bb-4f82-a23f-bcd810ee13ea', '680a6550-c76c-44d2-b9c4-1d1022880732', 'nova-lite-v1', NULL, true, '2026-05-06 08:32:20.351001+00', '2026-07-10 09:00:22.982175+00', '{"tag": "", "prompt": 0.00000006, "completion": 0.00000024, "create_time": 1733437363, "schema_version": 1, "max_context_tokens": 300000, "max_completion_tokens": 5120, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('5f5000be-04c0-4701-a187-af595db66060', '680a6550-c76c-44d2-b9c4-1d1022880732', 'nova-micro-v1', NULL, true, '2026-05-06 08:32:20.362197+00', '2026-07-10 09:00:22.989093+00', '{"tag": "", "prompt": 0.000000035, "completion": 0.00000014, "create_time": 1733437237, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": 5120, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('0c12dd01-ff6a-4c5f-b01d-cd682de8533c', '680a6550-c76c-44d2-b9c4-1d1022880732', 'nova-pro-v1', NULL, true, '2026-05-06 08:32:20.373548+00', '2026-07-10 09:00:22.996516+00', '{"tag": "", "prompt": 0.0000008, "completion": 0.0000032, "create_time": 1733436303, "schema_version": 1, "max_context_tokens": 300000, "max_completion_tokens": 5120, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('07819dd4-f5ab-4d66-81ec-7268e336dc1c', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-4o-2024-11-20', NULL, true, '2026-05-06 08:32:20.383461+00', '2026-07-10 09:00:23.003431+00', '{"tag": "", "prompt": 0.0000025, "completion": 0.00001, "create_time": 1732127594, "schema_version": 1, "input_cache_read": 0.00000125, "max_context_tokens": 128000, "max_completion_tokens": 16384, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('51aa5fff-4d59-4659-b3a6-69e2634014bc', '004533f3-71af-47b3-a4b4-9dcd2eeff9b8', 'mistral-large-2407', NULL, true, '2026-05-06 08:32:20.408082+00', '2026-07-10 09:00:23.010216+00', '{"tag": "", "prompt": 0.000002, "completion": 0.000006, "create_time": 1731978415, "schema_version": 1, "input_cache_read": 0.0000002, "max_context_tokens": 131072, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('70288593-1130-437a-bbb3-36bc875fc545', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen-2.5-coder-32b-instruct', NULL, true, '2026-05-19 17:03:55.470706+00', '2026-07-10 09:00:23.024641+00', '{"tag": "", "prompt": 0.00000066, "completion": 0.000001, "create_time": 1731368400, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": 32768, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('1cd8f7b5-9f0b-4d0c-8b06-5bba424e47e1', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen-2.5-7b-instruct', NULL, true, '2026-05-06 08:32:20.454431+00', '2026-07-10 09:00:23.038209+00', '{"tag": "", "prompt": 0.00000004, "completion": 0.0000001, "create_time": 1729036800, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 32768, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('5b7dc810-06b9-4788-9d44-bbb86544ae0c', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen-2.5-7b-instruct', NULL, true, '2026-05-19 17:03:55.530372+00', '2026-07-10 09:00:23.045012+00', '{"tag": "", "prompt": 0.00000004, "completion": 0.0000001, "create_time": 1729036800, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 32768, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('7d5a6e23-c872-4cf2-a29b-379661671c6e', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen-2.5-7b-instruct', NULL, true, '2026-05-19 17:03:55.545815+00', '2026-07-10 09:00:23.05248+00', '{"tag": "", "prompt": 0.00000004, "completion": 0.0000001, "create_time": 1729036800, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 32768, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('0d30ee80-e3bc-43bb-b645-7568f2dfb389', '1f21a50f-a00a-4669-82d2-ac6d2c05081f', 'sonar', NULL, true, '2026-05-06 08:32:20.234586+00', '2026-07-10 09:00:22.904089+00', '{"tag": "", "prompt": 0.000001, "completion": 0.000001, "web_search": 0.005, "create_time": 1738013808, "schema_version": 1, "max_context_tokens": 127072, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('5a966222-6838-47af-808c-c0155e12e45b', '493b150e-48c0-4fd4-9866-56bd3d915c46', 'deepseek-r1-distill-llama-70b', NULL, true, '2026-05-06 08:32:20.246081+00', '2026-07-10 09:00:22.91145+00', '{"tag": "", "prompt": 0.0000008, "completion": 0.0000008, "create_time": 1737663169, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": 8192, "model_interaction_type": "reasoning"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('4e2ed66d-e01b-4433-92b1-5425171a120f', '2810aca3-c2e5-426d-a8c8-2bddc1ff480d', 'minimax-01', NULL, true, '2026-05-06 08:32:20.272241+00', '2026-07-10 09:00:22.925786+00', '{"tag": "", "prompt": 0.0000002, "completion": 0.0000011, "create_time": 1736915462, "schema_version": 1, "max_context_tokens": 1000192, "max_completion_tokens": 1000192, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('226ca128-27c7-4b71-a1f5-59a4170e052a', 'd63d8b65-111d-4030-900c-a7b439c9473a', 'phi-4', NULL, true, '2026-05-06 08:32:20.288977+00', '2026-07-10 09:00:22.939672+00', '{"tag": "Latest", "prompt": 0.00000007, "completion": 0.00000014, "create_time": 1736489872, "schema_version": 1, "max_context_tokens": 16384, "max_completion_tokens": 16384, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('5f289dcc-efe2-4a23-8266-bebf49d9f65e', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen-2.5-coder-32b-instruct', NULL, true, '2026-05-06 08:32:20.431208+00', '2026-07-10 09:00:23.017331+00', '{"tag": "", "prompt": 0.00000066, "completion": 0.000001, "create_time": 1731368400, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": 32768, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('4f2591e7-ba6e-4967-ba8d-e4dba2d7a369', '64647d14-f1cd-4965-926c-476e20bcb1c3', 'llama-3.1-8b-instruct', NULL, true, '2026-05-06 08:32:20.621476+00', '2026-07-10 09:00:23.182054+00', '{"tag": "", "prompt": 0.00000002, "completion": 0.00000003, "create_time": 1721692800, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 16384, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('f3cc7433-bdfd-46f3-8c96-4c1472589acb', '64647d14-f1cd-4965-926c-476e20bcb1c3', 'llama-3.2-1b-instruct', NULL, true, '2026-05-06 08:32:20.520848+00', '2026-07-10 09:00:23.073934+00', '{"tag": "", "prompt": 0.000000027, "completion": 0.000000201, "create_time": 1727222400, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 60000, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('8d85c74c-dc6b-40a4-a9c7-2b386449c69e', 'e0f8fc91-72da-4009-8c8a-46c52f144bef', 'qwen-2.5-72b-instruct', NULL, true, '2026-05-06 08:32:20.544415+00', '2026-07-10 09:00:23.102247+00', '{"tag": "", "prompt": 0.00000036, "completion": 0.0000004, "create_time": 1726704000, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 16384, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('4545e8b8-b648-46a5-89e4-73ce7d513b50', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-4o-mini', NULL, true, '2026-05-06 08:32:20.669519+00', '2026-07-10 09:00:23.210062+00', '{"tag": "", "prompt": 0.00000015, "completion": 0.0000006, "create_time": 1721260800, "schema_version": 1, "input_cache_read": 0.000000075, "max_context_tokens": 128000, "max_completion_tokens": 16384, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('a29f3b86-3bd8-409d-8d04-2e9aded54eea', '64647d14-f1cd-4965-926c-476e20bcb1c3', 'llama-3.2-11b-vision-instruct', NULL, true, '2026-05-06 08:32:20.533026+00', '2026-07-10 09:00:23.08098+00', '{"tag": "", "prompt": 0.000000345, "completion": 0.000000345, "create_time": 1727222400, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 16384, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('67589e7d-31d1-4d08-8143-92800eefb9cd', 'ade284c2-0774-4471-b455-1810cd5375b5', 'qwen-2.5-72b-instruct', NULL, true, '2026-05-19 17:03:55.643862+00', '2026-07-10 09:00:23.109249+00', '{"tag": "", "prompt": 0.00000036, "completion": 0.0000004, "create_time": 1726704000, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 16384, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('2b630755-3503-430b-b84a-748e6b0eaf94', '64647d14-f1cd-4965-926c-476e20bcb1c3', 'llama-3.1-70b-instruct', NULL, true, '2026-05-06 08:32:20.633279+00', '2026-07-10 09:00:23.189067+00', '{"tag": "", "prompt": 0.0000004, "completion": 0.0000004, "create_time": 1721692800, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 16384, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('4dadd268-3baf-4ef4-b3f1-90415ad40b7b', '9f5cef8f-06f8-4500-8091-e046a5d4c384', 'gemma-2-27b-it', NULL, true, '2026-05-06 08:32:20.681377+00', '2026-07-10 09:00:23.217351+00', '{"tag": "", "prompt": 0.00000065, "completion": 0.00000065, "create_time": 1720828800, "schema_version": 1, "max_context_tokens": 8192, "max_completion_tokens": 2048, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('cad12e8e-1e00-4187-a170-ff460f0dc9b4', '9db42d7c-fcba-428d-bb68-0eca31f8bc34', 'qwen-2.5-72b-instruct', NULL, true, '2026-05-19 17:03:55.657845+00', '2026-07-10 09:00:23.118031+00', '{"tag": "", "prompt": 0.00000036, "completion": 0.0000004, "create_time": 1726704000, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 16384, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('fd6257a9-1456-4d0e-b09c-77b197ba0c05', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-4o-2024-05-13', NULL, true, '2026-05-06 08:32:20.704556+00', '2026-07-10 09:00:23.224364+00', '{"tag": "", "prompt": 0.000005, "completion": 0.000015, "create_time": 1715558400, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": 4096, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('23b3631b-a4b8-4507-85bc-8168076360c0', '64647d14-f1cd-4965-926c-476e20bcb1c3', 'llama-3.2-3b-instruct:free', NULL, true, '2026-06-07 15:16:17.374356+00', '2026-07-10 09:00:23.088431+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1727222400, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": null, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('7d7ab7f0-8da8-4088-9cbf-060ff7e658a4', '004533f3-71af-47b3-a4b4-9dcd2eeff9b8', 'mistral-nemo', NULL, true, '2026-05-06 08:32:20.645657+00', '2026-07-10 09:00:23.19604+00', '{"tag": "", "prompt": 0.00000002, "completion": 0.00000003, "create_time": 1721347200, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": null, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('cd750599-86cd-421e-8330-8faffdacd7da', '47927a94-7043-4921-b67e-8389985f9aab', 'command-r-08-2024', NULL, true, '2026-05-06 08:32:20.569581+00', '2026-07-10 09:00:23.132269+00', '{"tag": "", "prompt": 0.00000015, "completion": 0.0000006, "create_time": 1724976000, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": 4000, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('ff6c02f8-8e34-464f-9168-3adf184a6df5', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-4o', NULL, true, '2026-05-06 08:32:20.716156+00', '2026-07-10 09:00:23.23181+00', '{"tag": "", "prompt": 0.0000025, "completion": 0.00001, "create_time": 1715558400, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": 16384, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('3d383a20-bdf5-4b7b-b6b9-849ffbee92b2', '64647d14-f1cd-4965-926c-476e20bcb1c3', 'llama-3.2-3b-instruct', NULL, true, '2026-05-06 08:32:20.508762+00', '2026-07-10 09:00:23.095464+00', '{"tag": "", "prompt": 0.00000005, "completion": 0.00000033, "create_time": 1727222400, "schema_version": 1, "max_context_tokens": 131072, "max_completion_tokens": 131072, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('8cad1c7e-d98e-4ee0-9ea2-8855dd830c19', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-4o-mini-2024-07-18', NULL, true, '2026-05-06 08:32:20.657576+00', '2026-07-10 09:00:23.203102+00', '{"tag": "", "prompt": 0.00000015, "completion": 0.0000006, "create_time": 1721260800, "schema_version": 1, "input_cache_read": 0.000000075, "max_context_tokens": 128000, "max_completion_tokens": 16384, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('140c7de8-8a6e-44ca-8fc5-fce33ce879b3', '036cfc6e-0a26-4786-b7b6-7a5739ea6d5b', 'inflection-3-productivity', NULL, true, '2026-05-06 08:32:20.47918+00', '2026-07-10 09:00:23.059603+00', '{"tag": "Latest", "prompt": 0.0000025, "completion": 0.00001, "create_time": 1728604800, "schema_version": 1, "max_context_tokens": 8000, "max_completion_tokens": 1024, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('112ded97-951a-46b7-a456-a9863426afc5', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-4-turbo', NULL, true, '2026-05-06 08:32:20.773377+00', '2026-07-10 09:00:23.260293+00', '{"tag": "", "prompt": 0.00001, "completion": 0.00003, "create_time": 1712620800, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": 4096, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('beeec2ad-c24e-43dc-bfe2-a9d5018b365c', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-3.5-turbo-16k', NULL, true, '2026-05-06 08:32:20.885166+00', '2026-07-10 09:00:23.310477+00', '{"tag": "", "prompt": 0.000003, "completion": 0.000004, "create_time": 1693180800, "schema_version": 1, "max_context_tokens": 16385, "max_completion_tokens": 4096, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('374b0ba6-697b-4c03-8ba0-86c20f8c09c6', 'bb05b8a1-9856-4ac2-bcdd-2c132e94e795', 'weaver', NULL, true, '2026-05-06 08:32:20.896865+00', '2026-07-10 09:00:23.317396+00', '{"tag": "Latest", "prompt": 0.00000075, "completion": 0.000001, "create_time": 1690934400, "schema_version": 1, "max_context_tokens": 8000, "max_completion_tokens": 2000, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('7dad389d-f3ee-4d30-89d0-104f5e6e6ce6', '09b94796-8f59-4775-976b-ee85a5a6d927', 'claude-3-haiku', NULL, true, '2026-05-06 08:32:20.784599+00', '2026-07-10 09:00:23.267845+00', '{"tag": "", "prompt": 0.00000025, "completion": 0.00000125, "web_search": 0.01, "create_time": 1710288000, "schema_version": 1, "input_cache_read": 0.00000003, "input_cache_write": 0.0000003, "max_context_tokens": 200000, "input_cache_write_1h": 0.0000005, "max_completion_tokens": 4096, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('523830ce-590c-4707-bd4e-e400661688ef', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-4', NULL, true, '2026-05-06 08:32:20.920626+00', '2026-07-10 09:00:23.324574+00', '{"tag": "", "prompt": 0.00003, "completion": 0.00006, "create_time": 1685232000, "schema_version": 1, "max_context_tokens": 8191, "max_completion_tokens": 4096, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('72c53493-99d7-451c-81af-8daab1e47681', '004533f3-71af-47b3-a4b4-9dcd2eeff9b8', 'mistral-large', NULL, true, '2026-05-06 08:32:20.795888+00', '2026-07-10 09:00:23.275326+00', '{"tag": "", "prompt": 0.000002, "completion": 0.000006, "create_time": 1708905600, "schema_version": 1, "input_cache_read": 0.0000002, "max_context_tokens": 128000, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('5d44ed64-367f-4c70-a515-d02ab3c5c5d0', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-3.5-turbo-0613', NULL, true, '2026-05-06 08:32:20.818602+00', '2026-07-10 09:00:23.282569+00', '{"tag": "", "prompt": 0.000001, "completion": 0.000002, "create_time": 1706140800, "schema_version": 1, "max_context_tokens": 4095, "max_completion_tokens": 4096, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('75edf1f9-7842-44c6-8f2f-504fbe11eb5c', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-3.5-turbo', NULL, true, '2026-05-06 08:32:20.931784+00', '2026-07-10 09:00:23.332106+00', '{"tag": "", "prompt": 0.0000005, "completion": 0.0000015, "create_time": 1685232000, "schema_version": 1, "max_context_tokens": 16385, "max_completion_tokens": 4096, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('b888fc9a-2cb8-4618-ab8e-dbd4ffa28d48', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-4-turbo-preview', NULL, true, '2026-05-06 08:32:20.807371+00', '2026-07-10 09:00:23.289703+00', '{"tag": "", "prompt": 0.00001, "completion": 0.00003, "create_time": 1706140800, "schema_version": 1, "max_context_tokens": 128000, "max_completion_tokens": 4096, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('3afcdff9-4d54-48f3-a06a-d78602af04c7', '64647d14-f1cd-4965-926c-476e20bcb1c3', 'llama-3-8b-instruct', NULL, true, '2026-05-06 08:32:20.727675+00', '2026-07-10 09:00:23.238615+00', '{"tag": "", "prompt": 0.00000014, "completion": 0.00000014, "create_time": 1713398400, "schema_version": 1, "max_context_tokens": 8192, "max_completion_tokens": null, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('92689d4b-efcd-4b25-8161-38d2d81eee84', '004533f3-71af-47b3-a4b4-9dcd2eeff9b8', 'mixtral-8x22b-instruct', NULL, true, '2026-05-06 08:32:20.750825+00', '2026-07-10 09:00:23.245812+00', '{"tag": "", "prompt": 0.000002, "completion": 0.000006, "create_time": 1713312000, "schema_version": 1, "input_cache_read": 0.0000002, "max_context_tokens": 65536, "max_completion_tokens": null, "model_interaction_type": "multimodal"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('db7109e1-209e-42f8-9bc9-2a7e26a74ea6', '2be846df-8b85-4d9e-b94e-3f0c5cc3d223', 'auto', NULL, true, '2026-06-07 15:16:17.551224+00', '2026-07-10 09:00:23.296664+00', '{"tag": "", "prompt": 0, "completion": 0, "create_time": 1699401600, "schema_version": 1, "max_context_tokens": 2000000, "max_completion_tokens": null, "model_interaction_type": "image"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('bcaa4d39-9cf7-41e6-a8cd-3d32fb9a9809', 'adc9aced-1855-42e4-bbed-916b90e7d6b6', 'gpt-3.5-turbo-instruct', NULL, true, '2026-05-06 08:32:20.86255+00', '2026-07-10 09:00:23.303494+00', '{"tag": "", "prompt": 0.0000015, "completion": 0.000002, "create_time": 1695859200, "schema_version": 1, "max_context_tokens": 4095, "max_completion_tokens": 4096, "model_interaction_type": "chat"}');
INSERT INTO public.provider_models (id, provider_id, model_id, display_name, enabled, created_at, updated_at, info) VALUES ('b2e88033-35c0-40aa-b873-6bd30aa97ea2', 'd63d8b65-111d-4030-900c-a7b439c9473a', 'wizardlm-2-8x22b', NULL, true, '2026-05-06 08:32:20.762071+00', '2026-07-10 09:00:23.253235+00', '{"tag": "", "prompt": 0.00000062, "completion": 0.00000062, "create_time": 1713225600, "schema_version": 1, "max_context_tokens": 65536, "max_completion_tokens": 8000, "model_interaction_type": "chat"}');



--
-- PostgreSQL database dump complete
--

\unrestrict b5n4ijRYtgdDoXrJNkjxGVAsnNiqUwz57yWAn8bnd3v1F6eZiXwvvmj5dvKM5MR

