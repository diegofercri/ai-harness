#!/usr/bin/env bash

set -euo pipefail

target_branch="${TARGET_BRANCH:-${CI_MERGE_REQUEST_TARGET_BRANCH_NAME:-}}"
source_branch="${SOURCE_BRANCH:-${CI_MERGE_REQUEST_SOURCE_BRANCH_NAME:-}}"
source_sha="${SOURCE_SHA:-${CI_MERGE_REQUEST_SOURCE_BRANCH_SHA:-${CI_COMMIT_SHA:-}}}"
mr_body="${MR_BODY:-${CI_MERGE_REQUEST_DESCRIPTION:-}}"

require_value() {
  local description="$1"
  local value="$2"
  if [[ -z "$value" ]]; then
    printf 'Missing required %s.\n' "$description" >&2
    exit 1
  fi
}

require_match() {
  local description="$1"
  local pattern="$2"
  if [[ ! "$mr_body" =~ $pattern ]]; then
    printf 'MR description is missing a valid %s.\n' "$description" >&2
    exit 1
  fi
}

require_value "target branch" "$target_branch"
require_value "source branch" "$source_branch"
require_value "source SHA" "$source_sha"
require_value "MR description" "$mr_body"

if [[ "$target_branch" != "dev" ]]; then
  printf 'MR target must be dev; received %s.\n' "$target_branch" >&2
  exit 1
fi

branch_pattern='^(feature|bugfix|chore|refactor)/[0-9]+-[a-z0-9]+(-[a-z0-9]+)*$'
if [[ ! "$source_branch" =~ $branch_pattern ]]; then
  printf 'Invalid branch name: %s\n' "$source_branch" >&2
  exit 1
fi

require_match 'work-item Issue reference' 'Work-item Issue:[[:space:]]*#[0-9]+'
require_match 'work type' 'Work type:[[:space:]]*(feature|bugfix|chore|refactor)'
require_match 'Hard Spec revision' 'Hard Spec:[[:space:]]*HS-[0-9]+'
require_match 'Gherkin revision' 'Gherkin:[[:space:]]*GH-[0-9]+'
require_match 'feature root' 'Feature root:[[:space:]]*`?[^[:space:]<]+'
require_match 'run record' 'Run record:[[:space:]]*`?[^[:space:]<]+/runs/R[0-9]{3}\.md`?'
require_match 'test evidence' 'Test evidence:[[:space:]]*[^<[:space:]]'
require_match 'completed clean-code refactor checkbox' '\[[xX]\][[:space:]]+Final clean-code refactor completed, or approved N/A is linked'
require_match 'PRE_MUTATION note reference' 'PRE_MUTATION note:[[:space:]]*https://[^[:space:]<>]+'
require_match 'mutation note reference' 'Mutation note:[[:space:]]*https://[^[:space:]<>]+'
require_match 'FINAL note reference' 'FINAL note:[[:space:]]*https://[^[:space:]<>]+'
require_match 'exact candidate SHA' 'Exact SHA:[[:space:]]*`?[0-9a-fA-F]{40}`?'
require_match 'dev target statement' '\[[xX]\][[:space:]]+The MR target is `dev`\.'

if [[ "$mr_body" =~ Work-item[[:space:]]Issue:[[:space:]]*#([0-9]+) ]]; then
  issue_number="${BASH_REMATCH[1]}"
else
  exit 1
fi

branch_issue="${source_branch#*/}"
branch_issue="${branch_issue%%-*}"
if [[ "$branch_issue" != "$issue_number" ]]; then
  printf 'Branch Issue %s does not match MR work-item Issue %s.\n' \
    "$branch_issue" "$issue_number" >&2
  exit 1
fi

if [[ "$mr_body" =~ Work[[:space:]]type:[[:space:]]*(feature|bugfix|chore|refactor) ]]; then
  work_type="${BASH_REMATCH[1]}"
else
  exit 1
fi

branch_type="${source_branch%%/*}"
if [[ "$branch_type" != "$work_type" ]]; then
  printf 'Branch type %s does not match MR work type %s.\n' \
    "$branch_type" "$work_type" >&2
  exit 1
fi

if [[ "$mr_body" =~ Exact[[:space:]]SHA:[[:space:]]*\`?([0-9a-fA-F]{40})\`? ]]; then
  declared_sha="${BASH_REMATCH[1],,}"
else
  exit 1
fi

if [[ "$declared_sha" != "${source_sha,,}" ]]; then
  printf 'Declared SHA %s does not match MR source SHA %s.\n' \
    "$declared_sha" "$source_sha" >&2
  exit 1
fi

printf 'MR policy checks passed.\n'
