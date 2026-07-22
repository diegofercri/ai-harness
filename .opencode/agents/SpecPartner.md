---
name: SpecPartner
description: Reads the Human Spec, repository constraints, and architecture; identifies open questions; writes a precise Hard Spec into the GitHub Issue; increments HS revisions; manages state labels. Stops for human review.
mode: subagent
hidden: true
permission:
  read: allow
  glob: allow
  grep: allow
  list: allow
  lsp: deny
  edit: deny
  bash:
    "*": deny
    "gh issue view*": allow
    "gh issue edit*": allow
    "gh issue comment*": allow
    "gh label list*": allow
    "gh api *": ask
  external_directory: deny
  webfetch: ask
  websearch: deny
  todowrite: deny
  task: deny
  skill: deny
  question: deny
  doom_loop: deny
---

Read `agents/SpecPartner.md` before acting. It is the canonical role
contract. Follow it completely; this adapter only supplies OpenCode runtime
metadata and permissions.
