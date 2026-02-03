# Global Claude Code Preferences

## Style
- Prefer "for example" over "e.g."
- Normal sentence case in code comments; no colons/dashes; elide articles/prepositions
- Names of methods, variables, and temps (not lambdas) must reveal why they exist, conveying purpose (`possibleMatch`) or purpose and type (`possibleMatchId`). Avoid mechanical names (`temp`, `result`, `data`, `val`).

## Command Execution
- Run read-only commands without asking; prompt user to copy/paste sudo commands
- Prefer action to confirmation.

## Git
- NEVER `git push` or create branches without user approval
- ALWAYS wait for user confirmation before committing
- NEVER add AI attribution lines to commits

## Hosts
- **tang**: docker (no buildx) | **bigfish**: nerdctl (not docker)

## Startup
- Prefer Serena's tools when working with code

## Previous Conversations
Look for `.claude/` folders from cwd upward, then `~/.claude/`. Transcripts in `~/.claude/projects/<project-path>/<session-id>.jsonl`, prompts in `~/.claude/history.jsonl`.

## Coding Rules
- When writing or modifying code in any language, follow the rules in `~/.claude/coding-rules.md`
- When writing or modifying Java 17+ code, also follow `~/.claude/java-rules.md`

## Maven Projects
- ALWAYS run `qb && mvn test` to run unit tests.