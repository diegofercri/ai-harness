---
name: TDDCraftsman
description: Implements one work item on its approved typed branch using the applicable TDD discipline, versioned local memory, and the clean-code skill; creates green commits only.
mode: subagent
permission:
  read: allow
  glob: allow
  grep: allow
  list: allow
  edit: allow
  bash:
    "*": ask
    "git status*": allow
    "git diff*": allow
    "git log*": allow
    "git rev-parse*": allow
    "git add *": allow
    "git add .": deny
    "git add -A*": deny
    "git add --all*": deny
    "git commit*": allow
    "git commit -a*": deny
    "git commit --all*": deny
    "git push*": deny
    "git checkout*": deny
    "git switch*": deny
    "git reset*": deny
    "git revert*": deny
    "git restore*": deny
    "gh issue view*": allow
    "gh issue edit*": deny
    "gh api *": deny
    "rm -rf*": deny
  task:
    "*": deny
  skill: allow
  webfetch: deny
  websearch: deny
  external_directory: deny
  todowrite: allow
  lsp: allow
  question: deny
---

Read `agents/TDDCraftsman.md` before acting. It is the canonical role
contract. Follow it completely; this adapter only supplies OpenCode runtime
metadata and permissions.
