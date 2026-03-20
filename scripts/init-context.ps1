# init-context.ps1 — Inicialização SIMPLES e RÁPIDA para Windows PowerShell
# Cria estrutura dentro do projeto atual (não em pasta irmã)
# Funciona nativamente em Windows 10+ (PowerShell 5.0+)
#
# Uso:
#   .\init-context.ps1 (executado na raiz do projeto)
#   $env:BASE_SDD_DIR="C:\base-sdd" .\init-context.ps1 (especificar local de base-sdd)

# Colors para output
$GREEN = "`e[0;32m"
$BLUE = "`e[0;34m"
$YELLOW = "`e[1;33m"
$RED = "`e[0;31m"
$NC = "`e[0m"

function Log-Info { Write-Host "$BLUE[INFO]$NC $args" }
function Log-Ok { Write-Host "$GREEN[OK]$NC $args" }
function Log-Warn { Write-Host "$YELLOW[WARN]$NC $args" }
function Log-Error { Write-Host "$RED[ERROR]$NC $args"; exit 1 }

# Detectar BASE_SDD_DIR
if ([string]::IsNullOrWhiteSpace($env:BASE_SDD_DIR)) {
    $scriptDir = Split-Path -Parent $PSCommandPath
    $env:BASE_SDD_DIR = Join-Path $scriptDir ".." | Join-Path -ChildPath "base-sdd"
}

if (-not (Test-Path "$($env:BASE_SDD_DIR)/agents")) {
    Log-Error "base-sdd não encontrado em $($env:BASE_SDD_DIR)"
}

# Contexto atual (onde o script é executado)
$CONTEXT_NAME = Split-Path -Leaf (Get-Location)
$CONTEXT_DIR = Get-Location

Log-Info "Inicializando SDD em: $CONTEXT_DIR"
Log-Info "Contexto: $CONTEXT_NAME"

# Criar .github/sdd e agents (na raiz) se não existirem
Log-Info "Criando estrutura..."
@('.github/sdd/skills', '.github/sdd/docs', 'agents') | ForEach-Object {
    New-Item -ItemType Directory -Path "$CONTEXT_DIR/$_" -Force -ErrorAction SilentlyContinue | Out-Null
}
Log-Ok "Estrutura criada"

# Copiar arquivos base
Log-Info "Copiando arquivos base..."
try {
    Copy-Item "$($env:BASE_SDD_DIR)/agents/*.md" "$CONTEXT_DIR/agents/" -ErrorAction SilentlyContinue
} catch {
    Log-Warn "Nenhum arquivo agents encontrado"
}
@('skills', 'docs') | ForEach-Object {
    try {
        Copy-Item "$($env:BASE_SDD_DIR)/$_/*.md" "$CONTEXT_DIR/.github/sdd/$_/" -ErrorAction SilentlyContinue
    } catch {
        Log-Warn "Nenhum arquivo $_ encontrado"
    }
}
Log-Ok "Arquivos copiados"

# Copiar sdd-config-base.yaml
if (Test-Path "$($env:BASE_SDD_DIR)/sdd-config-base.yaml") {
    Copy-Item "$($env:BASE_SDD_DIR)/sdd-config-base.yaml" "$CONTEXT_DIR/.github/sdd/sdd-config.yaml"
    Log-Ok "sdd-config.yaml copiado"
}

# Copiar specialist-base.md
if (Test-Path "$($env:BASE_SDD_DIR)/agents/specialist-base.md") {
    Copy-Item "$($env:BASE_SDD_DIR)/agents/specialist-base.md" "$CONTEXT_DIR/agents/"
    Log-Ok "specialist-base.md copiado"
}

# Renomear -base.md para .md
Log-Info "Finalizando nomes de arquivos..."
@("$CONTEXT_DIR/.github/sdd", "$CONTEXT_DIR/agents") | ForEach-Object {
    Get-ChildItem -Path $_ -Filter "*-base.md" -Recurse | ForEach-Object {
        $newName = $_.Name -replace "-base.md", ".md"
        Rename-Item -Path $_.FullName -NewName $newName
    }
}
Log-Ok "Pronto"

