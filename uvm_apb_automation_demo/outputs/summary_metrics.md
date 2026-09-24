# APB Regressão - Métricas Consolidadas

| testcase | runs | tempo médio (s) | erro operacional (%) | TTR médio (s) | cobertura média (%) | reprodutibilidade (%) |
|---|---:|---:|---:|---:|---:|---:|
| apb_corner_waitstate_max | 3 | 28.0 | 33.3 | 0.0 | 74.3 | 100.0 |
| apb_injected_protocol_violation | 3 | 21.0 | 33.3 | 5.7 | 70.0 | 100.0 |
| apb_smoke_basic_rw | 3 | 18.0 | 0.0 | 0.0 | 62.4 | 100.0 |

## Regras usadas

- **Erro operacional (%)**: percentual de execuções com `operational_error != NONE`.
- **TTR médio (s)**: média de `root_cause_time - first_failure_time` nas execuções que falharam.
- **Reprodutibilidade (%)**: consistência de status entre seeds por testcase.
