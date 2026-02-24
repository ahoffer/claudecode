# Review GitLab Merge Request

Review a GitLab MR by fetching its context and running `/experts review` against the local diff.

## Usage

```
/review-mr <gitlab-mr-url>
```

## Instructions

When this skill is invoked, follow these steps in order.

### 1. Parse the MR URL

Extract from the argument URL:
- **Host** (for example `gitlab.octo-cx-prod.runshiftup.com`)
- **Source branch** and **target branch**
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

If the token is present, use `glmr` to fetch MR metadata, linked issues, and all comments:
```bash
~/bin/glmr <gitlab-mr-url>
```

From the output, extract: title, description, source_branch, target_branch, author, state, and all human-authored discussion notes.

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

Before invoking the experts skill, present a brief summary to the user:
- MR title and author
- Source branch and target branch
- Number of changed files
- Number of discussion notes
- One-line synopsis of the MR description

### 5. Invoke experts review

Invoke the `/experts review` skill. Pass it the following context as the target:
- The MR title and description
- The discussion notes (so reviewers understand what has already been discussed)
- The full diff from step 3
- The list of changed files

The expert agents should treat the MR description and discussion notes as context that informs the review, not as code to review. The code under review is the diff.

ARGUMENTS: $ARGUMENTS
