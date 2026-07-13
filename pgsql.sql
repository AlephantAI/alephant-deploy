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

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: agent_environment_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.agent_environment_enum AS ENUM (
    'production',
    'development',
    'staging'
);


--
-- Name: agent_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.agent_status_enum AS ENUM (
    'active',
    'inactive',
    'archived'
);


--
-- Name: alert_severity_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.alert_severity_enum AS ENUM (
    'high',
    'medium',
    'low'
);


--
-- Name: alert_source_kind_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.alert_source_kind_enum AS ENUM (
    'workspace',
    'department',
    'agent',
    'member'
);


--
-- Name: alert_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.alert_status_enum AS ENUM (
    'active',
    'acknowledged',
    'resolved'
);


--
-- Name: alert_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.alert_type_enum AS ENUM (
    'budget_threshold',
    'budget_exceeded',
    'usage_anomaly',
    'error_rate',
    'quota_approaching',
    'quota_exceeded',
    'operational'
);


--
-- Name: api_key_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.api_key_status_enum AS ENUM (
    'active',
    'inactive',
    'error',
    'revoked'
);


--
-- Name: audit_action_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.audit_action_enum AS ENUM (
    'create',
    'update',
    'delete',
    'login',
    'logout',
    'invite',
    'revoke',
    'enable',
    'disable',
    'rotate',
    'export',
    'reactivate',
    'reset-budget',
    'reveal',
    'add-admin',
    'remove-admin',
    'update-admin-role',
    'batch-create',
    'invite-member',
    'remove-member',
    'update-member'
);


--
-- Name: audit_resource_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.audit_resource_enum AS ENUM (
    'workspace',
    'master_key',
    'virtual_key',
    'agent',
    'member',
    'department',
    'subscription',
    'policy',
    'webhook'
);


--
-- Name: billing_period_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.billing_period_enum AS ENUM (
    'monthly',
    'yearly'
);


--
-- Name: department_budget_action_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.department_budget_action_enum AS ENUM (
    'pause_all',
    'alert_only',
    'soft_throttle'
);


--
-- Name: external_endpoint_risk_level; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.external_endpoint_risk_level AS ENUM (
    'low',
    'medium',
    'high'
);


--
-- Name: external_endpoint_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.external_endpoint_status AS ENUM (
    'ACTIVE',
    'PENDING_REVIEW',
    'SUSPENDED',
    'BLOCKED'
);


--
-- Name: invitation_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.invitation_status_enum AS ENUM (
    'pending',
    'accepted',
    'expired',
    'revoked'
);


--
-- Name: invoice_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.invoice_status_enum AS ENUM (
    'draft',
    'open',
    'paid',
    'void',
    'uncollectible'
);


--
-- Name: invoice_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.invoice_type_enum AS ENUM (
    'subscription',
    'overage',
    'vk_expansion',
    'one_time'
);


--
-- Name: key_market_account_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.key_market_account_status_enum AS ENUM (
    'active',
    'restricted',
    'disabled'
);


--
-- Name: key_market_alephant_observability_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.key_market_alephant_observability_status_enum AS ENUM (
    'disabled',
    'pending',
    'active',
    'degraded',
    'error'
);


--
-- Name: key_market_api_key_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.key_market_api_key_status_enum AS ENUM (
    'active',
    'revoked'
);


--
-- Name: key_market_bridge_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.key_market_bridge_status_enum AS ENUM (
    'created',
    'failed',
    'skipped',
    'disabled'
);


--
-- Name: key_market_cdp_deposit_destination_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.key_market_cdp_deposit_destination_status_enum AS ENUM (
    'created',
    'waiting_funds',
    'transfer_seen',
    'confirmed',
    'amount_mismatch',
    'network_mismatch',
    'asset_mismatch',
    'expired',
    'requires_review',
    'payment_seen',
    'review_required',
    'canceled'
);


--
-- Name: key_market_ledger_entry_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.key_market_ledger_entry_type_enum AS ENUM (
    'payment_credit',
    'usage_debit',
    'chargeback_debit',
    'chargeback_reversal',
    'adjustment',
    'reservation_hold',
    'reservation_release',
    'referral_reward',
    'topup_bonus_credit',
    'referral_cashback'
);


--
-- Name: key_market_payment_provider_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.key_market_payment_provider_enum AS ENUM (
    'stripe',
    'coinbase',
    'coinbase_cdp',
    'helio'
);


--
-- Name: key_market_reservation_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.key_market_reservation_status_enum AS ENUM (
    'reserved',
    'committed',
    'released',
    'expired'
);


--
-- Name: key_market_route_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.key_market_route_status_enum AS ENUM (
    'active',
    'paused',
    'disabled'
);


--
-- Name: key_market_topup_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.key_market_topup_status_enum AS ENUM (
    'created',
    'pending_provider',
    'succeeded',
    'failed',
    'canceled',
    'disputed',
    'chargeback_lost',
    'chargeback_reversed',
    'requires_review',
    'expired',
    'payment_review_required'
);


--
-- Name: key_market_upstream_key_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.key_market_upstream_key_status_enum AS ENUM (
    'active',
    'draining',
    'disabled',
    'error'
);


--
-- Name: line_item_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.line_item_type_enum AS ENUM (
    'base_subscription',
    'vk_expansion',
    'log_overage',
    'discount',
    'credit'
);


--
-- Name: log_key_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.log_key_type_enum AS ENUM (
    'agent',
    'member',
    'personal'
);


--
-- Name: member_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.member_status_enum AS ENUM (
    'active',
    'revoked',
    'suspended'
);


--
-- Name: notification_channel_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.notification_channel_enum AS ENUM (
    'in_app',
    'email',
    'webhook'
);


--
-- Name: notification_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.notification_type_enum AS ENUM (
    'alert',
    'notice',
    'system',
    'autotest',
    'billing'
);


--
-- Name: payment_method_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.payment_method_type_enum AS ENUM (
    'card',
    'bank_transfer',
    'invoice'
);


--
-- Name: policy_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.policy_type_enum AS ENUM (
    'rate_limit',
    'model_access',
    'ip_allowlist',
    'content_filter',
    'budget',
    'security',
    'caching',
    'governance',
    'session_policy',
    'session_policy_c1',
    'session_policy_c2',
    'session_policy_c3',
    'session_policy_c4',
    'session_policy_c5',
    'agent_policy'
);


--
-- Name: prompt_binding_entity_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.prompt_binding_entity_enum AS ENUM (
    'agent',
    'virtual_key',
    'member'
);


--
-- Name: prompt_role_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.prompt_role_enum AS ENUM (
    'system',
    'user',
    'assistant'
);


--
-- Name: prompt_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.prompt_status_enum AS ENUM (
    'draft',
    'production',
    'archived'
);


--
-- Name: prompt_var_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.prompt_var_type_enum AS ENUM (
    'string',
    'number',
    'json'
);


--
-- Name: subscription_event_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.subscription_event_type_enum AS ENUM (
    'created',
    'upgraded',
    'downgraded',
    'renewed',
    'canceled',
    'trial_started',
    'trial_ended',
    'payment_failed',
    'payment_succeeded'
);


--
-- Name: subscription_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.subscription_status_enum AS ENUM (
    'active',
    'trialing',
    'past_due',
    'canceled',
    'expired'
);


--
-- Name: subscription_tier_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.subscription_tier_enum AS ENUM (
    'free',
    'pro',
    'team',
    'enterprise',
    'contact'
);


--
-- Name: virtual_key_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.virtual_key_status_enum AS ENUM (
    'active',
    'disabled',
    'expired',
    'revoked'
);


--
-- Name: vk_budget_action_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.vk_budget_action_enum AS ENUM (
    'alert_only',
    'disable_key',
    'block_requests'
);


--
-- Name: vk_budget_window_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.vk_budget_window_enum AS ENUM (
    'daily',
    'weekly',
    'monthly'
);


--
-- Name: vk_disabled_by_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.vk_disabled_by_enum AS ENUM (
    'manual',
    'master_key_cascade'
);


--
-- Name: vk_entity_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.vk_entity_type_enum AS ENUM (
    'agent',
    'member'
);


--
-- Name: vk_expiry_preset_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.vk_expiry_preset_enum AS ENUM (
    'never',
    '7d',
    '30d',
    '90d',
    'custom'
);


--
-- Name: workspace_member_role_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.workspace_member_role_enum AS ENUM (
    'owner',
    'admin',
    'billing_admin',
    'viewer',
    'member'
);


--
-- Name: workspace_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.workspace_type_enum AS ENUM (
    'personal',
    'team',
    'enterprise'
);


--
-- Name: x402_asset_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.x402_asset_enum AS ENUM (
    'USDC'
);


--
-- Name: x402_cache_billing_mode_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.x402_cache_billing_mode_enum AS ENUM (
    'disabled',
    'free_hit',
    'discounted_hit',
    'charge_hit'
);


--
-- Name: x402_direction_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.x402_direction_enum AS ENUM (
    'inbound',
    'outbound'
);


--
-- Name: x402_endpoint_secret_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.x402_endpoint_secret_status_enum AS ENUM (
    'active',
    'revoked'
);


--
-- Name: x402_endpoint_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.x402_endpoint_status_enum AS ENUM (
    'draft',
    'active',
    'paused',
    'error'
);


--
-- Name: x402_endpoint_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.x402_endpoint_type_enum AS ENUM (
    'agent',
    'http_api',
    'n8n_workflow'
);


--
-- Name: x402_http_method_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.x402_http_method_enum AS ENUM (
    'GET',
    'POST',
    'PUT',
    'PATCH',
    'DELETE'
);


--
-- Name: x402_ledger_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.x402_ledger_status_enum AS ENUM (
    'pending_credit',
    'credited',
    'credit_failed',
    'reversed'
);


--
-- Name: x402_market_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.x402_market_status_enum AS ENUM (
    'not_listed',
    'pending',
    'listed',
    'partial',
    'failed'
);


--
-- Name: x402_network_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.x402_network_enum AS ENUM (
    'base',
    'solana',
    'polygon',
    'base-sepolia',
    'solana-devnet'
);


--
-- Name: x402_outbound_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.x402_outbound_status_enum AS ENUM (
    'pending',
    'settled',
    'blocked',
    'failed',
    'pending_chain'
);


--
-- Name: x402_payment_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.x402_payment_status_enum AS ENUM (
    'required',
    'submitted',
    'verified',
    'failed'
);


--
-- Name: x402_payout_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.x402_payout_status_enum AS ENUM (
    'requested',
    'approved',
    'submitted',
    'confirmed',
    'skipped',
    'failed',
    'cancelled'
);


--
-- Name: x402_platform_wallet_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.x402_platform_wallet_status_enum AS ENUM (
    'active',
    'rotated',
    'disabled',
    'failed'
);


--
-- Name: x402_pricing_model_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.x402_pricing_model_enum AS ENUM (
    'per_call',
    'session_pass',
    'prepaid_bundle',
    'upto'
);


--
-- Name: x402_service_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.x402_service_status_enum AS ENUM (
    'not_started',
    'running',
    'succeeded',
    'failed'
);


--
-- Name: x402_settlement_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.x402_settlement_status_enum AS ENUM (
    'pending',
    'settled',
    'failed',
    'reversed'
);


--
-- Name: x402_split_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.x402_split_status_enum AS ENUM (
    'pending_chain',
    'split_confirmed',
    'split_failed',
    'reversed'
);


--
-- Name: x402_split_treasury_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.x402_split_treasury_status_enum AS ENUM (
    'pending_deploy',
    'active',
    'rotated',
    'disabled',
    'failed'
);


--
-- Name: x402_sweep_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.x402_sweep_status_enum AS ENUM (
    'quoted',
    'submitted',
    'confirmed',
    'skipped',
    'failed'
);


--
-- Name: x402_wallet_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.x402_wallet_status_enum AS ENUM (
    'active',
    'disabled'
);


--
-- Name: x402_wallet_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.x402_wallet_type_enum AS ENUM (
    'external',
    'managed'
);


--
-- Name: x402_wallet_verification_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.x402_wallet_verification_enum AS ENUM (
    'unverified',
    'verified',
    'failed'
);


--
-- Name: fn_set_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


--
-- Name: fn_soft_delete_cascade_vk(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_soft_delete_cascade_vk() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_entity_type vk_entity_type_enum;
BEGIN
  IF OLD.deleted_at IS NOT NULL OR NEW.deleted_at IS NULL THEN
    RETURN NEW;
  END IF;
  IF TG_TABLE_NAME = 'agents' THEN
    v_entity_type := 'agent';
  ELSIF TG_TABLE_NAME = 'members' THEN
    v_entity_type := 'member';
  ELSE
    RETURN NEW;
  END IF;
  UPDATE virtual_keys
  SET status = 'disabled', updated_at = now()
  WHERE entity_type = v_entity_type AND entity_id = NEW.id AND deleted_at IS NULL;
  RETURN NEW;
END;
$$;


--
-- Name: fn_validate_vk_entity(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_validate_vk_entity() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  entity_exists BOOLEAN;
BEGIN
  IF NEW.entity_type IS NULL OR NEW.entity_id IS NULL THEN
    IF NEW.entity_type IS NOT NULL OR NEW.entity_id IS NOT NULL THEN
      RAISE EXCEPTION 'entity_type and entity_id must both be NULL or both be set';
    END IF;
    RETURN NEW;
  END IF;
  IF NEW.entity_type = 'agent' THEN
    SELECT EXISTS(SELECT 1 FROM agents WHERE id = NEW.entity_id AND deleted_at IS NULL) INTO entity_exists;
  ELSIF NEW.entity_type = 'member' THEN
    SELECT EXISTS(SELECT 1 FROM members WHERE id = NEW.entity_id AND deleted_at IS NULL) INTO entity_exists;
  ELSE
    RAISE EXCEPTION 'Unknown entity_type: %', NEW.entity_type;
  END IF;
  IF NOT entity_exists THEN
    RAISE EXCEPTION '% with id % does not exist', NEW.entity_type, NEW.entity_id;
  END IF;
  RETURN NEW;
END;
$$;


--
-- Name: network_protocol_canonical(text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.network_protocol_canonical(input text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
  SELECT CASE lower(trim(input))
    WHEN 'base' THEN 'eip155:8453'
    WHEN 'base-mainnet' THEN 'eip155:8453'
    WHEN '8453' THEN 'eip155:8453'
    WHEN 'eip155-8453' THEN 'eip155:8453'
    WHEN 'eip155:8453' THEN 'eip155:8453'
    WHEN 'base-sepolia' THEN 'eip155:84532'
    WHEN '84532' THEN 'eip155:84532'
    WHEN 'eip155-84532' THEN 'eip155:84532'
    WHEN 'eip155:84532' THEN 'eip155:84532'
    WHEN 'solana-mainnet' THEN 'solana'
    WHEN 'mainnet-beta' THEN 'solana'
    WHEN 'solana' THEN 'solana'
    WHEN 'devnet' THEN 'solana-devnet'
    WHEN 'solana-devnet' THEN 'solana-devnet'
    ELSE trim(input)
  END
$$;


--
-- Name: set_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: active_alerts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_alerts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    rule_id uuid,
    type public.alert_type_enum NOT NULL,
    severity public.alert_severity_enum NOT NULL,
    status public.alert_status_enum DEFAULT 'active'::public.alert_status_enum NOT NULL,
    title character varying(200) NOT NULL,
    message text NOT NULL,
    source_kind public.alert_source_kind_enum,
    source_id uuid,
    source_name character varying(200),
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    acknowledged_at timestamp with time zone,
    acknowledged_by uuid,
    resolved_at timestamp with time zone,
    resolved_by uuid
);


--
-- Name: TABLE active_alerts; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.active_alerts IS 'Active/acknowledged/resolved alerts (14-alerts). Created by backend evaluation jobs; API is read/manage only.';


--
-- Name: agent_allowed_models; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.agent_allowed_models (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    agent_id uuid NOT NULL,
    model_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: agent_policy_bindings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.agent_policy_bindings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    policy_id uuid NOT NULL,
    target_type text NOT NULL,
    target_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT agent_policy_bindings_target_type_check CHECK ((target_type = ANY (ARRAY['workspace'::text, 'department'::text, 'agent'::text]))),
    CONSTRAINT ck_agent_policy_binding_target CHECK ((((target_type = 'workspace'::text) AND (target_id IS NULL)) OR ((target_type = ANY (ARRAY['department'::text, 'agent'::text])) AND (target_id IS NOT NULL))))
);


--
-- Name: agent_runtime_configs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.agent_runtime_configs (
    agent_id uuid NOT NULL,
    workspace_id uuid NOT NULL,
    runtime_type text NOT NULL,
    endpoint_url_ciphertext bytea,
    http_method text DEFAULT 'POST'::text NOT NULL,
    auth_mode text DEFAULT 'none'::text NOT NULL,
    auth_header_name text,
    auth_secret_ciphertext bytea,
    input_format text DEFAULT 'json'::text NOT NULL,
    timeout_ms integer DEFAULT 30000 NOT NULL,
    retry_count integer DEFAULT 0 NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT agent_runtime_configs_auth_mode_check CHECK ((auth_mode = ANY (ARRAY['none'::text, 'bearer'::text, 'header'::text, 'basic'::text]))),
    CONSTRAINT agent_runtime_configs_http_method_check CHECK ((http_method = ANY (ARRAY['GET'::text, 'POST'::text, 'PUT'::text, 'PATCH'::text]))),
    CONSTRAINT agent_runtime_configs_input_format_check CHECK ((input_format = ANY (ARRAY['json'::text, 'form'::text, 'raw'::text]))),
    CONSTRAINT agent_runtime_configs_retry_count_check CHECK ((retry_count >= 0)),
    CONSTRAINT agent_runtime_configs_runtime_type_check CHECK ((runtime_type = ANY (ARRAY['llm_gateway'::text, 'n8n_workflow'::text, 'webhook'::text]))),
    CONSTRAINT agent_runtime_configs_timeout_ms_check CHECK ((timeout_ms > 0)),
    CONSTRAINT ck_agent_runtime_auth_matrix CHECK ((((auth_mode = 'none'::text) AND (auth_secret_ciphertext IS NULL) AND (auth_header_name IS NULL)) OR ((auth_mode = ANY (ARRAY['bearer'::text, 'basic'::text])) AND (auth_secret_ciphertext IS NOT NULL)) OR ((auth_mode = 'header'::text) AND (auth_header_name IS NOT NULL) AND (auth_secret_ciphertext IS NOT NULL)))),
    CONSTRAINT ck_agent_runtime_endpoint_required CHECK (((runtime_type = 'llm_gateway'::text) OR (endpoint_url_ciphertext IS NOT NULL)))
);


--
-- Name: agent_stream_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.agent_stream_keys (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    agent_id uuid NOT NULL,
    label text NOT NULL,
    public_key text NOT NULL,
    secret_hash text NOT NULL,
    secret_suffix character varying(8) DEFAULT ''::character varying NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone,
    revoked_at timestamp with time zone,
    CONSTRAINT agent_stream_keys_status_check CHECK ((status = ANY (ARRAY['active'::text, 'revoked'::text])))
);


--
-- Name: agents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.agents (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    department_id uuid,
    name character varying(100) NOT NULL,
    description text,
    provider_id uuid NOT NULL,
    model_id text NOT NULL,
    environment public.agent_environment_enum DEFAULT 'development'::public.agent_environment_enum NOT NULL,
    system_prompt text,
    status public.agent_status_enum DEFAULT 'active'::public.agent_status_enum NOT NULL,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    about text,
    source text DEFAULT 'manual'::text NOT NULL,
    linked_endpoint_slug text,
    framework text,
    CONSTRAINT agents_source_known_chk CHECK ((source = ANY (ARRAY['manual'::text, 'n8n_workflow'::text, 'custom_webhook'::text])))
);


--
-- Name: alephant_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alephant_settings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    settings jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: alert_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alert_rules (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    type public.alert_type_enum NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    enabled boolean DEFAULT true NOT NULL,
    config jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE alert_rules; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.alert_rules IS 'Alert rule definitions per workspace (14-alerts). Seeded by system; config/name/toggle editable via API.';


--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    actor_id uuid,
    action public.audit_action_enum NOT NULL,
    resource_type public.audit_resource_enum NOT NULL,
    resource_id uuid,
    details jsonb DEFAULT '{}'::jsonb NOT NULL,
    ip_address inet,
    user_agent text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: departments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.departments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    manager_id uuid,
    budget_cents bigint,
    budget_action public.department_budget_action_enum DEFAULT 'alert_only'::public.department_budget_action_enum,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: domain_notification_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.domain_notification_events (
    id bigint NOT NULL,
    event_type text NOT NULL,
    category text NOT NULL,
    workspace_id uuid NOT NULL,
    template_key text NOT NULL,
    payload jsonb DEFAULT '{}'::jsonb NOT NULL,
    idempotency_key text,
    status text NOT NULL,
    attempt_count integer DEFAULT 0 NOT NULL,
    locked_at timestamp with time zone,
    last_error_message text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    processed_at timestamp with time zone,
    CONSTRAINT domain_notification_events_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'processing'::text, 'done'::text, 'dead'::text])))
);


--
-- Name: domain_notification_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.domain_notification_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: domain_notification_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.domain_notification_events_id_seq OWNED BY public.domain_notification_events.id;


--
-- Name: external_endpoints; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.external_endpoints (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    name text NOT NULL,
    domain text NOT NULL,
    url_pattern text NOT NULL,
    method text NOT NULL,
    recipient text DEFAULT ''::text NOT NULL,
    network text DEFAULT ''::text NOT NULL,
    max_price numeric(38,18) DEFAULT 0 NOT NULL,
    status public.external_endpoint_status DEFAULT 'PENDING_REVIEW'::public.external_endpoint_status NOT NULL,
    risk_level public.external_endpoint_risk_level,
    verified_at timestamp with time zone,
    last_verified_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: insights_signal_definition; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.insights_signal_definition (
    signal_id character varying(8) NOT NULL,
    signal_family text NOT NULL,
    veto_cap_role text,
    default_display_name text NOT NULL,
    default_description text,
    default_severity text,
    default_sort_order smallint NOT NULL,
    default_score_weight numeric(6,2) NOT NULL,
    default_enabled boolean DEFAULT true NOT NULL,
    default_ui_meta jsonb DEFAULT '{}'::jsonb NOT NULL,
    is_system boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT insights_signal_definition_id_chk CHECK (((signal_id)::text = ANY ((ARRAY['W1'::character varying, 'W2'::character varying, 'W3'::character varying, 'W4'::character varying, 'W5'::character varying, 'W6'::character varying, 'W7'::character varying, 'W8'::character varying, 'V1'::character varying, 'V2'::character varying, 'V3'::character varying])::text[]))),
    CONSTRAINT insights_signal_definition_signal_family_check CHECK ((signal_family = ANY (ARRAY['waste'::text, 'value'::text]))),
    CONSTRAINT insights_signal_definition_veto_cap_role_check CHECK (((veto_cap_role IS NULL) OR (veto_cap_role = ANY (ARRAY['critical'::text, 'warning'::text])))),
    CONSTRAINT insights_signal_definition_veto_role_chk CHECK (((((signal_id)::text = 'W3'::text) AND (veto_cap_role = 'critical'::text)) OR (((signal_id)::text = 'W5'::text) AND (veto_cap_role = 'warning'::text)) OR (((signal_id)::text <> ALL ((ARRAY['W3'::character varying, 'W5'::character varying])::text[])) AND (veto_cap_role IS NULL))))
);


--
-- Name: TABLE insights_signal_definition; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.insights_signal_definition IS 'Platform AI Insights signal catalog (W1–W8, V1–V3). Seeded; workspace overrides in workspace_insights_signal_setting.';


--
-- Name: invitations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invitations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    email character varying(255) NOT NULL,
    role public.workspace_member_role_enum DEFAULT 'member'::public.workspace_member_role_enum NOT NULL,
    invited_by uuid NOT NULL,
    token character varying(64) NOT NULL,
    status public.invitation_status_enum DEFAULT 'pending'::public.invitation_status_enum NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    accepted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: invoice_line_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invoice_line_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    invoice_id uuid NOT NULL,
    type public.line_item_type_enum NOT NULL,
    description text NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    unit_price_cents bigint NOT NULL,
    total_cents bigint NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invoices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    subscription_id uuid NOT NULL,
    type public.invoice_type_enum DEFAULT 'subscription'::public.invoice_type_enum NOT NULL,
    status public.invoice_status_enum DEFAULT 'draft'::public.invoice_status_enum NOT NULL,
    currency character varying(3) DEFAULT 'USD'::character varying NOT NULL,
    subtotal_cents bigint DEFAULT 0 NOT NULL,
    discount_cents bigint DEFAULT 0 NOT NULL,
    tax_cents bigint DEFAULT 0 NOT NULL,
    total_cents bigint DEFAULT 0 NOT NULL,
    period_start date NOT NULL,
    period_end date NOT NULL,
    due_date date,
    paid_at timestamp with time zone,
    stripe_invoice_id character varying(255),
    pdf_url text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


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
-- Name: log_overage_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.log_overage_reports (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    subscription_id uuid NOT NULL,
    stripe_customer_id text NOT NULL,
    stripe_subscription_id text NOT NULL,
    stripe_subscription_item_id text,
    tier public.subscription_tier_enum NOT NULL,
    status text NOT NULL,
    report_kind text NOT NULL,
    period_start_at timestamp with time zone NOT NULL,
    period_end_at timestamp with time zone NOT NULL,
    observed_until timestamp with time zone NOT NULL,
    data_watermark_at timestamp with time zone,
    included_quota bigint NOT NULL,
    actual_count bigint NOT NULL,
    reported_from bigint NOT NULL,
    reported_to bigint NOT NULL,
    delta bigint NOT NULL,
    stripe_meter_event_name text NOT NULL,
    stripe_identifier text NOT NULL,
    stripe_event_id text,
    stripe_adjustment_id text,
    error text,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    reported_at timestamp with time zone,
    CONSTRAINT log_overage_reports_delta_check CHECK ((delta >= 0)),
    CONSTRAINT log_overage_reports_report_kind_check CHECK ((report_kind = ANY (ARRAY['daily'::text, 'final'::text, 'retry'::text, 'manual'::text]))),
    CONSTRAINT log_overage_reports_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'reported'::text, 'failed'::text, 'discrepancy'::text, 'void'::text])))
);


--
-- Name: managed_wallet_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.managed_wallet_accounts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id text,
    provider text NOT NULL,
    account_kind text NOT NULL,
    account_type text NOT NULL,
    environment text NOT NULL,
    network text NOT NULL,
    asset text NOT NULL,
    address text NOT NULL,
    provider_account_id text DEFAULT ''::text NOT NULL,
    provider_create_idempotency_key uuid,
    account_name text NOT NULL,
    create_response_hash text DEFAULT ''::text NOT NULL,
    status text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT managed_wallet_accounts_account_type_check CHECK ((account_type = ANY (ARRAY['evm'::text, 'solana'::text]))),
    CONSTRAINT managed_wallet_accounts_address_check CHECK ((address <> ''::text)),
    CONSTRAINT managed_wallet_accounts_asset_check CHECK ((asset <> ''::text)),
    CONSTRAINT managed_wallet_accounts_environment_check CHECK ((environment <> ''::text)),
    CONSTRAINT managed_wallet_accounts_network_check CHECK ((network <> ''::text)),
    CONSTRAINT managed_wallet_accounts_provider_check CHECK ((provider <> ''::text)),
    CONSTRAINT managed_wallet_accounts_status_check CHECK ((status = ANY (ARRAY['active'::text, 'disabled'::text, 'migration_pending'::text, 'closed'::text]))),
    CONSTRAINT mwa_protocol_network_chk CHECK (((environment <> ALL (ARRAY['sandbox'::text, 'production'::text, 'test'::text])) OR ((environment = ANY (ARRAY['sandbox'::text, 'test'::text])) AND (network = ANY (ARRAY['eip155:84532'::text, 'solana-devnet'::text]))) OR ((environment = 'production'::text) AND (network = ANY (ARRAY['eip155:8453'::text, 'solana'::text])))))
);


