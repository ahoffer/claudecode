# Java 17 Rules

Additional rules for Java 17+ code (no Spring). General rules in `~/.claude/coding-rules.md` also apply.

## Data
- Use `record` for immutable data passed between layers
- Prefer explicit results: `Optional` for "maybe", or a small `Result<T,E>` type

## JDK First
- Use JDK types (`Optional`, `Stream` cautiously, `Path`, `HttpClient`) before adding dependencies
- Avoid clever Stream chains; choose loops when clearer
