# APB/UVM Testcase Automation Demo

Este material agora inclui um fluxo completo para você gerar **evidência real** do artigo:

- DUT APB simples
- verificação manual (1 teste por vez)
- regressão automatizada
- cenário de falha injetada
- consolidação automática de métricas

## Estrutura

- `rtl/apb_simple_slave.sv` → DUT APB slave com 4 registradores e wait-state configurável
- `tb/tb_apb_simple_slave.sv` → testbench com 3 testcases
- `scripts/run_manual.sh` → execução manual de um testcase por vez
- `scripts/run_regression.sh` → regressão em lote (3 testcases x 3 seeds)
- `scripts/run_one_test.sh` → runner base que gera log padronizado
- `collect_metrics.py` → consolida logs e gera relatórios

## Testcases implementados

1. `apb_smoke_basic_rw` (smoke)
2. `apb_corner_waitstate_max` (corner)
3. `apb_injected_protocol_violation` (erro injetado)

## Pré-requisito de simulação

Use uma destas opções na máquina onde você vai rodar os testes:

- Cadence Xcelium (`xrun`)
- ou Icarus Verilog (`iverilog` + `vvp`)

> Se nenhum simulador estiver disponível, o script cria log com `operational_error=SIMULATOR_NOT_FOUND`.

## Método manual (1 teste por vez)

Exemplo:

```bash
cd /home/runner/work/Digital-Logic/Digital-Logic/uvm_apb_automation_demo
./scripts/run_manual.sh apb_smoke_basic_rw 101
./scripts/run_manual.sh apb_corner_waitstate_max 202
./scripts/run_manual.sh apb_injected_protocol_violation 303
```

Logs gerados em:

- `run_logs/manual/*.log`

Consolidar métricas do manual:

```bash
python3 collect_metrics.py --log-dir run_logs/manual --out-dir outputs/manual_summary
```

## Método automatizado (regressão em lote)

```bash
cd /home/runner/work/Digital-Logic/Digital-Logic/uvm_apb_automation_demo
./scripts/run_regression.sh
```

Saídas da regressão automatizada:

- logs padronizados: `run_logs/automated/*.log`
- relatório detalhado: `outputs/real_regression/regression_report.csv`
- tabela consolidada: `outputs/real_regression/summary_metrics.md`

## Formato de log padronizado

Cada execução gera um arquivo `key=value` com:

- `testcase`
- `seed`
- `start_time`
- `end_time`
- `status`
- `uvm_error_count`
- `uvm_fatal_count`
- `coverage`
- `first_failure_time` (quando aplicável)
- `root_cause_time` (quando aplicável)
- `operational_error`

## Como usar isso no artigo (prova concreta)

Para banca, anexe:

1. logs brutos (`run_logs/manual` e/ou `run_logs/automated`)
2. relatório CSV consolidado
3. tabela markdown consolidada
4. comandos executados para reproduzir os números

Assim você mostra rastreabilidade completa do resultado.
