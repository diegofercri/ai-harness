# CHECKPOINTS

Objective generic gates a Judge (human or AI) walks before opening a
MR. A gate passes only when its durable evidence is verifiable.
The project defines the test and mutation commands and the mutation
threshold; this checklist references them but invents no defaults.

## C1 — Contract is valid

- [ ] The Issue has `harness:work-item`, exactly one `type:*` label,
      and exactly one `state:*` label.
- [ ] The Issue description uses the applicable Telcryp template and
      contains the human-owned Human Spec.
- [ ] `Historia de usuario` and `QA - Bug` differ from their central source
      only by the added `Gherkin` section.
- [ ] The Issue contains an AI Hard Spec revision `HS-NNN`.
- [ ] The Issue contains an AI Gherkin revision `GH-NNN`.
- [ ] A human has approved the Hard Spec revision in an Issue
      comment.
- [ ] A human has approved the Gherkin revision in a subsequent
      Issue comment.
- [ ] No AI author wrote either approval comment.

## C2 — Branch and MR are correct

- [ ] The branch is cut from `dev`.
- [ ] The branch name matches
      `feature|bugfix|chore|refactor/<issue-number>-<slug>`.
- [ ] No MR exists against `main`.
- [ ] A human opened the MR against `dev` only after the `FINAL` Judge, and
      the agent verified its target and source SHA through GitLab.

## C3 — Implementation discipline

- [ ] `feature` and `bugfix` work shows evidence of strict
      red-green-refactor cycles.
- [ ] `refactor` work uses characterization tests and shows no
      fabricated red phase.
- [ ] `chore` work uses task-specific verification; every N/A gate has
      an approved rationale.
- [ ] Every applicable final refactor invokes the `clean-code` skill.
- [ ] For statically typed languages, type checks pass on the same
      exact HEAD.

## C4 — Local memory is on disk

- [ ] `<feature-root>/.ai/work-items/<issue-number>-<slug>/progress.md`
      exists and is current.
- [ ] `<feature-root>/.ai/work-items/<issue-number>-<slug>/decisions.md`
      exists and is current.
- [ ] A run file
      `<feature-root>/.ai/work-items/<issue-number>-<slug>/runs/RNNN.md`
      exists and is immutable.
- [ ] Local memory does not duplicate the Hard Spec or the Gherkin.

## C5 — Tests pass on HEAD

- [ ] The project-configured test command exits 0 on the same exact
      HEAD that will be submitted in the MR.
- [ ] For typed languages, type checks also exit 0.
- [ ] Candidate HEAD has not changed since the `PRE_MUTATION` Judge.

## C6 — Judge ran twice

- [ ] The `PRE_MUTATION` Judge verdict is recorded on HEAD `H1`.
- [ ] The `FINAL` Judge verdict is recorded on the same exact HEAD
      `H1` after mutation testing.
- [ ] Any change after `PRE_MUTATION` triggers a new `PRE_MUTATION`
      run.

## C7 — Mutation testing meets threshold

- [ ] The project-configured mutation command ran on the relevant
      code.
- [ ] The project's documented mutation threshold is met.
- [ ] Surviving and excluded mutants are recorded with explicit
      handling in the SHA-bound mutation Issue note.
- [ ] No template default threshold was assumed.

## C8 — MR readiness

- [ ] C1–C7 are all green.
- [ ] The MR description links the Issue and the run file.
- [ ] After merge, the orchestrator will request human Issue closure and
      `state:done`, then verify both through GitLab.
