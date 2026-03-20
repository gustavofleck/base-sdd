# Base-SDD — Specification Driven Development

[![Version](https://img.shields.io/badge/version-2.0.0-blue)](./docs/CHANGELOG.md)
[![License](https://img.shields.io/badge/license-MIT-green)](./LICENSE)
[![Python 3.7+](https://img.shields.io/badge/python-3.7%2B-blue)](https://www.python.org/)
[![Bash 4.0+](https://img.shields.io/badge/bash-4.0%2B-blue)](https://www.gnu.org/software/bash/)

## 📋 Descrição

**Base-SDD** é um framework agnóstico para desenvolvimento inteligente baseado em especificações. Oferece um sistema de orquestração de agentes especializados (Feature Writers, Architects, Coders, Testers, etc.) reutilizável em qualquer contexto, linguagem ou tecnologia.

O projeto oferece:
- ✅ **Estrutura base genérica** (agents, skills, docs) compilada em Markdown
- ✅ **Sistema de especialização** (`[GENÉRICO]`, `[ESPECIALIZAÇÃO]` tags)
- ✅ **Validação automática** de configuração YAML + integridade de contexto
- ✅ **Orquestração inteligente** via agentes + skills + documentação
- ✅ **Escalável para marketplace** (Phase 3+4 planejado)

## 🚀 Quick Start

### 1. Clone o repositório (uma única vez)

```bash
git clone https://github.com/gustavofleck/base-sdd.git
```

### 2. Passo 1 — Init (Simples & Rápido)

**Na raiz do seu projeto:**

```bash
cd seu-projeto
make -f ../base-sdd/Makefile init

# Ou no Windows (PowerShell):
.\scripts\init-context.ps1
```

**Resultado:** Estrutura SDD criada **dentro** do seu projeto:

```
seu-projeto/
├── agents/                      ← Agentes (genéricos, na raiz)
├── .github/
│   └── sdd/
│       ├── skills/              ← Skills (reutilizáveis)
│       ├── docs/                ← Documentação (templates)
│       └── sdd-config.yaml      ← Configuração (agnóstica)
├── copilot-instructions.md      ← Instruções
└── ... (seu código)
```

### 3. Passo 2 — Specialize (Customização para Tecnologia)

```bash
# Ainda na raiz do projeto
make -f ../base-sdd/Makefile specialize TECH=react
# Opções: react, node, android, flutter, custom
```

Isto irá:
- ✅ Customizar `.github/sdd/sdd-config.yaml` com tech stack específico
- ✅ Especializar agentes (feature-writer, architect, coder, tester) para sua tech
- ✅ Customizar skills (ci/cd, testing, etc)
- ✅ Gerar documentação tech-specific (tech-stack.md, architecture.md, etc)
- ✅ Criar `.github/sdd/README-specialization.md` documentando tudo

> **Nota**: Especialização automatizada está em desenvolvimento. Atualmente mostra instruções (leia `.github/sdd/specialist.md`).

### 4. Validar e usar

```bash
# Validar configuração YAML
make -f ../base-sdd/Makefile validate DIR=.

# Verificar integridade (tags, docs, etc)
make -f ../base-sdd/Makefile check DIR=.

# Resolver herança (merge base + customizações)
make -f ../base-sdd/Makefile resolve DIR=.
```

Ou com Python diretamente:

```bash
python ../base-sdd/scripts/validate-config.py .github/sdd/sdd-config.yaml
python ../base-sdd/scripts/check-integrity.py .github/sdd
python ../base-sdd/scripts/resolve-context.py .github/sdd
```

---

## �️ Compatibilidade Multiplataforma

✅ **Windows**, **macOS**, **Linux** — Totalmente suportado!

| SO | Método | Pré-requisito |
|----|--------|---|
| **macOS** | `make init` | Nada (já vem pronto) |
| **Linux** | `make init` | `sudo apt install build-essential python3` |
| **Windows (PowerShell)** | `.\scripts\init-context.ps1` | PowerShell 5.0+ + Python 3.7+ |
| **Windows (Git Bash)** | `make init` | Git for Windows + Make |
| **Windows (WSL 2)** | `make init` (no WSL) | WSL 2 instalado |

Para detalhes completos, veja [**CROSS-PLATFORM-GUIDE.md**](./CROSS-PLATFORM-GUIDE.md) — guia passo a passo para cada SO.

---

## �📁 Estrutura do Projeto

```
base-sdd/
├── Makefile                    # Facilitador para init/validate/check/resolve
├── README.md                   # Este arquivo
├── LICENSE                     # MIT License
├── .gitignore
│
├── scripts/                    # Ferramentas de automação (multiplatforma)
│   ├── init-context.sh         # Init para macOS/Linux (Bash 4.0+)
│   ├── init-context.ps1        # Init para Windows (PowerShell 5.0+)
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
    │   ├── orchestrator-base.md     # Orquestra todo o fluxo
    │   ├── feature-writer-base.md   # Especifica features/requisitos
    │   ├── architect-base.md        # Valida design e arquitetura
    │   ├── coder-base.md            # Implementa código
    │   ├── tester-base.md           # Desenha testes (Given-When-Then)
    │   ├── pr-agent-base.md         # Submete pull requests
    │   └── specialist-base.md       # Especializa estrutura para tech
    │
    ├── skills/                 # 6 skills reutilizáveis (carregados sob demanda)
    │   ├── git-workflow-base.md
    │   ├── code-architecture-base.md
    │   ├── code-review-base.md
    │   ├── execution-plan-base.md
    │   ├── testing-strategy-base.md
    │   └── pr-creation-base.md
    │
    ├── docs/                   # Documentação genérica
    │   ├── project-context-base.md
    │   ├── agents-vs-skills.md
    │   ├── architecture-base.md
    │   ├── specifications-base.md
    │   ├── guidelines-base.md
    │   └── glossary-base.md
    │
    └── sdd-config-base.yaml    # Template de configuração (agnóstico)
```

---

## 🔄 Workflow: 2 Passos Simples

### Passo 1: Init (Genérico)
```bash
$ make init
→ Nome projeto + Descrição
→ Estrutura base criada (agnóstica)
→ ~2 segundos
```

### Passo 2: Specialize (Tecnologia)
```bash
$ cd projeto
$ make -f ../base-sdd/Makefile specialize TECH=react
→ Customização para React
→ Agentes especializados
→ Docs tech-specific
→ ~1 minuto (manual, depois automatizado)
```

**Resultado Final:**
- ✅ Estrutura pronta para sua tecnologia
- ✅ Agentes com padrões específicos
- ✅ Documentação atualizada
- ✅ Pronto para usar com GitHub Copilot

Veja [INIT-FLOW-REFACTORED.md](./INIT-FLOW-REFACTORED.md) para mais detalhes.

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

### 2. **Especialização** (via Specialist Agent)

`specialist-base.md` guia:

```bash
1. ✅ Coletar inputs (tech, language, testing framework, etc)
2. ✅ Customizar sdd-config.yaml com tech stack
3. ✅ Remover tags [ESPECIALIZAÇÃO] dos agentes
4. ✅ Especializar agentes para sua tech
5. ✅ Customizar skills (CI/CD, testing, etc)
6. ✅ Gerar docs tech-specific
7. ✅ Criar README-specialization.md
```

Resultado: `.sdd/` 100% customizado para sua tecnologia

### 3. **Validação** 

```bash
# Schema YAML
make validate DIR=.

# Integridade
make check DIR=.
    ├─ Tags [GENÉRICO] removidas?
    ├─ Docs referenciadas existem?
    ├─ Exemplos de código no language correto?
    └─ Padrão arquitetural documentado?
```

### 4. **Herança** (resolve + merge)

```bash
# Merge base + contexto com semântica
make resolve DIR=.
    ├─ Load agents-base.md + agents.md
    ├─ Merge [GENÉRICO] + [ESPECIALIZAÇÃO]
    └─ Output: .sdd-resolved/ (final)
```

---

## 🛠 Ferramentas (Makefile)

```bash
# Passo 1: Criar novo contexto (genérico)
make init                # Interativo, cria estrutura agnóstica

# Passo 2: Especializar para tecnologia
make specialize TECH=react           # Opções: react, node, android, flutter, custom
make specialize TECH=node
make specialize TECH=android

# Validar contexto (interno ou externo)
make validate            # Valida ./.sdd/sdd-config.yaml
make validate DIR=../my-project      # Valida ../my-project/.sdd/

# Verificar integridade
make check               # Verifica ./.sdd/
make check DIR=../my-project

# Resolver herança
make resolve             # Resolve ./.sdd/ → ./.sdd-resolved/
make resolve DIR=../my-project

# Limpeza
make clean               # Remove .sdd-resolved/ de todos contextos

# Help
make help                # Mostra todos os targets
```

**Diferença entre Passo 1 e 2:**
- **Passo 1 (init)**: Agnóstico, rápido, genérico para qualquer tech
- **Passo 2 (specialize)**: Tech-specific, customiza agentes + skills + docs
make help                # Mostra todos targets
```

---

## 📦 Stacks Suportados

Baseado no novo workflow, **qualquer stack é suportado**:

- ✅ **React** — Vite + TypeScript + Redux
- ✅ **Node.js** — Express + TypeScript
- ✅ **Android** — Kotlin + Compose
- ✅ **Flutter** — Dart + Provider/Riverpod
- ✅ **Fast API** — Python + async/await
- ✅ **Custom** — Qualquer combinação

**Como usar:**
```bash
make init                           # Estrutura genérica
make specialize TECH=seu-stack      # Customizar para sua tech
```

O agente **Specialist** guia a customização para qualquer stack!

---

## 📚 Documentação Completa

- **[INIT-FLOW-REFACTORED.md](./INIT-FLOW-REFACTORED.md)** — Novo workflow de 2 passos (init + specialize)
- **[GENERALIZATION-GUIDE.md](./docs/GENERALIZATION-GUIDE.md)** — Como especializar base-sdd para seu stack
- **[INHERITANCE-PATTERNS.md](./docs/INHERITANCE-PATTERNS.md)** — Quais skills são 100% reutilizáveis vs 60% vs 0%
- **[MARKETPLACE.md](./docs/MARKETPLACE.md)** — Plano para Phase 3 (descobrir + instalar contextos)
- **[CHANGELOG.md](./docs/CHANGELOG.md)** — Histórico de versões

---

## 🧪 Exemplos de Uso

### Exemplo 1: React App

```bash
# Passo 1: Init
cd base-sdd
make init

# Respostas:
#   Nome: meu-app
#   Desc: Minha aplicação React

# Passo 2: Specialize
cd ../meu-app
make -f ../base-sdd/Makefile specialize TECH=react

# Resultado:
#   ✅ sdd-config.yaml customizado para React
#   ✅ Agentes especializados (Redux patterns, etc)
#   ✅ Skills tech-specific (jest + lint checks)
#   ✅ README-specialization.md criado
```

Depois, use com GitHub Copilot:
```bash
# Dentro do projeto
copilot /feat "Nova página de login"
```

### Exemplo 2: Node.js API

```bash
cd base-sdd
make init
# → meu-api

cd ../meu-api
make -f ../base-sdd/Makefile specialize TECH=node
```

### Exemplo 3: Android App

```bash
cd base-sdd
make init
# → meu-app-android

cd ../meu-app-android
make -f ../base-sdd/Makefile specialize TECH=android
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
