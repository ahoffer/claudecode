#!/bin/bash
# CCNotifier hook shim: enrich hook payloads with terminal context and forward
# them to the running Claude Code Notifier app over its local Unix socket.

set -euo pipefail

SOCKET="/tmp/ccn-$(id -u).sock"

if [ ! -S "$SOCKET" ]; then
  exit 0
fi

INPUT=$(cat)

if [ -z "$INPUT" ]; then
  exit 0
fi

ENRICHED=$(echo "$INPUT" | /usr/bin/python3 -c '
import json
import os
import sys

try:
    data = json.loads(sys.stdin.read())
    data["terminal_app"] = os.environ.get("TERM_PROGRAM", "")
    data["iterm_session_id"] = os.environ.get("ITERM_SESSION_ID", "")
    data["iterm_profile"] = os.environ.get("ITERM_PROFILE", "")
    data["kitty_window_id"] = os.environ.get("KITTY_WINDOW_ID", "")
    data["kitty_pid"] = os.environ.get("KITTY_PID", "")
    data["tmux_session"] = os.environ.get("TMUX", "")
    data["tmux_pane"] = os.environ.get("TMUX_PANE", "")
    data["terminal_pid"] = str(os.getppid())
    print(json.dumps(data))
except Exception:
    pass
' 2>/dev/null)

if [ -n "$ENRICHED" ]; then
  echo "$ENRICHED" | /usr/bin/nc -U "$SOCKET"
else
  echo "$INPUT" | /usr/bin/nc -U "$SOCKET"
fi
