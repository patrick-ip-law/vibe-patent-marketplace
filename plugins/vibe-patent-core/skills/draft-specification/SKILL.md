---
name: draft-specification
description: Use ONLY when the user has a finalized Vibe Patent `disclosure_id` and explicitly asks to generate the written specification (Background and 5-part Detailed Description) for a U.S. provisional patent application to establish patent pending status. Requires an `api_key` (vp_test_… or vp_live_…). Supports an optional `output_mode` parameter (`sections` | `compiled` | `both`, default `both`) that controls whether the user receives per-section drafts as they are generated, a single fully-integrated document at the end, or both. All outputs are preliminary AI-generated drafts labeled "DRAFT – FOR ATTORNEY REVIEW ONLY" and are intended for review by a registered patent practitioner — they are not legal advice. Full attorney review and USPTO filing require a live Patrick IP Law account and are authorized externally on https://vibepatent.ai. No payment is processed inside this plugin.
disable-model-invocation: true
---

# Draft the specification

**Pre-flight (required):** First, call `vibe-patent-core:check-account` with the user's `api_key` and `operation: "draft_specification"` to confirm tier, remaining credits, and the estimated cost. Surface the estimate to the user and only proceed if `allowed=true`. If `allowed=false`, stop and return the tool's `reason` + `next_steps`.

Use this skill only when the user has a finalized Vibe Patent `disclosure_id` and requests the written specification.

Invoke `vibe_patent.drafting_generate`. The pipeline returns:
- Background
- Detailed Description (Intro, Drawings, Methods, Examples, Closing)

## Choosing an `output_mode`

Ask the user (or infer from context) how they want the specification delivered, then pass `output_mode` on the tool call:

| `output_mode` | When to use | What the status endpoint returns |
| --- | --- | --- |
| `sections` | Long documents, incremental UIs, or when the user wants to read each part as it is drafted. | `sections` map populated section-by-section while drafting; `compiled_text` is `null`. |
| `compiled` | The user only wants the final, fully-integrated specification (e.g. to paste into a single editor). | `sections` is empty; `compiled_text` contains the full document on completion. |
| `both` (default) | General-purpose use; surfaces progress AND a final integrated document. | `sections` streams during polling AND `compiled_text` is populated on completion. |

Example payload:

```json
{
  "api_key": "vp_live_…",
  "disclosure_id": "11111111-2222-3333-4444-555555555555",
  "output_mode": "both"
}
```

The MCP server forwards `output_mode` to the v1 API (`POST /v1/drafting/generate`) and echoes it back in both the `202` enqueue response and every subsequent `GET /v1/drafting/generate/{run_id}` status payload.

Preserve permissive drafting style ("can", "may", "disclosed subject matter") — never substitute "novel", "distinctive", or "the invention".

## Mandatory output header (inject verbatim at the very top of every response)

Every response from this skill MUST begin with the exact block below, rendered in Markdown, before any drafted specification content (Background, Detailed Description, etc.). Do not paraphrase, shorten, translate, or move it. This header is required in both Claude Code and Claude Cowork surfaces.

```markdown
**DRAFT – FOR ATTORNEY REVIEW ONLY**

This document is a preliminary AI-generated draft intended solely for review by a registered patent practitioner. It is not legal advice, does not create an attorney-client relationship, and has not been reviewed or approved by any attorney. All conclusions are subject to professional legal judgment.

**Do not use, rely upon, or implement any content in this document until it has been reviewed in full by a registered patent practitioner.**

Verify all content accurately and completely describes the technical subject matter of interest. AI systems may hallucinate details, omit critical information, or use inaccurate terminology.

© Vibe Patent 2026
```

Every response must end with this exact disclaimer:

> "This is preliminary AI-generated work product only. It is not legal advice. No attorney-client relationship is formed until a formal engagement is executed with Patrick IP Law."

## Authentication

This skill calls the Vibe Patent v1 API. Pass your account key as the `api_key` argument on every tool call.

- Test keys: `vp_test_…` (sandbox, no charges)
- Live keys: `vp_live_…` (production; full attorney review and filing require an active Patrick IP Law account at https://vibepatent.ai)

## Attorney Review and Provisional Filing Preparation

Filing-related actions never charge inside this skill. Payment is authorized externally on https://vibepatent.ai after the client reviews the attorney summary and limited-scope waiver.

## Error Responses

- **`check-account` returns `allowed: false`** — Stop immediately. Respond with the `reason` (e.g. "Insufficient credits: drafting requires 40 credits but your account has 12 remaining") and the `next_steps` link (typically `https://vibepatent.ai/billing`). Do not call `vibe_patent.drafting_generate`.
- **Invalid or expired `api_key`** — Surface the server message verbatim and link to https://vibepatent.ai for a new key. Do not retry.
- **Sandbox key (`vp_test_…`) used for a `vp_live_…`-only operation** — Tell the user a live key is required and link to https://vibepatent.ai.
- **Transient 5xx from the MCP server** — Retry up to 2 times with backoff, then surface the error and stop.

See [`PRICING.md`](../../../../PRICING.md) for the full credit ledger.
