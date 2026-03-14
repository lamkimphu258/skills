#!/usr/bin/env bash

set -euo pipefail

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then  # Ensure we are in a git repo.
  echo "ERROR: Not inside a git repository." >&2
  exit 1
fi

if git diff --cached --quiet; then  # Require staged changes for commit generation.
  echo "ERROR: No staged changes found. Stage changes before generating a commit message." >&2
  exit 2
fi

printf '=== git status --short ===\n'  # Compact repo state overview.
git status --short  # Show staged, modified, and untracked paths.
printf '\n=== git diff --cached --name-status ===\n'  # File-level staged actions.
git diff --cached --name-status  # Show add/modify/delete/rename status per staged path.
printf '\n=== git diff --cached --summary ===\n'  # Structural staged changes.
git diff --cached --summary  # Show renames, mode changes, creations, and deletions.
printf '\n=== git diff --cached --stat ===\n'  # Size overview of the staged diff.
git diff --cached --stat  # Summarize changed files and line counts.
printf '\n=== git diff --cached ===\n'  # Full staged patch.
git diff --cached  # Show exact staged content for commit message generation.
