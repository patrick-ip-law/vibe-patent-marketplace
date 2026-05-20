# Vibe Patent — Code Bridge

Part of the [Vibe Patent marketplace](../../README.md) by [Patrick IP Law](https://vibepatent.ai).

## What this plugin does

Summarizes the currently open repository into a draft invention disclosure that can be handed to the Vibe Patent intake skill. Designed for Claude Code users who want to patent software they are actively building.

## Skills

- `code-to-disclosure`

## Install

```
/plugin install vibe-patent-code-bridge@vibe-patent
```

## Authentication

This plugin calls the Vibe Patent v1 API. Every tool accepts an `api_key` argument:

- `vp_test_…` — sandbox keys, no charges, full functional surface.
- `vp_live_…` — production keys; required for attorney review and USPTO filing. Issued from your Patrick IP Law account at https://vibepatent.ai.

The basic tier is free. Attorney review and provisional filing require an active Patrick IP Law account.

## Attorney Review and Provisional Filing Preparation

No charges are made inside this plugin. When you choose to file, payment is authorized externally on https://vibepatent.ai **after** you review the attorney summary and limited-scope waiver.

## Legal

Filing services are provided by Patrick IP Law, a USPTO-registered patent attorney practice. Engagement is limited-scope: attorney review of the submitted draft and USPTO filing only — no ongoing prosecution, patentability opinions, FTO analysis, or portfolio strategy. See https://vibepatent.ai/terms and https://vibepatent.ai/privacy.
