#!/bin/bash
# PostToolUse hook: Auto-summarize large Bash/Grep output via Ollama
#
# When Claude runs commands that produce large output, this hook
# auto-summarizes it to reduce context bloat.

input=$(cat)
tool_response=$(echo "$input" | jq -r '.tool_response // empty' 2>/dev/null)

# Exit silently if no tool response
[[ -z "$tool_response" ]] && exit 0

LINE_COUNT=$(echo "$tool_response" | wc -l)
BYTE_SIZE=$(echo "$tool_response" | wc -c)

# Thresholds - only summarize genuinely large output
LINE_THRESHOLD=150
BYTE_THRESHOLD=15360  # 15KB

if [[ "$LINE_COUNT" -lt "$LINE_THRESHOLD" && "$BYTE_SIZE" -lt "$BYTE_THRESHOLD" ]]; then
    exit 0
fi

# Check if llm-summarize exists and is executable
if [[ ! -x ~/bin/llm-summarize ]]; then
    exit 0
fi

# Summarize via Ollama (timeout after 30s to avoid blocking)
SUMMARY=$(timeout 30s bash -c 'echo "$1" | ~/bin/llm-summarize 2>/dev/null' -- "$tool_response" || echo "")

if [[ -n "$SUMMARY" && "$SUMMARY" != "Error"* ]]; then
    cat <<EOF

---
Auto-summary (${LINE_COUNT} lines condensed):
$SUMMARY
---
EOF
fi
