# Experts - Usage Guide

Dimensional analysis coordinated by a single `/experts` skill. The orchestrator examines code through 6 analytical dimensions in a single pass, then launches 2 adversarial agents to debate the findings. The result is a structured recommendation with built-in tension between preserving stability and pursuing improvement.

Dimensions and modes are configured in `config.yaml`. Each dimension defines a focus area and 5 analytical questions. Adversarial agents are defined in `agents/experts-advocate.md` and `agents/experts-challenger.md`.

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
Analyzes existing code. All 6 dimensions.

```
/experts review src/main/java/com/example/billing/InvoiceProcessor.java
/experts review the PaymentGateway interface and its implementations
```

Works best when you point it at a specific class, package, or interface. You can also use it after pasting code into the conversation.

### Design
Shapes new work before you write it. Runs structural clarity, domain alignment, operational readiness, and simplicity.

```
/experts design a circuit breaker for the notification service
/experts design how to decompose the monolithic SchedulerService
```

Works best when you describe the problem and constraints, not the solution.

### Refactor
Evaluates safe restructuring of existing code. Runs structural clarity, changeability, and simplicity.

```
/experts refactor the billing module
/experts refactor OrderService and its collaborators
```

Works best when you already have working code and want to improve its structure without changing behavior.

### API
Reviews public interfaces and API surfaces. Runs API surface, structural clarity, and simplicity.

```
/experts api the PaymentGateway interface
/experts api the REST endpoints in OrderController
```

Works best on interfaces, public APIs, and data models where early mistakes are expensive to fix.

### Ops
Assesses production readiness. Runs operational readiness and changeability.

```
/experts ops the notification service
/experts ops the event-driven order pipeline
```

Works best for evaluating debuggability, observability, and distributed systems trade-offs before shipping.

### Requirements Review
Reviews requirements artifacts. Runs domain alignment and simplicity.

```
/experts requirements-review .sdlc/add-user-auth/requirements.md
```

Works best on requirements and acceptance criteria documents during the SDLC requirements phase.

## How It Works

**Phase 1** - The orchestrator analyzes code through the applicable dimensions in a single pass. No parallel agent fan-out. 5 analytical questions per dimension, 3-5 findings per dimension.

**Short-circuit check** - If simplicity flags "unnecessary system," the orchestrator proposes a minimal viable structure and stops. If changeability flags "unsafe to change," it outputs a stabilization plan first.

**Phase 2** - Two adversarial agents launch in parallel. The advocate defends the current code; the challenger argues for change. Running in parallel prevents one from biasing the other.

**Phase 3** - The orchestrator synthesizes dimensional findings and adversarial arguments into a structured verdict.

## Output Format

Every experts run produces:

1. **Dimensions** - Findings per dimension (max 5 each)
2. **Advocate** - 3-5 arguments for preserving the current state
3. **Challenger** - 3-5 arguments for specific changes
4. **Verdict** - What to do, what not to do, tradeoffs. Opens with a one-sentence scope statement.
5. **Plan or Code** - Only when warranted: ordered steps for refactors/designs, diffs for code changes. Omitted if the verdict is self-contained.

## Short-Circuits

The skill stops early in two cases:

- **Simplicity flags "unnecessary system"** - the orchestrator proposes the smallest viable structure and stops. No point optimizing something that should not exist.
- **Changeability flags "unsafe to change"** - the orchestrator pauses feature work and outputs a stabilization plan first. No point designing new features on a foundation you cannot safely modify.

## Dimensions

| Dimension | Focus |
|-----------|-------|
| Structural Clarity | Data/state separation, naming, object boundaries, orthogonality |
| Changeability | Modification safety, seams, test coverage, dependency weight |
| Domain Alignment | Ubiquitous language, bounded contexts, traceable value |
| Operational Readiness | Testability, observability, debuggability, distributed trade-offs |
| API Surface | Naming honesty, abstraction leaks, consistency |
| Simplicity | Problem reality, ceremony ratio, deletion candidates |

## Tips

- **Be specific about scope.** `/experts review the checkout flow` is better than `/experts review everything`. The analysis is most useful when focused on a bounded piece of code or a concrete design question.
- **Combine with conversation context.** If you have been discussing a problem, `/experts` with no arguments reviews whatever is in context.
- **Pick the right mode.** Use `design` before writing code, `refactor` before restructuring, `api` on public interfaces, and `ops` before shipping. Use `review` when you want all perspectives.
- **Run it before big refactors.** The changeability dimension will identify the safest incremental path rather than a risky big-bang rewrite.
- **Design mode before coding.** Running `/experts design` before writing code is cheaper than running `/experts review` after.
- **Adversarial agents keep you honest.** The advocate prevents unnecessary churn; the challenger prevents complacency. The verdict weighs both.
