#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
from collections import Counter, defaultdict
from datetime import datetime
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
DEFAULT_LOG_DIR = BASE_DIR / "sample_logs"
DEFAULT_OUT_DIR = BASE_DIR / "outputs"

DT_FMT = "%Y-%m-%dT%H:%M:%S"


def parse_log(path: Path) -> dict:
    data: dict[str, str] = {}
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or "=" not in line:
            continue
        key, value = line.split("=", 1)
        data[key.strip()] = value.strip()

    required = [
        "testcase",
        "seed",
        "start_time",
        "end_time",
        "status",
        "uvm_error_count",
        "uvm_fatal_count",
        "coverage",
        "operational_error",
    ]
    missing = [key for key in required if key not in data]
    if missing:
        raise ValueError(f"Missing required keys in {path.name}: {', '.join(missing)}")

    start = datetime.strptime(data["start_time"], DT_FMT)
    end = datetime.strptime(data["end_time"], DT_FMT)
    duration_sec = int((end - start).total_seconds())

    first_failure = data.get("first_failure_time")
    root_cause = data.get("root_cause_time")
    ttr_root_cause_sec = ""
    if first_failure and root_cause:
        fail_t = datetime.strptime(first_failure, DT_FMT)
        root_t = datetime.strptime(root_cause, DT_FMT)
        ttr_root_cause_sec = int((root_t - fail_t).total_seconds())

    return {
        "testcase": data["testcase"],
        "seed": int(data["seed"]),
        "start_time": data["start_time"],
        "end_time": data["end_time"],
        "status": data["status"],
        "uvm_error_count": int(data["uvm_error_count"]),
        "uvm_fatal_count": int(data["uvm_fatal_count"]),
        "coverage": float(data["coverage"]),
        "operational_error": data["operational_error"],
        "duration_sec": duration_sec,
        "ttr_root_cause_sec": ttr_root_cause_sec,
    }


def reproducibility_percent(statuses: list[str]) -> float:
    if not statuses:
        return 0.0
    counts = Counter(statuses)
    return (max(counts.values()) / len(statuses)) * 100.0


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Consolidate APB/UVM regression metrics from key=value logs")
    parser.add_argument("--log-dir", default=str(DEFAULT_LOG_DIR), help="Directory containing *.log standardized files")
    parser.add_argument("--out-dir", default=str(DEFAULT_OUT_DIR), help="Directory where reports will be generated")
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    log_dir = Path(args.log_dir).resolve()
    out_dir = Path(args.out_dir).resolve()

    out_dir.mkdir(parents=True, exist_ok=True)

    logs = sorted(log_dir.glob("*.log"))
    if not logs:
        raise SystemExit(f"No log files found in {log_dir}")

    rows = [parse_log(path) for path in logs]

    csv_fields = [
        "testcase",
        "seed",
        "status",
        "duration_sec",
        "uvm_error_count",
        "uvm_fatal_count",
        "coverage",
        "ttr_root_cause_sec",
        "operational_error",
    ]

    csv_path = out_dir / "regression_report.csv"
    with csv_path.open("w", newline="", encoding="utf-8") as fp:
        writer = csv.DictWriter(fp, fieldnames=csv_fields)
        writer.writeheader()
        for row in rows:
            writer.writerow({field: row[field] for field in csv_fields})

    by_testcase: dict[str, list[dict]] = defaultdict(list)
    for row in rows:
        by_testcase[row["testcase"]].append(row)

    summary_lines = [
        "# APB Regressão - Métricas Consolidadas",
        "",
        "| testcase | runs | tempo médio (s) | erro operacional (%) | TTR médio (s) | cobertura média (%) | reprodutibilidade (%) |",
        "|---|---:|---:|---:|---:|---:|---:|",
    ]

    for testcase, test_rows in sorted(by_testcase.items()):
        runs = len(test_rows)
        avg_time = sum(r["duration_sec"] for r in test_rows) / runs
        op_errors = sum(1 for r in test_rows if r["operational_error"] != "NONE")
        op_error_rate = (op_errors / runs) * 100.0

        ttr_values = [r["ttr_root_cause_sec"] for r in test_rows if isinstance(r["ttr_root_cause_sec"], int)]
        avg_ttr = (sum(ttr_values) / len(ttr_values)) if ttr_values else 0.0

        avg_cov = sum(r["coverage"] for r in test_rows) / runs
        repro = reproducibility_percent([r["status"] for r in test_rows])

        summary_lines.append(
            f"| {testcase} | {runs} | {avg_time:.1f} | {op_error_rate:.1f} | {avg_ttr:.1f} | {avg_cov:.1f} | {repro:.1f} |"
        )

    summary_lines.extend(
        [
            "",
            "## Regras usadas",
            "",
            "- **Erro operacional (%)**: percentual de execuções com `operational_error != NONE`.",
            "- **TTR médio (s)**: média de `root_cause_time - first_failure_time` nas execuções que falharam.",
            "- **Reprodutibilidade (%)**: consistência de status entre seeds por testcase.",
        ]
    )

    md_path = out_dir / "summary_metrics.md"
    md_path.write_text("\n".join(summary_lines) + "\n", encoding="utf-8")

    print(f"Generated: {csv_path}")
    print(f"Generated: {md_path}")


if __name__ == "__main__":
    main()
