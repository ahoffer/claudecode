# Global Claude Code Preferences

## Style
- Prefer "for example" over "e.g."
- Normal sentence case in code comments; no colons/dashes; elide articles/prepositions

## Command Execution
- Run read-only commands without asking; prompt user to copy/paste sudo commands
- Prefer action over confirmation

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

## Maven Projects
- ALWAYS run `qb && mvn test` to run unit tests. 