#!/bin/bash
# Startup hook to show Ollama usage stats for current conversation

CONVO_FILE="$HOME/.cache/ollama-conversation-id"
USAGE_LOG="$HOME/.cache/ollama-usage.jsonl"

# Read conversation ID
if [[ -f "$CONVO_FILE" ]]; then
    export OLLAMA_CONVERSATION_ID=$(cat "$CONVO_FILE")
fi

# If no usage log, stay quiet
if [[ ! -f "$USAGE_LOG" ]] || [[ ! -s "$USAGE_LOG" ]]; then
    exit 0
fi

# Get stats (will filter by conversation if ID is set)
stats=$("$HOME/bin/llm-usage" --json 2>/dev/null || echo '{"calls":0,"tokens":0}')
calls=$(echo "$stats" | jq -r '.calls // 0')
tokens=$(echo "$stats" | jq -r '.tokens // 0')

# Only show if there's been activity
if [[ "$calls" -gt 0 ]]; then
    fmt_tokens=$(printf "%'d" "$tokens")
    convo_label=""
    if [[ -n "${OLLAMA_CONVERSATION_ID:-}" ]]; then
        convo_label=" (convo ${OLLAMA_CONVERSATION_ID})"
    fi
    jq -n --arg msg "📊 Ollama: $fmt_tokens tokens ($calls calls)$convo_label" \
        '{"systemMessage": $msg}'
fi

# Check Claude budget and provide guidance
STATS_FILE="$HOME/.claude/stats-cache.json"
if [[ -f "$STATS_FILE" ]]; then
    today=$(date +%Y-%m-%d)
    messages=$(jq -r --arg date "$today" '.dailyActivity[] | select(.date == $date) | .messageCount // 0' "$STATS_FILE" 2>/dev/null || echo "0")
    daily_limit=500
    pct=$((messages * 100 / daily_limit))

    if [[ $pct -ge 75 ]]; then
        jq -n '{"systemMessage": "⚠️ Claude budget >75% - AGGRESSIVELY use llm-* tools for all routine tasks"}'
    elif [[ $pct -ge 25 ]]; then
        jq -n '{"systemMessage": "📊 Claude budget 25-75% - Prefer llm-* tools for summaries, boilerplate, tests"}'
    fi
fi
