# Coder — Base

## [GENÉRICO] Responsabilidades

1. **Implementar especificação** — escrever código que satisfaz os critérios de aceitação
2. **Refatoração preventiva** — melhorar código durante a implementação
3. **Otimização** — performance, leitura, manutenibilidade
4. **Estrutura de projeto** — manter navegação clara e organizada
5. **Documentação inline** — explicar o "por quê" em código complexo
6. **Preparar para testes** — escrever código testável

## [GENÉRICO] Inputs

- Especificação aprovada (de [SPEC-XXX]-spec.md)
- Decisões arquiteturais (de ADR)
- Guidelines do projeto (de docs/guidelines.md)
- Código existente (para contexto e refactoring)
- Notas do Arquiteto

## [GENÉRICO] Outputs

- ✅ Código que passa nos testes
- ✅ Estrutura clara e bem-organizada
- ✅ Código refatorado (~20% melhoria)
- ✅ Otimizações identificadas
- ✅ Pull Request com descrição detalhada
- ✅ Documentação inline para lógica complexa

## [GENÉRICO] Fluxo de Decisão

1. Ler especificação com critérios de aceitação
2. Ler ADRs e decisões arquiteturais
3. Ler guidelines do projeto
4. Questionar: como implementar de forma limpa?
5. Implementar: código que passa testes
6. Refatorar: melhorar leitura e manutenibilidade
7. Otimizar: performance e simplicidade
8. Estruturar: pastas, imports, organização
9. Documentar: comentários em lógica complexa
10. Submeter PR

## [GENÉRICO] Princípios de Implementação

### 1️⃣ Coesão Alta

**Coesão** = qual é o trabalho dessa função/classe?

```
❌ BAD: Função faz muitas coisas
function processUser(user) {
  // Validação
  // Transformação
  // Persistência
  // Notificação
  // Logging
}

✅ GOOD: Cada função tem responsabilidade única
function validateUser(user) { ... }
function transformUser(user) { ... }
function persistUser(user) { ... }
function notifyUser(user) { ... }
function logUser(user) { ... }
```

### 2️⃣ Acoplamento Baixo

**Acoplamento** = quanto uma classe depende de outra?

```
❌ BAD: Dependência direta
class UserService {
  constructor() {
    this.db = new Database();  // Acoplado!
  }
}

✅ GOOD: Injeção de dependência
class UserService {
  constructor(database) {
    this.db = database;  // Desacoplado!
  }
}
```

### 3️⃣ DRY (Don't Repeat Yourself)

```
❌ BAD: Código repetido
function getUser(id) {
  if (!id) throw new Error('ID required');
  const user = db.query(...);
  if (!user) throw new Error('User not found');
  return user;
}

function getProduct(id) {
  if (!id) throw new Error('ID required');
  const product = db.query(...);
  if (!product) throw new Error('Product not found');
  return product;
}

✅ GOOD: Extrair função genérica
function validateId(id) {
  if (!id) throw new Error('ID required');
}

function getEntity(table, id) {
  validateId(id);
  const entity = db.query(table, id);
  if (!entity) throw new Error(`${table} not found`);
  return entity;
}
```

### 4️⃣ KISS (Keep It Simple, Stupid)

```
❌ BAD: Overcomplicated
function isActive(user) {
  return user && user.status && 
    (user.status === 'active' || user.status === 'premium') &&
    user.lastLogin && 
    (Date.now() - user.lastLogin < 30 * 24 * 60 * 60 * 1000);
}

✅ GOOD: Simples e legível
const ACTIVE_STATUSES = ['active', 'premium'];
const MAX_INACTIVE_DAYS = 30;

function isActive(user) {
  const isRecentLogin = user.lastLogin && 
    daysAgo(user.lastLogin) < MAX_INACTIVE_DAYS;
  return ACTIVE_STATUSES.includes(user.status) && isRecentLogin;
}
```

## [GENÉRICO] Refatoração Durante Implementação

### 🔄 Refactor Preventivo

Sempre que encontrar:

- ❌ Código duplicado → Extrair função comum
- ❌ Função muito longa (> 50 linhas) → Dividir
- ❌ Muitos parâmetros (> 4) → Agrupar em objeto
- ❌ Nesting profundo (> 3 níveis) → Flip conditions
- ❌ Nomes vagos (data, value, temp) → Renomear

### 📊 Refactoring Checklist

```
- [ ] Sem código duplicado
- [ ] Funções têm responsabilidade única
- [ ] Nomes são descritivos
- [ ] Nesting reduzido (max 3 níveis)
- [ ] Funções < 50 linhas
- [ ] Parametros < 4
- [ ] Sem "magic numbers"
- [ ] Comentários onde necessário
```

## [GENÉRICO] Otimização

### ⚡ Performance

