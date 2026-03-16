---
name: plan-with-scenarios-and-tasks
description: Supplement Plan mode with a stricter final proposed-plan format that includes Summary, Scenarios, Test Plan, Implementation Changes, Tasks, and Assumptions. Use when the user wants a plan to be more rigorous, cover crucial scenarios and edge cases, map scenarios to validation, or break implementation into concrete execution tasks.
---

# Strict Plan With Scenarios And Tasks

Use this skill only as an overlay on top of the active Plan mode instructions. Keep all normal Plan mode workflow, questioning, and finalization rules.

## Preserve Plan Mode Guarantees

- Keep the required `<proposed_plan>` and `</proposed_plan>` wrapper.
- Keep the rule that the final plan must be decision complete and directly implementable.
- Keep the rule that the final output must be plan-only and must not ask whether to proceed.
- Keep normal clarification behavior. Ask follow-up questions when unresolved decisions would materially change the plan.

## Planning Workflow

Before finalizing the plan:

1. Extract the goal, constraints, and locked decisions from the request.
2. Enumerate the crucial scenarios the implementation must support.
3. Convert those scenarios into validation coverage in `## Test Plan`.
4. Describe the implementation at the subsystem or behavior level in `## Implementation Changes`.
5. Turn the implementation into a concrete checklist in `## Tasks`.
6. Record chosen defaults and non-user-specified decisions in `## Assumptions`.

Include auth, migration, compatibility, rollout, or data integrity scenarios only when they are actually relevant. If a required section has nothing meaningful to add, keep the section and state `- None.` or an equally explicit equivalent.

## Final Plan Structure

When writing the final `<proposed_plan>` block:

- Use Markdown inside the block.
- Add a short title before the H2 sections.
- Use exactly these H2 sections in this order:
  - `## Summary`
  - `## Scenarios`
  - `## Test Plan`
  - `## Implementation Changes`
  - `## Tasks`
  - `## Assumptions`
- Do not rename, omit, or reorder these sections unless the user explicitly asks.

## Section Requirements

### Summary

- State the goal, intended outcome, and the most important constraints.
- Keep this section short.

### Scenarios

- Put this section immediately after `## Summary`.
- List the crucial behaviors the implementation must support.
- Cover the happy path plus meaningful edge cases, failure modes, regressions, permission boundaries, data integrity risks, and compatibility or migration cases when relevant.
- Write each bullet as one concrete scenario or required behavior.
- Describe what must work, not how to test it.

### Test Plan

- Explain how the crucial scenarios will be validated.
- Make sure the validation strategy covers every material scenario from `## Scenarios`.
- Use the right validation layers for the work, such as unit, integration, end-to-end, routing, migration, compatibility, load, or manual verification.
- Focus on validation strategy instead of repeating the scenario bullets verbatim.

### Implementation Changes

- Describe the design in a decision-complete way so the implementer does not need to make major design decisions later.
- Group changes by subsystem, behavior, or rollout phase rather than by file, unless filenames are necessary to remove ambiguity.
- Call out important public APIs, contracts, schemas, types, storage changes, config changes, or external integrations when relevant.
- Include sequencing or rollout notes when order matters.

### Tasks

- Put this section immediately after `## Implementation Changes`.
- Use Markdown task-list syntax such as `- [ ]`.
- Make every item concrete and directly executable by an engineer.
- Prefer small, ordered tasks over vague umbrellas.
- Do not include placeholder work such as `- [ ] figure out details` or `- [ ] investigate later`.
- If something is unresolved, ask before finalizing or record the chosen default in `## Assumptions`.

### Assumptions

- List defaults chosen and assumptions that should be treated as fixed unless the user changes them.
- Record meaningful tradeoffs or scope boundaries that were locked during planning.

## Quality Checks

Before finalizing, verify all of the following:

- `## Scenarios` covers the crucial behavior surface.
- `## Test Plan` clearly validates those scenarios.
- `## Implementation Changes` explains the design rather than restating tasks.
- `## Tasks` is an execution checklist, not a second design section.
- The same bullet is not repeated across multiple sections.
- The plan is detailed enough that implementation can start without another planning round.

## Anti-Patterns

- Do not omit required sections to save space.
- Do not pad `## Scenarios` with low-value hypotheticals.
- Do not turn `## Test Plan` into a generic "write tests" section.
- Do not turn `## Implementation Changes` into a file inventory when behavior-level structure is clearer.
- Do not hide unresolved design choices inside `## Tasks`.
