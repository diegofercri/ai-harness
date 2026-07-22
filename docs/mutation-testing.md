# Mutation testing — proving the tests have teeth

> A green suite only proves that the code does not crash with
> these inputs. Mutation testing introduces a small defect into
> the code and demands that **some test fail**. A surviving
> mutant is a hole in the safety net. This file is policy; the
> project's exact mutation command, eligible paths, and
> threshold are declared by the adopting repository — and
> **missing declaration blocks the mutation gate**.

---

## 1. The problem mutation solves

A green suite says "the code does not blow up with these
inputs". It does **not** say "the tests would fail if the code
were wrong". A test without strong assertions passes on any
input and protects nothing.

Mutation testing measures this in reverse. For each mutant:

- If **at least one test fails** → the mutant is **killed**.
- If **all tests pass** → the mutant **survives**.

**Mutation score** = `killed / total`. The higher it is, the
more the tests bite.

Mutation testing is compute-bound: the suite runs once per
mutant. The cost is real; the return is whether the suite
catches real defects. That return is why this gate exists.

---

## 2. Project policy (declared by the adopting repository)

The mutation gate is only meaningful if three things are
declared **in the repository's configuration** (the canonical
place is the workflow / governance document that lists the
adopting repo's commands; this template does not assume where
that lives). If any of the three is missing, the
`MutationTester` does **not invent defaults** — it blocks
the gate and reports the gap on the Issue.

| Field             | Meaning                                                                                |
|-------------------|----------------------------------------------------------------------------------------|
| Mutation command  | The exact shell command that runs the project's mutator (with subcommand, target, args). |
| Eligible paths    | The globs or paths the mutator may touch, **scoped to the files touched by this branch**. |
| Threshold         | The minimum `killed / total` ratio required to PASS, expressed as a fraction or percent. |

For example, an adopting repository might declare:

```
mutation:
  command: "<project mutation command>"
  eligible_paths: ["<project source glob>"]
  threshold: "<required score>"
```

These declarations are **the contract**. `MutationTester`
runs the declared command against the eligible scope, applies
the declared threshold, and reports the result.

---

## 3. The `MutationTester` subagent — read-only and restoring

`MutationTester` is **locally read-only**:

- It does **not** edit implementation, tests, or memory.
- It does **not** alter the candidate HEAD.
- It **does** run the mutation command against the worktree
  on each mutant.
- It **restores** the worktree after each mutant, regardless
  of how the run ended (the project's mutator is expected to
  handle this in a `finally`-equivalent; the agent verifies
  and recovers manually if it does not).

The mutation report is published as a **durable GitHub Issue
comment** anchored to the candidate SHA, not as a local file.
The mutation step is therefore append-only with respect to
HEAD: posting a comment does not create a commit.

If `MutationTester` finds it cannot run the declared
command (tool not installed, eligible paths missing on this
branch, threshold not declared), it does **not** silently
fall back. It blocks the gate, posts an Issue comment
documenting the gap, and lets the orchestrator decide
whether the adoption is incomplete or the policy needs an
amendment.

---

## 4. Reporting format on the Issue

A mutation report — posted once per run, tied to the exact
SHA being evaluated — contains:

- The candidate SHA (full, not abbreviated) being evaluated.
- The mutation command exactly as declared.
- The eligible paths actually evaluated.
- The threshold as declared.
- The score: `killed / total` and the percentage.
- The list of survivors: file, line, the applied mutation,
  and which scenario or test would have killed it.
- Any **equivalent-mutant exclusions** with explicit
  justification. An equivalent mutant does not change
  observable behavior. Excluding one is not an excuse to skip
  the test; it is a statement about the code under mutation.
  An unjustified exclusion is treated as a surviving mutant.

The report's structure lives in this template so that
adopting repositories, the Issue timeline, and any future
auditor speak one language.

---

## 5. Survivors, scope-limited, and exclusions

Survivors fall into three buckets, and each is handled
differently:

1. **Real survivor** — the test suite is missing an
   assertion, an edge case, or a scenario that distinguishes
   the mutated behavior from the original. **Action**: return
   to TDD. Write a failing test (red), then minimum code
   (green), then refactor (clean). All earlier evidence on
   this SHA is now stale.

2. **Equivalent mutant** — the mutation does not change
   observable behavior. **Action**: document in the Issue
   comment with an explicit written justification citing the
   behavior invariant that the mutation does not violate.
   Equivalence is a property of the code under mutation; it
   is not a property of the test suite.

3. **Out-of-eligible-scope** — the mutation lives on a file
   the adopting repository did not scope to this work item.
   **Action**: it is **not** part of the score for this gate.
   The adopting repository's policy decides whether
   legacy-eligible code has its own mutation pass; that
   decision is not `MutationTester`'s.

There is **no fourth bucket**. "I'll fix it later" and
"this is too expensive" are not exclusion categories.

---

## 6. Threshold and PASS / FAIL

- **PASS**: the score meets the declared threshold after policy-defined
  exclusions, no real or unjustified survivor remains, every equivalent
  mutant is justified, and out-of-scope mutants are excluded from the
  denominator.
- **FAIL**: any condition not met. Survivors that are real
  or unjustified block PASS.

A surviving mutant that returns to TDD makes the prior
Judge evidence stale. The full loop runs again: TDD → Judge
PRE_MUTATION → mutation → Judge FINAL → PR.

---

## 7. N/A policy

Mutation may be marked **N/A** only when approved `HS-NNN` documents a
project-specific reason and no mutation-eligible production code changes.
This can apply to a chore or behavior-preserving refactor. The mutation
Issue comment cites the approved rationale. There is no N/A by default,
and never for a feature or bugfix.

---

## 8. Why this gate exists, in one line

Green says the code does not crash. Mutation asks: **would a
small defect be caught?** Until the suite answers yes for the
declared threshold, the loop is not closed.
