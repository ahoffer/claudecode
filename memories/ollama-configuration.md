# Ollama Configuration

**Confirmed working**: 2026-01-26

The Ollama MCP tools (`mcp__ollama-sidekick__*`) are configured and connected to the local Ollama instance at `http://bigfish:11434`.

## Available Models

| Model | Use Case |
|-------|----------|
| `llama3.2:latest` | General text/chat |
| `llama3.2-vision:11b` | Vision tasks |
| `qwen2.5-coder:7b` | Code generation (faster) |
| `qwen2.5-coder:14b` | Code generation (larger) |
| `nomic-embed-text:latest` | Text embeddings |

## Usage Guidelines

Per CLAUDE.md, offload routine tasks to Ollama to save Claude tokens:

- **Code generation** (qwen2.5-coder): Boilerplate, CRUD, simple validation, test stubs, DTOs
- **Chat** (llama3.2): Factual lookups, simple error explanations, commit message drafts
- **Summarization** (llama3.2): Build logs, test output, stack traces, git diffs
- **Embeddings** (nomic-embed-text): Semantic similarity, finding related code/docs

Keep complex reasoning, architectural decisions, and security-sensitive work in Claude.
