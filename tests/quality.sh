#!/usr/bin/env bash
# quality.sh — Validate autorun output against expected structure
set -euo pipefail

RUN_DIR="${1:?Usage: quality.sh <run-dir>}"

if [[ ! -d "$RUN_DIR" ]]; then
  echo "Error: directory not found: $RUN_DIR"
  exit 1
fi

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

# --- Check 1: Root files exist ---
check_root_files() {
  local bad=0
  for f in brief.md approaches.md personas.md run-summary.md; do
    if [[ ! -f "$RUN_DIR/$f" ]]; then
      printf "      missing: %s\n" "$f"
      bad=1
    fi
  done
  return $bad
}
check "Root files (brief, approaches, personas, run-summary)" check_root_files

# --- Check 2: Approach subdirs ---
check_approach_subdirs() {
  local found=0
  for dir in "$RUN_DIR"/*/; do
    [[ ! -d "$dir" ]] && continue
    local name=$(basename "$dir")
    # Skip non-approach dirs (sessions, archive, etc.)
    [[ "$name" == sessions || "$name" == archive ]] && continue
    local ok=1
    for f in concept.md wireframes.md test-results.md; do
      [[ ! -f "$dir/$f" ]] && ok=0
    done
    if [[ $ok -eq 1 ]]; then
      ((found++))
    else
      local missing=""
      for f in concept.md wireframes.md test-results.md; do
        [[ ! -f "$dir/$f" ]] && missing="$missing $f"
      done
      printf "      %s: missing%s\n" "$name" "$missing"
    fi
  done
  [[ $found -ge 1 ]]
}
check "At least 1 approach subdir with concept, wireframes, test-results" check_approach_subdirs

# --- Check 3: Brief sections ---
check_brief_sections() {
  local brief="$RUN_DIR/brief.md"
  [[ -f "$brief" ]] || return 1
  local bad=0
  for section in "Problem" "Who feels this" "Known constraints" "Open questions" "First instinct"; do
    if ! grep -qi "$section" "$brief"; then
      printf "      missing section: %s\n" "$section"
      bad=1
    fi
  done
  return $bad
}
check "Brief has required sections" check_brief_sections

# --- Check 4: Wireframe structure ---
check_wireframe_structure() {
  local bad=0
  local checked=0
  for wf in "$RUN_DIR"/*/wireframes.md; do
    [[ -f "$wf" ]] || continue
    checked=1
    local name=$(basename "$(dirname "$wf")")
    # Version header
    if ! grep -q '^# Wireframes v' "$wf"; then
      printf "      %s: missing version header\n" "$name"
      bad=1
    fi
    # Box-drawing characters
    if ! grep -q '[┌┐└┘│─┬┴├┤╭╮╰╯]' "$wf"; then
      printf "      %s: no box-drawing characters\n" "$name"
      bad=1
    fi
    # Component labels: // [A-Z][0-9]
    if ! grep -qE '// [A-Z][0-9]' "$wf"; then
      printf "      %s: no component labels (// A1 format)\n" "$name"
      bad=1
    fi
  done
  [[ $checked -ge 1 ]] && return $bad
  printf "      no wireframes.md files found\n"
  return 1
}
check "Wireframe structure (version, box-drawing, labels)" check_wireframe_structure

# --- Check 5: Test results structure ---
check_test_results() {
  local bad=0
  local checked=0
  for tr in "$RUN_DIR"/*/test-results.md; do
    [[ -f "$tr" ]] || continue
    checked=1
    local name=$(basename "$(dirname "$tr")")
    # Version header
    if ! grep -q '^# .*v[0-9]' "$tr"; then
      printf "      %s: missing version header\n" "$name"
      bad=1
    fi
    # Required content markers
    for marker in "Tested against" "Action items" "What works" "Consensus issues" "Highest-leverage fix" "Adoption"; do
      if ! grep -qi "$marker" "$tr"; then
        printf "      %s: missing '%s'\n" "$name" "$marker"
        bad=1
      fi
    done
  done
  [[ $checked -ge 1 ]] && return $bad
  printf "      no test-results.md files found\n"
  return 1
}
check "Test results structure" check_test_results

# --- Check 6: Personas format ---
check_personas() {
  local pf="$RUN_DIR/personas.md"
  [[ -f "$pf" ]] || return 1
  # At least 2 ## Name headings
  local count
  count=$(grep -cE '^## ' "$pf" || true)
  if [[ $count -lt 2 ]]; then
    printf "      only %d persona headings (need >= 2)\n" "$count"
    return 1
  fi
  # Each persona should have Role, Key trait, Orientation
  local bad=0
  for field in "Role" "Key trait" "Orientation"; do
    local field_count
    field_count=$(grep -ci "$field" "$pf" || true)
    if [[ $field_count -lt 2 ]]; then
      printf "      '%s' appears %d times (need >= 2)\n" "$field" "$field_count"
      bad=1
    fi
  done
  return $bad
}
check "Personas format (headings, fields)" check_personas

# --- Check 7: Run summary sections ---
check_run_summary() {
  local rs="$RUN_DIR/run-summary.md"
  [[ -f "$rs" ]] || return 1
  local bad=0
  for section in "Approach comparison" "Key bets" "Recommendation" "Decision trail" "Items for review" "Action items"; do
    if ! grep -qi "$section" "$rs"; then
      printf "      missing section: %s\n" "$section"
      bad=1
    fi
  done
  return $bad
}
check "Run summary has required sections" check_run_summary

# --- Summary ---
echo ""
printf "Quality: %d passed, %d failed\n" "$pass" "$fail"
[[ $fail -eq 0 ]]
