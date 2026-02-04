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
- **Project path** (for example `octo-cx/cx/cx-search`), then URL-encode slashes as `%2F`
- **MR IID** (the number at the end)

If no URL is provided or the URL does not look like a GitLab MR, ask the user for one.

### 2. Fetch MR details from GitLab API

First, verify the token is available by checking `$GITLAB_BOT_READ_TOKEN` is non-empty:
```bash
test -n "$GITLAB_BOT_READ_TOKEN" && echo "ok" || echo "empty"
```

If the token is empty, stop immediately and tell the user:
> `GITLAB_BOT_READ_TOKEN` is not set. Restart with it passed at launch, for example:
> `GITLAB_BOT_READ_TOKEN=$GITLAB_BOT_READ_TOKEN claude`

If the token is present, fetch the MR metadata first:
```bash
curl -s -w "\nHTTP_CODE:%{http_code}" --header "PRIVATE-TOKEN: $GITLAB_BOT_READ_TOKEN" "https://<host>/api/v4/projects/<encoded-path>/merge_requests/<iid>"
```

Check the HTTP status code. If it is not 200, stop and report the error to the user with the status code and response body. Common causes: 401 means bad token, 404 means wrong project path or MR number.

Only after the metadata call succeeds, fetch the notes:
```bash
curl -s --header "PRIVATE-TOKEN: $GITLAB_BOT_READ_TOKEN" "https://<host>/api/v4/projects/<encoded-path>/merge_requests/<iid>/notes?per_page=100&sort=asc"
```

From the metadata, extract: title, description, source_branch, target_branch, author, state, web_url.
From the notes, extract all human-authored notes, ignoring system notes. Keep the author and body of each.

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
