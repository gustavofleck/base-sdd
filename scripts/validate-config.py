#!/usr/bin/env python3
"""
validate-config.py — Validador de sdd-config.yaml

Valida schema, tipos, integridade de arquivos.

Uso:
    python validate-config.py sdd-config.yaml
    python validate-config.py contexts/my-context/sdd-config.yaml
"""

import sys
import yaml
from pathlib import Path

class ConfigValidator:
    """Valida sdd-config.yaml contra schema."""

    def __init__(self, config_path):
        self.path = Path(config_path)
        self.config_dir = self.path.parent
        self.errors = []
        self.warnings = []

    def log_error(self, msg):
        self.errors.append(f"❌ {msg}")
        print(f"❌ {msg}")

    def log_warning(self, msg):
        self.warnings.append(f"⚠️  {msg}")
        print(f"⚠️  {msg}")

    def log_ok(self, msg):
        print(f"✅ {msg}")

    def validate_yaml_syntax(self):
        """Valida YAML syntax."""
        try:
            with open(self.path, 'r', encoding='utf-8') as f:
                self.config = yaml.safe_load(f)
            self.log_ok("YAML syntax válido")
            return True
        except yaml.YAMLError as e:
            self.log_error(f"YAML inválido: {e}")
            return False
        except FileNotFoundError:
            self.log_error(f"Arquivo não encontrado: {self.path}")
            return False

    def validate_required_fields(self):
        """Valida campos obrigatórios."""
        required = ["base_version", "context", "description", "architecture", "agents", "skills", "docs"]
        for field in required:
            if field not in self.config:
                self.log_error(f"Campo obrigatório faltando: {field}")
            else:
                self.log_ok(f"Campo obrigatório encontrado: {field}")

    def validate_types(self):
        """Valida tipos."""
        # base_version
        if not isinstance(self.config.get("base_version"), str):
            self.log_error("base_version deve ser string")
        
        # context
        if not isinstance(self.config.get("context"), str):
            self.log_error("context deve ser string")
        
        # architecture
        arch = self.config.get("architecture", {})
        if not isinstance(arch, dict):
            self.log_error("architecture deve ser dict")
        else:
            for key in ["pattern", "language"]:
                if key not in arch:
                    self.log_error(f"architecture.{key} obrigatório")
            self.log_ok("architecture válido")
        
        # agents
        agents = self.config.get("agents", {})
        if not isinstance(agents, dict):
            self.log_error("agents deve ser dict")
        else:
            for agent_id, agent_config in agents.items():
                if not isinstance(agent_config, dict):
                    self.log_error(f"agents.{agent_id} deve ser dict")
                elif "file" not in agent_config or "active" not in agent_config:
                    self.log_error(f"agents.{agent_id} faltam 'file' ou 'active'")
                else:
                    self.log_ok(f"Agent {agent_id} válido")

    def validate_files_exist(self):
        """Valida que arquivos referenciados existem."""
        # Agentes
        agents = self.config.get("agents", {})
        for agent_id, agent_config in agents.items():
            file_path = self.config_dir / agent_config.get("file", "")
            if not file_path.exists():
                self.log_error(f"Agente {agent_id}: arquivo não existe: {agent_config['file']}")
            else:
                self.log_ok(f"Agente {agent_id}: arquivo existe")

        # Skills
        skills = self.config.get("skills", {})
        for skill_id, skill_config in skills.items():
            file_path = self.config_dir / skill_config.get("file", "")
            if not file_path.exists():
                self.log_error(f"Skill {skill_id}: arquivo não existe: {skill_config['file']}")
            else:
                self.log_ok(f"Skill {skill_id}: arquivo existe")

        # Docs
        docs = self.config.get("docs", {})
        for doc_id, doc_config in docs.items():
            file_path = self.config_dir / doc_config.get("file", "")
            if not file_path.exists():
                self.log_error(f"Doc {doc_id}: arquivo não existe: {doc_config['file']}")
            else:
                self.log_ok(f"Doc {doc_id}: arquivo existe")

    def validate_version(self):
        """Valida versionamento."""
        version = self.config.get("base_version", "")
        if not version.startswith(("1.", "2.", "3.")):
            self.log_warning(f"base_version incomum: {version}")
        else:
            self.log_ok(f"base_version válido: {version}")

    def run(self):
        """Executa todas validações."""
        print(f"\n[INFO] Validando {self.path}...\n")
        
        if not self.validate_yaml_syntax():
            return False
        
        self.validate_required_fields()
        self.validate_types()
        self.validate_files_exist()
        self.validate_version()
        
        print(f"\n[RESULT]")
        if self.errors:
            print(f"❌ {len(self.errors)} erro(s) encontrado(s)")
            return False
        elif self.warnings:
            print(f"⚠️  {len(self.warnings)} aviso(s)")
            print("✅ Configuração válida (com avisos)")
            return True
        else:
            print("✅ Configuração válida")
            return True


def main():
    if len(sys.argv) < 2:
        print("Uso: python validate-config.py <config-path>")
        print("Exemplo: python validate-config.py .sdd/sdd-config.yaml")
        sys.exit(1)

    config_path = sys.argv[1]
    validator = ConfigValidator(config_path)
    
    if validator.run():
        sys.exit(0)
    else:
        sys.exit(1)


if __name__ == "__main__":
    main()
