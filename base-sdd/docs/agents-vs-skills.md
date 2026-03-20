# Agentes vs Skills — Decision Framework

## [GENÉRICO] Definição Conceitual

### Agentes

**Agente** é um especialista que:
- 🎯 Tem um **papel/persona** clara (Feature Writer, Architect, Coder, Tester)
- 🧠 **Toma decisões** sobre o que fazer
- 📋 **Responsável** pelos outputs e qualidade
- 🔄 **Orquestra** múltiplas skills conforme situação
- ⚡ **Carregamento completo** — inclui contexto, guidelines, histórico

### Skills

**Skill** é um procedimento reutilizável que:
- 📖 É um **passo procedural** (como fazer algo)
- 🎯 Tem **escopo bem-definido** (uma técnica, um padrão)
- 🔁 **Reutilizável** por múltiplos agentes
- ⚡ **Carregamento sob demanda** — apenas quando necessário (eficiência de tokens!)
- 📋 **Não toma decisões** — apenas executa instruções

## [GENÉRICO] Comparação: Quando Usar O Quê?

| Aspecto | AGENTE | SKILL |
|--------|--------|-------|
| **O Quê** | Toma decisões | Executa procedimentos |
| **Escopo** | Responsabilidade completa | Técnica específica |
| **Contexto** | Precisa contexto + história | Precisa apenas do input direto |
| **Reutilização** | Pouco reutilizável | Altamente reutilizável |
| **Carregamento** | Sempre carregado | Sob demanda (economiza tokens!) |
| **Exemplo** | "Revisar arquitetura" | "Criar índice de DB" |

## [GENÉRICO] Árvore de Decisão

```
┌─ PRECISO FAZER ALGO?
│
├─ É uma DECISÃO que requer contexto/julgamento?
│  └─→ SIM: Use AGENTE
│      └─ Exemplo: Feature Writer, Architect, Coder, Tester
│
├─ É um PROCEDIMENTO técnico específico?
│  └─→ SIM: Use SKILL (sob demanda)
│      └─ Exemplo: [SKILL:git-workflow], [SKILL:code-review]
│
└─ É GENÉRICO e REUTILIZÁVEL (em múltiplos contextos)?
   └─→ SIM: Melhor como SKILL
   └─→ NÃO: Melhor como AGENTE
```

## [GENÉRICO] Exemplos Práticos

### ✅ AGENTE: Feature Writer

**Por quê AGENTE?**
- Precisa tomar decisão: "Esta feature está clara?"
- Precisa contexto: project-context, guidelines, histórico
- Responsável: aprovar ou rejeitar especificação
- Não-reutilizável: é um papel único

**Sintaxe:**
```
[AGENT:feature-writer] → Analyze {spec} → Accept or Revise
```

---

### ✅ AGENTE: Architect

**Por quê AGENTE?**
- Precisa tomar decisão: "É um bom design?"
- Precisa contexto: ADRs existentes, guidelines, code base
- Responsável: garantir sustentabilidade
- Não-reutilizável: é um papel único

**Sintaxe:**
```
[AGENT:architect] → Review {spec} → Generate ADR
```

---

### ❌ NÃO é SKILL: Git Workflow

**Por quê SKILL (não AGENTE)?**
- É um procedimento bem-definido
- Reutilizável por Coder, Tester, Feature Writer
- Sob demanda: "Como faço um commit properly?"
- Não requer contexto pesado

**Sintaxe:**
```
[SKILL:git-workflow] → Commit message format, branch naming, merge strategy
```

---

### ❌ NÃO é SKILL: Code Review

**Por quê SKILL (não AGENTE)?**
- É uma técnica específica (like a checklist)
- Reutilizável por Architect, Coder, PR-Agent
- Sob demanda: "Qual é o checklist para revisar?"
- Não requer contexto do projeto pesado

**Sintaxe:**
```
[SKILL:code-review] → Apply checklist [readability, performance, security, ...]
```

---

### ❌ NÃO é AGENTE, Mas SKILL: Testing Strategy

**Por quê SKILL (não AGENTE)?**
- É um procedimento (como estruturar testes)
- Reutilizável por Tester, Coder, QA
- Sob demanda: "Qual estratégia de testes?"
- Tester AGENTE decide quando usar; SKILL executa

**Sintaxe:**
```
[AGENT:tester] → Decide: Qual estratégia?
  → [SKILL:testing-strategy] → Apply unit + integration + E2E
```

---

### ✅ AGENTE: Coder

**Por quê AGENTE?**
- Toma decisão: "Como implementar de forma limpa?"
- Precisa contexto: código existente, ADRs, guidelines
- Responsável: qualidade e performance
- Não-reutilizável: é um papel único

**Sintaxe:**
```
[AGENT:coder] → Implement → Refactor → Optimize → Structure
```

---

### ✅ AGENTE: Tester

**Por quê AGENTE?**
- Toma decisão: "Qual estratégia de testes?"
- Precisa contexto: specs, código, guidelines
- Responsável: cobertura e não-regressão
- Não-reutilizável: é um papel único

**Sintaxe:**
```
[AGENT:tester] → Plan → Implement[unit, integration, E2E] → Validate coverage
```

