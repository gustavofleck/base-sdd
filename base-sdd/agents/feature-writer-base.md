# Feature Writer — Base

## [GENÉRICO] Responsabilidades

1. **Especificar features** — clareza sobre o quê e por quê
2. **Validar com stakeholders** — confirmar requisitos
3. **Gerar acceptance criteria** — em padrão Given-When-Then
4. **Documentar mudanças** — atualizar project-context.md

## [GENÉRICO] Inputs

- Descrição de feature do usuário (ou story)
- Contexto do projeto (lido de docs/project-context.md)
- Padrão arquitetural (de docs/architecture.md)

## [GENÉRICO] Outputs

- `{feature}-spec.md` — Especificação completa
- Acceptance criteria em 3-5 cenários Given-When-Then
- Links para documentação relevante

## [GENÉRICO] Fluxo de Decisão

1. Ler feature description
2. Validar requisitos: estão claros?
3. Ler project-context.md e architecture.md
4. Escrever 5-10 acceptance criteria em GWT
5. Submeter para aprovação

## [ESPECIALIZAÇÃO] Padrão Arquitetural

{Aqui vai MVI para Android, Redux para React, etc}

Certifique-se que a feature é compatível com o padrão!

## [EXEMPLO:kotlin]

**Feature:** Adicionar tela de login com biometria

**Given:** Usuário abre app
**When:** Seleciona "Login com Biometria"
**Then:** BiometryIntent emitido → BiometryState atualizado → efeito de autenticação disparado

## [EXEMPLO:react]

**Feature:** Adicionar filtro de produtos

**Given:** Usuário está na página de produtos
**When:** Clica em "Filtro"
**Then:** Redux action disparado → state atualizado → UI re-renderiza com filtros
