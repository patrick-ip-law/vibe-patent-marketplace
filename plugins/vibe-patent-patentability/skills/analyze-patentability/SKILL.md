---
name: analyze-patentability
description: Use ONLY when the user references an existing Vibe Patent `disclosure_id` and explicitly asks for §101 eligibility, prior-art search, differences analysis, or §103 obviousness assessment. Applicable to both U.S. provisional patent applications (to establish patent pending status) and non-provisional, utility patent application preparation. Requires an `api_key` (vp_test_… or vp_live_…). All outputs are preliminary AI-generated drafts labeled "DRAFT – FOR ATTORNEY REVIEW ONLY" and are intended for review by a registered patent practitioner — they are not legal advice. Full attorney review and USPTO filing require a live Patrick IP Law account and are authorized externally on https://vibepatent.ai. No payment is processed inside this plugin.
disable-model-invocation: true
---

# Analyze patentability

**Pre-flight (required):** First, call `vibe-patent-core:check-account` with the user's `api_key` and `operation: "analyze_patentability_full"` to confirm tier, remaining credits, and the estimated cost. Surface the estimate to the user and only proceed if `allowed=true`. If `allowed=false`, stop and return the tool's `reason` + `next_steps`.

Use this skill only when the user references an existing Vibe Patent `disclosure_id` and asks for §101, prior-art, differences, or §103 analysis.

Pipeline:
1. `vibe_patent.eligibility_analyze101` — Alice/Mayo §101 framework.
2. `vibe_patent.prior_art_search` — patents + non-patent literature, scored.
3. `vibe_patent.eligibility_analyzediff` — Red/Yellow/Green feature matrix vs. selected references.
4. `vibe_patent.eligibility_analyze103` — KSR rationales and secondary considerations.

Report findings without paraphrasing the underlying legal disclaimers.

## Mandatory output header (inject verbatim at the very top of every response)

Every response from this skill MUST begin with the exact block below, rendered in Markdown, before any analysis, summary, or other content. Do not paraphrase, shorten, translate, or move it. This header is required in both Claude Code and Claude Cowork surfaces.

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

- **`check-account` returns `allowed: false`** — Stop immediately. Respond with the `reason` (e.g. "Insufficient credits: this operation requires 20 credits but your account has 4 remaining") and the `next_steps` link (typically `https://vibepatent.ai/billing`). Do not invoke any downstream `vibe_patent.*` tool.
- **Invalid or expired `api_key`** — Surface the server message verbatim and link to https://vibepatent.ai for a new key. Do not retry.
- **Sandbox key (`vp_test_…`) used for a `vp_live_…`-only operation** — Tell the user a live key is required and link to https://vibepatent.ai.
- **Transient 5xx from the MCP server** — Retry up to 2 times with backoff, then surface the error and stop.

See [`PRICING.md`](../../../../PRICING.md) for the full credit ledger.
