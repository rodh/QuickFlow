# Forma

**Opinionated design thinking skills for AI agents.**

Forma gives your AI coding agent a design thinking workflow — frame problems, explore solutions, wireframe interfaces, test with simulated users, and iterate on what you've built. Works with Claude Code, Codex, and any AI coding agent that reads markdown.

It runs as an opinionated workflow: each stage produces a persistent artifact that survives across sessions and engages in structured dialogue rather than one-shot generation. Run the stages in order, or jump to the one you need — the workflow adapts either way. You pick up any design exactly where you left off.

## Install

### Claude Code

```sh
git clone https://github.com/rodh/Forma.git ~/.local/share/forma
for skill in ~/.local/share/forma/skills/*-in-forma; do
  ln -s "$skill" ~/.claude/skills/$(basename "$skill")
done
```

Each skill must be a direct child of `~/.claude/skills/` so Claude Code can discover it. Symlinks keep them updatable with `git pull`.

### Codex CLI

```sh
git clone https://github.com/rodh/Forma.git ~/.local/share/forma
for skill in ~/.local/share/forma/skills/*-in-forma; do
  ln -s "$skill" ~/.codex/skills/$(basename "$skill")
done
```

Each skill must be a direct child of `~/.codex/skills/` so Codex can discover it. Symlinks keep them updatable with `git pull`.

## Skills

> Skill names shown without prefix. Use `/` for Claude Code, `$` for Codex CLI.

### Design loop

| Skill | What it does | Output |
|-------|-------------|--------|
| framing-in-forma | Distill raw context into a working brief through dialogue | `brief.md` |
| ideating-in-forma | Explore the solution space, develop all approaches to key-screen depth, pick or combine | `concept.md`, `approaches.md`, `exploration/` |
| wireframing-in-forma | Expand key screens into full-flow ASCII wireframes | `wireframes.md` |
| user-testing-in-forma | AI persona usability walkthroughs | `test-results.md`, `personas.md` |

### Iteration and session management

| Skill | What it does | Output |
|-------|-------------|--------|
| status-in-forma | Check status, resume, or create a design directory | — |
| log-in-forma | Capture session decisions and open threads | `sessions/YYYY-MM-DD-HHMM.md` |
| thinking-in-forma | Understand problems, evaluate effort, reason through design decisions | `sessions/YYYY-MM-DD-HHMM.md` |

## Example session

> **Platform syntax:** Claude Code uses `/skill-name`, Codex CLI uses `$skill-name`. This example uses `/` — swap for your platform's prefix.

