#!/bin/bash
# init-context.sh — Wizard para criar novo contexto SDD
# Uso:
#   ./init-context.sh                    (interativo)
#   ./init-context.sh my-context react   (direto)

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_ok() { echo -e "${GREEN}[OK]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Detectar BASE_SDD_DIR
if [ -z "$BASE_SDD_DIR" ]; then
    BASE_SDD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/base-sdd"
fi

if [ ! -d "$BASE_SDD_DIR/agents" ]; then
    log_error "base-sdd não encontrado em $BASE_SDD_DIR"
    exit 1
fi

# Argumentos ou interativo
if [ $# -ge 2 ]; then
    CONTEXT_NAME=$1
    STACK=$2
else
    log_info "=== Init Context Wizard ==="
    echo ""
    read -p "Context name (e.g., my-react-app): " CONTEXT_NAME
    read -p "Stack (android|react|node|custom): " STACK
fi

if [ -z "$CONTEXT_NAME" ] || [ -z "$STACK" ]; then
    log_error "Context name e Stack são obrigatórios"
    exit 1
fi

# Validar nome
if [[ ! "$CONTEXT_NAME" =~ ^[a-z0-9_-]+$ ]]; then
    log_error "Context name inválido. Use: a-z, 0-9, _, -"
    exit 1
fi

# Validar stack
case "$STACK" in
    android|react|node|custom)
        log_ok "Stack: $STACK"
        ;;
    *)
        log_error "Stack desconhecido. Use: android|react|node|custom"
        exit 1
        ;;
esac

# Criar diretório NO PARENT (uma pasta acima da raiz do projeto)
PARENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CONTEXT_DIR="$PARENT_DIR/$CONTEXT_NAME"

if [ -d "$CONTEXT_DIR" ]; then
    log_error "Contexto $CONTEXT_NAME já existe em $CONTEXT_DIR"
    exit 1
fi

log_info "Criando contexto: $CONTEXT_NAME ($STACK)"
mkdir -p "$CONTEXT_DIR"/{.sdd/agents,.sdd/skills,.sdd/docs}
log_ok "Diretórios criados"

