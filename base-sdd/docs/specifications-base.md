# Specifications — Base

## [GENÉRICO] Objetivo

Centralizar todas as especificações de requisitos do projeto. Este documento serve como single source of truth para o que deve ser construído.

## [GENÉRICO] Estrutura de Especificação

Cada especificação deve incluir:

1. **ID e Título** — Identificador único e nome descritivo
2. **Descrição** — O que será feito e por quê
3. **Critérios de Aceitação** — Cenários Given-When-Then
4. **Dependências** — Outras especificações relacionadas
5. **Notas Técnicas** — Constraints ou considerações
6. **Status** — Draft, Approved, In Development, Done

## [GENÉRICO] Template de Especificação

```
## [SPEC-001] Título do Requisito

**Status:** Draft | Approved | In Development | Done

### Descrição
O que será implementado e qual o valor entregue.

### Critérios de Aceitação

#### Cenário 1: Nome descritivo
- **Given:** Estado inicial
- **When:** Ação disparadora
- **Then:** Resultado esperado

#### Cenário 2: Nome descritivo
- **Given:** Estado inicial
- **When:** Ação disparadora
- **Then:** Resultado esperado

### Dependências
- [SPEC-XXX] Outra especificação relacionada

### Notas Técnicas
- Restrições técnicas
- Padrões a seguir
- Compatibilidades necessárias

### Aprovação
- [ ] Product Manager aprovou
- [ ] Arquiteto revisou
- [ ] Development team acordou
```

## [GENÉRICO] Ciclo de Vida de Especificações

1. **Draft** → Escrito pelo Feature Writer, aguardando revisão
2. **Approved** → Validado por stakeholders e arquiteto
3. **In Development** → Designado para um desenvolvedor
4. **Done** → Implementado e testado

## [GENÉRICO] Versionamento de Specs

- Versão inicial: 1.0
- Mudanças menores (clarificações): +0.1
- Mudanças significativas (novo critério): +1.0
- Quebrar compatibilidade com já-feito: nova spec

## [GENÉRICO] Traceability

Cada especificação deve poder ser rastreada até:
- Código que a implementa
- Commits associados
- Pull requests
- Testes que validam

Usar identificadores como `SPEC-001` nos commits e PRs.
