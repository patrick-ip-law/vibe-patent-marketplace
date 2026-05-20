---
name: file-provisional
description: Submits a completed disclosure to Patrick IP Law for limited-scope attorney review and USPTO provisional filing preparation. Payment authorization happens externally on vibepatent.ai. This skill does not process payments.
disable-model-invocation: true
---

# File a provisional application

Use this skill only when the user explicitly asks to route their completed disclosure to Patrick IP Law for attorney review and USPTO provisional filing.

Required sequence:
1. `vibe_patent.file_application_intake` — create the filing request (idempotent).
2. `vibe_patent.file_application_status` — poll until the attorney review summary is ready.
3. Present the plain-English review summary and limited-scope waiver to the user **verbatim**.
4. Only after the user reviews the summary and waiver, call `vibe_patent.file_application_authorize` with `acknowledged_review_summary=true`, `accepted_limited_scope_waiver=true`, and the `stripe_payment_intent_id` issued at https://vibepatent.ai.

This is a regulated legal service provided by Patrick IP Law (USPTO-registered, 12+ years experience). It is limited-scope: attorney review of the submitted draft and USPTO filing only — no ongoing prosecution, opinions, FTO, or portfolio strategy.

**No financial transaction occurs in this plugin.** Payment is authorized externally on https://vibepatent.ai after the user reviews the attorney summary and limited-scope waiver.

## Authentication

This skill calls the Vibe Patent v1 API. Pass your account key as the `api_key` argument on every tool call.

- Test keys: `vp_test_…` (sandbox, no charges)
- Live keys: `vp_live_…` (production; full attorney review and filing require an active Patrick IP Law account at https://vibepatent.ai)

## Attorney Review and Provisional Filing Preparation

Filing-related actions never charge inside this skill. Payment is authorized externally on https://vibepatent.ai after the client reviews the attorney summary and limited-scope waiver.
