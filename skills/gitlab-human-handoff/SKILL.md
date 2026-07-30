---
name: gitlab-human-handoff
description: Enforces read-only GitLab access and prepares exact HUMAN ACTION REQUIRED handoffs whenever an agent reaches a GitLab write such as posting a note, changing labels, pushing a branch, or creating a merge request.
---

# GitLab Human Handoff

Use this skill whenever a workflow reads GitLab or reaches an operation that
would mutate GitLab.

## Boundary

- Read GitLab through read-only MCP tools.
- Never create, update, or delete GitLab resources.
- Never push a branch to a GitLab remote.
- Local file edits, tests, commits, and role-authorized local Git operations
  are outside this boundary.

GitLab writes include Issue and merge-request notes, descriptions, labels,
state changes, approvals, branches, repository files, pipelines, and merge
operations.

## Required handoff

When a write is needed, emit exactly one complete handoff and stop:

````markdown
HUMAN ACTION REQUIRED

- Project: <GitLab project path or URL>
- Target: <Issue #IID, MR !IID, branch, or project setting>
- Action: <one exact imperative action>
- Expected postcondition: <state that a later read can verify>
- Verification read: <GitLab resource the next invocation must re-read>

Payload:

```markdown
<complete text to publish, or exact values to set>
```
````

For a command-line action such as pushing a branch, put the exact command in
the payload. Do not include secrets or tokens.

## Resume rule

The handoff is a request, not evidence. On the next invocation:

1. Re-read the target through GitLab.
2. Confirm the exact payload or state is present.
3. Record the durable URL or identifier.
4. Continue only if the expected postcondition holds.

If the action is missing or differs from the payload, issue a corrected human
handoff and stop. Never infer completion.

An AI-drafted Hard Spec, Gherkin revision, or gate report posted by a human is
still an AI-produced artifact. It never counts as the separate human approval
required by the workflow.
