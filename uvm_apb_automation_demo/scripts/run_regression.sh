#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

TESTCASES=(
  apb_smoke_basic_rw
  apb_corner_waitstate_max
  apb_injected_protocol_violation
)

SEEDS=(101 202 303)
LOG_DIR="$BASE_DIR/run_logs/automated"
OUT_DIR="$BASE_DIR/outputs/real_regression"

mkdir -p "$LOG_DIR" "$OUT_DIR"

for tc in "${TESTCASES[@]}"; do
  for seed in "${SEEDS[@]}"; do
    echo "Running testcase=$tc seed=$seed"
    "$SCRIPT_DIR/run_one_test.sh" \
      --mode automated \
      --testcase "$tc" \
      --seed "$seed" \
      --log-dir "$LOG_DIR" || true
  done
done

python3 "$BASE_DIR/collect_metrics.py" --log-dir "$LOG_DIR" --out-dir "$OUT_DIR"

echo "Regression finished. Consolidated files:"
echo "- $OUT_DIR/regression_report.csv"
echo "- $OUT_DIR/summary_metrics.md"
