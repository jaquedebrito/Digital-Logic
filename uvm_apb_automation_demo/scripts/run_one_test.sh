#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
RTL_FILE="$BASE_DIR/rtl/apb_simple_slave.sv"
TB_FILE="$BASE_DIR/tb/tb_apb_simple_slave.sv"

TESTCASE="${TESTCASE:-apb_smoke_basic_rw}"
SEED="${SEED:-101}"
MODE="${MODE:-manual}"
LOG_DIR="${LOG_DIR:-$BASE_DIR/run_logs/$MODE}"
WORK_DIR="${WORK_DIR:-$BASE_DIR/.sim_work}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --testcase) TESTCASE="$2"; shift 2 ;;
    --seed) SEED="$2"; shift 2 ;;
    --mode) MODE="$2"; shift 2 ;;
    --log-dir) LOG_DIR="$2"; shift 2 ;;
    --work-dir) WORK_DIR="$2"; shift 2 ;;
    *) echo "Unknown arg: $1"; exit 2 ;;
  esac
done

mkdir -p "$LOG_DIR" "$WORK_DIR"

SIM_LOG="$WORK_DIR/${TESTCASE}_seed${SEED}.sim.log"
STD_LOG="$LOG_DIR/${TESTCASE}_seed${SEED}.log"
START_TIME="$(date -u +"%Y-%m-%dT%H:%M:%S")"
OP_ERROR="NONE"
SIM_STATUS=""
SUMMARY_LINE=""

run_with_xrun() {
  xrun -clean -sv "$RTL_FILE" "$TB_FILE" \
    +TESTCASE="$TESTCASE" +SEED="$SEED" \
    -l "$SIM_LOG"
}

run_with_iverilog() {
  local exe="$WORK_DIR/tb_${TESTCASE}_seed${SEED}.out"
  iverilog -g2012 -o "$exe" "$RTL_FILE" "$TB_FILE"
  vvp "$exe" > "$SIM_LOG" 2>&1
}

if command -v xrun >/dev/null 2>&1; then
  if ! run_with_xrun; then
    OP_ERROR="EXEC_ABORTED"
  fi
elif command -v iverilog >/dev/null 2>&1 && command -v vvp >/dev/null 2>&1; then
  if ! run_with_iverilog; then
    OP_ERROR="EXEC_ABORTED"
  fi
else
  OP_ERROR="SIMULATOR_NOT_FOUND"
  cat > "$STD_LOG" <<EOT
testcase=$TESTCASE
seed=$SEED
start_time=$START_TIME
end_time=$(date -u +"%Y-%m-%dT%H:%M:%S")
status=SIM_ERROR
uvm_error_count=0
uvm_fatal_count=1
coverage=0.0
operational_error=$OP_ERROR
EOT
  echo "No simulator found (xrun or iverilog+vvp). Log created: $STD_LOG"
  exit 1
fi

if [[ "$OP_ERROR" == "NONE" ]]; then
  SUMMARY_LINE="$(grep 'TB_RESULT' "$SIM_LOG" | tail -n 1 || true)"
  if [[ -z "$SUMMARY_LINE" ]]; then
    OP_ERROR="LOG_INCOMPLETE"
  fi
fi

END_TIME="$(date -u +"%Y-%m-%dT%H:%M:%S")"

if [[ "$OP_ERROR" != "NONE" ]]; then
  SIM_STATUS="SIM_ERROR"
  UVM_ERR=0
  UVM_FATAL=1
  COV=0.0
  FIRST_NS=-1
  ROOT_NS=-1
else
  PARSED="$(python3 - "$SUMMARY_LINE" <<'PY'
import re, sys
line = sys.argv[1]
fields = {
    "testcase": "",
    "status": "SIM_ERROR",
    "uvm_error_count": "0",
    "uvm_fatal_count": "0",
    "coverage": "0.0",
    "first_failure_time_ns": "-1",
    "root_cause_time_ns": "-1",
}
for key in list(fields.keys()):
    m = re.search(rf"{key}=([^\s]+)", line)
    if m:
        fields[key] = m.group(1)
print("|".join(fields[k] for k in ["status", "uvm_error_count", "uvm_fatal_count", "coverage", "first_failure_time_ns", "root_cause_time_ns"]))
PY
)"
  IFS='|' read -r SIM_STATUS UVM_ERR UVM_FATAL COV FIRST_NS ROOT_NS <<< "$PARSED"
fi

FIRST_ISO=""
ROOT_ISO=""
if [[ "$FIRST_NS" != "-1" && "$ROOT_NS" != "-1" ]]; then
  CONVERTED="$(python3 - "$START_TIME" "$FIRST_NS" "$ROOT_NS" <<'PY'
from datetime import datetime, timedelta
import sys
start = datetime.strptime(sys.argv[1], "%Y-%m-%dT%H:%M:%S")
first_ns = int(sys.argv[2])
root_ns = int(sys.argv[3])
first_dt = start + timedelta(seconds=first_ns / 1_000_000_000)
root_dt = start + timedelta(seconds=root_ns / 1_000_000_000)
print(first_dt.strftime("%Y-%m-%dT%H:%M:%S"))
print(root_dt.strftime("%Y-%m-%dT%H:%M:%S"))
PY
)"
  FIRST_ISO="$(echo "$CONVERTED" | sed -n '1p')"
  ROOT_ISO="$(echo "$CONVERTED" | sed -n '2p')"
fi

{
  echo "testcase=$TESTCASE"
  echo "seed=$SEED"
  echo "start_time=$START_TIME"
  echo "end_time=$END_TIME"
  echo "status=$SIM_STATUS"
  echo "uvm_error_count=$UVM_ERR"
  echo "uvm_fatal_count=$UVM_FATAL"
  echo "coverage=$COV"
  if [[ -n "$FIRST_ISO" && -n "$ROOT_ISO" ]]; then
    echo "first_failure_time=$FIRST_ISO"
    echo "root_cause_time=$ROOT_ISO"
  fi
  echo "operational_error=$OP_ERROR"
} > "$STD_LOG"

echo "Generated standardized log: $STD_LOG"
echo "Simulation raw log: $SIM_LOG"
