---
name: git-commit
description: Generate an English commit message from staged git changes using fixed Conventional Commit rules. Use when is asked to write, draft, suggest, or improve a commit message based on the current staged diff, such as "generate a commit message", "write a commit message for these staged changes", or "summarize my git diff into a commit message". This skill prioritizes its own formatting rules over repository history and always returns a subject plus body when the staged intent is clear.
---

# Git Write Commit Message

## Overview

Inspect staged git changes and turn them into one commit message that follows a fixed Conventional Commit format.
Ignore existing repository commit style. Apply the rules in this skill even when prior commits use a different convention.

## Workflow

1. Confirm the working directory is inside a git repository.
2. Collect staged context with `./scripts/collect_commit_context.sh`.
3. If the script reports no staged changes, stop and tell the user to stage changes first.
4. Read the staged diff and classify the dominant intent.
5. If the staged diff mixes unrelated changes or the intent is not inferable, ask one clarifying question instead of guessing.
6. Draft one final commit message using the rules below.
7. After presenting the message, ask whether the user wants to commit with it as-is or modify it.

## Output Format

Write the message in this exact shape:

```text
type(scope): summary

Explain what changed and why.
Add one or two more lines only when they carry distinct value.
```

Use `type: summary` when there is no clear scope.
After the message, ask a short follow-up such as `Commit with this message, or modify it?`

Apply these subject rules:
- Use English.
- Use imperative mood.
- Keep the summary under 72 characters.
- Do not end the subject with a period.
- Keep the text after the colon lowercase unless a proper noun requires otherwise.
- Use `!` before the colon for breaking changes, for example `feat(api)!: remove legacy auth flow`.

Apply these body rules:
- Always include a blank line after the subject.
- Write 1 to 3 concise lines.
- Explain behavior or intent, not filenames.
- Mention side effects or migration notes when they matter.
- Wrap lines near 72 characters when practical.
- Add a `BREAKING CHANGE:` line when the diff clearly introduces an incompatible change.

## Type Selection

Choose exactly one type from this list:

- `feat` for new user-visible behavior or capability
- `fix` for bug corrections
- `refactor` for internal restructuring without intended behavior change
- `docs` for documentation-only changes
- `test` for adding or updating tests
- `chore` for maintenance work that does not fit a more specific type
- `build` for build system or dependency pipeline changes
- `ci` for CI workflow changes
- `perf` for measurable performance improvements
- `style` for formatting-only changes with no behavior effect

When multiple types could fit, prefer the highest-impact user-facing type.
If the staged diff contains unrelated work across multiple types, ask one clarifying question.

## Scope Selection

Add a scope only when one module, package, or feature area clearly dominates the staged change.
Keep the scope short and lowercase, such as `api`, `auth`, `cli`, or `docs`.
Omit the scope when the change spans multiple unrelated areas or when the correct scope is unclear.

## Decision Rules

- Base the message only on staged changes.
- Do not inspect commit history to imitate prior style.
- Do not mention files unless the filename itself is the user-facing change.
- Do not run `git commit` unless the user explicitly confirms they want to commit with the generated message.
- Prefer behavior-level summaries over implementation details.
- If the diff is mostly formatting, whitespace, or lint cleanup, default to `style` or `chore` based on actual impact.
- If the diff contains both code and tests for the same change, choose the code-oriented type and cover tests in the body.
- If the diff shows a breaking API or contract change, use `!` and add `BREAKING CHANGE:`.

## Failure Handling

- If the current directory is not a git repository, say that plainly and stop.
- If there are no staged changes, instruct the user to stage changes first.
- If the staged changes combine unrelated intents, ask for the intended commit split instead of inventing one message.

## Examples

```text
feat(auth): add refresh token rotation

Rotate refresh tokens on each renewal to reduce replay risk.
Invalidate the previous token after a successful exchange.
```

```text
fix(cli): handle empty config values

Avoid treating empty strings as missing keys during config parsing.
Preserve explicit user overrides for optional settings.
```

```text
refactor: simplify cache invalidation flow

Remove duplicate invalidation branches and centralize key cleanup.
Keep the behavior unchanged while reducing maintenance overhead.
```
