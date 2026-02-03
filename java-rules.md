# Java 17 Rules

Additional rules for Java 17+ code (no Spring). General rules in `~/.claude/coding-rules.md` also apply.

## Data
- Use `record` for immutable data passed between layers
- Prefer explicit results: `Optional` for "maybe", or a small `Result<T,E>` type

## Source Navigation
- NEVER unzip or extract JAR/WAR/EAR files when `.java` source is available locally or fetchable from the web
- When the user points you to a source directory, look for `.java` files there instead of searching for packaged artifacts
- Prefer reading `.java` source files over decompiled or binary class references in every case

## JDK First
- Use JDK types (`Optional`, `Stream` cautiously, `Path`, `HttpClient`) before adding dependencies
- Avoid clever Stream chains; choose loops when clearer
