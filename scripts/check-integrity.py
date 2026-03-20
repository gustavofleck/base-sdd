#!/usr/bin/env python3
"""
check-integrity.py — Verificador de integridade de contexto

Detecta problemas:
- Tags [GENÉRICO], [ESPECIALIZAÇÃO] remanescentes
- Docs faltantes que agentes requerem
- Exemplos de código em linguagem errada
- Padrão arquitetural documentado

Uso:
    python check-integrity.py .sdd
    python check-integrity.py .  (contexto atual)
"""

import sys
import re
from pathlib import Path
import yaml

class IntegrityChecker:
    """Verifica integridade de contexto."""

    def __init__(self, context_dir):
        self.context_dir = Path(context_dir)
        self.errors = []
        self.warnings = []
        self.info = []
        
        # Carregar config
        config_path = self.context_dir / "sdd-config.yaml"
        try:
            with open(config_path, 'r', encoding='utf-8') as f:
                self.config = yaml.safe_load(f)
        except Exception as e:
            self.config = {}
            self.log_error(f"Não conseguiu carregar sdd-config.yaml: {e}")

    def log_error(self, msg):
        self.errors.append(f"❌ {msg}")
        print(f"❌ {msg}")

    def log_warning(self, msg):
        self.warnings.append(f"⚠️  {msg}")
        print(f"⚠️  {msg}")

    def log_ok(self, msg):
        self.info.append(f"✅ {msg}")
        print(f"✅ {msg}")

    def check_generic_tags(self):
        """Verifica se tags [GENÉRICO], [ESPECIALIZAÇÃO] foram removidas."""
        print("\n[CHECK] Procurando tags remanescentes...")
        
        files_with_tags = []
        
        for md_file in self.context_dir.rglob("*.md"):
            if "base" in md_file.name:
                continue  # Skip -base.md files
            
            content = md_file.read_text(encoding='utf-8')
            
            if "[GENÉRICO]" in content:
                files_with_tags.append((md_file.relative_to(self.context_dir), "GENÉRICO"))
                self.log_error(f"Tag [GENÉRICO] em {md_file.relative_to(self.context_dir)}")
            
            if "[ESPECIALIZAÇÃO]" in content:
                files_with_tags.append((md_file.relative_to(self.context_dir), "ESPECIALIZAÇÃO"))
                self.log_error(f"Tag [ESPECIALIZAÇÃO] em {md_file.relative_to(self.context_dir)}")
            
            if "[EXEMPLO:" in content:
                # Deve ter removido [EXEMPLO:xxx]
                self.log_warning(f"Tag [EXEMPLO] encontrada em {md_file.relative_to(self.context_dir)} — customizar")
        
        if not files_with_tags:
            self.log_ok("Nenhuma tag [GENÉRICO] ou [ESPECIALIZAÇÃO] encontrada")

    def check_docs_exist(self):
        """Verifica se docs referenciadas existem."""
        print("\n[CHECK] Verificando docs existem...")
        
        docs_config = self.config.get("docs", {})
        
        for doc_id, doc_info in docs_config.items():
            doc_file = self.context_dir / doc_info.get("file", "")
            if not doc_file.exists():
                self.log_error(f"Doc {doc_id} não encontrada: {doc_info.get('file')}")
            else:
                self.log_ok(f"Doc {doc_id} existe")

    def check_agents_docs_required(self):
        """Verifica se agentes conseguem carregar docs que requerem."""
        print("\n[CHECK] Verificando agentes podem carregar docs...")
        
        agents_config = self.config.get("agents", {})
        
        for agent_id, agent_info in agents_config.items():
            # Documentos que este agente precisa
            docs_required = agent_info.get("docs_required", [])
            
            if not docs_required:
                self.log_ok(f"Agente {agent_id} sem docs_required")
                continue
            
            for doc_id in docs_required:
                doc_file = self.context_dir / self.config.get("docs", {}).get(doc_id, {}).get("file", "")
                if not doc_file.exists():
                    self.log_error(f"Agente {agent_id} requer doc {doc_id} que não existe")
                else:
                    self.log_ok(f"Agente {agent_id} consegue carregar {doc_id}")

    def check_code_examples(self):
        """Verifica se exemplos de código não são de outra linguagem."""
        print("\n[CHECK] Verificando exemplos de código...")
        
        language = self.config.get("architecture", {}).get("language", "").lower()
        
        if not language:
            self.log_warning("Linguagem não definida em architecture.language")
            return
        
        # Detectar linguagens em exemplos
        kotlin_keywords = ["@Composable", "fun ", "data class", "sealed interface", "BaseViewModel"]
        react_keywords = ["useEffect", "useState", "const ", "import ", "export ", ".tsx"]
        node_keywords = ["async ", "await ", "express", "app.get", "export default"]
        
        wrong_language_found = False
        
        for md_file in self.context_dir.rglob("*.md"):
            content = md_file.read_text(encoding='utf-8')
            
            if language == "kotlin":
                if any(kw in content for kw in react_keywords):
                    self.log_warning(f"Código React/TypeScript em contexto Kotlin: {md_file.relative_to(self.context_dir)}")
                    wrong_language_found = True
            elif language == "typescript":
                if any(kw in content for kw in kotlin_keywords):
                    self.log_warning(f"Código Kotlin em contexto TypeScript: {md_file.relative_to(self.context_dir)}")
                    wrong_language_found = True
        
        if not wrong_language_found:
            self.log_ok(f"Exemplos de código são compatíveis com {language}")

    def check_pattern_documented(self):
        """Verifica se padrão arquitetural está documentado."""
        print("\n[CHECK] Verificando padrão arquitetural...")
        
        pattern = self.config.get("architecture", {}).get("pattern", "").lower()
        
        if not pattern:
            self.log_error("architecture.pattern não definido")
            return
        
        # Verificar se é mencionado em architecture.md
        arch_file = self.context_dir / "docs" / "architecture.md"
        if arch_file.exists():
            content = arch_file.read_text(encoding='utf-8').lower()
            if pattern in content:
                self.log_ok(f"Padrão '{pattern}' documentado em architecture.md")
            else:
                self.log_warning(f"Padrão '{pattern}' pode não estar documentado em architecture.md")
        else:
            self.log_warning("architecture.md não encontrado")

    def check_orchestrator_exists(self):
        """Verifica se orchestrator exists."""
        print("\n[CHECK] Verificando orchestrador...")
        
        orch_file = self.context_dir / "agents" / "orchestrator.md"
        if orch_file.exists():
            self.log_ok("orchestrator.md existe")
        else:
            self.log_error("orchestrator.md não encontrado")

    def run(self):
        """Executa todas as verificações."""
        print(f"\n[INFO] Verificando integridade de {self.context_dir}...\n")
        
        self.check_generic_tags()
        self.check_docs_exist()
        self.check_agents_docs_required()
        self.check_code_examples()
        self.check_pattern_documented()
        self.check_orchestrator_exists()
        
        # Resumo
        print(f"\n[RESULT]")
        print(f"Erros: {len(self.errors)}")
        print(f"Avisos: {len(self.warnings)}")
        print(f"OK: {len(self.info)}")
        
        if self.errors:
            print("\n❌ Integridade comprometida. Corrigir erros acima.")
            return False
        elif self.warnings:
            print("\n⚠️  Contexto válido com avisos. Revisar acima.")
            return True
        else:
            print("\n✅ Contexto íntegro!")
            return True


def main():
    if len(sys.argv) < 2:
        context_dir = "."
    else:
        context_dir = sys.argv[1]
    
    checker = IntegrityChecker(context_dir)
    
    if checker.run():
        sys.exit(0)
    else:
        sys.exit(1)


if __name__ == "__main__":
    main()
