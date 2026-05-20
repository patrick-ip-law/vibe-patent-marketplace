# Vibe Patent Marketplace — Deployment Guide

How to publish `marketplaces/vibe-patent/` to GitHub, install it via the Claude plugin marketplace command, and enable it for a whole team via `.claude/settings.json`.

## 1. Publish to GitHub

The marketplace lives in this monorepo under `marketplaces/vibe-patent/`. To publish it as its own public repo for Claude to consume:

```bash
cd marketplaces/vibe-patent

git init
git add .
git commit -m "chore: initial Vibe Patent marketplace v1.0.0"

gh repo create patrick-ip-law/vibe-patent-marketplace \
  --public \
  --description "Official Patrick IP Law patent workflow toolkit for Claude" \
  --source . \
  --remote origin \
  --push

git tag -a v1.0.0 -m "Vibe Patent marketplace 1.0.0"
git push origin v1.0.0
```

Requirements for the Anthropic directory:

- Public repo, `LICENSE` at root (MIT or Apache-2.0 recommended).
- `.claude-plugin/marketplace.json` at the repo root (already present).
- Clean `main` — no `vp_live_…` keys, Stripe live keys, service-role tokens, or `.env`.
- A tagged release matching `version` in `marketplace.json`.

## 2. End-user installation

```
/plugin marketplace add patrick-ip-law/vibe-patent-marketplace
/plugin install vibe-patent-core@vibe-patent
```

Other bundles:

```
# Claude Code engineers patenting software
/plugin install vibe-patent-code-bridge@vibe-patent
/plugin install vibe-patent-intake@vibe-patent
/plugin install vibe-patent-drafting@vibe-patent
/plugin install vibe-patent-filing@vibe-patent

# In-house counsel / attorneys
/plugin install vibe-patent-patentability@vibe-patent
/plugin install vibe-patent-drafting@vibe-patent
/plugin install vibe-patent-filing@vibe-patent
```

Users authenticate by passing `api_key` on every tool call:

- `vp_test_…` — free sandbox.
- `vp_live_…` — production; required for attorney review and USPTO filing. Issued at https://vibepatent.ai.

## 3. Enable for a team via `.claude/settings.json`

Commit a `.claude/settings.json` to the team's repo (or distribute via MDM):

```json
{
  "marketplaces": {
    "vibe-patent": {
      "source": "github:patrick-ip-law/vibe-patent-marketplace",
      "ref": "v1.0.0"
    }
  },
  "plugins": {
    "vibe-patent-core": { "marketplace": "vibe-patent", "enabled": true }
  }
}
```

Notes:

- Pin `ref` to a tagged release for reproducibility; omit to track `main`.
- Never commit `api_key` values. Each user supplies their own at tool-call time or via `${env:VP_API_KEY}`.
- To use the hosted Streamable HTTP MCP server (recommended over the local stdio bridge):

  ```json
  {
    "mcpServers": {
      "vibe-patent": {
        "transport": "http",
        "url": "https://ujiaxmhlzrhcriremuyi.supabase.co/functions/v1/api-v1-mcp-server",
        "headers": {
          "X-API-Key": "${env:VP_API_KEY}",
          "X-Distribution-Channel": "marketplace_partner"
        }
      }
    }
  }
  ```

## 4. Submit to the Anthropic marketplace directory

After the GitHub repo and `v1.0.0` tag are live:

1. Run `claude plugin validate .` locally (or at minimum confirm every `.claude-plugin/*.json` and `marketplace.json` is valid JSON — already verified in CI).
2. Smoke-test from a clean Claude profile: `/plugin marketplace add patrick-ip-law/vibe-patent-marketplace` → `/plugin install vibe-patent-core@vibe-patent` → one tool call with a `vp_test_…` key.
3. Submit via Anthropic's plugin directory intake form, linking to `https://github.com/patrick-ip-law/vibe-patent-marketplace` and the `v1.0.0` tag.
4. Reference https://vibepatent.ai/terms and https://vibepatent.ai/privacy in the submission.

## Release checklist

- [ ] `version` bumped in `.claude-plugin/marketplace.json` and every `plugins/*/.claude-plugin/plugin.json`
- [ ] All SKILL.md frontmatter descriptions include narrow trigger + `api_key` + Attorney Review and Provisional Filing Preparation note
- [ ] No live secrets anywhere in the tree
- [ ] `git tag vX.Y.Z` pushed to `origin`
- [ ] Clean-profile smoke test passes

## Usage-based gating flow

Compute-heavy skills are gated by the new `check-account` skill, which calls the `vibe_patent.account_check_balance` MCP tool before any expensive operation runs.

Flow:

1. User asks for patentability analysis or full drafting.
2. The heavy skill's pre-flight step calls `vibe-patent-core:check-account` with the user's `api_key` and the operation name (e.g. `analyze_patentability_full`, `draft_specification`).
3. The backend validates the key, returns `tier`, `remaining_credits`, `estimated_credits`, `estimated_usd`, and an `allowed` boolean.
4. If `allowed=false`, the skill stops and surfaces the `reason` + `next_steps` (typically a top-up link at https://vibepatent.ai/billing). No downstream Claude call is made.
5. If `allowed=true`, the skill proceeds; actual usage is logged server-side into `api_usage_logs` with `distribution_channel="marketplace_partner"`.

Anthropic-compliance notes:

- No payment UI, charge, or checkout occurs inside any plugin.
- All top-ups and upgrades happen externally at https://vibepatent.ai.
- Cost estimates are shown to the user transparently before any heavy operation runs.