# Strict TDD — the discipline of `TDDCraftsman`

> Stack-agnostic. The contract lives in a GitLab child Issue.
> The code lives in the work branch. The proof lives in a runnable
> test that asked for it. This file is the discipline; the
> project's exact test command, code paths, and layout are declared
> by the adopting repository — see `docs/verification.md` and
> `docs/mutation-testing.md` for the gates that close the loop.

---

## 1. The contract: GitLab child Issue is the source of truth

Before any line is written, the atomic GitLab work-item Issue
holds all of these and **only** these are
binding:

| Field            | Source in the Issue                                |
|------------------|----------------------------------------------------|
| Human Spec       | Issue body (the prose specification)               |
| Hard Spec        | Approved revision `HS-NNN`                         |
| Gherkin          | Approved revision `GH-NNN`                         |
| Work type        | Issue label or explicit field: feature / bugfix / refactor / chore |
| Feature root     | Issue field that scopes memory and edits           |

These fields are owned upstream and **must not be edited** by
`TDDCraftsman`. A change of any of them is a contract
amendment and goes back through the spec → Gherkin approval
loop, never a code edit.

Local implementation memory — the durable artifacts that
travel with the branch — lives under:

```
<feature-root>/.ai/work-items/123-slug/
├── progress.md      # one line per cycle: what, command, observed result
├── decisions.md     # non-obvious choices and why they were taken
└── runs/R001.md     # the active run: full command transcripts and red reasons
```

`progress.md` is the running index; `decisions.md` captures
reasons; `runs/R001.md` is the working scratchpad for the
**current** run. A new run file is created for each round of
work; old runs are appended to the index in `progress.md` and
left on disk. Memory is finalized **before** the candidate HEAD
is presented to Judge and mutation gates — Judge and mutation
do not alter HEAD.

---

## 2. The Three Laws (feature and bugfix)

1. You do not write production code except to make a failing
   test pass.
2. You do not write more of a test than is necessary to fail —
   and failing to compile, to import, or to assert on an
   observable artifact **counts** as failing.
3. You do not write more production code than necessary to pass
   the failing test.

The cycle, in small and repeated:

```
   RED            GREEN                REFACTOR
   write ONE  →   minimum code    →   on the green bar:
   failing         that makes it      names, duplication,
   test            green              short functions
```

The arrow only moves to the right when the previous step is
satisfied with **executable evidence**.

---

## 3. Work-type disciplines

The work type determines the applicable discipline. Feature and bugfix
use the Three Laws. Refactor preserves characterized behavior while green.
Chore uses approved task-specific verification.

### 3.1 Feature work — strict one-test-at-a-time

Walk the approved Gherkin `GH-NNN` scenarios in order. One
`@sNNN` scenario maps to one or more Red-Green-Refactor cycles.
A test that passes on the first run proves nothing: tighten
the assertion, suspect the setup, or stop.

Production behavior **must not precede its failing test**.
Each green commit is preceded by a recorded red.

### 3.2 Bugfix — failing regression first

Start by writing a test that reproduces the bug as observable
behavior. The test fails because the bug exists; the fix is the
minimum change that turns it green. Re-run the full project
test command before and after the fix. Do not patch by code
inspection alone: the regression test is the contract.

### 3.3 Refactor — characterization tests and observable invariants

Refactors use **characterization tests** that capture current
behavior and **Gherkin scenarios** that state the invariant
the code must keep. The mark of an honest refactor is that
**no test was authored red and no scenario was fabricated**.
A passing characterization test must never be relabeled as
"red" to satisfy Law 1 — Law 1 does not run during refactor;
the safety net ran first.

Workflow:

1. Confirm the existing suite is fully green on the candidate
   HEAD.
2. Add characterization tests where current behavior is
   unobserved. Keep them passing.
3. Add or extend a Gherkin scenario that names an observable
   invariant (no behavior change here; this is the spec of
   *what stays the same*).
