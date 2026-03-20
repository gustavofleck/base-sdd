# Base-SDD — Sistema Distribuído de Decisão para Agentes Especializados

[![Version](https://img.shields.io/badge/version-2.0.0-blue)](./docs/CHANGELOG.md)
[![License](https://img.shields.io/badge/license-MIT-green)](./LICENSE)
[![Python 3.7+](https://img.shields.io/badge/python-3.7%2B-blue)](https://www.python.org/)
[![Bash 4.0+](https://img.shields.io/badge/bash-4.0%2B-blue)](https://www.gnu.org/software/bash/)

## 📋 Descrição

**Base-SDD** é um framework agnóstico para criar sistemas de orquestração de agentes especializados (Feature Writers, Architects, Coders, Testers, etc.) reutilizáveis em qualquer contexto: Android, React, Node.js, ou qualquer tecnologia.

O projeto oferece:
- ✅ **Estrutura base genérica** (agents, skills, docs) compilada em Markdown
- ✅ **Sistema de especialização** (`[GENÉRICO]`, `[ESPECIALIZAÇÃO]` tags)
- ✅ **Validação automática** de configuração YAML + integridade de contexto
- ✅ **Orquestração inteligente** via agentes + skills + documentação
- ✅ **Escalável para marketplace** (Phase 3+4 planejado)

## 🚀 Quick Start

### 1. Clone o repositório

```bash
git clone https://github.com/gustavoabelh/base-sdd.git
cd base-sdd
```

### 2. Criar um novo contexto (Android, React ou Node.js)

```bash
# Escolha uma opção:

# Opção 1: Modo interativo
make init

# Opção 2: Android context
make init-android

# Opção 3: React context
make init-react

# Opção 4: Node.js context
make init-node
```

**Resultado:** Nova pasta criada **UMA NÍVEL ACIMA do clone** com estrutura SDD pronta:

```
../
├── my-project/                 ← Novo contexto criado aqui
│   ├── .sdd/
│   │   ├── agents/
│   │   ├── skills/
│   │   ├── docs/
│   │   └── sdd-config.yaml
│   ├── copilot-instructions.md
│   └── ... (seus arquivos de projeto)
├── base-sdd/                   ← Clone do GitHub
│   ├── Makefile
│   ├── README.md
│   └── scripts/
```

### 3. Validar e usar

```bash
# Dentro do novo contexto (../my-project/)

# Validar configuração YAML
python ../base-sdd/scripts/validate-config.py .sdd/sdd-config.yaml

# Verificar integridade (tags, docs, etc)
python ../base-sdd/scripts/check-integrity.py .sdd

# Resolver herança (merge base + customizações)
python ../base-sdd/scripts/resolve-context.py .sdd

# Integrar no seu projeto
cp -r .sdd/* /seu/repo/.sdd
```

Ou execute tudo de uma vez:

```bash
cd ../my-project
make -f ../base-sdd/Makefile validate DIR=.
make -f ../base-sdd/Makefile check DIR=.
make -f ../base-sdd/Makefile resolve DIR=.
```

---

## 📁 Estrutura do Projeto

```
base-sdd/
├── Makefile                    # Facilitador para init/validate/check/resolve
├── README.md                   # Este arquivo
├── LICENSE                     # MIT License
├── .gitignore
│
├── scripts/                    # Ferramentas de automação
│   ├── init-context.sh         # Wizard para criar novo contexto (30s)
│   ├── validate-config.py      # Validator de YAML schema
│   ├── check-integrity.py      # Checker de integridade
│   └── resolve-context.py      # Resolver com merge semântico
│
├── docs/                       # Documentação do projeto
│   ├── MARKETPLACE.md          # Guia marketplace (Phase 3)
│   ├── INHERITANCE-PATTERNS.md # Padrões de herança
│   ├── GENERALIZATION-GUIDE.md # Como especializar para seu stack
│   └── CHANGELOG.md            # Histórico de versões
│
└── base-sdd/                   # Estrutura base (agnóstica)
    ├── agents/                 # 8 agentes especializados
    │   ├── orchestrator-base.md
    │   ├── feature-writer-base.md
    │   ├── designer-base.md
    │   ├── planner-base.md
    │   ├── architect-base.md
    │   ├── coder-base.md
    │   ├── tester-base.md
    │   └── pr-agent-base.md
    │
    ├── skills/                 # 6 skills reutilizáveis
    │   ├── git-workflow-base.md
    │   ├── code-architecture-base.md
    │   ├── code-review-base.md
    │   ├── execution-plan-base.md
    │   ├── testing-strategy-base.md
    │   └── pr-creation-base.md
    │
    ├── docs/                   # 5 docs base
    │   ├── project-context-base.md
    │   ├── architecture-base.md
    │   ├── features-base.md
    │   ├── tech-stack-base.md
    │   └── glossary-base.md
    │
    └── templates/              # Templates de exemplo
        ├── rateapp-android/    # Contexto especializado (Kotlin + MVI)
        ├── example-react/      # Contexto especializado (React + Redux)
        └── example-node/       # Contexto especializado (Node.js + Event-Driven)
```

---

## 🔄 Como Funciona

### 1. **Estrutura Base** (agnóstica)

Arquivos `-base.md` contêm:
- `[GENÉRICO]` — Conteúdo 100% reutilizável (ex: git workflow)
- `[ESPECIALIZAÇÃO]` — Placeholders para customização (ex: linguagem, framework)
- `[EXEMPLO:xxx]` — Exemplos específicos de stack

```markdown
# Feature Writer — Base

## [GENÉRICO] Responsabilidades

- Especificar features
- Gerar acceptance criteria

## [ESPECIALIZAÇÃO] Padrão Arquitetural

{Aqui vai MVI para Android, Redux para React, etc}

## [EXEMPLO:kotlin]
@Composable fun MyScreen() { ... }

## [EXEMPLO:react]
const MyComponent = () => { ... }
```

### 2. **Especialização** (para seu contexto)

`init-context.sh` faz:

```bash
1. ✅ Copiar base-sdd/* para seu .sdd/
2. ✅ Remover tags [GENÉRICO]/[ESPECIALIZAÇÃO]/[EXEMPLO:xxx]
3. ✅ Gerar sdd-config.yaml (stack-specific)
4. ✅ Criar copilot-instructions.md
```

Resultado: `.sdd/` pronto para customização

### 3. **Validação** 

```bash
# Schema YAML
validate-config.py

# Integridade
check-integrity.py
    ├─ Tags [GENÉRICO] removidas?
    ├─ Docs referenciadas existem?
    ├─ Exemplos de código no language correto?
    └─ Padrão arquitetural documentado?
```

### 4. **Herança** (Phase 3+)

```bash
# Merge base + contexto com semântica
resolve-context.py
    ├─ Load agents-base.md + agents.md
    ├─ Merge [GENÉRICO] + [ESPECIALIZAÇÃO]
    └─ Output: .sdd-resolved/ (final)
```

---

## 🛠 Ferramentas (Makefile)

```bash
# Criar novo contexto
make init                # Interativo
make init-android        # Android com prompt
make init-react          # React com prompt
make init-node           # Node.js com prompt

# Validar contexto (interno ou externo)
make validate            # Valida ./.sdd/sdd-config.yaml
make validate DIR=../my-project   # Valida ../my-project/.sdd/

# Verificar integridade
make check               # Verifica ./.sdd/
make check DIR=../my-project

# Resolver herança
make resolve             # Resolve ./.sdd/ → ./.sdd-resolved/
make resolve DIR=../my-project

# Limpeza
make clean               # Remove .sdd-resolved/ de todos contextos

# Help
make help                # Mostra todos targets
```

---

## 📦 Stacks Suportados

### Android
- **Language:** Kotlin
- **Architecture:** Clean Architecture + MVI
- **UI Framework:** Jetpack Compose
- **State Management:** MVI Pattern
- **Testing:** JUnit + Mockk

### React
- **Language:** TypeScript
- **Architecture:** Clean Architecture
- **Framework:** React 18+
- **State Management:** Redux
- **Testing:** Jest + React Testing Library

### Node.js
- **Language:** TypeScript
- **Architecture:** Clean Architecture + Event-Driven
- **Framework:** Express
- **State Management:** Event-Driven Pattern
- **Testing:** Jest + Supertest

### Custom
Customize para qualquer stack (Python, Go, Rust, etc)

---

## 📚 Documentação Completa

- **[GENERALIZATION-GUIDE.md](./docs/GENERALIZATION-GUIDE.md)** — Como especializar base-sdd para seu stack
- **[INHERITANCE-PATTERNS.md](./docs/INHERITANCE-PATTERNS.md)** — Quais skills são 100% reutilizáveis vs 60% vs 0%
- **[MARKETPLACE.md](./docs/MARKETPLACE.md)** — Plano para Phase 3 (descobrir + instalar contextos)
- **[CHANGELOG.md](./docs/CHANGELOG.md)** — Histórico de versões

---

## 🧪 Exemplos de Uso

### Exemplo 1: Android App

```bash
cd base-sdd
make init-android

# Prompt: "Context name: rateapp-android"
# Result: ../rateapp-android/.sdd/ criado

cd ../rateapp-android
python ../base-sdd/scripts/validate-config.py .sdd/sdd-config.yaml
python ../base-sdd/scripts/check-integrity.py .sdd

# Customizar docs/
# - .sdd/docs/project-context.md
# - .sdd/docs/architecture.md
# - .sdd/docs/tech-stack.md

# Usar em seu projeto
cp -r .sdd/* ~/AndroidStudioProjects/rateapp/.sdd/
```

### Exemplo 2: React App

```bash
cd base-sdd
make init-react

# Prompt: "Context name: my-frontend"
# Result: ../my-frontend/.sdd/ criado

cd ../my-frontend
# Customizar agents/coder.md com React + TypeScript exemplos
# Customizar skills/code-arch.md com Redux patterns
```

### Exemplo 3: Validar tudo

```bash
cd base-sdd
make validate-all
# Valida todos ../*/sdd-config.yaml + integridade
```

---

## 🔐 License

MIT — Use livremente em projetos comerciais e open-source

---

## 🤝 Contributing

Quer melhorar base-sdd? Abra uma issue ou PR no GitHub!

- Bugs/features: [Issues](https://github.com/gustavoabelh/base-sdd/issues)
- Pull requests: [PRs](https://github.com/gustavoabelh/base-sdd/pulls)
- Marketplace contexts: [Market](https://github.com/gustavoabelh/base-sdd-marketplace) (Phase 3)

---

## 📞 Support

- **Problemas com scripts?** Veja [TROUBLESHOOTING.md](./docs/TROUBLESHOOTING.md)
- **Dúvidas sobre especialização?** Leia [GENERALIZATION-GUIDE.md](./docs/GENERALIZATION-GUIDE.md)
- **Quer criar um marketplace?** Veja [MARKETPLACE.md](./docs/MARKETPLACE.md)

---

**Made with ❤️ for agile teams using distributed agent systems**

![Base-SDD](https://img.shields.io/badge/Base--SDD-2.0.0--beta-blue?style=for-the-badge)
