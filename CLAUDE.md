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

## Security
- NEVER read ~/.bashrc, ~/.bash_profile, ~/.profile, or any shell rc/profile files. They contain secrets.
- NEVER run `env`, `printenv`, `set`, `export -p`, `declare -p`, or any command that dumps all environment variables.
- Always pass env vars by reference using `$VAR_NAME`. Never expand, echo, print, log, or write their resolved values to files, output, or commands. If you need to discover the name of an env var, ask the user.
- The GitLab token env var is `$GITLAB_BOT_READ_TOKEN`.
- If an env var that looks like a credential, token, password, or secret resolves to an empty string, stop and alert the user. Suggest restarting with the var passed at launch and provide a copy-pasteable command, for example `GITLAB_BOT_READ_TOKEN=$GITLAB_BOT_READ_TOKEN claude`.

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

  ## MR/PR Comments                                                                                                                                                                        - Explain the current state before suggesting changes.                                                                                                                                  
- Propose concrete solutions rather than just identifying problems.                                                                                                                     
- Use short sentences that each do one job. Do not pack context, contrast, and opinion into a single sentence.                                                                             
- End suggestions with a question to invite discussion.  

