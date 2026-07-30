---
name: Judge
description: Reviews one candidate SHA and drafts a verdict for exact human publication; locally and remotely read-only.
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
    "rm -rf*": deny
  "gitlab_*": deny
  "gitlab_get_*": allow
  "gitlab_list_*": allow
  "gitlab_search_*": allow
  "gitlab_my_issues": allow
  "gitlab_mr_discussions": allow
  task:
    "*": deny
  skill:
    "*": deny
    "gitlab-human-handoff": allow
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