--
-- Name: managed_wallet_saas_commands; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.managed_wallet_saas_commands (
    workspace_id uuid NOT NULL,
    operation character varying(50) NOT NULL,
    idempotency_key character varying(128) NOT NULL,
    request_hash character varying(64) NOT NULL,
    payment_resource_id character varying(100),
    status character varying(50) NOT NULL,
    actor_type character varying(50) NOT NULL,
    actor_id character varying(128) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    response_snapshot jsonb,
    error_code character varying(100),
    error_message text,
    environment character varying(50),
    network character varying(50),
    asset character varying(20),
    amount_minor numeric(40,0),
    destination_wallet_id uuid,
    destination_address_snapshot text,
    ledger_status character varying(50),
    last_synced_at timestamp with time zone,
    submitted_at timestamp with time zone,
    confirmed_at timestamp with time zone,
    released_at timestamp with time zone
);


--
-- Name: master_key_departments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.master_key_departments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    master_key_id uuid NOT NULL,
    department_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: master_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.master_keys (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    label character varying(100) NOT NULL,
    provider_id uuid NOT NULL,
    key_ciphertext bytea NOT NULL,
    key_nonce bytea NOT NULL,
    key_salt bytea,
    masked_key character varying(20) NOT NULL,
    base_url text,
    status public.api_key_status_enum DEFAULT 'active'::public.api_key_status_enum NOT NULL,
    last_used_at timestamp with time zone,
    last_verified_at timestamp with time zone,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.members (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    department_id uuid,
    user_id uuid,
    display_name character varying(100) NOT NULL,
    email character varying(255),
    note text,
    role_label text,
    monthly_budget_cents bigint,
    status public.member_status_enum DEFAULT 'active'::public.member_status_enum NOT NULL,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: model_configs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.model_configs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    provider_id uuid NOT NULL,
    model_id text NOT NULL,
    display_name character varying(100),
    enabled boolean DEFAULT true NOT NULL,
    cost_per_input_token_cents numeric(12,8),
    cost_per_output_token_cents numeric(12,8),
    max_context_tokens integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: notification_delivery_tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notification_delivery_tasks (
    id bigint NOT NULL,
    user_id uuid NOT NULL,
    workspace_id uuid NOT NULL,
    category text NOT NULL,
    channel text NOT NULL,
    scheduled_at timestamp with time zone NOT NULL,
    status text NOT NULL,
    attempt_count integer DEFAULT 0 NOT NULL,
    next_retry_at timestamp with time zone,
    payload_snapshot jsonb DEFAULT '{}'::jsonb NOT NULL,
    last_error_message text,
    last_error_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT notification_delivery_tasks_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'processing'::text, 'completed'::text, 'dead'::text])))
);


--
-- Name: notification_delivery_tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notification_delivery_tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notification_delivery_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notification_delivery_tasks_id_seq OWNED BY public.notification_delivery_tasks.id;


--
-- Name: notification_preferences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notification_preferences (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    channel character varying(20) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    verified boolean DEFAULT false NOT NULL,
    config_value bytea,
    config_nonce bytea,
    extra_value text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT notification_preferences_channel_check CHECK (((channel)::text = ANY ((ARRAY['email'::character varying, 'slack'::character varying, 'telegram'::character varying, 'lark'::character varying, 'discord'::character varying])::text[])))
);


--
-- Name: TABLE notification_preferences; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.notification_preferences IS 'Notification channel webhook/address config per workspace';


--
-- Name: COLUMN notification_preferences.config_value; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.notification_preferences.config_value IS 'AES-256-GCM ciphertext of webhook URL or email address';


--
-- Name: COLUMN notification_preferences.config_nonce; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.notification_preferences.config_nonce IS 'GCM nonce for config_value decryption';


--
-- Name: COLUMN notification_preferences.extra_value; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.notification_preferences.extra_value IS 'Telegram chat_id (plaintext); unused for other channels';


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    type public.notification_type_enum NOT NULL,
    channel public.notification_channel_enum DEFAULT 'in_app'::public.notification_channel_enum NOT NULL,
    title character varying(200) NOT NULL,
    message text NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    read_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: COLUMN notifications.deleted_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.notifications.deleted_at IS 'When set, notification is hidden from list/unread APIs (soft delete).';


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
-- Name: partner_payouts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.partner_payouts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    partner_id text NOT NULL,
    period_start date NOT NULL,
    period_end date NOT NULL,
    upstream_cost_micro_usd bigint DEFAULT 0 NOT NULL,
    partner_base_cost_micro_usd bigint DEFAULT 0 NOT NULL,
    retail_amount_micro_usd bigint DEFAULT 0 NOT NULL,
    payout_amount_micro_usd bigint DEFAULT 0 NOT NULL,
    gross_micro_usd bigint DEFAULT 0 NOT NULL,
    markup_micro_usd bigint DEFAULT 0 NOT NULL,
    net_micro_usd bigint DEFAULT 0 NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT partner_payouts_check CHECK ((period_end > period_start)),
    CONSTRAINT partner_payouts_gross_micro_usd_check CHECK ((gross_micro_usd >= 0)),
    CONSTRAINT partner_payouts_markup_micro_usd_check CHECK ((markup_micro_usd >= 0)),
    CONSTRAINT partner_payouts_net_micro_usd_check CHECK ((net_micro_usd >= 0)),
    CONSTRAINT partner_payouts_partner_base_cost_micro_usd_check CHECK ((partner_base_cost_micro_usd >= 0)),
    CONSTRAINT partner_payouts_payout_amount_micro_usd_check CHECK ((payout_amount_micro_usd >= 0)),
    CONSTRAINT partner_payouts_retail_amount_micro_usd_check CHECK ((retail_amount_micro_usd >= 0)),
    CONSTRAINT partner_payouts_upstream_cost_micro_usd_check CHECK ((upstream_cost_micro_usd >= 0))
);


--
-- Name: partner_profile_models; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.partner_profile_models (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    partner_id text NOT NULL,
    route_id uuid NOT NULL,
    markup_percent numeric DEFAULT 0 NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT partner_profile_models_markup_percent_check CHECK ((markup_percent >= (0)::numeric))
);


--
-- Name: partner_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.partner_profiles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    account_id uuid NOT NULL,
    partner_id text NOT NULL,
    slug text NOT NULL,
    display_name text DEFAULT ''::text NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    wholesale_markup_percent numeric DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    support_email text DEFAULT ''::text NOT NULL,
    telegram text DEFAULT ''::text NOT NULL,
    discord text DEFAULT ''::text NOT NULL,
    whatsapp text DEFAULT ''::text NOT NULL,
    wechat text DEFAULT ''::text NOT NULL,
    seo_title text DEFAULT ''::text NOT NULL,
    seo_description text DEFAULT ''::text NOT NULL,
    custom_domain text DEFAULT ''::text NOT NULL,
    domain_status text DEFAULT 'not_configured'::text NOT NULL,
    CONSTRAINT partner_profiles_domain_status_chk CHECK ((domain_status = ANY (ARRAY['not_configured'::text, 'pending'::text, 'verified'::text, 'failed'::text]))),
    CONSTRAINT partner_profiles_partner_id_check CHECK ((length(TRIM(BOTH FROM partner_id)) > 0)),
    CONSTRAINT partner_profiles_slug_check CHECK ((length(TRIM(BOTH FROM slug)) > 0)),
    CONSTRAINT partner_profiles_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'published'::text, 'suspended'::text]))),
    CONSTRAINT partner_profiles_wholesale_markup_percent_check CHECK ((wholesale_markup_percent >= (0)::numeric))
);


--
-- Name: payment_methods; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_methods (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    type public.payment_method_type_enum DEFAULT 'card'::public.payment_method_type_enum NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    card_brand character varying(20),
    card_last4 character varying(4),
    card_exp_month smallint,
    card_exp_year smallint,
    stripe_payment_method_id character varying(255),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: payment_methods_copy1; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_methods_copy1 (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    type public.payment_method_type_enum DEFAULT 'card'::public.payment_method_type_enum NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    card_brand character varying(20),
    card_last4 character varying(4),
    card_exp_month smallint,
    card_exp_year smallint,
    stripe_payment_method_id character varying(255),
    created_at timestamp(6) with time zone DEFAULT now() NOT NULL,
    updated_at timestamp(6) with time zone DEFAULT now() NOT NULL
);


--
-- Name: payment_operation_traces; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_operation_traces (
    id bigint NOT NULL,
    occurred_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    workspace_id uuid,
    operation_type text NOT NULL,
    operation_id text,
    event_type text NOT NULL,
    stage text NOT NULL,
    outcome text NOT NULL,
    reason text,
    request_id text,
    correlation_id text,
    trace_id text,
    activity_id uuid,
    settlement_id uuid,
    withdrawal_id uuid,
    revenue_withdrawal_id uuid,
    outbound_spend_id uuid,
    transfer_attempt_id uuid,
    tx_hash text,
    provider text,
    from_status text,
    to_status text,
    failure_class text,
    duration_ms integer,
    detail jsonb DEFAULT '{}'::jsonb NOT NULL
);


--
-- Name: payment_operation_traces_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payment_operation_traces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payment_operation_traces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payment_operation_traces_id_seq OWNED BY public.payment_operation_traces.id;


--
-- Name: payment_webhook_inbox; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_webhook_inbox (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider text NOT NULL,
    event_type text NOT NULL,
    event_dedupe_key text NOT NULL,
    provider_event_id text,
    provider_object_id text,
    topup_id uuid,
    account_id uuid,
    workspace_id uuid,
    status text DEFAULT 'received'::text NOT NULL,
    attempt_count integer DEFAULT 0 NOT NULL,
    next_retry_at timestamp with time zone,
    last_attempt_at timestamp with time zone,
    processed_at timestamp with time zone,
    last_error_code text,
    last_error_message text,
    headers jsonb DEFAULT '{}'::jsonb NOT NULL,
    raw_body bytea NOT NULL,
    raw_body_sha256 text NOT NULL,
    parsed_payload jsonb,
    received_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT payment_webhook_inbox_attempt_count_check CHECK ((attempt_count >= 0)),
    CONSTRAINT payment_webhook_inbox_dedupe_key_check CHECK ((char_length(TRIM(BOTH FROM event_dedupe_key)) > 0)),
    CONSTRAINT payment_webhook_inbox_event_type_check CHECK ((char_length(TRIM(BOTH FROM event_type)) > 0)),
    CONSTRAINT payment_webhook_inbox_processed_at_check CHECK ((((status = 'processed'::text) AND (processed_at IS NOT NULL)) OR (status <> 'processed'::text))),
    CONSTRAINT payment_webhook_inbox_provider_check CHECK ((char_length(TRIM(BOTH FROM provider)) > 0)),
    CONSTRAINT payment_webhook_inbox_raw_body_sha256_check CHECK ((char_length(TRIM(BOTH FROM raw_body_sha256)) = 64)),
    CONSTRAINT payment_webhook_inbox_status_check CHECK ((status = ANY (ARRAY['received'::text, 'processing'::text, 'retryable'::text, 'processed'::text, 'ignored'::text, 'failed'::text])))
);


--
-- Name: personal_access_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.personal_access_tokens (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    workspace_id uuid NOT NULL,
    name character varying(100) NOT NULL,
    token_hash character varying(64) NOT NULL,
    token_prefix character varying(32) NOT NULL,
    scopes text[] DEFAULT ARRAY['read'::text] NOT NULL,
    last_used_at timestamp with time zone,
    expires_at timestamp with time zone,
    revoked_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    token_ciphertext bytea,
    token_nonce bytea
);


--
-- Name: platform_fee_withdrawal_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.platform_fee_withdrawal_requests (
    id uuid NOT NULL,
    actor_user_id uuid NOT NULL,
    actor_email text NOT NULL,
    idempotency_key text NOT NULL,
    request_hash text NOT NULL,
    environment text NOT NULL,
    network text NOT NULL,
    asset text NOT NULL,
    computed_amount numeric(20,8),
    destination_key text NOT NULL,
    destination_address_snapshot text,
    payment_service_withdrawal_id text,
    payment_service_status text,
    tx_hash text,
    status text NOT NULL,
    failure_reason text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    completed_at timestamp with time zone,
    CONSTRAINT platform_fee_withdrawal_requests_computed_amount_check CHECK (((computed_amount IS NULL) OR (computed_amount >= (0)::numeric))),
    CONSTRAINT platform_fee_withdrawal_requests_status_check CHECK ((status = ANY (ARRAY['requested'::text, 'reserved'::text, 'submitted'::text, 'confirmed'::text, 'failed'::text, 'manual_review'::text, 'released'::text])))
);


--
-- Name: platform_fee_withdrawals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.platform_fee_withdrawals (
    id uuid NOT NULL,
    actor_user_id uuid,
    actor_email text,
    idempotency_key text NOT NULL,
    request_hash text NOT NULL,
    environment text NOT NULL,
    network text NOT NULL,
    asset text NOT NULL,
    computed_amount numeric(20,8),
    destination_key text NOT NULL,
    destination_address_snapshot text,
    payment_service_withdrawal_id text,
    payment_service_status text,
    tx_hash text,
    status text NOT NULL,
    failure_reason text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    completed_at timestamp with time zone,
    platform_account_id uuid,
    amount numeric(78,0) DEFAULT 0 NOT NULL,
    destination_address text DEFAULT ''::text NOT NULL,
    provider text DEFAULT ''::text NOT NULL,
    provider_idempotency_key uuid,
    provider_transfer_id text DEFAULT ''::text NOT NULL,
    chain_tx_id text DEFAULT ''::text NOT NULL,
    chain_evidence_type text DEFAULT ''::text NOT NULL,
    chain_evidence_ref text DEFAULT ''::text NOT NULL,
    expires_at timestamp with time zone DEFAULT now() NOT NULL,
    network_fee_amount numeric(78,0) DEFAULT 0 NOT NULL,
    net_amount numeric(78,0),
    fee_asset text DEFAULT 'USDC'::text NOT NULL,
    fee_reason text DEFAULT 'withdrawal_network_fee'::text NOT NULL,
    fee_policy_version text DEFAULT ''::text NOT NULL,
    fee_quote_id text DEFAULT ''::text NOT NULL,
    fee_quote_expires_at timestamp with time zone DEFAULT now() NOT NULL,
    fee_quote_hash text DEFAULT ''::text NOT NULL,
    requested_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT platform_fee_withdrawals_computed_amount_check CHECK (((computed_amount IS NULL) OR (computed_amount >= (0)::numeric))),
    CONSTRAINT platform_fee_withdrawals_status_check CHECK ((status = ANY (ARRAY['requested'::text, 'reserved'::text, 'submitted'::text, 'confirmed'::text, 'failed'::text, 'manual_review'::text, 'released'::text])))
);


--
-- Name: platform_revenue_balances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.platform_revenue_balances (
    environment text NOT NULL,
    network text NOT NULL,
    asset text NOT NULL,
    source_account_id uuid NOT NULL,
    available_amount numeric(78,0) DEFAULT 0 NOT NULL,
    reserved_amount numeric(78,0) DEFAULT 0 NOT NULL,
    version bigint DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT platform_revenue_balances_available_amount_check CHECK ((available_amount >= (0)::numeric)),
    CONSTRAINT platform_revenue_balances_reserved_amount_check CHECK ((reserved_amount >= (0)::numeric)),
    CONSTRAINT platform_revenue_balances_version_check CHECK ((version >= 0)),
    CONSTRAINT prb_protocol_network_chk CHECK (((environment <> ALL (ARRAY['sandbox'::text, 'production'::text, 'test'::text])) OR ((environment = ANY (ARRAY['sandbox'::text, 'test'::text])) AND (network = ANY (ARRAY['eip155:84532'::text, 'solana-devnet'::text]))) OR ((environment = 'production'::text) AND (network = ANY (ARRAY['eip155:8453'::text, 'solana'::text])))))
);


--
-- Name: platform_revenue_ledger_postings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.platform_revenue_ledger_postings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    ledger_transaction_id uuid NOT NULL,
    account text NOT NULL,
    direction text NOT NULL,
    amount numeric(78,0) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT platform_revenue_ledger_postings_account_check CHECK ((account = ANY (ARRAY['platform_revenue_available'::text, 'platform_revenue_reserved'::text, 'platform_revenue_chain_outflow'::text, 'platform_revenue_adjustment'::text]))),
    CONSTRAINT platform_revenue_ledger_postings_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT platform_revenue_ledger_postings_direction_check CHECK ((direction = ANY (ARRAY['debit'::text, 'credit'::text])))
);


--
-- Name: platform_revenue_ledger_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.platform_revenue_ledger_transactions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    environment text NOT NULL,
    network text NOT NULL,
    asset text NOT NULL,
    source_account_id uuid NOT NULL,
    operation_type text NOT NULL,
    operation_id text NOT NULL,
    operation_status text NOT NULL,
    idempotency_key text NOT NULL,
    request_hash text NOT NULL,
    actor_type text NOT NULL,
    actor_id text NOT NULL,
    correlation_id text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT platform_revenue_ledger_transactions_idempotency_key_check CHECK ((idempotency_key <> ''::text)),
    CONSTRAINT platform_revenue_ledger_transactions_operation_id_check CHECK ((operation_id <> ''::text)),
    CONSTRAINT platform_revenue_ledger_transactions_operation_type_check CHECK ((operation_type = ANY (ARRAY['revenue_credit'::text, 'revenue_withdraw_reserve'::text, 'revenue_withdraw_submit'::text, 'revenue_withdraw_confirm'::text, 'revenue_withdraw_release'::text, 'manual_adjustment'::text]))),
    CONSTRAINT platform_revenue_ledger_transactions_request_hash_check CHECK ((request_hash <> ''::text)),
    CONSTRAINT prlt_protocol_network_chk CHECK (((environment <> ALL (ARRAY['sandbox'::text, 'production'::text, 'test'::text])) OR ((environment = ANY (ARRAY['sandbox'::text, 'test'::text])) AND (network = ANY (ARRAY['eip155:84532'::text, 'solana-devnet'::text]))) OR ((environment = 'production'::text) AND (network = ANY (ARRAY['eip155:8453'::text, 'solana'::text])))))
);


--
-- Name: policy_configs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.policy_configs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    type public.policy_type_enum NOT NULL,
    name character varying(100) NOT NULL,
    config jsonb DEFAULT '{}'::jsonb NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: policy_eval_traces; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.policy_eval_traces (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    request_id text NOT NULL,
    workspace_id uuid NOT NULL,
    stage text NOT NULL,
    outcome text NOT NULL,
    reason text,
    detail jsonb DEFAULT '{}'::jsonb NOT NULL,
    virtual_key_id uuid,
    department_id text,
    session_id text,
    duration_ms integer
);


--
-- Name: policy_eval_traces_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.policy_eval_traces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: policy_eval_traces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.policy_eval_traces_id_seq OWNED BY public.policy_eval_traces.id;


--
-- Name: policy_overrides; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.policy_overrides (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    department_id uuid NOT NULL,
    overrides jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE policy_overrides; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.policy_overrides IS 'Per-department policy overrides (Enterprise tier). Overrides take precedence over workspace-level policies.';


--
-- Name: private_deployment_contracts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.private_deployment_contracts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    contract_no text NOT NULL,
    customer_code text NOT NULL,
    customer_name text NOT NULL,
    starts_at timestamp with time zone NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    grace_until timestamp with time zone NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    created_by uuid NOT NULL,
    updated_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT private_deployment_contracts_check CHECK (((starts_at < expires_at) AND (expires_at <= grace_until))),
    CONSTRAINT private_deployment_contracts_status_check CHECK ((status = ANY (ARRAY['active'::text, 'terminated'::text])))
);


--
-- Name: private_deployment_licenses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.private_deployment_licenses (
    id uuid NOT NULL,
    contract_id uuid NOT NULL,
    key_id text NOT NULL,
    signed_token text NOT NULL,
    not_before timestamp with time zone NOT NULL,
    issued_at timestamp with time zone NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    grace_until timestamp with time zone NOT NULL,
    idempotency_key text NOT NULL,
    issued_by uuid NOT NULL,
    revoked_at timestamp with time zone,
    revoke_reason text,
    revoked_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT private_deployment_licenses_check CHECK (((not_before < expires_at) AND (expires_at <= grace_until))),
    CONSTRAINT private_deployment_licenses_check1 CHECK ((((revoked_at IS NULL) AND (revoke_reason IS NULL) AND (revoked_by IS NULL)) OR ((revoked_at IS NOT NULL) AND (revoke_reason IS NOT NULL) AND (revoked_by IS NOT NULL))))
);


--
-- Name: prompt_bindings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.prompt_bindings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    template_id uuid NOT NULL,
    entity_type public.prompt_binding_entity_enum NOT NULL,
    entity_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE prompt_bindings; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.prompt_bindings IS 'M:N binding: prompt_templates ↔ agents / virtual_keys / members (workspace_members.id).';


--
-- Name: prompt_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.prompt_templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    slug character varying(64) NOT NULL,
    name character varying(255) NOT NULL,
    status public.prompt_status_enum DEFAULT 'draft'::public.prompt_status_enum NOT NULL,
    current_version integer DEFAULT 1 NOT NULL,
    messages jsonb DEFAULT '[]'::jsonb NOT NULL,
    variables jsonb DEFAULT '[]'::jsonb NOT NULL,
    bound_model character varying(64) DEFAULT 'gpt-4o'::character varying NOT NULL,
    temperature numeric(3,2) DEFAULT 0.70 NOT NULL,
    max_tokens integer DEFAULT 4096 NOT NULL,
    top_p numeric(3,2) DEFAULT 0.95 NOT NULL,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT chk_prompt_max_tokens CHECK (((max_tokens >= 1) AND (max_tokens <= 128000))),
    CONSTRAINT chk_prompt_temperature CHECK (((temperature >= (0)::numeric) AND (temperature <= (2)::numeric))),
    CONSTRAINT chk_prompt_top_p CHECK (((top_p >= (0)::numeric) AND (top_p <= (1)::numeric)))
);


--
-- Name: TABLE prompt_templates; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.prompt_templates IS 'Registered prompt templates — cost-saving assets with version control and model routing.';


--
-- Name: COLUMN prompt_templates.slug; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.prompt_templates.slug IS 'Human-readable ID, unique per workspace. Used as :id in API routes.';


--
-- Name: COLUMN prompt_templates.messages; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.prompt_templates.messages IS 'JSONB array: [{role: "system"|"user"|"assistant", content: "..."}]';


--
-- Name: COLUMN prompt_templates.variables; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.prompt_templates.variables IS 'JSONB array: [{name, type: "string"|"number"|"json", required: bool, description}]';


--
-- Name: prompt_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.prompt_versions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    template_id uuid NOT NULL,
    version integer NOT NULL,
    messages jsonb NOT NULL,
    variables jsonb DEFAULT '[]'::jsonb NOT NULL,
    temperature numeric(3,2) NOT NULL,
    max_tokens integer NOT NULL,
    top_p numeric(3,2) NOT NULL,
    change_note text DEFAULT ''::text NOT NULL,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_prompt_version_positive CHECK ((version > 0))
);


--
-- Name: TABLE prompt_versions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.prompt_versions IS 'Immutable version snapshots. Each save creates a new row.';


--
-- Name: provider_configs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.provider_configs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    provider_id uuid NOT NULL,
    default_base_url text,
    timeout_ms integer DEFAULT 30000,
    retry_count integer DEFAULT 2,
    enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: provider_models; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.provider_models (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_id uuid NOT NULL,
    model_id character varying(100) NOT NULL,
    display_name character varying(200),
    enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    info jsonb
);


--
-- Name: TABLE provider_models; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.provider_models IS 'Known models per provider (workspace-independent). Source for frontend dropdowns.';


--
-- Name: COLUMN provider_models.info; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.provider_models.info IS 'Per-model billing rates as JSON (schema_version + per-1M-token USD fields). Gateway logging cost; NULL means no table-based price.';


--
-- Name: providers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    icon_url text,
    logo_url text,
    default_base_url text,
    sort_order integer DEFAULT 0 NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    is_router boolean DEFAULT false NOT NULL,
    cn_base_url text
);


--
-- Name: TABLE providers; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.providers IS 'API provider registry (workspace-independent). Replaces api_provider_enum.';


--
-- Name: COLUMN providers.is_router; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.providers.is_router IS 'Model aggregator: gateway skips embedded model whitelist and model-mapping for this target; forwards client model string.';


--
-- Name: COLUMN providers.cn_base_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.providers.cn_base_url IS 'Optional Mainland China endpoint for same-provider regional endpoint retry.';


--
-- Name: refresh_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.refresh_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    token_hash character varying(64) NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    revoked_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_agent text,
    ip_address text,
    location text
);


--
-- Name: revenue_reservation_consumptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.revenue_reservation_consumptions (
    workspace_id text NOT NULL,
    revenue_reservation_id text CONSTRAINT revenue_reservation_consumption_revenue_reservation_id_not_null NOT NULL,
    environment text NOT NULL,
    network text NOT NULL,
    asset text NOT NULL,
    amount numeric(78,0) NOT NULL,
    to_address text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    idempotency_key text NOT NULL,
    canonical_request_hash text CONSTRAINT revenue_reservation_consumption_canonical_request_hash_not_null NOT NULL,
    signature_hash text NOT NULL,
    revenue_withdrawal_id uuid NOT NULL,
    status text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    destination_wallet_id uuid,
    CONSTRAINT revenue_reservation_consumptions_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT revenue_reservation_consumptions_canonical_request_hash_check CHECK ((canonical_request_hash <> ''::text)),
    CONSTRAINT revenue_reservation_consumptions_signature_hash_check CHECK ((signature_hash <> ''::text)),
    CONSTRAINT revenue_reservation_consumptions_status_check CHECK ((status = ANY (ARRAY['reserved'::text, 'submitted'::text, 'confirmed'::text, 'released'::text, 'manual_review'::text]))),
    CONSTRAINT revenue_reservation_consumptions_to_address_check CHECK ((to_address <> ''::text)),
    CONSTRAINT rrc_protocol_network_chk CHECK (((environment <> ALL (ARRAY['sandbox'::text, 'production'::text, 'test'::text])) OR ((environment = ANY (ARRAY['sandbox'::text, 'test'::text])) AND (network = ANY (ARRAY['eip155:84532'::text, 'solana-devnet'::text]))) OR ((environment = 'production'::text) AND (network = ANY (ARRAY['eip155:8453'::text, 'solana'::text])))))
);


--
-- Name: revenue_withdrawals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.revenue_withdrawals (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id text NOT NULL,
    revenue_reservation_id text NOT NULL,
    platform_account_id uuid,
    environment text NOT NULL,
    network text NOT NULL,
    asset text NOT NULL,
    amount numeric(78,0) NOT NULL,
    to_address text NOT NULL,
    provider text DEFAULT ''::text NOT NULL,
    provider_idempotency_key uuid,
    provider_transfer_id text DEFAULT ''::text NOT NULL,
    chain_tx_id text DEFAULT ''::text NOT NULL,
    status text NOT NULL,
    idempotency_key text NOT NULL,
    request_hash text NOT NULL,
    reservation_signature_hash text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    failure_reason text DEFAULT ''::text NOT NULL,
    requested_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    chain_evidence_type text DEFAULT ''::text NOT NULL,
    chain_evidence_ref text DEFAULT ''::text NOT NULL,
    network_fee_amount numeric(78,0) DEFAULT 0 NOT NULL,
    net_amount numeric(78,0),
    fee_asset text DEFAULT 'USDC'::text NOT NULL,
    fee_reason text DEFAULT 'withdrawal_network_fee'::text NOT NULL,
    fee_policy_version text DEFAULT ''::text NOT NULL,
    fee_quote_id text DEFAULT ''::text NOT NULL,
    fee_quote_expires_at timestamp with time zone DEFAULT now() NOT NULL,
    fee_quote_hash text DEFAULT ''::text NOT NULL,
    destination_wallet_id uuid,
    CONSTRAINT revenue_withdrawals_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT revenue_withdrawals_asset_check CHECK ((asset <> ''::text)),
    CONSTRAINT revenue_withdrawals_environment_check CHECK ((environment <> ''::text)),
    CONSTRAINT revenue_withdrawals_idempotency_key_check CHECK ((idempotency_key <> ''::text)),
    CONSTRAINT revenue_withdrawals_network_check CHECK ((network <> ''::text)),
    CONSTRAINT revenue_withdrawals_request_hash_check CHECK ((request_hash <> ''::text)),
    CONSTRAINT revenue_withdrawals_reservation_signature_hash_check CHECK ((reservation_signature_hash <> ''::text)),
    CONSTRAINT revenue_withdrawals_revenue_reservation_id_check CHECK ((revenue_reservation_id <> ''::text)),
    CONSTRAINT revenue_withdrawals_status_check CHECK ((status = ANY (ARRAY['requested'::text, 'reserved'::text, 'submitted'::text, 'confirmed'::text, 'canceled'::text, 'failed'::text, 'manual_review'::text]))),
    CONSTRAINT revenue_withdrawals_to_address_check CHECK ((to_address <> ''::text)),
    CONSTRAINT revenue_withdrawals_workspace_id_check CHECK ((workspace_id <> ''::text)),
    CONSTRAINT rw_protocol_network_chk CHECK (((environment <> ALL (ARRAY['sandbox'::text, 'production'::text, 'test'::text])) OR ((environment = ANY (ARRAY['sandbox'::text, 'test'::text])) AND (network = ANY (ARRAY['eip155:84532'::text, 'solana-devnet'::text]))) OR ((environment = 'production'::text) AND (network = ANY (ARRAY['eip155:8453'::text, 'solana'::text])))))
);


