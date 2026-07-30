# Work-Item Lifecycle

This document is the canonical lifecycle. The atomic child work-item Issue is the contract and lifecycle source. Repository files support it but never replace its current state, approved revisions, labels, or evidence comments.

## Invariants

- A request may have an optional parent Issue labeled `harness:request`. It is only a container for decomposition: it never receives a branch, code, or MR.
- Every implementation uses one atomic child Issue labeled `harness:work-item`, exactly one documented type label, and exactly one documented state label.
- One work item has at most one active branch and one active MR. Do not combine work items. A reopened unmet contract may create a later delivery run as documented in `docs/issues.md`.
- The lead may inspect state labels but may not mutate them or create,
  imitate, or paraphrase human approval comments.
- Required approvals are explicit comments by an authorized human. Reactions, labels, reviews, inferred consent, and AI-authored text do not count.
- Every GitLab mutation is performed by a human. Agents use read-only GitLab
  tools and the `HUMAN ACTION REQUIRED` protocol in `CONSTRAINTS.md`.
- Stop as blocked rather than inventing policy if `dev`, required labels, authorized approvers, the project test policy, the mutation command, eligible mutation paths, or the mutation threshold is missing.

## Artifacts

The Issue contains or links the human-owned Human Spec, revisioned AI artifacts, approval comments, and exact-SHA gate evidence:

- **Human Spec**: owned and changed only by humans.
- **Hard Spec `HS-NNN`**: AI-produced, traceable to the Human Spec.
- **Gherkin `GH-NNN`**: AI-produced from the approved Hard Spec.
- **Gate evidence comments**: Judge and mutation results naming the exact 40-character candidate SHA.

After both approvals and branch creation, create local memory at the approved feature root:

```text
<feature-root>/.ai/work-items/123-slug/
├── progress.md
├── decisions.md
└── runs/
    └── R001.md
```

Use subsequent `RNNN.md` files for later runs. Local memory records execution context and decisions; it is not an approval source and cannot override the Issue.

## Lifecycle

### 1. Intake and decomposition

1. Optionally create or use a parent request Issue.
2. A human selects the applicable template from
   `https://gitlab.telcryp/telcryp/productos/plantillas`. Feature and bugfix
   work use the local mirrors `Historia de usuario` and `QA - Bug`; their
   only local addition is the `Gherkin` section.
3. If an Issue or label change is needed, provide the exact populated
   template and label set in a `HUMAN ACTION REQUIRED` handoff. Do not add
   template sections. Continue only after a human performs it and a read
   confirms one atomic child work-item Issue with the required work-item,
   type, and state labels.
4. Confirm scope is independently specifiable, implementable, verifiable, and mergeable.
5. Record dependencies as Issue links; do not share a branch or MR with another child.

### 2. Human Spec and Hard Spec

1. An authorized human supplies and owns the complete populated Issue
   description as the Human Spec.
2. Delegate analysis to `SpecPartner`, using read-only explorers only when repository discovery is needed.
3. Draft a revisioned Hard Spec comment as `HS-NNN`. It must record the
   Human Spec digest and define boundaries, acceptance behavior, constraints,
   risks, dependencies, work type, feature root, and any proposed N/A gates.
4. Request human publication of the exact draft and the required state-label
   transition. Stop, then verify the published note and labels through a
   fresh read.
5. Stop until an authorized human posts a separate exact
   `APPROVED HARD SPEC HS-NNN` comment for the current revision.
6. If the Human Spec or Hard Spec changes, draft a new Hard Spec revision and
   repeat the human publication and approval gates.

### 3. Gherkin

1. Delegate to `GherkinAuthor` to derive revisioned Gherkin `GH-NNN` from the approved Hard Spec.
2. Draft the immutable `GH-NNN` note with its source `HS-NNN`, Human Spec
   digest, and traceability to acceptance behavior.
3. Request human publication of the exact draft and the required state-label
   transition. Stop, then verify both through a fresh read.
4. Stop until an authorized human posts a separate exact
   `APPROVED GHERKIN GH-NNN` comment for the current revision.
