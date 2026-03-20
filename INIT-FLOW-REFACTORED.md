# Novo Fluxo de Inicialização SDD

## Problema Resolvido

✅ **Inicialização era muito complexa** — múltiplos comandos tech-specific (android, react, node)
✅ **Agora é simples e rápida** — um único fluxo de 2 passos: init + specialize

---

## Novo Workflow

### Passo 1: Inicialização (< 2 segundos)

```bash
cd base-sdd
make init
```

**Output:**
```
Nome do projeto (ex: meu-app): meu-app
Descrição breve (ex: Aplicação de tarefas): Minha aplicação super legal
...
✅ Contexto SDD criado: ../meu-app
Próximos passos:
  1. cd meu-app
  2. Especializar: make specialize TECH=<react|node|android|flutter|custom>
```

**Estrutura Criada:**
```
../meu-app/
├── .sdd/
│   ├── agents/
│   │   ├── orchestrator.md (genérico)
│   │   ├── feature-writer.md (genérico)
│   │   ├── architect.md (genérico)
│   │   ├── coder.md (genérico)
│   │   ├── tester.md (genérico)
│   │   └── specialist.md (ferramenta para fase seguinte)
│   ├── skills/
│   │   ├── git-workflow.md (genérico)
│   │   └── ... (genéricos)
│   ├── docs/
│   │   ├── project-context.md (genérico)
│   │   ├── agents-vs-skills.md
│   │   └── ... (genéricos)
│   └── sdd-config.yaml (AGNÓSTICO)
└── copilot-instructions.md (referencia especialização)
```

### Passo 2: Especialização (< 1 minuto com agente)

```bash
cd meu-app
make specialize TECH=react
```

**Output (AGORA):**
```
Especialização automatizada ainda não implementada.

Próximos passos (manual):
  1. Abrir .sdd/specialist.md
  2. Seguir instruções para:
     - Editar sdd-config.yaml com tech stack
     - Remover tags [ESPECIALIZAÇÃO] dos agentes
     - Customizar skills
     - Criar docs tech-specific
     - Gerar README-specialization.md
```

**Output (DEPOIS — via agente):**
```
✅ Especialização para React concluída!

Arquivos customizados:
  ✅ .sdd/sdd-config.yaml (React-specific)
  ✅ .sdd/agents/feature-writer.md (Redux patterns)
  ✅ .sdd/agents/architect.md (React validations)
  ✅ .sdd/agents/coder.md (Hooks best practices)
  ✅ .sdd/agents/tester.md (React Testing Library)
  ✅ .sdd/skills/git-workflow.md (jest + lint checks)
  ✅ .sdd/docs/tech-stack.md (Vite + Redux + Jest)
  ✅ .sdd/docs/architecture.md (React folder structure)
  ✅ .sdd/README-specialization.md (NOVO!)

Pronto para começar! Use:
  $ make validate    # Validar config
  $ make check       # Verificar integridade
  $ copilot /help    # Ver comandos
```

---

## O Que Mudou?

### Antes (COMPLEXO)
```bash
make init-react      # wizard pedia tech-specific inputs
make init-android    # duplicava lógica de inicialização
make init-node       # cada tech tinha seu próprio path
```

❌ Problema: 3 comandos, lógica quebrada, não escalava

### Agora (SIMPLES)
```bash
make init                    # Uma inicialização genérica universal
make specialize TECH=react   # Especialização separada por technologia
```

✅ Vantagem:
- Mesma estrutura base para qualquer tech
- Fácil adicionar novas tecnologias
- Especialização fica clara e documentada
- Agente (specialist) controla tudo

---

## Arquivos Atualizados

### [init-context.sh](./scripts/init-context.sh)
```diff
- Removido: case statement para android/react/node
- Removido: sed substituições tech-specific
- Adicionado: cópia simples de sdd-config-base.yaml
- Adicionado: cópia de specialist-base.md para .sdd/agents/
```
**Antes:** 260+ linhas complexas
**Agora:** ~80 linhas limpas

### [Makefile](./Makefile)
```diff
- Removido: make init-android, make init-react, make init-node
- Adicionado: make specialize TECH=<type>
- Simplificado: help text
```

### [specialist-base.md](./base-sdd/agents/specialist-base.md)
**Novo arquivo** — Agente de especialização com:
- Fluxo para coletar inputs (tech, language, tools)
- Instruções para customizar sdd-config.yaml
- Instruções para especializar agentes
- Instruções para customizar skills
- Instruções para gerar docs tech-specific
- Exemplo de saída para React

---

## Usado Por

**Pré-requisito:**
- Ter base-sdd clonado em diretório local
- PowerShell ou Bash (Git Bash no Windows)
- Python 3.x (validação scripts)

**Quem usa:**
- Engenheiros iniciando novo projeto SDD
- Equipes migrando para SDD framework
- Agente Specialist (especialização)

---

## Próximos Passos

### Curto Prazo (Automatizar Especialização)
- [ ] Criar script `specialize-context.sh` que:
  - Copia specialist-base.md para specialist.md
  - Lê inputs do usuário (tech, language, etc)
  - Parse templates de tech (React, Node, Android, etc)
  - Customiza sdd-config.yaml
  - Gera README-specialization.md

### Médio Prazo
- [ ] Integrar com Copilot `/specialize` command
- [ ] Criar templates para cada tech (react.yaml, node.yaml, etc)
- [ ] Adicionar mais tecnologias (Rust, Go, Python, etc)

### Longo Prazo
- [ ] Documentação migração para projetos existentes
- [ ] Dashboard web para gerenciar contextos
- [ ] Templates para diferentes padrões arquiteturais

---

## FAQ

### P: Posso usar `make specialize` agora?
**R:** `make specialize TECH=react` funciona, mas atualmente mostra instruções manuais. A automatização vem em breve.

### P: Por que separar init e specialize?
**R:** Simplicidade. `init` é genérico (descentralizado), `specialize` é tech-specific. Uma fase rápida, outra customizável.

### P: E se usar `make init` sem depois specializar?
**R:** Funciona! Estrutura genérica já é operacional. Agentes esperam inputs agnósticos. Você só fica sem otimizações tech-specific.

### P: Como adicionar nova tecnologia?
**R:** Criar template em `specialist-base.md` na seção `[ESPECIALIZAÇÃO: minha-tech]` com exemplos específicos. Aí executar `make specialize TECH=minha-tech`.

---

## Arquitetura

```
base-sdd/
├── Makefile (targets: init, specialize)
├── scripts/
│   ├── init-context.sh (cria genérico)
│   └── specialize-context.sh (TODO: especializa)
└── base-sdd/
    ├── sdd-config-base.yaml (template genérico)
    └── agents/
        ├── orchestrator-base.md (genérico)
        └── specialist-base.md (NEW: guia especialização)

meu-app/  (criado por make init)
├── .sdd/
│   ├── sdd-config.yaml (cópia de base, customizável)
│   ├── agents/
│   │   ├── orchastrator.md (cópia de base)
│   │   └── specialist.md (ferramenta)
│   └── docs/
│       └── (templates genéricos)
└── copilot-instructions.md
```

---

## Conclução

✅ **Init agora é simples e rápido**
✅ **Especialização é clara e documen tada**
✅ **Escalável para novas tecnologias**
✅ **Agnóstico por padrão**

🚀 Pronto para usar!
