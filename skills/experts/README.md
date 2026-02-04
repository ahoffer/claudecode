# Experts — Usage Guide

Analytical agents coordinated by a single `/experts` skill. Each agent applies a distinct lens to your code or design, and the orchestrator synthesizes their findings into one actionable recommendation.

Experts and modes are configured in `config.yaml`. Each expert entry defines a name, analytical lens, and conflict resolution priority. Each mode entry lists which experts run. To add a new expert, create `agents/experts-{name}.md`, add the expert to `config.yaml`, and include it in the relevant modes.

## Quick Start

```
/experts review src/main/java/com/example/OrderService.java
/experts design a retry mechanism for failed event deliveries
/experts                  # reviews whatever you've been discussing
```

## Modes

### Review (default)
Analyzes existing code. All experts configured for review mode run in parallel.

```
/experts review src/main/java/com/example/billing/InvoiceProcessor.java
/experts review the PaymentGateway interface and its implementations
```

Works best when you point it at a specific class, package, or interface. You can also use it after pasting code into the conversation.

### Design
Shapes new work before you write it. Runs the experts configured for design mode. Other experts join only if there is existing code involved.

```
/experts design a circuit breaker for the notification service
/experts design how to decompose the monolithic SchedulerService
```

Works best when you describe the problem and constraints, not the solution.

## Output Format

Every experts run produces:

1. **Findings** — Bullets per agent (max 5 each)
2. **Verdict** — What to do, what not to do, tradeoffs. Opens with a one-sentence scope statement.
3. **Plan or Code** — Only when warranted: ordered steps for refactors/designs, diffs for code changes. Omitted if the verdict is self-contained.

## Conflict Resolution

When agents disagree, the expert with the lower priority number in config.yaml wins.

Exception: ESR can override higher-priority agents if something is pure ceremony with no user-visible value, unless removing it would reduce change safety.

## Short-Circuits

The skill stops early in two cases:

- **ESR flags "unnecessary system"** — the orchestrator asks Hickey and Farley to propose the smallest viable structure, then stops. No point optimizing something that shouldn't exist.
- **Feathers flags "unsafe to change"** — the orchestrator pauses feature work and outputs a stabilization plan first. No point designing new features on a foundation you can't safely modify.

## Tips

- **Be specific about scope.** `/experts review the checkout flow` is better than `/experts review everything`. The agents are most useful when focused on a bounded piece of code or a concrete design question.
- **Combine with conversation context.** If you've been discussing a problem, `/experts` with no arguments reviews whatever is in context.
- **Run it before big refactors.** The Feathers agent will identify the safest incremental path rather than a risky big-bang rewrite.
- **Run it on interfaces, not just implementations.** The Yegge and Hickey agents are especially useful on API surfaces and data models where early mistakes are expensive to fix later.
- **Design mode before coding.** Running `/experts design` before writing code is cheaper than running `/experts review` after.
