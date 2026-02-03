# General Coding Rules

Apply these rules when writing or modifying code in any language.

## Structure
- Keep the main path flat; orchestration logic readable in one file with ≤2–3 call hops
- Make side effects explicit; all filesystem/network/db/process calls obvious at the call site
- Separate pure "compute" functions from "do" functions that perform effects
- One rule, one place; each business rule has a single obvious implementation point

## Data
- Prefer small, focused data carriers over rich "everything objects"
- Keep mutation rare; prefer immutable structures; if mutating, keep it localized and document ownership
- Maps/dicts are harder to reason about than typed objects or primitives; every map declaration must have a comment explaining why the map is important to the work of the function or class; prefer a typed object when modeling structured data

## Abstraction
- New type/interface only if reused, enforces a real invariant, isolates a volatile dependency, or improves testing meaningfully
- No wrapper types for naming alone
- Prefer composition over inheritance; inheritance only for true "is-a" with shared behavior
- Prefer simple branching (if/switch, explicit lookups) over polymorphic dispatch unless extensibility is required

## Errors
- No exceptions for expected control flow
- Prefer explicit results over thrown exceptions where the language supports it
- Meaningful error messages

## Naming
- Functions named by outcome: `calculateTotal`, `parseHeader`, `selectAnchors`
- Avoid vague verbs (`handle`, `process`, `manage`) except in tiny scopes

## Testing
- Test behavior over pure functions and public APIs
- Minimize mocks; prefer fakes/in-memory implementations at boundaries
