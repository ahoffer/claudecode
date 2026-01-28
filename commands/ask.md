# Unified Ask Skill

Query both Ollama's knowledge and web search, then synthesize results.

## Usage

```
/ask <your question>
```

## Instructions

When this skill is invoked:

1. Run the hybrid query:
   ```bash
   llm-ask-hybrid "<user's question>"
   ```
2. Display the synthesized response directly to the user
3. Do not add commentary - just show the response

## How It Works

The tool runs in parallel:
- `llm-ask` - queries Ollama's trained knowledge
- `llm-search` - searches the web and summarizes

Then synthesizes both sources with Ollama, preferring web results for current info and LLM for stable concepts.

## Example

User runs: `/ask how fast is a 5060 ti?`

Execute:
```bash
llm-ask-hybrid "how fast is a 5060 ti?"
```


ARGUMENTS: $ARGUMENTS
