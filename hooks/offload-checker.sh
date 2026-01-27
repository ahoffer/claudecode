#!/bin/bash
# Hook to check if Claude should have offloaded work to Ollama
# Analyzes the assistant's response for patterns that indicate missed offloading opportunities

# Read the assistant message from stdin (Claude Code passes context as JSON)
input=$(cat)

# Extract assistant message if present
message=$(echo "$input" | jq -r '.assistantMessage // empty' 2>/dev/null)

if [[ -z "$message" ]]; then
    exit 0
fi

warnings=()

# Check for patterns that suggest missed offloading

# 1. Long code blocks that look like boilerplate
if echo "$message" | grep -qE '```(java|typescript|python|javascript)' && \
   echo "$message" | grep -qE '(getter|setter|constructor|equals|hashCode|toString|Builder|CRUD|repository)'; then
    warnings+=("⚠ Boilerplate code detected - consider using: llm-gen-code")
fi

# 2. Error explanations
if echo "$message" | grep -qiE '(error means|exception occurs|stack trace|caused by|fix this by|to resolve)' && \
   ! echo "$message" | grep -q 'llm-explain-error'; then
    warnings+=("⚠ Error explanation detected - consider using: llm-explain-error")
fi

# 3. Summaries of logs/output
if echo "$message" | grep -qiE '(summary:|key points:|the output shows|the log shows|build (failed|succeeded))' && \
   ! echo "$message" | grep -q 'llm-summarize'; then
    warnings+=("⚠ Summary detected - consider using: llm-summarize")
fi

# 4. Simple factual Q&A
if echo "$message" | grep -qiE '^(the syntax|the command|to do this|you can use|the difference between)' && \
   [[ ${#message} -lt 500 ]]; then
    warnings+=("⚠ Simple Q&A detected - consider using: llm-ask")
fi

# 5. Test generation
if echo "$message" | grep -qiE '(describe\(|it\(|test\(|@Test|def test_|func Test)' && \
   echo "$message" | grep -qE '```'; then
    warnings+=("⚠ Test code detected - consider using: llm-test")
fi

# 6. Docstrings/documentation
if echo "$message" | grep -qiE '(/\*\*|"""|@param|@return|Args:|Returns:|:param)'; then
    warnings+=("⚠ Documentation detected - consider using: llm-docstring")
fi

# Output warnings as system reminder if any found
if [[ ${#warnings[@]} -gt 0 ]]; then
    reminder="OFFLOAD CHECK:\\n"
    for w in "${warnings[@]}"; do
        reminder+="$w\\n"
    done
    reminder+="Use ~/bin/llm-* tools to save tokens!"

    # Output as JSON for Claude Code
    jq -n --arg msg "$reminder" '{"systemMessage": $msg}'
fi
