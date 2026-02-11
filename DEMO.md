# Demo

**Repository:** cadenroberts/cadenroberts (GitHub profile README)  
**Purpose:** View rendered profile page and validate content integrity

---

## Prerequisites

### Viewing the Profile
- Web browser
- Internet connection
- No authentication required (public profile)

### Running Validation Locally
- Node.js >= 14
- npm or yarn
- Git

**Install validation tools:**
```bash
npm install -g markdown-link-check markdownlint-cli
```

---

## Demo Steps

### 1. View Rendered Profile

Navigate to:
```
https://github.com/cadenroberts
```

**Expected output:**
- Profile page loads with README.md content rendered as HTML
- Heading: "Caden Wesley Roberts"
- Sections: Summary, What I Do, Architecture, Selected Systems, Design Tradeoffs, Evaluation, Repository Standards, Repository Layout, Limitations, Contact
- Links are clickable (LinkedIn, email, project repositories)

**Validation:**
- Page loads without errors
- Content matches latest commit on `main` branch
- No broken images or malformed rendering

**Typical render time:** <30 seconds after push to `main`.

### 2. Run Local Validation Script

```bash
cd /Users/croberts/resume/repos/cadenroberts
./scripts/demo.sh
```

**Expected output:**
```
Running link validation...
✓ README.md: All links valid

Running Markdown lint...
✓ README.md: No errors

DEMO_OK
```

**Exit code:** 0 (success)

**Failure scenarios:**

**Broken links:**
```
Running link validation...
✗ README.md: 1 dead link found
  - https://github.com/cadenroberts/NonExistentRepo (404)

FAIL: Link validation failed
```
**Resolution:** Fix or remove broken link in README.md, rerun.

**Markdown linting errors:**
```
Running Markdown lint...
✗ README.md:15 MD013/line-length Line length exceeded
✗ README.md:23 MD009/no-trailing-spaces Trailing spaces

FAIL: Markdown linting failed
```
**Resolution:** Fix formatting issues, rerun.

**Missing tools:**
```
Error: markdown-link-check not found
Install: npm install -g markdown-link-check
```
**Resolution:** Install missing npm packages, rerun.

### 3. Verify CI Workflow

Push any change to `main`:
```bash
echo "# Test" >> test.md
./sync.sh "Clarifying: test CI"
```

Navigate to:
```
https://github.com/cadenroberts/cadenroberts/actions
```

**Expected output:**
- Workflow run appears (within 10 seconds)
- Status: ✓ (green checkmark) after ~30-60 seconds
- Jobs: "validate" passes

**Inspection:**
Click on workflow run → "validate" job → expand steps:
- "Checkout code" ✓
- "Setup Node.js" ✓
- "Install dependencies" ✓
- "Run validation script" ✓

**Failure:**
If red X appears, click to view logs. Errors same as local validation failures.

**Cleanup test:**
```bash
rm test.md
./sync.sh "Cleaning: remove test file"
```

---

## Troubleshooting

### Profile not updating after push
**Symptom:** GitHub profile shows old content after successful push.

**Causes:**
1. CDN cache (typically clears within 30 seconds)
2. Browser cache (hard refresh: Cmd+Shift+R on macOS, Ctrl+Shift+R on Windows/Linux)
3. Wrong branch (verify push went to `main`)

**Resolution:**
```bash
git branch --show-current  # Should output: main
git log -1                 # Verify latest commit
```
Wait 60 seconds, hard refresh browser.

### Link checker fails on valid links
**Symptom:** `markdown-link-check` reports 404 on working URLs.

**Causes:**
1. Rate limiting (LinkedIn, GitHub API)
2. Requires authentication (internal/private repos)
3. Temporary service outage

**Resolution:**
- Manual verification: open URL in browser
- Whitelist known-good URLs in `.markdown-link-check.json`
- Retry after delay

### Markdown linting strict warnings
**Symptom:** Linter flags stylistic choices (line length, heading emphasis).

**Causes:**
Default `markdownlint` rules are opinionated.

**Resolution:**
Create `.markdownlint.json` to customize rules:
```json
{
  "MD013": false,  // Allow long lines
  "MD033": false   // Allow inline HTML (if needed)
}
```

### CI workflow not triggering
**Symptom:** Push succeeds but no workflow appears in Actions tab.

**Causes:**
1. Actions disabled on repository (check Settings → Actions)
2. Workflow file syntax error (YAML validation)
3. Branch protection rules blocking

**Resolution:**
```bash
# Validate workflow syntax locally
cat .github/workflows/ci.yml | grep -E "^\s{2,}- "  # Check indentation
```
Enable Actions: Settings → Actions → Allow all actions.

---

## Smoke vs. Full Demo

**This repository supports full demo (DEMO_OK).**

Validation runs entirely locally:
- No external dependencies beyond public URLs
- No secrets or credentials required
- No build step or compilation
- Validation tools installable via npm

**Smoke test** (minimal validation without tool installation):
```bash
# Check README exists
test -f README.md && echo "README exists" || echo "FAIL: README missing"

# Check git status
git status | grep "nothing to commit" && echo "SMOKE_OK" || echo "Uncommitted changes"
```

---

## Expected Final State

After running `./scripts/demo.sh` successfully:
- Exit code: 0
- Output ends with: `DEMO_OK`
- All links valid (HTTP 200)
- No Markdown linting errors
- Content matches committed version

Profile viewable at `https://github.com/cadenroberts` with latest content rendered.
