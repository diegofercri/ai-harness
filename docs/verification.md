# Verification — how the loop closes

> The orchestrator never says "it works"; it proves it on a
> specific SHA. Two judge stages and one mutation pass produce
> the only evidence that opens a PR. Missing declarations in
> the adopting repository **block** the relevant gate; the
> template never invents a language, source layout, test command,
> mutation command, eligible path, or threshold.

---

## 1. The principle

For every work item, a candidate HEAD exists on an approved typed branch
such as `feature/123-short-slug`. That HEAD is the **only** thing under
review. Evidence is durable GitHub Issue comments anchored to
the exact commit SHA, not local files. Reporting does not
alter the SHA.

The agent does not say it works — it runs the declared
project commands, copies the **real** output, and posts it
on the Issue. A green suite, a passing mutation, or a Judge verdict
`APPROVED` without a SHA-anchored Issue comment is not
evidence.

---

## 2. Project declarations required before any gate runs

The adopting repository must declare these, in its governance
document (the place that lists project commands; this
template does not assume where that lives). If any is missing
when a gate is invoked, the relevant agent does **not**
invent defaults — it blocks the gate and reports the gap.

| Declaration       | Used by                          | Effect of missing          |
|-------------------|----------------------------------|----------------------------|
| Test command(s)   | `TDDCraftsman`, `Judge`          | Judge reports `BLOCKED: missing test command` |
| Mutation command  | `MutationTester`                 | Mutation step blocked      |
| Eligible paths    | `MutationTester`                 | Mutation step blocked      |
| Mutation threshold| `MutationTester`                 | Mutation step blocked      |
| Authorized approvers | Specification agents and lead | Approval gate blocks       |

The commands may be a single test command, a build-then-test
chain, or a per-package list — whatever the adopting project
runs.

---

## 3. The candidate HEAD — what it must contain

Before any quality gate runs, the candidate HEAD on the typed work branch carries:

1. **Implementation** that satisfies the work item.
2. **Tests** that drive each piece of behavior.
3. **Local implementation memory** under
   `<feature-root>/.ai/work-items/123-slug/`:
   - `progress.md` — finalized
   - `decisions.md` — non-obvious choices with reasons
   - `runs/R001.md` (and any successors) — full transcripts
     with real commands and real red failure reasons

If memory is not on the branch, the gates see a partial
picture and the gate is invalidated the moment a later commit
alters HEAD. Local memory is part of the diff.

The candidate HEAD is **green** at the moment gates start: no
deliberately red state, no failing test committed by design
(see `docs/tdd.md`).

---

## 4. The two-stage Judge

The `Judge` subagent runs **twice** on the **same unchanged
SHA**. Each stage has its own verdict and its own Issue
comment; once posted, the comment is the durable artifact.
Any code or test change after the comment invalidates the
prior verdict.

### 4.1 Stage `PRE_MUTATION`

Run after the candidate HEAD is fully green and includes
finalized local memory. Inputs `Judge` receives:

- The candidate SHA.
- The Issue contract: Human Spec, approved `HS-NNN`,
  approved `GH-NNN`, work type, feature root.
- The `progress.md`, `decisions.md`, and `runs/*.md` from
  memory.
- Declarations: test command(s), mutation policy, N/A
  justifications (if any).

The judge validates:

| Check                                  | Notes                                                                |
|----------------------------------------|----------------------------------------------------------------------|
| Contract fields                        | Human Spec, `HS-NNN`, `GH-NNN`, work type, feature root all present and unchanged on this SHA. |
| Constraints                            | Layering, dependencies, naming, and error contract of the adopting repository. |
| Scenario traceability                  | Each applicable `@sNNN` in `GH-NNN` maps to at least one concrete test. |
| Test results                           | The declared test command is run; output is captured on the Issue.  |
| Clean-code refactor                    | Evidence in `progress.md` that the final scope-limited refactor happened (see `docs/tdd.md` §6). |
| Mutation evidence                      | **Not yet required.** The judge issues `APPROVED` only if the items above hold; mutation is the next gate. |

The verdict is either `APPROVED` or `CHANGES_REQUESTED`,
posted as an Issue comment tied to the SHA. On `APPROVED`,
the orchestrator advances to mutation.

### 4.2 Stage `FINAL`

Run after mutation has PASSed on the same SHA. Inputs add
the mutation report.

The judge re-validates the items above **plus**:

| Check                                  | Notes                                                                |
|----------------------------------------|----------------------------------------------------------------------|
| `PRE_MUTATION` approval                | Issue comment with stage `PRE_MUTATION` and verdict `APPROVED` on the same SHA. |
| Mutation evidence                      | Issue comment with score, threshold, survivors, exclusions, command, and the same SHA. |
| SHA freshness                          | Candidate HEAD did not change between `PRE_MUTATION`, mutation, and `FINAL`. |

Only `FINAL` `APPROVED` permits PR creation. Any change in
between rewinds the loop: TDD → `PRE_MUTATION` → mutation →
`FINAL`.

### 4.3 Anti-patterns

- The judge **never** edits code or tests. It names a problem;
  it does not fix it.
- The judge **never** approves a `FINAL` whose SHA drifted
  from the prior `PRE_MUTATION`. Drift means the evidence is
  no longer evidence.
- The judge **never** accepts a chat-only report. The Issue
  comment on the SHA is the deliverable.

---

## 5. The mutation pass

After `PRE_MUTATION` `APPROVED`, `MutationTester` runs the
declared mutation command on the declared eligible scope at
the declared threshold. Full mechanics, including how a
survivor returns the work item to TDD, are in
`docs/mutation-testing.md`.

The mutation report is a single Issue comment carrying the
exact SHA, the exact command, the threshold, the score, and
the survivor list with handling (real / equivalent /
out-of-scope).

---

## 6. N/A policy across the gates

N/A is a per-gate declaration, not a per-feature preference:

- **TDD** is N/A only when work type is `chore` and the
  approved Hard Spec `HS-NNN` records a project-specific
  reason. It is never N/A for `feature` or `bugfix`.
- **Mutation** is N/A only for a chore or behavior-preserving refactor
  with no eligible production-code change, when `HS-NNN` approves the
  rationale and the mutation Issue comment records it.
- **Judge** is never N/A. Both stages run; one or both may
  approve, and both must on the path to PR.

A missing N/A justification is not a default N/A — it is a
missing declaration that blocks the gate.

---

## 7. Closing the loop

The five-step closing sequence, with the SHA as the only
moving reference:

```
candidate HEAD on typed branch   (green, memory finalized)
  │
  ├── Judge PRE_MUTATION          → Issue comment APPROVED on SHA
  │
  ├── Mutation pass               → Issue comment PASS|FAIL on SHA
  │       └── on FAIL or survivor → back to TDD, evidence stale
  │
  ├── Judge FINAL                 → Issue comment APPROVED on SHA
  │
  └── PR creation allowed         → PR opened from typed branch
```

If at any point the SHA changes, the loop rewinds to TDD.
The next green commit becomes the new candidate SHA, and
every gate runs again from `PRE_MUTATION`.

---

## 8. Final verification before closing

The orchestrator's last act on a work item is to confirm:

1. The candidate SHA has a `FINAL` `APPROVED` Issue comment.
2. The mutation step on the same SHA is `PASS` (or N/A with
   documented justification).
3. No commit followed the `FINAL` comment on that SHA.
4. The PR opened from the typed work branch references the SHA
   that carried the `FINAL` approval.

If any item fails, no PR is opened; the orchestrator returns
to the first unsatisfied gate and re-runs.
