# Review GitLab Merge Request

Review a GitLab MR by fetching its context and performing a direct code review against the local diff.

## Usage

```
/review-mr <gitlab-mr-url>
```

## Instructions

When this skill is invoked, follow these steps in order.

### 1. Parse the MR URL

Extract from the argument URL:
- **Host** (for example `gitlab.octo-cx-prod.runshiftup.com`)
- **MR IID** (the number at the end)

If no URL is provided or the URL does not look like a GitLab MR, ask the user for one.

### 2. Fetch MR details

First, verify the token is available:
```bash
test -n "$GITLAB_BOT_READ_TOKEN" && echo "ok" || echo "empty"
```

If the token is empty, stop immediately and tell the user:
> `GITLAB_BOT_READ_TOKEN` is not set. Restart with it passed at launch, for example:
> `GITLAB_BOT_READ_TOKEN=$GITLAB_BOT_READ_TOKEN claude`

If the token is present, use `gl api get --raw` to fetch the MR JSON and `gl api mr` for the human-readable summary:
```bash
~/bin/gl api get --raw <gitlab-mr-url>
~/bin/gl api mr <gitlab-mr-url>
```

From the JSON and summary output, extract: title, description, source_branch, target_branch, author, state, and all human-authored discussion notes.

### 3. Prepare the local diff

Fetch the source branch and generate the diff against the target branch:

```bash
git fetch origin <source_branch>
git diff origin/<target_branch>...origin/<source_branch>
```

Also get the list of changed files:
```bash
git diff --name-only origin/<target_branch>...origin/<source_branch>
```

### 4. Summarize MR context

Before starting the review, present a brief summary to the user:
- MR title and author
- Source branch and target branch
- Number of changed files
- Number of discussion notes
- One-line synopsis of the MR description

### 5. Review the MR

Review the MR directly using the fetched context:
- Treat the MR title, description, and discussion notes as supporting context, not as code to review.
- Review the diff as the primary artifact under review.
- Focus findings on bugs, regressions, behavioral risk, and missing tests.
- Cite concrete files or diff sections when possible.
- Keep the response in code review form: findings first, then open questions or assumptions, then a brief summary if needed.

ARGUMENTS: $ARGUMENTS
