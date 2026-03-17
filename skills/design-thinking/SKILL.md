---
name: design-thinking
description: Think through a hunch, explore a what-if, or decide between options — mid-process structured thinking that reads your design artifacts and optionally updates them
---

**Workflow context:** Lateral skill — can be invoked at any point in the design process. Reads existing artifacts, structures thinking, optionally modifies artifacts with approval.

## 1. Scan artifacts

Read all design files in the current directory: `brief.md`, `concept.md`, `wireframes.md`, `test-results.md`, `personas.md`, plus the most recent session note in `sessions/`. Establish what exists and what stage the design is at.

## 2. Frame

Detect mode from `$ARGUMENTS` or the user's opening statement.

**Vague instinct ("something feels off"):**
- Present a compact design state summary (one sentence per artifact)
- Ask "what's nagging you?" — open-ended
- Allow 1-2 rounds to get from vague → specific
- Surface tensions in the existing artifacts as options if the user can't articulate it
- **Output:** a precise statement of the issue

**What-if ("what if we tried..."):**
- Restate the idea as a testable proposition
- One quick check: "Is that a fair restatement?" (skip if clearly accurate)
- **Output:** the proposition to trace

**Decision ("should we X or Y"):**
- Acknowledge the options. If only one stated, ask for the alternative.
- Frame as "[X] vs [Y] given [relevant context from artifacts]"
- **Output:** the framed decision

**STOP after Frame.** Present the framed question and wait for the user to confirm or adjust before proceeding to Think. Do not deliver Frame and Think in the same response.

If ambiguous, ask one AskUserQuestion with three labeled options:
- **A. Surface something** — a hunch or instinct you want to explore
- **B. Explore a what-if** — trace a specific idea through the design
- **C. Decide between options** — compare alternatives and commit

If during framing it becomes clear the user needs a different skill (e.g., they need to re-run user-testing), say so directly and suggest the appropriate skill.

## 3. Think

Four-part analysis against the framed question:

1. **What the artifacts say** — pull relevant content, quote specific lines/sections
2. **What's at stake** — concrete downstream effects on each artifact if we go one way vs another
3. **Strongest argument for each side** — steel-man all positions (even for hunches: steel-man "it's actually fine" vs "there's a real problem")
4. **What we'd need to believe** — the assumption about user behavior each direction rests on

**Dialogue within Think:**
- Vague instinct: pause after presenting tensions, check in after each piece of analysis. 2-3 exchanges total.
- What-if: deliver the four-part analysis as one block, then stop and ask "worth pursuing or dead end?"
- Decision: deliver the four-part analysis as one block, then stop and ask "which way are you leaning?" Pressure-test their answer briefly before moving to Act.

Each pause means **stop and wait for the user's response** — do not continue to the next phase in the same message.

## 4. Act

If thinking leads to artifact changes:
- List each file and the specific change proposed
- Get approval per file via AskUserQuestion (approve / reject / modify)
- On approval: apply changes, increment version header if applicable, append entry to `design-log.md`
- If no changes needed: skip to Capture

## 5. Capture

Write session note to `sessions/YYYY-MM-DD-HHMM.md`:

- **Session summary** — 2-3 sentences
- **Trigger** — the user's opening statement
- **Frame** — the precise question arrived at
- **Analysis** — key points from Think (compressed, not the full analysis)
- **Resolution** — what was decided
- **Artifact changes** — what was modified, or "None"
- **Open threads** — anything surfaced but not resolved

Create the `sessions/` directory if it doesn't exist.

## Rules

- Be direct. No preamble, no filler.
- Dialogue scales with ambiguity: vague inputs get more back-and-forth, clear inputs get autonomous analysis.
- Quote artifacts, don't summarize — the user needs to see exactly what you're referencing.
- Steel-man all positions. Don't lead the user toward a predetermined answer.
- YAGNI: if the thinking resolves without needing artifact changes, don't invent changes to make.
- If the thinking reveals an upstream problem (concept-level, not wireframe-level), name it. Don't patch downstream artifacts to work around a concept issue.
- One precise statement anchors the whole session. If Frame fails to produce one, keep asking until it does.
- Labeled bullets for discrete items, prose for narrative.
- **Never deliver Frame and Think in the same response.** Frame produces a question; wait for confirmation. Think produces analysis; wait for a reaction. Each phase ends with the user's input before the next begins.

$ARGUMENTS
