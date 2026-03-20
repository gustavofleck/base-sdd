#!/bin/bash
# init-context.sh — Inicialização SIMPLES e RÁPIDA de novo contexto SDD
# Usa estrutura genérica base. Especialização fica para um agente posterior.
# 
# Uso:
#   ./init-context.sh my-project                    (interativo)
#   ./init-context.sh my-project "My Project Desc"  (direto)

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
if [ $# -ge 1 ]; then
    CONTEXT_NAME=$1
    CONTEXT_DESC=${2:-"Projeto $CONTEXT_NAME"}
else
    log_info "=== SDD Init (Simples e Rápido) ==="
    echo ""
    read -p "Nome do projeto (ex: meu-app): " CONTEXT_NAME
    read -p "Descrição breve (ex: Aplicação de tarefas): " CONTEXT_DESC
fi

# Validar entrada
if [ -z "$CONTEXT_NAME" ]; then
    log_error "Nome do projeto é obrigatório"
    exit 1
fi

if [[ ! "$CONTEXT_NAME" =~ ^[a-z0-9_-]+$ ]]; then
    log_error "Nome inválido. Use: a-z, 0-9, _, -"
    exit 1
fi

# Criar diretório (uma pasta acima da raiz do projeto SDD)
PARENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CONTEXT_DIR="$PARENT_DIR/$CONTEXT_NAME"

if [ -d "$CONTEXT_DIR/.sdd" ]; then
    log_error "Contexto SDD já existe em $CONTEXT_DIR/.sdd"
    exit 1
fi

# Criar estrutura de diretórios
log_info "Criando estrutura para: $CONTEXT_NAME"
mkdir -p "$CONTEXT_DIR"/{.sdd/agents,.sdd/skills,.sdd/docs}
log_ok "Diretórios criados em $CONTEXT_DIR"

# Copiar arquivos base
log_info "Copiando arquivos base..."
cp "$BASE_SDD_DIR/agents"/*.md "$CONTEXT_DIR/.sdd/agents/" 2>/dev/null || log_warn "Nenhum arquivo agents encontrado"
cp "$BASE_SDD_DIR/skills"/*.md "$CONTEXT_DIR/.sdd/skills/" 2>/dev/null || log_warn "Nenhum arquivo skills encontrado"
cp "$BASE_SDD_DIR/docs"/*.md "$CONTEXT_DIR/.sdd/docs/" 2>/dev/null || log_warn "Nenhum arquivo docs encontrado"
log_ok "Arquivos copiados"

# Copiar specialist-base.md para agents/ (será usado durante specialization)
if [ -f "$BASE_SDD_DIR/agents/specialist-base.md" ]; then
    cp "$BASE_SDD_DIR/agents/specialist-base.md" "$CONTEXT_DIR/.sdd/agents/"
    log_ok "specialist-base.md copiado"
fi

# Renomear -base.md para .md
log_info "Finalizando nomes de arquivos..."
find "$CONTEXT_DIR/.sdd" -name "*-base.md" -exec bash -c 'mv "$1" "${1%-base.md}.md"' _ {} \;
log_ok "Pronto"

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
# Criar sdd-config.yaml genérico (cópia de sdd-config-base.yaml)
log_info "Criando sdd-config.yaml..."
cp "$BASE_SDD_DIR/sdd-config-base.yaml" "$CONTEXT_DIR/.sdd/sdd-config.yaml"

# Substituir placeholders mínimos
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/your-project-name/$CONTEXT_NAME/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
    sed -i '' "s/Descrição breve do seu projeto/$CONTEXT_DESC/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
else
    sed -i "s/your-project-name/$CONTEXT_NAME/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
    sed -i "s/Descrição breve do seu projeto/$CONTEXT_DESC/g" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
fi
log_ok "sdd-config.yaml criado (genérico)"

# Criar copilot-instructions.md minimal
log_info "Criando copilot-instructions.md..."
cat > "$CONTEXT_DIR/copilot-instructions.md" << 'EOF'
# GitHub Copilot Instructions

## Fluxo Obrigatório

1. **Verificar Especialização**: Veja `.sdd/README-especialization.md` para confirmar tecnologias específicas
2. **Llevar Orchestrator**: Sempre comece por `.sdd/agents/orchestrator.md`
3. **Seguir Fluxo de Decisão**: Classifique a tarefa (feature / bugfix / refactor / test)
4. **Usar Agentes Apropriados**: Feature Writer → Architect → Coder → Tester → PR Agent
5. **Validar Antes de Commit**: Siga guidelines em `.sdd/docs/`

## Agentes Disponíveis

- **orchestrator.md** — Orquestra todo o fluxo (carregue primeiro!)
- **feature-writer.md** — Especifica features/requisitos
- **architect.md** — Valida design e arquitetura
- **coder.md** — Implementa código
- **tester.md** — Design de testes dados-quando-então
- **pr-agent.md** — Submete PR (ainda não criado)

## Próximo Passo

Após `make init` completar, customize a estrutura para sua tecnologia:
```bash
cd $CONTEXT_NAME
make specialize TECH=react
# ou: make specialize TECH=node, TECH=android, etc
```

Ou use o agente de especialização:
```bash
copilot /specialize
```
EOF
log_ok "copilot-instructions.md criado"

echo ""
log_ok "✅ Contexto SDD criado: $CONTEXT_DIR"
log_info "Próximos passos:"
log_info "  1. cd $CONTEXT_NAME"
log_info "  2. Especializar: make specialize TECH=<react|node|android|custom>"
log_info "  3. Ou convocar agente: copilot /specialize"
log_info ""
log_info "Todo o resto fica para o agente de especialização!"
echo ""
