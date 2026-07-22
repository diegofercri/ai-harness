---
name: Judge
description: Reviews one candidate HEAD at PRE_MUTATION or FINAL, runs declared verification, and posts a durable Issue verdict tied to the exact SHA; locally read-only.
mode: subagent
permission:
  read: allow
  glob: allow
  grep: allow
  list: allow
  edit: deny
  bash:
    "*": ask
    "git status*": allow
    "git diff*": allow
    "git log*": allow
    "git show*": allow
    "git rev-parse*": allow
    "git checkout*": deny
    "git commit*": deny
    "git push*": deny
    "git reset*": deny
    "git revert*": deny
    "git add*": deny
    "gh issue view*": allow
    "gh issue comment*": allow
    "gh api *": ask
    "rm -rf*": deny
  task:
    "*": deny
  skill: deny
  webfetch: deny
  websearch: deny
  external_directory: deny
  todowrite: allow
  lsp: deny
  question: deny
---

Read `agents/Judge.md` before acting. It is the canonical role contract.
Follow it completely; this adapter only supplies OpenCode runtime metadata
and permissions.
