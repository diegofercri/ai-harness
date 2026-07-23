# Agent Navigation

This repository uses an OpenCode-first, tool-portable engineering workflow. The Issue is the contract and lifecycle source; do not infer missing policy.

## Read in this order

1. `docs/workflow.md` — canonical lifecycle, gates, artifacts, branches, and PR rules.
2. The atomic work-item Issue and its authorized approval comments.
3. `ARCHITECTURE.md` and `CONSTRAINTS.md`.
4. Project conventions, TDD, Gherkin, verification, and mutation-testing documentation as relevant.
5. `agents/` for canonical role contracts and `.opencode/agents/` for
   OpenCode runtime adapters; `Leader` is the primary orchestrator.

## Key locations

- `docs/workflow.md`: canonical process.
- `ARCHITECTURE.md`: repository and artifact architecture.
- `CONSTRAINTS.md`: non-negotiable workflow rules.
- `docs/issues.md`: Issue schema, labels, revisions, and approvals.
- `docs/memory.md`: colocated progress, decisions, and run records.
- `docs/conventions.md`: repository conventions.
- `docs/gherkin.md`: scenario guidance.
- `docs/tdd.md`: test-driven development guidance.
- `docs/verification.md`: project test policy.
- `docs/mutation-testing.md`: configured mutation command and threshold.
- `<feature-root>/.ai/work-items/<issue-number>-<slug>/`: local progress, decisions, and run records.
- `.github/pull_request_template.md`: required PR evidence.
- `.github/workflows/enforce-dev-pr.yml`: mechanical PR policy check; branch protection must require it.
- `agents/`: canonical agent behavior shared across runtimes.
- `.opencode/agents/`: executable adapters and OpenCode permissions.

## Stop conditions

Stop as blocked if `dev`, required labels, authorized approvers, the project test policy, the mutation command, eligible mutation paths, or the mutation threshold is missing. Never invent defaults. Never use `main` as a PR base.
