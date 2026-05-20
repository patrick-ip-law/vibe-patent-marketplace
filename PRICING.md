# Vibe Patent — Pricing & Credit Ledger

All pricing and credit consumption is enforced **server-side** by the Vibe Patent v1 API. The plugin never charges; charges and top-ups are authorized externally at https://vibepatent.ai.

## Tiers

| Tier | Monthly credits | Keys | Notes |
| --- | ---: | --- | --- |
| **Free** | 25 | `vp_test_…` (sandbox) + throttled `vp_live_…` | Default on signup |
| **Pro** | 500 | `vp_live_…` | Monthly subscription |
| **Firm** | Unmetered analysis/drafting | `vp_live_…` | Monthly subscription |

Admin/reviewer accounts are exempt from quota limits during the Anthropic review window.

## Credit costs (fixed, server-enforced)

| Operation | Credits | ~USD |
| --- | ---: | ---: |
| `intake` | 1 | $0.05 |
| `eligibility_101` | 3 | $0.15 |
| `prior_art_search` | 8 | $0.40 |
| `eligibility_diff` | 5 | $0.25 |
| `eligibility_103` | 5 | $0.25 |
| `analyze_patentability_full` | 20 | $1.00 |
| `draft_specification` | 40 | $2.00 |
| `file_provisional` | 0 (attorney fee billed externally) | — |

Authoritative values are returned by `vibe_patent.account_check_balance` (`estimated_credits`, `estimated_usd`). The plugin must surface these to the user before running any heavy operation.

## Filing fee

- **$250 flat** attorney fee for limited-scope Attorney Review and USPTO Provisional Filing Preparation by Patrick IP Law.
- USPTO government fees (micro / small / large entity) are billed separately at filing.
- Payment is authorized externally via Stripe on https://vibepatent.ai after the client reviews the attorney summary and limited-scope waiver. **No payment ever occurs inside the plugin.**

## How credits are consumed

1. User invokes a heavy skill (e.g. `analyze-patentability`).
2. Skill calls `vibe-patent-core:check-account` -> MCP tool `vibe_patent.account_check_balance`.
3. Server returns `tier`, `remaining_credits`, `estimated_credits`, `estimated_usd`, `allowed`.
4. If `allowed=true`, the heavy tool runs and the server **deducts the fixed credit cost on completion** (logged in `api_usage_logs` with `distribution_channel="marketplace_partner"`).
5. If `allowed=false`, the skill stops and surfaces `reason` + `next_steps` (typically a top-up link).

## Top-ups

- Buy additional credits or upgrade tier at https://vibepatent.ai/billing.
- Top-ups are reflected in the next `check-account` call (no plugin restart needed).

## Refunds

Credit refunds for failed server-side operations are automatic. Filing fee refunds follow the engagement terms at https://vibepatent.ai/terms.