--
-- Name: sales_leads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sales_leads (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    full_name character varying(255) NOT NULL,
    work_email character varying(255) NOT NULL,
    company character varying(255) NOT NULL,
    company_size character varying(50) NOT NULL,
    use_case text NOT NULL,
    source character varying(50) DEFAULT 'unknown'::character varying NOT NULL,
    intent character varying(255),
    user_id uuid,
    workspace_id uuid,
    notification_sent_at timestamp with time zone,
    notification_error text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    role character varying(255),
    timeline character varying(255),
    CONSTRAINT sales_leads_notification_error_len_chk CHECK (((notification_error IS NULL) OR (char_length(notification_error) <= 1000))),
    CONSTRAINT sales_leads_source_chk CHECK (((source)::text = ANY ((ARRAY['billing'::character varying, 'pricing'::character varying, 'dashboard'::character varying, 'landing'::character varying, 'contact'::character varying, 'unknown'::character varying])::text[])))
);


--
-- Name: subscription_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subscription_events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    subscription_id uuid NOT NULL,
    event_type public.subscription_event_type_enum NOT NULL,
    from_tier public.subscription_tier_enum,
    to_tier public.subscription_tier_enum,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subscriptions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    tier public.subscription_tier_enum DEFAULT 'free'::public.subscription_tier_enum NOT NULL,
    status public.subscription_status_enum DEFAULT 'active'::public.subscription_status_enum NOT NULL,
    billing_period public.billing_period_enum DEFAULT 'monthly'::public.billing_period_enum NOT NULL,
    base_price_cents integer DEFAULT 0 NOT NULL,
    base_vk_limit integer NOT NULL,
    extra_vk_count integer DEFAULT 0 NOT NULL,
    log_limit integer NOT NULL,
    current_period_start date NOT NULL,
    current_period_end date NOT NULL,
    trial_ends_at timestamp with time zone,
    cancel_at_period_end boolean DEFAULT false NOT NULL,
    canceled_at timestamp with time zone,
    downgraded_from public.subscription_tier_enum,
    downgraded_at timestamp with time zone,
    stripe_customer_id character varying(255),
    stripe_subscription_id character varying(255),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    log_overage_reported bigint DEFAULT 0 NOT NULL,
    current_period_start_at timestamp with time zone,
    current_period_end_at timestamp with time zone
);


--
-- Name: sync_watermarks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sync_watermarks (
    sync_key character varying(128) NOT NULL,
    last_synced_value text NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE sync_watermarks; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.sync_watermarks IS 'Watermarks for CH-to-PG sync jobs';


--
-- Name: teams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.teams (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: usage_aggregates_daily; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.usage_aggregates_daily (
    workspace_id uuid NOT NULL,
    date date NOT NULL,
    department_id uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    entity_type text DEFAULT ''::text NOT NULL,
    entity_id uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    model text DEFAULT ''::text NOT NULL,
    provider text DEFAULT ''::text NOT NULL,
    master_key_id uuid DEFAULT '00000000-0000-0000-0000-000000000000'::uuid NOT NULL,
    request_count bigint DEFAULT 0 NOT NULL,
    cost_sum bigint DEFAULT 0 NOT NULL,
    prompt_tokens_sum bigint DEFAULT 0 NOT NULL,
    completion_tokens_sum bigint DEFAULT 0 NOT NULL,
    reasoning_tokens_sum bigint DEFAULT 0 NOT NULL,
    latency_ms_sum bigint DEFAULT 0 NOT NULL,
    success_count bigint DEFAULT 0 NOT NULL,
    error_count bigint DEFAULT 0 NOT NULL,
    last_event_at timestamp with time zone,
    entity_name text DEFAULT ''::text NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email character varying(255) NOT NULL,
    name character varying(255),
    password_hash character varying(255),
    oauth_provider character varying(50),
    oauth_id character varying(255),
    status character varying(20) DEFAULT 'active'::character varying,
    email_verified_at timestamp with time zone,
    email_verification_token_hash character varying(255),
    email_verification_expires_at timestamp with time zone,
    password_reset_token_hash character varying(255),
    password_reset_expires_at timestamp with time zone,
    display_name text,
    avatar_url text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_seen_at timestamp with time zone,
    onboarding_completed boolean DEFAULT false NOT NULL,
    onboarding_step text,
    two_factor_enabled boolean DEFAULT false NOT NULL,
    totp_secret_encrypted bytea,
    totp_backup_codes_hash text,
    totp_pending_secret_encrypted bytea,
    totp_pending_backup_codes_hash text,
    auth_provider text DEFAULT 'email'::text NOT NULL,
    email_otp_hash text,
    email_otp_expires_at timestamp with time zone,
    email_otp_token_hash text,
    email_otp_token_expires_at timestamp with time zone,
    CONSTRAINT users_auth_provider_check CHECK ((auth_provider = ANY (ARRAY['email'::text, 'google'::text, 'github'::text]))),
    CONSTRAINT users_password_or_oauth CHECK (((password_hash IS NOT NULL) OR ((oauth_provider IS NOT NULL) AND (oauth_id IS NOT NULL))))
);


--
-- Name: TABLE users; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.users IS 'User table for self-hosted PG. If using Supabase, use auth.users instead.';


--
-- Name: COLUMN users.onboarding_completed; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.onboarding_completed IS 'True when user has finished onboarding (737)';


--
-- Name: COLUMN users.onboarding_step; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.onboarding_step IS 'Current onboarding step: null (not chosen), personal, enterprise, or done (737)';


--
-- Name: virtual_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.virtual_keys (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    master_key_id uuid NOT NULL,
    label character varying(100) NOT NULL,
    key_hash character varying(64) NOT NULL,
    key_prefix character varying(16) NOT NULL,
    entity_type public.vk_entity_type_enum,
    entity_id uuid,
    status public.virtual_key_status_enum DEFAULT 'active'::public.virtual_key_status_enum NOT NULL,
    expires_at timestamp with time zone,
    expiry_preset public.vk_expiry_preset_enum DEFAULT 'never'::public.vk_expiry_preset_enum NOT NULL,
    budget_cents bigint,
    budget_action public.vk_budget_action_enum DEFAULT 'alert_only'::public.vk_budget_action_enum,
    budget_window public.vk_budget_window_enum DEFAULT 'monthly'::public.vk_budget_window_enum,
    rate_limit_rpm integer,
    rate_limit_rph integer,
    allowed_models text[],
    blocked_models text[],
    key_token_ciphertext bytea,
    key_token_nonce bytea,
    disabled_by public.vk_disabled_by_enum,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone,
    models_info jsonb,
    CONSTRAINT chk_vk_entity_pair CHECK ((((entity_type IS NULL) AND (entity_id IS NULL)) OR ((entity_type IS NOT NULL) AND (entity_id IS NOT NULL)))),
    CONSTRAINT chk_vk_expiry_preset_expires_at CHECK ((((expiry_preset = 'never'::public.vk_expiry_preset_enum) AND (expires_at IS NULL)) OR ((expiry_preset = ANY (ARRAY['7d'::public.vk_expiry_preset_enum, '30d'::public.vk_expiry_preset_enum, '90d'::public.vk_expiry_preset_enum, 'custom'::public.vk_expiry_preset_enum])) AND (expires_at IS NOT NULL))))
);


--
-- Name: COLUMN virtual_keys.key_token_ciphertext; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.virtual_keys.key_token_ciphertext IS 'AES-GCM ciphertext of full VK token; NULL for legacy rows until rotated.';


--
-- Name: COLUMN virtual_keys.key_token_nonce; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.virtual_keys.key_token_nonce IS 'Nonce for key_token_ciphertext; NULL when ciphertext is NULL.';


--
-- Name: COLUMN virtual_keys.disabled_by; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.virtual_keys.disabled_by IS 'Why this VK was disabled: manual (user toggled) or master_key_cascade (parent MK disabled). NULL when active.';


--
-- Name: v_member_usage; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_member_usage AS
 SELECT m.id,
    m.workspace_id,
    m.display_name AS name,
    COALESCE(m.email, ''::character varying(255)) AS email,
    m.note,
    vk.key_prefix AS virtual_key_prefix,
    vk.id AS virtual_key_id,
    m.monthly_budget_cents,
    (0)::bigint AS period_spend_cents,
    0 AS period_request_count,
    m.status,
    m.created_at,
    m.department_id,
    vk.expires_at AS key_expires_at,
    vk.master_key_id,
    vk.expiry_preset AS key_expiry_preset,
    vk.status AS virtual_key_status,
    m.role_label
   FROM (public.members m
     LEFT JOIN public.virtual_keys vk ON (((vk.entity_type = 'member'::public.vk_entity_type_enum) AND (vk.entity_id = m.id) AND (vk.deleted_at IS NULL))))
  WHERE (m.deleted_at IS NULL);


--
-- Name: v_subscription_usage; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_subscription_usage AS
 SELECT workspace_id,
    (( SELECT count(*) AS count
           FROM public.master_keys mk
          WHERE ((mk.workspace_id = s.workspace_id) AND (mk.deleted_at IS NULL))))::integer AS master_keys,
    (( SELECT count(*) AS count
           FROM public.virtual_keys vk
          WHERE ((vk.workspace_id = s.workspace_id) AND (vk.status = 'active'::public.virtual_key_status_enum) AND (vk.deleted_at IS NULL))))::integer AS virtual_keys,
    (( SELECT count(*) AS count
           FROM public.agents a
          WHERE ((a.workspace_id = s.workspace_id) AND (a.deleted_at IS NULL))))::integer AS agents,
    (( SELECT count(*) AS count
           FROM public.members m
          WHERE ((m.workspace_id = s.workspace_id) AND (m.deleted_at IS NULL))))::integer AS members,
    (( SELECT count(*) AS count
           FROM public.departments d
          WHERE ((d.workspace_id = s.workspace_id) AND (d.deleted_at IS NULL))))::integer AS departments,
    0 AS requests_this_month
   FROM public.subscriptions s
  WHERE (workspace_id IS NOT NULL);


--
-- Name: v_virtual_key_detail; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_virtual_key_detail AS
 SELECT vk.id,
    vk.workspace_id,
    vk.master_key_id,
    vk.label,
    vk.key_prefix,
    vk.entity_type,
    vk.entity_id,
    COALESCE(a.name, m.display_name) AS entity_display_name,
    vk.status,
    mk.label AS master_key_name,
    p.code AS master_key_provider,
    vk.budget_cents,
    vk.budget_action,
    vk.budget_window,
    vk.rate_limit_rpm,
    vk.rate_limit_rph,
    vk.allowed_models,
    vk.blocked_models,
    vk.expires_at,
    vk.expiry_preset,
    vk.created_at,
    vk.updated_at,
    vk.models_info
   FROM ((((public.virtual_keys vk
     LEFT JOIN public.agents a ON (((vk.entity_type = 'agent'::public.vk_entity_type_enum) AND (vk.entity_id = a.id) AND (a.deleted_at IS NULL))))
     LEFT JOIN public.members m ON (((vk.entity_type = 'member'::public.vk_entity_type_enum) AND (vk.entity_id = m.id) AND (m.deleted_at IS NULL))))
     LEFT JOIN public.master_keys mk ON (((vk.master_key_id = mk.id) AND (mk.deleted_at IS NULL))))
     LEFT JOIN public.providers p ON ((mk.provider_id = p.id)))
  WHERE (vk.deleted_at IS NULL);


--
-- Name: x402_payment_activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_payment_activities (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    endpoint_id uuid,
    agent_id uuid,
    trace_id text,
    request_id text NOT NULL,
    direction public.x402_direction_enum DEFAULT 'inbound'::public.x402_direction_enum NOT NULL,
    buyer_wallet text,
    amount numeric(20,8) NOT NULL,
    asset text DEFAULT 'USDC'::text NOT NULL,
    network text NOT NULL,
    source text DEFAULT 'direct'::text NOT NULL,
    facilitator text DEFAULT 'coinbase'::text NOT NULL,
    payment_status public.x402_payment_status_enum DEFAULT 'required'::public.x402_payment_status_enum NOT NULL,
    settlement_status public.x402_settlement_status_enum DEFAULT 'pending'::public.x402_settlement_status_enum NOT NULL,
    service_status public.x402_service_status_enum DEFAULT 'not_started'::public.x402_service_status_enum NOT NULL,
    split_status public.x402_split_status_enum DEFAULT 'pending_chain'::public.x402_split_status_enum NOT NULL,
    payment_signature_hash text,
    tx_hash text,
    block_number bigint,
    ale_receive_wallet_address text,
    split_treasury_id uuid,
    receive_wallet_address text NOT NULL,
    fee_wallet_address text NOT NULL,
    fee_bps integer DEFAULT 500 NOT NULL,
    gross_revenue numeric(20,8) NOT NULL,
    alephant_fee numeric(20,8) NOT NULL,
    net_revenue numeric(20,8) NOT NULL,
    ai_cost numeric(20,8),
    failure_reason text,
    facilitator_request_id text,
    facilitator_response jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    verified_at timestamp with time zone,
    settled_at timestamp with time zone,
    service_completed_at timestamp with time zone,
    available_at timestamp with time zone,
    trace_status text,
    upstream_status_code integer,
    cache_billing_mode text,
    response_hash text,
    candidate_accepts_json jsonb DEFAULT '[]'::jsonb NOT NULL,
    payment_required_header text DEFAULT ''::text NOT NULL,
    selected_accept_index integer,
    selected_accept_hash text,
    selected_network text,
    selected_asset text,
    selected_amount numeric,
    selected_pay_to text,
    selected_facilitator text,
    selected_seller_receive_wallet_address text,
    selected_collection_mode text,
    facilitator_extension_responses jsonb DEFAULT '{}'::jsonb CONSTRAINT x402_payment_activities_facilitator_extension_response_not_null NOT NULL
);


--
-- Name: x402_payouts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_payouts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    platform_wallet_id uuid,
    network text NOT NULL,
    asset text DEFAULT 'USDC'::text NOT NULL,
    seller_receive_wallet_address text,
    balance_entry_ids uuid[] DEFAULT ARRAY[]::uuid[] NOT NULL,
    entry_count integer DEFAULT 0 NOT NULL,
    gross_amount numeric(20,8),
    fee_amount numeric(20,8),
    net_amount numeric(20,8),
    estimated_payout_cost numeric(20,8),
    tx_hash text,
    status public.x402_payout_status_enum DEFAULT 'requested'::public.x402_payout_status_enum NOT NULL,
    skip_reason text,
    failure_reason text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    submitted_at timestamp with time zone,
    confirmed_at timestamp with time zone,
    idempotency_key text,
    request_hash text,
    revenue_reservation_id uuid,
    payment_service_withdrawal_id text,
    payment_service_status text,
    destination_address_snapshot text,
    created_by_user_id uuid,
    destination_wallet_id uuid,
    destination_wallet text DEFAULT ''::text,
    amount numeric(20,8) DEFAULT 0,
    network_fee numeric(20,8) DEFAULT 0 NOT NULL,
    block_number bigint,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    completed_at timestamp with time zone,
    net_received numeric(20,8) GENERATED ALWAYS AS ((COALESCE(amount, (0)::numeric) - COALESCE(network_fee, (0)::numeric))) STORED,
    CONSTRAINT x402_payouts_network_known_chk CHECK ((network = ANY (ARRAY['eip155:8453'::text, 'eip155:84532'::text, 'solana'::text, 'solana-devnet'::text])))
);


--
-- Name: v_workspace_payout_stats; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_workspace_payout_stats AS
 WITH activity AS (
         SELECT x402_payment_activities.workspace_id,
            x402_payment_activities.network,
            COALESCE(sum(x402_payment_activities.net_revenue) FILTER (WHERE (((x402_payment_activities.settlement_status)::text = 'settled'::text) AND ((x402_payment_activities.service_status)::text = 'succeeded'::text))), (0)::numeric) AS available_amount,
            COALESCE(sum(x402_payment_activities.net_revenue) FILTER (WHERE (((x402_payment_activities.settlement_status)::text = 'settled'::text) AND ((x402_payment_activities.service_status)::text <> 'succeeded'::text))), (0)::numeric) AS pending_amount,
            COALESCE(sum(x402_payment_activities.net_revenue) FILTER (WHERE (((x402_payment_activities.settlement_status)::text = 'settled'::text) AND ((x402_payment_activities.split_status)::text = 'failed'::text))), (0)::numeric) AS held_amount
           FROM public.x402_payment_activities
          GROUP BY x402_payment_activities.workspace_id, x402_payment_activities.network
        ), payouts AS (
         SELECT x402_payouts.workspace_id,
            x402_payouts.network,
            COALESCE(sum(x402_payouts.net_received) FILTER (WHERE ((x402_payouts.status)::text = 'confirmed'::text)), (0)::numeric) AS lifetime_payouts_amount,
            count(*) FILTER (WHERE ((x402_payouts.status)::text = 'confirmed'::text)) AS lifetime_count,
            max(x402_payouts.completed_at) FILTER (WHERE ((x402_payouts.status)::text = 'confirmed'::text)) AS last_payout_at
           FROM public.x402_payouts
          GROUP BY x402_payouts.workspace_id, x402_payouts.network
        )
 SELECT COALESCE(activity.workspace_id, payouts.workspace_id) AS workspace_id,
    COALESCE(activity.network, payouts.network) AS network,
    COALESCE(activity.available_amount, (0)::numeric) AS available_amount,
    COALESCE(activity.pending_amount, (0)::numeric) AS pending_amount,
    COALESCE(activity.held_amount, (0)::numeric) AS held_amount,
    COALESCE(payouts.lifetime_payouts_amount, (0)::numeric) AS lifetime_payouts_amount,
    COALESCE(payouts.lifetime_count, (0)::bigint) AS lifetime_count,
    payouts.last_payout_at
   FROM (activity
     FULL JOIN payouts ON (((payouts.workspace_id = activity.workspace_id) AND (payouts.network = activity.network))));


--
-- Name: wallet_chain_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wallet_chain_events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    environment text NOT NULL,
    network text NOT NULL,
    asset text NOT NULL,
    chain_tx_id text NOT NULL,
    chain_event_index integer NOT NULL,
    amount numeric(78,0) NOT NULL,
    from_address text DEFAULT ''::text NOT NULL,
    to_address text NOT NULL,
    token_address text DEFAULT ''::text NOT NULL,
    token_mint text DEFAULT ''::text NOT NULL,
    confirmation_count integer DEFAULT 0 NOT NULL,
    finality_status text NOT NULL,
    claimed_by_deposit_intent_id uuid,
    status text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT wallet_chain_events_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT wallet_chain_events_asset_check CHECK ((asset <> ''::text)),
    CONSTRAINT wallet_chain_events_chain_event_index_check CHECK ((chain_event_index >= 0)),
    CONSTRAINT wallet_chain_events_chain_tx_id_check CHECK ((chain_tx_id <> ''::text)),
    CONSTRAINT wallet_chain_events_confirmation_count_check CHECK ((confirmation_count >= 0)),
    CONSTRAINT wallet_chain_events_environment_check CHECK ((environment <> ''::text)),
    CONSTRAINT wallet_chain_events_network_check CHECK ((network <> ''::text)),
    CONSTRAINT wallet_chain_events_status_check CHECK ((status = ANY (ARRAY['observed'::text, 'claimed'::text, 'confirmed'::text, 'released'::text, 'manual_review'::text]))),
    CONSTRAINT wallet_chain_events_to_address_check CHECK ((to_address <> ''::text)),
    CONSTRAINT wce_protocol_network_chk CHECK (((environment <> ALL (ARRAY['sandbox'::text, 'production'::text, 'test'::text])) OR ((environment = ANY (ARRAY['sandbox'::text, 'test'::text])) AND (network = ANY (ARRAY['eip155:84532'::text, 'solana-devnet'::text]))) OR ((environment = 'production'::text) AND (network = ANY (ARRAY['eip155:8453'::text, 'solana'::text])))))
);


--
-- Name: wallet_deposit_intents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wallet_deposit_intents (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id text NOT NULL,
    managed_account_id uuid NOT NULL,
    environment text NOT NULL,
    network text NOT NULL,
    asset text NOT NULL,
    expected_amount numeric(78,0) NOT NULL,
    observed_amount numeric(78,0) DEFAULT 0 NOT NULL,
    confirmed_amount numeric(78,0) DEFAULT 0 NOT NULL,
    target_address text NOT NULL,
    chain_tx_id text DEFAULT ''::text NOT NULL,
    chain_event_index integer,
    status text NOT NULL,
    idempotency_key text NOT NULL,
    request_hash text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT wallet_deposit_intents_asset_check CHECK ((asset <> ''::text)),
    CONSTRAINT wallet_deposit_intents_chain_event_index_check CHECK (((chain_event_index IS NULL) OR (chain_event_index >= 0))),
    CONSTRAINT wallet_deposit_intents_confirmed_amount_check CHECK ((confirmed_amount >= (0)::numeric)),
    CONSTRAINT wallet_deposit_intents_environment_check CHECK ((environment <> ''::text)),
    CONSTRAINT wallet_deposit_intents_expected_amount_check CHECK ((expected_amount > (0)::numeric)),
    CONSTRAINT wallet_deposit_intents_idempotency_key_check CHECK ((idempotency_key <> ''::text)),
    CONSTRAINT wallet_deposit_intents_network_check CHECK ((network <> ''::text)),
    CONSTRAINT wallet_deposit_intents_observed_amount_check CHECK ((observed_amount >= (0)::numeric)),
    CONSTRAINT wallet_deposit_intents_request_hash_check CHECK ((request_hash <> ''::text)),
    CONSTRAINT wallet_deposit_intents_status_check CHECK ((status = ANY (ARRAY['created'::text, 'submitted'::text, 'confirmed'::text, 'expired'::text, 'failed'::text, 'manual_review'::text]))),
    CONSTRAINT wallet_deposit_intents_target_address_check CHECK ((target_address <> ''::text)),
    CONSTRAINT wallet_deposit_intents_workspace_id_check CHECK ((workspace_id <> ''::text)),
    CONSTRAINT wdi_protocol_network_chk CHECK (((environment <> ALL (ARRAY['sandbox'::text, 'production'::text, 'test'::text])) OR ((environment = ANY (ARRAY['sandbox'::text, 'test'::text])) AND (network = ANY (ARRAY['eip155:84532'::text, 'solana-devnet'::text]))) OR ((environment = 'production'::text) AND (network = ANY (ARRAY['eip155:8453'::text, 'solana'::text])))))
);


--
-- Name: wallet_ledger_postings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wallet_ledger_postings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    ledger_transaction_id uuid NOT NULL,
    account text NOT NULL,
    direction text NOT NULL,
    amount numeric(78,0) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT wallet_ledger_postings_account_check CHECK ((account = ANY (ARRAY['external'::text, 'pending'::text, 'available'::text, 'reserved'::text, 'chain_outflow'::text]))),
    CONSTRAINT wallet_ledger_postings_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT wallet_ledger_postings_direction_check CHECK ((direction = ANY (ARRAY['debit'::text, 'credit'::text])))
);


--
-- Name: wallet_ledger_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wallet_ledger_transactions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id text NOT NULL,
    environment text NOT NULL,
    network text NOT NULL,
    asset text NOT NULL,
    operation_type text NOT NULL,
    operation_id text NOT NULL,
    operation_status text DEFAULT ''::text NOT NULL,
    idempotency_key text NOT NULL,
    request_hash text NOT NULL,
    actor_type text NOT NULL,
    actor_id text NOT NULL,
    correlation_id text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT wallet_ledger_transactions_asset_check CHECK ((asset <> ''::text)),
    CONSTRAINT wallet_ledger_transactions_check CHECK ((((operation_type = 'manual_adjustment'::text) AND (operation_status = ''::text)) OR ((operation_type <> 'manual_adjustment'::text) AND (operation_status = ANY (ARRAY['created'::text, 'requested'::text, 'reserved'::text, 'submitted'::text, 'confirmed'::text, 'canceled'::text, 'expired'::text, 'failed'::text, 'manual_review'::text]))))),
    CONSTRAINT wallet_ledger_transactions_environment_check CHECK ((environment <> ''::text)),
    CONSTRAINT wallet_ledger_transactions_idempotency_key_check CHECK ((idempotency_key <> ''::text)),
    CONSTRAINT wallet_ledger_transactions_network_check CHECK ((network <> ''::text)),
    CONSTRAINT wallet_ledger_transactions_operation_id_check CHECK ((operation_id <> ''::text)),
    CONSTRAINT wallet_ledger_transactions_operation_type_check CHECK ((operation_type = ANY (ARRAY['deposit_observe'::text, 'deposit_confirm'::text, 'deposit_release'::text, 'withdraw_reserve'::text, 'withdraw_release'::text, 'withdraw_confirm'::text, 'manual_adjustment'::text]))),
    CONSTRAINT wallet_ledger_transactions_request_hash_check CHECK ((request_hash <> ''::text)),
    CONSTRAINT wallet_ledger_transactions_workspace_id_check CHECK ((workspace_id <> ''::text)),
    CONSTRAINT wlt_protocol_network_chk CHECK (((environment <> ALL (ARRAY['sandbox'::text, 'production'::text, 'test'::text])) OR ((environment = ANY (ARRAY['sandbox'::text, 'test'::text])) AND (network = ANY (ARRAY['eip155:84532'::text, 'solana-devnet'::text]))) OR ((environment = 'production'::text) AND (network = ANY (ARRAY['eip155:8453'::text, 'solana'::text])))))
);


--
-- Name: wallet_network_assets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wallet_network_assets (
    environment text NOT NULL,
    network text NOT NULL,
    asset text NOT NULL,
    preferred_provider text NOT NULL,
    fallback_provider text DEFAULT ''::text NOT NULL,
    account_type text NOT NULL,
    chain_id text NOT NULL,
    token_address text DEFAULT ''::text NOT NULL,
    token_mint text DEFAULT ''::text NOT NULL,
    decimals integer NOT NULL,
    min_confirmations integer DEFAULT 0 NOT NULL,
    finality_rule text NOT NULL,
    min_deposit_amount numeric(78,0) DEFAULT 0 NOT NULL,
    min_withdraw_amount numeric(78,0) DEFAULT 0 NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT wallet_network_assets_account_type_check CHECK ((account_type = ANY (ARRAY['evm'::text, 'solana'::text]))),
    CONSTRAINT wallet_network_assets_asset_check CHECK ((asset <> ''::text)),
    CONSTRAINT wallet_network_assets_decimals_check CHECK ((decimals >= 0)),
    CONSTRAINT wallet_network_assets_environment_check CHECK ((environment <> ''::text)),
    CONSTRAINT wallet_network_assets_min_confirmations_check CHECK ((min_confirmations >= 0)),
    CONSTRAINT wallet_network_assets_min_deposit_amount_check CHECK ((min_deposit_amount >= (0)::numeric)),
    CONSTRAINT wallet_network_assets_min_withdraw_amount_check CHECK ((min_withdraw_amount >= (0)::numeric)),
    CONSTRAINT wallet_network_assets_network_check CHECK ((network <> ''::text)),
    CONSTRAINT wallet_network_assets_preferred_provider_check CHECK ((preferred_provider <> ''::text)),
    CONSTRAINT wna_protocol_network_chk CHECK (((environment <> ALL (ARRAY['sandbox'::text, 'production'::text, 'test'::text])) OR ((environment = ANY (ARRAY['sandbox'::text, 'test'::text])) AND (network = ANY (ARRAY['eip155:84532'::text, 'solana-devnet'::text]))) OR ((environment = 'production'::text) AND (network = ANY (ARRAY['eip155:8453'::text, 'solana'::text])))))
);


