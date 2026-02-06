# Experts — Usage Guide

Analytical agents coordinated by a single `/experts` skill. Each agent applies a distinct lens to your code or design, and the orchestrator synthesizes their findings into one actionable recommendation.

Experts and modes are configured in `config.yaml`. Each expert entry defines a name, analytical lens, and conflict resolution priority. Each mode entry lists which experts run. To add a new expert, create `agents/experts-{name}.md`, add the expert to `config.yaml`, and include it in the relevant modes.

## Quick Start

```
/experts review src/main/java/com/example/OrderService.java
/experts design a retry mechanism for failed event deliveries
/experts refactor the billing module
/experts api the PaymentGateway interface
/experts ops the notification service
/experts                  # reviews whatever you've been discussing
```

## Modes

### Review (default)
Analyzes existing code. All experts run in parallel.

```
/experts review src/main/java/com/example/billing/InvoiceProcessor.java
/experts review the PaymentGateway interface and its implementations
```

Works best when you point it at a specific class, package, or interface. You can also use it after pasting code into the conversation.

### Design
Shapes new work before you write it. Runs hickey, farley, evans, kleppmann, and esr. Other experts join only if there is existing code involved.

```
/experts design a circuit breaker for the notification service
/experts design how to decompose the monolithic SchedulerService
```

Works best when you describe the problem and constraints, not the solution.

### Refactor
Evaluates safe restructuring of existing code. Runs feathers, fowler, metz, beck, and pike.

```
/experts refactor the billing module
/experts refactor OrderService and its collaborators
```

Works best when you already have working code and want to improve its structure without changing behavior.

### API
Reviews public interfaces and API surfaces. Runs yegge, hickey, fowler, and pike.

```
/experts api the PaymentGateway interface
/experts api the REST endpoints in OrderController
```

Works best on interfaces, public APIs, and data models where early mistakes are expensive to fix.

### Ops
Assesses production readiness. Runs cantrill, farley, and kleppmann.

```
/experts ops the notification service
/experts ops the event-driven order pipeline
```

Works best for evaluating debuggability, observability, and distributed systems trade-offs before shipping.

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

## Experts

| Expert | Lens | Focus |
|--------|------|-------|
| hickey | conceptual integrity | Data, state, identity, and behavior separation |
| farley | testable systems | Workflow clarity, test boundaries, observability |
| feathers | change safety | Modification risk, seams, dependency weight |
| fowler | refactoring vocabulary | Code smells, naming, design communication |
| pike | clarity and restraint | Obviousness, orthogonality, earned complexity |
| metz | practical composition | Object size, message flow, dependency direction |
| beck | evolutionary simplicity | Four rules of simple design, TDD rhythm |
| evans | domain modeling | Ubiquitous language, bounded contexts, aggregates |
| adzic | traceable value | Requirements to goals, specification by example |
| yegge | reader experience | Naming honesty, abstraction leaks, surprise factor |
| cantrill | operational honesty | Debuggability, observability, failure modes |
| kleppmann | honest trade-offs | Consistency models, replication, data flow |
| esr | complexity veto | Problem reality, ceremony ratio, deletion candidates |

## Tips

- **Be specific about scope.** `/experts review the checkout flow` is better than `/experts review everything`. The agents are most useful when focused on a bounded piece of code or a concrete design question.
- **Combine with conversation context.** If you've been discussing a problem, `/experts` with no arguments reviews whatever is in context.
- **Pick the right mode.** Use `design` before writing code, `refactor` before restructuring, `api` on public interfaces, and `ops` before shipping. Use `review` when you want all perspectives.
- **Run it before big refactors.** The Feathers agent will identify the safest incremental path rather than a risky big-bang rewrite.
- **Design mode before coding.** Running `/experts design` before writing code is cheaper than running `/experts review` after.
