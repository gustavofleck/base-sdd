.PHONY: help init init-android init-react init-node validate check resolve clean

# Colors for output
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m # No Color

# Default target
help:
	@echo "$(BLUE)╔════════════════════════════════════════════════════════════╗$(NC)"
	@echo "$(BLUE)║          Base-SDD — Sistema de Decisão Distribuído         ║$(NC)"
	@echo "$(BLUE)╚════════════════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "$(GREEN)Targets disponíveis:$(NC)"
	@echo ""
	@echo "  $(YELLOW)make init-android$(NC)   — Criar novo contexto Android (Kotlin + Compose)"
	@echo "  $(YELLOW)make init-react$(NC)     — Criar novo contexto React (TypeScript + Redux)"
	@echo "  $(YELLOW)make init-node$(NC)      — Criar novo contexto Node.js (TypeScript + Express)"
	@echo "  $(YELLOW)make init$(NC)           — Assistente interativo para criar contexto"
	@echo ""
	@echo "  $(YELLOW)make validate [DIR=.]$(NC)    — Validar configuração YAML"
	@echo "  $(YELLOW)make check [DIR=.]$(NC)       — Verificar integridade de contexto"
	@echo "  $(YELLOW)make resolve [DIR=.]$(NC)     — Resolver herança (merge base + contexto)"
	@echo ""
	@echo "  $(YELLOW)make clean$(NC)           — Remover arquivos gerados (.sdd-resolved/)"
	@echo "  $(YELLOW)make help$(NC)            — Mostrar esta mensagem"
	@echo ""
	@echo "$(GREEN)Exemplos de uso:$(NC)"
	@echo ""
	@echo "  $$ make init-react               # (prompt será pedido nome do projeto)"
	@echo "  $$ make init-android             # (prompt será pedido nome do projeto)"
	@echo ""
	@echo "$(YELLOW)Estrutura de diretórios esperada:$(NC)"
	@echo "  base-sdd/                        ← Clone do GitHub"
	@echo "  ├── Makefile"
	@echo "  ├── scripts/"
	@echo "  │   ├── init-context.sh"
	@echo "  │   ├── validate-config.py"
	@echo "  │   ├── check-integrity.py"
	@echo "  │   └── resolve-context.py"
	@echo "  └── base-sdd/                    ← Estrutura base SDD"
	@echo ""
	@echo "Novos projetos SDD são criados $(RED)UMA PASTA ACIMA$(NC) do clone:"
	@echo "  ../my-project/                   ← Novo contexto criado aqui"
	@echo "  ├── .sdd/                        ← Estrutura SDD customizada"
	@echo "  ├── copilot-instructions.md"
	@echo "  └── ... (seus arquivos de projeto)"
	@echo ""

# Initialize with interactive prompt
init:
	@echo "$(BLUE)╔════════════════════════════════════════════════════════════╗$(NC)"
	@echo "$(BLUE)║          SDD Context Initialization — Interactive          ║$(NC)"
	@echo "$(BLUE)╚════════════════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@bash $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/scripts/init-context.sh

# Initialize Android context with parameter
init-android:
	@read -p "$(YELLOW)Context name (e.g., my-android-app): $(NC)" CONTEXT_NAME; \
	[ -n "$$CONTEXT_NAME" ] && bash $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/scripts/init-context.sh $$CONTEXT_NAME android \
	|| (echo "$(RED)❌ Nome do contexto é obrigatório$(NC)" && exit 1)

# Initialize React context with parameter
init-react:
	@read -p "$(YELLOW)Context name (e.g., my-react-app): $(NC)" CONTEXT_NAME; \
	[ -n "$$CONTEXT_NAME" ] && bash $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/scripts/init-context.sh $$CONTEXT_NAME react \
	|| (echo "$(RED)❌ Nome do contexto é obrigatório$(NC)" && exit 1)

# Initialize Node.js context with parameter
init-node:
	@read -p "$(YELLOW)Context name (e.g., my-api): $(NC)" CONTEXT_NAME; \
	[ -n "$$CONTEXT_NAME" ] && bash $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/scripts/init-context.sh $$CONTEXT_NAME node \
	|| (echo "$(RED)❌ Nome do contexto é obrigatório$(NC)" && exit 1)

# Validate context configuration
validate:
	@DIR=${DIR:-.}; \
	if [ -f "$$DIR/.sdd/sdd-config.yaml" ]; then \
		python $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/scripts/validate-config.py "$$DIR/.sdd/sdd-config.yaml"; \
	elif [ -f "$$DIR/sdd-config.yaml" ]; then \
		python $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/scripts/validate-config.py "$$DIR/sdd-config.yaml"; \
	else \
		echo "$(RED)❌ sdd-config.yaml não encontrado em $$DIR/.sdd/ ou $$DIR/$(NC)"; \
		exit 1; \
	fi

# Check context integrity
check:
	@DIR=${DIR:-.}; \
	if [ -d "$$DIR/.sdd" ]; then \
		python $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/scripts/check-integrity.py "$$DIR/.sdd"; \
	else \
		echo "$(RED)❌ Diretório .sdd não encontrado em $$DIR/$(NC)"; \
		exit 1; \
	fi

# Resolve inheritance (merge base + context)
resolve:
	@DIR=${DIR:-.}; \
	if [ -d "$$DIR/.sdd" ]; then \
		python $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/scripts/resolve-context.py "$$DIR/.sdd"; \
	else \
		echo "$(RED)❌ Diretório .sdd não encontrado em $$DIR/$(NC)"; \
		exit 1; \
	fi

# Clean generated files
clean:
	@echo "$(YELLOW)Limpando arquivos gerados...$(NC)"
	@find .. -type d -name ".sdd-resolved" -exec rm -rf {} + 2>/dev/null || true
	@find .. -type d -name ".sdd-context.tgz" -exec rm -f {} + 2>/dev/null || true
	@echo "$(GREEN)✅ Limpeza concluída$(NC)"

# Quick validation + check
validate-all:
	@echo "$(BLUE)Validando todos os contextos...$(NC)"
	@for context in ../*/; do \
		if [ -f "$$context/.sdd/sdd-config.yaml" ]; then \
			echo ""; \
			echo "$(YELLOW)Validating $$context$(NC)"; \
			python $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/scripts/validate-config.py "$$context/.sdd/sdd-config.yaml" && \
			python $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/scripts/check-integrity.py "$$context/.sdd"; \
		fi; \
	done

.SILENT:
