# Security Policy

## Supported Versions

The Vibe Patent marketplace is actively maintained. Only the latest published version (currently `v1.0.0`) receives security updates.

| Version | Supported |
| ------- | --------- |
| 1.0.x   | ✅        |
| < 1.0   | ❌        |

## Reporting a Vulnerability

If you discover a security vulnerability in any Vibe Patent plugin, MCP tool, or marketplace asset, please report it privately. **Do not open a public GitHub issue.**

- **Email:** security@patrickiplaw.com
- **Subject line:** `[Vibe Patent Security] <short summary>`
- Include: affected plugin/version, reproduction steps, impact assessment, and any proof-of-concept.

We will acknowledge receipt within **2 business days** and aim to provide a remediation timeline within **10 business days**. Coordinated disclosure is appreciated; credit will be offered in the CHANGELOG unless you request anonymity.

## Scope

In scope:
- Plugins under `marketplaces/vibe-patent/plugins/*`
- The hosted Vibe Patent MCP server (`https://api.vibepatent.ai/mcp`)
- The local stdio bridge defined in `vibe-patent-core/.mcp.json`

Out of scope:
- Third-party LLM providers (Anthropic, OpenAI, Google, xAI) — report to the respective vendor.
- Issues requiring a compromised user device or stolen `vp_live_…` key.

## Handling of Sensitive Disclosure Content

Invention disclosures are confidential. If a vulnerability could expose disclosure content or `api_key` material, mark the report **CRITICAL** in the subject line for expedited triage.