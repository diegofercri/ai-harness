# Constraints

The keywords **MUST**, **MUST NOT**, and **SHOULD** in this document
follow RFC 2119.

## Issue is the contract

- The GitHub Issue MUST be the contract and lifecycle source.
- Every change MUST originate from one atomic work-item Issue labeled
  `harness:work-item`.
- A parent request Issue labeled `harness:request` MUST NOT receive
  code, a branch, or a PR. It MAY reference one or many child Issues.

## Issue content

- A work-item Issue MUST contain an immutable Human Spec in its body.
- A work-item Issue MUST contain an AI Hard Spec comment `HS-NNN`.
- A work-item Issue MUST contain an AI Gherkin comment `GH-NNN`.
- Each new revision MUST be appended as a new Issue comment and MUST
  be immutable.
- A revision MUST NOT be edited in place; revisions are superseded
  by posting a new revision.

## Human approval

- A human approval MUST be an explicit Issue comment that names the
  exact revision.
- The repository MUST declare which human accounts are authorized to
  approve revisions.
- AI GitHub identities MUST NOT be authorized approvers. If AI and human
  actions share an identity, the repository MUST require an additional
  verifiable manual attestation.
- AI MUST NOT author approval comments.
- Hard Spec approval MUST precede Gherkin approval.
- Gherkin approval MUST precede branch creation.

## Branch and PR

- Branches MUST be cut from `dev`.
- Branch names MUST match exactly one of:
  - `feature/<issue-number>-<slug>`
  - `bugfix/<issue-number>-<slug>`
  - `chore/<issue-number>-<slug>`
  - `refactor/<issue-number>-<slug>`
- The PR base MUST be `dev`.
- The PR base MUST NOT be `main`.
- After a PR merges into `dev`, the orchestrator MUST close the
  work-item Issue and apply `state:done`.

## Workflow types

- A `feature` or `bugfix` workflow MUST use strict red-green-refactor
  TDD.
- A `refactor` workflow MUST use characterization tests and MUST NOT
  fabricate a red phase.
- A `chore` workflow MAY record approved N/A gates with verification
  in `runs/RNNN.md`.

## Implementation discipline

- Type checks MUST run when required by the adopting project.
- Every applicable final refactor MUST load the `clean-code` skill.
- The Judge agent MUST run twice:
  - once after TDD, before mutation testing (`PRE_MUTATION`), and
  - once after mutation testing, on the same exact HEAD (`FINAL`).
- Any code or test change MUST invalidate prior gate results and MUST
  require a re-run of the affected gates.
- Any commit that changes candidate HEAD after `PRE_MUTATION` MUST
  invalidate the complete quality-evidence chain.

## Mutation testing

- Mutation testing MUST be the project-configured command.
- The project MUST declare mutation-eligible paths.
- This template MUST NOT define a default mutation threshold.
- The project MUST document its mutation threshold in its own
  repository, and that threshold MUST be met on the relevant code
  before the `FINAL` Judge.
- Mutation MAY be N/A only for an approved chore or behavior-preserving
  refactor with no mutation-eligible production-code change.

## Local memory

- Durable memory MUST live under
  `<feature-root>/.ai/work-items/<issue-number>-<slug>/`.
- That directory MUST contain `progress.md`, `decisions.md`, and
  `runs/RNNN.md` files.
- Local memory MUST NOT duplicate the Hard Spec or the Gherkin.
- Local memory MUST be committed with the implementation branch.
- Reopening an unmet original contract MUST create a new run file.
- Changed scope or a regression after previously working behavior MUST
  create a new work-item Issue, not a
  new revision of the current one.

## Language and portability

- All human-readable artifacts MUST be in English.
- This template MUST NOT assume a specific language, framework, test
  runner, or mutation tool.
- The project MUST document its own test and mutation commands in its
  own repository; the template references them but MUST NOT invent
  defaults.

## Documentation hygiene

- `docs/workflow.md`, `docs/tdd.md`, `docs/gherkin.md`,
  `docs/mutation-testing.md`, and `docs/verification.md` SHOULD
  reference this file for hard rules and SHOULD NOT duplicate them
  verbatim.
