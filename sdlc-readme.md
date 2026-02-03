# SDLC for Claude Code

A practical, AI-assisted software development lifecycle for solo developers using Claude Code. Claude actively drives the workflow, prompting you at every decision point. You hold decision authority; Claude ensures the process happens.

## Why This Exists

Writing code is easy. Shipping correct, well-considered code is harder. This SDLC provides structure without bureaucracy: requirements before code, design before implementation, verification before "done." Claude handles the process mechanics so you can focus on decisions and domain knowledge.

## Setup

### 1. Opt a project in

Add this to the project's `CLAUDE.md`:

```markdown
## SDLC
When `/sdlc` is invoked, follow the process defined in `~/.claude/sdlc-process.md`.
```

### 2. Add `.sdlc/` to `.gitignore`

The `.sdlc/` directory contains working artifacts, not deliverables. Add it to your project's `.gitignore`:

```
.sdlc/
```

### 3. Use it

Type `/sdlc` in any Claude Code session within the opted-in project.

## How It Works

### Starting a Feature

When you run `/sdlc`, Claude scans for existing features in `.sdlc/` and either offers to resume one or prompts you to describe new work. You'll provide a feature name, description, and confirm a tier (see below).

Claude then drives through phases sequentially. At each phase, Claude does the work, runs quality checks, presents the output, and asks you to approve, revise, or change direction.

### Tiers

Not every change needs the same ceremony.

**Tier 1 — Light**: For obvious bug fixes, small tweaks, and well-understood changes. Phases: Implement > Verify. Use this when you already know exactly what to do and the risk of getting it wrong is low.

**Tier 2 — Standard**: For typical features, non-trivial bugs, and moderate-scope work. Phases: Requirements > Design > Verification Planning > Implement > Verify. This is the default for most work. Use it when the change touches multiple components or has non-obvious implications.

**Tier 3 — Full**: For new subsystems, architectural changes, and high-risk modifications. All phases with full artifacts and `/panel review`. Use this when getting it wrong would be expensive to fix, or when the work changes the system's fundamental structure.

Claude proposes a tier based on your description. Override it if you disagree — you know your codebase and risk tolerance better than Claude does.

### Common tier selection mistakes

- **Always picking Tier 1** to avoid ceremony. If you're skipping requirements and design for non-trivial work, you're trading a few minutes of upfront thought for debugging time later.
- **Always picking Tier 3** for safety. Full ceremony on a simple bug fix is wasted effort. Trust the lighter tiers for lighter work.
- **Upgrading mid-feature**. If you started Tier 1 and realize the change is more complex than expected, tell Claude. It will adjust.

### Phase Transitions

At every phase gate, Claude presents numbered options:

- [1] Approve and move to next phase
- [2] Revise (with specific feedback)
- [3] Skip this phase
- [4] Abort / change direction

Pick a number (or type your own response). Claude won't proceed without your input.

## Phases in Detail

### Requirements (Tier 2+)

Claude drafts requirements based on your description: problem statement, acceptance criteria, constraints, out-of-scope items. The goal is testable, unambiguous criteria that later phases can check against.

**Getting good results**: Describe requirements in terms of observable behavior ("when a user clicks X, Y should happen"), not implementation ("add a function that does Z"). Be explicit about what's out of scope.

### Design (Tier 2+)

Claude explores the codebase, then proposes an approach: what changes, where, why, and what trade-offs are involved. The design is checked against requirements.

**Getting good results**: Push back on complexity. If the design feels over-engineered, say so. Ask "what's the simplest thing that could work?" Claude sometimes over-builds; your job is to keep it grounded.

### Verification Planning (Tier 2+)

Claude proposes what verification each requirement needs: unit test, integration test, manual verification, or no test. Each decision includes rationale.

**Getting good results**: Watch for "no test needed" rationalizations on non-trivial behavior. Also watch for unnecessary test plans on trivial getters or configuration. The right amount of testing is proportional to risk.

### Implementation (All tiers)

Claude writes code and tests per the approved design and verification strategy. If it encounters decisions not covered by the design, it prompts you before proceeding.

**Getting good results**: If Claude asks about a design deviation, take it seriously — it usually means the design missed something. Decide whether to update the design or adjust the implementation.

### Verification (All tiers)

Claude builds a requirements coverage matrix, checks design adherence adversarially, runs tests, and assesses coding rules compliance. For Tier 3, this includes a `/panel review`.

**Getting good results**: Read the coverage matrix. If a requirement maps to "covered by implementation" but has no test and the verification strategy said it should, that's a gap. The human review at this gate is the most important quality check in the whole process.

## Working with Quality Checks

Every phase includes quality checks that Claude runs before presenting output. These checks are mechanical: "Is each requirement testable? Does the design address every requirement? Does the code follow coding rules?"

### What quality checks catch

- Missed requirements (something in the requirements not addressed in design or code)
- Design deviations (code that doesn't match the approved design)
- Untested scenarios (verification strategy says "unit test" but no test exists)
- Structural issues (requirements that aren't testable, designs that don't address all requirements)

### What quality checks don't catch

- Incorrect logic (the code does what you asked, but what you asked was wrong)
- Missing requirements (you never mentioned a constraint that matters)
- Subtle bugs (off-by-one, race conditions, edge cases nobody thought of)
- Domain errors (the design is internally consistent but doesn't solve the real problem)

Your judgment at each phase gate compensates for these limitations. Don't rubber-stamp approvals.

## Feature Management

### Multiple features

You can have multiple features in `.sdlc/` at once. When you run `/sdlc`, Claude lists them and asks which one to work on.

### Shelving

If you need to pause a feature, tell Claude to shelve it. Claude updates `state.md` with context notes so it can resume later. Shelved features show up in the feature list with their status.

### Completing

When the verification phase is approved, Claude marks the feature as complete and asks whether to keep the `.sdlc/<feature>/` directory for reference or delete it.

### Direct commands

- `/sdlc` — scan and prompt (default)
- `/sdlc new <name>` — start a new feature with the given name
- `/sdlc resume` — resume the most recently active feature
- `/sdlc list` — show all features and statuses

## Session Continuity

The SDLC is designed to survive session boundaries. Each feature's `state.md` records the current phase, tier, key decisions, and notes.

When you start a new session and type `/sdlc`, Claude reads the state, summarizes where things stand, and confirms its understanding before proceeding. You don't need to re-explain anything.

If session context is lost mid-phase (for example, a long implementation), the artifacts in `.sdlc/<feature>/` serve as the canonical record. Claude reads them to rebuild context.

## Common Pitfalls

**Vague requirements**: "Make it faster" or "improve the UX" aren't actionable requirements. Claude will try to make them specific, but you'll get better results if you describe the observable problem and desired outcome.

**Skipping phases then wanting their benefits**: If you skip design, don't expect the verification phase to catch design-level problems. Each phase builds on the previous one.

**Treating approvals as formalities**: The phase gates exist so you can catch problems early. If you approve everything without reading it, you're just adding ceremony without value.

**Not providing domain knowledge**: Claude knows your code but not your business context. When requirements involve domain-specific behavior, explain the "why" — Claude can't infer it from the codebase.

**Fighting the tier**: If you picked Tier 1 and Claude keeps discovering complexity, let it suggest an upgrade. If you picked Tier 3 and every phase is trivial, downgrade. The tier should match the actual complexity, not your initial guess.
