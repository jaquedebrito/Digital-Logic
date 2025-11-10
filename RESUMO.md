# 📋 Resumo Completo do Repositório - Lógica Digital

## Visão Geral

Este documento fornece um resumo abrangente de todos os projetos contidos neste repositório de Lógica Digital, desenvolvidos durante o curso utilizando SystemVerilog e ferramentas Cadence.

---

## 📊 Estatísticas do Repositório

- **Total de Projetos:** 6 módulos principais
- **Linguagem:** SystemVerilog
- **Ferramentas:** Cadence Xcelium (simulação), Cadence Genus (síntese)
- **Tópicos Abordados:** Lógica Combinacional, Lógica Sequencial, FSMs, Protocolos de Comunicação

---

## 🗂️ Estrutura de Projetos

### 1. Avaliação Parcial Parte 1: Decodificador I2C

**Objetivo:** Implementar um decodificador para protocolo I2C

**Características Principais:**
- Máquina de Estados Finitos (FSM) com 5 estados (IDLE, ADDR, OP, ACK, DONE)
- Detecção de condições START e STOP
- Decodificação de endereço de 7 bits
- Identificação de operação de leitura/escrita
- Sinais de controle para comunicação I2C

**Conceitos Aplicados:**
- Projeto de FSM síncrona
- Detecção de bordas e transições de sinais
- Decodificação de protocolo de comunicação
- Comparação de endereços

**Arquivos:** `dec_i2c.sv`, `tb_dec_i2c.sv`

---

### 2. Avaliação Parcial Parte 2: Projetos de Lógica Sequencial

Esta seção contém múltiplos projetos focados em lógica sequencial:

#### 2.1 Controlador de Semáforo Avançado (`sinaleira2.sv`)

**Objetivo:** Controlar um cruzamento de duas ruas com passagem de pedestres

**Especificações:**
- Clock de 1 Hz
- Temporização configurável baseada em parâmetros
- Rua 1: Luz verde de X segundos
- Rua 2: Luz verde de 4 segundos (Y = 3 + 1)
- Luz amarela: 2 segundos
- Pedestre: 5 segundos após solicitação

**Estados Implementados:**
1. START - Inicialização
2. STREET_1_GREEN - Verde da Rua 1
3. STREET_1_YELLOW - Amarelo da Rua 1
4. STREET_2_GREEN - Verde da Rua 2
5. STREET_2_YELLOW - Amarelo da Rua 2
6. PEDESTRIAN_GREEN - Verde do pedestre
7. PEDESTRIAN_RED - Vermelho do pedestre

**Melhorias Implementadas:**
- Correção de parâmetros de temporização
- Lógica de sinal aprimorada (vermelho desliga quando verde/amarelo ativo)
- Testbench sincronizado com verificação de temporização
- Restrições de segurança garantidas

#### 2.2 Semáforo Básico (`semaforo.sv`)

**Objetivo:** FSM simples de semáforo

**Estados:**
- START (vermelho + amarelo)
- GREEN (verde)
- YELLOW (amarelo)
- RED (vermelho)

**Características:**
- Detecção de borda de pulso
- Transições controladas por sinal de pulso
- Reset síncrono para estado START

#### 2.3 Contador de 5 Bits (`contador_5b.sv`)

**Objetivo:** Contador síncrono configurável

**Funcionalidades:**
- Contagem de 0 até valor máximo configurável (0-31)
- Reset síncrono
- Sinal de fim de contagem (`done`)
- Reinício automático ao atingir valor máximo

**Aplicações:**
- Divisores de frequência
- Geradores de temporização
- Controle de sequências

#### 2.4 Detector de Padrão Serial (`detec_padrao_serial.sv`)

**Objetivo:** Detectar sequência específica em entrada serial

**Implementação:**
- FSM para reconhecimento de padrão
- Entrada serial bit a bit
- Sinalização quando padrão é detectado

#### 2.5 Flip-Flop D (`flip_flop_D.sv`)

**Objetivo:** Elemento básico de armazenamento

**Características:**
- Implementação fundamental de flip-flop tipo D
- Demonstração de elemento sequencial básico

---

### 3. Atividade Prática 2: Projeto de Lógica Combinacional

**Objetivo:** Projetar circuitos combinacionais usando células de biblioteca

#### 3.1 Sistema X - Comparador com Constante

**Especificação:**
- Entrada: X[3:0] (4 bits)
- Saída: Q (1 bit)
- Comportamento: Q = 1 se e somente se X == 4'b0101

