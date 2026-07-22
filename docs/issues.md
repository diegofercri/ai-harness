# Issues

GitHub Issues replace any local feature registry. The Issue and its
comments are the contract, approval record, lifecycle record, and quality
evidence for a work item.

## Issue Roles

| Role | Label | Purpose | Delivery |
| --- | --- | --- | --- |
| Parent request | `harness:request` | Optional container that decomposes a broad request into atomic children. | No branch or PR. |
| Work item | `harness:work-item` | One independently specifiable, implementable, verifiable change. | One active branch and PR per run. |

A parent may reference several work items. It never owns their contract or
approval. A work item contains one Human Spec and one active Hard Spec and
Gherkin revision at a time.

## Work-Item Body

The work-item Issue Form records human-owned intake:

- Human Spec
- work type
- slug
- optional parent and related Issues
- optional proposed feature root
- supporting context

The Human Spec remains in the Issue body exactly as supplied. AI agents
MUST NOT rewrite it. If a human edits it after approval, all downstream
Hard Spec and Gherkin approvals become stale.

Hard Spec and Gherkin revisions are append-only Issue comments, not body
edits. This preserves their history and avoids rewriting the Human Spec.

## Hard Spec Revisions

`SpecPartner` posts one comment per revision:

````markdown
# Hard Spec HS-001

- Human Spec digest: sha256:<digest>
- Type: feature | bugfix | chore | refactor
- Feature root: <one repository-relative owning directory>
- Parent request: #<n> | none
- Related Issues: <relations> | none
- Proposed branch: feature/123-short-slug

## Purpose
...

## Scope
...

## Non-goals
...

## Observable behavior
...

## Edge cases
...

## Decisions
- Decision, alternatives, rationale

## Verification policy
- Project test commands
- Mutation command, eligible paths, and threshold
- Explicit N/A gates, if the work type permits them

## Open questions
- none
````

Revision IDs are Issue-local, zero-padded, and monotonically increasing.
A published comment is immutable. Human feedback produces `HS-002`, never
an edit to `HS-001`.

The Human Spec digest binds the revision to the exact human-owned text it
interpreted. A mismatched digest invalidates the revision and everything
derived from it.

## Gherkin Revisions

After an exact Hard Spec revision is approved, `GherkinAuthor` posts a
new comment:

````markdown
# Gherkin GH-001

- Derived from: HS-001
- Human Spec digest: sha256:<same digest as HS-001>

```gherkin
@issue-123
Feature: Observable capability

  @s001
  Scenario: Observable result
    Given a measurable starting state
    When a concrete action occurs
    Then a measurable result is observed
```
````

`docs/gherkin.md` defines scenario and work-type rules. A published Gherkin
comment is immutable. Feedback produces the next `GH-NNN` comment.

## Approval Comments

Only these exact comment forms approve revisions:

```text
APPROVED HARD SPEC HS-NNN
APPROVED GHERKIN GH-NNN
```

The author MUST satisfy the adopting repository's authorized-human policy.
AI agents MUST NOT write, imitate, relay, or infer an approval comment.
Labels, reactions, PR reviews, chat statements, and approximate wording do
not count.

Use a distinct bot identity for AI-authored GitHub writes whenever possible;
that identity MUST NOT be an authorized approver. If AI and human actions
share one GitHub identity, the repository MUST define an additional
verifiable manual-attestation mechanism. Account authorship alone is then
insufficient. Missing or ambiguous approval policy blocks the workflow.

Approval validity:

- Editing the Human Spec invalidates Hard Spec and Gherkin approvals.
- A new Hard Spec revision invalidates the prior Hard Spec approval and all
  Gherkin approvals derived from it.
- A new Gherkin revision invalidates only the prior Gherkin approval.
- Approval always names the exact active revision.

## Labels

Create all labels before using the workflow. Issue Forms cannot create
missing labels.

Role, exactly one:

- `harness:request`
- `harness:work-item`

Type, exactly one on every work item:

- `type:feature`
- `type:bugfix`
- `type:chore`
- `type:refactor`

State, exactly one on every work item:

| Label | Meaning |
| --- | --- |
| `state:human-spec` | Human Spec exists; Hard Spec is not ready for review. |
| `state:hard-spec-review` | Awaiting approval of the active `HS-NNN`. |
| `state:gherkin-review` | Awaiting approval of the active `GH-NNN`. |
| `state:ready` | Both active revisions are approved; no implementation branch is active. |
| `state:in-progress` | An implementation branch and local run are active. |
| `state:blocked` | A documented prerequisite prevents progress. |
| `state:pr-ready` | A PR to `dev` is open. |
| `state:done` | Delivery merged into `dev`; the Issue is closed. |

## Branches, PRs, And Reopening

The normal case is one work item, one run, one branch, and one PR. The
branch is created from current `dev` only after both approvals and matches:

```text
feature/123-short-slug
bugfix/123-short-slug
chore/123-short-slug
refactor/123-short-slug
```

Only one branch and PR may be active for a work item. After merge, the
orchestrator closes the Issue and applies `state:done`.

If the original approved contract is later shown never to have been
satisfied, reopen the same Issue, create the next local run, and recreate
the canonical branch from current `dev`. The Issue may therefore have more
than one historical PR, but never concurrent delivery branches.

Create a new work-item Issue instead when:

- requirements or accepted scope change,
- previously working behavior regresses, or
- the fix can be delivered independently of the original contract.

## Source-Of-Truth Rule

Human Spec, Hard Spec, Gherkin, approvals, labels, and quality-gate comments
live only in the Issue. Local memory stores identifiers, links, progress,
and implementation decisions. It MUST NOT copy contract text.
