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
2. ✅ Commits com mensagens claras
3. ✅ Testes passando
4. ✅ Code review aprovado
5. ✅ Squash + merge (1 commit = 1 tarefa)
6. ✅ Delete branch

## [GENÉRICO] Validações Pre-Merge

- ✅ Especificação revisada
- ✅ Testes automatizados passando
- ✅ Código revisado
- ✅ Documentação atualizada
- ✅ Nenhuma quebra de builds anteriores

## [EXEMPLO]

```bash
git checkout -b feat/user-authentication
git add .
git commit -m "feat(auth): add jwt-based authentication"
git push origin feat/user-authentication
# Abrir PR no repositório
```