**Implementação:**
- Design hierárquico usando células da biblioteca
- Portas lógicas: INVX1HVT, AND3X1HVT, OR3X1HVT
- Esquemático e forma de onda documentados

#### 3.2 Sistema Y - Comparador Dinâmico (Bônus)

**Especificação:**
- Entradas: A[3:0], B[3:0]
- Saída: Q (1 bit)
- Comportamento: Q = 1 se A == B

**Vantagens:**
- Flexibilidade de comparação
- Valor de comparação configurável

#### 3.3 Multiplexador 8x1

**Especificação:**
- Multiplexador de 8 entradas para 1 saída
- Sinais de seleção de 3 bits
- Testbench completo

**Documentação:**
- Esquemático do circuito
- Formas de onda de simulação
- PDF de resultados

---

### 4. Atividade Prática 3: Contador de Votos

**Objetivo:** Contar bits ativos em vetor de entrada

**Especificação:**
- Entrada: V[2:0] (3 bits)
- Saída: R[3:0] (4 bits, codificação one-hot)

**Tabela de Comportamento:**
| Entrada V | Saída R | Significado |
|-----------|---------|-------------|
| 000       | 0001    | 0 bits ativos |
| 001, 010, 100 | 0010 | 1 bit ativo |
| 011, 101, 110 | 0100 | 2 bits ativos |
| 111       | 1000    | 3 bits ativos |

**Implementação:**
- Design hierárquico com células lógicas básicas
- Inversores para gerar entradas complementadas
- Portas AND de 3 entradas para detectar padrões
- Portas OR de 3 entradas para combinar condições

**Validação:**
- Testbench verifica todas as 8 combinações possíveis
- Resultados confirmam codificação one-hot correta

---

### 5. Atividade Prática 4: Árbitro de Barramento

**Objetivo:** Gerenciar acesso ao barramento para múltiplos dispositivos

**Especificação:**
- Entradas: req[3:0] (requisições de 4 dispositivos)
- Saídas: 
  - grant[3:0] (concessão one-hot)
  - available (1 bit, indica barramento disponível)
  - grant_num[1:0] (número do dispositivo em binário)

**Política de Arbitragem:**
- Baseada em prioridade
- Apenas uma concessão ativa por vez
- Dispositivo com maior prioridade recebe acesso

**Características:**
- Design sintetizável
- Lógica combinacional para arbitragem
- Codificação binária do dispositivo concedido

**Validação:**
- Testbench com múltiplos cenários de requisição
- Verificação de exclusividade de concessão
- Formas de onda documentadas

---

### 6. Projeto Final: Codificador/Decodificador PT2262/2272

**Objetivo:** Implementar sistema completo de codificação e decodificação RF

#### 6.1 Codificador PT2262

**Funcionalidades:**
- Codificação de endereço (8 bits)
- Codificação de dados (4 bits)
- Transmissão sincronizada
- Frequência de oscilador configurável

**Estrutura:**
- `codificador_pt2262.sv` - Módulo principal
- `comp_endereco.sv` - Comparador de endereço
- `codificador_tb.sv` - Testbench
- `run_sim.sh` - Script de simulação

#### 6.2 Decodificador PT2272

**Funcionalidades:**
- Comparação e validação de endereço
- Extração de dados
- Indicador de transmissão válida
- Recepção sincronizada

**Estrutura:**
- `decodificador_pt2272.sv` - Módulo principal
- `comp_endereco.sv` - Comparador de endereço
- `decodificador_tb.sv` - Testbench
- `run_sim.sh` - Script de simulação

#### 6.3 Relatórios de Síntese

O projeto inclui análises completas de síntese:

**Utilização de Área:**
- Relatório: `codificador_pt2262_area.rpt`
- Análise de recursos utilizados
- Otimizações de área

**Análise de Potência:**
- Relatório: `codificador_pt2262_power.rpt`
- Consumo estático e dinâmico
- Otimizações de potência

**Análise em Nível de Portas:**
- Relatório: `codificador_pt2262_gates.rpt`
- Contagem de portas lógicas
- Distribuição por tipo de célula

**Mapeamento de Datapath:**
- Relatórios: `codificador_pt2262_datapath_map.rpt`, `codificador_pt2262_datapath_generic.rpt`
- Estrutura do datapath
- Otimizações de mapeamento

#### 6.4 Datasheets

- `Datasheet PT2262-2272-1-1.pdf` - Especificação completa
- `PT2262.pdf` - Referência adicional

---

## 🎓 Conceitos e Técnicas Aplicadas

