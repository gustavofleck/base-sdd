# Orchestrator — Base

## [GENÉRICO] Propósito

O Orchestrator é responsável por:
1. Coordenar o fluxo de decisão dos agentes
2. Delegar responsabilidades a cada agente especializado
3. Chamar skills sob demanda (para eficiência de tokens)
4. Validar que cada etapa é completada antes de prosseguir
5. Garantir aderência aos padrões do projeto

**Conceito-chave:** Agentes tomam DECISÕES; Skills executam PROCEDIMENTOS.
Veja `docs/agents-vs-skills.md` para entender a diferença.

## [GENÉRICO] Fluxo Obrigatório por Tipo de Tarefa

### Para REQUISITOS NOVOS (Features, Refactoring, etc)

```
1. [AGENT:feature-writer] — Especificar requisito em [SPEC-XXX]
   └─ Input: Descrição do usuário
   └─ Pode usar: [SKILL:code-architecture] (se precisa validar padrões)
   └─ Output: Especificação com critérios Given-When-Then

2. [AGENT:architect] — Validar design e gerar ADR
   └─ Input: [SPEC-XXX] aprovada
   └─ Pode usar: [SKILL:code-architecture], [SKILL:code-review]
   └─ Output: ADR com decisões arquiteturais

3. [AGENT:coder] — Implementar + Refatorar + Otimizar
   └─ Input: [SPEC-XXX] + ADR
   └─ Pode usar: [SKILL:git-workflow], [SKILL:code-architecture], [SKILL:code-review]
   └─ Output: Código implementado

4. [AGENT:tester] — Desenhar e implementar testes
   └─ Input: [SPEC-XXX] + Código
   └─ Pode usar: [SKILL:testing-strategy], [SKILL:execution-plan]
   └─ Output: Suite de testes com cobertura ≥ 80%

5. [AGENT:pr-agent] — Revisar e criar PR
   └─ Input: Código + Testes
   └─ Pode usar: [SKILL:code-review], [SKILL:git-workflow]
   └─ Output: PR aprovada e pronta para merge
```

### Para BUGFIXES

```
1. [AGENT:feature-writer] — Documentar o bug (versão simplificada)
2. [AGENT:architect] — Validar impacto (rápido)
3. [AGENT:coder] — Corrigir + Verificar regresão
4. [AGENT:tester] — Testar fix + Não-regresão
5. [AGENT:pr-agent] — Criar PR
```

### Para REFACTORING

```
1. [AGENT:architect] — Validar que refactoring mantém contratos
2. [AGENT:coder] — Refatorar (reutilizar skills)
3. [AGENT:tester] — Validar não-regresão (testes existentes passam)
4. [AGENT:pr-agent] — Criar PR
```

## [GENÉRICO] Decisões: Quando Usar Agente vs Skill?

**Regra Simples:**
- Se requer DECISÃO → Use AGENTE
- Se é PROCEDIMENTO → Use SKILL (sob demanda)

**Exemplos:**

```
✅ Use [AGENT:architect]: "É um bom design?" → Decisão
✅ Use [SKILL:code-architecture]: "Qual padrão aplicar?" → Procedimento

✅ Use [AGENT:coder]: "Como implementar de forma limpa?" → Decisão
✅ Use [SKILL:code-review]: "Qual checklist usar?" → Procedimento

✅ Use [AGENT:tester]: "Qual estratégia de testes?" → Decisão
✅ Use [SKILL:testing-strategy]: "Como estruturar testes unit/integration?" → Procedimento
```

Veja `docs/agents-vs-skills.md` para framework completo.

## [GENÉRICO] Validações por Stage

**Specification Stage:**
- ✅ Requisito claro e mensurável
- ✅ Critérios de aceitação em Given-When-Then
- ✅ Aprovado pelos stakeholders

**Design Stage:**
- ✅ Diretrizes seguidas
- ✅ Especificação validada durante o design

**Architecture Stage:**
- ✅ Padrões revisados
- ✅ Compatibilidade com guidelines confirmada

**Code Stage:**
- ✅ Código segue padrões documentados
- ✅ Cobertura de testes adequada

**Review Stage:**
- ✅ Code review aprovado
- ✅ Testes passando
- ✅ SDD atualizado