4. Refactor under the green bar. After every structural
   change, re-run the project test command. If anything
   turns red, the refactor changed behavior: revert that
   step and reconsider.

### 3.4 Chore — task-specific verification, explicit N/A

Chores (renames, dependency bumps, build wiring, formatting,
CI tweaks) are not behavior changes. They use whatever
verification the chore demands — `git diff` review, a smoke
run, a build, a linter. The approved Hard Spec may mark TDD
or mutation as **N/A** for a chore, and **only** with that
explicit justification in `HS-NNN`. No N/A by default.

---

## 4. Recording evidence in the active run

Every cycle leaves a paper trail in
`<feature-root>/.ai/work-items/123-slug/runs/R001.md`:

```
## @s2 — multi-item accumulator returns the exact total
- command: <the project's declared test command, with this scenario>
- RED : observed: <real failure, not paraphrased>
- code: <file:line of minimum change>
- GREEN : observed: <all tests pass, real output>
```

Required in every entry:

- The **real command**, not a paraphrase — the Judge and
  mutation gates cite it.
- The **real red failure reason**, even if truncated, copied
  from the test runner's output. A test that fails for the
  wrong reason is not evidence.

`progress.md` records one timeline entry per cycle indexing into
`runs/R001.md` so a reviewer can read top-down. `decisions.md`
records why a particular minimum code was chosen when several
paths were possible.

---

## 5. Green commits only

No commit captures a deliberately red state. The sequence is
always: red verified, green reached, then commit. If the work
must be split across commits because review is requested mid-
flow, every commit still leaves the candidate HEAD
**green** — never with a known failing test left in place.

The branch is the typed `feature/123-slug`, `bugfix/123-slug`,
`chore/123-slug`, or `refactor/123-slug` branch created from
the integration branch. The candidate HEAD for quality gates
is the **latest green commit** on that branch.

---

## 6. The final scope-limited refactor

After every applicable scenario is green and the
`@sNNN -> test` map is complete, `TDDCraftsman` performs a
final scope-limited refactor while the suite remains green:

1. **Explicitly load** the `clean-code` skill shipped with this harness.
2. Refactor only within files touched by this work item. Anything outside is out of scope and
   goes through a separate issue.
3. After every structural change, re-run the declared test
   command end-to-end. Refactor that turns red is not
   refactor.

This step exists because, while you are climbing the red-green
ladder, "good enough to be green" is the right bar; once all
scenarios are green, "as clean as the project's standards
demand" becomes the bar. Do not skip it.

---

## 7. Preparing the candidate HEAD for review

Before invoking Judge and mutation gates:

1. `<feature-root>/.ai/work-items/123-slug/progress.md` is
   finalized and traces every `@sNNN` to at least one test.
2. `decisions.md` records non-obvious choices.
3. The active run captures real commands and observed results, then closes
   before the candidate commit. A later implementation change creates the
   next run rather than rewriting a closed one.
4. The candidate HEAD is the latest green commit on the typed work
   branch, with code, tests, and memory included.
5. The Issue contract fields (Human Spec, `HS-NNN`, `GH-NNN`,
   work type, feature root) are unchanged by this branch.

The Judge and mutation reports become durable Issue notes only after a human
publishes the exact agent-drafted payload and a later read verifies it. They
remain tied to the exact commit SHA, not local files, so reporting does not
alter HEAD. Any commit after publication invalidates **both** Judge and
mutation evidence, and they must run again.

---

## 8. Smells the Judge looks for

- Production code that **no red test** demanded (violates Law 1).
- Tests written "for the future" for scenarios that are not yet
  up.
- Refactors done while red.
- Long functions, opaque names, and magic numbers that
  survived the final refactor.
- Scenario coverage gaps: an `@sNNN` in `GH-NNN` with no
  concrete test.
- TDD or mutation marked N/A on a feature or bugfix — those
  work types never opt out.
