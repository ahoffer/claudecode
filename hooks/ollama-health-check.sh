#!/bin/bash
# Check if Ollama is reachable at session start

OLLAMA_HOST="${OLLAMA_HOST:-http://bigfish:11434}"

if ! curl -s --connect-timeout 2 "$OLLAMA_HOST/api/tags" >/dev/null 2>&1; then
    jq -n '{"systemMessage": "⚠️ Ollama unreachable at '"$OLLAMA_HOST"' - llm-* tools will fail"}'
fi
