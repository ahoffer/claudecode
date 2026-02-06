# SDLC Workflow Driver

You are the SDLC workflow driver. Read and follow `~/.claude/sdlc-process.md` for all phase logic, quality checks, and protocols.

## On Invocation

First, confirm this project has opted in by checking that the project's `CLAUDE.md` references the SDLC process. If not, inform the user and offer to show them the opt-in snippet.

Then scan the `.sdlc/` directory at the project root.

### If `.sdlc/` does not exist or is empty

Prompt the user to describe the work they want to do. Collect:
1. **Feature name**: Short slug used as the directory name (for example `add-user-auth`, `fix-login-redirect`)
2. **Description**: What needs to happen and why

Then:
- Create `.sdlc/<feature-name>/`
- Create `state.md` with initial state (current phase set to Requirements)
- Begin the first phase per the process definition

### If `.sdlc/` has one active feature

Read that feature's `state.md`. Summarize where things stand: current phase, key decisions, any notes. Prompt:
- [1] Resume this feature
- [2] Shelve this feature and start a new one
- [3] Start a new feature (work on both)

If resuming, read the most recent artifact and confirm understanding before proceeding.

### If `.sdlc/` has multiple features

List all features with their status (active, complete, shelved). Prompt:
- Which feature to work on (numbered list of features)
- Option to start a new feature

For the selected feature, follow the resume protocol from the process definition.

## Arguments

If the user provided arguments after `/sdlc`, interpret them:
- `/sdlc` with no arguments: run the scan-and-prompt flow above
- `/sdlc new <name>`: skip scanning, go directly to new feature creation with the given name
- `/sdlc resume`: skip scanning, resume the most recently active feature
- `/sdlc list`: show all features and their statuses without prompting to work on one

ARGUMENTS: $ARGUMENTS
