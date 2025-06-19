#!/usr/bin/env bash
set -euo pipefail          # safer scripting defaults

# ── 1. Get the first word of the status line ────────────────────────────────
status="$(mullvad status | head -n 1 | awk '{print $1}')"  # → "Connected" or "Disconnected"

# ── 2. Toggle based on that word ────────────────────────────────────────────
case "$status" in
  Connected)
    echo "Currently connected → disconnecting…"
    mullvad disconnect
    ;;
  Disconnected)
    echo "Currently disconnected → connecting…"
    mullvad connect
    ;;
  *)
    echo "⚠️ Unrecognised status: $status" >&2
    exit 1
    ;;
esac
