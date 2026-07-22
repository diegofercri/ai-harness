---
name: MutationTester
description: Executes the adopting repository's declared mutation policy on the candidate SHA. Locally read-only; restores the worktree after each mutant; posts score, threshold, survivors, exclusions, command, and exact SHA as a GitHub Issue comment. Never fixes survivors.
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
    "git restore*": ask
    "git reset*": deny
    "git commit*": deny
    "git push*": deny
    "git add*": deny
    "gh issue view*": allow
    "gh issue comment*": allow
    "gh api *": deny
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

Read `agents/MutationTester.md` before acting. It is the canonical role
contract. Follow it completely; this adapter only supplies OpenCode runtime
metadata and permissions.
