#!/bin/bash
# Auto-activate Serena for /builds/ and /projects/ directories

cwd="$PWD"

if [[ "$cwd" == /builds/* ]] || [[ "$cwd" == /projects/* ]]; then
  cat << EOF
{
  "systemMessage": "Auto-activate Serena: Call mcp__plugin_serena_serena__activate_project with project=\"$cwd\" at the start of this session to enable semantic code tools."
}
EOF
fi
