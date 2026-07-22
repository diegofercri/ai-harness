# Work-Item Memory

Memory is versioned next to the code it explains. It supports handoff and
historical reasoning without becoming a second copy of the Issue contract.

## Location

After both specification approvals and branch creation, create exactly one
directory under the feature root approved by the Hard Spec:

```text
<feature-root>/.ai/work-items/123-short-slug/
  progress.md
  decisions.md
  runs/
    R001.md
```

The feature root is the smallest repository-relative directory that owns
the change. For production work it is normally a code or package root; for
a chore it may own configuration or documentation. For cross-cutting work,
the Hard Spec designates one owner and lists other touched areas. Do not
duplicate memory across modules.

The memory directory MUST be committed with the implementation branch.
Agents, reviewers, and later related work must be able to discover it from
Git history.

## `progress.md`

`progress.md` contains two sections.

The current handoff is replaceable while a run is active:

```markdown
## Current handoff
- Issue: #123
- Active run: R001
- Branch: feature/123-short-slug
- Revisions: HS-001, GH-001
- Last verified commit: <current HEAD before the next commit>
- Next action: <one concrete action>
- Blockers: none | <Issue comment URL>
```

The lifecycle timeline is append-only:

```markdown
## Timeline
- 2026-07-22T10:14:00Z - R001 started for #123.
- 2026-07-22T11:02:00Z - @s001 reached green; see R001.
```

Corrections are new timeline entries. Do not rewrite historical entries.
Before quality gates, mark the handoff `candidate-ready` and close the active
run. Commit those final memory changes with the implementation. The resulting
SHA is recorded in Issue gate comments, not written back into memory, which
would create a new SHA. Gate and merge events remain in the Issue and PR.

## `decisions.md`

Record only implementation decisions not already part of the approved Hard
Spec. Entries are append-only and use stable IDs:

```markdown
## D-123-001 - Cache boundary
- Status: accepted
- Date: 2026-07-22
- Run: R001
- Context: <why a decision was needed>
- Decision: <chosen implementation approach>
- Alternatives: <discarded options>
- Rationale: <why this option fits the approved contract>
- Consequences: <tradeoffs>
- Supersedes: none
```

Do not rewrite accepted decisions. A replacement entry names the prior ID in
`Supersedes`; readers determine the active decision from the latest entry.

A decision that affects multiple work items belongs in the project's
architecture decision mechanism as well; link it from this file.

## `runs/RNNN.md`

A run is one implementation attempt against unchanged approved revisions.
It records actual execution, not intended execution:

```markdown
# R001 - Issue #123

## Contract references
- Issue: <URL>
- Hard Spec: HS-001 <comment URL>
- Gherkin: GH-001 <comment URL>

## TDD and verification
- @s001 RED: <command and observed failure>
- @s001 GREEN: <command and observed success>
- Refactor: <clean-code observations and verification>

## Outcome
- Status: candidate | abandoned | superseded
- Candidate state: ready | not produced
- Next run: none | R002
```

Close a run immediately before creating its candidate commit. Once committed
as closed, it is immutable. Record the resulting candidate SHA in remote gate
comments, never by editing the closed run.

Create the next run when:

- Judge or mutation feedback requires code or test changes,
- an interrupted attempt is intentionally superseded, or
- the Issue is reopened because its original approved contract was never
  satisfied.

A requirements change or later regression creates a new Issue rather than
a new run. See `docs/issues.md`.

## Contract Boundary

Local memory may cite Issue numbers, revision IDs, scenario tags, comment
URLs, branches, commits, tests, and code paths. It MUST NOT reproduce Human
Spec, Hard Spec, Gherkin, approval, or gate-report text. Fetch those durable
artifacts from the Issue when needed.