# Substituir placeholders em sdd-config.yaml
Log-Info "Customizando sdd-config.yaml..."
$configFile = "$CONTEXT_DIR/.github/sdd/sdd-config.yaml"
$content = Get-Content $configFile -Raw
$content = $content -replace "your-project-name", $CONTEXT_NAME
$content = $content -replace "Descrição breve do seu projeto", $CONTEXT_NAME
Set-Content -Path $configFile -Value $content
Log-Ok "sdd-config.yaml customizado"

# Substituir placeholders em agents (na raiz)
Log-Info "Customizando agents..."
Get-ChildItem -Path "$CONTEXT_DIR/agents" -Filter "*.md" -Recurse | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    $content = $content -replace "your-project-name", $CONTEXT_NAME
    Set-Content -Path $_.FullName -Value $content
}
Log-Ok "agents customizados"

Log-Info "Done"
$content = $content -replace "Descrição breve do seu projeto", $CONTEXT_NAME
Set-Content -Path $configFile -Value $content -Encoding UTF8
Log-Ok "sdd-config.yaml customizado"

# Criar copilot-instructions.md NA RAIZ DO PROJETO
Log-Info "Criando copilot-instructions.md..."
$copilotContent = @'
# GitHub Copilot Instructions

## Fluxo Obrigatório

1. **Verificar Especialização**: Veja `.github/sdd/README-specialization.md` para confirmar tecnologias específicas
2. **Carregar Orchestrator**: Sempre comece por `agents/orchestrator.md`
3. **Seguir Fluxo de Decisão**: Classifique a tarefa (feature / bugfix / refactor / test)
4. **Usar Agentes Apropriados**: Feature Writer → Architect → Coder → Tester → PR Agent
5. **Validar Antes de Commit**: Siga guidelines em `.github/sdd/docs/`

## Agentes Disponíveis

- **agents/orchestrator.md** — Orquestra todo o fluxo (carregue primeiro!)
- **agents/feature-writer.md** — Especifica features/requisitos
- **agents/architect.md** — Valida design e arquitetura
- **agents/coder.md** — Implementa código
- **agents/tester.md** — Design de testes dados-quando-então
- **agents/pr-agent.md** — Submete PR (ainda não criado)

## Próximo Passo

Customize a estrutura para sua tecnologia:
```bash
make -f ../base-sdd/Makefile specialize TECH=react
```

Ou use o agente de especialização:
```bash
copilot /specialize
```
'@
Set-Content -Path "$CONTEXT_DIR/copilot-instructions.md" -Value $copilotContent -Encoding UTF8
Log-Ok "copilot-instructions.md criado"

Write-Host ""
Log-Ok "✅ SDD inicializado em: $CONTEXT_DIR"
Log-Info ""
Log-Info "Estrutura criada:"
Log-Info "  agents/                    ← Agentes (raiz)"
Log-Info "  .github/sdd/skills/        ← Skills"
Log-Info "  .github/sdd/docs/          ← Documentação"
Log-Info "  .github/sdd/sdd-config.yaml ← Configuração"
Log-Info "  copilot-instructions.md    ← Instruções (raiz)"
Log-Info ""
Log-Info "Próximos passos:"
Log-Info "  1. Especializar: make -f ../base-sdd/Makefile specialize TECH=<react|node|android|flutter|custom>"
Log-Info "  2. Ou invocar agente: copilot /specialize"
Log-Info ""
Log-Info "Estrutura agnóstica pronta. Tecnologia será definida na especialização!"
Log-Info ""
Log-Info "Próximos passos:"
Log-Info "  1. Especializar: make -f ../base-sdd/Makefile specialize TECH=<react|node|android|flutter|custom>"
Log-Info "  2. Ou invocar agente: copilot /specialize"
Log-Info ""
Log-Info "Estrutura agnóstica pronta. Tecnologia será definida na especialização!"
Write-Host ""
