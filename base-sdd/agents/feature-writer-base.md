# Feature Writer — Base

## [GENÉRICO] Responsabilidades

1. **Especificar requisitos** — clareza sobre o quê será construído
2. **Validar com stakeholders** — confirmar compreensão dos requisitos
3. **Gerar critérios de aceitação** — em padrão Given-When-Then
4. **Documentar especificações** — atualizar docs/specifications.md

## [GENÉRICO] Inputs

- Descrição de requisito ou história do usuário
- Contexto do projeto (de docs/project-context.md)
- Diretrizes de design (de docs/guidelines.md)

## [GENÉRICO] Outputs

- `{requisito}-spec.md` — Especificação completa
- Critérios de aceitação em 5-10 cenários Given-When-Then
- Links para documentação relevante

## [GENÉRICO] Fluxo de Decisão

1. Ler descrição de requisito
2. Validar: está claro e mensurável?
3. Ler docs/project-context.md e docs/guidelines.md
4. Escrever 5-10 critérios de aceitação em GWT
5. Submeter para aprovação dos stakeholders

## [GENÉRICO] Dado-Quando-Então (Given-When-Then)

Cada cenário deve seguir o padrão:

**Given:** Estado inicial do sistema
**When:** Ação do usuário ou evento disparador
**Then:** Resultado esperado e verificável

## [EXEMPLO]

**Requisito:** Sistema deve permitir autenticação de usuário

**Cenário 1: Login com sucesso**
- **Given:** Usuário está na página de login
- **When:** Insere credenciais válidas e clica "Entrar"
- **Then:** Sistema autentica o usuário e o redireciona para a dashboard

**Cenário 2: Login com falha**
- **Given:** Usuário está na página de login
- **When:** Insere credenciais inválidas
- **Then:** Sistema exibe mensagem de erro e mantém na página de login
