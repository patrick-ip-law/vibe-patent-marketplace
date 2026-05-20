# Changelog

All notable changes to the Vibe Patent marketplace are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] — 2026-05-19

### Added
- Initial public release of the Vibe Patent marketplace with six plugins:
  `vibe-patent-core`, `vibe-patent-intake`, `vibe-patent-patentability`,
  `vibe-patent-drafting`, `vibe-patent-filing`, `vibe-patent-code-bridge`.
- MCP integration in `vibe-patent-core` (hosted Streamable HTTP + local stdio bridge via `.mcp.json`).
- Usage-based gating via the `check-account` skill and the `vibe_patent.account_check_balance` MCP tool.
- Anthropic Software Directory compliance pass:
  - Narrow `description` + `disable-model-invocation: true` on every skill.
  - "Attorney Review and Provisional Filing Preparation" framing; no payments inside any plugin.
  - Mandatory end-of-response legal disclaimer on `analyze-patentability` and `draft-specification` skills.
- `LICENSE` (Apache-2.0), `SECURITY.md`, `SETUP.md`, and `DEPLOYMENT.md`.

### Security
- `api_key` is required for every API call; `vp_live_…` enforced on filing operations.
- All MCP traffic is logged server-side; no plugin stores user credentials locally.