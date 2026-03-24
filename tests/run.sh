#!/usr/bin/env bash
# run.sh — Test orchestrator for Forma
set -euo pipefail

TESTS_DIR="$(cd "$(dirname "$0")" && pwd)"

usage() {
  echo "Usage: ./tests/run.sh [structural|quality <dir>|all <dir>]"
  echo ""
  echo "  (no args)        Run structural checks only"
  echo "  structural       Run structural checks only"
  echo "  quality <dir>    Run quality checks on an autorun output directory"
  echo "  all <dir>        Run both structural and quality checks"
  exit 1
}

run_structural() {
  echo "=== Structural checks ==="
  bash "$TESTS_DIR/structural.sh"
}

run_quality() {
  local dir="${1:?quality requires a run directory}"
  echo "=== Quality checks ==="
  bash "$TESTS_DIR/quality.sh" "$dir"
}

MODE="${1:-structural}"
total_exit=0

case "$MODE" in
  structural)
    run_structural || total_exit=1
    ;;
  quality)
    run_quality "${2:-}" || total_exit=1
    ;;
  all)
    run_structural || total_exit=1
    echo ""
    run_quality "${2:-}" || total_exit=1
    ;;
  *)
    usage
    ;;
esac

exit $total_exit
