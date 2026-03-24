#!/usr/bin/env bash
# structural.sh — Deterministic lint checks for Forma skill definitions
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_DIR="$REPO_ROOT/skills"
PLUGIN_JSON="$REPO_ROOT/.claude-plugin/plugin.json"
README="$REPO_ROOT/README.md"

pass=0
fail=0

check() {
  local label="$1"
  shift
  if "$@" 2>/dev/null; then
    printf "  ✓ %s\n" "$label"
    pass=$((pass + 1))
  else
    printf "  ✗ %s\n" "$label"
    fail=$((fail + 1))
  fi
}

# --- Check 1: Plugin metadata ---
check_plugin_metadata() {
  [[ -f "$PLUGIN_JSON" ]] || return 1
  # Valid JSON with required fields
  python3 -c "
import json, sys
d = json.load(open('$PLUGIN_JSON'))
assert 'name' in d, 'missing name'
assert 'version' in d, 'missing version'
assert 'description' in d, 'missing description'
"
}
check "Plugin metadata (name, version, description)" check_plugin_metadata

# --- Check 2: Skill directories have SKILL.md ---
check_skill_dirs() {
  local missing=0
  for dir in "$SKILLS_DIR"/*-in-forma; do
    [[ -d "$dir" ]] || continue
    if [[ ! -f "$dir/SKILL.md" ]]; then
      printf "      missing: %s/SKILL.md\n" "$(basename "$dir")"
      missing=1
    fi
  done
  return $missing
}
check "Every skill dir has SKILL.md" check_skill_dirs

# --- Check 3: Frontmatter fields ---
check_frontmatter() {
  local bad=0
  for skill in "$SKILLS_DIR"/*-in-forma/SKILL.md; do
    [[ -f "$skill" ]] || continue
    local name=$(basename "$(dirname "$skill")")
    # Extract frontmatter between --- delimiters
    local fm
    fm=$(sed -n '/^---$/,/^---$/p' "$skill")
    if ! echo "$fm" | grep -q '^name:'; then
      printf "      %s: missing 'name' in frontmatter\n" "$name"
      bad=1
    fi
    if ! echo "$fm" | grep -q '^description:'; then
      printf "      %s: missing 'description' in frontmatter\n" "$name"
      bad=1
    fi
  done
  return $bad
}
check "Frontmatter has name and description" check_frontmatter

# --- Check 4: Name consistency ---
check_name_consistency() {
  local bad=0
  for skill in "$SKILLS_DIR"/*-in-forma/SKILL.md; do
    [[ -f "$skill" ]] || continue
    local dir_name=$(basename "$(dirname "$skill")")
    local fm_name
    fm_name=$(awk '/^---$/{c++; next} c==1 && /^name:/{sub(/^name: */, ""); print; exit}' "$skill")
    if [[ "$fm_name" != "$dir_name" ]]; then
      printf "      %s: frontmatter name is '%s'\n" "$dir_name" "$fm_name"
      bad=1
    fi
  done
  return $bad
}
check "Frontmatter name matches directory name" check_name_consistency

# --- Check 5: $ARGUMENTS placeholder ---
check_arguments() {
  local bad=0
  for skill in "$SKILLS_DIR"/*-in-forma/SKILL.md; do
    [[ -f "$skill" ]] || continue
    local name=$(basename "$(dirname "$skill")")
    if ! grep -q '\$ARGUMENTS' "$skill"; then
      printf "      %s: missing \$ARGUMENTS\n" "$name"
      bad=1
    fi
  done
  return $bad
}
check "Each SKILL.md contains \$ARGUMENTS" check_arguments

# --- Check 6: README ↔ skills sync ---
check_readme_sync() {
  local bad=0
  # Skill dirs that exist
  local dirs=()
  for dir in "$SKILLS_DIR"/*-in-forma; do
    [[ -d "$dir" ]] && dirs+=("$(basename "$dir")")
  done
  # Skills mentioned in README tables (lines with | skill-name |)
  local readme_skills=()
  while IFS= read -r line; do
    readme_skills+=("$line")
  done < <(grep -oE '[a-z]+(-[a-z]+)*-in-forma' "$README" | sort -u)

  # Every dir should appear in README
  for d in "${dirs[@]}"; do
    local found=0
    for r in "${readme_skills[@]}"; do
      [[ "$r" == "$d" ]] && found=1 && break
    done
    if [[ $found -eq 0 ]]; then
      printf "      %s: directory exists but not in README\n" "$d"
      bad=1
    fi
  done
  # Every README skill should have a directory
  for r in "${readme_skills[@]}"; do
    if [[ ! -d "$SKILLS_DIR/$r" ]]; then
      printf "      %s: in README but no directory\n" "$r"
      bad=1
    fi
  done
  return $bad
}
check "README ↔ skills directory sync" check_readme_sync

# --- Check 7: Cross-references ---
check_cross_refs() {
  local bad=0
  for skill in "$SKILLS_DIR"/*-in-forma/SKILL.md; do
    [[ -f "$skill" ]] || continue
    local name=$(basename "$(dirname "$skill")")
    # Find references to other *-in-forma skills
    while IFS= read -r ref; do
      [[ "$ref" == "$name" ]] && continue
      if [[ ! -d "$SKILLS_DIR/$ref" ]]; then
        printf "      %s references non-existent %s\n" "$name" "$ref"
        bad=1
      fi
    done < <(grep -oE '[a-z]+(-[a-z]+)*-in-forma' "$skill" | sort -u)
  done
  return $bad
}
check "Cross-references point to existing skills" check_cross_refs

# --- Check 8: Wireframe conventions ---
check_wireframe_conventions() {
  [[ -f "$SKILLS_DIR/wireframing-in-forma/wireframe-conventions.md" ]]
}
check "wireframe-conventions.md exists" check_wireframe_conventions

# --- Summary ---
echo ""
printf "Structural: %d passed, %d failed\n" "$pass" "$fail"
[[ $fail -eq 0 ]]
