#!/bin/bash
# Generate a conversation ID for Ollama usage tracking

CONVO_FILE="$HOME/.cache/ollama-conversation-id"

# Generate short ID: timestamp + random suffix
convo_id="$(date +%m%d-%H%M)-$(head -c 4 /dev/urandom | xxd -p)"

# Save it
echo "$convo_id" > "$CONVO_FILE"

# No output - silent hook
