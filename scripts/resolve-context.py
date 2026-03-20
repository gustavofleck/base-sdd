#!/usr/bin/env python3
"""
resolve-context.py — Resolvedor de Herança com Merge Semântico

Carrega base-sdd/agents → apply overrides de contexto → gera arquivo final

Padrão de merge:
1. Seções [GENÉRICO] vêm da base
2. Seções [ESPECIALIZAÇÃO] customizadas vêm do contexto
3. Conflitos: contexto prevalece

Uso:
    python resolve-context.py .sdd --output=.sdd-resolved/
    python resolve-context.py . --output=../.sdd-final/
"""

import sys
import re
from pathlib import Path
from typing import Dict

class ContextResolver:
    """Resolvedor de herança com merge semântico."""

    def __init__(self, context_dir: str, base_dir: str = None, output_dir: str = None):
        self.context_dir = Path(context_dir)
        self.base_dir = Path(base_dir) if base_dir else self._find_base_dir()
        self.output_dir = Path(output_dir) if output_dir else self.context_dir.parent / ".sdd-resolved"
        self.errors = []
        self.warnings = []
        self.resolved = []

    def _find_base_dir(self) -> Path:
        """Tenta encontrar base-sdd automaticamente."""
        # Buscar parent directory com estrutura base-sdd
        current = self.context_dir
        for _ in range(5):  # Max 5 levels up
            parent = current.parent
            if (parent / "base-sdd" / "agents").exists():
                return parent / "base-sdd"
            current = parent
        
        # Default
        return self.context_dir.parent.parent / "base-sdd"

    def log_error(self, msg):
        self.errors.append(f"❌ {msg}")
        print(f"❌ {msg}")

    def log_warning(self, msg):
        self.warnings.append(f"⚠️  {msg}")
        print(f"⚠️  {msg}")

    def log_ok(self, msg):
        self.resolved.append(f"✅ {msg}")
        print(f"✅ {msg}")

    def parse_sections(self, content: str) -> Dict[str, str]:
        """Parse file into sections."""
        sections = {}
        current_section = None
        current_content = ""
        
        for line in content.split('\n'):
            # Detectar seção
            if line.startswith("## ["):
                # Salvar seção anterior
                if current_section:
                    sections[current_section] = current_content.strip()
                
                # Extrair nome da seção
                match = re.match(r"## \[([^\]]+)\]", line)
                if match:
                    current_section = match.group(1)
                    current_content = ""
            else:
                current_content += line + "\n"
        
        # Salvar última seção
        if current_section:
            sections[current_section] = current_content.strip()
        
        return sections

    def merge_files(self, base_file: Path, context_file: Path) -> str:
        """Merge base + context com semântica."""
        
        if not base_file or not base_file.exists():
            self.log_warning(f"Base file não existe: {base_file}")
            # Retornar arquivo do contexto se base não existe
            if context_file and context_file.exists():
                return context_file.read_text(encoding='utf-8')
            return ""
        
        if not context_file or not context_file.exists():
            self.log_warning(f"Context file não existe: {context_file}")
            # Retornar arquivo da base se contexto não existe
            return base_file.read_text(encoding='utf-8')
        
        # Carregar ambos
        base_content = base_file.read_text(encoding='utf-8')
        context_content = context_file.read_text(encoding='utf-8')
        
        # Parse sections
        base_sections = self.parse_sections(base_content)
        context_sections = self.parse_sections(context_content)
        
        # Merge strategy:
        # 1. Use context sections se existem
        # 2. Use base sections para o resto
        # 3. Remover [GENÉRICO], [ESPECIALIZAÇÃO] tags
        
        merged = []
        
        # Header (antes de qualquer ## [...])
        header_base = base_content.split("## [")[0] if "## [" in base_content else base_content
        header_context = context_content.split("## [")[0] if "## [" in context_content else context_content
        
        # Usar header do contexto se não vazio, senão base
        header = header_context.strip() if header_context.strip() else header_base.strip()
        merged.append(header)
        merged.append("")
        
        # Seções
        all_section_names = set(base_sections.keys()) | set(context_sections.keys())
        
        for section_name in sorted(all_section_names):
            # Preferir contexto sobre base
            content = context_sections.get(section_name) or base_sections.get(section_name)
            
            if content and content.strip():
                merged.append(f"## {section_name}")
                merged.append("")
                merged.append(content)
                merged.append("")
        
        result = "\n".join(merged)
        
        # Remove stray [GENÉRICO], [ESPECIALIZAÇÃO] tags
        result = re.sub(r"\[GENÉRICO\]", "", result)
        result = re.sub(r"\[ESPECIALIZAÇÃO\]", "", result)
        
        return result

    def resolve(self):
        """Resolve contexto + base → output final."""
        print(f"\n[INFO] Resolvendo contexto...")
        print(f"  Base: {self.base_dir}")
        print(f"  Context: {self.context_dir}")
        print(f"  Output: {self.output_dir}\n")
        
        # Criar output dir
        self.output_dir.mkdir(parents=True, exist_ok=True)
        
        # Resolving agents
        print("[RESOLVE] Agents...")
        self._resolve_files("agents")
        
        # Resolving skills
        print("[RESOLVE] Skills...")
        self._resolve_files("skills")
        
        # Resolving docs
        print("[RESOLVE] Docs...")
        self._resolve_files("docs")
        
        # Copiar config
        print("[COPY] Copying sdd-config.yaml...")
        config_src = self.context_dir / "sdd-config.yaml"
        config_dst = self.output_dir / "sdd-config.yaml"
        if config_src.exists():
            config_dst.write_text(config_src.read_text(encoding='utf-8'), encoding='utf-8')
            self.log_ok("sdd-config.yaml copied")
        
        # Copiar instructions
        print("[COPY] Copying copilot-instructions.md...")
        instr_src = self.context_dir / "copilot-instructions.md"
        instr_dst = self.output_dir / "copilot-instructions.md"
        if instr_src.exists():
            instr_dst.write_text(instr_src.read_text(encoding='utf-8'), encoding='utf-8')
            self.log_ok("copilot-instructions.md copied")
        
        # Resumo
        print(f"\n[RESULT]")
        print(f"Erros: {len(self.errors)}")
        print(f"Avisos: {len(self.warnings)}")
        print(f"Resolvidos: {len(self.resolved)}")
        
        if self.errors:
            print(f"\n❌ Erros encontrados")
            return False
        else:
            print(f"\n✅ Contexto resolvido em {self.output_dir}/")
            return True

    def _resolve_files(self, file_type: str):
        """Resolve arquivos de um tipo (agents, skills, docs)."""
        base_dir = self.base_dir / file_type
        context_dir = self.context_dir / file_type
        output_dir = self.output_dir / file_type
        
        output_dir.mkdir(parents=True, exist_ok=True)
        
        # Coletar todos os arquivos
        all_files = set()
        
        if base_dir.exists():
            all_files.update(f.name for f in base_dir.glob("*.md"))
        
        if context_dir.exists():
            all_files.update(f.name for f in context_dir.glob("*.md"))
        
        # Resolver cada arquivo
        for filename in sorted(all_files):
            base_file = base_dir / filename if base_dir.exists() else None
            context_file = context_dir / filename if context_dir.exists() else None
            output_file = output_dir / filename
            
            # Skip -base.md files
            if "-base.md" in filename:
                continue
            
            # Merge
            merged_content = self.merge_files(
                base_file if base_file and base_file.exists() else None,
                context_file if context_file and context_file.exists() else None
            )
            
            if merged_content:
                output_file.write_text(merged_content, encoding='utf-8')
                self.log_ok(f"Resolved {file_type}/{filename}")
            else:
                self.log_warning(f"Skipped {file_type}/{filename} (vazio)")


def main():
    import argparse
    
    parser = argparse.ArgumentParser(description="Resolvedor de contextos SDD com merge semântico")
    parser.add_argument("context_dir", help="Diretório do contexto")
    parser.add_argument("--base", help="Diretório base-sdd (detectado automaticamente)")
    parser.add_argument("--output", help="Diretório output (default: .sdd-resolved/)")
    
    args = parser.parse_args()
    
    resolver = ContextResolver(
        context_dir=args.context_dir,
        base_dir=args.base,
        output_dir=args.output
    )
    
    if resolver.resolve():
        sys.exit(0)
    else:
        sys.exit(1)


if __name__ == "__main__":
    main()