# Copiar arquivos da base para .sdd/
log_info "Copiando arquivos base para .sdd/..."
cp "$BASE_SDD_DIR/agents"/*.md "$CONTEXT_DIR/.sdd/agents/" 2>/dev/null || log_warn "Nenhum arquivo agents encontrado"
cp "$BASE_SDD_DIR/skills"/*.md "$CONTEXT_DIR/.sdd/skills/" 2>/dev/null || log_warn "Nenhum arquivo skills encontrado"
cp "$BASE_SDD_DIR/docs"/*.md "$CONTEXT_DIR/.sdd/docs/" 2>/dev/null || log_warn "Nenhum arquivo docs encontrado"
log_ok "Arquivos copiados"

# Renomear -base.md para .md
log_info "Renomeando arquivos -base.md..."
find "$CONTEXT_DIR/.sdd" -name "*-base.md" -exec bash -c 'mv "$1" "${1%-base.md}.md"' _ {} \;
log_ok "Arquivos renomeados"

# Remover tags [GENÉRICO], [ESPECIALIZAÇÃO], [EXEMPLO]
log_info "Removendo tags [GENÉRICO], [ESPECIALIZAÇÃO]..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    find "$CONTEXT_DIR/.sdd" -name "*.md" -exec sed -i '' 's/^## \[GENÉRICO\]$//' {} \;
    find "$CONTEXT_DIR/.sdd" -name "*.md" -exec sed -i '' 's/^## \[ESPECIALIZAÇÃO\]$//' {} \;
    find "$CONTEXT_DIR/.sdd" -name "*.md" -exec sed -i '' '/^## \[EXEMPLO:[^]]*\]$/d' {} \;
    find "$CONTEXT_DIR/.sdd" -name "*.md" -exec sed -i '' 's/ \[GENÉRICO\]//g' {} \;
    find "$CONTEXT_DIR/.sdd" -name "*.md" -exec sed -i '' 's/ \[ESPECIALIZAÇÃO\]//g' {} \;
else
    # Linux/Windows (Git Bash)
    find "$CONTEXT_DIR/.sdd" -name "*.md" -exec sed -i 's/^## \[GENÉRICO\]$//' {} \;
    find "$CONTEXT_DIR/.sdd" -name "*.md" -exec sed -i 's/^## \[ESPECIALIZAÇÃO\]$//' {} \;
    find "$CONTEXT_DIR/.sdd" -name "*.md" -exec sed -i '/^## \[EXEMPLO:[^]]*\]$/d' {} \;
    find "$CONTEXT_DIR/.sdd" -name "*.md" -exec sed -i 's/ \[GENÉRICO\]//g' {} \;
    find "$CONTEXT_DIR/.sdd" -name "*.md" -exec sed -i 's/ \[ESPECIALIZAÇÃO\]//g' {} \;
fi
log_ok "Tags removidas"

# Criar sdd-config.yaml
log_info "Criando sdd-config.yaml..."
cat > "$CONTEXT_DIR/.sdd/sdd-config.yaml" << 'EOF'
base_version: "2.0.0"
context: "CONTEXT_NAME"
description: "CONTEXT_DESC — STACK"

architecture:
  pattern: "PATTERN"
  ui_framework: "FRAMEWORK"
  state_management: "STATE_MGT"
  language: "LANGUAGE"

agents:
  feat:
    file: "agents/feature-writer.md"
    active: true
  design:
    file: "agents/designer.md"
    active: true
  plan:
    file: "agents/planner.md"
    active: true
  arch:
    file: "agents/architect.md"
    active: true
  code:
    file: "agents/coder.md"
    active: true
  test:
    file: "agents/tester.md"
    active: true
  pr:
    file: "agents/pr-agent.md"
    active: true

skills:
  git-flow:
    file: "skills/git-workflow.md"
    active: true
  code-arch:
    file: "skills/code-architecture.md"
    active: true
    customization: "CUSTOMIZATION"
  exec-plan:
    file: "skills/execution-plan.md"
    active: true
  test-strat:
    file: "skills/testing-strategy.md"
    active: true
    customization: "TOOLS"
  pr-create:
    file: "skills/pr-creation.md"
    active: true
  code-rev:
    file: "skills/code-review.md"
    active: true

docs:
  project-context:
    file: "docs/project-context.md"
  architecture:
    file: "docs/architecture.md"
  features:
    file: "docs/features.md"
  tech-stack:
    file: "docs/tech-stack.md"
  glossary:
    file: "docs/glossary.md"
EOF

# Substituir placeholders conforme stack
case "$STACK" in
    android)
        sed -i.bak "s/CONTEXT_NAME/rateapp-android/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        sed -i.bak "s/CONTEXT_DESC/Community (RateApp)/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        sed -i.bak "s/STACK/Android/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        sed -i.bak "s/PATTERN/clean-architecture/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        sed -i.bak "s/FRAMEWORK/jetpack-compose/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        sed -i.bak "s/STATE_MGT/mvi/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        sed -i.bak "s/LANGUAGE/kotlin/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        sed -i.bak "s/CUSTOMIZATION/kotlin + compose/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        sed -i.bak "s/TOOLS/junit + mockk/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        ;;
    react)
        sed -i.bak "s/CONTEXT_NAME/$CONTEXT_NAME/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        sed -i.bak "s/CONTEXT_DESC/$CONTEXT_NAME/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        sed -i.bak "s/STACK/React/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        sed -i.bak "s/PATTERN/clean-architecture/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        sed -i.bak "s/FRAMEWORK/react/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        sed -i.bak "s/STATE_MGT/redux/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        sed -i.bak "s/LANGUAGE/typescript/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        sed -i.bak "s/CUSTOMIZATION/typescript + react + redux/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        sed -i.bak "s/TOOLS/jest + react-testing-library/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        ;;
    node)
        sed -i.bak "s/CONTEXT_NAME/$CONTEXT_NAME/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        sed -i.bak "s/CONTEXT_DESC/$CONTEXT_NAME/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        sed -i.bak "s/STACK/Node.js/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        sed -i.bak "s/PATTERN/clean-architecture/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        sed -i.bak "s/FRAMEWORK//g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        sed -i.bak "s/STATE_MGT/event-driven/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        sed -i.bak "s/LANGUAGE/typescript/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        sed -i.bak "s/CUSTOMIZATION/typescript + node.js + express/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        sed -i.bak "s/TOOLS/jest + supertest/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        ;;
    custom)
        sed -i.bak "s/CONTEXT_NAME/$CONTEXT_NAME/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        sed -i.bak "s/CONTEXT_DESC/$CONTEXT_NAME/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        sed -i.bak "s/STACK/Custom/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
        log_warn "Customize manualmente: pattern, framework, state_management, language"
        ;;
esac

rm -f "$CONTEXT_DIR/.sdd/sdd-config.yaml.bak"
log_ok "sdd-config.yaml criado"

# Criar copilot-instructions.md
log_info "Criando copilot-instructions.md..."
cat > "$CONTEXT_DIR/.sdd/copilot-instructions.md" << EOF
# GitHub Copilot Instructions — $CONTEXT_NAME

## Regra Principal

**Todo pedido DEVE ser direcionado ao Orchestrator (\`.sdd/agents/orchestrator.md\`).**

Leia e siga o fluxo de orquestração antes de executar qualquer tarefa.

## Fluxo Obrigatório

1. Carregar \`.sdd/agents/orchestrator.md\`
2. Classificar tarefa (feature / bugfix / refactor / docs / test)
3. Criar branch dedicada a partir de \`main\`
4. Seguir fluxo de decisão do Orchestrator
5. Commitar com conventional commits
6. Validar padrões arquiteturais
7. Atualizar SDD se necessário
8. Push + criar PR via GitHub

## Agentes Disponíveis

| ID | Agente | Responsabilidade |
|----|--------|-------------------|
| \`[A:feat]\` | Feature Writer | Especificar demandas |
| \`[A:design]\` | Designer | Design de telas |
| \`[A:plan]\` | Planner | Decompor em tarefas |
| \`[A:arch]\` | Architect | Validar arquitetura |
| \`[A:code]\` | Coder | Implementar código |
| \`[A:test]\` | Tester | Testes Given-When-Then |
| \`[A:pr]\` | PR Agent | Push + criar PR |

## Comandos Rápidos

- \`/spec <desc>\` — Especificar feature
- \`/feat <desc>\` — Fluxo completo
- \`/fix <desc>\` — Fluxo bugfix
- \`/test <scope>\` — Apenas testes
- \`/pr\` — Push branch + criar PR
- \`/branch <tipo> <slug>\` — Criar branch
- \`/status\` — Estado atual

## Restrições

- ❌ Nunca pular etapas do Orchestrator
- ❌ Nunca commitar em \`main\`
- ✅ Sempre criar branch antes de implementar
- ✅ Sempre validar padrões antes de avançar
- ✅ Sempre submeter via PR
EOF
log_ok "copilot-instructions.md criado"

echo ""
log_ok "✅ Contexto criado com sucesso em: $CONTEXT_DIR"
log_info "Próximos passos:"
log_info "  1. cd $CONTEXT_DIR"
log_info "  2. Customizar .sdd/docs/ (project-context.md, architecture.md, tech-stack.md)"
log_info "  3. Validar: python $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/validate-config.py .sdd/sdd-config.yaml"
log_info "  4. Verificar: python $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/check-integrity.py .sdd"
log_info "  5. Usar em seu projeto: cp -r .sdd/* /seu/projeto/.sdd"
echo ""
