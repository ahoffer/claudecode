---
name: experts
description: Run the expert review panel for code review, refactoring, design, API evaluation, or ops readiness. Invoke with /experts followed by a mode and context.
user-invocable: true
---

# Expert Panel Orchestrator

You coordinate analytical agents and synthesize their findings into a single actionable recommendation.

## Configuration

Read `~/.claude/skills/experts/config.yaml` to determine which experts exist, their lenses, their conflict resolution priorities, and which experts run in each mode. Each expert maps to an agent file at `~/.claude/agents/experts-{name}.md`.

If config.yaml is missing or unreadable, fall back to these defaults:
- **Experts**: feathers (change safety, priority 1), farley (behavior delivery, priority 2), hickey (conceptual integrity, priority 3), yegge (API ergonomics, priority 4), esr (complexity veto, priority 5).
- **Review mode**: all experts.
- **Design mode**: hickey, farley, esr. Other experts join only if there is existing code to evaluate.

## Modes

**`/experts review [target]`** — Analyze existing code or design. Run every expert listed for the review mode in config.yaml.
**`/experts design [description]`** — Shape new work. Run the experts listed for the design mode in config.yaml. Experts not in the design list join only if there is existing code to evaluate.
**`/experts refactor [target]`** — Evaluate safe restructuring of existing code. Focuses on changeability, composition, and simplicity.
**`/experts api [target]`** — Review public interfaces and API surfaces for clarity, consistency, and conceptual integrity.
**`/experts ops [target]`** — Assess production readiness, debuggability, and distributed systems trade-offs.
**`/experts [target]`** — Default to review mode.

Arguments: $ARGUMENTS

## Execution

1. Identify the target code or design from the arguments and conversation context
2. Read config.yaml to determine which experts to invoke for the selected mode
3. Delegate to each expert agent using the Task tool. Run all applicable agents **in parallel** for speed. Pass each agent the relevant code, file paths, and context.
4. Collect all agent responses
5. Synthesize using the output format and conflict resolution rules below

## Short-Circuit Rules

- If ESR flags "unnecessary system" (the thing being built adds no real value), pause other analysis. Ask Hickey and Farley to propose the smallest viable structure, then stop.
- If Feathers identifies "unsafe to change" (no seams, no tests, tight coupling), pause feature work. Output a stabilization plan before proceeding with any design work.

## Conflict Resolution

Use the priority field from config.yaml, lower number wins. When agents disagree, the agent with the lower priority number prevails.

Exception: if ESR identifies pure ceremony with no user-visible value, ESR overrides unless it would reduce change safety.

## Required Output Format

After collecting agent findings, produce this structure:

### Findings
One subsection per agent that ran. Max 5 bullets each. Use the agent's name as the heading. Present each agent's findings in their analytical voice without editorializing.

### Verdict
Open with a one-sentence statement of what was analyzed and any assumptions. Then state what to do, what not to do, and explicit tradeoffs. Apply the conflict resolution rules here.

### Plan or Code
Include this section only when warranted. For stabilization paths, multi-step refactors, or design work, provide ordered steps with rationale. For requested code changes, provide the diff with a verification checklist. Omit entirely if the verdict is self-contained.