```
▶ /framing-in-forma
  [notifications-requirements.md]  [current-save-flow.png]

  Teams need to be notified when a teammate saves content to a shared
  topic. Currently saves are silent. Want push + in-app notifications
  with controls to avoid noise.

  Before drafting — two questions:
  - Per-topic mute, global quiet hours, or both?
  - All shared topics notify by default, or opt-in?

> Per-topic mute only. Default on, opt-out.

  ✓ Brief saved → brief.md


▶ /ideating-in-forma

  Three directions:

  A. Activity feed — passive tab per topic.
     Low interruption, low timeliness.
  B. Smart digest — batched summary.
     Quiet, but delays awareness by hours.
  C. Notify-on-save — push per save, per-topic mute.
     Immediate, but noisier.

> Explore all three.

  I'll explore each approach with 1-2 key screens — enough to
  compare interaction models. Full wireframing comes after we
  lock a direction.

  A: New "Activity" tab            C: Inline notification banner
  ┌───────────────────────┐        ┌───────────────────────┐
  │ Design Systems        │        │ ┌───────────────────┐ │
  │ [Saves] [Activity]    │        │ │ Sarah saved "Q3   │ │
  │ ┌───────────────────┐ │        │ │ OKRs" [Mute▾] [x] │ │
  │ │ Sarah: Q3 OKRs    │ │        │ │ [View]             │ │
  │ │ 2h ago            │ │        │ └───────────────────┘ │
  │ │ James: Brand doc  │ │        │ ★ Design Systems  (3) │
  │ │ yesterday         │ │        │   Product Research (1)│
  │ └───────────────────┘ │        │   Brand Guidelines    │
  └───────────────────────┘        └───────────────────────┘

  B: Daily digest notification
  ┌───────────────────────┐
  │ Today's Activity      │
  │ ┌───────────────────┐ │
  │ │ Design Systems    │ │
  │ │ 3 new saves today │ │
  │ │ Product Research  │ │
  │ │ 1 new save today  │ │
  │ └───────────────────┘ │
  └───────────────────────┘

  Explored Activity feed — 1 key screen showing passive tab.
  Saved to exploration/activity-feed.md

  Explored Smart digest — 1 key screen showing batched summary.
  Saved to exploration/smart-digest.md

  Explored Notify-on-save — 1 key screen showing inline banner
  with mute. Saved to exploration/notify-on-save.md

  A and B are pull-based — user checks for updates.
  C is push-based — updates come to the user.

> C — mute controls inline is exactly right.

  ✓ Concept locked → concept.md
  Direction: notify-on-save with inline mute controls.
  Key bet: users will manage noise themselves if controls are
  within reach.

  → Next step: /wireframing-in-forma to build the full flow.


▶ /wireframing-in-forma

  Expanding key screens into full flow — notification banner,
  mute controls, topic list with badges, settings panel.

  ┌──────────────────────────────────┐
  │ ┌──────────────────────────────┐ │
  │ │ Sarah saved "Q3 OKRs"        │ │
  │ │ to Design Systems       [x]  │ │
  │ │  [View]  [Mute ▾]            │ │
  │ └──────────────────────────────┘ │
  │  ★ Design Systems            (3) │
  │    Product Research          (1) │
  │    Brand Guidelines              │
  └──────────────────────────────────┘
  + empty state, muted state, settings screens

  ✓ Full wireframes saved → wireframes.md


▶ /user-testing-in-forma

  3 personas walked through the design independently.
  Consensus issue: mute toggle is discoverable but "mute duration"
  isn't — all 3 expected a way to mute temporarily, not just on/off.
  Recommendation: add a duration picker (1h, 1d, forever) to the
  mute action.

  ✓ Test results saved → test-results.md


▶ /wireframing-in-forma fix the mute duration issue

  ┌──────────────────────────────────┐
  │ ┌──────────────────────────────┐ │
  │ │ Sarah saved "Q3 OKRs"        │ │
  │ │ to Design Systems       [x]  │ │
  │ │  [View]  [Mute ▾]            │ │
  │ │  ┌─────────────────────────┐ │ │
  │ │  │ Mute for 1 hour        │ │ │
  │ │  │ Mute for 1 day         │ │ │
  │ │  │ Mute forever           │ │ │
  │ │  └─────────────────────────┘ │ │
  │ └──────────────────────────────┘ │
  │  ★ Design Systems            (3) │
  │    Product Research          (1) │
  │    Brand Guidelines              │
  └──────────────────────────────────┘

  ✓ Wireframes updated → wireframes.md


▶ /user-testing-in-forma

  3 personas re-tested the updated wireframe.
  No critical issues. Minor: consider "Unmute" confirmation.

  ✓ Test results saved → test-results.md

  This cycle repeats as needed:

           │
           ▼
  ┌──────────────────────────┐◄─────┐
  │  wireframing-in-forma    │      │
  └────────────┬─────────────┘      │
               ▼                    │
  ┌──────────────────────────┐  ┌───┴─────────────┐
  │  user-testing-in-forma   │─►│ Issues found?   │
  └────────┬────────┘    │ Refine & retest │
           │              └─────────────────┘
           │ (passes)
           ▼
  ┌─────────────────────────────────┐
  │ Ready to implement              │
  │ → Hand off to your build tools  │
  └─────────────────────────────────┘
```

## Learn more

[Guide](docs/guide.md) — scenario patterns, design principles, and the full workflow

## License

MIT
