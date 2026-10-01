#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

TESTCASE="${1:-apb_smoke_basic_rw}"
SEED="${2:-101}"

"$SCRIPT_DIR/run_one_test.sh" \
  --mode manual \
  --testcase "$TESTCASE" \
  --seed "$SEED" \
  --log-dir "$BASE_DIR/run_logs/manual"

echo "Manual run completed for testcase=$TESTCASE seed=$SEED"
