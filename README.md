# Vibe Patent Marketplace

Official Claude marketplace for the [Vibe Patent](https://vibepatent.ai) workflow, operated by **Patrick IP Law** — a USPTO-registered patent attorney practice with 12+ years of experience.

> **AI-powered tools for U.S. provisional patent applications to establish patent pending status.** Disclosure intake and patentability analysis also support non-provisional, utility patent application preparation. **All outputs are drafts for registered patent practitioner review.**

Currently supports the full workflow for U.S. provisional patent applications to establish patent pending status, including disclosure intake, patentability analysis, specification drafting, attorney review, and filing request. The disclosure intake and patentability analysis tools are also applicable to non-provisional, utility patent applications. All outputs are preliminary AI-generated drafts ready for review, analysis, or filing by a registered patent practitioner.

### Mandatory attorney-review labeling

Every response from the `analyze-patentability` and `draft-specification` skills is automatically prefixed with a bold **"DRAFT – FOR ATTORNEY REVIEW ONLY"** header (with full disclaimer and © Vibe Patent 2026), in both Claude Code and Claude Cowork surfaces. Do not remove or paraphrase this header before relying on the output.

### Selectable specification output shape (`output_mode`)

The `draft-specification` skill accepts an optional `output_mode` parameter that controls how the final specification is returned:

| `output_mode` | Behavior |
| --- | --- |
| `sections` | Streams each section draft as it is generated (ideal for long documents and incremental UIs). |
| `compiled` | Returns a single fully-integrated specification at the end. |
| `both` *(default)* | Returns sections as they stream **and** the full compiled document on completion. |

## Install the marketplace

```
/plugin marketplace add patrick-ip-law/vibe-patent-marketplace
```

Then install one or more plugins:

```
/plugin install vibe-patent-core@vibe-patent
```

## Plugins

| Plugin | Purpose |
|---|---|
| `vibe-patent-core` | Full end-to-end toolkit (intake → patentability → drafting → filing). |
| `vibe-patent-intake` | Structured invention intake only. |
| `vibe-patent-patentability` | §101, prior-art, differences, and §103 analysis. |
| `vibe-patent-drafting` | Background + 5-part Detailed Description generator. |
| `vibe-patent-filing` | Patrick IP Law attorney review + USPTO provisional filing. |
| `vibe-patent-code-bridge` | Summarize a code repository into a draft disclosure. |

## Recommended bundles

| Use case | Install |
|---|---|
| **Claude Cowork** (inventors, founders) | `vibe-patent-core` |
| **Claude Code** (engineers patenting software) | `vibe-patent-code-bridge` + `vibe-patent-intake` + `vibe-patent-drafting` + `vibe-patent-filing` |
| **Claude for Legal** (in-house counsel, attorneys) | `vibe-patent-patentability` + `vibe-patent-drafting` + `vibe-patent-filing` |

## Authentication

Every tool accepts an `api_key` argument:

- `vp_test_…` — free sandbox keys with the full functional surface.
- `vp_live_…` — production keys; required for attorney review and USPTO filing. Issued from your Patrick IP Law account at https://vibepatent.ai.

## Pricing — Attorney Review and Provisional Filing Preparation

The basic tier (intake, patentability, drafting, prior-art) is free with a sandbox or starter key. Attorney review and USPTO provisional filing are billed under the **Attorney Review and Provisional Filing Preparation** model: you review the attorney summary and limited-scope waiver **before** any charge is authorized, and payment is captured externally at https://vibepatent.ai.

## Legal & compliance

Filing services are provided by Patrick IP Law under a **limited-scope** engagement: attorney review of the submitted draft and USPTO filing only. No ongoing prosecution, patentability opinion, FTO, or portfolio strategy work is included.

- [Terms of service](https://vibepatent.ai/terms)
- [Privacy policy](https://vibepatent.ai/privacy)

## Support

- Website: https://vibepatent.ai
- Email: support@vibepatent.ai

## Example workflows

Three prompts you can paste into Claude after installing `vibe-patent-core`:

1. **Capture a new invention disclosure**
   > "Use vibe-patent-core to start a new invention disclosure. My api_key is `vp_test_…`. The idea is a wearable that detects early-stage dehydration from skin impedance."

2. **Run patentability analysis on an existing disclosure**
   > "Using vibe-patent-core with api_key `vp_test_…` and disclosure_id `disc_abc123`, run the full patentability analysis (§101, prior-art search, differences, §103). Show the cost estimate first."

3. **Draft the specification and request attorney review**
   > "Generate the Background and 5-part Detailed Description for disclosure_id `disc_abc123` using api_key `vp_live_…`, then route it to Patrick IP Law for limited-scope attorney review and USPTO provisional filing preparation. Stop before authorizing payment so I can review the attorney summary on vibepatent.ai."

## Privacy & legal

- Outputs from all plugins are preliminary AI-generated work product and are **not** legal advice.
- No attorney-client relationship is formed until a formal engagement is executed with Patrick IP Law.
- Full privacy policy: https://vibepatent.ai/privacy
- Terms of service: https://vibepatent.ai/terms
- Security disclosure: see [`SECURITY.md`](./SECURITY.md)
- License: [Apache 2.0](./LICENSE)
