---
name: intake-invention
description: Use ONLY when the user explicitly asks to start, draft, or capture a new patent invention disclosure on the Vibe Patent platform. Interviews the user turn-by-turn (title, problem, operation, variations, applications) and finalizes a structured disclosure record via the Vibe Patent v1 API. Requires an `api_key` (vp_test_… for sandbox or vp_live_… for production). Downstream attorney review and USPTO filing are authorized externally on https://vibepatent.ai. No payment is processed inside this plugin.
disable-model-invocation: true
---

# Intake an invention disclosure

Use this skill only when the user explicitly asks to start, draft, or capture a new patent invention disclosure for the Vibe Patent platform.

Walk the user through:
1. Title and one-sentence summary.
2. Problem being solved and the field of art.
3. How the invention operates (step-by-step).
4. Material variations and alternative embodiments.
5. Target applications and commercial context.

When the user confirms they are done, finalize the disclosure via the `vibe_patent.disclosure_intake` tool with `finalize=true` to produce a structured JSON record.

## Authentication

This skill calls the Vibe Patent v1 API. Pass your account key as the `api_key` argument on every tool call.

- Test keys: `vp_test_…` (sandbox, no charges)
- Live keys: `vp_live_…` (production; full attorney review and filing require an active Patrick IP Law account at https://vibepatent.ai)

## Attorney Review and Provisional Filing Preparation

Filing-related actions never charge inside this skill. Payment is authorized externally on https://vibepatent.ai after the client reviews the attorney summary and limited-scope waiver.
