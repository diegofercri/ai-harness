# AI Harness

AI Harness is a reusable template repository for bringing structured
AI-assisted development workflows into other codebases. It collects portable
agents, skills, MCP integrations, and supporting resources that can be adopted
individually or combined into a project-specific harness.

## Repository Contents

| Path | Purpose |
| --- | --- |
| `agents/` | Agent definitions for planning, implementation, review, and coordination. |
| `skills/` | Reusable instructions and domain-specific workflows. |
| `mcps/` | MCP server configurations and integration documentation. |

Additional resource types may be added as the harness evolves.

## Included Agents

- `leader`: Coordinates work, delegates tasks, and enforces human approval
  gates through remote repository Issues.
- `spec_author`: Turns feature requests into structured requirements, designs,
  and implementation tasks.
- `implementer`: Implements one approved feature at a time and verifies it with
  tests.
- `reviewer`: Reviews implementations for requirement traceability, completed
  tasks, architectural consistency, and passing tests.

## Using This Template

1. Create a repository from this template or clone it as a starting point.
2. Select the agents, skills, and integrations needed by the target project.
3. Copy or reference those resources from the target repository's AI tooling
   configuration.
4. Adapt project-specific paths, commands, permissions, and workflow rules.
5. Keep application code in the target repository; keep reusable harness
   components here.

## Design Principles

- Keep resources portable and independent of a single application.
- Make agent responsibilities explicit and narrowly scoped.
- Require human approval at consequential workflow boundaries.
- Store durable outputs in files or repository Issues instead of chat history.
- Verify implementation work with automated tests and traceable reviews.

## Status

This repository is evolving. Interfaces, directory conventions, and workflows
may change as new agents, skills, and integrations are added.
