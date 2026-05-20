# Contributing to Vibe Patent Marketplace

Thanks for your interest in contributing! This marketplace ships Claude plugins that interact with a regulated legal-services backend, so contributions must clear a few extra bars.

## Ground rules

1. **Narrow skill descriptions (§2D).** Every `SKILL.md` `description` must start with "Use ONLY when…" (or equivalent) and name the exact trigger conditions. Broad descriptions will be rejected.
2. **No in-plugin payments (§4A).** Skills must never collect card details, render checkout, or call Stripe directly. All charges are authorized externally on https://vibepatent.ai.
3. **Mandatory disclaimer.** `analyze-patentability` and `draft-specification` outputs must end with the exact disclaimer in their `SKILL.md`. Do not paraphrase.
4. **Permissive drafting language.** Use "disclosed subject matter", "can", "may". Never "novel", "distinctive", or "the invention".
5. **`disable-model-invocation: true`** is required on every `SKILL.md`.
6. **No secrets.** Never commit `vp_live_…`, `sk_live_…`, `service_role`, `.env`, or `*.key` files. CI will fail the PR.

## Local validation

```bash
# JSON
find marketplaces/vibe-patent -name '*.json' -exec python3 -c "import json,sys; json.load(open(sys.argv[1]))" {} \;

# Secret sweep
grep -RIEn 'vp_live_|sk_live_|service_role' marketplaces/vibe-patent && echo "FAIL" || echo "OK"
```

The `validate.yml` GitHub Action runs the same checks on every PR.

## PR checklist

Use the PR template. At minimum: compliance boxes checked, validation output pasted, linked issue.

## Releasing

Bump `CHANGELOG.md` under a new version heading. Marketplace version is tracked in `.claude-plugin/marketplace.json`.
