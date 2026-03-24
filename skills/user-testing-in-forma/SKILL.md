---
name: user-testing-in-forma
description: Use when wireframes exist and you need to validate the design against realistic user behavior before implementation
---

**Workflow context:** Typically follows wireframing-in-forma. Reads `wireframes.md` and `concept.md` if available; can also test screenshots or descriptions provided directly. Produces `test-results.md` and `personas.md`.

You are simulating real users walking through a design for the first time. Not a heuristic review. Not a checklist. You are inhabiting specific personas and reporting what they would actually do, miss, struggle with, and say.

## Personas

Check for `personas.md` in the current directory, then the parent directory (`../personas.md`).

**If found:** Read and use them. Briefly list the personas at the start of the output so the user can verify they're still appropriate.

**If not found:** Read `brief.md` and `concept.md` (and any other available artifacts) from the current directory and generate 2 personas. Add a third only if the product serves distinct user segments with conflicting needs (e.g., creator vs. consumer, admin vs. end-user). Save to `personas.md` before running the walkthrough. After first run, the project owns its personas — consistent testing across iterations.

**Persona format** (use this exact structure in `personas.md`):

```
## {Name}
- **Role:** {job title or archetype}
- **Key trait:** {one behavioral trait, e.g., "skims before committing"}
- **Orientation:** {trust-first or speed-first}
- **Current workflow:** {what they do today without this product}
- **Usage context:** {when/where/how often they'd use this}
```

## Input

Check for `wireframes.md` in the current directory. If found, use it. Also check for `concept.md` — if found, use the key bet as a validation target.

If no wireframes file exists, the user must provide one of:
- A text description of the screens and layout
- Screenshots pasted into the conversation
- Inline wireframes in their message

If no concept.md exists, skip key-bet validation — focus the test on usability and task completion instead.

## Adaptive screens

Before testing, scan the wireframe for adaptive elements (personalized content, role-based views, conditional copy). If found:

1. **Construct per-persona views.** Describe what each persona would actually see — their topics, copy variant, data state. Don't test all personas against the single static wireframe.
2. **Label findings as structure or content.** Structure = layout, hierarchy, navigation (same for all). Content = copy, topics, curation (varies per user).
3. **Flag untested personalization.** If adaptive elements exist but per-persona variants aren't specified, say so.

## Versioning

Always write to `test-results.md`. Before writing, if `test-results.md` exists AND wireframes have changed since the last test run, move it to `archive/test-results-v{N}.md` (N = count of existing `archive/test-results-v*.md` files + 1). Create `archive/` if needed. If re-running against the same wireframes, overwrite in place.

Start the file with `# Test Results v{N}` (N = count of existing archive files + 1). Next line: `**Tested against:** wireframes v{M}` (from the `# Wireframes v{M}` header in `wireframes.md`).

## Output

Mentally walk through each screen per persona — first impressions, task attempts, friction, what they'd say. This walkthrough is your raw material; do not output it. Synthesize into these sections:

### Action items

Three subsections (omit any that would be empty). Number items sequentially as AI-{n} — stable IDs across iterations.

Each item gets 1–2 evidence bullets. Format:
```
- **AI-{n}.** Brief description — why it matters.
  - *Evidence:* Persona (trait) observed behavior or failure.
```

- **Resolved from previous test:** Items the current wireframes addressed. Preserve original AI-{n} IDs. (Empty on first run.)
- **Remaining issues:** Items still present from prior tests. Preserve IDs, re-state why each matters. (Empty on first run.)
- **New findings:** Issues found in this test. On first run, all items go here. On subsequent runs, continue numbering from max prior ID + 1.

### What works

Short list of design positives grounded in persona behavior. Format:
```
- **Short label.** What works and which persona behavior confirms it.
```

### Consensus issues

Problems multiple personas hit. Numbered list with evidence. Below each, an indented sub-bullet: ***Fix now*** or ***Defer*** leading the line, with short rationale.

### Highest-leverage fix

One bolded recommendation with 2–4 bullets on what it accomplishes. End with a readiness assessment: where the design stands and a clear next step. If concept.md included a key bet, report whether the walkthroughs validated or contradicted it.

### Adoption

One line per persona:
```
- **Persona name:** Adopts / Hesitant / Unlikely — reason tied to their current workflow.
```

## Rules

- Be direct. No preamble, no filler.
- Every observation must be grounded in a specific persona's behavior pattern and the specific design being tested — no generic usability feedback.
- If the design is too vague to simulate a walkthrough, say so and ask for specifics. Don't fake it.
- Don't soften the findings. If the design has a fundamental problem, say it directly.

After producing the output, immediately save test results to test-results.md (and `personas.md` if generated).

$ARGUMENTS
