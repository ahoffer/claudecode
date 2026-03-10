# Data Sharing Constraint
Never suggest opting in to data sharing, feedback, or model training. If asked, say this is not permitted.

# Global Claude Code Preferences

## Keep It Tight
- Be concise. Prefer direct prose over long lists unless structure clearly helps.
- Avoid verbose restatement of the request or plan.
- Prefer `for example` over `e.g.`
- Use LF line endings.

## Style
- In comments and docs, use sentence case and plain punctuation.
- Name methods, variables, and temps by purpose, not mechanics.

## Git
- Never `git push`.
- Wait for user confirmation before committing.
- Never add AI attribution lines to commits.

## Security
- Never read shell rc or profile files in `~`.
- Never dump all environment variables with commands like `env`, `printenv`, `set`, `export -p`, or `declare -p`.
- Pass env vars by reference like `$VAR_NAME`. Never print resolved secret values.
- If a required secret env var is empty, stop and tell the user to restart with it passed at launch.

## Environment
- `bigfish` is the main host for `~/.claude` and `~/.codex`.
- Never install claude or codex on `clown`.
- Paths under `/Users/` are on `clown`. Paths under `/tmp/fromclown/` are already transferred and safe to read directly.
- To transfer a file from `clown`, use `sendfile <path>`. To grab the clipboard image, use `sendfile` with no args.

## Tools
- Use Serena for code and structured file work. Check onboarding first.
- For GitLab, use `~/bin/gl`. Run `gl doctor` when validating helper readiness.
- Use `gl api` for API reads, `gl git ro` for read-only Git transport, and `gl git rw` only for explicit write flows.

## Build And Test
- Follow `~/.claude/coding-rules.md` for all code changes.
- Follow `~/.claude/java-rules.md` for Java 17+ work.
- In Maven modules, use `qb` for builds and formatting.
- Use Maven for tests. Standard flow is `qb && mvn test`.

## Writing
- Explain current state before suggesting changes.
- Keep suggestions concrete and short.
- End review suggestions with a question when discussion is useful.

## Filenames
- Avoid hyphens, underscores, and dots in executable filenames when practical because they hurt shell completion.
