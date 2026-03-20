# Guia Multiplataforma — Windows, macOS, Linux

O Base-SDD funciona em **Windows**, **macOS** e **Linux**. Este documento explica como usar cada sistema operacional.

---

## 🖥️ macOS

### Pré-requisitos
- Bash 4.0+ (incluído por padrão)
- Make (incluído com Xcode)
- Python 3.7+ (para validação scripts)

### Como usar

```bash
# Clone base-sdd (apenas uma vez)
git clone https://github.com/gustavofleck/base-sdd.git

# Passo 1: Init (dentro do seu projeto)
cd seu-projeto
make -f ../base-sdd/Makefile init
# → Cria .github/sdd/ dentro do projeto (agnóstico)

# Passo 2: Specialize (ainda dentro de seu-projeto)
make -f ../base-sdd/Makefile specialize TECH=react
# → Customiza .github/sdd/ para sua tech stack
```

### Troubleshooting

**Erro: `bash: ./init-context.sh: Permission denied`**
```bash
chmod +x scripts/init-context.sh
make init
```

**Erro: `sed -i` syntax (compatibilidade macOS/Linux)**
- ✅ Já tratado no script (sed -i '' para macOS)

---

## 🐧 Linux

### Pré-requisitos
- Bash 4.0+ (geralmente incluído)
- Make
- Python 3.7+

### Como usar

Idêntico ao macOS:

```bash
git clone https://github.com/gustavofleck/base-sdd.git

cd seu-projeto
make -f ../base-sdd/Makefile init

# Specialize (ainda dentro de seu-projeto)
make -f ../base-sdd/Makefile specialize TECH=node
```

### Troubleshooting

**Erro: `bash: ./init-context.sh: Permission denied`**
```bash
chmod +x scripts/init-context.sh
make init
```

---

## 🪟 Windows

### Opção 1: PowerShell (Nativo - Recomendado)

**Pré-requisitos:**
- Windows 10+
- PowerShell 5.0+ (incluído por padrão)
- Python 3.7+ (para validação scripts)
- Git for Windows (opcional, para git commands)

**Como usar:**

```powershell
# Clone (com Git for Windows)
git clone https://github.com/gustavofleck/base-sdd.git

# Passo 1: Init (na raiz do seu projeto)
cd seu-projeto
..\base-sdd\scripts\init-context.ps1
# → Cria .github/sdd/ dentro do projeto

# Passo 2: Specialize (ainda dentro de seu-projeto)
make -f ..\base-sdd\Makefile specialize TECH=react
# → Customiza .github/sdd/ para sua tech stack
```

#### Permitir execução de scripts PowerShell

Se receber erro `... cannot be loaded because running scripts is disabled...`:

```powershell
# Verificar política atual
Get-ExecutionPolicy

# Permitir scripts locais (temporário, apenas sessão atual)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

# Ou permitir permanentemente (cuidado!)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

### Opção 2: Git Bash (Emulação Bash)

**Pré-requisitos:**
- Git for Windows (inclui Git Bash)
- Python 3.7+
- Make (incluído em alguns builds do Git for Windows, ou instale via Chocolatey: `choco install make`)

**Como usar:**

Abra **Git Bash** (não PowerShell/CMD):

```bash
# Clone
git clone https://github.com/gustavofleck/base-sdd.git

# Passo 1: Init (na raiz do seu projeto)
cd seu-projeto
bash ../base-sdd/scripts/init-context.sh
# → Cria .github/sdd/ dentro do projeto

# Passo 2: Specialize (ainda dentro de seu-projeto)
make -f ../base-sdd/Makefile specialize TECH=react
# → Customiza .github/sdd/ para sua tech stack
```

---

### Opção 3: WSL 2 (Windows Subsystem for Linux)

**Pré-requisitos:**
- WSL 2 instalado (Windows 10/11)
- Distribuição Linux instalada (Ubuntu recomendada)
- Bash, Make, Python 3.7+

**Como usar:**

```bash
# Dentro do WSL Terminal
wsl

# Clone
git clone https://github.com/gustavofleck/base-sdd.git

# Passo 1: Init (na raiz do seu projeto)
cd seu-projeto
make -f ../base-sdd/Makefile init
# → Cria .github/sdd/ dentro do projeto

