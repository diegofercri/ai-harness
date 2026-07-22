# Gherkin — the acceptance contract inside the Issue

> Gherkin is a **human-readable acceptance contract**, stored in the
> child Issue. It is not necessarily executed by a BDD framework; the
> repository may map it to tests by hand if a runner is undesirable.
> The full Issue schema, gate comments, and labels live in
> `docs/issues.md`.

---

## 1. Where the contract lives

Gherkin lives in an append-only `GH-NNN` comment on the work-item Issue.
It is not duplicated to local files. Each revision names the approved
`HS-NNN` from which it was derived.

The parent request Issue and the root repository never carry a
`.feature` file as a side channel; the Issue is the only source.

---

## 2. Structure

```gherkin
@issue-123
Feature: <purpose in one sentence>

  @s001
  Scenario: <observable behavior>
    Given <starting state>
    When <concrete action>
    Then <measurable result>

  @s002
  Scenario: <edge case or error>
    Given ...
    When  ...
    Then  ...
```

- The first tag `@issue-123` is the Issue number. Stable across
  revisions.
- Per-scenario tags are `@s001`, `@s002`, … zero-padded so they sort
  lexically. Stable across revisions.
- `Feature:` appears once per work-item. The parent request Issue
  never carries a `Feature:` block.

---

## 3. Hard rules

- **One `Scenario` per observable behavior**, including error paths
  (nonexistent ID, invalid flag, empty file). Every Hard Spec
  observable behavior is covered by at least one `@sNNN`.
- **Every `Then` asserts something measurable.** Forbidden: "the
  system works", "the value is correct". Allowed: "Then standard
  output is exactly `3`", "Then the exit code is `1`", "Then the
  file is byte-for-byte identical to before".
- **A single `When` per scenario.** If a scenario needs two actions,
  it is probably two scenarios.
- **No implementation details.** The scenarios describe behavior,
  not function names, classes, or internal variables.
- **Use exact expectations when the contract is exact.** Avoid vague
  qualifiers such as "approximately correct" unless tolerance is itself
  part of the approved behavior.
- **Stable tags.** `@issue-123` and `@s001..@sNNN` are the
  identifiers the implementer and the reviewer cite. Renumbering
  breaks traceability.

---

## 4. Type-aware policy

The `type:*` label on the Issue changes the Gherkin obligation.

| Type | Gherkin requirement |
| --- | --- |
| `type:feature` | Full Gherkin required. Every observable behavior and every Hard Spec edge case has a scenario. |
| `type:bugfix` | Full Gherkin required. Include a regression scenario that fails without the fix. |
| `type:chore` | Gherkin may be marked `n/a` with a clear rationale in `GH-NNN`. The Hard Spec still requires human approval. |
| `type:refactor` | Gherkin describes the **observable invariants** that must hold after the refactor (e.g. "the public API of `count()` is unchanged", "existing scenarios still pass with no edits"). Internal structure changes are not scenarios. |

---

## 5. Revisions and approval

- `GherkinAuthor` posts an immutable draft comment at `GH-NNN`. The
  state label moves to `state:gherkin-review`.
- A human posts `APPROVED GHERKIN GH-NNN` as an Issue comment (never
  the body, never a checkbox). The agent verifies the author is an
  authorized human.
- A new Gherkin comment supersedes and invalidates approval of the prior
  Gherkin revision only. Publish the next sequential `GH-NNN`.
- A changed Human Spec or new Hard Spec revision invalidates both active
  approvals; new Gherkin must identify the newly approved Hard Spec.

---

## 6. From scenarios to tests

The implementer maps each `@sNNN` to one or more concrete tests in
the project's chosen test framework. The mapping is recorded in the
active local run and reviewed against the Issue. A BDD runner is **optional**;
if the stack forbids it, the mapping is done by hand. The scenarios
are the contract either way.

Two anti-patterns to avoid:

- A test that only asserts "no exception thrown". It catches nothing.
- A test that duplicates the scenario literally. The scenario is the
  contract; the test is the executable witness, not a paraphrase.
