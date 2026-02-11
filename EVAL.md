# Evaluation

**Repository type:** Static content (GitHub profile README)  
**Validation focus:** Link integrity, Markdown formatting, content accuracy

---

## Correctness Criteria

### 1. Link Validity
All external URLs must return HTTP 200 (or 30x redirect to 200).

**Links under test:**
- https://linkedin.com/in/cwro
- https://github.com/cadenroberts/CliniRepGen
- https://github.com/cadenroberts/ClinImCL
- https://github.com/cadenroberts/OllamaBot

**Pass condition:** All links reachable, no 404s.

### 2. Markdown Formatting
Markdown must conform to GitHub Flavored Markdown spec with no linter errors.

**Rules enforced:**
- Consistent heading hierarchy (no skipped levels)
- No trailing whitespace
- Consistent list marker style
- No bare URLs (all links formatted as `[text](url)`)
- Fenced code blocks use triple backticks with language tags

**Pass condition:** `markdownlint-cli` exits 0.

### 3. Content Accuracy
Technical claims must be verifiable or clearly marked as proprietary.

**Verifiable claims:**
- CliniRepGen: CONSORT/ICH-E3 compliance (verifiable via repo + EVAL.md)
- ClinImCL: 3,000+ scans, UMAP validation (verifiable via repo + paper)
- OllamaBot: multi-model orchestration, local LLMs (verifiable via repo + ARCHITECTURE.md)

**Proprietary claims (Paystand):**
- 50 grading agents, 88 criteria, >=90% supermajority — specific metrics, internally verifiable
- >70% automation rate for OPEX variance commentary — quantified, auditable internally

**Pass condition:** No unsubstantiated claims. All open-source projects linkable. Proprietary projects described with specific, quantifiable metrics.

### 4. Spelling and Grammar
No typos, misspellings, or grammatical errors in public-facing content.

**Pass condition:** Manual review or automated spell checker with technical dictionary (accepts domain-specific terms: CONSORT, ICH-E3, OPEX, UMAP, etc.).

---

## Reproduction Instructions

### Local Validation

```bash
cd /Users/croberts/resume/repos/cadenroberts
./scripts/demo.sh
```

**Expected output:**
```
Running link validation...
✓ All links valid

Running Markdown lint...
✓ No linting errors

DEMO_OK
```

**Failure modes:**
- Exit code 1 + "FAIL: broken links" → fix URLs in README.md
- Exit code 1 + "FAIL: linting errors" → fix Markdown formatting
- Exit code 1 + missing tools → install via `npm install -g markdown-link-check markdownlint-cli`

### CI Validation

Push to `main` triggers `.github/workflows/ci.yml`.

**Pass condition:** Workflow status badge green (all checks pass).

**Inspection:**
```bash
git push origin main
# Wait 30-60s
# Check: https://github.com/cadenroberts/cadenroberts/actions
```

---

## Performance Expectations

Not applicable. Static content has no runtime performance characteristics.

**Rendering speed:** Dependent on GitHub's infrastructure (typically <200ms page load).

---

## Validation Frequency

- **On every commit:** CI runs link check + Markdown lint
- **Before major updates:** Manual review for content accuracy and tone
- **Quarterly:** Review flagship project list for currency (new systems, deprecated projects)

---

## Pass/Fail Criteria Summary

| Criterion           | Tool                       | Pass Condition              |
|---------------------|----------------------------|-----------------------------|
| Link validity       | `markdown-link-check`      | Exit 0, no 404s             |
| Markdown formatting | `markdownlint-cli`         | Exit 0, no linting errors   |
| Content accuracy    | Manual review              | Claims verifiable/specific  |
| Spelling/grammar    | Manual review or spell check | No typos                  |

**Overall pass:** All criteria met. `scripts/demo.sh` exits 0 with `DEMO_OK`.

---

## Known Limitations

1. **Link checking rate limits:** External services (LinkedIn, GitHub) may throttle repeated checks. CI may produce false positives under heavy load.
2. **No automated content accuracy check:** Claims about proprietary systems cannot be automatically verified. Relies on manual review.
3. **Rendering validation:** GitHub's Markdown renderer is authoritative. Local preview may differ slightly. Final validation requires inspecting live profile page.

**Mitigation:**
- Rate limits: Add retry logic or whitelist known-good URLs
- Content accuracy: Peer review before major releases
- Rendering: Preview via GitHub's API or render to HTML locally with GFM-compatible tool
