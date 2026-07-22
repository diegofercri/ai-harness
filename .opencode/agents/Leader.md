---
name: Leader
description: Primary orchestrator for the Issue-driven spec, Gherkin, TDD, Judge, mutation, and dev-PR lifecycle; never edits production code or tests.
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
    "gh issue view*": allow
    "gh issue list*": allow
    "gh issue edit*": allow
    "gh issue comment*": allow
    "gh issue close*": allow
    "gh pr view*": allow
    "gh pr list*": allow
    "gh pr create*": allow
    "gh label list*": allow
    "gh api *": ask
  task:
    "*": deny
    "SpecPartner": allow
    "GherkinAuthor": allow
    "TDDCraftsman": allow
    "Judge": allow
    "MutationTester": allow
    "explore": allow
  webfetch: deny
  websearch: deny
  external_directory: deny
---

Read `agents/Leader.md` before acting. It is the canonical role
contract. Follow it completely; this adapter only supplies OpenCode runtime
metadata and permissions.
