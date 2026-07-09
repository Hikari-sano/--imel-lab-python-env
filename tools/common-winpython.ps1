function Get-MemilRoot {
    return (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}

function Write-MemilTitle {
    param([string]$Text)

    Write-Host ""
    Write-Host "========================================"
    Write-Host " $Text"
    Write-Host "========================================"
    Write-Host ""
}

function Write-MemilOk {
    param([string]$Text)
    Write-Host "[OK] $Text" -ForegroundColor Green
}

function Write-MemilWarn {
    param([string]$Text)
    Write-Host "[WARN] $Text" -ForegroundColor Yellow
}

function Write-MemilNg {
    param([string]$Text)
    Write-Host "[NG] $Text" -ForegroundColor Red
}

function Ensure-MemilDirectory {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
        Write-MemilOk "Created: $Path"
    } else {
        Write-MemilOk "Exists: $Path"
    }
}

function Find-MemilWinPython {
    $Root = Get-MemilRoot
    $WinPythonDir = Join-Path $Root "winpython"

    if (-not (Test-Path $WinPythonDir)) {
        return $null
    }

    $candidate = Get-ChildItem -Path $WinPythonDir -Recurse -Filter "python.exe" -File -ErrorAction SilentlyContinue |
        Where-Object {
            $_.FullName -notlike "*.venv*" -and
            $_.FullName -like "*\python\python.exe"
        } |
        Sort-Object FullName |
        Select-Object -First 1

    if ($null -eq $candidate) {
        return $null
    }

    return [string]$candidate.FullName
}

function Show-MemilWinPythonHelp {
    Write-MemilNg "WinPython python.exe was not found."
    Write-Host ""
    Write-Host "Expected layout:"
    Write-Host ""
    Write-Host "memil-python-env"
    Write-Host "  winpython"
    Write-Host "    WPy64-xxxx"
    Write-Host "      python"
    Write-Host "        python.exe"
    Write-Host ""
    Write-Host "Important:"
    Write-Host "Do not only put WinPython64-xxxx.exe under winpython."
    Write-Host "You need to run or extract it first."
    Write-Host ""
    Write-Host "Recommended page:"
    Write-Host "https://sourceforge.net/projects/winpython/files/WinPython_3.12/3.12.10.1/"
    Write-Host ""
}

function New-MemilProjectVenv {
    param(
        [string]$ProjectDir,
        [string]$PythonExe
    )

    if (-not $PythonExe) {
        throw "PythonExe is empty. WinPython python.exe was not detected."
    }

    if ($PythonExe.Length -le 2) {
        throw "PythonExe looks invalid: $PythonExe"
    }

    if (-not (Test-Path $PythonExe)) {
        throw "PythonExe path does not exist: $PythonExe"
    }

    $VenvDir = Join-Path $ProjectDir ".venv"
    $VenvPython = Join-Path $VenvDir "Scripts\python.exe"

    if (-not (Test-Path $VenvPython)) {
        Write-Host ""
        Write-Host "Creating .venv:"
        Write-Host $VenvDir
        & $PythonExe -m venv $VenvDir
        Write-MemilOk "Created .venv"
    } else {
        Write-MemilOk ".venv already exists"
    }

    Write-Host ""
    Write-Host "Updating pip / setuptools / wheel..."
    & $VenvPython -m pip install -U pip setuptools wheel | Out-Host

    return [string]$VenvPython
}

function Write-MemilVSCodeProjectFiles {
    param(
        [string]$ProjectDir,
        [string]$DisplayName
    )

    $VscodeDir = Join-Path $ProjectDir ".vscode"
    Ensure-MemilDirectory $VscodeDir

    $settings = [ordered]@{
        "python.defaultInterpreterPath" = '${workspaceFolder}\.venv\Scripts\python.exe'
        "python.terminal.activateEnvironment" = $true
        "terminal.integrated.defaultProfile.windows" = "Command Prompt"
    }

    $settings |
        ConvertTo-Json -Depth 10 |
        Set-Content -Path (Join-Path $VscodeDir "settings.json") -Encoding UTF8

    $launch = [ordered]@{
        version = "0.2.0"
        configurations = @(
            [ordered]@{
                name = "Python: current file"
                type = "debugpy"
                request = "launch"
                program = '${file}'
                console = "integratedTerminal"
                justMyCode = $true
            }
        )
    }

    $launch |
        ConvertTo-Json -Depth 10 |
        Set-Content -Path (Join-Path $VscodeDir "launch.json") -Encoding UTF8

    $OpenBat = Join-Path $ProjectDir "OPEN_IN_VSCODE.bat"

    $openLines = @(
        "@echo off",
        "chcp 65001 >nul",
        "cd /d ""%~dp0\..\..""",
        "if exist "".\vscode\Code.exe"" (",
        "    start """" "".\vscode\Code.exe"" ""%~dp0""",
        ") else (",
        "    echo vscode\Code.exe was not found.",
        "    echo Please check Start.bat.",
        "    pause",
        ")"
    )

    $openLines | Set-Content -Path $OpenBat -Encoding ASCII

    Write-MemilOk "VS Code project files created: $DisplayName"
}

function Update-MemilInstalledStatus {
    param(
        [string]$ToolId,
        [string]$ProjectDir,
        [string]$PythonExe
    )

    $Root = Get-MemilRoot
    $InstalledPath = Join-Path $Root "catalog\installed.json"

    $installed = @{}

    if (Test-Path $InstalledPath) {
        $raw = Get-Content $InstalledPath -Raw

        if ($raw -and $raw.Trim().Length -gt 0) {
            $obj = $raw | ConvertFrom-Json

            if ($obj) {
                foreach ($p in $obj.PSObject.Properties) {
                    $installed[$p.Name] = $p.Value
                }
            }
        }
    }

    $installed[$ToolId] = [ordered]@{
        installed = $true
        projectDir = (Resolve-Path $ProjectDir -Relative)
        python = $PythonExe
        installedAt = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    }

    $installed |
        ConvertTo-Json -Depth 10 |
        Set-Content -Path $InstalledPath -Encoding UTF8
}