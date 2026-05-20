---
name: code-to-disclosure
description: Use ONLY when the user is working inside a code repository in Claude Code AND explicitly asks to draft an invention disclosure from the source. Summarizes the repo into a draft disclosure (problem, operation, variations, applications) for handoff to the `intake-invention` skill. Does not call the Vibe Patent API directly; downstream attorney review and USPTO filing require a live Patrick IP Law `api_key` (vp_live_…) and are authorized externally on https://vibepatent.ai. No payment is processed inside this plugin.
disable-model-invocation: true
---

# Code-to-disclosure bridge

Use this skill only when the user is working in a code repository and explicitly asks to draft an invention disclosure from the code.

Steps:
1. Read the repository `README`, top-level `package.json`/manifest, and the primary source modules.
2. Produce a draft disclosure with: title, problem solved, how the system operates (step-by-step), material variations, and target applications.
3. Use permissive drafting style: "can", "may", "disclosed subject matter". Never claim novelty.
4. Hand the draft to the `intake-invention` skill (or directly to `vibe_patent.disclosure_intake`) for finalization into a Vibe Patent disclosure record.

This skill does not call the Vibe Patent API by itself. Filing or attorney review still requires the `vibe-patent-filing` plugin and a Patrick IP Law account.

## Authentication

This skill calls the Vibe Patent v1 API. Pass your account key as the `api_key` argument on every tool call.

- Test keys: `vp_test_…` (sandbox, no charges)
- Live keys: `vp_live_…` (production; full attorney review and filing require an active Patrick IP Law account at https://vibepatent.ai)

## Attorney Review and Provisional Filing Preparation

Filing-related actions never charge inside this skill. Payment is authorized externally on https://vibepatent.ai after the client reviews the attorney summary and limited-scope waiver.