--
-- Name: wallet_transfer_attempts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wallet_transfer_attempts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    operation_type text NOT NULL,
    operation_id uuid NOT NULL,
    provider text NOT NULL,
    provider_idempotency_key uuid NOT NULL,
    provider_transfer_id text DEFAULT ''::text NOT NULL,
    status text NOT NULL,
    error_class text DEFAULT ''::text NOT NULL,
    error_message text DEFAULT ''::text NOT NULL,
    next_attempt_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    chain_tx_id text DEFAULT ''::text NOT NULL,
    source_account_id uuid,
    source_address text DEFAULT ''::text NOT NULL,
    prepared_transaction_hash text DEFAULT ''::text NOT NULL,
    nonce_or_recent_blockhash text DEFAULT ''::text NOT NULL,
    last_valid_block_height bigint,
    submitted_at timestamp with time zone,
    CONSTRAINT wallet_transfer_attempts_operation_type_check CHECK ((operation_type = ANY (ARRAY['wallet_withdrawal'::text, 'revenue_withdrawal'::text, 'platform_fee_withdrawal'::text]))),
    CONSTRAINT wallet_transfer_attempts_provider_check CHECK ((provider <> ''::text)),
    CONSTRAINT wallet_transfer_attempts_status_check CHECK ((status = ANY (ARRAY['prepared'::text, 'submitted'::text, 'confirmed'::text, 'failed'::text, 'unknown'::text, 'manual_review'::text])))
);


--
-- Name: wallet_withdrawals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wallet_withdrawals (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id text NOT NULL,
    managed_account_id uuid NOT NULL,
    environment text NOT NULL,
    network text NOT NULL,
    asset text NOT NULL,
    amount numeric(78,0) NOT NULL,
    to_address text NOT NULL,
    provider text NOT NULL,
    provider_idempotency_key uuid,
    provider_transfer_id text DEFAULT ''::text NOT NULL,
    chain_tx_id text DEFAULT ''::text NOT NULL,
    status text NOT NULL,
    idempotency_key text NOT NULL,
    request_hash text NOT NULL,
    failure_reason text DEFAULT ''::text NOT NULL,
    requested_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    chain_evidence_type text DEFAULT ''::text NOT NULL,
    chain_evidence_ref text DEFAULT ''::text NOT NULL,
    network_fee_amount numeric(78,0) DEFAULT 0 NOT NULL,
    net_amount numeric(78,0),
    fee_asset text DEFAULT 'USDC'::text NOT NULL,
    fee_reason text DEFAULT 'withdrawal_network_fee'::text NOT NULL,
    fee_policy_version text DEFAULT ''::text NOT NULL,
    fee_quote_id text DEFAULT ''::text NOT NULL,
    fee_quote_expires_at timestamp with time zone DEFAULT now() NOT NULL,
    fee_quote_hash text DEFAULT ''::text NOT NULL,
    CONSTRAINT wallet_withdrawals_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT wallet_withdrawals_asset_check CHECK ((asset <> ''::text)),
    CONSTRAINT wallet_withdrawals_environment_check CHECK ((environment <> ''::text)),
    CONSTRAINT wallet_withdrawals_idempotency_key_check CHECK ((idempotency_key <> ''::text)),
    CONSTRAINT wallet_withdrawals_network_check CHECK ((network <> ''::text)),
    CONSTRAINT wallet_withdrawals_provider_check CHECK ((provider <> ''::text)),
    CONSTRAINT wallet_withdrawals_request_hash_check CHECK ((request_hash <> ''::text)),
    CONSTRAINT wallet_withdrawals_status_check CHECK ((status = ANY (ARRAY['requested'::text, 'reserved'::text, 'submitted'::text, 'confirmed'::text, 'canceled'::text, 'failed'::text, 'manual_review'::text]))),
    CONSTRAINT wallet_withdrawals_to_address_check CHECK ((to_address <> ''::text)),
    CONSTRAINT wallet_withdrawals_workspace_id_check CHECK ((workspace_id <> ''::text)),
    CONSTRAINT ww_protocol_network_chk CHECK (((environment <> ALL (ARRAY['sandbox'::text, 'production'::text, 'test'::text])) OR ((environment = ANY (ARRAY['sandbox'::text, 'test'::text])) AND (network = ANY (ARRAY['eip155:84532'::text, 'solana-devnet'::text]))) OR ((environment = 'production'::text) AND (network = ANY (ARRAY['eip155:8453'::text, 'solana'::text])))))
);


