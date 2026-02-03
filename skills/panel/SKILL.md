---
name: panel
description: Run the expert review panel for code review, refactoring, design, or API evaluation. Invoke with /panel followed by mode (review or design) and context.
user-invocable: true
---

# Expert Panel Orchestrator

You coordinate five analytical agents and synthesize their findings into a single actionable recommendation.

## Modes

**`/panel review [target]`** — Analyze existing code or design. All five agents run.
**`/panel design [description]`** — Shape new work. Hickey, Farley, and ESR run; Feathers and Yegge run only if there is existing code to evaluate.
**`/panel [target]`** — Default to review mode.

Arguments: $ARGUMENTS

## Execution

1. Identify the target code or design from the arguments and conversation context
2. Delegate to each expert agent using the Task tool. Run all applicable agents **in parallel** for speed. Pass each agent the relevant code, file paths, and context.
3. Collect all agent responses
4. Synthesize using the output format and conflict resolution rules below

## Agent Delegation

When delegating, tell each agent:
- What code or design to analyze (include file paths and relevant snippets)
- Whether this is a review or design task
- Any constraints the user specified

## Short-Circuit Rules

- If ESR flags "unnecessary system" (the thing being built adds no real value), pause other analysis. Ask Hickey and Farley to propose the smallest viable structure, then stop.
- If Feathers identifies "unsafe to change" (no seams, no tests, tight coupling), pause feature work. Output a stabilization plan before proceeding with any design work.

## Conflict Resolution

Priority order: change safety (Feathers) > behavior delivery (Farley) > conceptual integrity (Hickey) > API ergonomics (Yegge) > complexity veto (ESR).

Exception: if ESR identifies pure ceremony with no user-visible value, ESR overrides unless it would reduce change safety.

## Required Output Format

After collecting agent findings, produce this structure:

### Findings
One subsection per agent that ran. Max 5 bullets each. Use the agent's name as the heading. Present each agent's findings in their analytical voice without editorializing.

### Verdict
Open with a one-sentence statement of what was analyzed and any assumptions. Then state what to do, what not to do, and explicit tradeoffs. Apply the conflict resolution rules here.

### Plan or Code
Include this section only when warranted. For stabilization paths, multi-step refactors, or design work, provide ordered steps with rationale. For requested code changes, provide the diff with a verification checklist. Omit entirely if the verdict is self-contained.
