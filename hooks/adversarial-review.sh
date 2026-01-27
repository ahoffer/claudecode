#!/bin/bash
# PostToolUse hook: Adversarial code review via Ollama
#
# After Claude edits files, Ollama critiques the changes to catch issues.

input=$(cat)
tool_name=$(echo "$input" | jq -r '.tool_name // empty' 2>/dev/null)
tool_input=$(echo "$input" | jq -r '.tool_input // empty' 2>/dev/null)

# Only run for Edit/Write tools
[[ ! "$tool_name" =~ ^(Edit|Write)$ ]] && exit 0

# Extract file path
file_path=$(echo "$tool_input" | jq -r '.file_path // empty' 2>/dev/null)
[[ -z "$file_path" || ! -f "$file_path" ]] && exit 0

# Skip non-code files
case "$file_path" in
    *.md|*.txt|*.json|*.yaml|*.yml|*.xml|*.html|*.css) exit 0 ;;
esac

# Check if llm-review exists
[[ ! -x ~/bin/llm-review ]] && exit 0

# Get the changed content (last 100 lines for context)
content=$(tail -100 "$file_path" 2>/dev/null)
[[ -z "$content" ]] && exit 0

# Run adversarial review via Ollama (timeout 45s)
CRITIQUE=$(timeout 45s bash -c '
echo "Review this code for bugs, edge cases, security issues, or logic errors. Be critical. If nothing wrong, say LGTM.

File: $1

\`\`\`
$2
\`\`\`" | ~/bin/llm-ask 2>/dev/null
' -- "$file_path" "$content")

# Only show if there's meaningful critique (not just LGTM)
if [[ -n "$CRITIQUE" && ! "$CRITIQUE" =~ ^(LGTM|Looks good) ]]; then
    cat <<REVIEW

🔍 **Ollama Adversarial Review** ($(basename "$file_path")):
$CRITIQUE

REVIEW
fi