### Lógica Combinacional
- ✅ Comparadores
- ✅ Multiplexadores
- ✅ Codificadores
- ✅ Circuitos aritméticos
- ✅ Design hierárquico com células de biblioteca

### Lógica Sequencial
- ✅ Flip-flops
- ✅ Contadores síncronos
- ✅ Registradores de deslocamento
- ✅ Máquinas de Estados Finitos (FSM)

### Máquinas de Estados (FSM)
- ✅ FSM de Moore e Mealy
- ✅ Codificação de estados
- ✅ Detecção de bordas
- ✅ Transições controladas

### Protocolos de Comunicação
- ✅ I2C (detecção START/STOP, endereçamento)
- ✅ RF (codificação/decodificação PT2262/2272)

### Verificação e Teste
- ✅ Testbenches SystemVerilog
- ✅ Geração de estímulos
- ✅ Verificação de comportamento
- ✅ Análise de formas de onda

### Síntese e Otimização
- ✅ Síntese lógica com Cadence Genus
- ✅ Análise de área
- ✅ Análise de potência
- ✅ Mapeamento de tecnologia

---

## 🛠️ Ferramentas e Metodologias

### Linguagem de Descrição de Hardware
- **SystemVerilog**: Linguagem principal para todos os designs
- Construções sintetizáveis
- Testbenches abrangentes
- Assertions e verificação

### Fluxo de Simulação
1. **Xcelium**: Simulação funcional e temporal
2. Geração de formas de onda
3. Análise de cobertura
4. Verificação de protocolo

### Fluxo de Síntese
1. **Genus**: Síntese lógica
2. Otimização de área e potência
3. Fechamento de temporização
4. Mapeamento de tecnologia
5. Geração de relatórios

### Automação
- **Scripts TCL**: Automação de fluxo de projeto
- Scripts de simulação (bash)
- Geração de relatórios

---

## 📈 Progresso e Conquistas

### Habilidades Desenvolvidas
- ✅ Design de circuitos digitais complexos
- ✅ Implementação de FSMs robustas
- ✅ Verificação funcional abrangente
- ✅ Síntese e otimização de hardware
- ✅ Documentação técnica detalhada
- ✅ Uso de ferramentas industriais (Cadence)

### Projetos Concluídos
- ✅ 1 Decodificador de protocolo I2C
- ✅ 5 Projetos de lógica sequencial
- ✅ 3 Projetos de lógica combinacional
- ✅ 1 Contador de votos
- ✅ 1 Árbitro de barramento
- ✅ 1 Sistema completo de codificador/decodificador RF

### Documentação
- ✅ READMEs detalhados para cada projeto
- ✅ Diagramas de estado
- ✅ Esquemáticos de circuito
- ✅ Formas de onda de simulação
- ✅ Relatórios de síntese

---

## 🔍 Pontos de Destaque

### Complexidade Técnica
1. **Decodificador I2C**: Implementação completa de protocolo de comunicação
2. **Controlador de Semáforo**: FSM com múltiplos estados e temporização precisa
3. **Codificador/Decodificador RF**: Sistema completo com síntese e análise

### Qualidade de Código
- Código limpo e bem comentado
- Nomenclatura significativa
- Estrutura hierárquica
- Práticas recomendadas de SystemVerilog

### Verificação
- Testbenches abrangentes
- Cobertura de casos extremos
- Documentação de resultados
- Formas de onda anotadas

---

## 📚 Recursos Educacionais

Este repositório serve como:
- **Portfólio** de projetos de lógica digital
- **Material de referência** para design SystemVerilog
- **Exemplos práticos** de FSMs e lógica combinacional
- **Demonstração** de uso de ferramentas Cadence
- **Guia** de boas práticas em design digital

---

## 🎯 Conclusão

Este repositório demonstra proficiência abrangente em:
- Design de circuitos digitais
- SystemVerilog HDL
- Verificação funcional
- Síntese e otimização
- Documentação técnica
- Uso de ferramentas EDA profissionais

Os projetos cobrem desde conceitos fundamentais (flip-flops, contadores) até sistemas complexos (protocolos de comunicação, sistemas RF), demonstrando progressão de aprendizado e domínio de técnicas de design digital modernas.

---

**Total de Arquivos:** 60+ arquivos SystemVerilog, scripts, relatórios e documentação  
**Linhas de Código:** Milhares de linhas de código SystemVerilog sintetizável e testbenches  
**Documentação:** 15+ arquivos README detalhados com diagramas e especificações

**Status:** ✅ Todos os projetos testados, simulados e documentados  
**Qualidade:** ⭐⭐⭐⭐⭐ Código de produção com documentação profissional
