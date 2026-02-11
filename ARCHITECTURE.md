# Architecture

**Repository type:** GitHub profile README  
**Pattern:** Special `username/username` repository (cadenroberts/cadenroberts)  
**Rendering:** GitHub automatically displays README.md on https://github.com/cadenroberts

---

## System Overview

```
┌──────────────────────────────────────────────────────────────┐
│                        GitHub Profile                        │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│   Author writes Markdown    Git commit/push               │
│           ↓                       ↓                          │
│   README.md (main branch)  →  GitHub Renderer              │
│                                   ↓                          │
│                        Profile page display                  │
│                   (https://github.com/cadenroberts)          │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

## Components

### Content Layer
**File:** `README.md`  
**Format:** GitHub Flavored Markdown (GFM)  
**Purpose:** Static content rendered as profile landing page

**Structure:**
- Header: Name, role
- Summary: 1-2 line positioning statement
- Core competencies: Bullet list
- Project showcase: 4-5 flagship systems with links
- Standards: Documentation and engineering discipline
- Contact: LinkedIn, email

### Rendering Engine
**Provider:** GitHub  
**Specification:** GitHub Flavored Markdown  
**Execution:** Server-side render on page load  
**Cache:** GitHub CDN

### Auxiliary Files
- `ARCHITECTURE.md` — this file
- `DESIGN_DECISIONS.md` — content strategy ADRs
- `EVAL.md` — quality validation criteria
- `DEMO.md` — viewing instructions
- `REPO_AUDIT.md` — technical audit
- `scripts/demo.sh` — automated validation (link check, Markdown lint)
- `.github/workflows/ci.yml` — CI validation on push

## Execution Flow

1. Author edits `README.md` locally
2. Commit via `./sync.sh "message"`
3. Push to `main` branch on `github.com/cadenroberts/cadenroberts`
4. GitHub detects update to special profile repository
5. Markdown rendered to HTML via GFM parser
6. HTML cached and served on profile page
7. Visitor navigates to `https://github.com/cadenroberts`
8. Cached HTML displayed

**Propagation delay:** Typically <30 seconds from push to visible update.

## Contracts

### Input Contract
- Valid GitHub Flavored Markdown syntax
- UTF-8 encoding
- No executable code (HTML/JS stripped by GitHub)
- Links must be absolute URLs or relative to repo root

### Output Contract
- Rendered HTML on profile page
- Links clickable (external open in new tab)
- Code blocks syntax-highlighted
- Heading hierarchy preserved

### Failure Modes
1. **Invalid Markdown syntax:** GitHub renders malformed content literally or skips sections
2. **Broken links:** No automatic validation; links may 404
3. **Stale content:** No expiration; author must manually update
4. **Repository misconfiguration:** If repo name != username, profile rendering disabled

## Observability

**Visibility:** Public (intentional)  
**Monitoring:** None (static content)  
**Audit trail:** Git history provides full provenance  
**Validation:** CI runs link checker + Markdown linter on push

## Dependencies

**Runtime:** None (GitHub's rendering infrastructure)  
**Development:** None (plain text editing)  
**CI:** `markdown-link-check`, `markdownlint-cli` (installed via npm in CI)

## Security

**Threat model:** Public content repository, no secrets or dynamic execution.

**Mitigations:**
- `.gitignore` excludes `.env`, `__pycache__`, `.venv`, `node_modules`, `.cursor`
- No credentials, API keys, or PII in content
- GitHub strips `<script>` tags and inline JS from rendered Markdown
- All content manually reviewed before commit

**Attack surface:** Minimal. Only risk is typosquatting on external links (mitigated by HTTPS + manual review).

## Scalability

Not applicable. Single static file, no dynamic load.

## Disaster Recovery

**Backup:** Git history on GitHub (full versioning)  
**Recovery:** Roll back via `git revert` or `git reset`  
**RTO:** <5 minutes (edit + push)  
**RPO:** Last commit (zero data loss)
