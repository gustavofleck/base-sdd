# Git Workflow — Skill Base

## [GENÉRICO] Objetivo

Padronizar o fluxo de git em qualquer contexto:
- Nomes de branch
- Formato de commit
- Estratégia de merge
- Limpeza

## [GENÉRICO] Branch Naming

```
feat/{feature-slug}      — Feature nova
fix/{bug-slug}           — Bugfix
refactor/{area-slug}     — Refatoração
docs/{doc-slug}          — Documentação
test/{test-slug}         — Testes
```

**Regra:** sempre a partir de `main`, nunca commitar direto

## [GENÉRICO] Conventional Commits

```
feat(scope): short message (max 50 chars)
fix(scope): short message
docs(scope): short message
test(scope): short message
refactor(scope): short message

Body (optional, 72 chars max):
Detalhes adicionais aqui.

Closes: #123
```

## [GENÉRICO] Merge Strategy

1. ✅ Branch criada a partir de main
2. ✅ Commits mensagem clara
3. ✅ CI/CD passa
4. ✅ Code review aprovado
5. ✅ Squash + merge (1 commit = 1 feature)
6. ✅ Delete branch

## [EXEMPLO:qualquer-linguagem]

```bash
git checkout -b feat/user-authentication
git add .
git commit -m "feat(auth): add login with jwt tokens"
git push origin feat/user-authentication
# Open PR on GitHub
```

---

## [ESPECIALIZAÇÃO] CI/CD Pre-Merge Checks

{Customizar conforme seu stack}

**Android:**
- ./gradlew test
- ./gradlew lint
- Code coverage > 80%

**React:**
- npm test
- npm run lint
- npm run build

**Node.js:**
- npm test
- npm run lint
- npm run typecheck
