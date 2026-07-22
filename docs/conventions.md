# Harness Conventions

These conventions define template vocabulary and identifiers. Application
code follows the adopting project's own conventions.

## Language

All first-party harness documents, Issue contracts, memory, and evidence
MUST be written in English.

## Terms

| Term | Meaning |
| --- | --- |
| Parent request | Optional `harness:request` Issue that groups work items and receives no branch or PR. |
| Work item | Atomic `harness:work-item` Issue and unit of delivery. |
| Human Spec | Human-owned request in the work-item body. |
| Hard Spec | Append-only AI comment identified by `HS-NNN`. |
| Gherkin | Append-only AI acceptance-contract comment identified by `GH-NNN`. |
| Feature root | Smallest repository directory that owns the change and its local memory. |
| Run | One implementation attempt against unchanged approved revisions. |

## Identifiers

- Hard Spec revisions: `HS-001`, `HS-002`, and so on.
- Gherkin revisions: `GH-001`, `GH-002`, and so on.
- Scenario tags: `@issue-123` plus `@s001`, `@s002`, and so on.
- Decision IDs: `D-123-001`, where `123` is the Issue number.
- Runs: `R001`, `R002`, and so on.
- Slugs: lowercase ASCII words separated by one hyphen.
- Branches: `<type>/<issue>-<slug>`, where type is `feature`, `bugfix`,
  `chore`, or `refactor`.

Identifiers are stable and never reused. A superseding revision, decision,
or run receives the next number.

## Labels

Every work item has exactly one label on each axis:

- role: `harness:work-item`
- type: one `type:*` label documented in `docs/issues.md`
- state: one `state:*` label documented in `docs/issues.md`

Parent requests use `harness:request` and do not require one overall work
type because their children may have different types.

## Approval Text

Approval comments must match exactly:

```text
APPROVED HARD SPEC HS-NNN
APPROVED GHERKIN GH-NNN
```

Approximate wording, reactions, checkboxes, chat messages, and AI-authored
comments are not approvals.

## Paths

Local memory uses:

```text
<feature-root>/.ai/work-items/<issue>-<slug>/
  progress.md
  decisions.md
  runs/RNNN.md
```

Use repository-relative paths in Hard Spec, memory, findings, and PRs.

## Portability

Reusable agents and docs MUST NOT invent a language, source directory,
test command, mutation command, eligible mutation paths, or threshold. The
adopting repository declares these policies. Missing policy blocks work.
