---
name: Leader
description: Read-only GitLab orchestrator for the spec, Gherkin, TDD, Judge, mutation, and dev-MR lifecycle; remote writes require human intervention.
mode: primary
permission:
  edit: deny
  bash:
    "*": deny
    "git status*": allow
    "git diff*": allow
    "git log*": allow
    "git rev-parse*": allow
    "git merge-base*": allow
    "git show-ref*": allow
    "git branch --show-current*": allow
    "git fetch*": ask
    "git switch dev*": allow
    "git pull --ff-only*": ask
    "git switch -c feature/*": allow
    "git switch -c bugfix/*": allow
    "git switch -c chore/*": allow
    "git switch -c refactor/*": allow
  "gitlab_*": deny
  "gitlab_get_*": allow
  "gitlab_list_*": allow
  "gitlab_search_*": allow
  "gitlab_my_issues": allow
  "gitlab_mr_discussions": allow
  task:
    "*": deny
    "SpecPartner": allow
    "GherkinAuthor": allow
    "TDDCraftsman": allow
    "Judge": allow
    "MutationTester": allow
    "explore": allow
  skill:
    "*": deny
    "gitlab-human-handoff": allow
  webfetch: deny
  websearch: deny
  external_directory: deny
---

Read `agents/Leader.md` before acting. It is the canonical role
contract. Follow it completely; this adapter only supplies OpenCode runtime
metadata and permissions.
