.PHONY: help init specialize validate check resolve clean

# Colors for output
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m # No Color

# Default target
help:
	@echo "$(BLUE)╔════════════════════════════════════════════════════════════╗$(NC)"
	@echo "$(BLUE)║     Base-SDD — Specification Driven Development            ║$(NC)"
	@echo "$(BLUE)╚════════════════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "$(GREEN)Workflow (Dois Passos):$(NC)"
	@echo ""
	@echo "  $(YELLOW)Passo 1 — Inicialização Rápida:$(NC)"
	@echo "    $$ make init"
	@echo ""
	@echo "  $(YELLOW)Passo 2 — Especialização (Tecnologia):$(NC)"
	@echo "    $$ cd <projeto>"
	@echo "    $$ make specialize TECH=react"
	@echo "           # ou: node, android, flutter, custom"
	@echo ""
	@echo "$(GREEN)Comandos Disponíveis:$(NC)"
	@echo ""
	@echo "  $(YELLOW)make init$(NC)                    — Criar novo contexto SDD (genérico)"
	@echo "  $(YELLOW)make specialize TECH=<type>$(NC)  — Especializar para tecnologia"
	@echo "  $(YELLOW)make validate [DIR=.]$(NC)       — Validar sdd-config.yaml"
	@echo "  $(YELLOW)make check [DIR=.]$(NC)          — Verificar integridade .sdd/"
	@echo "  $(YELLOW)make resolve [DIR=.]$(NC)        — Resolver herança (merge base)"
	@echo "  $(YELLOW)make clean [DIR=.]$(NC)          — Remover .sdd-resolved/"
	@echo ""
	@echo "$(YELLOW)Estrutura de Diretórios:$(NC)"
	@echo "  base-sdd/                        ← Clone do GitHub"
	@echo "  ├── Makefile"
	@echo "  ├── scripts/"
	@echo "  └── base-sdd/                    ← Templates genéricos"
	@echo ""
	@echo "  ../meu-projeto/                  ← Novo projeto (criado acima)"
	@echo "  ├── .sdd/                        ← Estrutura SDD customizada"
	@echo "  ├── copilot-instructions.md"
	@echo "  └── ... (seu código)"
	@echo ""

# Initialize with interactive prompt (SIMPLE + FAST)
# Compatível com: Windows, macOS, Linux
# Executa na RAIZ do projeto (cria .github/sdd/)
# Uso: cd seu-projeto && make -f ../base-sdd/Makefile init
init:
	@echo "$(BLUE)╔════════════════════════════════════════════════════════════╗$(NC)"
	@echo "$(BLUE)║      SDD Init — Simples, Rápido, Agnóstico                 ║$(NC)"
	@echo "$(BLUE)║      Executando em: $(shell pwd)                         ║$(NC)"
	@echo "$(BLUE)╚════════════════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@bash $(dir $(realpath $(lastword $(MAKEFILE_LIST))))/scripts/init-context.sh

# Specialize for specific technology
specialize:
	@if [ -z "$(TECH)" ]; then \
		echo "$(RED)❌ TECH é obrigatória. Use: make specialize TECH=react$(NC)"; \
		echo "   Tecnologias suportadas: react, node, android, flutter, custom"; \
		exit 1; \
	fi
	@echo "$(BLUE)╔════════════════════════════════════════════════════════════╗$(NC)"
	@echo "$(BLUE)║        SDD Specialization — Tech: $(TECH)$(NC)"
	@echo "$(BLUE)╚════════════════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "$(YELLOW)⚠️  Especialização automatizada ainda não implementada.$(NC)"
	@echo ""
	@echo "$(GREEN)Próximos passos (manual):$(NC)"
	@echo ""
	@echo "  1. Abrir .sdd/specialist-base.md (cópia de base-sdd/agents/specialist-base.md)"
	@echo "  2. Seguir instruções para especializar:"
	@echo "     - Editar sdd-config.yaml com tech stack específico"
	@echo "     - Remover tags [ESPECIALIZAÇÃO] dos agentes"
	@echo "     - Customizar skills para $(TECH)"
	@echo "     - Criar docs tech-specific em .sdd/docs/"
	@echo "     - Gerar .sdd/README-specialization.md"
	@echo ""
	@echo "  3. Ou usar o agente Specialist (quando integrado com Copilot):"
	@echo "     copilot /specialize $(TECH)"
	@echo ""

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
