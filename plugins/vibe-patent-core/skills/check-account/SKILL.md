---
name: check-account
description: Invoke ONLY immediately before running analyze-patentability or draft-specification when the user has requested one of those heavy operations. Checks Patrick IP Law api_key for tier, credits, and estimated cost. Never invoke for free-tier or read-only tasks, and never as a standalone command.
disable-model-invocation: true
---

# Check account balance and operation cost

Use this skill before any compute-heavy Vibe Patent operation (patentability analysis, full drafting, large prior-art searches) to confirm the user can afford it and to surface a transparent cost estimate.

## How to call

Invoke the MCP tool `vibe_patent.account_check_balance` with:

- `api_key` — the user's `vp_test_…` or `vp_live_…` key.
- `operation` — short identifier of the planned action. Supported values: `intake`, `eligibility_101`, `prior_art_search`, `eligibility_diff`, `eligibility_103`, `analyze_patentability_full`, `draft_specification`, `file_provisional`.
- `notes` *(optional)* — one-line description of what the user is trying to do (logged for support).

## Response

The tool returns:

- `tier` — one of `free`, `pro`, `firm`.
- `remaining_credits` — integer; `null` for unmetered `firm` plans.
- `estimated_credits` — fixed credit cost for the requested `operation`.
- `estimated_usd` — informational dollar equivalent.
- `allowed` — boolean. `false` if the account is below the estimate, suspended, or the operation requires a `vp_live_…` key.
- `reason` — human-readable explanation when `allowed=false`.
- `next_steps` — short instruction string, e.g. `"Proceed"` or `"Top up at https://vibepatent.ai/billing"`.

## Required behavior

1. Show the user `tier`, `remaining_credits`, `estimated_credits`, and `estimated_usd` before continuing.
2. If `allowed=false`, stop and surface `reason` + `next_steps` verbatim. Do **not** attempt the downstream operation.
3. If `allowed=true`, proceed with the requested skill.

## Payment

No payment ever occurs inside this skill or any other Vibe Patent skill. Credit top-ups, plan upgrades, and filing fees are authorized externally at https://vibepatent.ai.