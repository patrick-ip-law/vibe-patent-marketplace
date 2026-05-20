#!/usr/bin/env bash
# Vibe Patent Marketplace — end-to-end smoke test
#
# Verifies the live MCP server matches what the marketplace documentation
# promises reviewers. Safe to run repeatedly; performs no writes.
#
# Usage:
#   VP_TEST_API_KEY=vp_test_xxxxxxxxxxxxxxxx ./scripts/smoke-test.sh
#   (key optional — invalid-key paths still run without it)
#
# Exit codes: 0 = all checks passed, 1 = one or more checks failed.

set -uo pipefail

MCP_URL="${MCP_URL:-https://ujiaxmhlzrhcriremuyi.supabase.co/functions/v1/api-v1-mcp-server}"
KEY="${VP_TEST_API_KEY:-}"
FAIL=0

say()  { printf "\n\033[1m▸ %s\033[0m\n" "$*"; }
pass() { printf "  \033[32m✓\033[0m %s\n" "$*"; }
fail() { printf "  \033[31m✗\033[0m %s\n" "$*"; FAIL=$((FAIL+1)); }

rpc() {
  # rpc <method> <params-json>
  # mcp-lite returns either SSE (data: …) or plain JSON depending on method;
  # strip the SSE prefix if present, otherwise pass through.
  local raw
  raw=$(curl -sS -X POST "$MCP_URL" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json, text/event-stream" \
    -d "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"$1\",\"params\":$2}")
  if printf '%s' "$raw" | grep -q '^data: '; then
    printf '%s' "$raw" | sed -n 's/^data: //p' | head -n1
  else
    printf '%s' "$raw"
  fi
}

say "1. initialize handshake"
INIT=$(rpc initialize '{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"smoke","version":"1"}}')
echo "$INIT" | grep -q '"protocolVersion"' && pass "handshake OK" || fail "handshake failed: $INIT"

say "2. tools/list — expect 10 tools incl. account_check_balance"
LIST=$(rpc 'tools/list' '{}')
COUNT=$(echo "$LIST" | python3 -c 'import json,sys;d=json.load(sys.stdin);print(len(d["result"]["tools"]))')
[ "$COUNT" = "10" ] && pass "tool count = 10" || fail "tool count = $COUNT (expected 10)"
echo "$LIST" | grep -q 'vibe_patent.account_check_balance' && pass "account_check_balance present" || fail "account_check_balance missing"

say "3. filing tools use compliant description (no 'Pay-After-Review')"
if echo "$LIST" | grep -q 'Pay-After-Review'; then
  fail "legacy 'Pay-After-Review' language still present"
else
  pass "no legacy language"
fi
echo "$LIST" | grep -q 'limited-scope attorney review and USPTO provisional filing preparation' \
  && pass "compliant filing description present" \
  || fail "compliant filing description missing"

say "4. account_check_balance — invalid key returns actionable error"
BAD=$(rpc 'tools/call' '{"name":"vibe_patent.account_check_balance","arguments":{"api_key":"bogus","operation":"draft_specification"}}')
echo "$BAD" | grep -q 'Invalid API key format' && pass "clear invalid-key message" || fail "missing clear error: $BAD"

say "5. account_check_balance — valid key returns allow/deny payload"
if [ -n "$KEY" ]; then
  OK=$(rpc 'tools/call' "{\"name\":\"vibe_patent.account_check_balance\",\"arguments\":{\"api_key\":\"$KEY\",\"operation\":\"analyze_patentability_full\"}}")
  echo "$OK" | grep -q '"allowed"' && pass "allowed/denied decision returned" || fail "no decision: $OK"
  echo "$OK" | grep -q '"distribution_channel": "marketplace_partner"' \
    && pass "distribution_channel = marketplace_partner" \
    || fail "distribution_channel not surfaced"
else
  printf "  (skip — set VP_TEST_API_KEY to exercise valid-key path)\n"
fi

echo
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mAll smoke checks passed.\033[0m\n"
  exit 0
else
  printf "\033[31m%d check(s) failed.\033[0m\n" "$FAIL"
  exit 1
fi