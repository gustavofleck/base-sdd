#!/bin/bash
# init-context.sh — Inicialização SIMPLES e RÁPIDA de novo contexto SDD
# Cria estrutura dentro do projeto atual (não em pasta irmã)
# Compatível com: macOS (Darwin), Linux, Windows (Git Bash/WSL)
# 
# Uso:
#   ./init-context.sh                    (na raiz do projeto)
#   CONTEXT_NAME="meu-app" ./init-context.sh

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

# Detectar BASE_SDD_DIR (onde está o base-sdd)
if [ -z "$BASE_SDD_DIR" ]; then
    BASE_SDD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/base-sdd"
fi

if [ ! -d "$BASE_SDD_DIR/agents" ]; then
    log_error "base-sdd não encontrado em $BASE_SDD_DIR"
    exit 1
fi

# Contexto atual (onde o script é executado)
CONTEXT_NAME="${CONTEXT_NAME:-$(basename "$(pwd)")}"
CONTEXT_DIR="$(pwd)"

log_info "Inicializando SDD em: $CONTEXT_DIR"
log_info "Contexto: $CONTEXT_NAME"

# Criar .github/{agents,sdd} se não existirem
log_info "Criando estrutura em .github/"
mkdir -p "$CONTEXT_DIR/.github"/{agents,sdd/{skills,docs}}
log_ok ".github/ criado"

# Copiar arquivos base
log_info "Copiando arquivos base..."
cp "$BASE_SDD_DIR/agents"/*.md "$CONTEXT_DIR/.github/agents/" 2>/dev/null || log_warn "Nenhum arquivo agents encontrado"
cp "$BASE_SDD_DIR/skills"/*.md "$CONTEXT_DIR/.github/sdd/skills/" 2>/dev/null || log_warn "Nenhum arquivo skills encontrado"
cp "$BASE_SDD_DIR/docs"/*.md "$CONTEXT_DIR/.github/sdd/docs/" 2>/dev/null || log_warn "Nenhum arquivo docs encontrado"
log_ok "Arquivos copiados"

# Copiar base config e specialist
if [ -f "$BASE_SDD_DIR/sdd-config-base.yaml" ]; then
    cp "$BASE_SDD_DIR/sdd-config-base.yaml" "$CONTEXT_DIR/.github/sdd/sdd-config.yaml"
    log_ok "sdd-config.yaml copiado"
fi

if [ -f "$BASE_SDD_DIR/agents/specialist-base.md" ]; then
    cp "$BASE_SDD_DIR/agents/specialist-base.md" "$CONTEXT_DIR/.github/agents/"
    log_ok "specialist-base.md copiado"
fi

# Renomear -base.md para .md
log_info "Finalizando nomes de arquivos..."
find "$CONTEXT_DIR/.github" -name "*-base.md" -exec bash -c 'mv "$1" "${1%-base.md}.md"' _ {} \;
log_ok "Pronto"

# Substituir placeholders em sdd-config.yaml e agents (compatível com macOS e Linux)
log_info "Customizando sdd-config.yaml..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/your-project-name/$CONTEXT_NAME/g" "$CONTEXT_DIR/.github/sdd/sdd-config.yaml"
    sed -i '' "s/Descrição breve do seu projeto/$CONTEXT_NAME/g" "$CONTEXT_DIR/.github/sdd/sdd-config.yaml"
else
    sed -i "s/your-project-name/$CONTEXT_NAME/g" "$CONTEXT_DIR/.github/sdd/sdd-config.yaml"
    sed -i "s/Descrição breve do seu projeto/$CONTEXT_NAME/g" "$CONTEXT_DIR/.github/sdd/sdd-config.yaml"
fi
log_ok "sdd-config.yaml customizado"

log_info "Customizando agents..."
find "$CONTEXT_DIR/.github/agents" -name "*.md" -type f | while read file; do
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/your-project-name/$CONTEXT_NAME/g" "$file"
    else
        sed -i "s/your-project-name/$CONTEXT_NAME/g" "$file"
    fi
done
log_ok "agents customizados"

# Criar copilot-instructions.md NA RAIZ DO PROJETO
log_info "Criando copilot-instructions.md..."
cat > "$CONTEXT_DIR/copilot-instructions.md" << 'COPILOT_EOF'
# GitHub Copilot Instructions

## Fluxo Obrigatório

1. **Verificar Especialização**: Veja `.github/sdd/README-specialization.md` para confirmar tecnologias específicas
2. **Carregar Orchestrator**: Sempre comece por `.github/agents/orchestrator.md`
3. **Seguir Fluxo de Decisão**: Classifique a tarefa (feature / bugfix / refactor / test)
4. **Usar Agentes Apropriados**: Feature Writer → Architect → Coder → Tester → PR Agent
5. **Validar Antes de Commit**: Siga guidelines em `.github/sdd/docs/`

## Agentes Disponíveis

- **.github/agents/orchestrator.md** — Orquestra todo o fluxo (carregue primeiro!)
- **.github/agents/feature-writer.md** — Especifica features/requisitos
- **.github/agents/architect.md** — Valida design e arquitetura
- **.github/agents/coder.md** — Implementa código
- **.github/agents/tester.md** — Design de testes dados-quando-então
- **.github/agents/pr-agent.md** — Submete PR (ainda não criado)

## Próximo Passo

Customize a estrutura para sua tecnologia:
```bash
make -f ../base-sdd/Makefile specialize TECH=react
```

Ou use o agente de especialização:
```bash
copilot /specialize
```
COPILOT_EOF
log_ok "copilot-instructions.md criado"

echo ""
log_ok "✅ SDD inicializado em: $CONTEXT_DIR"
log_info ""
log_info "Estrutura criada:"
log_info "  .github/agents/           ← Agentes"
log_info "  .github/sdd/skills/       ← Skills"
log_info "  .github/sdd/docs/         ← Documentação"
log_info "  .github/sdd/sdd-config.yaml ← Configuração"
log_info "  copilot-instructions.md   ← Instruções (raiz)"
log_info ""
log_info "Próximos passos:"
log_info "  1. Especializar: make -f ../base-sdd/Makefile specialize TECH=<react|node|android|flutter|custom>"
log_info "  2. Ou invocar agente: copilot /specialize"
log_info ""
log_info "Estrutura agnóstica pronta. Tecnologia será definida na especialização!"
echo ""
