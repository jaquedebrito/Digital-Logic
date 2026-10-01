# Plano de Execução em 10 Dias — Artigo de Verificação UVM com Automação APB

## Tema final
**Como a automação acelera a verificação UVM em projetos de microeletrônica: aprendizados de um aluno júnior no CI Inovador.**

## Estrutura final do artigo
1. Introdução
2. Base técnica (UVM e motivação para automação)
3. Metodologia prática (manual vs automatizado)
4. Demonstração de testcases APB (smoke, corner, erro injetado)
5. Resultados e análise (tempo, erros operacionais, TTR, cobertura, reprodutibilidade)
6. Conclusão

---

## Execução diária (10 dias)

### Dia 1 — Fechamento de escopo
- Fechar título, objetivo e pergunta central do artigo.
- Confirmar estrutura final de seções.
- Definir critério de sucesso: artigo completo até o Dia 7.

**Entrega do dia:** título e sumário aprovados.

### Dia 2 — Introdução pronta
- Escrever contexto de microeletrônica e verificação.
- Inserir recorte de entrada de júnior.
- Declarar objetivo do trabalho.

**Entrega do dia:** seção 1 completa.

### Dia 3 — Base técnica curta e objetiva
- Explicar UVM sem excesso de teoria.
- Justificar por que fluxo manual escala mal.
- Definir por que automação é necessária.

**Entrega do dia:** seção 2 completa.

### Dia 4 — Testcases e metodologia
- Descrever 3 classes:
  - `apb_smoke_basic_rw`
  - `apb_corner_waitstate_max`
  - `apb_injected_protocol_violation`
- Definir o que será medido.

**Entrega do dia:** seções 3 e 4 completas.

### Dia 5 — Coleta de dados
- Executar a demonstração automatizada:

```bash
cd /home/runner/work/Digital-Logic/Digital-Logic/uvm_apb_automation_demo
python3 collect_metrics.py
```

- Validar os artefatos:
  - `outputs/regression_report.csv`
  - `outputs/summary_metrics.md`

**Entrega do dia:** dados consolidados prontos para uso no artigo.

### Dia 6 — Resultados e análise
- Montar tabela principal com as métricas comparáveis.
- Interpretar ganhos do fluxo automatizado sobre o manual.
- Relacionar resultados com dificuldades de júnior.

**Entrega do dia:** seção 5 completa.

### Dia 7 — Conclusão e versão completa
- Escrever conclusão conectando aprendizado e aplicação real.
- Incluir limitações e próximos passos.
- Fechar versão completa do artigo.

**Entrega do dia:** artigo 100% completo (versão 1).

### Dia 8 — Revisão técnica
- Revisar coerência entre método, resultados e conclusão.
- Eliminar repetições e ajustar transições entre seções.

**Entrega do dia:** versão 2 técnica.

### Dia 9 — Revisão acadêmica/formatação
- Ajustar norma solicitada (ABNT/regras da pós).
- Revisar ortografia, citação e padronização de termos.

**Entrega do dia:** versão 3 formatada.

### Dia 10 — Revisão final e entrega
- Checklist final de qualidade.
- Exportar arquivo final e submeter.

**Entrega do dia:** artigo entregue.

---

## Checklist rápido para não atrasar
- [ ] Até o Dia 3: contexto e base técnica fechados.
- [ ] Até o Dia 5: métricas geradas automaticamente.
- [ ] Até o Dia 7: primeira versão completa pronta.
- [ ] Dias 8–10: apenas revisão, sem reescrita total.

## Pacote de evidência mínimo no artigo
- 1 tabela de métricas comparáveis (tempo, erro operacional, TTR, cobertura, reprodutibilidade).
- 1 parágrafo por classe de teste (smoke/corner/erro injetado).
- 1 parágrafo de aprendizado profissional (visão de júnior aplicada ao contexto real).
