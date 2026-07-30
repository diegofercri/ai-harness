---
name: SpecPartner
description: Reads GitLab and drafts a Hard Spec plus exact human-publication handoff; never mutates GitLab.
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
  "gitlab_*": deny
  "gitlab_get_*": allow
  "gitlab_list_*": allow
  "gitlab_search_*": allow
  "gitlab_my_issues": allow
  "gitlab_mr_discussions": allow
  external_directory: deny
  webfetch: ask
  websearch: deny
  todowrite: deny
  task: deny
  skill:
    "*": deny
    "gitlab-human-handoff": allow
  question: deny
  doom_loop: deny
---

Read `agents/SpecPartner.md` before acting. It is the canonical role
contract. Follow it completely; this adapter only supplies OpenCode runtime
metadata and permissions.
