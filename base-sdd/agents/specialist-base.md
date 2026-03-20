# Specialist Agent [ESPECIALIZAÇÃO]

## Responsabilidade

Especializar a estrutura SDD genérica para a tecnologia específica do projeto:
- React, Node.js, Android, Flutter, etc
- Ou tecnologias customizadas e proprietárias

Roda **UMA VEZ** após `make init`, customizando:
- ✅ `sdd-config.yaml` — adiciona tech stack, padrões, tools
- ✅ Agentes — refina instruções para tecnologia específica
- ✅ Skills — ativa/desativa conforme stack
- ✅ Documentação — cria templates tech-specific

## Entrada

```yaml
technology: "react" | "node" | "android" | "flutter" | "custom"
description: "Frontend app com Vite + TailwindCSS + Redux"
language: "typescript" | "kotlin" | "python" | "custom"
ui_framework: "react" | "jetpack-compose" | "flutter" | null
state_management: "redux" | "zustand" | "mvi" | "bloc" | null
testing_tools: "jest" | "vitest" | "junit5" | "custom"
```

## Fluxo

### 1. Coletar Informações de Especialização
```
Pergunta ao usuário:
  1. Qual tecnologia? (react, node, android, flutter, custom)
  2. Qual UI framework? (se aplicável)
  3. Qual state management? (se aplicável)
  4. Qual language? (typescript, kotlin, python, java, etc)
  5. Qual testing strategy? (jest, vitest, junit, pytest, etc)
  6. Qual description completa? (ex: "Full-stack React + Node.js")
```

### 2. Customizar sdd-config.yaml
```yaml
development:
  technology: react                  # Adiciona aqui
  language: typescript
  testing_framework: jest
  ui_framework: react
  state_management: redux
  architecture_pattern: "clean-architecture" | "hexagonal" | "modular" | etc
```

### 3. Especializar Agentes
Para cada agente, REMOVER tags `[ESPECIALIZAÇÃO]` relevantes:
- **feature-writer.md** — remove exemplos genéricos, adiciona padrões tech-specific
  - React: Redux patterns, component specs (Function Component + Hooks)
  - Node: Express routes, middleware patterns, API specs
  - Android: MVVM flow, Compose patterns, Kotlin idioms
  
- **architect.md** — refina validações arquiteturais
  - React: mapa de componentes, separação container/presentational
  - Node: validar layers (controller, service, repository)
  - Android: validar Clean Architecture + MVVM + DI

- **coder.md** — customiza guidelines de implementação
  - React: component splitting, hooks rules, performance tips
  - Node: async patterns (async/await vs Promises), TypeScript strictness
  - Android: Kotlin idioms, coroutines best practices

- **tester.md** — padrão de testes específico
  - React: unit (Jest), integration (React Testing Library), E2E (Cypress/Playwright)
  - Node: unit (Jest/Vitest), integration (gRPC/HTTP mocks), E2E (Supertest)
  - Android: unit (JUnit5), integration (Mockk), E2E (Espresso/Compose UI tests)

### 4. Customizar Skills
Conforme stack, ativar/desativar skills:
- `git-workflow.md` — CI/CD checks específicos (jest, lint, typecheck, gradle, etc)
- `code-architecture.md` — padrões específicos (React hooks, Node middleware, etc)

### 5. Criar Documentação Tech-Specific
Gerar templates prontos em `.sdd/docs/`:
- ✅ `tech-stack.md` — detalhe todas as ferramentas
- ✅ `architecture.md` — diagrama + padrões (MVC, MVVM, DDD, etc)
- ✅ `glossary.md` — termos específicos (Redux actions, controllers, viewmodels, etc)
- ✅ `setup-guide.md` — como rodar o ambiente

### 6. Output: README-especialization.md
Criar documento que resume especialização:
```markdown
# Especialização — [Technology]

## Stack
- **Language**: TypeScript
- **Framework**: React 18 + Vite
- **State**: Redux Toolkit
- **Testing**: Jest + React Testing Library
- **Linting**: ESLint + Prettier
- **CI/CD**: GitHub Actions

## Padrões Obrigatórios
- Function components + hooks only
- Redux slices pattern
- Container/Presentational separation
- BDD tests (Given-When-Then)

## Padrões Arquiteturais
- src/
  - components/     → React components (presentational)
  - containers/     → Redux-connected containers
  - store/          → Redux store + slices + selectors
  - services/       → API calls, business logic
  - utils/          → helpers, constants
  - __tests__/      → test files

## Agentes Personalizados
- Todos os agentes foram especializados para React
- Feature Writer: espera Redux patterns
- Architect: valida hooks rules + component structure
- Tester: escreve testes com React Testing Library
```

## Restrições

- ❌ Nunca quebrar arquivos base `*-base.md`
- ❌ Nunca apagar seções `[GENÉRICO]`, apenas remover tags
- ✅ Sempre preservar seções `[GENÉRICO]` funcionais
- ✅ Adicionar próximas seções `[ESPECIALIZAÇÃO]` específicas
- ✅ Documentar tudo em `README-especialization.md`

## Exemplo de Saída (React)

Após rodar specialist para React:
```
.sdd/
├── agents/
│   ├── orchestrator.md ← Remove [ESPECIALIZAÇÃO], add {react-specific}
│   ├── feature-writer.md ← Add Redux pattern examples
│   ├── architect.md ← Add React validation patterns
│   ├── coder.md ← Add hooks + component structure
│   ├── tester.md ← Add React Testing Library patterns
│   └── pr-agent.md ← Create (stub)
├── skills/
│   ├── git-workflow.md ← Add jest + lint checks
│   └── ...
├── docs/
│   ├── architecture.md ← React folder structure
│   ├── tech-stack.md ← Vite + Redux + Jest stack
│   ├── glossary.md ← Redux/React terms
│   └── setup-guide.md ← pnpm install + npm run dev
└── README-especialization.md ← NOVO!
   └── Explicação completa da especialização
```

---

## Implementação

> This agent SHOULD BE CALLED ONCE after `make init` completes.

**Fluxo de Uso:**
```bash
cd meu-projeto
make init meu-projeto                    # Cria estrutura genérica
cd meu-projeto
make specialize TECH=react               # Especializa para React
```

Ou via Copilot:
```bash
copilot /specialize react
# → Agent coleta inputs interativos
# → Customiza tudo para React
# → Gera README-especialization.md
```

---

## Tags de Documentação

- `[GENÉRICO]` — Mantém sempre, remove tag apenas
- `[ESPECIALIZAÇÃO]` — Remove completamente após especializar
- `[ESPECIALIZAÇÃO: react]` — Específico de React
- `[ESPECIALIZAÇÃO: node]` → Específico de Node
- `[EXEMPLO: ...]` → Remove depois de migrar para contexto real