--
-- Name: webhook_deliveries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.webhook_deliveries (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    endpoint_id uuid NOT NULL,
    event_type text NOT NULL,
    payload jsonb NOT NULL,
    status_code smallint,
    response_body text,
    attempts integer DEFAULT 0 NOT NULL,
    max_attempts integer DEFAULT 5 NOT NULL,
    next_retry_at timestamp with time zone,
    delivered_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: webhook_endpoints; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.webhook_endpoints (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    url text NOT NULL,
    secret_hash character varying(64) NOT NULL,
    events text[] NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: withdrawal_daily_usage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.withdrawal_daily_usage (
    workspace_id text NOT NULL,
    fund_domain text NOT NULL,
    source_account_id uuid NOT NULL,
    environment text NOT NULL,
    network text NOT NULL,
    asset text NOT NULL,
    usage_date date NOT NULL,
    used_minor_amount numeric(78,0) DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT wdu_protocol_network_chk CHECK (((environment <> ALL (ARRAY['sandbox'::text, 'production'::text, 'test'::text])) OR ((environment = ANY (ARRAY['sandbox'::text, 'test'::text])) AND (network = ANY (ARRAY['eip155:84532'::text, 'solana-devnet'::text]))) OR ((environment = 'production'::text) AND (network = ANY (ARRAY['eip155:8453'::text, 'solana'::text]))))),
    CONSTRAINT withdrawal_daily_usage_asset_check CHECK ((asset <> ''::text)),
    CONSTRAINT withdrawal_daily_usage_environment_check CHECK ((environment <> ''::text)),
    CONSTRAINT withdrawal_daily_usage_fund_domain_check CHECK ((fund_domain = ANY (ARRAY['workspace_funding'::text, 'platform_revenue'::text]))),
    CONSTRAINT withdrawal_daily_usage_network_check CHECK ((network <> ''::text)),
    CONSTRAINT withdrawal_daily_usage_used_minor_amount_check CHECK ((used_minor_amount >= (0)::numeric)),
    CONSTRAINT withdrawal_daily_usage_workspace_id_check CHECK ((workspace_id <> ''::text))
);


--
-- Name: withdrawal_daily_usage_releases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.withdrawal_daily_usage_releases (
    withdrawal_kind text NOT NULL,
    withdrawal_id uuid NOT NULL,
    workspace_id text NOT NULL,
    fund_domain text NOT NULL,
    source_account_id uuid NOT NULL,
    environment text NOT NULL,
    network text NOT NULL,
    asset text NOT NULL,
    usage_date date NOT NULL,
    released_minor_amount numeric(78,0) NOT NULL,
    evidence_type text NOT NULL,
    evidence_ref text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT wdur_protocol_network_chk CHECK (((environment <> ALL (ARRAY['sandbox'::text, 'production'::text, 'test'::text])) OR ((environment = ANY (ARRAY['sandbox'::text, 'test'::text])) AND (network = ANY (ARRAY['eip155:84532'::text, 'solana-devnet'::text]))) OR ((environment = 'production'::text) AND (network = ANY (ARRAY['eip155:8453'::text, 'solana'::text]))))),
    CONSTRAINT withdrawal_daily_usage_releases_evidence_ref_check CHECK ((evidence_ref <> ''::text)),
    CONSTRAINT withdrawal_daily_usage_releases_evidence_type_check CHECK ((evidence_type <> ''::text)),
    CONSTRAINT withdrawal_daily_usage_releases_released_minor_amount_check CHECK ((released_minor_amount > (0)::numeric)),
    CONSTRAINT withdrawal_daily_usage_releases_withdrawal_kind_check CHECK ((withdrawal_kind = ANY (ARRAY['wallet_withdrawal'::text, 'revenue_withdrawal'::text])))
);


--
-- Name: withdrawal_network_fee_accruals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.withdrawal_network_fee_accruals (
    withdrawal_kind text NOT NULL,
    withdrawal_id uuid NOT NULL,
    workspace_id text NOT NULL,
    fund_domain text NOT NULL,
    source_account_id uuid NOT NULL,
    environment text NOT NULL,
    network text NOT NULL,
    asset text NOT NULL,
    gross_minor_amount numeric(78,0) NOT NULL,
    net_minor_amount numeric(78,0) NOT NULL,
    fee_asset text NOT NULL,
    fee_minor_amount numeric(78,0) NOT NULL,
    fee_quote_hash text NOT NULL,
    status text NOT NULL,
    settlement_id text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT withdrawal_network_fee_accruals_check CHECK ((gross_minor_amount = (net_minor_amount + fee_minor_amount))),
    CONSTRAINT withdrawal_network_fee_accruals_fee_asset_check CHECK ((fee_asset <> ''::text)),
    CONSTRAINT withdrawal_network_fee_accruals_fee_minor_amount_check CHECK ((fee_minor_amount >= (0)::numeric)),
    CONSTRAINT withdrawal_network_fee_accruals_fee_quote_hash_check CHECK ((fee_quote_hash <> ''::text)),
    CONSTRAINT withdrawal_network_fee_accruals_fund_domain_check CHECK ((fund_domain = ANY (ARRAY['workspace_funding'::text, 'platform_revenue'::text]))),
    CONSTRAINT withdrawal_network_fee_accruals_gross_minor_amount_check CHECK ((gross_minor_amount > (0)::numeric)),
    CONSTRAINT withdrawal_network_fee_accruals_net_minor_amount_check CHECK ((net_minor_amount > (0)::numeric)),
    CONSTRAINT withdrawal_network_fee_accruals_status_check CHECK ((status = ANY (ARRAY['reserved'::text, 'submitted_unknown'::text, 'confirmed_accrued'::text, 'settlement_pending'::text, 'settled'::text, 'released'::text, 'manual_review'::text]))),
    CONSTRAINT withdrawal_network_fee_accruals_withdrawal_kind_check CHECK ((withdrawal_kind = ANY (ARRAY['wallet_withdrawal'::text, 'revenue_withdrawal'::text, 'platform_fee_withdrawal'::text])))
);


--
-- Name: workspace_insights_score_formula; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workspace_insights_score_formula (
    workspace_id uuid NOT NULL,
    base_score smallint DEFAULT 100 NOT NULL,
    grade_boundaries jsonb NOT NULL,
    veto_cap jsonb NOT NULL,
    config_version integer DEFAULT 1 NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by_user_id uuid
);


--
-- Name: TABLE workspace_insights_score_formula; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.workspace_insights_score_formula IS 'Per-workspace AI Insights scoring: base score, grade boundaries JSON, veto_cap JSON (criticalCap/warningCap for W3/W5).';


--
-- Name: COLUMN workspace_insights_score_formula.grade_boundaries; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.workspace_insights_score_formula.grade_boundaries IS 'e.g. {"S":120,"A":90,"B":70,"C":60}';


--
-- Name: COLUMN workspace_insights_score_formula.veto_cap; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.workspace_insights_score_formula.veto_cap IS 'e.g. {"criticalCap":59,"warningCap":79}';


--
-- Name: workspace_insights_signal_setting; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workspace_insights_signal_setting (
    workspace_id uuid NOT NULL,
    signal_id character varying(8) NOT NULL,
    enabled boolean NOT NULL,
    weight numeric(6,2) NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE workspace_insights_signal_setting; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.workspace_insights_signal_setting IS 'Workspace overrides for AI Insights signals; weight is positive, sign applied from insights_signal_definition.signal_family.';


--
-- Name: workspace_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workspace_members (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    user_id uuid NOT NULL,
    role public.workspace_member_role_enum DEFAULT 'member'::public.workspace_member_role_enum NOT NULL,
    invited_by uuid,
    joined_at timestamp with time zone DEFAULT now() NOT NULL,
    last_active_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: workspace_revenue_balances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workspace_revenue_balances (
    workspace_id uuid NOT NULL,
    network text NOT NULL,
    asset text NOT NULL,
    pending_amount numeric(38,8) DEFAULT 0 NOT NULL,
    available_amount numeric(38,8) DEFAULT 0 NOT NULL,
    total_gross_amount numeric(38,8) DEFAULT 0 NOT NULL,
    total_fee_amount numeric(38,8) DEFAULT 0 NOT NULL,
    total_confirmed_net_amount numeric(38,8) DEFAULT 0 NOT NULL,
    version bigint DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    environment text NOT NULL,
    CONSTRAINT workspace_revenue_balances_asset_check CHECK ((asset <> ''::text)),
    CONSTRAINT workspace_revenue_balances_available_amount_check CHECK ((available_amount >= (0)::numeric)),
    CONSTRAINT workspace_revenue_balances_network_check CHECK ((network <> ''::text)),
    CONSTRAINT workspace_revenue_balances_pending_amount_check CHECK ((pending_amount >= (0)::numeric)),
    CONSTRAINT workspace_revenue_balances_total_confirmed_net_amount_check CHECK ((total_confirmed_net_amount >= (0)::numeric)),
    CONSTRAINT workspace_revenue_balances_total_fee_amount_check CHECK ((total_fee_amount >= (0)::numeric)),
    CONSTRAINT workspace_revenue_balances_total_gross_amount_check CHECK ((total_gross_amount >= (0)::numeric)),
    CONSTRAINT workspace_revenue_balances_version_check CHECK ((version >= 0))
);


--
-- Name: workspace_wallet_balances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workspace_wallet_balances (
    workspace_id text NOT NULL,
    environment text NOT NULL,
    network text NOT NULL,
    asset text NOT NULL,
    available_amount numeric(78,0) DEFAULT 0 NOT NULL,
    pending_amount numeric(78,0) DEFAULT 0 NOT NULL,
    reserved_amount numeric(78,0) DEFAULT 0 NOT NULL,
    version bigint DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT workspace_wallet_balances_asset_check CHECK ((asset <> ''::text)),
    CONSTRAINT workspace_wallet_balances_available_amount_check CHECK ((available_amount >= (0)::numeric)),
    CONSTRAINT workspace_wallet_balances_environment_check CHECK ((environment <> ''::text)),
    CONSTRAINT workspace_wallet_balances_network_check CHECK ((network <> ''::text)),
    CONSTRAINT workspace_wallet_balances_pending_amount_check CHECK ((pending_amount >= (0)::numeric)),
    CONSTRAINT workspace_wallet_balances_reserved_amount_check CHECK ((reserved_amount >= (0)::numeric)),
    CONSTRAINT workspace_wallet_balances_version_check CHECK ((version >= 0)),
    CONSTRAINT workspace_wallet_balances_workspace_id_check CHECK ((workspace_id <> ''::text)),
    CONSTRAINT wwb_protocol_network_chk CHECK (((environment <> ALL (ARRAY['sandbox'::text, 'production'::text, 'test'::text])) OR ((environment = ANY (ARRAY['sandbox'::text, 'test'::text])) AND (network = ANY (ARRAY['eip155:84532'::text, 'solana-devnet'::text]))) OR ((environment = 'production'::text) AND (network = ANY (ARRAY['eip155:8453'::text, 'solana'::text])))))
);


--
-- Name: workspaces; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workspaces (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(100) NOT NULL,
    slug character varying(63) NOT NULL,
    type public.workspace_type_enum DEFAULT 'personal'::public.workspace_type_enum NOT NULL,
    owner_id uuid NOT NULL,
    logo_url text,
    billing_email text,
    settings jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    daily_budget_usd numeric(12,2) DEFAULT NULL::numeric
);


--
-- Name: x402_chain_networks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_chain_networks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    network text NOT NULL,
    caip2_namespace text NOT NULL,
    caip2_reference text NOT NULL,
    chain_id bigint,
    slug text NOT NULL,
    display_name text NOT NULL,
    environment text NOT NULL,
    is_testnet boolean DEFAULT false NOT NULL,
    native_currency_symbol text NOT NULL,
    native_currency_decimals integer DEFAULT 18 NOT NULL,
    rpc_url text,
    block_explorer_url text,
    default_facilitator text DEFAULT 'coinbase'::text NOT NULL,
    x402_enabled boolean DEFAULT true NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT x402_chain_networks_environment_check CHECK ((environment = ANY (ARRAY['mainnet'::text, 'testnet'::text, 'local'::text, 'sandbox'::text]))),
    CONSTRAINT x402_chain_networks_evm_network_check CHECK (((caip2_namespace <> 'eip155'::text) OR (network = ((caip2_namespace || ':'::text) || caip2_reference)))),
    CONSTRAINT x402_chain_networks_native_currency_decimals_check CHECK (((native_currency_decimals >= 0) AND (native_currency_decimals <= 255))),
    CONSTRAINT x402_chain_networks_status_check CHECK ((status = ANY (ARRAY['active'::text, 'disabled'::text, 'deprecated'::text])))
);


--
-- Name: x402_endpoint_market_listings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_endpoint_market_listings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    endpoint_id uuid NOT NULL,
    channel text NOT NULL,
    status public.x402_market_status_enum DEFAULT 'not_listed'::public.x402_market_status_enum NOT NULL,
    external_listing_id text,
    last_sync_error text,
    last_synced_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: x402_endpoint_networks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_endpoint_networks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    endpoint_id uuid NOT NULL,
    network text NOT NULL,
    receive_wallet_id uuid,
    system_wallet_address text,
    collection_mode text NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT x402_endpoint_networks_check CHECK ((((collection_mode = 'workspace_wallet'::text) AND (receive_wallet_id IS NOT NULL) AND (system_wallet_address IS NULL)) OR ((collection_mode = 'alephant_system_wallet'::text) AND (receive_wallet_id IS NULL) AND (system_wallet_address IS NOT NULL)))),
    CONSTRAINT x402_endpoint_networks_collection_mode_check CHECK ((collection_mode = ANY (ARRAY['workspace_wallet'::text, 'alephant_system_wallet'::text]))),
    CONSTRAINT x402_endpoint_networks_network_check CHECK ((network = ANY (ARRAY['eip155:8453'::text, 'eip155:84532'::text, 'solana'::text, 'solana-devnet'::text])))
);


--
-- Name: x402_endpoint_policies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_endpoint_policies (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    name text NOT NULL,
    buyer_access text DEFAULT 'public'::text NOT NULL,
    rate_limit_rpm integer DEFAULT 100 NOT NULL,
    max_request_size integer DEFAULT 1000000 NOT NULL,
    timeout_seconds integer DEFAULT 60 NOT NULL,
    payment_retry_attempts integer DEFAULT 3 NOT NULL,
    schema_validation_required boolean DEFAULT true NOT NULL,
    facilitator text,
    min_price_amount numeric(20,8),
    min_margin_buffer numeric(20,8) DEFAULT 0.000000 NOT NULL,
    cache_billing_mode public.x402_cache_billing_mode_enum DEFAULT 'disabled'::public.x402_cache_billing_mode_enum NOT NULL,
    cache_hit_discount_bps integer DEFAULT 0 NOT NULL,
    config jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: x402_endpoint_secret_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_endpoint_secret_events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    endpoint_id uuid NOT NULL,
    secret_id uuid,
    event_type text NOT NULL,
    actor_user_id uuid,
    actor_service text,
    ip_address inet,
    user_agent text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT x402_endpoint_secret_events_event_type_check CHECK ((event_type = ANY (ARRAY['created'::text, 'displayed_once'::text, 'regenerated'::text, 'revoked'::text])))
);


--
-- Name: x402_endpoint_secrets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_endpoint_secrets (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    endpoint_id uuid NOT NULL,
    version integer NOT NULL,
    secret_prefix text DEFAULT 'whsec_'::text NOT NULL,
    secret_ciphertext bytea NOT NULL,
    secret_hash text NOT NULL,
    secret_fingerprint text NOT NULL,
    kms_key_id text NOT NULL,
    status public.x402_endpoint_secret_status_enum DEFAULT 'active'::public.x402_endpoint_secret_status_enum NOT NULL,
    view_once_displayed_at timestamp with time zone,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    revoked_by uuid,
    CONSTRAINT x402_endpoint_secrets_version_check CHECK ((version > 0))
);


--
-- Name: x402_endpoints; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_endpoints (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    agent_id uuid,
    policy_id uuid NOT NULL,
    receive_wallet_id uuid,
    status public.x402_endpoint_status_enum DEFAULT 'draft'::public.x402_endpoint_status_enum NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    category text DEFAULT ''::text NOT NULL,
    tags text[] DEFAULT ARRAY[]::text[] NOT NULL,
    method public.x402_http_method_enum DEFAULT 'POST'::public.x402_http_method_enum NOT NULL,
    path text DEFAULT '/'::text NOT NULL,
    target_kind text DEFAULT 'http_proxy'::text NOT NULL,
    original_target_url text NOT NULL,
    target_forward_method text DEFAULT 'preserve'::text NOT NULL,
    target_path_rewrite jsonb DEFAULT '{"prefix": "/", "strip_public_slug": true}'::jsonb NOT NULL,
    target_headers_policy jsonb DEFAULT '{"inject_alephant_trace": true, "forward_payment_headers": false, "inject_origin_signature": true, "origin_signature_window_seconds": 300}'::jsonb NOT NULL,
    origin_signature_required boolean DEFAULT true NOT NULL,
    active_secret_version integer DEFAULT 1 NOT NULL,
    pricing_model public.x402_pricing_model_enum DEFAULT 'per_call'::public.x402_pricing_model_enum NOT NULL,
    price_amount numeric(20,8) NOT NULL,
    session_ttl_seconds integer,
    session_included_calls integer,
    cache_ttl_seconds integer,
    asset public.x402_asset_enum DEFAULT 'USDC'::public.x402_asset_enum NOT NULL,
    network text DEFAULT 'base'::public.x402_network_enum NOT NULL,
    query_schema jsonb,
    body_schema jsonb,
    output_schema jsonb,
    example_request jsonb,
    example_response jsonb,
    response_format text DEFAULT 'JSON'::text NOT NULL,
    discoverable boolean DEFAULT false NOT NULL,
    market_status public.x402_market_status_enum DEFAULT 'not_listed'::public.x402_market_status_enum NOT NULL,
    schema_status text DEFAULT 'configured'::text NOT NULL,
    snapshot_revision bigint DEFAULT 1 NOT NULL,
    published_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    endpoint_type public.x402_endpoint_type_enum DEFAULT 'agent'::public.x402_endpoint_type_enum NOT NULL,
    CONSTRAINT chk_x402_endpoints_http_api_without_agent CHECK (((endpoint_type <> 'http_api'::public.x402_endpoint_type_enum) OR (agent_id IS NULL))),
    CONSTRAINT x402_endpoints_cache_ttl_seconds_check CHECK (((cache_ttl_seconds IS NULL) OR (cache_ttl_seconds > 0))),
    CONSTRAINT x402_endpoints_check CHECK (((pricing_model = 'per_call'::public.x402_pricing_model_enum) OR (session_ttl_seconds IS NOT NULL) OR (session_included_calls IS NOT NULL))),
    CONSTRAINT x402_endpoints_network_known_chk CHECK ((network = ANY (ARRAY['eip155:8453'::text, 'eip155:84532'::text, 'solana'::text, 'solana-devnet'::text]))),
    CONSTRAINT x402_endpoints_path_check CHECK ((path ~~ '/%'::text)),
    CONSTRAINT x402_endpoints_price_amount_publish_chk CHECK (((status = 'draft'::public.x402_endpoint_status_enum) OR (price_amount >= (0)::numeric))),
    CONSTRAINT x402_endpoints_session_included_calls_check CHECK (((session_included_calls IS NULL) OR (session_included_calls > 0))),
    CONSTRAINT x402_endpoints_session_ttl_seconds_check CHECK (((session_ttl_seconds IS NULL) OR (session_ttl_seconds > 0))),
    CONSTRAINT x402_endpoints_target_kind_check CHECK ((target_kind = ANY (ARRAY['http_proxy'::text, 'gateway_route'::text])))
);


--
-- Name: x402_facilitator_attempts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_facilitator_attempts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    activity_id uuid NOT NULL,
    facilitator text NOT NULL,
    operation text NOT NULL,
    request_hash text NOT NULL,
    response_code integer,
    response_body jsonb DEFAULT '{}'::jsonb NOT NULL,
    error text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: x402_network_provider_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_network_provider_settings (
    workspace_id text NOT NULL,
    preferred_facilitator text DEFAULT 'coinbase'::text NOT NULL,
    network text DEFAULT 'eip155:84532'::text NOT NULL,
    asset text DEFAULT 'USDC'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: x402_outbound_result_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_outbound_result_keys (
    result_key text NOT NULL,
    outbound_spend_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: x402_outbound_spends; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_outbound_spends (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    agent_id uuid NOT NULL,
    trace_id text,
    external_host text NOT NULL,
    external_path text NOT NULL,
    protocol text DEFAULT 'x402'::text NOT NULL,
    amount numeric(20,8) NOT NULL,
    asset text DEFAULT 'USDC'::text NOT NULL,
    network text NOT NULL,
    status public.x402_outbound_status_enum DEFAULT 'pending'::public.x402_outbound_status_enum NOT NULL,
    policy_decision jsonb DEFAULT '{}'::jsonb NOT NULL,
    tx_hash text,
    failure_reason text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    settled_at timestamp with time zone
);


--
-- Name: x402_payment_idempotency_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_payment_idempotency_keys (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    endpoint_id uuid,
    request_hash text NOT NULL,
    payment_nonce text,
    payment_signature_hash text,
    activity_id uuid NOT NULL,
    status text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    payment_payload text
);


--
-- Name: x402_payment_service_result_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_payment_service_result_keys (
    result_key text NOT NULL,
    activity_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: x402_payout_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_payout_requests (
    id text NOT NULL,
    workspace_id text NOT NULL,
    amount numeric(20,8) NOT NULL,
    asset text DEFAULT 'USDC'::text NOT NULL,
    network text NOT NULL,
    destination_wallet_address text NOT NULL,
    status text DEFAULT 'requested'::text NOT NULL,
    idempotency_key text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    cancelled_at timestamp with time zone
);


--
-- Name: x402_platform_wallets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_platform_wallets (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    environment text DEFAULT 'production'::text NOT NULL,
    revision integer DEFAULT 1 NOT NULL,
    network text NOT NULL,
    asset text DEFAULT 'USDC'::text NOT NULL,
    token_address text NOT NULL,
    receive_wallet_address text NOT NULL,
    fee_wallet_address text NOT NULL,
    fee_bps integer DEFAULT 500 NOT NULL,
    min_payout_amount numeric(20,8) DEFAULT 100.000000 NOT NULL,
    max_payout_delay_seconds integer DEFAULT 86400 NOT NULL,
    payout_mode text DEFAULT 'admin_triggered'::text NOT NULL,
    status public.x402_platform_wallet_status_enum DEFAULT 'active'::public.x402_platform_wallet_status_enum NOT NULL,
    last_observed_balance numeric(20,8) DEFAULT 0 NOT NULL,
    last_reconciled_at timestamp with time zone,
    last_payout_id uuid,
    last_payout_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT x402_platform_wallets_fee_bps_check CHECK ((fee_bps = 500)),
    CONSTRAINT x402_platform_wallets_max_payout_delay_seconds_check CHECK ((max_payout_delay_seconds > 0)),
    CONSTRAINT x402_platform_wallets_min_payout_amount_check CHECK ((min_payout_amount > (0)::numeric)),
    CONSTRAINT x402_platform_wallets_payout_mode_check CHECK ((payout_mode = ANY (ARRAY['admin_triggered'::text, 'scheduled'::text, 'seller_requested'::text])))
);


--
-- Name: x402_receive_wallet_challenges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_receive_wallet_challenges (
    id text NOT NULL,
    workspace_id text NOT NULL,
    wallet_address text NOT NULL,
    network text NOT NULL,
    message text NOT NULL,
    expected_signature text NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: x402_receive_wallets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_receive_wallets (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    name text NOT NULL,
    address text NOT NULL,
    network text NOT NULL,
    asset public.x402_asset_enum DEFAULT 'USDC'::public.x402_asset_enum NOT NULL,
    type public.x402_wallet_type_enum DEFAULT 'external'::public.x402_wallet_type_enum NOT NULL,
    verification_status public.x402_wallet_verification_enum DEFAULT 'unverified'::public.x402_wallet_verification_enum NOT NULL,
    status public.x402_wallet_status_enum DEFAULT 'active'::public.x402_wallet_status_enum NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    verification_payload jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT x402_receive_wallets_network_known_chk CHECK ((network = ANY (ARRAY['eip155:8453'::text, 'eip155:84532'::text, 'solana'::text, 'solana-devnet'::text])))
);


--
-- Name: x402_revenue_withdrawal_reservation_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_revenue_withdrawal_reservation_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    reservation_id uuid CONSTRAINT x402_revenue_withdrawal_reservation_ite_reservation_id_not_null NOT NULL,
    activity_id uuid NOT NULL,
    workspace_id uuid NOT NULL,
    endpoint_id uuid,
    allocated_amount numeric(20,8) CONSTRAINT x402_revenue_withdrawal_reservation_i_allocated_amount_not_null NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT x402_revenue_withdrawal_reservation_item_allocated_amount_check CHECK ((allocated_amount > (0)::numeric))
);


--
-- Name: x402_revenue_withdrawal_reservations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_revenue_withdrawal_reservations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    payout_id uuid NOT NULL,
    idempotency_key text NOT NULL,
    request_hash text NOT NULL,
    network text NOT NULL,
    asset text NOT NULL,
    amount numeric(20,8) NOT NULL,
    destination_wallet_id uuid CONSTRAINT x402_revenue_withdrawal_reservat_destination_wallet_id_not_null NOT NULL,
    destination_address text CONSTRAINT x402_revenue_withdrawal_reservatio_destination_address_not_null NOT NULL,
    status text DEFAULT 'reserved'::text NOT NULL,
    payment_service_withdrawal_id text,
    payment_service_status text,
    created_by_user_id uuid CONSTRAINT x402_revenue_withdrawal_reservation_created_by_user_id_not_null NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    released_at timestamp with time zone,
    confirmed_at timestamp with time zone,
    expires_at timestamp with time zone NOT NULL,
    CONSTRAINT x402_revenue_withdrawal_reservations_amount_check CHECK ((amount > (0)::numeric)),
    CONSTRAINT x402_revenue_withdrawal_reservations_status_check CHECK ((status = ANY (ARRAY['reserved'::text, 'submitted'::text, 'manual_review'::text, 'sync_required'::text, 'confirmed'::text, 'released'::text, 'failed'::text])))
);


--
-- Name: x402_settlements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_settlements (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    activity_id uuid NOT NULL,
    endpoint_id uuid NOT NULL,
    receive_wallet_address text NOT NULL,
    fee_wallet_address text NOT NULL,
    ale_receive_wallet_address text CONSTRAINT x402_settlements_split_contract_address_not_null NOT NULL,
    split_treasury_id uuid,
    network text NOT NULL,
    gross_amount numeric(20,8) NOT NULL,
    fee_amount numeric(20,8) NOT NULL,
    net_amount numeric(20,8) NOT NULL,
    fee_bps integer DEFAULT 500 NOT NULL,
    tx_hash text,
    block_number bigint,
    status public.x402_split_status_enum DEFAULT 'pending_chain'::public.x402_split_status_enum NOT NULL,
    failure_reason text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    confirmed_at timestamp with time zone,
    asset text DEFAULT 'USDC'::text NOT NULL,
    CONSTRAINT x402_settlements_asset_nonempty_chk CHECK ((asset <> ''::text))
);


--
-- Name: x402_spend_agent_bindings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_spend_agent_bindings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    agent_id uuid NOT NULL,
    policy_id uuid NOT NULL,
    default_protocol text DEFAULT 'x402'::text NOT NULL,
    allowed_protocols text[] DEFAULT ARRAY['x402'::text] NOT NULL,
    allowed_endpoint_ids uuid[] DEFAULT ARRAY[]::uuid[] NOT NULL,
    paused boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: x402_spend_policies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_spend_policies (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    name text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    daily_cap numeric(20,8) DEFAULT 25 NOT NULL,
    monthly_cap numeric(20,8) DEFAULT 600 NOT NULL,
    max_per_request numeric(20,8) DEFAULT 1 NOT NULL,
    rpm integer DEFAULT 60 NOT NULL,
    retries integer DEFAULT 2 NOT NULL,
    allowed_endpoint_ids uuid[] DEFAULT ARRAY[]::uuid[] NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: x402_spend_wallet_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_spend_wallet_accounts (
    id text NOT NULL,
    workspace_id text NOT NULL,
    network text NOT NULL,
    asset text DEFAULT 'USDC'::text NOT NULL,
    spend_wallet_address text NOT NULL,
    private_key_ref text,
    available_amount numeric(20,8) DEFAULT 0 NOT NULL,
    pending_amount numeric(20,8) DEFAULT 0 NOT NULL,
    held_amount numeric(20,8) DEFAULT 0 NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    paused boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: x402_spend_wallet_movements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_spend_wallet_movements (
    id text NOT NULL,
    account_id text NOT NULL,
    workspace_id text NOT NULL,
    movement_type text NOT NULL,
    amount numeric(20,8) NOT NULL,
    outbound_spend_id text,
    top_up_intent_id text,
    idempotency_key text NOT NULL,
    balance_after_available numeric(20,8) NOT NULL,
    balance_after_pending numeric(20,8) NOT NULL,
    balance_after_held numeric(20,8) NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: x402_spend_wallet_top_up_intents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_spend_wallet_top_up_intents (
    id text NOT NULL,
    account_id text NOT NULL,
    workspace_id text NOT NULL,
    network text NOT NULL,
    asset text DEFAULT 'USDC'::text NOT NULL,
    amount numeric(20,8) NOT NULL,
    status text DEFAULT 'created'::text NOT NULL,
    funding_address text,
    provider text,
    provider_reference text,
    tx_hash text,
    expires_at timestamp with time zone,
    confirmed_at timestamp with time zone,
    failure_reason text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: x402_split_sweep_batches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_split_sweep_batches (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    split_treasury_id uuid NOT NULL,
    network text NOT NULL,
    asset text DEFAULT 'USDC'::text NOT NULL,
    activity_count integer DEFAULT 0 NOT NULL,
    recipient_count integer DEFAULT 0 NOT NULL,
    gross_amount numeric(20,8) NOT NULL,
    fee_amount numeric(20,8) NOT NULL,
    net_amount numeric(20,8) NOT NULL,
    distribution_root text NOT NULL,
    estimated_gas_units bigint,
    estimated_gas_cost numeric(20,8),
    gas_price_wei numeric(78,0),
    tx_hash text,
    status public.x402_sweep_status_enum DEFAULT 'quoted'::public.x402_sweep_status_enum NOT NULL,
    skip_reason text,
    failure_reason text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    submitted_at timestamp with time zone,
    confirmed_at timestamp with time zone,
    CONSTRAINT x402_split_sweep_batches_check CHECK ((fee_amount = (gross_amount * 0.05))),
    CONSTRAINT x402_split_sweep_batches_check1 CHECK ((net_amount = (gross_amount * 0.95)))
);


--
-- Name: x402_split_sweep_distributions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_split_sweep_distributions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    batch_id uuid NOT NULL,
    workspace_id uuid NOT NULL,
    endpoint_id uuid,
    receive_wallet_address text NOT NULL,
    activity_ids uuid[] DEFAULT ARRAY[]::uuid[] NOT NULL,
    activity_count integer DEFAULT 0 NOT NULL,
    gross_amount numeric(20,8) NOT NULL,
    fee_amount numeric(20,8) NOT NULL,
    net_amount numeric(20,8) NOT NULL,
    tx_log_index integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT x402_split_sweep_distributions_check CHECK ((fee_amount = (gross_amount * 0.05))),
    CONSTRAINT x402_split_sweep_distributions_check1 CHECK ((net_amount = (gross_amount * 0.95)))
);


--
-- Name: x402_split_treasuries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_split_treasuries (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    environment text DEFAULT 'production'::text NOT NULL,
    revision integer DEFAULT 1 NOT NULL,
    network text NOT NULL,
    asset text DEFAULT 'USDC'::text NOT NULL,
    token_address text NOT NULL,
    treasury_address text NOT NULL,
    implementation_address text,
    factory_address text,
    fee_wallet_address text NOT NULL,
    fee_bps integer DEFAULT 500 NOT NULL,
    min_sweep_amount numeric(20,8) DEFAULT 100.000000 NOT NULL,
    max_sweep_delay_seconds integer DEFAULT 86400 NOT NULL,
    sweep_margin_buffer numeric(20,8) DEFAULT 0.000000 NOT NULL,
    distribution_mode text DEFAULT 'operator_batch'::text NOT NULL,
    distribution_root text,
    status public.x402_split_treasury_status_enum DEFAULT 'pending_deploy'::public.x402_split_treasury_status_enum NOT NULL,
    deploy_tx_hash text,
    last_chain_balance numeric(20,8) DEFAULT 0 NOT NULL,
    last_sweep_batch_id uuid,
    last_swept_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT x402_split_treasuries_distribution_mode_check CHECK ((distribution_mode = ANY (ARRAY['operator_batch'::text, 'merkle_claim'::text]))),
    CONSTRAINT x402_split_treasuries_fee_bps_check CHECK ((fee_bps = 500)),
    CONSTRAINT x402_split_treasuries_max_sweep_delay_seconds_check CHECK ((max_sweep_delay_seconds > 0)),
    CONSTRAINT x402_split_treasuries_min_sweep_amount_check CHECK ((min_sweep_amount > (0)::numeric))
);


--
-- Name: x402_system_wallets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_system_wallets (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    network text NOT NULL,
    address text NOT NULL,
    label text NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT x402_system_wallets_network_check CHECK ((network = ANY (ARRAY['eip155:8453'::text, 'eip155:84532'::text, 'solana'::text, 'solana-devnet'::text])))
);


--
-- Name: x402_wallet_verification_challenges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_wallet_verification_challenges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    workspace_id uuid NOT NULL,
    wallet_id uuid,
    address text NOT NULL,
    network text NOT NULL,
    challenge text NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    signature text,
    expires_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    completed_at timestamp with time zone
);


--
-- Name: x402_workspace_payment_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_workspace_payment_settings (
    workspace_id uuid NOT NULL,
    default_facilitator text DEFAULT 'coinbase'::text NOT NULL,
    default_network public.x402_network_enum DEFAULT 'base'::public.x402_network_enum NOT NULL,
    default_asset public.x402_asset_enum DEFAULT 'USDC'::public.x402_asset_enum NOT NULL,
    fee_bps integer DEFAULT 500 NOT NULL,
    fee_receive_wallet text,
    split_contract_address text,
    facilitator_fee_estimate numeric(20,8) DEFAULT 0.001000 CONSTRAINT x402_workspace_payment_settin_facilitator_fee_estimate_not_null NOT NULL,
    network_cost_estimate numeric(20,8) DEFAULT 0.000000 NOT NULL,
    internal_cost_estimate numeric(20,8) DEFAULT 0.000000 NOT NULL,
    required_margin_buffer numeric(20,8) DEFAULT 0.000000 NOT NULL,
    settings jsonb DEFAULT '{}'::jsonb NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT x402_workspace_payment_settings_fee_bps_check CHECK ((fee_bps = 500))
);


--
-- Name: x402_workspace_spend_ceilings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.x402_workspace_spend_ceilings (
    workspace_id uuid NOT NULL,
    workspace_daily numeric(20,8) DEFAULT 200 NOT NULL,
    workspace_monthly numeric(20,8) DEFAULT 5000 NOT NULL,
    department_daily numeric(20,8) DEFAULT 100 NOT NULL,
    department_monthly numeric(20,8) DEFAULT 2500 NOT NULL,
    observation_enabled boolean DEFAULT true NOT NULL,
    auto_pause_enabled boolean DEFAULT true NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: domain_notification_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.domain_notification_events ALTER COLUMN id SET DEFAULT nextval('public.domain_notification_events_id_seq'::regclass);


--
-- Name: notification_delivery_tasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_delivery_tasks ALTER COLUMN id SET DEFAULT nextval('public.notification_delivery_tasks_id_seq'::regclass);


--
-- Name: payment_operation_traces id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_operation_traces ALTER COLUMN id SET DEFAULT nextval('public.payment_operation_traces_id_seq'::regclass);


--
-- Name: policy_eval_traces id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.policy_eval_traces ALTER COLUMN id SET DEFAULT nextval('public.policy_eval_traces_id_seq'::regclass);


--
-- Name: active_alerts active_alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_alerts
    ADD CONSTRAINT active_alerts_pkey PRIMARY KEY (id);


--
-- Name: agent_allowed_models agent_allowed_models_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent_allowed_models
    ADD CONSTRAINT agent_allowed_models_pkey PRIMARY KEY (id);


--
-- Name: agent_policy_bindings agent_policy_bindings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent_policy_bindings
    ADD CONSTRAINT agent_policy_bindings_pkey PRIMARY KEY (id);


--
-- Name: agent_runtime_configs agent_runtime_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent_runtime_configs
    ADD CONSTRAINT agent_runtime_configs_pkey PRIMARY KEY (agent_id);


--
-- Name: agent_stream_keys agent_stream_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent_stream_keys
    ADD CONSTRAINT agent_stream_keys_pkey PRIMARY KEY (id);


--
-- Name: agents agents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents
    ADD CONSTRAINT agents_pkey PRIMARY KEY (id);


--
-- Name: alephant_settings alephant_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alephant_settings
    ADD CONSTRAINT alephant_settings_pkey PRIMARY KEY (id);


--
-- Name: alephant_settings alephant_settings_unique_name; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alephant_settings
    ADD CONSTRAINT alephant_settings_unique_name UNIQUE (name);


--
-- Name: alert_rules alert_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alert_rules
    ADD CONSTRAINT alert_rules_pkey PRIMARY KEY (id);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: domain_notification_events domain_notification_events_idempotency_key_uq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.domain_notification_events
    ADD CONSTRAINT domain_notification_events_idempotency_key_uq UNIQUE (idempotency_key);


--
-- Name: domain_notification_events domain_notification_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.domain_notification_events
    ADD CONSTRAINT domain_notification_events_pkey PRIMARY KEY (id);


--
-- Name: external_endpoints external_endpoints_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.external_endpoints
    ADD CONSTRAINT external_endpoints_pkey PRIMARY KEY (id);


--
-- Name: insights_signal_definition insights_signal_definition_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.insights_signal_definition
    ADD CONSTRAINT insights_signal_definition_pkey PRIMARY KEY (signal_id);


--
-- Name: invitations invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT invitations_pkey PRIMARY KEY (id);


--
-- Name: invoice_line_items invoice_line_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_line_items
    ADD CONSTRAINT invoice_line_items_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


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
-- Name: log_overage_reports log_overage_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.log_overage_reports
    ADD CONSTRAINT log_overage_reports_pkey PRIMARY KEY (id);


--
-- Name: log_overage_reports log_overage_reports_stripe_identifier_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.log_overage_reports
    ADD CONSTRAINT log_overage_reports_stripe_identifier_key UNIQUE (stripe_identifier);


--
-- Name: managed_wallet_accounts managed_wallet_accounts_account_kind_chk; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.managed_wallet_accounts
    ADD CONSTRAINT managed_wallet_accounts_account_kind_chk CHECK ((account_kind = ANY (ARRAY['workspace_funding'::text, 'platform_receive'::text, 'platform_revenue'::text]))) NOT VALID;


--
-- Name: managed_wallet_accounts managed_wallet_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.managed_wallet_accounts
    ADD CONSTRAINT managed_wallet_accounts_pkey PRIMARY KEY (id);


--
-- Name: managed_wallet_accounts managed_wallet_accounts_workspace_scope_chk; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.managed_wallet_accounts
    ADD CONSTRAINT managed_wallet_accounts_workspace_scope_chk CHECK ((((account_kind = 'workspace_funding'::text) AND (workspace_id IS NOT NULL) AND (workspace_id <> ''::text)) OR ((account_kind = 'platform_receive'::text) AND (workspace_id IS NULL)) OR ((account_kind = 'platform_revenue'::text) AND (workspace_id IS NULL) AND (status = ANY (ARRAY['disabled'::text, 'closed'::text]))))) NOT VALID;


--
-- Name: managed_wallet_saas_commands managed_wallet_saas_commands_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.managed_wallet_saas_commands
    ADD CONSTRAINT managed_wallet_saas_commands_pkey PRIMARY KEY (workspace_id, operation, idempotency_key);


--
-- Name: master_key_departments master_key_departments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_key_departments
    ADD CONSTRAINT master_key_departments_pkey PRIMARY KEY (id);


--
-- Name: master_keys master_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_keys
    ADD CONSTRAINT master_keys_pkey PRIMARY KEY (id);


--
-- Name: members members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_pkey PRIMARY KEY (id);


--
-- Name: model_configs model_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.model_configs
    ADD CONSTRAINT model_configs_pkey PRIMARY KEY (id);


--
-- Name: managed_wallet_accounts mwa_managed_wallet_environment_network_chk; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.managed_wallet_accounts
    ADD CONSTRAINT mwa_managed_wallet_environment_network_chk CHECK (((environment <> ALL (ARRAY['sandbox'::text, 'production'::text])) OR ((environment = 'sandbox'::text) AND (network = ANY (ARRAY['eip155:84532'::text, 'solana-devnet'::text]))) OR ((environment = 'production'::text) AND (network = ANY (ARRAY['eip155:8453'::text, 'solana'::text]))))) NOT VALID;


--
-- Name: notification_delivery_tasks notification_delivery_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_delivery_tasks
    ADD CONSTRAINT notification_delivery_tasks_pkey PRIMARY KEY (id);


--
-- Name: notification_preferences notification_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_preferences
    ADD CONSTRAINT notification_preferences_pkey PRIMARY KEY (id);


--
-- Name: notification_preferences notification_preferences_workspace_id_channel_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_preferences
    ADD CONSTRAINT notification_preferences_workspace_id_channel_key UNIQUE (workspace_id, channel);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


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
-- Name: partner_payouts partner_payouts_partner_id_period_start_period_end_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.partner_payouts
    ADD CONSTRAINT partner_payouts_partner_id_period_start_period_end_key UNIQUE (partner_id, period_start, period_end);


--
-- Name: partner_payouts partner_payouts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.partner_payouts
    ADD CONSTRAINT partner_payouts_pkey PRIMARY KEY (id);


--
-- Name: partner_profile_models partner_profile_models_partner_id_route_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.partner_profile_models
    ADD CONSTRAINT partner_profile_models_partner_id_route_id_key UNIQUE (partner_id, route_id);


--
-- Name: partner_profile_models partner_profile_models_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.partner_profile_models
    ADD CONSTRAINT partner_profile_models_pkey PRIMARY KEY (id);


--
-- Name: partner_profiles partner_profiles_account_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.partner_profiles
    ADD CONSTRAINT partner_profiles_account_id_key UNIQUE (account_id);


--
-- Name: partner_profiles partner_profiles_partner_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.partner_profiles
    ADD CONSTRAINT partner_profiles_partner_id_key UNIQUE (partner_id);


--
-- Name: partner_profiles partner_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.partner_profiles
    ADD CONSTRAINT partner_profiles_pkey PRIMARY KEY (id);


--
-- Name: partner_profiles partner_profiles_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.partner_profiles
    ADD CONSTRAINT partner_profiles_slug_key UNIQUE (slug);


--
-- Name: payment_methods_copy1 payment_methods_copy1_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_methods_copy1
    ADD CONSTRAINT payment_methods_copy1_pkey PRIMARY KEY (id);


--
-- Name: payment_methods payment_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_pkey PRIMARY KEY (id);


--
-- Name: payment_operation_traces payment_operation_traces_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_operation_traces
    ADD CONSTRAINT payment_operation_traces_pkey PRIMARY KEY (id);


--
-- Name: payment_webhook_inbox payment_webhook_inbox_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_webhook_inbox
    ADD CONSTRAINT payment_webhook_inbox_pkey PRIMARY KEY (id);


--
-- Name: personal_access_tokens personal_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: platform_fee_withdrawal_requests platform_fee_withdrawal_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platform_fee_withdrawal_requests
    ADD CONSTRAINT platform_fee_withdrawal_requests_pkey PRIMARY KEY (id);


--
-- Name: platform_fee_withdrawals platform_fee_withdrawals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platform_fee_withdrawals
    ADD CONSTRAINT platform_fee_withdrawals_pkey PRIMARY KEY (id);


--
-- Name: platform_fee_withdrawals platform_fee_withdrawals_platform_account_required_chk; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.platform_fee_withdrawals
    ADD CONSTRAINT platform_fee_withdrawals_platform_account_required_chk CHECK ((platform_account_id IS NOT NULL)) NOT VALID;


--
-- Name: platform_revenue_balances platform_revenue_balances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platform_revenue_balances
    ADD CONSTRAINT platform_revenue_balances_pkey PRIMARY KEY (environment, network, asset, source_account_id);


--
-- Name: platform_revenue_ledger_postings platform_revenue_ledger_postings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platform_revenue_ledger_postings
    ADD CONSTRAINT platform_revenue_ledger_postings_pkey PRIMARY KEY (id);


--
-- Name: platform_revenue_ledger_transactions platform_revenue_ledger_trans_environment_network_asset_so_key1; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platform_revenue_ledger_transactions
    ADD CONSTRAINT platform_revenue_ledger_trans_environment_network_asset_so_key1 UNIQUE (environment, network, asset, source_account_id, operation_type, operation_id);


--
-- Name: platform_revenue_ledger_transactions platform_revenue_ledger_trans_environment_network_asset_sou_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platform_revenue_ledger_transactions
    ADD CONSTRAINT platform_revenue_ledger_trans_environment_network_asset_sou_key UNIQUE (environment, network, asset, source_account_id, idempotency_key);


--
-- Name: platform_revenue_ledger_transactions platform_revenue_ledger_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platform_revenue_ledger_transactions
    ADD CONSTRAINT platform_revenue_ledger_transactions_pkey PRIMARY KEY (id);


--
-- Name: policy_configs policy_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.policy_configs
    ADD CONSTRAINT policy_configs_pkey PRIMARY KEY (id);


--
-- Name: policy_eval_traces policy_eval_traces_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.policy_eval_traces
    ADD CONSTRAINT policy_eval_traces_pkey PRIMARY KEY (id);


--
-- Name: policy_overrides policy_overrides_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.policy_overrides
    ADD CONSTRAINT policy_overrides_pkey PRIMARY KEY (id);


--
-- Name: platform_revenue_balances prb_managed_wallet_environment_network_chk; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.platform_revenue_balances
    ADD CONSTRAINT prb_managed_wallet_environment_network_chk CHECK (((environment <> ALL (ARRAY['sandbox'::text, 'production'::text])) OR ((environment = 'sandbox'::text) AND (network = ANY (ARRAY['eip155:84532'::text, 'solana-devnet'::text]))) OR ((environment = 'production'::text) AND (network = ANY (ARRAY['eip155:8453'::text, 'solana'::text]))))) NOT VALID;


--
-- Name: private_deployment_contracts private_deployment_contracts_contract_no_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.private_deployment_contracts
    ADD CONSTRAINT private_deployment_contracts_contract_no_key UNIQUE (contract_no);


--
-- Name: private_deployment_contracts private_deployment_contracts_customer_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.private_deployment_contracts
    ADD CONSTRAINT private_deployment_contracts_customer_code_key UNIQUE (customer_code);


--
-- Name: private_deployment_contracts private_deployment_contracts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.private_deployment_contracts
    ADD CONSTRAINT private_deployment_contracts_pkey PRIMARY KEY (id);


--
-- Name: private_deployment_licenses private_deployment_licenses_contract_id_idempotency_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.private_deployment_licenses
    ADD CONSTRAINT private_deployment_licenses_contract_id_idempotency_key_key UNIQUE (contract_id, idempotency_key);


--
-- Name: private_deployment_licenses private_deployment_licenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.private_deployment_licenses
    ADD CONSTRAINT private_deployment_licenses_pkey PRIMARY KEY (id);


--
-- Name: platform_revenue_ledger_transactions prlt_managed_wallet_environment_network_chk; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.platform_revenue_ledger_transactions
    ADD CONSTRAINT prlt_managed_wallet_environment_network_chk CHECK (((environment <> ALL (ARRAY['sandbox'::text, 'production'::text])) OR ((environment = 'sandbox'::text) AND (network = ANY (ARRAY['eip155:84532'::text, 'solana-devnet'::text]))) OR ((environment = 'production'::text) AND (network = ANY (ARRAY['eip155:8453'::text, 'solana'::text]))))) NOT VALID;


--
-- Name: prompt_bindings prompt_bindings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prompt_bindings
    ADD CONSTRAINT prompt_bindings_pkey PRIMARY KEY (id);


--
-- Name: prompt_templates prompt_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prompt_templates
    ADD CONSTRAINT prompt_templates_pkey PRIMARY KEY (id);


--
-- Name: prompt_versions prompt_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prompt_versions
    ADD CONSTRAINT prompt_versions_pkey PRIMARY KEY (id);


--
-- Name: provider_configs provider_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provider_configs
    ADD CONSTRAINT provider_configs_pkey PRIMARY KEY (id);


--
-- Name: provider_models provider_models_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provider_models
    ADD CONSTRAINT provider_models_pkey PRIMARY KEY (id);


--
-- Name: providers providers_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.providers
    ADD CONSTRAINT providers_code_key UNIQUE (code);


--
-- Name: providers providers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.providers
    ADD CONSTRAINT providers_pkey PRIMARY KEY (id);


--
-- Name: refresh_sessions refresh_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_sessions
    ADD CONSTRAINT refresh_sessions_pkey PRIMARY KEY (id);


--
-- Name: revenue_reservation_consumptions revenue_reservation_consumptio_workspace_id_idempotency_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revenue_reservation_consumptions
    ADD CONSTRAINT revenue_reservation_consumptio_workspace_id_idempotency_key_key UNIQUE (workspace_id, idempotency_key);


--
-- Name: revenue_reservation_consumptions revenue_reservation_consumptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revenue_reservation_consumptions
    ADD CONSTRAINT revenue_reservation_consumptions_pkey PRIMARY KEY (workspace_id, revenue_reservation_id);


--
-- Name: revenue_withdrawals revenue_withdrawals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revenue_withdrawals
    ADD CONSTRAINT revenue_withdrawals_pkey PRIMARY KEY (id);


--
-- Name: revenue_withdrawals revenue_withdrawals_provider_provider_idempotency_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revenue_withdrawals
    ADD CONSTRAINT revenue_withdrawals_provider_provider_idempotency_key_key UNIQUE (provider, provider_idempotency_key);


--
-- Name: revenue_withdrawals revenue_withdrawals_workspace_id_idempotency_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revenue_withdrawals
    ADD CONSTRAINT revenue_withdrawals_workspace_id_idempotency_key_key UNIQUE (workspace_id, idempotency_key);


--
-- Name: revenue_withdrawals revenue_withdrawals_workspace_id_revenue_reservation_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revenue_withdrawals
    ADD CONSTRAINT revenue_withdrawals_workspace_id_revenue_reservation_id_key UNIQUE (workspace_id, revenue_reservation_id);


--
-- Name: revenue_reservation_consumptions rrc_managed_wallet_environment_network_chk; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.revenue_reservation_consumptions
    ADD CONSTRAINT rrc_managed_wallet_environment_network_chk CHECK (((environment <> ALL (ARRAY['sandbox'::text, 'production'::text])) OR ((environment = 'sandbox'::text) AND (network = ANY (ARRAY['eip155:84532'::text, 'solana-devnet'::text]))) OR ((environment = 'production'::text) AND (network = ANY (ARRAY['eip155:8453'::text, 'solana'::text]))))) NOT VALID;


--
-- Name: revenue_withdrawals rw_managed_wallet_environment_network_chk; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.revenue_withdrawals
    ADD CONSTRAINT rw_managed_wallet_environment_network_chk CHECK (((environment <> ALL (ARRAY['sandbox'::text, 'production'::text])) OR ((environment = 'sandbox'::text) AND (network = ANY (ARRAY['eip155:84532'::text, 'solana-devnet'::text]))) OR ((environment = 'production'::text) AND (network = ANY (ARRAY['eip155:8453'::text, 'solana'::text]))))) NOT VALID;


--
-- Name: sales_leads sales_leads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales_leads
    ADD CONSTRAINT sales_leads_pkey PRIMARY KEY (id);


--
-- Name: subscription_events subscription_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscription_events
    ADD CONSTRAINT subscription_events_pkey PRIMARY KEY (id);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: sync_watermarks sync_watermarks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sync_watermarks
    ADD CONSTRAINT sync_watermarks_pkey PRIMARY KEY (sync_key);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: agent_allowed_models uq_agent_model; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent_allowed_models
    ADD CONSTRAINT uq_agent_model UNIQUE (agent_id, model_id);


--
-- Name: invitations uq_invitation_token; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT uq_invitation_token UNIQUE (token);


--
-- Name: invoices uq_invoices_stripe_invoice_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT uq_invoices_stripe_invoice_id UNIQUE (stripe_invoice_id);


--
-- Name: master_key_departments uq_mk_dept; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_key_departments
    ADD CONSTRAINT uq_mk_dept UNIQUE (master_key_id, department_id);


--
-- Name: model_configs uq_model_config; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.model_configs
    ADD CONSTRAINT uq_model_config UNIQUE (workspace_id, provider_id, model_id);


--
-- Name: personal_access_tokens uq_pat_hash; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT uq_pat_hash UNIQUE (token_hash);


--
-- Name: policy_overrides uq_policy_overrides_workspace_department; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.policy_overrides
    ADD CONSTRAINT uq_policy_overrides_workspace_department UNIQUE (workspace_id, department_id);


--
-- Name: prompt_bindings uq_prompt_binding; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prompt_bindings
    ADD CONSTRAINT uq_prompt_binding UNIQUE (template_id, entity_type, entity_id);


--
-- Name: prompt_versions uq_prompt_version; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prompt_versions
    ADD CONSTRAINT uq_prompt_version UNIQUE (template_id, version);


--
-- Name: prompt_templates uq_prompt_workspace_slug; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prompt_templates
    ADD CONSTRAINT uq_prompt_workspace_slug UNIQUE (workspace_id, slug);


--
-- Name: provider_configs uq_provider_config; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provider_configs
    ADD CONSTRAINT uq_provider_config UNIQUE (workspace_id, provider_id);


--
-- Name: provider_models uq_provider_model; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provider_models
    ADD CONSTRAINT uq_provider_model UNIQUE (provider_id, model_id);


--
-- Name: subscriptions uq_subscription_ws; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT uq_subscription_ws UNIQUE (workspace_id);


--
-- Name: workspace_members uq_ws_member; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspace_members
    ADD CONSTRAINT uq_ws_member UNIQUE (workspace_id, user_id);


--
-- Name: usage_aggregates_daily usage_aggregates_daily_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usage_aggregates_daily
    ADD CONSTRAINT usage_aggregates_daily_pkey PRIMARY KEY (workspace_id, date, department_id, entity_type, entity_id, provider, model, master_key_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: virtual_keys virtual_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.virtual_keys
    ADD CONSTRAINT virtual_keys_pkey PRIMARY KEY (id);


--
-- Name: wallet_chain_events wallet_chain_events_environment_network_asset_chain_tx_id_c_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet_chain_events
    ADD CONSTRAINT wallet_chain_events_environment_network_asset_chain_tx_id_c_key UNIQUE (environment, network, asset, chain_tx_id, chain_event_index);


--
-- Name: wallet_chain_events wallet_chain_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet_chain_events
    ADD CONSTRAINT wallet_chain_events_pkey PRIMARY KEY (id);


--
-- Name: wallet_deposit_intents wallet_deposit_intents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet_deposit_intents
    ADD CONSTRAINT wallet_deposit_intents_pkey PRIMARY KEY (id);


--
-- Name: wallet_deposit_intents wallet_deposit_intents_workspace_id_environment_network_ass_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet_deposit_intents
    ADD CONSTRAINT wallet_deposit_intents_workspace_id_environment_network_ass_key UNIQUE (workspace_id, environment, network, asset, idempotency_key);


--
-- Name: wallet_ledger_postings wallet_ledger_postings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet_ledger_postings
    ADD CONSTRAINT wallet_ledger_postings_pkey PRIMARY KEY (id);


--
-- Name: wallet_ledger_transactions wallet_ledger_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet_ledger_transactions
    ADD CONSTRAINT wallet_ledger_transactions_pkey PRIMARY KEY (id);


--
-- Name: wallet_ledger_transactions wallet_ledger_transactions_workspace_id_environment_networ_key1; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet_ledger_transactions
    ADD CONSTRAINT wallet_ledger_transactions_workspace_id_environment_networ_key1 UNIQUE (workspace_id, environment, network, asset, operation_type, operation_id);


--
-- Name: wallet_ledger_transactions wallet_ledger_transactions_workspace_id_environment_network_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet_ledger_transactions
    ADD CONSTRAINT wallet_ledger_transactions_workspace_id_environment_network_key UNIQUE (workspace_id, environment, network, asset, idempotency_key);


--
-- Name: wallet_network_assets wallet_network_assets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet_network_assets
    ADD CONSTRAINT wallet_network_assets_pkey PRIMARY KEY (environment, network, asset);


--
-- Name: wallet_transfer_attempts wallet_transfer_attempts_operation_type_operation_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet_transfer_attempts
    ADD CONSTRAINT wallet_transfer_attempts_operation_type_operation_id_key UNIQUE (operation_type, operation_id);


--
-- Name: wallet_transfer_attempts wallet_transfer_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet_transfer_attempts
    ADD CONSTRAINT wallet_transfer_attempts_pkey PRIMARY KEY (id);


--
-- Name: wallet_transfer_attempts wallet_transfer_attempts_provider_provider_idempotency_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet_transfer_attempts
    ADD CONSTRAINT wallet_transfer_attempts_provider_provider_idempotency_key_key UNIQUE (provider, provider_idempotency_key);


--
-- Name: wallet_withdrawals wallet_withdrawals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet_withdrawals
    ADD CONSTRAINT wallet_withdrawals_pkey PRIMARY KEY (id);


--
-- Name: wallet_withdrawals wallet_withdrawals_provider_provider_idempotency_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet_withdrawals
    ADD CONSTRAINT wallet_withdrawals_provider_provider_idempotency_key_key UNIQUE (provider, provider_idempotency_key);


--
-- Name: wallet_withdrawals wallet_withdrawals_workspace_id_environment_network_asset_i_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet_withdrawals
    ADD CONSTRAINT wallet_withdrawals_workspace_id_environment_network_asset_i_key UNIQUE (workspace_id, environment, network, asset, idempotency_key);


--
-- Name: wallet_chain_events wce_managed_wallet_environment_network_chk; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.wallet_chain_events
    ADD CONSTRAINT wce_managed_wallet_environment_network_chk CHECK (((environment <> ALL (ARRAY['sandbox'::text, 'production'::text])) OR ((environment = 'sandbox'::text) AND (network = ANY (ARRAY['eip155:84532'::text, 'solana-devnet'::text]))) OR ((environment = 'production'::text) AND (network = ANY (ARRAY['eip155:8453'::text, 'solana'::text]))))) NOT VALID;


--
-- Name: wallet_deposit_intents wdi_managed_wallet_environment_network_chk; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.wallet_deposit_intents
    ADD CONSTRAINT wdi_managed_wallet_environment_network_chk CHECK (((environment <> ALL (ARRAY['sandbox'::text, 'production'::text])) OR ((environment = 'sandbox'::text) AND (network = ANY (ARRAY['eip155:84532'::text, 'solana-devnet'::text]))) OR ((environment = 'production'::text) AND (network = ANY (ARRAY['eip155:8453'::text, 'solana'::text]))))) NOT VALID;


--
-- Name: withdrawal_daily_usage wdu_managed_wallet_environment_network_chk; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.withdrawal_daily_usage
    ADD CONSTRAINT wdu_managed_wallet_environment_network_chk CHECK (((environment <> ALL (ARRAY['sandbox'::text, 'production'::text])) OR ((environment = 'sandbox'::text) AND (network = ANY (ARRAY['eip155:84532'::text, 'solana-devnet'::text]))) OR ((environment = 'production'::text) AND (network = ANY (ARRAY['eip155:8453'::text, 'solana'::text]))))) NOT VALID;


--
-- Name: withdrawal_daily_usage_releases wdur_managed_wallet_environment_network_chk; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.withdrawal_daily_usage_releases
    ADD CONSTRAINT wdur_managed_wallet_environment_network_chk CHECK (((environment <> ALL (ARRAY['sandbox'::text, 'production'::text])) OR ((environment = 'sandbox'::text) AND (network = ANY (ARRAY['eip155:84532'::text, 'solana-devnet'::text]))) OR ((environment = 'production'::text) AND (network = ANY (ARRAY['eip155:8453'::text, 'solana'::text]))))) NOT VALID;


--
-- Name: webhook_deliveries webhook_deliveries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webhook_deliveries
    ADD CONSTRAINT webhook_deliveries_pkey PRIMARY KEY (id);


--
-- Name: webhook_endpoints webhook_endpoints_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webhook_endpoints
    ADD CONSTRAINT webhook_endpoints_pkey PRIMARY KEY (id);


--
-- Name: withdrawal_daily_usage withdrawal_daily_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.withdrawal_daily_usage
    ADD CONSTRAINT withdrawal_daily_usage_pkey PRIMARY KEY (workspace_id, fund_domain, source_account_id, environment, network, asset, usage_date);


--
-- Name: withdrawal_daily_usage_releases withdrawal_daily_usage_releases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.withdrawal_daily_usage_releases
    ADD CONSTRAINT withdrawal_daily_usage_releases_pkey PRIMARY KEY (withdrawal_kind, withdrawal_id);


--
-- Name: withdrawal_network_fee_accruals withdrawal_network_fee_accruals_kind_fund_domain_chk; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.withdrawal_network_fee_accruals
    ADD CONSTRAINT withdrawal_network_fee_accruals_kind_fund_domain_chk CHECK ((((withdrawal_kind = 'wallet_withdrawal'::text) AND (fund_domain = 'workspace_funding'::text)) OR ((withdrawal_kind = ANY (ARRAY['revenue_withdrawal'::text, 'platform_fee_withdrawal'::text])) AND (fund_domain = 'platform_revenue'::text)))) NOT VALID;


--
-- Name: withdrawal_network_fee_accruals withdrawal_network_fee_accruals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.withdrawal_network_fee_accruals
    ADD CONSTRAINT withdrawal_network_fee_accruals_pkey PRIMARY KEY (withdrawal_kind, withdrawal_id);


--
-- Name: wallet_ledger_transactions wlt_managed_wallet_environment_network_chk; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.wallet_ledger_transactions
    ADD CONSTRAINT wlt_managed_wallet_environment_network_chk CHECK (((environment <> ALL (ARRAY['sandbox'::text, 'production'::text])) OR ((environment = 'sandbox'::text) AND (network = ANY (ARRAY['eip155:84532'::text, 'solana-devnet'::text]))) OR ((environment = 'production'::text) AND (network = ANY (ARRAY['eip155:8453'::text, 'solana'::text]))))) NOT VALID;


--
-- Name: wallet_network_assets wna_managed_wallet_environment_network_chk; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.wallet_network_assets
    ADD CONSTRAINT wna_managed_wallet_environment_network_chk CHECK (((environment <> ALL (ARRAY['sandbox'::text, 'production'::text])) OR ((environment = 'sandbox'::text) AND (network = ANY (ARRAY['eip155:84532'::text, 'solana-devnet'::text]))) OR ((environment = 'production'::text) AND (network = ANY (ARRAY['eip155:8453'::text, 'solana'::text]))))) NOT VALID;


--
-- Name: workspace_insights_score_formula workspace_insights_score_formula_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspace_insights_score_formula
    ADD CONSTRAINT workspace_insights_score_formula_pkey PRIMARY KEY (workspace_id);


--
-- Name: workspace_insights_signal_setting workspace_insights_signal_setting_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspace_insights_signal_setting
    ADD CONSTRAINT workspace_insights_signal_setting_pkey PRIMARY KEY (workspace_id, signal_id);


--
-- Name: workspace_members workspace_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspace_members
    ADD CONSTRAINT workspace_members_pkey PRIMARY KEY (id);


--
-- Name: workspace_revenue_balances workspace_revenue_balances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspace_revenue_balances
    ADD CONSTRAINT workspace_revenue_balances_pkey PRIMARY KEY (workspace_id, network, asset);


--
-- Name: workspace_wallet_balances workspace_wallet_balances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspace_wallet_balances
    ADD CONSTRAINT workspace_wallet_balances_pkey PRIMARY KEY (workspace_id, environment, network, asset);


--
-- Name: workspaces workspaces_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspaces
    ADD CONSTRAINT workspaces_pkey PRIMARY KEY (id);


--
-- Name: wallet_withdrawals ww_managed_wallet_environment_network_chk; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.wallet_withdrawals
    ADD CONSTRAINT ww_managed_wallet_environment_network_chk CHECK (((environment <> ALL (ARRAY['sandbox'::text, 'production'::text])) OR ((environment = 'sandbox'::text) AND (network = ANY (ARRAY['eip155:84532'::text, 'solana-devnet'::text]))) OR ((environment = 'production'::text) AND (network = ANY (ARRAY['eip155:8453'::text, 'solana'::text]))))) NOT VALID;


--
-- Name: workspace_wallet_balances wwb_managed_wallet_environment_network_chk; Type: CHECK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.workspace_wallet_balances
    ADD CONSTRAINT wwb_managed_wallet_environment_network_chk CHECK (((environment <> ALL (ARRAY['sandbox'::text, 'production'::text])) OR ((environment = 'sandbox'::text) AND (network = ANY (ARRAY['eip155:84532'::text, 'solana-devnet'::text]))) OR ((environment = 'production'::text) AND (network = ANY (ARRAY['eip155:8453'::text, 'solana'::text]))))) NOT VALID;


--
-- Name: x402_chain_networks x402_chain_networks_network_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_chain_networks
    ADD CONSTRAINT x402_chain_networks_network_key UNIQUE (network);


--
-- Name: x402_chain_networks x402_chain_networks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_chain_networks
    ADD CONSTRAINT x402_chain_networks_pkey PRIMARY KEY (id);


--
-- Name: x402_chain_networks x402_chain_networks_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_chain_networks
    ADD CONSTRAINT x402_chain_networks_slug_key UNIQUE (slug);


--
-- Name: x402_endpoint_market_listings x402_endpoint_market_listings_endpoint_id_channel_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoint_market_listings
    ADD CONSTRAINT x402_endpoint_market_listings_endpoint_id_channel_key UNIQUE (endpoint_id, channel);


--
-- Name: x402_endpoint_market_listings x402_endpoint_market_listings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoint_market_listings
    ADD CONSTRAINT x402_endpoint_market_listings_pkey PRIMARY KEY (id);


--
-- Name: x402_endpoint_networks x402_endpoint_networks_endpoint_id_network_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoint_networks
    ADD CONSTRAINT x402_endpoint_networks_endpoint_id_network_key UNIQUE (endpoint_id, network);


--
-- Name: x402_endpoint_networks x402_endpoint_networks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoint_networks
    ADD CONSTRAINT x402_endpoint_networks_pkey PRIMARY KEY (id);


--
-- Name: x402_endpoint_policies x402_endpoint_policies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoint_policies
    ADD CONSTRAINT x402_endpoint_policies_pkey PRIMARY KEY (id);


--
-- Name: x402_endpoint_secret_events x402_endpoint_secret_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoint_secret_events
    ADD CONSTRAINT x402_endpoint_secret_events_pkey PRIMARY KEY (id);


--
-- Name: x402_endpoint_secrets x402_endpoint_secrets_endpoint_id_version_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoint_secrets
    ADD CONSTRAINT x402_endpoint_secrets_endpoint_id_version_key UNIQUE (endpoint_id, version);


--
-- Name: x402_endpoint_secrets x402_endpoint_secrets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoint_secrets
    ADD CONSTRAINT x402_endpoint_secrets_pkey PRIMARY KEY (id);


--
-- Name: x402_endpoint_secrets x402_endpoint_secrets_secret_hash_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoint_secrets
    ADD CONSTRAINT x402_endpoint_secrets_secret_hash_key UNIQUE (secret_hash);


--
-- Name: x402_endpoints x402_endpoints_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoints
    ADD CONSTRAINT x402_endpoints_pkey PRIMARY KEY (id);


--
-- Name: x402_facilitator_attempts x402_facilitator_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_facilitator_attempts
    ADD CONSTRAINT x402_facilitator_attempts_pkey PRIMARY KEY (id);


--
-- Name: x402_network_provider_settings x402_network_provider_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_network_provider_settings
    ADD CONSTRAINT x402_network_provider_settings_pkey PRIMARY KEY (workspace_id);


--
-- Name: x402_outbound_result_keys x402_outbound_result_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_outbound_result_keys
    ADD CONSTRAINT x402_outbound_result_keys_pkey PRIMARY KEY (result_key);


--
-- Name: x402_outbound_spends x402_outbound_spends_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_outbound_spends
    ADD CONSTRAINT x402_outbound_spends_pkey PRIMARY KEY (id);


--
-- Name: x402_payment_activities x402_payment_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_payment_activities
    ADD CONSTRAINT x402_payment_activities_pkey PRIMARY KEY (id);


--
-- Name: x402_payment_idempotency_keys x402_payment_idempotency_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_payment_idempotency_keys
    ADD CONSTRAINT x402_payment_idempotency_keys_pkey PRIMARY KEY (id);


--
-- Name: x402_payment_idempotency_keys x402_payment_idempotency_keys_workspace_id_payment_nonce_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_payment_idempotency_keys
    ADD CONSTRAINT x402_payment_idempotency_keys_workspace_id_payment_nonce_key UNIQUE (workspace_id, payment_nonce);


--
-- Name: x402_payment_idempotency_keys x402_payment_idempotency_keys_workspace_id_request_hash_pay_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_payment_idempotency_keys
    ADD CONSTRAINT x402_payment_idempotency_keys_workspace_id_request_hash_pay_key UNIQUE (workspace_id, request_hash, payment_signature_hash);


--
-- Name: x402_payment_service_result_keys x402_payment_service_result_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_payment_service_result_keys
    ADD CONSTRAINT x402_payment_service_result_keys_pkey PRIMARY KEY (result_key);


--
-- Name: x402_payout_requests x402_payout_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_payout_requests
    ADD CONSTRAINT x402_payout_requests_pkey PRIMARY KEY (id);


--
-- Name: x402_payouts x402_payouts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_payouts
    ADD CONSTRAINT x402_payouts_pkey PRIMARY KEY (id);


--
-- Name: x402_platform_wallets x402_platform_wallets_network_asset_environment_revision_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_platform_wallets
    ADD CONSTRAINT x402_platform_wallets_network_asset_environment_revision_key UNIQUE (network, asset, environment, revision);


--
-- Name: x402_platform_wallets x402_platform_wallets_network_receive_wallet_address_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_platform_wallets
    ADD CONSTRAINT x402_platform_wallets_network_receive_wallet_address_key UNIQUE (network, receive_wallet_address);


--
-- Name: x402_platform_wallets x402_platform_wallets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_platform_wallets
    ADD CONSTRAINT x402_platform_wallets_pkey PRIMARY KEY (id);


--
-- Name: x402_receive_wallet_challenges x402_receive_wallet_challenges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_receive_wallet_challenges
    ADD CONSTRAINT x402_receive_wallet_challenges_pkey PRIMARY KEY (id);


--
-- Name: x402_receive_wallets x402_receive_wallets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_receive_wallets
    ADD CONSTRAINT x402_receive_wallets_pkey PRIMARY KEY (id);


--
-- Name: x402_receive_wallets x402_receive_wallets_workspace_id_network_address_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_receive_wallets
    ADD CONSTRAINT x402_receive_wallets_workspace_id_network_address_key UNIQUE (workspace_id, network, address);


--
-- Name: x402_revenue_withdrawal_reservations x402_revenue_withdrawal_reserv_workspace_id_idempotency_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_revenue_withdrawal_reservations
    ADD CONSTRAINT x402_revenue_withdrawal_reserv_workspace_id_idempotency_key_key UNIQUE (workspace_id, idempotency_key);


--
-- Name: x402_revenue_withdrawal_reservation_items x402_revenue_withdrawal_reservation_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_revenue_withdrawal_reservation_items
    ADD CONSTRAINT x402_revenue_withdrawal_reservation_items_pkey PRIMARY KEY (id);


--
-- Name: x402_revenue_withdrawal_reservations x402_revenue_withdrawal_reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_revenue_withdrawal_reservations
    ADD CONSTRAINT x402_revenue_withdrawal_reservations_pkey PRIMARY KEY (id);


--
-- Name: x402_settlements x402_settlements_activity_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_settlements
    ADD CONSTRAINT x402_settlements_activity_id_key UNIQUE (activity_id);


--
-- Name: x402_settlements x402_settlements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_settlements
    ADD CONSTRAINT x402_settlements_pkey PRIMARY KEY (id);


--
-- Name: x402_spend_agent_bindings x402_spend_agent_bindings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_spend_agent_bindings
    ADD CONSTRAINT x402_spend_agent_bindings_pkey PRIMARY KEY (id);


--
-- Name: x402_spend_agent_bindings x402_spend_agent_bindings_workspace_id_agent_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_spend_agent_bindings
    ADD CONSTRAINT x402_spend_agent_bindings_workspace_id_agent_id_key UNIQUE (workspace_id, agent_id);


--
-- Name: x402_spend_policies x402_spend_policies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_spend_policies
    ADD CONSTRAINT x402_spend_policies_pkey PRIMARY KEY (id);


--
-- Name: x402_spend_wallet_accounts x402_spend_wallet_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_spend_wallet_accounts
    ADD CONSTRAINT x402_spend_wallet_accounts_pkey PRIMARY KEY (id);


--
-- Name: x402_spend_wallet_accounts x402_spend_wallet_accounts_workspace_id_network_asset_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_spend_wallet_accounts
    ADD CONSTRAINT x402_spend_wallet_accounts_workspace_id_network_asset_key UNIQUE (workspace_id, network, asset);


--
-- Name: x402_spend_wallet_movements x402_spend_wallet_movements_account_id_idempotency_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_spend_wallet_movements
    ADD CONSTRAINT x402_spend_wallet_movements_account_id_idempotency_key_key UNIQUE (account_id, idempotency_key);


--
-- Name: x402_spend_wallet_movements x402_spend_wallet_movements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_spend_wallet_movements
    ADD CONSTRAINT x402_spend_wallet_movements_pkey PRIMARY KEY (id);


--
-- Name: x402_spend_wallet_top_up_intents x402_spend_wallet_top_up_intents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_spend_wallet_top_up_intents
    ADD CONSTRAINT x402_spend_wallet_top_up_intents_pkey PRIMARY KEY (id);


--
-- Name: x402_split_sweep_batches x402_split_sweep_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_split_sweep_batches
    ADD CONSTRAINT x402_split_sweep_batches_pkey PRIMARY KEY (id);


--
-- Name: x402_split_sweep_distributions x402_split_sweep_distributions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_split_sweep_distributions
    ADD CONSTRAINT x402_split_sweep_distributions_pkey PRIMARY KEY (id);


--
-- Name: x402_split_treasuries x402_split_treasuries_network_asset_environment_revision_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_split_treasuries
    ADD CONSTRAINT x402_split_treasuries_network_asset_environment_revision_key UNIQUE (network, asset, environment, revision);


--
-- Name: x402_split_treasuries x402_split_treasuries_network_treasury_address_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_split_treasuries
    ADD CONSTRAINT x402_split_treasuries_network_treasury_address_key UNIQUE (network, treasury_address);


--
-- Name: x402_split_treasuries x402_split_treasuries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_split_treasuries
    ADD CONSTRAINT x402_split_treasuries_pkey PRIMARY KEY (id);


--
-- Name: x402_system_wallets x402_system_wallets_network_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_system_wallets
    ADD CONSTRAINT x402_system_wallets_network_key UNIQUE (network);


--
-- Name: x402_system_wallets x402_system_wallets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_system_wallets
    ADD CONSTRAINT x402_system_wallets_pkey PRIMARY KEY (id);


--
-- Name: x402_wallet_verification_challenges x402_wallet_verification_challenges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_wallet_verification_challenges
    ADD CONSTRAINT x402_wallet_verification_challenges_pkey PRIMARY KEY (id);


--
-- Name: x402_workspace_payment_settings x402_workspace_payment_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_workspace_payment_settings
    ADD CONSTRAINT x402_workspace_payment_settings_pkey PRIMARY KEY (workspace_id);


--
-- Name: x402_workspace_spend_ceilings x402_workspace_spend_ceilings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_workspace_spend_ceilings
    ADD CONSTRAINT x402_workspace_spend_ceilings_pkey PRIMARY KEY (workspace_id);


--
-- Name: domain_notification_events_status_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX domain_notification_events_status_id_idx ON public.domain_notification_events USING btree (status, id);


--
-- Name: idx_active_alerts_workspace_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_active_alerts_workspace_created ON public.active_alerts USING btree (workspace_id, created_at DESC);


--
-- Name: idx_active_alerts_workspace_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_active_alerts_workspace_status ON public.active_alerts USING btree (workspace_id, status);


--
-- Name: idx_agent_allowed_models_agent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_agent_allowed_models_agent ON public.agent_allowed_models USING btree (agent_id);


--
-- Name: idx_agent_policy_bindings_policy; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_agent_policy_bindings_policy ON public.agent_policy_bindings USING btree (policy_id);


--
-- Name: idx_agent_runtime_configs_workspace; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_agent_runtime_configs_workspace ON public.agent_runtime_configs USING btree (workspace_id);


--
-- Name: idx_agent_stream_keys_secret_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_agent_stream_keys_secret_hash ON public.agent_stream_keys USING btree (secret_hash);


--
-- Name: idx_agent_stream_keys_workspace_agent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_agent_stream_keys_workspace_agent ON public.agent_stream_keys USING btree (workspace_id, agent_id) WHERE (status = 'active'::text);


--
-- Name: idx_agents_dept; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_agents_dept ON public.agents USING btree (department_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_agents_workspace_source; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_agents_workspace_source ON public.agents USING btree (workspace_id, source) WHERE (deleted_at IS NULL);


--
-- Name: idx_agents_ws; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_agents_ws ON public.agents USING btree (workspace_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_alert_rules_workspace; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_alert_rules_workspace ON public.alert_rules USING btree (workspace_id);


--
-- Name: idx_audit_ws_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_ws_time ON public.audit_logs USING btree (workspace_id, created_at DESC);


--
-- Name: idx_external_endpoints_workspace_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_external_endpoints_workspace_status ON public.external_endpoints USING btree (workspace_id, status);


--
-- Name: idx_insights_signal_definition_family; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_insights_signal_definition_family ON public.insights_signal_definition USING btree (signal_family);


--
-- Name: idx_invoices_ws; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_invoices_ws ON public.invoices USING btree (workspace_id, period_start DESC);


--
-- Name: idx_key_market_alephant_observability_workspace; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_key_market_alephant_observability_workspace ON public.key_market_alephant_observability_links USING btree (workspace_id, status);


--
-- Name: idx_line_items_invoice; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_line_items_invoice ON public.invoice_line_items USING btree (invoice_id);


--
-- Name: idx_log_overage_reports_status_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_log_overage_reports_status_created ON public.log_overage_reports USING btree (status, created_at);


--
-- Name: idx_log_overage_reports_workspace_period; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_log_overage_reports_workspace_period ON public.log_overage_reports USING btree (workspace_id, period_start_at, period_end_at);


--
-- Name: idx_log_overage_reports_workspace_period_to; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_log_overage_reports_workspace_period_to ON public.log_overage_reports USING btree (workspace_id, period_start_at, period_end_at, reported_to) WHERE (status = ANY (ARRAY['pending'::text, 'reported'::text]));


--
-- Name: idx_managed_wallet_saas_commands_withdraw_limit; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_managed_wallet_saas_commands_withdraw_limit ON public.managed_wallet_saas_commands USING btree (workspace_id, created_at) WHERE (((operation)::text = 'wallet.withdraw.create'::text) AND ((status)::text = ANY ((ARRAY['completed'::character varying, 'pending'::character varying, 'submitted'::character varying, 'confirmed'::character varying, 'manual_review'::character varying, 'unknown'::character varying, 'sync_required'::character varying])::text[])));


--
-- Name: idx_managed_wallet_saas_commands_withdraw_sync; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_managed_wallet_saas_commands_withdraw_sync ON public.managed_wallet_saas_commands USING btree (updated_at) WHERE (((operation)::text = 'wallet.withdraw.create'::text) AND (payment_resource_id IS NOT NULL) AND ((status)::text = ANY ((ARRAY['pending'::character varying, 'submitted'::character varying, 'manual_review'::character varying, 'unknown'::character varying, 'sync_required'::character varying])::text[])));


--
-- Name: idx_members_dept; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_members_dept ON public.members USING btree (department_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_members_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_members_user ON public.members USING btree (user_id) WHERE ((user_id IS NOT NULL) AND (deleted_at IS NULL));


--
-- Name: idx_members_ws; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_members_ws ON public.members USING btree (workspace_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_mk_ws; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mk_ws ON public.master_keys USING btree (workspace_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_mkd_dept; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mkd_dept ON public.master_key_departments USING btree (department_id);


--
-- Name: idx_notif_unread; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notif_unread ON public.notifications USING btree (workspace_id) WHERE ((read_at IS NULL) AND (deleted_at IS NULL));


--
-- Name: idx_notif_ws_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notif_ws_time ON public.notifications USING btree (workspace_id, created_at DESC) WHERE (deleted_at IS NULL);


--
-- Name: idx_notification_preferences_workspace; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_notification_preferences_workspace ON public.notification_preferences USING btree (workspace_id);


--
-- Name: idx_pat_hash_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pat_hash_active ON public.personal_access_tokens USING btree (token_hash) WHERE (revoked_at IS NULL);


--
-- Name: idx_pat_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pat_user ON public.personal_access_tokens USING btree (user_id) WHERE (revoked_at IS NULL);


--
-- Name: idx_platform_fee_withdrawal_requests_active; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_platform_fee_withdrawal_requests_active ON public.platform_fee_withdrawal_requests USING btree (environment, network, asset) WHERE (status = ANY (ARRAY['requested'::text, 'reserved'::text, 'submitted'::text, 'manual_review'::text]));


--
-- Name: idx_platform_fee_withdrawal_requests_idempotency; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_platform_fee_withdrawal_requests_idempotency ON public.platform_fee_withdrawal_requests USING btree (environment, network, asset, idempotency_key);


--
-- Name: idx_platform_fee_withdrawal_requests_payment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_platform_fee_withdrawal_requests_payment_id ON public.platform_fee_withdrawal_requests USING btree (payment_service_withdrawal_id) WHERE (payment_service_withdrawal_id IS NOT NULL);


--
-- Name: idx_platform_fee_withdrawals_active; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_platform_fee_withdrawals_active ON public.platform_fee_withdrawals USING btree (environment, network, asset) WHERE (status = ANY (ARRAY['requested'::text, 'reserved'::text, 'submitted'::text, 'manual_review'::text]));


--
-- Name: idx_platform_fee_withdrawals_idempotency; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_platform_fee_withdrawals_idempotency ON public.platform_fee_withdrawals USING btree (environment, network, asset, idempotency_key);


--
-- Name: idx_platform_fee_withdrawals_payment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_platform_fee_withdrawals_payment_id ON public.platform_fee_withdrawals USING btree (payment_service_withdrawal_id) WHERE (payment_service_withdrawal_id IS NOT NULL);


--
-- Name: idx_policy_overrides_department; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_policy_overrides_department ON public.policy_overrides USING btree (department_id);


--
-- Name: idx_policy_overrides_workspace; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_policy_overrides_workspace ON public.policy_overrides USING btree (workspace_id);


--
-- Name: idx_prompt_bind_entity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_prompt_bind_entity ON public.prompt_bindings USING btree (entity_type, entity_id);


--
-- Name: idx_prompt_bind_template; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_prompt_bind_template ON public.prompt_bindings USING btree (template_id);


--
-- Name: idx_prompt_tpl_bound_model; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_prompt_tpl_bound_model ON public.prompt_templates USING btree (bound_model) WHERE (deleted_at IS NULL);


--
-- Name: idx_prompt_tpl_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_prompt_tpl_slug ON public.prompt_templates USING btree (workspace_id, slug) WHERE (deleted_at IS NULL);


--
-- Name: idx_prompt_tpl_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_prompt_tpl_status ON public.prompt_templates USING btree (workspace_id, status) WHERE (deleted_at IS NULL);


--
-- Name: idx_prompt_tpl_workspace; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_prompt_tpl_workspace ON public.prompt_templates USING btree (workspace_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_prompt_ver_template; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_prompt_ver_template ON public.prompt_versions USING btree (template_id, version DESC);


--
-- Name: idx_provider_models_provider; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_provider_models_provider ON public.provider_models USING btree (provider_id);


--
-- Name: idx_providers_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_providers_code ON public.providers USING btree (code);


--
-- Name: idx_refresh_sessions_user_exp; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_refresh_sessions_user_exp ON public.refresh_sessions USING btree (user_id, expires_at) WHERE (revoked_at IS NULL);


--
-- Name: idx_sales_leads_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sales_leads_created_at ON public.sales_leads USING btree (created_at DESC);


--
-- Name: idx_sales_leads_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sales_leads_user_id ON public.sales_leads USING btree (user_id) WHERE (user_id IS NOT NULL);


--
-- Name: idx_sales_leads_work_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sales_leads_work_email ON public.sales_leads USING btree (work_email);


--
-- Name: idx_sales_leads_workspace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sales_leads_workspace_id ON public.sales_leads USING btree (workspace_id) WHERE (workspace_id IS NOT NULL);


--
-- Name: idx_sub_events_ws; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sub_events_ws ON public.subscription_events USING btree (workspace_id, created_at DESC);


--
-- Name: idx_sub_ws_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sub_ws_status ON public.subscriptions USING btree (workspace_id, status);


--
-- Name: idx_vk_entity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vk_entity ON public.virtual_keys USING btree (entity_type, entity_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_vk_key_hash_active; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_vk_key_hash_active ON public.virtual_keys USING btree (key_hash) WHERE (deleted_at IS NULL);


--
-- Name: idx_vk_master_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vk_master_key ON public.virtual_keys USING btree (master_key_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_vk_ws_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vk_ws_status ON public.virtual_keys USING btree (workspace_id, status) WHERE (deleted_at IS NULL);


--
-- Name: idx_workspace_insights_signal_setting_workspace; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_workspace_insights_signal_setting_workspace ON public.workspace_insights_signal_setting USING btree (workspace_id);


--
-- Name: idx_ws_members_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ws_members_user ON public.workspace_members USING btree (user_id);


--
-- Name: idx_x402_activities_endpoint; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_x402_activities_endpoint ON public.x402_payment_activities USING btree (endpoint_id, created_at DESC);


--
-- Name: idx_x402_activities_trace; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_x402_activities_trace ON public.x402_payment_activities USING btree (trace_id);


--
-- Name: idx_x402_activities_ws_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_x402_activities_ws_created ON public.x402_payment_activities USING btree (workspace_id, created_at DESC);


--
-- Name: idx_x402_chain_networks_environment; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_x402_chain_networks_environment ON public.x402_chain_networks USING btree (environment, status);


--
-- Name: idx_x402_chain_networks_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_x402_chain_networks_status ON public.x402_chain_networks USING btree (status, x402_enabled);


--
-- Name: idx_x402_endpoint_networks_workspace_endpoint; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_x402_endpoint_networks_workspace_endpoint ON public.x402_endpoint_networks USING btree (workspace_id, endpoint_id);


--
-- Name: idx_x402_endpoint_networks_workspace_network_endpoint; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_x402_endpoint_networks_workspace_network_endpoint ON public.x402_endpoint_networks USING btree (workspace_id, network, endpoint_id);


--
-- Name: idx_x402_endpoints_ws_agent; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_x402_endpoints_ws_agent ON public.x402_endpoints USING btree (workspace_id, agent_id);


--
-- Name: idx_x402_endpoints_ws_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_x402_endpoints_ws_status ON public.x402_endpoints USING btree (workspace_id, status);


--
-- Name: idx_x402_endpoints_ws_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_x402_endpoints_ws_type ON public.x402_endpoints USING btree (workspace_id, endpoint_type) WHERE (deleted_at IS NULL);


--
-- Name: idx_x402_outbound_ws_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_x402_outbound_ws_created ON public.x402_outbound_spends USING btree (workspace_id, created_at DESC);


--
-- Name: idx_x402_payouts_ws_destination_wallet; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_x402_payouts_ws_destination_wallet ON public.x402_payouts USING btree (workspace_id, destination_wallet_id);


--
-- Name: idx_x402_revenue_withdrawal_items_activity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_x402_revenue_withdrawal_items_activity ON public.x402_revenue_withdrawal_reservation_items USING btree (activity_id);


--
-- Name: idx_x402_revenue_withdrawal_items_workspace; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_x402_revenue_withdrawal_items_workspace ON public.x402_revenue_withdrawal_reservation_items USING btree (workspace_id, reservation_id);


--
-- Name: idx_x402_revenue_withdrawal_reservations_sync; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_x402_revenue_withdrawal_reservations_sync ON public.x402_revenue_withdrawal_reservations USING btree (updated_at) WHERE ((payment_service_withdrawal_id IS NOT NULL) AND (status = ANY (ARRAY['submitted'::text, 'manual_review'::text, 'sync_required'::text])));


--
-- Name: idx_x402_settlements_ws_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_x402_settlements_ws_created ON public.x402_settlements USING btree (workspace_id, created_at DESC);


--
-- Name: idx_x402_spend_bindings_ws; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_x402_spend_bindings_ws ON public.x402_spend_agent_bindings USING btree (workspace_id, agent_id);


--
-- Name: idx_x402_split_sweep_batches_treasury_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_x402_split_sweep_batches_treasury_created ON public.x402_split_sweep_batches USING btree (split_treasury_id, created_at DESC);


--
-- Name: idx_x402_split_sweep_distributions_batch; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_x402_split_sweep_distributions_batch ON public.x402_split_sweep_distributions USING btree (batch_id);


--
-- Name: idx_x402_split_sweep_distributions_endpoint; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_x402_split_sweep_distributions_endpoint ON public.x402_split_sweep_distributions USING btree (endpoint_id, created_at DESC);


--
-- Name: idx_x402_split_treasuries_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_x402_split_treasuries_status ON public.x402_split_treasuries USING btree (network, asset, environment, status);


--
-- Name: idx_x402_split_treasuries_sweep; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_x402_split_treasuries_sweep ON public.x402_split_treasuries USING btree (status, last_swept_at);


--
-- Name: idx_x402_wallets_ws; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_x402_wallets_ws ON public.x402_receive_wallets USING btree (workspace_id, status);


--
-- Name: idx_x402_workspace_spend_ceilings_updated; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_x402_workspace_spend_ceilings_updated ON public.x402_workspace_spend_ceilings USING btree (updated_at DESC);


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
-- Name: managed_wallet_accounts_active_platform_receive_uidx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX managed_wallet_accounts_active_platform_receive_uidx ON public.managed_wallet_accounts USING btree (environment, network, asset) WHERE ((status = 'active'::text) AND (account_kind = 'platform_receive'::text));


--
-- Name: managed_wallet_accounts_active_platform_uidx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX managed_wallet_accounts_active_platform_uidx ON public.managed_wallet_accounts USING btree (account_kind, environment, network, asset, provider) WHERE ((status = 'active'::text) AND (account_kind = 'platform_revenue'::text));


--
-- Name: managed_wallet_accounts_active_workspace_uidx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX managed_wallet_accounts_active_workspace_uidx ON public.managed_wallet_accounts USING btree (workspace_id, account_kind, environment, network, asset) WHERE ((status = 'active'::text) AND (account_kind = 'workspace_funding'::text));


--
-- Name: managed_wallet_accounts_provider_account_uidx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX managed_wallet_accounts_provider_account_uidx ON public.managed_wallet_accounts USING btree (provider, provider_account_id) WHERE (provider_account_id <> ''::text);


--
-- Name: managed_wallet_accounts_provider_create_idempotency_uidx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX managed_wallet_accounts_provider_create_idempotency_uidx ON public.managed_wallet_accounts USING btree (provider, provider_create_idempotency_key) WHERE (provider_create_idempotency_key IS NOT NULL);


--
-- Name: notification_delivery_tasks_pending_schedule_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notification_delivery_tasks_pending_schedule_idx ON public.notification_delivery_tasks USING btree (status, scheduled_at, id) WHERE (status = 'pending'::text);


--
-- Name: notification_delivery_tasks_user_ws_cat_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX notification_delivery_tasks_user_ws_cat_idx ON public.notification_delivery_tasks USING btree (user_id, workspace_id, category);


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
-- Name: payment_operation_traces_activity_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payment_operation_traces_activity_idx ON public.payment_operation_traces USING btree (activity_id, occurred_at, id) WHERE (activity_id IS NOT NULL);


--
-- Name: payment_operation_traces_correlation_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payment_operation_traces_correlation_idx ON public.payment_operation_traces USING btree (correlation_id, occurred_at DESC, id DESC) WHERE (correlation_id IS NOT NULL);


--
-- Name: payment_operation_traces_occurred_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payment_operation_traces_occurred_at_idx ON public.payment_operation_traces USING btree (occurred_at, id);


--
-- Name: payment_operation_traces_operation_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payment_operation_traces_operation_idx ON public.payment_operation_traces USING btree (operation_type, operation_id, occurred_at, id) WHERE (operation_id IS NOT NULL);


--
-- Name: payment_operation_traces_request_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payment_operation_traces_request_idx ON public.payment_operation_traces USING btree (request_id, occurred_at DESC, id DESC) WHERE (request_id IS NOT NULL);


--
-- Name: payment_operation_traces_revenue_withdrawal_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payment_operation_traces_revenue_withdrawal_idx ON public.payment_operation_traces USING btree (revenue_withdrawal_id, occurred_at, id) WHERE (revenue_withdrawal_id IS NOT NULL);


--
-- Name: payment_operation_traces_trace_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payment_operation_traces_trace_idx ON public.payment_operation_traces USING btree (trace_id, occurred_at DESC, id DESC) WHERE (trace_id IS NOT NULL);


--
-- Name: payment_operation_traces_tx_hash_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payment_operation_traces_tx_hash_idx ON public.payment_operation_traces USING btree (tx_hash, occurred_at, id) WHERE (tx_hash IS NOT NULL);


--
-- Name: payment_operation_traces_ws_created_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payment_operation_traces_ws_created_at_idx ON public.payment_operation_traces USING btree (workspace_id, occurred_at DESC, id DESC);


--
-- Name: payment_webhook_inbox_provider_dedupe_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX payment_webhook_inbox_provider_dedupe_unique ON public.payment_webhook_inbox USING btree (provider, event_dedupe_key);


--
-- Name: payment_webhook_inbox_provider_event_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payment_webhook_inbox_provider_event_idx ON public.payment_webhook_inbox USING btree (provider, provider_event_id) WHERE (provider_event_id IS NOT NULL);


--
-- Name: payment_webhook_inbox_provider_object_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payment_webhook_inbox_provider_object_idx ON public.payment_webhook_inbox USING btree (provider, provider_object_id) WHERE (provider_object_id IS NOT NULL);


--
-- Name: payment_webhook_inbox_retry_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payment_webhook_inbox_retry_idx ON public.payment_webhook_inbox USING btree (next_retry_at, received_at) WHERE (status = ANY (ARRAY['received'::text, 'retryable'::text]));


--
-- Name: payment_webhook_inbox_status_received_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payment_webhook_inbox_status_received_idx ON public.payment_webhook_inbox USING btree (status, received_at);


--
-- Name: payment_webhook_inbox_topup_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payment_webhook_inbox_topup_idx ON public.payment_webhook_inbox USING btree (topup_id) WHERE (topup_id IS NOT NULL);


--
-- Name: platform_fee_withdrawals_scope_active_uidx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX platform_fee_withdrawals_scope_active_uidx ON public.platform_fee_withdrawals USING btree (environment, network, asset) WHERE (status = ANY (ARRAY['requested'::text, 'reserved'::text, 'submitted'::text, 'manual_review'::text]));


--
-- Name: platform_fee_withdrawals_scope_idempotency_uidx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX platform_fee_withdrawals_scope_idempotency_uidx ON public.platform_fee_withdrawals USING btree (environment, network, asset, idempotency_key);


--
-- Name: policy_eval_traces_request_created_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX policy_eval_traces_request_created_at_idx ON public.policy_eval_traces USING btree (request_id, created_at);


--
-- Name: policy_eval_traces_session_created_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX policy_eval_traces_session_created_at_idx ON public.policy_eval_traces USING btree (session_id, created_at DESC) WHERE (session_id IS NOT NULL);


--
-- Name: policy_eval_traces_vk_created_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX policy_eval_traces_vk_created_at_idx ON public.policy_eval_traces USING btree (virtual_key_id, created_at DESC);


--
-- Name: policy_eval_traces_ws_created_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX policy_eval_traces_ws_created_at_idx ON public.policy_eval_traces USING btree (workspace_id, created_at DESC);


--
-- Name: revenue_reservation_consumptions_workspace_destination_wallet_i; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX revenue_reservation_consumptions_workspace_destination_wallet_i ON public.revenue_reservation_consumptions USING btree (workspace_id, destination_wallet_id) WHERE (destination_wallet_id IS NOT NULL);


--
-- Name: revenue_withdrawals_workspace_destination_wallet_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX revenue_withdrawals_workspace_destination_wallet_idx ON public.revenue_withdrawals USING btree (workspace_id, destination_wallet_id) WHERE (destination_wallet_id IS NOT NULL);


--
-- Name: uq_agent_policy_bindings_target; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_agent_policy_bindings_target ON public.agent_policy_bindings USING btree (workspace_id, target_type, target_id) WHERE (target_id IS NOT NULL);


--
-- Name: uq_agent_policy_bindings_workspace; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_agent_policy_bindings_workspace ON public.agent_policy_bindings USING btree (workspace_id, target_type) WHERE (target_type = 'workspace'::text);


--
-- Name: uq_agents_id_workspace; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_agents_id_workspace ON public.agents USING btree (id, workspace_id);


--
-- Name: uq_dept_ws_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_dept_ws_name ON public.departments USING btree (workspace_id, name) WHERE (deleted_at IS NULL);


--
-- Name: uq_external_endpoints_workspace_endpoint; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_external_endpoints_workspace_endpoint ON public.external_endpoints USING btree (workspace_id, lower(domain), url_pattern, upper(method));


--
-- Name: uq_member_ws_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_member_ws_email ON public.members USING btree (workspace_id, email) WHERE ((deleted_at IS NULL) AND (email IS NOT NULL) AND ((email)::text <> ''::text));


--
-- Name: uq_pm_stripe_payment_method_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_pm_stripe_payment_method_id ON public.payment_methods USING btree (stripe_payment_method_id) WHERE (stripe_payment_method_id IS NOT NULL);


--
-- Name: uq_pm_stripe_payment_method_id_copy1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_pm_stripe_payment_method_id_copy1 ON public.payment_methods_copy1 USING btree (stripe_payment_method_id) WHERE (stripe_payment_method_id IS NOT NULL);


--
-- Name: uq_policy_configs_agent_policy_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_policy_configs_agent_policy_name ON public.policy_configs USING btree (workspace_id, lower((name)::text)) WHERE (type = 'agent_policy'::public.policy_type_enum);


--
-- Name: uq_policy_configs_id_workspace; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_policy_configs_id_workspace ON public.policy_configs USING btree (id, workspace_id);


--
-- Name: uq_policy_configs_ws_session_policy; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_policy_configs_ws_session_policy ON public.policy_configs USING btree (workspace_id) WHERE (type = 'session_policy'::public.policy_type_enum);


--
-- Name: uq_policy_configs_ws_session_policy_cn; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_policy_configs_ws_session_policy_cn ON public.policy_configs USING btree (workspace_id, type) WHERE (type = ANY (ARRAY['session_policy_c1'::public.policy_type_enum, 'session_policy_c2'::public.policy_type_enum, 'session_policy_c3'::public.policy_type_enum, 'session_policy_c4'::public.policy_type_enum, 'session_policy_c5'::public.policy_type_enum]));


--
-- Name: uq_sub_stripe_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_sub_stripe_customer_id ON public.subscriptions USING btree (stripe_customer_id) WHERE (stripe_customer_id IS NOT NULL);


--
-- Name: uq_workspaces_slug_active; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_workspaces_slug_active ON public.workspaces USING btree (slug) WHERE (deleted_at IS NULL);


--
-- Name: uq_x402_endpoint_secrets_active; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_x402_endpoint_secrets_active ON public.x402_endpoint_secrets USING btree (endpoint_id) WHERE (status = 'active'::public.x402_endpoint_secret_status_enum);


--
-- Name: uq_x402_endpoints_public_route; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_x402_endpoints_public_route ON public.x402_endpoints USING btree (endpoint_type, slug, method, path) WHERE (deleted_at IS NULL);


--
-- Name: uq_x402_payout_requests_idempotency; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_x402_payout_requests_idempotency ON public.x402_payout_requests USING btree (workspace_id, idempotency_key) WHERE ((idempotency_key IS NOT NULL) AND (idempotency_key <> ''::text));


--
-- Name: uq_x402_payouts_workspace_idempotency; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_x402_payouts_workspace_idempotency ON public.x402_payouts USING btree (workspace_id, idempotency_key) WHERE (idempotency_key IS NOT NULL);


--
-- Name: uq_x402_receive_wallet_default; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_x402_receive_wallet_default ON public.x402_receive_wallets USING btree (workspace_id) WHERE ((is_default = true) AND (deleted_at IS NULL));


--
-- Name: wallet_transfer_attempts_chain_tx_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX wallet_transfer_attempts_chain_tx_idx ON public.wallet_transfer_attempts USING btree (chain_tx_id) WHERE (chain_tx_id <> ''::text);


--
-- Name: wallet_transfer_attempts_status_next_attempt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX wallet_transfer_attempts_status_next_attempt_idx ON public.wallet_transfer_attempts USING btree (status, next_attempt_at);


--
-- Name: withdrawal_network_fee_accruals_residual_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX withdrawal_network_fee_accruals_residual_idx ON public.withdrawal_network_fee_accruals USING btree (workspace_id, environment, network, asset, source_account_id) INCLUDE (fee_minor_amount) WHERE ((fund_domain = 'workspace_funding'::text) AND (withdrawal_kind = 'wallet_withdrawal'::text) AND (status = ANY (ARRAY['confirmed_accrued'::text, 'settlement_pending'::text])));


--
-- Name: x402_payment_activities_selected_accept_hash_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX x402_payment_activities_selected_accept_hash_idx ON public.x402_payment_activities USING btree (selected_accept_hash);


--
-- Name: x402_payment_activities_selected_network_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX x402_payment_activities_selected_network_idx ON public.x402_payment_activities USING btree (selected_network);


--
-- Name: x402_payouts_payment_service_withdrawal_uidx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX x402_payouts_payment_service_withdrawal_uidx ON public.x402_payouts USING btree (payment_service_withdrawal_id) WHERE ((payment_service_withdrawal_id IS NOT NULL) AND (payment_service_withdrawal_id <> ''::text));


--
-- Name: insights_signal_definition insights_signal_definition_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER insights_signal_definition_updated_at BEFORE UPDATE ON public.insights_signal_definition FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: agents trg_agent_soft_delete_cascade; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_agent_soft_delete_cascade AFTER UPDATE OF deleted_at ON public.agents FOR EACH ROW WHEN (((old.deleted_at IS NULL) AND (new.deleted_at IS NOT NULL))) EXECUTE FUNCTION public.fn_soft_delete_cascade_vk();


--
-- Name: agents trg_agents_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_agents_set_updated_at BEFORE UPDATE ON public.agents FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();


--
-- Name: alert_rules trg_alert_rules_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_alert_rules_set_updated_at BEFORE UPDATE ON public.alert_rules FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();


--
-- Name: departments trg_departments_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_departments_set_updated_at BEFORE UPDATE ON public.departments FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();


--
-- Name: invitations trg_invitations_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_invitations_set_updated_at BEFORE UPDATE ON public.invitations FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();


--
-- Name: invoices trg_invoices_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_invoices_set_updated_at BEFORE UPDATE ON public.invoices FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();


--
-- Name: master_keys trg_master_keys_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_master_keys_set_updated_at BEFORE UPDATE ON public.master_keys FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();


--
-- Name: members trg_member_soft_delete_cascade; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_member_soft_delete_cascade AFTER UPDATE OF deleted_at ON public.members FOR EACH ROW WHEN (((old.deleted_at IS NULL) AND (new.deleted_at IS NOT NULL))) EXECUTE FUNCTION public.fn_soft_delete_cascade_vk();


--
-- Name: members trg_members_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_members_set_updated_at BEFORE UPDATE ON public.members FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();


--
-- Name: model_configs trg_model_configs_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_model_configs_set_updated_at BEFORE UPDATE ON public.model_configs FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();


--
-- Name: payment_methods trg_payment_methods_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_payment_methods_set_updated_at BEFORE UPDATE ON public.payment_methods FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();


--
-- Name: payment_methods_copy1 trg_payment_methods_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_payment_methods_set_updated_at BEFORE UPDATE ON public.payment_methods_copy1 FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();


--
-- Name: policy_configs trg_policy_configs_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_policy_configs_set_updated_at BEFORE UPDATE ON public.policy_configs FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();


--
-- Name: prompt_templates trg_prompt_templates_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_prompt_templates_set_updated_at BEFORE UPDATE ON public.prompt_templates FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();


--
-- Name: provider_configs trg_provider_configs_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_provider_configs_set_updated_at BEFORE UPDATE ON public.provider_configs FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();


--
-- Name: provider_models trg_provider_models_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_provider_models_set_updated_at BEFORE UPDATE ON public.provider_models FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();


--
-- Name: providers trg_providers_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_providers_set_updated_at BEFORE UPDATE ON public.providers FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();


--
-- Name: sales_leads trg_sales_leads_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_sales_leads_set_updated_at BEFORE UPDATE ON public.sales_leads FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();


--
-- Name: subscriptions trg_subscriptions_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_subscriptions_set_updated_at BEFORE UPDATE ON public.subscriptions FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();


--
-- Name: teams trg_teams_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_teams_set_updated_at BEFORE UPDATE ON public.teams FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();


--
-- Name: virtual_keys trg_virtual_keys_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_virtual_keys_set_updated_at BEFORE UPDATE ON public.virtual_keys FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();


--
-- Name: virtual_keys trg_vk_entity_validate; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_vk_entity_validate BEFORE INSERT OR UPDATE OF entity_type, entity_id ON public.virtual_keys FOR EACH ROW EXECUTE FUNCTION public.fn_validate_vk_entity();


--
-- Name: webhook_endpoints trg_webhook_endpoints_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_webhook_endpoints_set_updated_at BEFORE UPDATE ON public.webhook_endpoints FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();


--
-- Name: workspace_members trg_workspace_members_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_workspace_members_set_updated_at BEFORE UPDATE ON public.workspace_members FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();


--
-- Name: workspaces trg_workspaces_set_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trg_workspaces_set_updated_at BEFORE UPDATE ON public.workspaces FOR EACH ROW EXECUTE FUNCTION public.fn_set_updated_at();


--
-- Name: users users_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: workspace_insights_score_formula workspace_insights_score_formula_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER workspace_insights_score_formula_updated_at BEFORE UPDATE ON public.workspace_insights_score_formula FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: workspace_insights_signal_setting workspace_insights_signal_setting_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER workspace_insights_signal_setting_updated_at BEFORE UPDATE ON public.workspace_insights_signal_setting FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: active_alerts active_alerts_acknowledged_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_alerts
    ADD CONSTRAINT active_alerts_acknowledged_by_fkey FOREIGN KEY (acknowledged_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: active_alerts active_alerts_resolved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_alerts
    ADD CONSTRAINT active_alerts_resolved_by_fkey FOREIGN KEY (resolved_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: active_alerts active_alerts_rule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_alerts
    ADD CONSTRAINT active_alerts_rule_id_fkey FOREIGN KEY (rule_id) REFERENCES public.alert_rules(id) ON DELETE SET NULL;


--
-- Name: active_alerts active_alerts_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_alerts
    ADD CONSTRAINT active_alerts_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: agent_allowed_models agent_allowed_models_agent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent_allowed_models
    ADD CONSTRAINT agent_allowed_models_agent_id_fkey FOREIGN KEY (agent_id) REFERENCES public.agents(id) ON DELETE CASCADE;


--
-- Name: agent_allowed_models agent_allowed_models_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent_allowed_models
    ADD CONSTRAINT agent_allowed_models_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: agent_policy_bindings agent_policy_bindings_policy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent_policy_bindings
    ADD CONSTRAINT agent_policy_bindings_policy_id_fkey FOREIGN KEY (policy_id) REFERENCES public.policy_configs(id) ON DELETE RESTRICT;


--
-- Name: agent_policy_bindings agent_policy_bindings_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent_policy_bindings
    ADD CONSTRAINT agent_policy_bindings_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: agent_runtime_configs agent_runtime_configs_agent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent_runtime_configs
    ADD CONSTRAINT agent_runtime_configs_agent_id_fkey FOREIGN KEY (agent_id) REFERENCES public.agents(id) ON DELETE CASCADE;


--
-- Name: agent_runtime_configs agent_runtime_configs_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent_runtime_configs
    ADD CONSTRAINT agent_runtime_configs_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: agent_stream_keys agent_stream_keys_agent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent_stream_keys
    ADD CONSTRAINT agent_stream_keys_agent_id_fkey FOREIGN KEY (agent_id) REFERENCES public.agents(id) ON DELETE CASCADE;


--
-- Name: agent_stream_keys agent_stream_keys_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent_stream_keys
    ADD CONSTRAINT agent_stream_keys_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: agents agents_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents
    ADD CONSTRAINT agents_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON DELETE SET NULL;


--
-- Name: agents agents_provider_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents
    ADD CONSTRAINT agents_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES public.providers(id);


--
-- Name: agents agents_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agents
    ADD CONSTRAINT agents_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: alert_rules alert_rules_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alert_rules
    ADD CONSTRAINT alert_rules_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: audit_logs audit_logs_actor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: audit_logs audit_logs_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: departments departments_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.workspace_members(id) ON DELETE SET NULL;


--
-- Name: departments departments_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: agent_policy_bindings fk_agent_policy_bindings_policy_workspace; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent_policy_bindings
    ADD CONSTRAINT fk_agent_policy_bindings_policy_workspace FOREIGN KEY (policy_id, workspace_id) REFERENCES public.policy_configs(id, workspace_id) ON DELETE RESTRICT;


--
-- Name: agent_runtime_configs fk_agent_runtime_configs_agent_workspace; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agent_runtime_configs
    ADD CONSTRAINT fk_agent_runtime_configs_agent_workspace FOREIGN KEY (agent_id, workspace_id) REFERENCES public.agents(id, workspace_id) ON DELETE CASCADE;


--
-- Name: invitations invitations_invited_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT invitations_invited_by_fkey FOREIGN KEY (invited_by) REFERENCES public.users(id);


--
-- Name: invitations invitations_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT invitations_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: invoice_line_items invoice_line_items_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_line_items
    ADD CONSTRAINT invoice_line_items_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.invoices(id) ON DELETE CASCADE;


--
-- Name: invoice_line_items invoice_line_items_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_line_items
    ADD CONSTRAINT invoice_line_items_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: invoices invoices_subscription_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_subscription_id_fkey FOREIGN KEY (subscription_id) REFERENCES public.subscriptions(id) ON DELETE RESTRICT;


--
-- Name: invoices invoices_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


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
-- Name: log_overage_reports log_overage_reports_subscription_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.log_overage_reports
    ADD CONSTRAINT log_overage_reports_subscription_id_fkey FOREIGN KEY (subscription_id) REFERENCES public.subscriptions(id) ON DELETE CASCADE;


--
-- Name: log_overage_reports log_overage_reports_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.log_overage_reports
    ADD CONSTRAINT log_overage_reports_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: managed_wallet_saas_commands managed_wallet_saas_commands_destination_wallet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.managed_wallet_saas_commands
    ADD CONSTRAINT managed_wallet_saas_commands_destination_wallet_id_fkey FOREIGN KEY (destination_wallet_id) REFERENCES public.x402_receive_wallets(id) ON DELETE RESTRICT;


--
-- Name: master_key_departments master_key_departments_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_key_departments
    ADD CONSTRAINT master_key_departments_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON DELETE CASCADE;


--
-- Name: master_key_departments master_key_departments_master_key_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_key_departments
    ADD CONSTRAINT master_key_departments_master_key_id_fkey FOREIGN KEY (master_key_id) REFERENCES public.master_keys(id) ON DELETE CASCADE;


--
-- Name: master_key_departments master_key_departments_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_key_departments
    ADD CONSTRAINT master_key_departments_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: master_keys master_keys_provider_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_keys
    ADD CONSTRAINT master_keys_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES public.providers(id);


--
-- Name: master_keys master_keys_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_keys
    ADD CONSTRAINT master_keys_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: members members_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON DELETE SET NULL;


--
-- Name: members members_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: members members_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: model_configs model_configs_provider_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.model_configs
    ADD CONSTRAINT model_configs_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES public.providers(id);


--
-- Name: model_configs model_configs_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.model_configs
    ADD CONSTRAINT model_configs_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: notification_preferences notification_preferences_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_preferences
    ADD CONSTRAINT notification_preferences_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: notifications notifications_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


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


--
-- Name: partner_payouts partner_payouts_partner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.partner_payouts
    ADD CONSTRAINT partner_payouts_partner_id_fkey FOREIGN KEY (partner_id) REFERENCES public.partner_profiles(partner_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: partner_profile_models partner_profile_models_partner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.partner_profile_models
    ADD CONSTRAINT partner_profile_models_partner_id_fkey FOREIGN KEY (partner_id) REFERENCES public.partner_profiles(partner_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: partner_profile_models partner_profile_models_route_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.partner_profile_models
    ADD CONSTRAINT partner_profile_models_route_id_fkey FOREIGN KEY (route_id) REFERENCES public.key_market_model_routes(id) ON DELETE CASCADE;


--
-- Name: partner_profiles partner_profiles_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.partner_profiles
    ADD CONSTRAINT partner_profiles_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.openmodels_accounts(id) ON DELETE CASCADE;


--
-- Name: payment_methods_copy1 payment_methods_copy1_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_methods_copy1
    ADD CONSTRAINT payment_methods_copy1_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: payment_methods payment_methods_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: personal_access_tokens personal_access_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: personal_access_tokens personal_access_tokens_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: platform_fee_withdrawals platform_fee_withdrawals_platform_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platform_fee_withdrawals
    ADD CONSTRAINT platform_fee_withdrawals_platform_account_id_fkey FOREIGN KEY (platform_account_id) REFERENCES public.managed_wallet_accounts(id);


--
-- Name: platform_revenue_balances platform_revenue_balances_source_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platform_revenue_balances
    ADD CONSTRAINT platform_revenue_balances_source_account_id_fkey FOREIGN KEY (source_account_id) REFERENCES public.managed_wallet_accounts(id);


--
-- Name: platform_revenue_ledger_postings platform_revenue_ledger_postings_ledger_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platform_revenue_ledger_postings
    ADD CONSTRAINT platform_revenue_ledger_postings_ledger_transaction_id_fkey FOREIGN KEY (ledger_transaction_id) REFERENCES public.platform_revenue_ledger_transactions(id);


--
-- Name: platform_revenue_ledger_transactions platform_revenue_ledger_transactions_source_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.platform_revenue_ledger_transactions
    ADD CONSTRAINT platform_revenue_ledger_transactions_source_account_id_fkey FOREIGN KEY (source_account_id) REFERENCES public.managed_wallet_accounts(id);


--
-- Name: policy_configs policy_configs_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.policy_configs
    ADD CONSTRAINT policy_configs_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: policy_overrides policy_overrides_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.policy_overrides
    ADD CONSTRAINT policy_overrides_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON DELETE CASCADE;


--
-- Name: policy_overrides policy_overrides_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.policy_overrides
    ADD CONSTRAINT policy_overrides_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: private_deployment_contracts private_deployment_contracts_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.private_deployment_contracts
    ADD CONSTRAINT private_deployment_contracts_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: private_deployment_contracts private_deployment_contracts_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.private_deployment_contracts
    ADD CONSTRAINT private_deployment_contracts_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public.users(id);


--
-- Name: private_deployment_licenses private_deployment_licenses_contract_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.private_deployment_licenses
    ADD CONSTRAINT private_deployment_licenses_contract_id_fkey FOREIGN KEY (contract_id) REFERENCES public.private_deployment_contracts(id);


--
-- Name: private_deployment_licenses private_deployment_licenses_issued_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.private_deployment_licenses
    ADD CONSTRAINT private_deployment_licenses_issued_by_fkey FOREIGN KEY (issued_by) REFERENCES public.users(id);


--
-- Name: private_deployment_licenses private_deployment_licenses_revoked_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.private_deployment_licenses
    ADD CONSTRAINT private_deployment_licenses_revoked_by_fkey FOREIGN KEY (revoked_by) REFERENCES public.users(id);


--
-- Name: prompt_bindings prompt_bindings_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prompt_bindings
    ADD CONSTRAINT prompt_bindings_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.prompt_templates(id) ON DELETE CASCADE;


--
-- Name: prompt_templates prompt_templates_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prompt_templates
    ADD CONSTRAINT prompt_templates_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: prompt_templates prompt_templates_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prompt_templates
    ADD CONSTRAINT prompt_templates_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: prompt_versions prompt_versions_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prompt_versions
    ADD CONSTRAINT prompt_versions_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: prompt_versions prompt_versions_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prompt_versions
    ADD CONSTRAINT prompt_versions_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.prompt_templates(id) ON DELETE CASCADE;


--
-- Name: provider_configs provider_configs_provider_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provider_configs
    ADD CONSTRAINT provider_configs_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES public.providers(id);


--
-- Name: provider_configs provider_configs_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provider_configs
    ADD CONSTRAINT provider_configs_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: provider_models provider_models_provider_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.provider_models
    ADD CONSTRAINT provider_models_provider_id_fkey FOREIGN KEY (provider_id) REFERENCES public.providers(id) ON DELETE CASCADE;


--
-- Name: refresh_sessions refresh_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refresh_sessions
    ADD CONSTRAINT refresh_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: revenue_reservation_consumptions revenue_reservation_consumptions_revenue_withdrawal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revenue_reservation_consumptions
    ADD CONSTRAINT revenue_reservation_consumptions_revenue_withdrawal_id_fkey FOREIGN KEY (revenue_withdrawal_id) REFERENCES public.revenue_withdrawals(id);


--
-- Name: revenue_withdrawals revenue_withdrawals_platform_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revenue_withdrawals
    ADD CONSTRAINT revenue_withdrawals_platform_account_id_fkey FOREIGN KEY (platform_account_id) REFERENCES public.managed_wallet_accounts(id);


--
-- Name: sales_leads sales_leads_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales_leads
    ADD CONSTRAINT sales_leads_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: sales_leads sales_leads_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sales_leads
    ADD CONSTRAINT sales_leads_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE SET NULL;


--
-- Name: subscription_events subscription_events_subscription_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscription_events
    ADD CONSTRAINT subscription_events_subscription_id_fkey FOREIGN KEY (subscription_id) REFERENCES public.subscriptions(id) ON DELETE CASCADE;


--
-- Name: subscription_events subscription_events_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscription_events
    ADD CONSTRAINT subscription_events_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: subscriptions subscriptions_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: teams teams_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: virtual_keys virtual_keys_master_key_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.virtual_keys
    ADD CONSTRAINT virtual_keys_master_key_id_fkey FOREIGN KEY (master_key_id) REFERENCES public.master_keys(id) ON DELETE RESTRICT;


--
-- Name: virtual_keys virtual_keys_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.virtual_keys
    ADD CONSTRAINT virtual_keys_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: wallet_chain_events wallet_chain_events_claimed_by_deposit_intent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet_chain_events
    ADD CONSTRAINT wallet_chain_events_claimed_by_deposit_intent_id_fkey FOREIGN KEY (claimed_by_deposit_intent_id) REFERENCES public.wallet_deposit_intents(id);


--
-- Name: wallet_deposit_intents wallet_deposit_intents_managed_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet_deposit_intents
    ADD CONSTRAINT wallet_deposit_intents_managed_account_id_fkey FOREIGN KEY (managed_account_id) REFERENCES public.managed_wallet_accounts(id);


--
-- Name: wallet_ledger_postings wallet_ledger_postings_ledger_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet_ledger_postings
    ADD CONSTRAINT wallet_ledger_postings_ledger_transaction_id_fkey FOREIGN KEY (ledger_transaction_id) REFERENCES public.wallet_ledger_transactions(id);


--
-- Name: wallet_withdrawals wallet_withdrawals_managed_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wallet_withdrawals
    ADD CONSTRAINT wallet_withdrawals_managed_account_id_fkey FOREIGN KEY (managed_account_id) REFERENCES public.managed_wallet_accounts(id);


--
-- Name: webhook_deliveries webhook_deliveries_endpoint_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webhook_deliveries
    ADD CONSTRAINT webhook_deliveries_endpoint_id_fkey FOREIGN KEY (endpoint_id) REFERENCES public.webhook_endpoints(id) ON DELETE CASCADE;


--
-- Name: webhook_deliveries webhook_deliveries_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webhook_deliveries
    ADD CONSTRAINT webhook_deliveries_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: webhook_endpoints webhook_endpoints_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webhook_endpoints
    ADD CONSTRAINT webhook_endpoints_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: workspace_insights_score_formula workspace_insights_score_formula_updated_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspace_insights_score_formula
    ADD CONSTRAINT workspace_insights_score_formula_updated_by_user_id_fkey FOREIGN KEY (updated_by_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: workspace_insights_score_formula workspace_insights_score_formula_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspace_insights_score_formula
    ADD CONSTRAINT workspace_insights_score_formula_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: workspace_insights_signal_setting workspace_insights_signal_setting_signal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspace_insights_signal_setting
    ADD CONSTRAINT workspace_insights_signal_setting_signal_id_fkey FOREIGN KEY (signal_id) REFERENCES public.insights_signal_definition(signal_id);


--
-- Name: workspace_insights_signal_setting workspace_insights_signal_setting_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspace_insights_signal_setting
    ADD CONSTRAINT workspace_insights_signal_setting_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: workspace_members workspace_members_invited_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspace_members
    ADD CONSTRAINT workspace_members_invited_by_fkey FOREIGN KEY (invited_by) REFERENCES public.users(id);


--
-- Name: workspace_members workspace_members_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspace_members
    ADD CONSTRAINT workspace_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: workspace_members workspace_members_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspace_members
    ADD CONSTRAINT workspace_members_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: workspaces workspaces_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workspaces
    ADD CONSTRAINT workspaces_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: x402_endpoint_market_listings x402_endpoint_market_listings_endpoint_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoint_market_listings
    ADD CONSTRAINT x402_endpoint_market_listings_endpoint_id_fkey FOREIGN KEY (endpoint_id) REFERENCES public.x402_endpoints(id) ON DELETE CASCADE;


--
-- Name: x402_endpoint_market_listings x402_endpoint_market_listings_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoint_market_listings
    ADD CONSTRAINT x402_endpoint_market_listings_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: x402_endpoint_networks x402_endpoint_networks_endpoint_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoint_networks
    ADD CONSTRAINT x402_endpoint_networks_endpoint_id_fkey FOREIGN KEY (endpoint_id) REFERENCES public.x402_endpoints(id) ON DELETE CASCADE;


--
-- Name: x402_endpoint_networks x402_endpoint_networks_receive_wallet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoint_networks
    ADD CONSTRAINT x402_endpoint_networks_receive_wallet_id_fkey FOREIGN KEY (receive_wallet_id) REFERENCES public.x402_receive_wallets(id) ON DELETE RESTRICT;


--
-- Name: x402_endpoint_networks x402_endpoint_networks_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoint_networks
    ADD CONSTRAINT x402_endpoint_networks_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: x402_endpoint_policies x402_endpoint_policies_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoint_policies
    ADD CONSTRAINT x402_endpoint_policies_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: x402_endpoint_secret_events x402_endpoint_secret_events_actor_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoint_secret_events
    ADD CONSTRAINT x402_endpoint_secret_events_actor_user_id_fkey FOREIGN KEY (actor_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: x402_endpoint_secret_events x402_endpoint_secret_events_endpoint_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoint_secret_events
    ADD CONSTRAINT x402_endpoint_secret_events_endpoint_id_fkey FOREIGN KEY (endpoint_id) REFERENCES public.x402_endpoints(id) ON DELETE CASCADE;


--
-- Name: x402_endpoint_secret_events x402_endpoint_secret_events_secret_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoint_secret_events
    ADD CONSTRAINT x402_endpoint_secret_events_secret_id_fkey FOREIGN KEY (secret_id) REFERENCES public.x402_endpoint_secrets(id) ON DELETE SET NULL;


--
-- Name: x402_endpoint_secret_events x402_endpoint_secret_events_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoint_secret_events
    ADD CONSTRAINT x402_endpoint_secret_events_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: x402_endpoint_secrets x402_endpoint_secrets_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoint_secrets
    ADD CONSTRAINT x402_endpoint_secrets_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: x402_endpoint_secrets x402_endpoint_secrets_endpoint_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoint_secrets
    ADD CONSTRAINT x402_endpoint_secrets_endpoint_id_fkey FOREIGN KEY (endpoint_id) REFERENCES public.x402_endpoints(id) ON DELETE CASCADE;


--
-- Name: x402_endpoint_secrets x402_endpoint_secrets_revoked_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoint_secrets
    ADD CONSTRAINT x402_endpoint_secrets_revoked_by_fkey FOREIGN KEY (revoked_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: x402_endpoint_secrets x402_endpoint_secrets_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoint_secrets
    ADD CONSTRAINT x402_endpoint_secrets_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: x402_endpoints x402_endpoints_agent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoints
    ADD CONSTRAINT x402_endpoints_agent_id_fkey FOREIGN KEY (agent_id) REFERENCES public.agents(id) ON DELETE SET NULL;


--
-- Name: x402_endpoints x402_endpoints_policy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoints
    ADD CONSTRAINT x402_endpoints_policy_id_fkey FOREIGN KEY (policy_id) REFERENCES public.x402_endpoint_policies(id) ON DELETE RESTRICT;


--
-- Name: x402_endpoints x402_endpoints_receive_wallet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoints
    ADD CONSTRAINT x402_endpoints_receive_wallet_id_fkey FOREIGN KEY (receive_wallet_id) REFERENCES public.x402_receive_wallets(id) ON DELETE RESTRICT;


--
-- Name: x402_endpoints x402_endpoints_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_endpoints
    ADD CONSTRAINT x402_endpoints_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: x402_facilitator_attempts x402_facilitator_attempts_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_facilitator_attempts
    ADD CONSTRAINT x402_facilitator_attempts_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES public.x402_payment_activities(id) ON DELETE CASCADE;


--
-- Name: x402_payment_activities x402_payment_activities_split_treasury_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_payment_activities
    ADD CONSTRAINT x402_payment_activities_split_treasury_id_fkey FOREIGN KEY (split_treasury_id) REFERENCES public.x402_split_treasuries(id) ON DELETE SET NULL;


--
-- Name: x402_payment_idempotency_keys x402_payment_idempotency_keys_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_payment_idempotency_keys
    ADD CONSTRAINT x402_payment_idempotency_keys_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES public.x402_payment_activities(id) ON DELETE CASCADE;


--
-- Name: x402_payouts x402_payouts_created_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_payouts
    ADD CONSTRAINT x402_payouts_created_by_user_id_fkey FOREIGN KEY (created_by_user_id) REFERENCES public.users(id);


--
-- Name: x402_payouts x402_payouts_destination_wallet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_payouts
    ADD CONSTRAINT x402_payouts_destination_wallet_id_fkey FOREIGN KEY (destination_wallet_id) REFERENCES public.x402_receive_wallets(id) ON DELETE RESTRICT;


--
-- Name: x402_payouts x402_payouts_platform_wallet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_payouts
    ADD CONSTRAINT x402_payouts_platform_wallet_id_fkey FOREIGN KEY (platform_wallet_id) REFERENCES public.x402_platform_wallets(id) ON DELETE SET NULL;


--
-- Name: x402_receive_wallets x402_receive_wallets_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_receive_wallets
    ADD CONSTRAINT x402_receive_wallets_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: x402_revenue_withdrawal_reservation_items x402_revenue_withdrawal_reservation_items_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_revenue_withdrawal_reservation_items
    ADD CONSTRAINT x402_revenue_withdrawal_reservation_items_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES public.x402_payment_activities(id) ON DELETE RESTRICT;


--
-- Name: x402_revenue_withdrawal_reservation_items x402_revenue_withdrawal_reservation_items_reservation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_revenue_withdrawal_reservation_items
    ADD CONSTRAINT x402_revenue_withdrawal_reservation_items_reservation_id_fkey FOREIGN KEY (reservation_id) REFERENCES public.x402_revenue_withdrawal_reservations(id) ON DELETE CASCADE;


--
-- Name: x402_revenue_withdrawal_reservation_items x402_revenue_withdrawal_reservation_items_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_revenue_withdrawal_reservation_items
    ADD CONSTRAINT x402_revenue_withdrawal_reservation_items_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: x402_revenue_withdrawal_reservations x402_revenue_withdrawal_reservations_created_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_revenue_withdrawal_reservations
    ADD CONSTRAINT x402_revenue_withdrawal_reservations_created_by_user_id_fkey FOREIGN KEY (created_by_user_id) REFERENCES public.users(id);


--
-- Name: x402_revenue_withdrawal_reservations x402_revenue_withdrawal_reservations_destination_wallet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_revenue_withdrawal_reservations
    ADD CONSTRAINT x402_revenue_withdrawal_reservations_destination_wallet_id_fkey FOREIGN KEY (destination_wallet_id) REFERENCES public.x402_receive_wallets(id);


--
-- Name: x402_revenue_withdrawal_reservations x402_revenue_withdrawal_reservations_payout_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_revenue_withdrawal_reservations
    ADD CONSTRAINT x402_revenue_withdrawal_reservations_payout_id_fkey FOREIGN KEY (payout_id) REFERENCES public.x402_payouts(id) ON DELETE CASCADE;


--
-- Name: x402_revenue_withdrawal_reservations x402_revenue_withdrawal_reservations_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_revenue_withdrawal_reservations
    ADD CONSTRAINT x402_revenue_withdrawal_reservations_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: x402_settlements x402_settlements_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_settlements
    ADD CONSTRAINT x402_settlements_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES public.x402_payment_activities(id) ON DELETE CASCADE;


--
-- Name: x402_settlements x402_settlements_split_treasury_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_settlements
    ADD CONSTRAINT x402_settlements_split_treasury_id_fkey FOREIGN KEY (split_treasury_id) REFERENCES public.x402_split_treasuries(id) ON DELETE SET NULL;


--
-- Name: x402_spend_agent_bindings x402_spend_agent_bindings_agent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_spend_agent_bindings
    ADD CONSTRAINT x402_spend_agent_bindings_agent_id_fkey FOREIGN KEY (agent_id) REFERENCES public.agents(id) ON DELETE CASCADE;


--
-- Name: x402_spend_agent_bindings x402_spend_agent_bindings_policy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_spend_agent_bindings
    ADD CONSTRAINT x402_spend_agent_bindings_policy_id_fkey FOREIGN KEY (policy_id) REFERENCES public.x402_spend_policies(id) ON DELETE RESTRICT;


--
-- Name: x402_spend_agent_bindings x402_spend_agent_bindings_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_spend_agent_bindings
    ADD CONSTRAINT x402_spend_agent_bindings_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: x402_spend_policies x402_spend_policies_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_spend_policies
    ADD CONSTRAINT x402_spend_policies_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: x402_spend_wallet_movements x402_spend_wallet_movements_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_spend_wallet_movements
    ADD CONSTRAINT x402_spend_wallet_movements_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.x402_spend_wallet_accounts(id) ON DELETE CASCADE;


--
-- Name: x402_spend_wallet_movements x402_spend_wallet_movements_top_up_intent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_spend_wallet_movements
    ADD CONSTRAINT x402_spend_wallet_movements_top_up_intent_id_fkey FOREIGN KEY (top_up_intent_id) REFERENCES public.x402_spend_wallet_top_up_intents(id) ON DELETE SET NULL;


--
-- Name: x402_spend_wallet_top_up_intents x402_spend_wallet_top_up_intents_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_spend_wallet_top_up_intents
    ADD CONSTRAINT x402_spend_wallet_top_up_intents_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.x402_spend_wallet_accounts(id) ON DELETE CASCADE;


--
-- Name: x402_split_sweep_batches x402_split_sweep_batches_split_treasury_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_split_sweep_batches
    ADD CONSTRAINT x402_split_sweep_batches_split_treasury_id_fkey FOREIGN KEY (split_treasury_id) REFERENCES public.x402_split_treasuries(id) ON DELETE CASCADE;


--
-- Name: x402_split_sweep_distributions x402_split_sweep_distributions_batch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_split_sweep_distributions
    ADD CONSTRAINT x402_split_sweep_distributions_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.x402_split_sweep_batches(id) ON DELETE CASCADE;


--
-- Name: x402_workspace_payment_settings x402_workspace_payment_settings_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_workspace_payment_settings
    ADD CONSTRAINT x402_workspace_payment_settings_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;


--
-- Name: x402_workspace_spend_ceilings x402_workspace_spend_ceilings_workspace_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.x402_workspace_spend_ceilings
    ADD CONSTRAINT x402_workspace_spend_ceilings_workspace_id_fkey FOREIGN KEY (workspace_id) REFERENCES public.workspaces(id) ON DELETE CASCADE;















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
INSERT INTO "public"."providers" ("id", "code", "name", "icon_url", "logo_url", "default_base_url", "sort_order", "enabled", "created_at", "updated_at", "is_router", "cn_base_url") VALUES ('db1cbfcb-8d6d-4a55-9ddb-c1e638738b38', 'openmodels', 'OpenModels', NULL, NULL, 'https://api.getopenmodels.com/v1', 1, 't', '2026-07-08 13:05:16.464902+00', '2026-07-08 13:05:16.464902+00', 'f', NULL);

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

