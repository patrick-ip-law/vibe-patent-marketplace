# Anthropic Software Directory — Submission Packet

Marketplace: **Vibe Patent** (`patrick-ip-law/vibe-patent-marketplace`)
Version: **1.0.0**
Operator: **Patrick IP Law** — USPTO-registered patent attorney practice
Submission contact: support@vibepatent.ai · Security: security@patrickiplaw.com

---

## 1. Anthropic submission checklist

### Identity & ownership
- [x] Owner block in `marketplace.json` (name, URL, email)
- [x] Homepage, privacy, and terms URLs in `metadata`
- [x] `LICENSE` file present at marketplace root (Apache-2.0)
- [x] `SECURITY.md` with private disclosure address
- [x] `CHANGELOG.md` with `1.0.0` entry
- [x] `SETUP.md` in `vibe-patent-core`
- [x] `DEPLOYMENT.md` at marketplace root

### Discoverability
- [x] `category: "legal"` on marketplace + every plugin
- [x] `tags` include `patent`, `ip-law`, `invention-disclosure`, `uspto`, `provisional`, `attorney-review`
- [x] Distinct, non-generic plugin names (`vibe-patent-*`)

### Skill quality (§2D — narrow scope)
- [x] Every `SKILL.md` has a **narrow** `description` starting with "Use ONLY when…" or equivalent
- [x] Every `SKILL.md` sets `disable-model-invocation: true`
- [x] `check-account` is gated to compute-heavy operations only and is **never** auto-invoked standalone
- [x] Heavy skills require a pre-flight `vibe-patent-core:check-account` call

### Monetization & payments (§4A — no in-plugin payments)
- [x] No plugin processes payments; `file-provisional` description states this explicitly
- [x] All charges authorized externally at https://vibepatent.ai
- [x] Service framed as **"Attorney Review and Provisional Filing Preparation"** (no "Pay-After-Review" residue)
- [x] `vp_test_…` (sandbox) vs `vp_live_…` (production) key model documented

### Observability & reviewer verification
- [x] All MCP calls log `distribution_channel = "marketplace_partner"` on the backend
      (`account_check_balance` surfaces it inline in its response; downstream
      tools record it in `api_usage_logs`)
- [x] Runnable smoke test: `marketplaces/vibe-patent/scripts/smoke-test.sh`
      checks handshake, tool count (10), compliant filing language, invalid-key
      error clarity, and `distribution_channel` propagation
- [x] `account_check_balance` description includes copy-pasteable example
      payloads for `allowed:true`, `allowed:false`, and invalid-key cases
- [x] Invalid / expired / revoked keys return actionable `reason` + `next_steps`
      (format guidance, renewal link, support contact)

### Legal & compliance
- [x] Limited-scope engagement disclosed in filing skill + README
- [x] Mandatory end-of-response disclaimer on `analyze-patentability` and `draft-specification`:
      > "This is preliminary AI-generated work product only. It is not legal advice. No attorney-client relationship is formed until a formal engagement is executed with Patrick IP Law."
- [x] NYRPC 7.1-compliant attorney advertising language at vibepatent.ai
- [x] Privacy policy + terms linked from every README

### Technical
- [x] All `marketplace.json` / `plugin.json` / `.mcp.json` files validate as JSON
- [x] All `SKILL.md` files have well-formed YAML frontmatter
- [x] MCP integration documented (hosted Streamable HTTP + local stdio fallback)
- [x] `vibe_patent.account_check_balance` MCP tool enforces credit/tier gating server-side
- [x] Credit ledger and filing fee documented in [`PRICING.md`](./PRICING.md)
- [x] Heavy skills document `## Error Responses` for `allowed: false`, invalid keys, and transient 5xx

### Pricing & credit ledger

See [`PRICING.md`](./PRICING.md) for the full tier table, per-operation credit costs (server-enforced via `vibe_patent.account_check_balance`), the $250 flat filing fee, and the top-up flow. Reviewers can verify that every heavy skill calls `check-account` first and surfaces the returned `estimated_credits` / `estimated_usd` to the user before consuming credits. No payment ever occurs inside any plugin.

---

## 2. Reviewer notes template

> **Reviewer:** _______________
> **Date:** _______________
>
> **Installed plugins tested:**
> - [ ] vibe-patent-core
> - [ ] vibe-patent-intake
> - [ ] vibe-patent-patentability
> - [ ] vibe-patent-drafting
> - [ ] vibe-patent-filing
> - [ ] vibe-patent-code-bridge
>
> **Test key used:** `vp_test_…`
>
> **Findings:**
> 1. Skill discoverability: ⬜ pass ⬜ fail — notes:
> 2. Pre-flight `check-account` invoked before heavy ops: ⬜ pass ⬜ fail — notes:
> 3. No payment UI/flow inside any plugin: ⬜ pass ⬜ fail — notes:
> 4. Mandatory legal disclaimer present in analyze/draft outputs: ⬜ pass ⬜ fail — notes:
> 5. MCP tool errors surface to user (not silently swallowed): ⬜ pass ⬜ fail — notes:
>
> **Overall decision:** ⬜ approve ⬜ approve with changes ⬜ reject

---

## 3. Testing account

Anthropic reviewers should request a dedicated **sandbox `vp_test_…` key** by emailing **support@vibepatent.ai** with subject `[Anthropic Review] Sandbox key request`. The key is provisioned within one business day with:

- Unlimited free-tier credits during the review window
- Access to a pre-seeded `disclosure_id` (`disc_review_demo_001`) covering all four pipeline stages
- Read access to the hosted MCP server at `https://api.vibepatent.ai/mcp`

No `vp_live_…` key is required to evaluate the marketplace — filing skills can be exercised end-to-end up to (but not including) the externally-hosted payment authorization step.

---

## 4. Example workflows for reviewers

1. **Capture a new invention disclosure**
   > "Use `vibe-patent-core` to start a new invention disclosure. My `api_key` is `vp_test_…`. The idea is a wearable that detects early-stage dehydration from skin impedance."

2. **Run patentability analysis on an existing disclosure**
   > "Using `vibe-patent-core` with `api_key` `vp_test_…` and `disclosure_id` `disc_review_demo_001`, run the full patentability analysis (§101, prior-art search, differences, §103). Show the credit estimate first."

3. **Draft the specification and route for attorney review**
   > "Generate the Background and 5-part Detailed Description for `disclosure_id` `disc_review_demo_001` using `api_key` `vp_test_…`, then route it to Patrick IP Law for limited-scope attorney review and USPTO provisional filing preparation. Stop before authorizing payment so I can review the attorney summary on vibepatent.ai."

Each prompt should: (a) trigger the correct narrow skill, (b) call `check-account` before heavy compute, (c) end with the mandatory legal disclaimer where applicable, and (d) never attempt an in-plugin charge.