# UI Test-Driven Development Skill

You are now in **UI Test-Driven Development mode**. Follow this workflow:

## Workflow

### Phase 1: Understand Requirements
- Ask the user what feature/functionality they want to implement
- Clarify acceptance criteria (what should the UI do?)
- Identify the target project and its test directory

### Phase 2: Write the Test First
- Create a Playwright test file in the project's test directory
- Write test steps that define the expected behavior
- Each step should be a clear assertion that will initially fail
- Use descriptive test names and comments

### Phase 3: Progressive Implementation
- Implement code in small increments
- After each significant change, run the test:
  ```bash
  cd <project> && ~/projects/playwright-tests/run-tests.sh <test-file> --reporter=list
  ```
- Report progress: "X/Y steps passing"
- Continue until all assertions pass

### Phase 4: Completion
- All tests green
- Ask if user wants additional test coverage
- Offer to add the test to CI/regression suite

## Commands Available

```bash
# Run specific test with progress
~/projects/playwright-tests/run-tests.sh tests/feature.spec.js --reporter=list

# Run and stop on first failure (debugging)
~/projects/playwright-tests/run-tests.sh tests/feature.spec.js --reporter=list -x

# Run headed (watch the browser)
~/projects/playwright-tests/run-tests.sh tests/feature.spec.js --headed

# Debug mode (step through)
~/projects/playwright-tests/run-tests.sh tests/feature.spec.js --debug
```

## Test Template

```javascript
const { test, expect } = require('@playwright/test');

test.describe('Feature: <NAME>', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('<APP_URL>');
  });

  test('should <expected behavior>', async ({ page }) => {
    // Step 1: <action>
    await page.click('<selector>');
    await expect(page.locator('<selector>')).toBeVisible();

    // Step 2: <action>
    // ... continue with steps
  });
});
```

## Project Configuration

If the target project doesn't have Playwright configured, offer to:
1. Copy playwright.config.js from ~/projects/playwright-tests/
2. Create a tests/ directory
3. Add npm scripts for running tests

## Key Principles

- **Test first**: Write the test before implementing
- **Small steps**: Implement incrementally, test often
- **Visible progress**: Always report how many steps are passing
- **GPU acceleration**: Tests run with GPU for speed (configured in playwright.config.js)
