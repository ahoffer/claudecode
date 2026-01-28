# Global Claude Code Preferences

## Command Execution

- Do NOT prompt for permission for read-only commands - just run them
- If a command needs sudo, prompt the user to copy and paste the command themselves instead of running it
- Prefer action over asking for confirmation on non-destructive operations

## Git Restrictions

- NEVER call `git push`
- NEVER create a new branch without user approval (no `git checkout -b`, `git branch`, `git switch -c`)

## Host-Specific Container Tools

- **tang**: Has docker, but does NOT have buildx (cannot use `docker buildx`)
- **bigfish**: Has nerdctl, NOT docker. Use `nerdctl` instead of `docker` on this host

## Ollama MCP Tools

The `mcp__ollama-sidekick__*` tools default to model `gpt-oss` which does NOT exist. Always specify a valid model:

- **Text/chat**: Use `model: "llama3.2:latest"`
- **Code generation**: Use `model: "qwen2.5-coder:7b"` or `"qwen2.5-coder:14b"`
- **Embeddings**: Use `model: "nomic-embed-text:latest"`

Ollama runs on **bigfish**. From other hosts (e.g., tang), SSH to bigfish or configure the MCP server to use `http://bigfish:11434`.

### Offload to Ollama - MANDATORY

**RULE**: Before generating boilerplate, explanations, summaries, or test stubs, FIRST try the appropriate `llm-*` tool. Only do it yourself if the tool fails or the task requires deep context.

**ANNOUNCE**: Always say "Offloading to Ollama..." before calling any `llm-*` tool, so the user knows work is being delegated.

**Self-check before responding:**
- Am I about to summarize logs/output? → `llm-summarize`
- Am I about to explain an error? → `llm-explain-error`
- Am I about to write boilerplate code? → `llm-gen-code`
- Am I about to generate tests? → `llm-test`
- Am I answering a simple factual question? → `llm-ask`
- Am I drafting a commit message? → `llm-commit-msg`

**CLI Tools Available (use via Bash):**
| Tool | Use For |
|------|---------|
| `llm-summarize` | Build logs, test output, large diffs, stack traces |
| `llm-commit-msg` | Generate conventional commit messages from staged changes |
| `llm-explain-error` | Diagnose errors, exceptions, stack traces |
| `llm-gen-code` | Boilerplate, simple functions, repetitive code |
| `llm-test` | Generate unit test stubs |
| `llm-docstring` | Generate documentation comments |
| `llm-review` | First-pass code review before detailed analysis |
| `llm-shell` | Generate shell commands from descriptions |
| `llm-regex` | Generate regex patterns |
| `llm-json` | Generate jq queries |
| `llm-ask` | Quick factual lookups |
| `llm-index` | Index codebase for semantic search |
| `llm-watch` | Run commands and summarize output |
| `llm-explore` | Codebase exploration (agentic grep/find) |
| `llm-budget` | Check Claude Code daily message usage |

**When to use CLI tools (DO THIS AUTOMATICALLY):**
1. **After running builds/tests**: Pipe output through `llm-summarize`
   ```bash
   mvn test 2>&1 | llm-summarize
   ```
2. **Before committing**: Use `llm-commit-msg` to draft message
3. **On errors**: Pipe to `llm-explain-error` for quick diagnosis
4. **Generating boilerplate**: Use `llm-gen-code --lang <lang>`
5. **Large log files**: Always summarize before reading fully
6. **After modifying scripts**: Test and pipe output through `llm-summarize` to verify

**MCP Tools (alternative to CLI):**
- `mcp__ollama__*` tools with models: `llama3.2:latest`, `qwen2.5-coder:7b`, `nomic-embed-text:latest`

**Keep in Claude (don't offload):**
- Architectural decisions requiring full codebase context
- Complex multi-file debugging
- Security-sensitive code review
- Refactoring with non-obvious implications
- Tasks requiring conversation history

## Codebase Exploration

For exploratory questions about the codebase, prefer `llm-explore`:
```bash
llm-explore "where is authentication handled?"
llm-explore "what tests cover the User model?"
llm-explore "find usages of deprecated API"
llm-explore "what modules handle SGPro integration?"
```

This uses local Ollama (free) instead of Claude context. The tool:
- Runs grep/find/cat commands autonomously via Ollama
- Iterates up to 5 times to gather information
- Returns only the final answer (not intermediate output)
- Blocks destructive commands (rm, mv, sudo, etc.)

## Budget Awareness

Periodically check Claude usage with `llm-budget`:
- **< 25%**: Normal operation
- **25-75%**: Prefer llm-* tools for routine tasks
- **> 75%**: Aggressively offload - use llm-explore, llm-summarize, llm-gen-code

Use `/ollama-usage` to see how many tokens were offloaded to Ollama this session.

## /ask Skill Behavior

- Only show the raw `llm-ask-hybrid` output
- Do not add formatted summaries after the command

## Startup Tasks

At the START of every session, before the user asks for anything:

1. **Activate Serena for cwd (only if it's a code project):**
   - Skip if cwd is `~` or `/home/aaron`
   - Skip if no project markers exist (pom.xml, package.json, Cargo.toml, go.mod, .git, etc.)
   - If markers exist, call `mcp__plugin_serena_serena__activate_project` with cwd
   - If activation fails, continue without Serena

Note: Ollama runs as a systemd service on bigfish - do NOT start it manually.

## Previous Conversation Context

When the user asks about a previous conversation:
1. First, look in current directory for `.claude/` folder
2. Then climb the directory tree looking for `.claude/` folders
3. Finally, check `~/.claude/` for context
4. Session transcripts are in `~/.claude/projects/<project-path>/<session-id>.jsonl`
5. Recent prompts can be found in `~/.claude/history.jsonl`

## Maven Project Automation

When validating, testing, or preparing commits on Maven projects:

**Environment:**
- Custom scripts in `~/bin` (on PATH)
- `qb` = Quick Build: `mvn clean install -T6 -DskipTests` + code formatting
- `qb -t` = Quick Build with tests
- Maven handles ALL builds: Java, UI (TypeScript/React), GraphQL, containers, Helm

**Finding Project Root:**
- Walk UP from cwd checking for pom.xml
- Keep going until a directory has NO pom.xml
- The last directory that HAD a pom.xml is the project root

**Validation Workflow:**

1. Find project root (as above)

2. Detect impacted modules:
   - If `scripts/impacted-modules.sh` exists at root, use it
   - Otherwise: `git diff --name-only HEAD` → map paths to modules → find dependents via pom.xml

3. Test each impacted module:
   - `cd <module> && qb && mvn test`
   - Wait for maven to exit before proceeding
   - Capture exit codes and failure output

4. Collect evidence:
   - git status, changed files, impacted modules (with reasoning)
   - Pass/fail per module, failure details if any

**Commit Rules (ALL must be true):**
- Working tree stable
- Tests passed for ALL impacted modules
- Impacted modules confidently identified

**If Tests Fail:**
- Stop, report failing module(s) with output
- Ask user how to proceed - do NOT auto-fix

**Commit Behavior:**
- Show: git status, files, modules, test summary
- Propose: `type(scope): description` (Conventional Commits)
- Commit only if all rules pass
