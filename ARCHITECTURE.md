# Architecture

This document is the canonical description of the repository layout,
the artifacts the lifecycle produces, and how they relate to GitHub.
The GitHub Issue is the contract and lifecycle source; nothing in the
codebase may contradict it.

## Repository layout

| Path                                                | Role                                                                |
|-----------------------------------------------------|---------------------------------------------------------------------|
| `AGENTS.md`                                         | Primary navigation read by every agent at session start.            |
| `README.md`                                         | How to adopt the template.                                          |
| `ARCHITECTURE.md`                                   | This file: repository and artifact architecture.                   |
| `CONSTRAINTS.md`                                    | RFC 2119 hard workflow rules.                                       |
| `CHECKPOINTS.md`                                    | Objective gate checklist.                                           |
| `opencode.json`                                     | Minimal OpenCode configuration.                                     |
| `docs/conventions.md`                               | Template terminology, IDs, revisions, paths.                       |
| `docs/issues.md`                                    | Issue roles, revisions, labels, approvals, and reopening rules.    |
| `docs/memory.md`                                    | Colocated progress, decisions, and immutable run records.           |
| `docs/workflow.md`                                  | Canonical lifecycle, gates, artifacts, branches, and PR rules.       |
| `docs/tdd.md`                                       | Test-driven development discipline.                                 |
| `docs/gherkin.md`                                   | Gherkin contract format.                                            |
| `docs/mutation-testing.md`                          | Mutation testing policy.                                            |
| `docs/verification.md`                              | Verification levels.                                                |
| `agents/`                                           | Canonical, tool-portable agent role contracts.                      |
| `.opencode/agents/`                                 | OpenCode adapters that load canonical contracts and enforce permissions. |
| `skills/`                                           | OpenCode skill definitions (for example `clean-code`).              |
| `.github/`                                          | Issue Forms, PR template, and mechanical PR checks.                 |
| `<feature-root>/.ai/work-items/<issue>-<slug>/`     | Durable local memory for one Issue.                                 |

## Artifact model

### Issue types

- **Work-item Issue** (`harness:work-item` label). Atomic. Carries:
  - An immutable **Human Spec** in the Issue body.
  - Append-only **AI Hard Spec** comments identified by `HS-NNN`.
  - Append-only **AI Gherkin** comments identified by `GH-NNN`.
  - Human approval and exact-SHA quality-gate comments.
- **Parent Request Issue** (`harness:request` label, optional). May
  reference one or many child Issues. It NEVER receives code, a
  branch, or a PR.

### Revisions

`HS-NNN` and `GH-NNN` are zero-padded, monotonically increasing,
Issue-local numbers. Each revision is a new Issue comment. Hard Spec
records the Human Spec digest it interpreted; Gherkin identifies its
source Hard Spec. A new comment supersedes a prior revision without
rewriting history.

### Approvals

A human approval is an **explicit Issue comment** by a human that
names the exact revision. AI MUST NEVER author an approval comment.

Approval ordering:

1. Hard Spec approval precedes Gherkin approval.
2. Gherkin approval precedes branch creation.

## Branch and PR model

- The base branch is `dev`. `main` is never a PR base.
- Branches MUST be cut from `dev` and named exactly
  `feature/`, `bugfix/`, `chore/`, or `refactor/` followed by
  `<issue-number>-<slug>`.
- The PR base MUST be `dev`. After merge, the orchestrator closes the
  work-item Issue and applies `state:done`.

## Local memory model

Durable implementation memory lives under
`<feature-root>/.ai/work-items/<issue>-<slug>/`:

- `progress.md` — current run state, blockers, next steps.
- `decisions.md` — decisions, alternatives, and reasons.
- `runs/RNNN.md` — one immutable record per run, zero-padded.

`<feature-root>` is the smallest repository directory that owns the change,
approved by the Hard Spec. For production work it is normally a code or
package root; for a chore it may be a configuration or documentation root.
Memory is committed with the implementation branch so later sessions
and related work can discover it. The Issue remains the contract and
lifecycle source; local memory does NOT duplicate the Hard Spec or
Gherkin text.

## Run model

A run is one implementation attempt against unchanged approved
revisions. Close it before committing a candidate for quality gates.
Create the next run when a gate requires code or test changes, or when
an Issue is reopened because the original approved contract was never
satisfied. Changed scope or a later regression receives a new Issue.

The previous run file stays immutable. A reopened, unchanged contract
may start another delivery episode on a newly created canonical branch;
only one branch and PR may be active for the Issue at a time.

## Gate model

`CHECKPOINTS.md` lists the gates. Any candidate HEAD change invalidates
prior gate results. The Judge MUST run twice on the same exact HEAD
(`PRE_MUTATION` before mutation testing and `FINAL` after it) before
a PR is opened.
