---
name: autorun-in-forma
description: Use when you want a complete first-draft design from raw context — runs the full pipeline autonomously and produces all artifacts end-to-end without interaction
---

**Workflow context:** Autonomous alternative to the interactive pipeline. Takes raw context, produces a timestamped directory with brief, approaches, personas, per-approach wireframes + test results, and a comparative summary. No user interaction during the run.

## Input

The user provides raw context — the same messy input framing-in-forma accepts. If no input is provided after the skill name, ask once: "What are you designing? Paste raw context — tickets, requirements, notes, anything."

## Decision protocol

Every autonomous decision gets documented with: what was decided, alternatives considered, reasoning, and a confidence tag — **[confident]** (input strongly implied the choice) or **[review]** (genuinely competing options, user should verify).

## Pipeline

Create a timestamped directory: `run-YYYY-MM-DD-HHMM/`. All artifacts go inside it.

### Phase 1 — Frame

Read raw input. Infer answers to gaps from available context. State assumptions explicitly. Produce `brief.md` in the standard framing-in-forma format (problem, who feels this, constraints, what we know, open questions, first instinct). Auto-resolve open questions using the decision protocol — document each resolution inline.

Save `brief.md` at the run root.

### Phase 2 — Ideate

Read `brief.md`. Auto-resolve any remaining open questions using the decision protocol. Generate 2-3 approaches with distinct interaction models — different trade-offs, not UI variations. For each approach, auto-resolve tensions and generate a concept direction (core interaction, key bet, biggest risk).

Save `approaches.md` at the run root. Save `concept.md` inside each approach subdirectory (`{approach-slug}/concept.md`).

### Phase 3 — Generate personas

Generate 2-3 personas from `brief.md`. Each persona gets: name, role, key behavioral trait, trust/speed orientation, current workflow, usage context.

Save `personas.md` at the run root. All approaches are tested against the same personas.

### Phase 4 — Per-approach pipeline

Process all approaches — each is independent with its own subdirectory and no shared mutable state. Agents that support parallelism (e.g., Claude Code subagents) should run approaches concurrently.

For each approach:

1. **Wireframe.** Generate full ASCII wireframes per `wireframe-conventions.md` from the approach's `concept.md`. Save `wireframes.md` in the approach subdirectory.
2. **Test.** Run persona walkthroughs per `test-output-format.md` using shared `personas.md`. Save `test-results.md` in the approach subdirectory.
3. **Iterate (cap: 1 cycle).** If any consensus issues are tagged "Fix now", revise wireframes and retest. Save updated files in the same subdirectory. If the second test still has Fix Now items, note as unresolved and stop.

### Phase 5 — Summarize

Produce `run-summary.md` at the run root with these sections:

- **Approach comparison.** One-line concept per approach, how each tested, key structural differences.
- **Key bets.** Which bets validated vs. failed per approach.
- **Recommendation.** Which approach tested strongest, or suggested combination.
- **Decision trail.** Table: phase, decision, alternatives, reasoning, confidence tag.
- **Items for review.** All [review]-tagged decisions as a scannable checklist.
- **Unresolved issues.** Remaining Fix Now items across approaches after iteration cap.

## Directory structure

```
run-YYYY-MM-DD-HHMM/
  brief.md
  approaches.md
  personas.md
  {approach-slug}/
    concept.md
    wireframes.md
    test-results.md
  {approach-slug}/
    ...
  run-summary.md
```

## Rules

- No user interaction during the run. Auto-resolve everything, document everything.
- Approach slugs are kebab-case derived from the approach name.
- Wireframes must meet wireframing-in-forma quality standard — full ASCII, realistic placeholders, labeled screens, state variations. Not sketches.
- Persona walkthroughs must follow test-output-format.md structure.
- If upstream context includes `personas.md` in the current directory, use those personas instead of generating new ones.
- Each approach subdirectory is a valid working directory for interactive skills — users can `cd` into one and run wireframing-in-forma or user-testing-in-forma to iterate further.

## Raw context

$ARGUMENTS
