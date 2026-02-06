# SDLC Process Definition

You are driving a structured software development lifecycle. You actively guide the process, prompting the human at every decision point. The human holds decision authority; you ensure the process happens and nothing falls through the cracks.

## How This File Is Used

This file is referenced from a project's `CLAUDE.md` to opt in. The `/sdlc` command reads this file and drives the workflow. You do not passively wait for instructions — you announce each phase, do the work, run quality checks, and prompt for decisions.

## Project Opt-In

Projects that use this SDLC add this snippet to their `CLAUDE.md`:

```markdown
## SDLC
When `/sdlc` is invoked, follow the process defined in `~/.claude/sdlc-process.md`.
```

## Feature Directory Structure

All artifacts live in `.sdlc/` at the project root. Each feature gets its own subdirectory:

```
.sdlc/
  add-user-auth/
    state.md
    requirements.md
    design.md
    verification-strategy.md
    verification-report.md
  fix-login-redirect/
    state.md
    requirements.md
```

The `.sdlc/` directory should be in the project's `.gitignore`. These artifacts are disposable working documents, not deliverables.

## Expert Review by Phase

The `/experts` skill provides structured multi-perspective analysis. Different phases benefit from different experts. Use `/experts <mode>` where the mode determines which experts run.

| Phase | Mode | Experts | Focus |
|-------|------|---------|-------|
| Requirements | `requirements-review` | adzic, evans | Traceable value, domain alignment |
| Design | `design` | hickey, evans, kleppmann, farley, esr | Conceptual integrity, domain modeling, trade-offs |
| Verification | `review` | All code experts | Change safety, testability, complexity |

**When to run expert review:**
- Run if the human requests it
- Run if you are uncertain about quality
- Always run at the Verification phase

**How to invoke:**
- Requirements phase: `/experts requirements-review` on the requirements artifact
- Design phase: `/experts design` on the design artifact
- Verification phase: `/experts review` on the implementation

---

## Phase Transitions

When a phase's work is complete and quality checks pass, present the output and prompt the human:

