#!/bin/bash
# Hook that runs on user prompt submission to suggest offloading
# Analyzes the user's request and suggests appropriate llm-* tools

input=$(cat)
prompt=$(echo "$input" | jq -r '.prompt // empty' 2>/dev/null)

if [[ -z "$prompt" ]]; then
    exit 0
fi

prompt_lower=$(echo "$prompt" | tr '[:upper:]' '[:lower:]')
hints=()

# Pattern matching for offloadable requests
if echo "$prompt_lower" | grep -qE '(what does this error|explain.*error|why.*(fail|crash)|stack trace|exception)'; then
    hints+=("💡 Error explanation → Consider: echo \"<error>\" | llm-explain-error")
fi

if echo "$prompt_lower" | grep -qE '(summarize|summary|what happened|tldr|condense)'; then
    hints+=("💡 Summarization → Consider: <content> | llm-summarize")
fi

if echo "$prompt_lower" | grep -qE '(write.*(test|spec)|generate.*test|add.*test|unit test)'; then
    hints+=("💡 Test generation → Consider: llm-test <file> or <code> | llm-test")
fi

if echo "$prompt_lower" | grep -qE '(boilerplate|getter|setter|constructor|builder|crud|dto|pojo)'; then
    hints+=("💡 Boilerplate → Consider: llm-gen-code \"<description>\" --lang <lang>")
fi

if echo "$prompt_lower" | grep -qE '(add.*(docstring|documentation|jsdoc|javadoc)|document this)'; then
    hints+=("💡 Documentation → Consider: llm-docstring <file>")
fi

if echo "$prompt_lower" | grep -qE '(what is|how do|syntax for|difference between|when to use)' && [[ ${#prompt} -lt 100 ]]; then
    hints+=("💡 Simple Q&A → Consider: llm-ask \"<question>\"")
fi

if echo "$prompt_lower" | grep -qE '(commit message|git commit)'; then
    hints+=("💡 Commit message → Consider: llm-commit-msg")
fi

if echo "$prompt_lower" | grep -qE '(regex|regular expression|pattern for)'; then
    hints+=("💡 Regex generation → Consider: llm-regex \"<description>\"")
fi

if echo "$prompt_lower" | grep -qE '(where is|find.*(in|across).*code|what (files|modules)|which (class|file|module)|how does.*work)'; then
    hints+=("💡 Codebase exploration → Consider: llm-explore \"<question>\"")
fi

# Output hints if any (plain text stdout is added as context per Claude Code docs)
if [[ ${#hints[@]} -gt 0 ]]; then
    echo "OFFLOAD OPPORTUNITY:"
    for h in "${hints[@]}"; do
        echo "$h"
    done
    echo ""
    echo "Claude can use these tools directly, or you can run them yourself."
fi