## [GENÉRICO] Padrão: Agente + Skills

### Como Funciona

```
[AGENT] toma decisão → [Chama SKILL:X sob demanda] → Reutiliza contexto
                     ↘ [Chama SKILL:Y sob demanda] ↙

Exemplo:
[AGENT:architect] → "Preciso validar padrões?"
  ↘ [SKILL:code-architecture] → Retorna validação
  ↘ [SKILL:code-review] → Retorna checklist
  → Combina resultados → Gera ADR
```

### Economizar Tokens

```
❌ BAD: Carregar tudo sempre
AGENTE + SKILL-A + SKILL-B + SKILL-C + SKILL-D
= Muito contexto sempre

✅ GOOD: Carregar sob demanda
AGENTE carregado
  → Se precisa validar: carrega [SKILL:code-architecture]
  → Se precisa revisar: carrega [SKILL:code-review]
  → Skills outros podem não ser usados
= Eficiência de tokens!
```

## [GENÉRICO] Lista Completa: Agentes vs Skills (Atual)

### AGENTES (Sempre Carregados)

1. **[AGENT:feature-writer]** — Especificar requisitos em GWT
2. **[AGENT:orchestrator]** — Coordenar fluxo de agentes
3. **[AGENT:architect]** — Validar design, gerar ADRs
4. **[AGENT:coder]** — Implementar, refatorar, otimizar
5. **[AGENT:tester]** — Testar unit, integração, E2E
6. **[AGENT:pr-agent]** — Revisar e criar PRs

### SKILLS (Carregadas Sob Demanda)

1. **[SKILL:git-workflow]** — Branch naming, commits, merge strategy
2. **[SKILL:code-architecture]** — Padrões de design, estrutura
3. **[SKILL:code-review]** — Checklist de revisão
4. **[SKILL:testing-strategy]** — Estratégia de testes
5. **[SKILL:execution-plan]** — Planejar execução
6. **[SKILL:pr-creation]** — Criar pull requests properlly

## [GENÉRICO] Fluxo Completo (Com Agentes e Skills)

```
1. Feature Writer [AGENT]
   └─ Ler requisito
   └─ Usar [SKILL:code-architecture] (se precisa validar padrões)
   └─ Gerar [SPEC-001]

2. Architect [AGENT]
   └─ Revisar [SPEC-001]
   └─ Usar [SKILL:code-architecture] (validar padrões)
   └─ Usar [SKILL:code-review] (checklist)
   └─ Gerar ADR-001

3. Coder [AGENT]
   └─ Ler [SPEC-001] e ADR-001
   └─ Usar [SKILL:code-architecture] (implementar padrões)
   └─ Usar [SKILL:git-workflow] (naming branches)
   └─ Implementar código
   └─ Usar [SKILL:code-review] (auto-review antes de submeter)

4. Tester [AGENT]
   └─ Ler [SPEC-001]
   └─ Usar [SKILL:testing-strategy] (desenhar testes)
   └─ Implementar testes
   └─ Validar cobertura

5. PR Agent [AGENT]
   └─ Revisar PR
   └─ Usar [SKILL:code-review] (checklist)
   └─ Usar [SKILL:git-workflow] (validar commits)
   └─ Aprovar ou rejeitar
```

## [GENÉRICO] Criando Novos Agentes ou Skills

### Quando Criar Novo AGENTE?

```
✅ Crie novo agente se:
- É um PAPEL/PERSONA único
- Toma DECISÕES sobre responsabilidade completa
- Precisa de CONTEXTO pesado (guidelines, histórico, código)
- NÃO é reutilizável por outros agentes

❌ Não crie como agente se:
- É uma técnica específica → Crie como SKILL
- É um passo procedural → Crie como SKILL
- Será usado por múltiplos agentes → Crie como SKILL
```

### Quando Criar Nova SKILL?

```
✅ Crie nova skill se:
- É um PROCEDIMENTO bem-definido
- É REUTILIZÁVEL (múltiplos agentes usam)
- Pode ser carregada SOB DEMANDA
- Escopo bem-definido e focado

❌ Não crie como skill se:
- Requer CONTEXTO pesado → Crie como AGENTE
- É uma DECISÃO complexa → Crie como AGENTE
- Não é reutilizável → Crie como AGENTE
```

## [GENÉRICO] Naming Convention

### Agentes

```
[AGENT:nome-descritivo]
Exemplos:
[AGENT:feature-writer]
[AGENT:architect]
[AGENT:coder]
[AGENT:tester]
```

### Skills

```
[SKILL:nome-descritivo]
Exemplos:
[SKILL:git-workflow]
[SKILL:code-architecture]
[SKILL:code-review]
[SKILL:testing-strategy]
```

### Documentação

```
agents/
├── feature-writer-base.md
├── architect-base.md
├── coder-base.md
├── tester-base.md
├── pr-agent-base.md
└── orchestrator-base.md

skills/
├── git-workflow-base.md
├── code-architecture-base.md
├── code-review-base.md
├── testing-strategy-base.md
├── execution-plan-base.md
└── pr-creation-base.md
```