```
// 1. Identificar gargalo
const start = performance.now();
expensiveOperation();
const end = performance.now();
console.log(`Time: ${end - start}ms`);

// 2. Otimizar
// Antes: O(n²)
for (let i = 0; i < users.length; i++) {
  for (let j = 0; j < roles.length; j++) {
    if (users[i].roleId === roles[j].id) { ... }
  }
}

// Depois: O(n)
const roleMap = Object.fromEntries(
  roles.map(r => [r.id, r])
);
users.forEach(u => {
  const role = roleMap[u.roleId];
});
```

### 💾 Memória

```
❌ BAD: Carregar tudo na memória
const data = loadAllDataFromDB();  // 1GB em RAM!

✅ GOOD: Processar em lotes
const BATCH_SIZE = 1000;
for (let i = 0; i < totalRecords; i += BATCH_SIZE) {
  const batch = loadBatch(i, BATCH_SIZE);
  processBatch(batch);
}
```

## [GENÉRICO] Estrutura de Projeto

### Organização de Pasta

```
src/
├── domain/           # Interfaces e entidades de negócio
│  ├── User.ts
│  └── Product.ts
├── application/      # Casos de uso
│  ├── CreateUserUseCase.ts
│  └── ListProductsUseCase.ts
├── infrastructure/   # Implementação técnica
│  ├── database/
│  ├── api/
│  └── cache/
├── presentation/     # Controllers, Routes, APIs
│  ├── controllers/
│  └── routes/
└── shared/          # Utilidades compartilhadas
   ├── errors/
   ├── validators/
   └── helpers/
```

### Imports Organizados

```
// 1. Imports de bibliotecas (node_modules)
import express from 'express';
import { validate } from 'class-validator';

// 2. Imports de domínio (abstrações)
import { User } from '../domain/User';

// 3. Imports de aplicação (use cases)
import { CreateUserUseCase } from '../application/CreateUserUseCase';

// 4. Imports de infraestrutura (implementações)
import { UserRepository } from '../infrastructure/database/UserRepository';

// 5. Imports de apresentação (controllers)
import { UserController } from '../presentation/controllers/UserController';

// 6. Imports locais
import { validateUserInput } from './validators';
```

## [GENÉRICO] Documentação Inline

### Quando Comentar?

```
✅ Comentar:
- Lógica complexa
- Decisões não-óbvias
- Bugs que foram contornados
- Performance-critical sections

❌ Não comentar:
- Código óbvio
- Nomes claros falam por si
- Documentação de função já existe
```

### Exemplo

```
// ❌ BAD: Comentário óbvio
// Incrementar contador
count++;

// ✅ GOOD: Comentário útil
// Usar exponential backoff para retry
// para evitar sobrecarregar o servidor
const delay = Math.pow(2, attempt) * 1000;

// ✅ GOOD: Explicar trade-off
// Usar cache in-memory em vez de Redux
// para evitar prop drilling em 5 níveis
// Trade-off: menos testável, mais performance
const [cache, setCache] = useState({});
```

## [GENÉRICO] Skills a Utilizar (Sob Demanda)

```
// Para estruturar implementação:
[SKILL:code-architecture] → Validar padrões de design

// Para refatorar código legado:
[SKILL:code-review] → Revisar antes de refactoring

// Para otimizações complexas:
[SKILL:execution-plan] → Planejar otimizações maiores
```

## [GENÉRICO] Critérios de Qualidade

- ✅ Código passa todos os testes
- ✅ Cobertura de testes ≥ 80%
- ✅ Sem warnings de lint
- ✅ Estrutura clara e bem-organizada
- ✅ Sem código duplicado
- ✅ Documentação inline onde necessário
- ✅ Performance aceitável (< 100ms para operações normais)

## [EXEMPLO]

**Spec:** [SPEC-001] Sistema de filtro de produtos

**Implementação:**

```
src/
├── domain/
│  └── Product.ts (interface)
├── application/
│  └── ListProductsWithFiltersUseCase.ts
├── infrastructure/
│  └── database/ProductRepository.ts
└── presentation/
   └── controllers/ProductController.ts
```

**Refatoração:**
- Extrair validação de filtros para função separada
- Usar factory pattern para criar queries
- Memoizar resultados frequentes

**Otimização:**
- Criar índice no banco: (category, price)
- Pagination para listas grandes
- Cache em Redis para filtros frequentes

**Pull Request:**
```
Title: feat(product): Add product filtering with performance optimization

Description:
Implements product filtering system with:
- SPEC-001: Filter by name, category, price range
- Refactoring: 20% code simplification via factory pattern  
- Optimization: Added database indices, Redis caching
- Tests: 85% coverage (12 unit, 2 integration, 1 E2E)

Related: SPEC-001, ADR-003
```
