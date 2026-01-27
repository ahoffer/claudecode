#!/bin/bash
# Print Ollama usage report before context compaction

CONVO_FILE="$HOME/.cache/ollama-conversation-id"
USAGE_LOG="$HOME/.cache/ollama-usage.jsonl"

# Get conversation ID
if [[ -f "$CONVO_FILE" ]]; then
    export OLLAMA_CONVERSATION_ID=$(cat "$CONVO_FILE")
fi

# Check if there's any usage to report
if [[ ! -f "$USAGE_LOG" ]] || [[ ! -s "$USAGE_LOG" ]]; then
    exit 0
fi

# Get stats for this conversation
stats=$("$HOME/bin/llm-usage" --json 2>/dev/null || echo '{"calls":0,"tokens":0}')
calls=$(echo "$stats" | jq -r '.calls // 0')
tokens=$(echo "$stats" | jq -r '.tokens // 0')

if [[ "$calls" -gt 0 ]]; then
    fmt_tokens=$(printf "%'d" "$tokens")
    # Output as notification before compaction
    jq -n --arg msg "📊 Ollama usage before compact: $fmt_tokens tokens ($calls calls)" \
        '{"systemMessage": $msg}'
fi
