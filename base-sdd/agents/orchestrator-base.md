# Orchestrator — Base

## [GENÉRICO] Propósito

O Orchestrator é responsável por:
1. Definir o fluxo de decisão dos agentes
2. Validar que cada etapa é completada antes de prosseguir
3. Garantir aderência aos padrões do projeto
4. Coordenar timeing entre agentes

## [GENÉRICO] Fluxo Obrigatório

Para toda tarefa (feature, bugfix, refactor, test, docs):

1. **Receber pedido** — usuário descreve o que quer
2. **Classificar** — qual tipo de tarefa?
3. **Carregar documentação** — ler docs relevantes
4. **Delegar agentes** — seguir ordem definida
5. **Validar etapas** — checkpoint antes de avançar
6. **Documentar mudanças** — atualizar SDD se necessário
7. **Submeter PR** — nunca fazer merge direto

## [ESPECIALIZAÇÃO] Comandos Rápidos

Defina aqui os comandos de sua aplicação:

{Exemplo para Android}:
- `/feat <description>` → [A:feat] → [A:design] → [A:plan] → [A:arch] → [A:code] → [A:test]
- `/fix <description>` → Direct to [A:code]
- `/test <scope>` → Direct to [A:test]

{Exemplo para React}:
- `/spec <description>` → [A:feat]
- `/build <feature>` → [A:feat] → [A:design] → [A:code]

## [ESPECIALIZAÇÃO] Validações por Stage

**Feature Design Stage:**
- ✅ Mockup validado com designer
- ✅ Acceptance criteria em Given-When-Then

**Architecture Stage:**
- ✅ Diagrama de arquitetura atualizado
- ✅ Padrões aplicados (MVI, Redux, etc)

**Code Stage:**
- ✅ Código segue padrões da arquitetura
- ✅ 80%+ test coverage

**Review Stage:**
- ✅ Code review aprovado
- ✅ CI/CD passing
- ✅ SDD atualizado

## [EXEMPLO:kotlin]

Feature → Design (Material 3) → Architect (Validate MVI) → Coder (Kotlin) → Tester (Given-When-Then) → PR (Create PR)

## [EXEMPLO:react]

Feature → Design (Figma) → Architect (Validate Redux) → Coder (TypeScript + React) → Tester (Jest + RTL) → PR
