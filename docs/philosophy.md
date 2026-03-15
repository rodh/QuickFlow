# Design Philosophy

Why Forma works the way it does.

For an overview of the system — stage mechanics, dialogue patterns — see the [Guide](guide.md).

---

## Design principles

### Design is thinking, not decoration

Most design tools optimize for pixels. Forma optimizes for decisions. The system treats design as a sequence of increasingly specific commitments — from problem framing to interaction model to screen structure — where each stage forces a decision before the next one begins.

This is deliberate. Jumping to wireframes before articulating the core interaction model produces layouts that look reasonable but encode no real design bet. The workflow prevents this by making the concept direction explicit and reviewable before any structure gets drawn.

### Opinionated defaults, flexible execution

The workflow has a design flow (design-briefing → concept-forming → user-testing → [wireframing ↔ user-testing]) that produces tested wireframes.

You can run the full pipeline end-to-end, skip stages that don't apply, or jump in at any point. A wireframe doesn't require a brief to exist first. Running user-testing on screenshots you already have is perfectly valid. The workflow is a recommended sequence, not a gate.

But when a stage runs, it runs with opinion. concept-forming doesn't present neutral options — it names what each approach prioritizes, what it sacrifices, and when it breaks. user-testing doesn't produce generic usability feedback — it simulates specific people with specific behaviors encountering the design for the first time. The system would rather be wrong and specific than right and vague.

### Artifacts over conversations

Every stage writes a file. Brief, concept, wireframes, test results — each is a durable artifact that persists across sessions and can be read by anyone (or any agent) without context from the conversation that produced it.

This matters because design work is interrupt-heavy. You shape a concept on Monday, wireframe on Wednesday, test on Friday. The artifacts carry the thinking forward so you don't re-derive decisions. Session debriefs capture the rest — the rejected directions, the open questions, the insights that didn't fit neatly into a formal artifact.

### Specificity over flexibility

Good design direction is specific. "Batch-action queue with exception handling" is useful. "Clean, intuitive interface" is not. Every stage in the system pushes toward concrete, falsifiable statements — a concept direction names its key bet and the assumption it rests on, wireframes commit to specific screen structures, test results validate against specific behavior patterns.

This specificity makes the output actionable downstream. A coding agent can build from "tabbed inbox with a badge count on unread, batch-select via long-press, swipe-to-archive." It can't build from "easy-to-use message management."

### Honest feedback, not validation

The system is built to challenge, not confirm. concept-forming pressure-tests your direction by naming what it sacrifices and when it breaks. user-testing simulates real users who miss things, get confused, and say blunt things — it tests with behavior patterns, not opinion. Each persona encounters the design based on how they actually use software, not what they'd say in a survey. If a wireframe has a fundamental problem, the system says so directly rather than softening the finding.

This extends to knowing when to stop. Commands flag diminishing returns when iteration stops producing structural improvements. Three rounds of wireframe changes is the explicit cap — if the structure isn't converging by then, the problem is upstream in an ambiguous concept, not downstream in layout tweaks. The system tells you to re-run concept-forming rather than continuing to adjust wireframes past the point of structural return.

### Design decisions should be traceable

Every concept names its key bet — the assumption about user behavior that the whole design rests on. Test results explicitly validate or contradict that bet. Session debriefs log what was decided and what was rejected.

This traceability isn't bureaucracy. It's insurance against the most common failure mode in design: forgetting why something was decided and revisiting it endlessly. When you can point to "we chose this because [reason], validated by [test result]," the design stays coherent through iteration.

---

## Why ASCII wireframes

The choice of ASCII art for wireframes is philosophical, not technical.

ASCII wireframes are intentionally low-fidelity. You can't fall in love with a layout drawn in box-drawing characters. There's no color to debate, no border radius to bikeshed, no font pairing to agonize over. The medium forces attention on what matters at the wireframing stage: information hierarchy, interaction flow, and screen structure.

They're also fast — both to generate and to iterate on. An AI agent produces a full set of ASCII wireframes in seconds, not the minutes-to-hours a visual tool demands. When a test walkthrough surfaces a structural problem, you re-run wireframing and have a revised layout moments later. That speed changes how you work: you stop protecting wireframes from criticism because replacing them costs almost nothing. Iteration becomes the default rather than a concession.

There's a practical benefit too. ASCII wireframes live in the same medium as everything else — markdown files in the terminal. They're versionable with git, diffable in pull requests, and readable by AI agents. The wireframes need to be text to flow through the design workflow.

---

## Concept-forming and the iteration loop

Concept-forming handles the full path from approaches to wireframes. It presents 2-3 genuinely different directions, then auto-develops all of them — resolving tensions autonomously, generating concept directions, and producing full ASCII wireframes for each. You compare the materialized approaches and pick one or combine elements from several. The result promotes to `concept.md` and `wireframes.md`.

If you already know which direction you want, name the approach directly and concept-forming develops it through dialogue instead — working through tensions and concept direction interactively before saving.

After concept-forming produces wireframes, the iteration loop takes over: run user-testing to surface usability issues, then wireframing to fix them, then user-testing again. Repeat until the design is stable. Wireframing becomes a refinement tool at this stage, not initial generation — concept-forming already handled that.
