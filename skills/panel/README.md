# Expert Panel — Usage Guide

Five analytical agents coordinated by a single `/panel` skill. Each agent applies a distinct lens to your code or design, and the orchestrator synthesizes their findings into one actionable recommendation.

## Quick Start

```
/panel review src/main/java/com/example/OrderService.java
/panel design a retry mechanism for failed event deliveries
/panel                  # reviews whatever you've been discussing
```

## Modes

### Review (default)
Analyzes existing code. All five agents run in parallel.

```
/panel review src/main/java/com/example/billing/InvoiceProcessor.java
/panel review the PaymentGateway interface and its implementations
```

Works best when you point it at a specific class, package, or interface. You can also use it after pasting code into the conversation.

### Design
Shapes new work before you write it. Runs Hickey (conceptual integrity), Farley (testability), and ESR (complexity veto). Feathers and Yegge join only if there is existing code involved.

```
/panel design a circuit breaker for the notification service
/panel design how to decompose the monolithic SchedulerService
```

Works best when you describe the problem and constraints, not the solution.

## The Five Agents

| Agent | Lens | Asks |
|-------|------|------|
| **Hickey** | Conceptual integrity | Are data, state, and identity properly separated? |
| **Farley** | Testability & behavior | Can workflows be tested with deterministic boundaries? |
| **Feathers** | Change safety | Can a developer modify this with confidence? |
| **Yegge** | Reader experience | Would a newcomer understand this API? |
| **ESR** | Complexity veto | Does this justify its own existence? |

## Output Format

Every panel run produces:

1. **Findings** — Bullets per agent (max 5 each)
2. **Verdict** — What to do, what not to do, tradeoffs. Opens with a one-sentence scope statement.
3. **Plan or Code** — Only when warranted: ordered steps for refactors/designs, diffs for code changes. Omitted if the verdict is self-contained.

## Conflict Resolution

When agents disagree, priority is:

1. Change safety (Feathers) — can we modify this without breaking things?
2. Behavior delivery (Farley) — does it deliver testable outcomes?
3. Conceptual integrity (Hickey) — is the data model clean?
4. API ergonomics (Yegge) — is it clear to outsiders?
5. Complexity veto (ESR) — is it minimal?

Exception: ESR can override higher-priority agents if something is pure ceremony with no user-visible value, unless removing it would reduce change safety.

## Short-Circuits

The panel stops early in two cases:

- **ESR flags "unnecessary system"** — the orchestrator asks Hickey and Farley to propose the smallest viable structure, then stops. No point optimizing something that shouldn't exist.
- **Feathers flags "unsafe to change"** — the orchestrator pauses feature work and outputs a stabilization plan first. No point designing new features on a foundation you can't safely modify.

## Tips

- **Be specific about scope.** `/panel review the checkout flow` is better than `/panel review everything`. The agents are most useful when focused on a bounded piece of code or a concrete design question.
- **Combine with conversation context.** If you've been discussing a problem, `/panel` with no arguments reviews whatever is in context.
- **Run it before big refactors.** The Feathers agent will identify the safest incremental path rather than a risky big-bang rewrite.
- **Run it on interfaces, not just implementations.** The Yegge and Hickey agents are especially useful on API surfaces and data models where early mistakes are expensive to fix later.
- **Design mode before coding.** Running `/panel design` before writing code is cheaper than running `/panel review` after.