# Passo 2: Specialize (ainda dentro de seu-projeto)
make -f ../base-sdd/Makefile specialize TECH=react
# → Customiza .github/sdd/ para sua tech stack
```

---

## 🔄 Makefile Multiplataforma

O `Makefile` funciona em **qualquer plataforma** que tenha:
- Make (geralmente vem com Dev Tools no macOS/Linux)
- Python 3.7+ (para scripts de validação)

```bash
make init           # Funciona em Windows/macOS/Linux
make specialize     # Funciona em Windows/macOS/Linux
make validate       # Funciona em Windows/macOS/Linux
make check          # Funciona em Windows/macOS/Linux
```

---

## 📊 Tabela Comparativa

| SO | Init Script | Recomendado | Setup |
|----|------------|-----------|-------|
| **macOS** | `bash init-context.sh` | ✅ | Nada, já vem com tudo |
| **Linux** | `bash init-context.sh` | ✅ | `sudo apt install make python3` |
| **Windows (PowerShell)** | `.\init-context.ps1` | ✅ | `choco install python make` |
| **Windows (Git Bash)** | `bash init-context.sh` | ✅ | Instalar Git for Windows + Make |
| **Windows (WSL 2)** | `bash init-context.sh` (no WSL) | ✅ | Instalar WSL 2 + distribuição |

---

## 🛠️ Instalando Make no Windows

### Opção 1: Chocolatey (Recomendado)
```powershell
# Instalar Chocolatey (admin)
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Instalar Make
choco install make
```

### Opção 2: Git for Windows
```bash
# Git for Windows já inclui Make em alguns builds
# Se não tiver, instale via Chocolatey
choco install make
```

### Opção 3: MinGW
```bash
# Instalar MinGW com Make
choco install mingw
```

---

## ✅ Checklist de Setup

### macOS
- [ ] Xcode Command Line Tools: `xcode-select --install`
- [ ] Python 3.7+: `python3 --version`
- [ ] Bash 4.0+: `bash --version`

### Linux (Ubuntu/Debian)
- [ ] `sudo apt update && sudo apt install build-essential python3`

### Windows (PowerShell)
- [ ] PowerShell 5.0+: `$PSVersionTable.PSVersion`
- [ ] Python 3.7+: `python --version`
- [ ] Make (opcional para `make` commands): `choco install make`

### Windows (ambas opções)
- [ ] Git for Windows: `git --version`

---

## 🧪 Testes Rápidos

Para verificar se tudo está funcionando:

### macOS/Linux
```bash
cd base-sdd

# Test 1: Init
make init
# → Digite: test-app, "Test Application"

# Test 2: Validar
make validate DIR=../test-app
```

### Windows (PowerShell)
```powershell
cd base-sdd

# Test 1: Init
.\scripts\init-context.ps1

# Test 2: Validar (se Make está instalado)
make validate DIR=../test-app
```

---

## 📝 Troubleshooting Geral

**Problema: `command not found: make`**
- Linux: `sudo apt install build-essential`
- macOS: `xcode-select --install`
- Windows: `choco install make`

**Problema: `python not found`**
- Instalar Python 3.7+:
  - Linux: `sudo apt install python3`
  - macOS: `brew install python3`
  - Windows: `choco install python`

**Problema: `permission denied` (bash scripts)**
```bash
chmod +x scripts/*.sh
```

**Problema: `execution policy` (PowerShell)**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
```

---

## 🚀 Próximos Passos (Qualquer SO)

Após fazer `make init` ou `.\init-context.ps1`:

```bash
# Especializar para sua tecnologia
cd seu-projeto
make specialize TECH=react    # ou node, android, etc

# Validar
make validate
make check
```

---

## 📚 Links Úteis

- [Bash on macOS 10.15+ (Catalina)](https://support.apple.com/en-us/HT211238)
- [Bash on Ubuntu/Debian](https://ubuntu.com/bash)
- [Git for Windows](https://gitforwindows.org)
- [WSL 2 Installation Guide](https://docs.microsoft.com/en-us/windows/wsl/install)
- [PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/)
- [Make on Windows](https://stackoverflow.com/questions/32127524/how-to-install-and-use-make-in-windows)

---

**Precisa de ajuda?** Abra uma issue no GitHub ou consulte a documentação do seu SO.