5. Any scenario or governing spec change requires a new revision, human
   publication, and matching approval.

### 4. Branch

Only after both approvals, create exactly one branch from the current `dev` HEAD. Confirm `dev` exists and is current; otherwise stop blocked.

Allowed names:

```text
feature/123-slug
bugfix/123-slug
chore/123-slug
refactor/123-slug
```

The numeric segment is the child Issue number. The slug is lowercase alphanumeric words separated by single hyphens. The branch type must match the Issue type label.

After creating the local branch, create and commit the local-memory
structure and start `R001`. Request that a human move the Issue to
`state:in-progress`; stop and verify the label before implementation.

### 5. Type-aware implementation and verification

Delegate all production-code and test changes to `TDDCraftsman`. `Leader` never edits production code or tests.

- **feature** and **bugfix**: strict red-green-refactor, one behavior increment at a time. Preserve genuine failing-test evidence before the minimum implementation.
- **refactor**: establish or confirm characterization tests, then change structure while behavior remains green. Never manufacture fake red evidence.
- **chore**: run applicable configured checks. A test, Gherkin, or mutation gate may be N/A only when the approved Hard Spec explicitly authorizes that N/A.

Use the repository's language, framework, and configured tooling. Run the
project-defined test, lint, type, build, security, or other verification
policy applicable to the changed area. Record commands and outcomes in local
memory. Any required GitLab evidence is handed to a human for publication
without exposing secrets.

After behavior is complete and green, perform a final clean-code refactor and rerun all applicable verification. Remove duplication, clarify names and boundaries, and avoid unrelated changes.

### 6. Immutable candidate gates

The candidate is the exact committed `HEAD` SHA. A dirty worktree is not a candidate.

1. Run `Judge` in **PRE_MUTATION** mode on candidate `HEAD`.
2. Give the complete Judge verdict to a human for publication as an Issue
   note naming the exact SHA and `PRE_MUTATION`; stop and verify its URL and
   content through a fresh read.
3. If approved, run the project-configured mutation command through
   `MutationTester` and enforce the project-configured threshold.
4. Give the complete mutation evidence to a human for publication as an
   Issue note naming the exact SHA, command, score, threshold, and result;
   stop and verify it.
5. Without changing `HEAD`, run `Judge` in **FINAL** mode on that same exact
   SHA.
6. Give the complete FINAL verdict to a human for publication as an Issue
   note naming the exact SHA and `FINAL`; stop and verify it.

Two Judge passes are mandatory. Judge and mutation evidence lives in Issue comments so recording it does not mutate the candidate. Any candidate `HEAD` change makes all gate evidence stale and returns the work item to PRE_MUTATION; recreate the full evidence chain for the new SHA.

### 7. Merge request and merge

1. Only after PRE_MUTATION, mutation, and FINAL pass on one unchanged exact
   SHA, give a human the exact push command and completed MR body.
2. The human pushes the branch and creates the MR; agents never push or
   create the MR.
3. The MR target is `dev` only. `main` is never valid, with no release
   exception.
4. The MR body uses the template and includes the child Issue, type, approved
   HS/GH revisions, feature root, verification and refactor evidence, all
   three evidence-note references, and exact SHA.
5. Re-read GitLab and confirm the MR source SHA exactly matches every gate
   note before accepting `state:mr-ready`.
6. Keep the work-item Issue open until the MR is merged into `dev`; then ask
   a human to close it and apply `state:done`, and verify both.
7. Ask a human to close a parent request only when its own human-defined
   completion criteria and all required children are complete. It still
   receives no branch, code, or MR.

## Invalidations and blockers

Return to the earliest affected lifecycle stage when scope, behavior, or
approvals change. Never reuse stale approvals or evidence across revisions or
SHAs. Record blockers in local memory, request human publication and the
documented blocked state label, then verify them rather than bypassing a
missing prerequisite.

## Repository enforcement

The GitLab MR pipeline checks the `dev` target, branch-name format, and
required MR-body references. Configure protected-branch and merge settings
for `dev` to reject direct pushes and require a successful
`enforce-dev-mr` job.
