# Seção 4 — Demonstração de Testcases APB para Verificação UVM

Esta seção apresenta a metodologia prática adotada para sustentar a comparação entre fluxo manual e fluxo automatizado na verificação UVM. A estratégia utiliza três classes de teste com finalidades complementares: validação funcional básica (smoke), validação em condição de limite (corner case) e validação de robustez do ambiente por falha proposital (erro injetado).

## 4.1 Teste Smoke — `apb_smoke_basic_rw`

**Objetivo do teste**  
Comprovar que o caminho funcional mínimo do barramento APB está íntegro antes da execução de cenários mais complexos.

**Como foi estimulado**  
Foi aplicada sequência de reset do DUT, seguida de uma operação de escrita e uma operação de leitura no mesmo endereço, mantendo parâmetros de transação estáveis para isolar o comportamento básico do protocolo.

**Critério de aprovação/reprovação**  
- **Aprovação (PASS):** leitura coerente com a escrita, sem violações de protocolo e com `uvm_error_count = 0`.  
- **Reprovação (FAIL):** inconsistência de dados lidos, falha de handshake, ou ocorrência de erro monitorado pelo ambiente UVM.

**Métrica que ajuda a provar**  
- **Tempo total de execução:** estabelece baseline de referência para os demais testes.  
- **Cobertura básica:** evidencia ativação mínima dos caminhos de read/write.  
- **Reprodutibilidade:** confirma estabilidade do ambiente nas seeds executadas.

## 4.2 Teste Corner Case — `apb_corner_waitstate_max`

**Objetivo do teste**  
Avaliar se o ambiente e o DUT preservam conformidade do protocolo APB sob latência elevada de resposta do escravo.

**Como foi estimulado**  
Foi forçada condição de espera no escravo por múltiplos ciclos, com `PREADY = 0` antes da conclusão das transações, incluindo acessos em sequência para estressar temporização e controle.

**Critério de aprovação/reprovação**  
- **Aprovação (PASS):** transações completadas corretamente após wait-state, sem timeout indevido e sem erros funcionais.  
- **Reprovação (FAIL):** timeout incorreto, quebra de sequência de handshake, ou divergência de comportamento em relação ao protocolo APB.

**Métrica que ajuda a provar**  
- **Tempo total de execução:** tende a crescer devido ao wait-state, validando custo temporal de condição extrema.  
- **Taxa de erro operacional:** útil para demonstrar impacto de execução manual em cenários mais longos.  
- **Cobertura de canto:** reforça que o fluxo cobre condição de limite e não apenas caminho nominal.

## 4.3 Teste com Erro Injetado — `apb_injected_protocol_violation`

**Objetivo do teste**  
Verificar se o ambiente UVM detecta e classifica corretamente uma violação proposital de protocolo, validando eficácia de monitoramento e diagnóstico.

**Como foi estimulado**  
Foi introduzida violação controlada no handshake (exemplo: ativação de `PENABLE` fora da sequência esperada), mantendo o restante do cenário suficientemente estável para evidenciar causa-raiz da falha.

**Critério de aprovação/reprovação**  
- **Aprovação (FAIL_EXPECTED):** falha detectada pelo monitor/scoreboard com incremento de `uvm_error_count`, caracterizando comportamento esperado para teste negativo.  
- **Reprovação:** ausência de detecção da violação, classificação incorreta do resultado, ou diagnóstico inconsistente.

**Métrica que ajuda a provar**  
- **Tempo até causa-raiz (TTR):** principal indicador de eficiência de análise de falha.  
- **Taxa de erro operacional:** mede perdas por comando inválido/log incompleto durante triagem.  
- **Reprodutibilidade de falha esperada:** confirma previsibilidade do teste negativo entre seeds.

## 4.4 Síntese metodológica da seção

A combinação dos três testcases cobre, de forma progressiva, os pontos necessários para sustentar a argumentação do artigo:  
(1) funcionalidade mínima válida,  
(2) comportamento sob condição extrema e  
(3) capacidade de diagnóstico frente a erro proposital.  
Com isso, as métricas coletadas deixam de ser apenas números de execução e passam a representar evidência prática da contribuição da automação para produtividade, rastreabilidade e evolução técnica de profissionais em início de carreira.
