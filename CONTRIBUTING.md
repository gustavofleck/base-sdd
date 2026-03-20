# CONTRIBUTING

Obrigado por estar interessado em contribuir para Base-SDD!

## Como Contribuir

### 1. Reportar Bugs

Encontrou um bug? Abra uma [issue](https://github.com/gustavoabelh/base-sdd/issues) descrevendo:
- O que esperava
- O que aconteceu
- Steps para reproduzir
- Seu ambiente (SO, Python version, Bash version)

### 2. Sugerir Features

Tenha ideias? Abra uma issue com label `enhancement`:
- Descrição clara da feature
- Por que é útil
- Exemplos de uso

### 3. Melhorar Documentação

Documentação incompleta? Abra um PR:
- Typos e clareza
- Novos exemplos
- Melhor organização

### 4. Submeter Código

#### Fork e Clone
```bash
git clone https://github.com/YOUR-USERNAME/base-sdd.git
cd base-sdd
git checkout -b feature/sua-feature
```

#### Desenvolvimento
- Python scripts: siga PEP 8
- Bash scripts: siga Google Bash guidelines
- Sempre adicione comentários
- Teste localmente

#### Testing
```bash
# Bash scripts
bash scripts/init-context.sh test-app android

# Python scripts
python scripts/validate-config.py test-app/.sdd/sdd-config.yaml
python scripts/check-integrity.py test-app/.sdd
python scripts/resolve-context.py test-app/.sdd
```

#### Submeter PR
1. Commit com mensagens claras
   ```bash
   git commit -m "feat: add support for custom stacks"
   git commit -m "fix: handle edge case in resolver"
   ```
2. Push para seu fork
   ```bash
   git push origin feature/sua-feature
   ```
3. Abra um PR contra `main` com descrição clara

### 5. Criar um Contexto Comunitário

Especialista em Kotlin? Vue? Go? Contribua um contexto novo:

1. Crie usando `make init`
2. Customize agents, skills, docs completamente
3. Valide com `make validate` + `make check`
4. Abra um PR ou publique no [marketplace](https://github.com/gustavoabelh/base-sdd-marketplace)

---

## Diretrizes

### Code Style
- **Python:** `black` formatter recommended
- **Bash:** No tabs, 2 spaces indentation
- **Markdown:** Max 100 chars per line (prefer 80 for readability)

### Commit Messages
Siga conventional commits:
```
feat(scope): short description
fix(scope): short description
docs(scope): short description
test(scope): short description
refactor(scope): short description
```

### Pull Requests
- ✅ Uma feature por PR
- ✅ Testes passando
- ✅ Documentação atualizada
- ✅ Descrição clara do que muda

---

## Roadmap

- **Phase 3:** Marketplace de contextos (descoberta + versioning + signatures)
- **Phase 4:** Web UI + CLI TUI melhorado
- **Phase 5:** Integração com IDE plugins (VS Code, JetBrains, etc)

---

## Questions?

- Issues: [GitHub Issues](https://github.com/gustavoabelh/base-sdd/issues)
- Discussions: [GitHub Discussions](https://github.com/gustavoabelh/base-sdd/discussions)
- Email: contact@example.com

**Obrigado por contribuir! 🙏**
