# Constraints

The keywords **MUST**, **MUST NOT**, and **SHOULD** in this document
follow RFC 2119.

## Issue is the contract

- The GitLab Issue MUST be the contract and lifecycle source.
- Every change MUST originate from one atomic work-item Issue labeled
  `harness:work-item`.
- A parent request Issue labeled `harness:request` MUST NOT receive
  code, a branch, or an MR. It MAY reference one or many child Issues.

## Issue content

- A work-item Issue MUST contain an immutable Human Spec in its complete
  description.
- The Issue description MUST use the applicable canonical template from
  `https://gitlab.telcryp/telcryp/productos/plantillas`.
- The mirrored `Historia de usuario` and `QA - Bug` templates MUST differ
  from their source only by the added `Gherkin` section.
- AI agents MUST NOT add, remove, or rename template sections.
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
- AI GitLab identities MUST NOT be authorized approvers. If AI and human
  actions share an identity, the repository MUST require an additional
  verifiable manual attestation.
- AI MUST NOT author approval comments.
- Hard Spec approval MUST precede Gherkin approval.
- Gherkin approval MUST precede branch creation.

## GitLab access boundary

- AI agents MAY inspect GitLab Issues, notes, labels, branches, pipelines,
  approvals, and merge requests through read-only tools.
- AI agents MUST NOT create, update, or delete any GitLab resource. This
  includes notes, labels, Issues, branches, repository files, pipelines,
  approvals, and merge requests.
- A remote `git push` is a GitLab write and MUST be performed by a human.
- When a GitLab write is required, the agent MUST emit a
  `HUMAN ACTION REQUIRED` handoff containing the project, target, exact
  action, complete payload, expected postcondition, and verification read.
  It MUST then stop.
- A later invocation MUST re-read GitLab and verify the postcondition before
  advancing. Requesting an action is not evidence that it happened.
- Human publication of an AI-drafted Hard Spec, Gherkin revision, or gate
  report does not make it a human approval. Approvals remain separate exact
  comments from an authorized human.
- This boundary applies to remote GitLab mutations. Role-specific local file
  and Git permissions remain as documented by each agent.

## Branch and MR

- Branches MUST be cut from `dev`.
- Branch names MUST match exactly one of:
  - `feature/<issue-number>-<slug>`
  - `bugfix/<issue-number>-<slug>`
  - `chore/<issue-number>-<slug>`
  - `refactor/<issue-number>-<slug>`
- The MR base MUST be `dev`.
- The MR base MUST NOT be `main`.
- After an MR merges into `dev`, the orchestrator MUST request human closure
  of the work-item Issue and application of `state:done`, then verify both
  through a fresh read.

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

- Harness documentation and agent contracts MUST be in English.
- Issue descriptions MUST preserve the language and headings of their
  selected Telcryp template. Other work-item artifacts MUST use the
  adopting project's documented language.
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
