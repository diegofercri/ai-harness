# AI Harness Template

A stack-agnostic, OpenCode-first template that brings a disciplined
human-approved workflow to any software project. The lifecycle is
portable; OpenCode is the first-class runner.

## What this template gives you

- A canonical contract: every change lives inside one atomic GitHub
  child Issue that carries an immutable **Human Spec**, an **AI Hard
  Spec** (revision `HS-NNN`), and an **AI Gherkin** (revision
  `GH-NNN`).
- An OpenCode-first but portable agent set, configured through a
  minimal `opencode.json` with `Leader` as the default
  orchestrator.
- A gate-based lifecycle (Hard Spec → Gherkin → TDD → Refactor →
  Judge `PRE_MUTATION` → Mutation → Judge `FINAL` → PR) that ends with
  a pull request into `dev`, never `main`.
- Durable local memory that lives next to the code, under
  `<feature-root>/.ai/work-items/<issue-number>-<slug>/`.
- Stack-agnostic policies: the project, not the template, defines the
  test runner and mutation command.

## Quick start

1. Install OpenCode:

   ```sh
   curl -fsSL https://opencode.ai/install | bash
   ```

   Other install methods (npm, Homebrew, pacman, Scoop, Mise, Docker)
   are listed at <https://opencode.ai/docs/>.

2. Configure an LLM provider in OpenCode. The simplest path is
   OpenCode Zen: run `/connect` inside the TUI and follow the prompts.
3. Use this repository as a template, or merge its content into an
   existing repository.
4. Create the required GitHub `dev` branch, labels, approval policy,
   and branch-protection rule described below.
5. Configure the project test and mutation policies.
6. Restart OpenCode after installing or changing the configuration,
   agents, or skills. OpenCode loads them only at startup.

## Required GitHub setup

- A protected `dev` branch. Pull requests MUST target `dev`. `main` is
  never a PR base.
- A PR policy check (for example
  `.github/workflows/enforce-dev-pr.yml`) that mechanically rejects
  PRs whose base is not `dev`.
- Role labels: `harness:request` and `harness:work-item`.
- Type labels: `type:feature`, `type:bugfix`, `type:chore`, and
  `type:refactor`.
- State labels: `state:human-spec`, `state:hard-spec-review`,
  `state:gherkin-review`, `state:ready`, `state:in-progress`,
  `state:blocked`, `state:pr-ready`, and `state:done`.
- A documented policy that identifies which human accounts may approve
  Hard Spec and Gherkin revisions. Missing approval policy blocks work.

For auditable gates, run AI GitHub writes through a bot identity that is
not on the human approver list. If AI and human actions share one GitHub
identity, the project MUST define another verifiable manual-attestation
mechanism before treating comments as approvals.

Issue Forms can apply only labels that already exist. Create these labels
before opening the first work item.

## Required branch names

Branches MUST be cut from `dev` and named exactly one of:

- `feature/<issue-number>-<slug>`
- `bugfix/<issue-number>-<slug>`
- `chore/<issue-number>-<slug>`
- `refactor/<issue-number>-<slug>`

## Project-specific test and mutation policy

This template does not prescribe a test runner or mutation tool. The
project MUST define and document, in its own repository:

- the test command (for example `npm test`, `pytest`, `go test ./...`),
- the mutation command (for example
  `npx stryker run`, `mutmut run`, `cargo mutants`),
- the paths eligible for mutation,
- the mutation threshold the team accepts on new or touched code.

`CONSTRAINTS.md` and `CHECKPOINTS.md` reference these commands and
thresholds but never invent defaults.

## Final layout

```
.
├── AGENTS.md                            Orchestrator navigation (primary read)
├── README.md                            This file
├── ARCHITECTURE.md                      Repository and artifact architecture
├── CONSTRAINTS.md                       RFC 2119 hard workflow rules
├── CHECKPOINTS.md                       Objective gate checklist
├── opencode.json                        OpenCode configuration
├── docs/
│   ├── conventions.md                   Template terminology and IDs
│   ├── issues.md                        Canonical Issue contract
│   ├── memory.md                        Colocated progress and decisions
│   ├── workflow.md                      Lifecycle and gates
│   ├── tdd.md                           Test-driven development
│   ├── gherkin.md                       Gherkin contract format
│   ├── mutation-testing.md              Mutation policy
│   └── verification.md                  Verification levels
├── agents/                              Canonical portable agent contracts
├── .opencode/agents/                    OpenCode runtime adapters and permissions
├── .github/                             Issue Forms, PR template, and policy check
└── skills/                              Reusable skills, including clean-code
```

## Portability

- No stack-specific tooling or language assumptions are baked in.
- The Hard Spec, Gherkin, and lifecycle are language-neutral.
- Local memory under `<feature-root>/.ai/work-items/` is plain
  Markdown and is versioned with the code.
- OpenCode is the first-class runner, but the lifecycle is portable
  to any agent runtime that can read the Issue and the files.
- Agent behavior is authored once in `agents/`. OpenCode adapters under
  `.opencode/agents/` load those contracts and add runtime permissions.
