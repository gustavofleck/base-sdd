# init-context.ps1 — Inicialização SIMPLES e RÁPIDA para Windows PowerShell
# Funciona nativamente em Windows 10+ (PowerShell 5.0+)
# Este script é equivalente ao init-context.sh para bash
#
# Uso:
#   .\init-context.ps1 my-project
#   .\init-context.ps1 my-project "My Project Description"

param(
    [string]$ContextName = "",
    [string]$ContextDesc = ""
)

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
$scriptDir = Split-Path -Parent $PSCommandPath
$BASE_SDD_DIR = Join-Path $scriptDir ".." | Join-Path -ChildPath "base-sdd"

if (-not (Test-Path "$BASE_SDD_DIR/agents")) {
    Log-Error "base-sdd não encontrado em $BASE_SDD_DIR"
}

# Argumentos ou interativo
if ([string]::IsNullOrWhiteSpace($ContextName)) {
    Log-Info "=== SDD Init (Simples e Rápido) ==="
    Write-Host ""
    $ContextName = Read-Host "Nome do projeto (ex: meu-app)"
    $ContextDesc = Read-Host "Descrição breve (ex: Aplicação de tarefas)"
    if ([string]::IsNullOrWhiteSpace($ContextDesc)) {
        $ContextDesc = "Projeto $ContextName"
    }
} else {
    if ([string]::IsNullOrWhiteSpace($ContextDesc)) {
        $ContextDesc = "Projeto $ContextName"
    }
}

# Validar entrada
if ([string]::IsNullOrWhiteSpace($ContextName)) {
    Log-Error "Nome do projeto é obrigatório"
}

if ($ContextName -notmatch "^[a-z0-9_-]+$") {
    Log-Error "Nome inválido. Use: a-z, 0-9, _, -"
}

# Criar diretório (uma pasta acima da raiz do projeto SDD)
$PARENT_DIR = Split-Path -Parent (Split-Path -Parent $BASE_SDD_DIR)
$CONTEXT_DIR = Join-Path $PARENT_DIR $ContextName

if (Test-Path "$CONTEXT_DIR/.sdd") {
    Log-Error "Contexto SDD já existe em $CONTEXT_DIR/.sdd"
}

# Criar estrutura de diretórios
Log-Info "Criando estrutura para: $ContextName"
@('.sdd/agents', '.sdd/skills', '.sdd/docs') | ForEach-Object {
    New-Item -ItemType Directory -Path "$CONTEXT_DIR/$_" -Force -ErrorAction SilentlyContinue | Out-Null
}
Log-Ok "Diretórios criados em $CONTEXT_DIR"

# Copiar arquivos base
Log-Info "Copiando arquivos base..."
@('agents', 'skills', 'docs') | ForEach-Object {
    try {
        Copy-Item "$BASE_SDD_DIR/$_/*.md" "$CONTEXT_DIR/.sdd/$_/" -ErrorAction SilentlyContinue
    } catch {
        Log-Warn "Nenhum arquivo $_encontrado"
    }
}
Log-Ok "Arquivos copiados"

# Copiar sdd-config-base.yaml
if (Test-Path "$BASE_SDD_DIR/sdd-config-base.yaml") {
    Copy-Item "$BASE_SDD_DIR/sdd-config-base.yaml" "$CONTEXT_DIR/.sdd/sdd-config.yaml"
    Log-Ok "sdd-config.yaml copiado"
}

# Copiar specialist-base.md
if (Test-Path "$BASE_SDD_DIR/agents/specialist-base.md") {
    Copy-Item "$BASE_SDD_DIR/agents/specialist-base.md" "$CONTEXT_DIR/.sdd/agents/"
    Log-Ok "specialist-base.md copiado"
}

# Renomear -base.md para .md
Log-Info "Finalizando nomes de arquivos..."
Get-ChildItem -Path "$CONTEXT_DIR/.sdd" -Filter "*-base.md" -Recurse | ForEach-Object {
    $newName = $_.Name -replace "-base.md", ".md"
    Rename-Item -Path $_.FullName -NewName $newName
}
Log-Ok "Pronto"

# Substituir placeholders em sdd-config.yaml
Log-Info "Customizando sdd-config.yaml..."
$configFile = "$CONTEXT_DIR/.sdd/sdd-config.yaml"
$content = Get-Content $configFile -Raw
$content = $content -replace "your-project-name", $ContextName
$content = $content -replace "Descrição breve do seu projeto", $ContextDesc
Set-Content -Path $configFile -Value $content -Encoding UTF8
Log-Ok "sdd-config.yaml customizado"

# Criar copilot-instructions.md
Log-Info "Criando copilot-instructions.md..."
$copilotContent = @'
# GitHub Copilot Instructions

## Fluxo Obrigatório

1. **Verificar Especialização**: Veja `.sdd/README-specialization.md` para confirmar tecnologias específicas
2. **Carregar Orchestrator**: Sempre comece por `.sdd/agents/orchestrator.md`
3. **Seguir Fluxo de Decisão**: Classifique a tarefa (feature / bugfix / refactor / test)
4. **Usar Agentes Apropriados**: Feature Writer → Architect → Coder → Tester → PR Agent
5. **Validar Antes de Commit**: Siga guidelines em `.sdd/docs/`

## Agentes Disponíveis

- **orchestrator.md** — Orquestra todo o fluxo (carregue primeiro!)
- **feature-writer.md** — Especifica features/requisitos
- **architect.md** — Valida design e arquitetura
- **coder.md** — Implementa código
- **tester.md** — Design de testes dados-quando-então
- **pr-agent.md** — Submete PR (ainda não criado)

## Próximo Passo

Após inicialização, customize a estrutura para sua tecnologia:
```bash
cd $CONTEXT_NAME
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
Log-Ok "✅ Contexto SDD criado: $CONTEXT_DIR"
Log-Info ""
Log-Info "Próximos passos:"
Log-Info "  1. cd $ContextName"
Log-Info "  2. Especializar: make -f ../base-sdd/Makefile specialize TECH=<react|node|android|flutter|custom>"
Log-Info "  3. Ou invocar agente: copilot /specialize"
Log-Info ""
Log-Info "Todo o resto fica para o agente de especialização!"
Write-Host ""
