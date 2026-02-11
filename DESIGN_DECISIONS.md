# Design Decisions

All decisions grounded in current repository state (commit 560988dd08bf51d63dd4f8fa27d864bc3d71936f and subsequent).

---

## ADR-001: Profile Repository Pattern

**Context:**  
GitHub renders README.md from `username/username` repositories on profile pages. Alternative: host static site externally, link from profile.

**Decision:**  
Use GitHub's native profile repository feature (`cadenroberts/cadenroberts`).

**Consequences:**
- **Pro:** Zero hosting cost, automatic HTTPS, immediate updates on push, high availability via GitHub CDN
- **Pro:** Single source of truth (no sync between external site and GitHub)
- **Con:** Limited to GitHub Flavored Markdown (no custom HTML/JS)
- **Con:** Layout constrained by GitHub's renderer (no custom CSS)
- **Con:** Content publicly accessible (acceptable for landing page)

---

## ADR-002: Technical Framing Over Marketing Language

**Context:**  
Profile READMEs often use marketing language, emojis, competitive comparisons, and badge walls. Alternative: adopt recruiter-friendly tone with buzzwords.

**Decision:**  
Use technical, neutral language. No emojis, no badges, no competitive claims.

**Consequences:**
- **Pro:** Appeals to technical hiring managers and engineers (primary audience)
- **Pro:** Ages well (no stale badges, outdated framework wars)
- **Pro:** Signals rigor and discipline
- **Con:** May not catch attention of non-technical recruiters
- **Con:** Less visually distinctive than emoji-heavy profiles

---

## ADR-003: Project Selection Criteria

**Context:**  
Portfolio includes 10+ repositories. Not all merit profile-level visibility. Alternative: list all projects chronologically.

**Decision:**  
Showcase 4-5 flagship systems. Criteria:
1. Production use or research publication
2. Demonstrates core competency (LLM evaluation, distributed ML, orchestration)
3. Publicly linkable or describable without NDA breach
4. Non-trivial complexity (no toy examples)

**Consequences:**
- **Pro:** High signal-to-noise ratio
- **Pro:** Each project supports positioning statement
- **Con:** Excludes smaller contributions (acceptable tradeoff)
- **Con:** Requires periodic review to update flagship list

**Current selection:**
- CliniRepGen (regulatory, multi-stage pipelines)
- Paystand automation (production scale, consensus evaluation)
- ClinImCL (distributed GPU, self-supervised learning)
- OllamaBot (agent orchestration, local inference)

---

## ADR-004: Structured Documentation Standards

**Context:**  
Many repositories lack consistent documentation. Alternative: minimal READMEs with usage instructions only.

**Decision:**  
Enforce documentation standard across flagship repositories:
- `ARCHITECTURE.md` — component diagrams, execution flow
- `DESIGN_DECISIONS.md` — ADR-style rationale
- `EVAL.md` — validation criteria and commands
- `DEMO.md` — reproducible demo instructions
- CI for validation

**Consequences:**
- **Pro:** Demonstrates engineering discipline and reproducibility focus
- **Pro:** Reduces onboarding friction for collaborators
- **Pro:** Signals attention to operational rigor (appeals to infrastructure roles)
- **Con:** Higher maintenance burden (documentation must stay current)
- **Con:** Older repositories require backfill

**Implementation:**  
Profile README documents standard; each flagship repository implements it.

---

## ADR-005: Link Strategy

**Context:**  
Some projects are proprietary (Paystand). Alternative: omit proprietary work entirely.

**Decision:**  
Include proprietary work with description but no repository link. Link open-source projects directly.

**Consequences:**
- **Pro:** Demonstrates production experience and scale
- **Pro:** Showcases work under real-world constraints (compliance, cost, uptime)
- **Con:** Unverifiable claims (mitigated by specificity: "50 agents, 88 criteria, >=90% supermajority")
- **Con:** Cannot provide code samples (acceptable for proprietary systems)

**Current state:**
- CliniRepGen: linked (open source)
- Paystand: described, not linked (proprietary)
- ClinImCL: linked (research)
- OllamaBot: linked (open source)

---

## ADR-006: Validation and Quality Assurance

**Context:**  
Profile README is public-facing. Typos, broken links, and formatting errors damage credibility. Alternative: manual review only.

**Decision:**  
Implement automated validation in CI:
- Link checker (`markdown-link-check`)
- Markdown linter (`markdownlint-cli`)
- Runs on every push to `main`

**Consequences:**
- **Pro:** Catches broken links before they go live
- **Pro:** Enforces consistent Markdown formatting
- **Pro:** Reduces manual QA burden
- **Con:** CI setup overhead (acceptable one-time cost)
- **Con:** False positives on link checker (e.g., rate limits)

**Implementation:**  
`.github/workflows/ci.yml` runs validation, `scripts/demo.sh` provides local reproduction.

---

## ADR-007: Contact Information Placement

**Context:**  
Contact info can be at top (high visibility) or bottom (standard resume pattern). Alternative: omit contact info entirely (rely on GitHub profile sidebar).

**Decision:**  
Place contact info at bottom, below content.

**Consequences:**
- **Pro:** Follows standard resume/CV convention (familiar pattern)
- **Pro:** Prioritizes technical content (first impression = work, not contact details)
- **Con:** Requires scrolling to reach contact info (acceptable; interested parties will scroll)

**Current state:**  
LinkedIn and email links at bottom, separated by horizontal rule.

---

## ADR-008: Versioning and Change Management

**Context:**  
Profile content evolves (new projects, role changes, skill development). Alternative: no change tracking beyond git history.

**Decision:**  
Use `sync.sh` for all commits. Categorize commits:
- "Cleaning: ..." — deletions only
- "Clarifying: ..." — additions only
- "Refactoring: ..." — mixed changes

**Consequences:**
- **Pro:** Git history provides clear audit trail
- **Pro:** Commit discipline signals rigor
- **Con:** Slightly more overhead than `git commit -am "update"`

**Implementation:**  
`sync.sh` enforces commit-and-push atomicity. Commit message convention documented here.
