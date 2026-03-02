# Data Sharing Constraint
- The user is NOT permitted to allow data sent through Claude Code to be used for model training. Do not suggest opting in to any data sharing, feedback, or training program. If asked, remind the user of this constraint.

# Global Claude Code Preferences

## Style
- Prefer "for example" over "e.g."
- Avoid punctuation other than commas and periods in comments and documents. Avoid parentheses, colons, dashes, and such.
- Normal sentence case in code comments. Elide articles and prepositions.
- NEVER use numbered or bulleted lists in code comments. Write prose sentences instead.
- NEVER use all caps in comments.
- Names of methods, variables, and temps (not lambdas) must reveal why they exist, conveying purpose (`possibleMatch`) or purpose and type (`possibleMatchId`). Avoid mechanical names (`temp`, `result`, `data`, `val`).
- ALWAYS use Unix line endings (LF). NEVER use Windows line endings (CRLF).

## Git
- NEVER `git push` or create branches without user approval
- ALWAYS wait for user confirmation before committing
- NEVER add AI attribution lines to commits

## Hosts
- **tang**: nerdctl (rootless containerd + RKE2) | **bigfish**: nerdctl (not docker)

## Security
- NEVER read ~/.bashrc, ~/.bash_profile, ~/.profile, or any shell rc/profile files. They contain secrets.
- NEVER run `env`, `printenv`, `set`, `export -p`, `declare -p`, or any command that dumps all environment variables.
- Always pass env vars by reference using `$VAR_NAME`. Never expand, echo, print, log, or write their resolved values to files, output, or commands. If you need to discover the name of an env var, ask the user.
- The GitLab token env var is `$GITLAB_BOT_READ_TOKEN`.
- If an env var that looks like a credential, token, password, or secret resolves to an empty string, stop and alert the user. Suggest restarting with the var passed at launch and provide a copy-pasteable command, for example `GITLAB_BOT_READ_TOKEN=$GITLAB_BOT_READ_TOKEN claude`.

## Startup
- ALWAYS use Serena's tools when working with any kind of code or structured files
- On startup, call `check_onboarding_performed` to see if Serena is activated for the current project. If onboarding was not performed, ask the user whether to activate and onboard Serena for this project.

## Coding Rules
- When writing or modifying code in any language, follow the rules in `~/.claude/coding-rules.md`
- When writing or modifying Java 17+ code, also follow `~/.claude/java-rules.md`

## Maven Projects
- `qb` is a quick-build alias that also runs the code formatter and license header fixer. Use `qb` instead of running formatters or license fixers separately. ALWAYS run it from the module directory where the relevant pom.xml lives, or pass `-pl <module>` to target a single module. NEVER run `qb` from the project root without `-pl`.
- ALWAYS run `qb && mvn test` to run unit tests.

## MR/PR Comments
- Explain the current state before suggesting changes.
- Propose concrete solutions rather than just identifying problems.
- Use short sentences that each do one job. Do not pack context, contrast, and opinion into a single sentence.
- End suggestions with a question to invite discussion.

## GitLab
- ALWAYS use the helper scripts in ~/bin for GitLab access. NEVER manually construct curl commands to the GitLab API.
- `glmr <mr-url>` fetches MR details, linked issues, and all comments. This is the go-to tool for reviewing merge requests.
- `glapi <web-url> [sub-resource]` translates GitLab web URLs to API endpoints. Handles URL encoding and authentication automatically.
- Both scripts use `$GITLAB_BOT_READ_TOKEN` for authentication.

## Filename
- AVOID hyphen, underscores and dots in executable filename because they make tab completion difficult

## Files from clown

When the user provides a file path that does not exist on bigfish, the file
is on clown. Transfer it first by calling `mcp__clown__start_process` with
command `sendfile <path>` and timeout_ms `10000`. The stdout line is the
file path on bigfish. Then read that file with the Read tool.

macOS paths may contain invisible non-breaking spaces. When the path has
spaces, glob it to a temp path first, then sendfile the temp path, for
example `cp /path/to/Screenshot*10.56.21* /tmp/ss.png && sendfile /tmp/ss.png`.

Paths under /Users/ are always on clown. Paths under /tmp/fromclown/ are
files already transferred from clown. Read those directly.

When the user says to grab the clipboard image, run `sendfile` with no
arguments using the same MCP tool, then read the resulting path.
