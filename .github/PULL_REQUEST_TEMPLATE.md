## Summary

<!-- What does this PR change and why? -->

## Scope

- [ ] Marketplace metadata / docs only
- [ ] Skill content (`SKILL.md`)
- [ ] Plugin manifest (`plugin.json` / `.mcp.json`)
- [ ] CI / repo hygiene

## Compliance checklist

- [ ] No in-plugin payment processing introduced (§4A)
- [ ] Skill `description` fields remain narrow and start with "Use ONLY when…" or equivalent
- [ ] `disable-model-invocation: true` preserved on all `SKILL.md` files
- [ ] Mandatory legal disclaimer preserved on `analyze-patentability` and `draft-specification`
- [ ] No `vp_live_…`, `sk_live_…`, or `service_role` strings committed
- [ ] All JSON files validate; all `SKILL.md` frontmatter parses

## Validation

```
# How you validated locally
```

## Linked issue
Closes #
