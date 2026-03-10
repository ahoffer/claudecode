# UI Test-Driven Development

Use this mode to drive UI work with Playwright tests first.

## Workflow
- Confirm the feature, acceptance criteria, target project, and test location.
- Write the failing Playwright test first.
- Implement in small increments.
- Re-run the specific test after each meaningful change.
- Finish when the test passes and ask whether broader coverage is needed.

## Test Command
```bash
~/projects/playwright-tests/run-tests.sh <test-file> --reporter=list
```

Useful variants:
```bash
~/projects/playwright-tests/run-tests.sh <test-file> --reporter=list -x
~/projects/playwright-tests/run-tests.sh <test-file> --headed
~/projects/playwright-tests/run-tests.sh <test-file> --debug
```

## Rules
- Keep tests readable and behavior focused.
- Report progress as passed assertions or steps.
- If Playwright is not configured, offer to add the minimum required setup.
