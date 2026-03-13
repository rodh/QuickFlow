# Skill Test Findings — 2026-03-12

Subagent tests run against all four design pipeline skills after the optimization pass.

## wireframe-conventions.md — 3 fixes needed

### 1. Add worked nesting example (High)
The nesting rule says "at least 1 space of padding on each side" but doesn't show how inner/outer rulers interact. Add a worked example with arithmetic:
- Outer = 72 chars total (`┌` + 70 `─` + `┐`)
- 2 spaces left padding, 4 spaces right padding = 64-char inner box
- Inner = `┌` + 62 `─` + `┐`
- Full line: `│` + 2 spaces + inner content (64 chars) + 4 spaces + `│` = 72

### 2. Clarify width tier specification (Medium)
Change "Standard (~72 chars)" to be explicit: "The ruler line (top border) is exactly 72 characters: `┌` + 70 `─` + `┐`." The `~` is ambiguous when alignment rules demand exact counts.

### 3. Add multi-line text area notation (Medium)
Interactive elements define single-line inputs but not text areas. Add a convention, e.g., represent as a nested box with placeholder text.

### Lower priority
- Clarify annotation placement with nested boxes: "after outermost right border"
- Note that `//` inside content (e.g., URLs) is not an annotation
- Clarify spacing when section labels follow separators

### Note on LLM alignment accuracy
The test agent failed character-exact alignment on its first two attempts. This is an inherent LLM limitation — the conventions are correct but compliance is hard. Consider adding a reference wireframe with annotated character counts as a calibration aid.

## test-output-format.md — 1 fix needed

### Clarify action items scope (Medium)
Current text says: "Every 'fix now' consensus issue, most impactful first."

The test agent interpreted this as consensus items PLUS high-impact single-persona findings. Clarify whether action items are:
- **(a)** Strictly consensus "fix now" items only, OR
- **(b)** All "fix now" items including single-persona issues that are high-impact enough to warrant action

Recommendation: option (b) — single-persona issues can be critical if that persona represents a large segment.

## concept-forming — optional improvement

No guidance on how many tensions to present. A "2-5 tensions" range would help calibrate without being rigid.

## design-briefing — no changes needed

Condensed triage rubric tested well on thin input. The "proportional to gaps" instruction outperformed the old Rich/Moderate/Thin rubric.
