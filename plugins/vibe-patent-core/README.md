# Vibe Patent — Core

Part of the [Vibe Patent marketplace](../../README.md) by [Patrick IP Law](https://vibepatent.ai).

## What this plugin does

End-to-end Vibe Patent workflow in a single plugin: intake → patentability → drafting → attorney-reviewed provisional filing. Install this if you want the full toolkit; otherwise install the focused plugins you need.

## Skills

- `intake-invention` — capture a structured disclosure.
- `analyze-patentability` — §101 / prior art / differences / §103.
- `draft-specification` — Background + 5-part Detailed Description.
- `file-provisional` — Patrick IP Law attorney review + USPTO filing.

## Install

```
/plugin install vibe-patent-core@vibe-patent
```

See [`SETUP.md`](./SETUP.md) for the full quick-start, MCP server options, and privacy notes.

## Available Tools

The MCP server exposes 9 tools (intake, §101/§103/differences, prior-art search, drafting, and the 3-step filing flow), plus `vibe_patent.account_check_balance`. Authoritative schemas and parameter docs live in the tool registry:

- Repo path: [`docs/mcp/tool-registry.json`](../../../../docs/mcp/tool-registry.json)
- Raw GitHub: `https://raw.githubusercontent.com/patrick-ip-law/vibe-patent-marketplace/main/docs/mcp/tool-registry.json`

See [`PRICING.md`](../../PRICING.md) for credit costs per tool.

## Example workflows

1. **Capture a disclosure**
   > "Use `vibe-patent-core` with api_key `vp_test_…` to start a new invention disclosure for a wearable hydration sensor."
2. **Run patentability**
   > "On disclosure_id `disc_abc123`, run the full patentability pipeline (§101, prior-art, differences, §103). Show the credit estimate first."
3. **Draft and route for attorney review**
   > "Generate the Background and 5-part Detailed Description for `disc_abc123`, then route it to Patrick IP Law for limited-scope attorney review and USPTO provisional filing preparation. Pause before payment authorization."

## Authentication

This plugin calls the Vibe Patent v1 API. Every tool accepts an `api_key` argument:

- `vp_test_…` — sandbox keys, no charges, full functional surface.
- `vp_live_…` — production keys; required for attorney review and USPTO filing. Issued from your Patrick IP Law account at https://vibepatent.ai.

The basic tier is free. Attorney review and provisional filing require an active Patrick IP Law account.

## Attorney Review and Provisional Filing Preparation

No charges are made inside this plugin. When you choose to file, payment is authorized externally on https://vibepatent.ai **after** you review the attorney summary and limited-scope waiver.

## Usage-based credits

Compute-heavy skills (`analyze-patentability`, `draft-specification`) call the `check-account` skill first via the `vibe_patent.account_check_balance` MCP tool. It returns the account `tier`, `remaining_credits`, a fixed `estimated_credits` cost for the planned operation, an `estimated_usd` figure, and an `allowed` decision. If the account cannot cover the estimate, the heavy skill stops and surfaces a top-up link.

Indicative fixed costs (subject to change — authoritative values come from the live MCP response):

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

### Tiers

- **Free** — 25 included credits/month, `vp_test_…` keys only for sandbox; `vp_live_…` keys throttled.
- **Pro** — 500 included credits/month, monthly subscription.
- **Firm** — unmetered analysis/drafting, monthly subscription.

All top-ups, plan upgrades, and attorney filing fees are authorized **externally** at https://vibepatent.ai. No payment ever occurs inside the plugin.

## Legal

Filing services are provided by Patrick IP Law, a USPTO-registered patent attorney practice. Engagement is limited-scope: attorney review of the submitted draft and USPTO filing only — no ongoing prosecution, patentability opinions, FTO analysis, or portfolio strategy. See https://vibepatent.ai/terms and https://vibepatent.ai/privacy.

## MCP server

This plugin ships an MCP server configuration (`.mcp.json`) that exposes the Vibe Patent v1 API surface (9 tools — intake, §101/§103/differences, prior-art search, drafting, and the Attorney Review and Provisional Filing Preparation filing trio) to Claude over the Model Context Protocol.

### Option A — Hosted Streamable HTTP (recommended)

The production MCP server is hosted by Patrick IP Law as a Supabase Edge Function and is the easiest way to use the plugin:

```
https://ujiaxmhlzrhcriremuyi.supabase.co/functions/v1/api-v1-mcp-server
```

Authenticate with the `X-API-Key` header using a `vp_test_…` or `vp_live_…` key from https://vibepatent.ai. All calls are tagged `distribution_channel="marketplace_partner"` server-side.

### Option B — Local stdio server

The bundled `.mcp.json` runs a local Node stdio bridge against the same hosted API. After installing the plugin:

```bash
cd ~/.claude/plugins/vibe-patent-core
npm install
npm run build   # emits dist/mcp-server.js
```

Then export the Supabase URL and your anon/publishable key (or a Vibe Patent API key, depending on the bridge build you ship) before launching Claude:

```bash
export SUPABASE_URL="https://ujiaxmhlzrhcriremuyi.supabase.co"
export SUPABASE_ANON_KEY="…"
```

Claude will auto-discover the server from `.mcp.json` on next launch. Verify with `/mcp list`.