- [1] Approve and move to next phase
- [2] Revise (with specific feedback)
- [3] Skip this phase (with acknowledgment of what's being skipped)
- [4] Abort / change direction

Use AskUserQuestion to present these options. Wait for the human's response before proceeding.

---

## Phases

### 1. Requirements

**Purpose**: Capture what needs to change and why, in a form that later phases can check against.

**Artifact**: `.sdlc/<feature>/requirements.md`

**Content**:
- Problem statement or feature description
- Acceptance criteria (observable, testable outcomes)
- Constraints and assumptions
- Out-of-scope items (what this work intentionally does not address)

**Your workflow**:
1. Draft requirements based on the human's description. Ask clarifying questions if anything is ambiguous or underspecified.
2. Run quality checks (below).
3. Present the draft with your quality assessment.
4. Prompt: [1] Approve [2] Revise [3] Add more detail [4] Change scope

**Quality checks — Requirements quality**:
- Is each acceptance criterion testable? Could someone verify it passed or failed?
- Are the requirements complete? Do they cover the problem statement?
- Are they unambiguous? Is there only one reasonable interpretation?
- Is scope bounded? Are out-of-scope items explicit?

If quality checks fail, fix the issues before presenting to the human. If a fix requires a decision (for example, an ambiguous requirement that could go two ways), present the options to the human.

Write the approved requirements to the artifact file.

---

### 2. Design

**Purpose**: Decide how to solve the problem before writing code. Identify affected components, key decisions, and trade-offs.

**Artifact**: `.sdlc/<feature>/design.md`

**Content**:
- Approach summary (what changes, where, why)
- Key design decisions with rationale
- Affected files/components
- Interface changes (if any)
- For complex features: component interaction diagrams, architectural quality attributes

**Your workflow**:
1. Explore the codebase to understand current state. Use Serena's symbolic tools or the Explore agent to understand existing patterns and architecture.
2. Draft design, checking it against the requirements artifact.
3. Run quality checks (below).
4. Present design with quality assessment and any trade-off decisions that need human input.
5. Prompt: [1] Approve [2] Revise approach [3] Explore alternatives [4] Go back to requirements

**Quality checks — Design quality**:
- Does the design address every requirement and acceptance criterion?
- Is it consistent with existing codebase patterns and conventions?
- Is it minimally sufficient? Could anything be removed without losing a requirement?
- Are there security implications? If so, are they addressed?

Write the approved design to the artifact file.

---

### 3. Verification Planning

**Purpose**: Decide what verification this work needs. Replaces dogmatic "always test" or "test later" with a deliberate, per-feature decision.

**Artifact**: `.sdlc/<feature>/verification-strategy.md`

**Content**:
For each requirement or design component, one of:
- **Unit test**: Behavior is complex enough to warrant automated checks
- **Integration test**: Behavior depends on component interaction
- **Manual verification**: One-time check, or too costly to automate for the value
- **No test needed**: Trivial, or covered by existing tests

Include rationale for each decision and specific test scenarios (what to test, not test code).

**Your workflow**:
1. Examine each requirement and design component.
2. Propose a verification approach for each, with rationale.
3. Run quality checks (below).
4. Present the strategy.
5. Prompt: [1] Approve [2] Adjust specific items [3] More/fewer tests [4] Go back to design

**Quality checks — Strategy quality**:
- Is every requirement covered by at least one verification approach?
- Is the approach risk-proportionate? (High-risk areas get more thorough verification.)
- Is the rationale honest? (Not "no test needed" because testing is inconvenient.)

Write the approved strategy to the artifact file.

---

### 4. Implementation

**Purpose**: Write code and tests aligned with requirements and design.

**No separate artifact** — the code is the artifact. Tests are written as determined by the verification strategy.

**Your workflow**:
1. Implement per the approved design, following the project's coding rules.
2. Write tests as determined by the verification strategy.
3. Run quality checks (below).
4. When you encounter significant decisions or design deviations, prompt the human with options before proceeding. Do not silently deviate from the approved design.
5. Present completed implementation with your quality self-assessment.
6. Prompt: [1] Move to verification [2] Revise implementation [3] Go back to design

**Quality checks — Code quality**:
- Does the code satisfy every requirement and acceptance criterion?
- Does it match the approved design? If you deviated, did you get approval?
- Does it follow the project's coding rules?
- Are there security concerns (injection, XSS, auth bypass, etc.)?
- Are side effects explicit and obvious at the call site?

**Quality checks — Test quality** (when tests were planned):
- Do tests verify behavior, not just exercise code paths?
- Do tests match the verification strategy's scenarios?
- Would the tests catch a regression if the feature broke?

---

### 5. Verification

**Purpose**: Confirm the work is complete and correct through structured assessment.

**Artifact**: `.sdlc/<feature>/verification-report.md`

**Content**:
- Requirements coverage matrix (each requirement mapped to implementation location + test)
- Design adherence check (does code match design decisions?)
- Test results (all tests pass?)
- Coding rules compliance
- `/experts review` output

**Your workflow**:
1. Build the requirements coverage matrix. For each requirement, identify where in the code it's implemented and which test covers it.
2. Check design adherence using adversarial framing: "What could be wrong? Where might the implementation differ from the design? What edge cases are missing?"
3. Run all tests and report results.
4. Assess coding rules compliance.
5. Run `/experts review` on the implementation.
6. Present the verification report.
7. Prompt: [1] Approve — work is complete [2] Issues found — fix and re-verify [3] Needs rework in earlier phase

**Quality checks — Review quality**:
- Did you use adversarial framing? (The question is "what's wrong?" not "does this look good?")
- Is cross-phase consistency confirmed? (Requirements > Design > Code > Tests all align)
- Did the experts review surface anything the self-review missed?

Write the verification report to the artifact file.

---

## Documentation as Cross-Cutting Concern

Documentation is not a separate phase. Instead:

- **Requirements phase** captures the "what and why" (often becomes the basis for user docs)
- **Design phase** captures architectural decisions (developer docs)
- **Implementation** includes code comments where logic isn't self-evident (per coding-rules.md)
- **Verification** report serves as a completion record

If the feature needs user-facing documentation, capture that as an explicit requirement in phase 1. Track it like any other requirement through all phases.

---

## Iteration Protocol

When you discover during a later phase that an earlier artifact has a problem:

1. Identify which artifact is affected and explain the issue.
2. Prompt the human:
   - [1] Fix the earlier artifact and cascade updates through all downstream artifacts
   - [2] Adjust the current phase to work around it
   - [3] Accept the inconsistency with a noted rationale
3. If option 1: update the earlier artifact, then update all downstream artifacts. Resume from the current phase.
4. Record the iteration in `state.md` under notes.

This is expected, not a failure. The process handles it explicitly.

---

## State Management

Each feature's `state.md` tracks progress for session continuity:

```markdown
# SDLC State
- Feature: [feature name]
- Description: [brief description]
- Current phase: [phase name]
- Last completed phase: [phase name or "none"]
- Key decisions: [any decisions that affect remaining work]
- Notes: [anything relevant for session continuity]
```

Update `state.md` after every phase transition. Include enough context in "Key decisions" and "Notes" that a new session can resume without re-reading all artifacts.

---

## Feature Lifecycle

- **Active**: Has a `state.md` with a current phase that isn't "complete"
- **Complete**: Verification phase approved. Prompt the human: keep `.sdlc/<feature>/` for reference, or delete it?
- **Shelved**: Human chose to pause work. Update `state.md` notes with context for resumption.

---

## Session Continuity Protocol

When resuming work (typically via `/sdlc`):

1. Scan `.sdlc/` for features and their states.
2. Present feature options (resume existing, start new, shelve current).
3. For the selected feature, read `state.md` and the most recent artifact.
4. Summarize your understanding of where things stand.
5. Confirm with the human before proceeding.
6. Resume driving the workflow from the current phase.

---

## Structured Self-Review: Limitations and Mitigations

You reviewing your own work is inherently limited. The SDLC makes this honest:

1. **Checklist-driven**: Every phase has explicit quality checks. These are mechanical, not subjective — did you do X, yes or no.
2. **Adversarial framing**: During verification, the question is "what's wrong?" not "does this look good?"
3. **Cross-phase checking**: Each phase's artifact is reviewed against the previous phase's artifact. Requirements vs. design, design vs. code, code vs. tests.
4. **Experts review**: The `/experts` skill brings structured multi-perspective analysis. Different modes apply to different phases.
5. **Human as independent reviewer**: Every phase gate is a human decision point. You prepare the materials; the human judges.

The human should understand that quality checks catch structural issues (missed requirements, design deviations, untested code paths) but cannot guarantee the code is correct. The human's domain knowledge and judgment at each gate is the real quality assurance.
