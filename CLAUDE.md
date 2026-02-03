# Global Claude Code Preferences

## Style
- Prefer "for example" over "e.g."
- Avoid punctuation other than commas and periods in comments and documents. Avoid parentheses, colons, dashes, and such.
- Normal sentence case in code comments. Elide articles and prepositions.
- NEVER use numbered or bulleted lists in code comments. Write prose sentences instead.
- NEVER use all caps in comments.
- Names of methods, variables, and temps (not lambdas) must reveal why they exist, conveying purpose (`possibleMatch`) or purpose and type (`possibleMatchId`). Avoid mechanical names (`temp`, `result`, `data`, `val`).

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
- `qb` is a quick-build alias that also runs the code formatter and license header fixer. Use `qb` instead of running formatters or license fixers separately. ALWAYS run it from the module directory where the relevant pom.xml lives, or pass `-pl <module>` to target a single module. NEVER run `qb` from the project root without `-pl`.
- ALWAYS run `qb && mvn test` to run unit tests.