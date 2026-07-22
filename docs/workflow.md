# Work-Item Lifecycle

This document is the canonical lifecycle. The atomic child work-item Issue is the contract and lifecycle source. Repository files support it but never replace its current state, approved revisions, labels, or evidence comments.

## Invariants

- A request may have an optional parent Issue labeled `harness:request`. It is only a container for decomposition: it never receives a branch, code, or PR.
- Every implementation uses one atomic child Issue labeled `harness:work-item`, exactly one documented type label, and exactly one documented state label.
- One work item has at most one active branch and one active PR. Do not combine work items. A reopened unmet contract may create a later delivery run as documented in `docs/issues.md`.
- The lead may manage state labels but may not create, imitate, or paraphrase human approval comments.
- Required approvals are explicit comments by an authorized human. Reactions, labels, reviews, inferred consent, and AI-authored text do not count.
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
2. Create one atomic child work-item Issue with the required work-item, type, and state labels.
3. Confirm scope is independently specifiable, implementable, verifiable, and mergeable.
4. Record dependencies as Issue links; do not share a branch or PR with another child.

### 2. Human Spec and Hard Spec

1. An authorized human supplies and owns the Human Spec in the child Issue.
2. Delegate analysis to `SpecPartner`, using read-only explorers only when repository discovery is needed.
3. Publish a revisioned Hard Spec comment as `HS-NNN`. It must record the Human Spec digest and define boundaries, acceptance behavior, constraints, risks, dependencies, work type, feature root, and any proposed N/A gates.
4. Stop until an authorized human posts exactly `APPROVED HARD SPEC HS-NNN` for the current revision.
5. If the Human Spec or Hard Spec changes, publish a new Hard Spec revision and obtain a new exact approval.

### 3. Gherkin

1. Delegate to `GherkinAuthor` to derive revisioned Gherkin `GH-NNN` from the approved Hard Spec.
2. Publish the immutable `GH-NNN` comment with its source `HS-NNN`, Human Spec digest, and traceability to acceptance behavior.
3. Stop until an authorized human posts exactly `APPROVED GHERKIN GH-NNN` for the current revision.
4. Any scenario or governing spec change requires a new revision and matching approval.

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

After creating the branch, create and commit the local-memory structure,
start `R001`, and move the Issue to `state:in-progress`.

### 5. Type-aware implementation and verification

Delegate all production-code and test changes to `TDDCraftsman`. `Leader` never edits production code or tests.

- **feature** and **bugfix**: strict red-green-refactor, one behavior increment at a time. Preserve genuine failing-test evidence before the minimum implementation.
- **refactor**: establish or confirm characterization tests, then change structure while behavior remains green. Never manufacture fake red evidence.
- **chore**: run applicable configured checks. A test, Gherkin, or mutation gate may be N/A only when the approved Hard Spec explicitly authorizes that N/A.

Use the repository's language, framework, and configured tooling. Run the project-defined test, lint, type, build, security, or other verification policy applicable to the changed area. Record commands, outcomes, and relevant evidence in local memory and the Issue without exposing secrets.

After behavior is complete and green, perform a final clean-code refactor and rerun all applicable verification. Remove duplication, clarify names and boundaries, and avoid unrelated changes.

### 6. Immutable candidate gates

The candidate is the exact committed `HEAD` SHA. A dirty worktree is not a candidate.

1. Run `Judge` in **PRE_MUTATION** mode on candidate `HEAD`.
2. Post the Judge verdict as an Issue comment naming the exact SHA and `PRE_MUTATION`.
3. If approved, run the project-configured mutation command through `MutationTester` and enforce the project-configured threshold.
4. Post mutation evidence as an Issue comment naming the exact SHA, command, score, threshold, and result.
5. Without changing `HEAD`, run `Judge` in **FINAL** mode on that same exact SHA.
6. Post the FINAL verdict as an Issue comment naming the exact SHA and `FINAL`.

Two Judge passes are mandatory. Judge and mutation evidence lives in Issue comments so recording it does not mutate the candidate. Any candidate `HEAD` change makes all gate evidence stale and returns the work item to PRE_MUTATION; recreate the full evidence chain for the new SHA.

### 7. Pull request and merge

1. Create the PR only after PRE_MUTATION, mutation, and FINAL pass on one unchanged exact SHA.
2. PR creation must not modify `HEAD`.
3. Set the base to `dev` only. `main` is never valid, with no release exception.
4. Use the PR template and include the child Issue, type, approved HS/GH revisions, feature root, verification and refactor evidence, all three evidence-comment references, and exact SHA.
5. Confirm the PR candidate SHA exactly matches every gate comment.
6. Keep the work-item Issue open until the PR is merged into `dev`; then close it and apply `state:done`.
7. Close a parent request only when its own human-defined completion criteria and all required children are complete. It still receives no branch, code, or PR.

## Invalidations and blockers

Return to the earliest affected lifecycle stage when scope, behavior, or approvals change. Never reuse stale approvals or evidence across revisions or SHAs. Record blockers in the child Issue and local memory, apply the documented blocked state label, and stop rather than bypassing a missing prerequisite.

## Repository enforcement

The PR policy workflow checks the `dev` base, branch-name format, and required PR-body references. Configure branch protection for `dev` to require the `enforce-dev-pr` check; the workflow does not become mandatory until branch protection requires it.
