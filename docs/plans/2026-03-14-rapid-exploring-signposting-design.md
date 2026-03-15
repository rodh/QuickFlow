# ~~Design: Elevate rapid-exploring as the recommended post-concept path~~

> **Superseded.** Rapid-exploring has been merged into concept-forming and the separate skill deleted. The choice point described below no longer exists — concept-forming now auto-develops all approaches to wireframe depth by default. See the updated `skills/concept-forming/SKILL.md`.

## Problem

After concept-forming presents approaches, rapid-exploring exists as an alternative path but is never surfaced. The user has to already know it exists and manually invoke it, breaking out of concept-forming's dialogue flow.

## Decision

Add an explicit choice point in concept-forming after Step 1 (approaches presented). Rapid-explore is the recommended default. Manual dialogue becomes the fallback for when the user already has a strong instinct.

## Approach: Choice point in concept-forming

After Step 1 presents approaches and saves `approaches.md`, replace "which approach resonates?" with:

> How do you want to proceed?
> - **Rapid-explore** — auto-develop all approaches to wireframe depth, then compare and combine (recommended)
> - **Pick [Approach Name]** — develop one through dialogue
> - **Explore [Approach Name]** — dig deeper into one before committing
> - **Branch** — create parallel design pipelines

- Rapid-explore listed first, marked as recommended
- Non-specific responses ("go," "proceed") default to rapid-explore
- Concept-forming Steps 2-4 (tensions, concept direction, save) only run if user picks a specific approach
- Exploration mode stays as-is

## Changes

| File | Change |
|---|---|
| `skills/concept-forming/SKILL.md` | Replace "which approach resonates?" with explicit choice point after Step 1. Rapid-explore first as recommended. Non-specific responses default to rapid-explore. |
| `docs/philosophy.md` | Reorder rapid-explore before explore. Note it as the default path after concept-forming. |
| `docs/guide.md` | Update concept-forming description to mention choice point. Move rapid-exploring paragraph after concept-forming. |
| `docs/quickstart.md` | Update default flow to show rapid-exploring in the pipeline. |

## What doesn't change

- `skills/rapid-exploring/SKILL.md` — unchanged
- `skills/wireframing/SKILL.md` — unchanged
- All four paths remain available — this is signposting, not removal
