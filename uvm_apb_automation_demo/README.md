# APB/UVM Testcase Automation Demo

Este material demonstra como automatizar a coleta de métricas comparáveis para o artigo sobre verificação UVM.

## Objetivo

Padronizar saídas de regressão APB e gerar uma tabela única com:

- tempo total de execução
- taxa de erro operacional
- tempo até causa-raiz (TTR)
- cobertura
- reprodutibilidade

## Classes de teste

1. **Smoke** — `apb_smoke_basic_rw`
   - Cenário: reset + 1 write + 1 read no mesmo endereço.
   - Esperado: `PASS`, `UVM_ERROR=0`.

2. **Corner case** — `apb_corner_waitstate_max`
   - Cenário: escravo mantém `PREADY=0` por vários ciclos antes de responder.
   - Esperado: `PASS`, sem timeout indevido.

3. **Erro injetado** — `apb_injected_protocol_violation`
   - Cenário: violação proposital de protocolo (`PENABLE` sem setup válido).
   - Esperado: `FAIL_EXPECTED` com detecção no monitor/scoreboard.

## Formato de log padronizado

Cada execução contém os campos abaixo:

- `testcase`
- `seed`
- `start_time`
- `end_time`
- `status`
- `uvm_error_count`
- `uvm_fatal_count`
- `coverage`
- `first_failure_time` (opcional)
- `root_cause_time` (opcional)
- `operational_error`

## Execução da demonstração

```bash
cd /home/runner/work/Digital-Logic/Digital-Logic/uvm_apb_automation_demo
python3 collect_metrics.py
```

Saídas geradas:

- `outputs/regression_report.csv`
- `outputs/summary_metrics.md`

## Interpretação da reprodutibilidade

Nesta demonstração, a reprodutibilidade por testcase é a consistência de status entre as três seeds da regressão:

- `100%` = todas as seeds tiveram o mesmo resultado esperado
- `<100%` = houve oscilação de resultado entre seeds
