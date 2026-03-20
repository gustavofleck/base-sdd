# Guidelines — Base

## [GENÉRICO] Objetivo

Documentar as diretrizes e padrões que guiam o desenvolvimento do projeto. Qualquer desenvolvedor deve conseguir seguir as guidelines e produzir código consistente com o projeto.

## [GENÉRICO] Categorias de Guidelines

### 1. Code Style & Formatting

- Nome de variáveis, funções, classes
- Indentação e espaçamento
- Comprimento máximo de linhas
- Comentários e documentação

### 2. Architecture Patterns

- Padrão arquitetural principal (Clean, Hexagonal, Event-Driven, etc)
- Estrutura de pastas/módulos
- Responsabilidades por camada
- Como as camadas se comunicam

### 3. Testing Strategy

- Tipos de testes (unitário, integração, E2E)
- Cobertura mínima esperada
- Frameworks e ferramentas
- Como nomear testes

### 4. Git & Version Control

- Estratégia de branching
- Formato de commits
- Regras para PRs
- Revisão de código

### 5. Documentation

- Onde documentar código
- Formato de documentação
- O que deve ser documentado
- Manutenção de docs

### 6. Performance & Quality

- Padrões de performance esperados
- Métricas de qualidade
- Ferramentas de análise estática
- Limites aceitáveis

### 7. Security

- Autenticação e autorização
- Validação de entrada
- Proteção de dados sensíveis
- Conformidade com standards

## [GENÉRICO] Template de Guideline

```
## [guideline-name]

**Categoria:** Code Style | Architecture | Testing | Git | Docs | Performance | Security

### Princípio
Explique o porquê dessa guideline.

### Regra
Declare a regra ou padrão claramente.

### Exemplo ✅ (Correto)
```
código ou exemplo correto
```

### Exemplo ❌ (Incorreto)
```
código ou exemplo incorreto
```

### Exceções
Quando essa guideline pode não ser aplicável?

### Ferramentas de Validação
Como garantir que essa guideline é seguida?
```

## [GENÉRICO] Validação de Guidelines

- **Linters/Formatters** para Code Style
- **Testes automatizados** para Architecture
- **Code Coverage** para Testing
- **CI/CD Checks** para qualidade geral
- **Code Review** para aderência manual

## [GENÉRICO] Atualização de Guidelines

1. Documentar em um pull request
2. Revisar com a equipe
3. Aprovar (ou rejeitar com feedback)
4. Mesclar e anunciar
5. Atualizar CI/CD checks se necessário

## [GENÉRICO] Divergência de Guidelines

Se uma guideline não faz sentido para um caso específico:

1. Documentar a exceção no código
2. Comentar por quê a guideline foi ignorada
3. Trazer para discussão em um PR
4. Ajustar a guideline se necessário

**Não ignore guidelines silenciosamente.**
