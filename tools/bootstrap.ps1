$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

$VscodeDir = Join-Path $Root "vscode"
$VscodeExe = Join-Path $VscodeDir "Code.exe"
$VscodeData = Join-Path $VscodeDir "data"

$CacheDir = Join-Path $Root "cache"
$ProjectsDir = Join-Path $Root "projects"

$PythonDir = Join-Path $Root "python"
$UvDir = Join-Path $PythonDir "uv"
$UvExe = Join-Path $UvDir "uv.exe"
$PythonVersionsDir = Join-Path $PythonDir "versions"
$UvCache = Join-Path $CacheDir "uv"

function Ensure-Dir {
    param(
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
    }
}

Ensure-Dir $VscodeDir
Ensure-Dir $VscodeData
Ensure-Dir $CacheDir
Ensure-Dir $ProjectsDir
Ensure-Dir $PythonDir
Ensure-Dir $UvDir
Ensure-Dir $PythonVersionsDir
Ensure-Dir $UvCache

Write-Host "== PyDevCatalog setup =="
Write-Host "Root: $Root"

if (-not (Test-Path $VscodeExe)) {
    Write-Host "[1/5] Downloading VS Code ZIP..."

    $ZipUrl = "https://update.code.visualstudio.com/latest/win32-x64-archive/stable"
    $ZipPath = Join-Path $CacheDir "vscode-win32-x64-latest.zip"
    $TempExtract = Join-Path $CacheDir "vscode-extract"

    if (Test-Path $ZipPath) {
        Remove-Item $ZipPath -Force
    }

    if (Test-Path $TempExtract) {
        Remove-Item $TempExtract -Recurse -Force
    }

    Ensure-Dir $TempExtract

    Invoke-WebRequest -Uri $ZipUrl -OutFile $ZipPath

    Write-Host "[1/5] Extracting VS Code..."
    Expand-Archive -Path $ZipPath -DestinationPath $TempExtract -Force

    Get-ChildItem -Path $TempExtract | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination $VscodeDir -Recurse -Force
    }

    Remove-Item $TempExtract -Recurse -Force
} else {
    Write-Host "[1/5] VS Code already exists."
}

Ensure-Dir $VscodeData

if (-not (Test-Path $UvExe)) {
    Write-Host "[2/5] Installing uv..."

    $env:UV_INSTALL_DIR = $UvDir
    $env:UV_NO_MODIFY_PATH = "1"

    Invoke-RestMethod https://astral.sh/uv/install.ps1 | Invoke-Expression
} else {
    Write-Host "[2/5] uv already exists."
}

if (-not (Test-Path $UvExe)) {
    throw "uv.exe was not found: $UvExe"
}

$env:UV_PYTHON_INSTALL_DIR = $PythonVersionsDir
$env:UV_CACHE_DIR = $UvCache

Write-Host "[3/5] Installing Python 3.12..."
& $UvExe python install 3.12

$HelloDir = Join-Path $ProjectsDir "hello-python"
$VscodeProjectDir = Join-Path $HelloDir ".vscode"

Ensure-Dir $HelloDir
Ensure-Dir $VscodeProjectDir

$MainPy = Join-Path $HelloDir "main.py"

if (-not (Test-Path $MainPy)) {
    Set-Content -Path $MainPy -Encoding UTF8 -Value @(
        'print("Hello from PyDevCatalog!")',
        'print("VS Code portable Python environment is ready.")'
    )
}

$PyProject = Join-Path $HelloDir "pyproject.toml"

if (-not (Test-Path $PyProject)) {
    Set-Content -Path $PyProject -Encoding UTF8 -Value @(
        '[project]',
        'name = "hello-python"',
        'version = "0.1.0"',
        'description = "PyDevCatalog sample project"',
        'requires-python = ">=3.12"',
        'dependencies = []'
    )
}

$SettingsJson = Join-Path $VscodeProjectDir "settings.json"

Set-Content -Path $SettingsJson -Encoding UTF8 -Value @(
    '{',
    '  "python.defaultInterpreterPath": "${workspaceFolder}\\.venv\\Scripts\\python.exe",',
    '  "python.terminal.activateEnvironment": true,',
    '  "editor.formatOnSave": true,',
    '  "python.analysis.typeCheckingMode": "basic"',
    '}'
)

$VenvDir = Join-Path $HelloDir ".venv"
$VenvPython = Join-Path $VenvDir "Scripts\python.exe"

if (-not (Test-Path $VenvPython)) {
    Write-Host "[4/5] Creating virtual environment..."
    & $UvExe venv "$VenvDir" --python 3.12
} else {
    Write-Host "[4/5] Virtual environment already exists."
}

$CodeCmd = Join-Path $VscodeDir "bin\code.cmd"

if (Test-Path $CodeCmd) {
    Write-Host "[5/5] Installing VS Code extensions..."

    $Extensions = @(
        "ms-ceintl.vscode-language-pack-ja",
        "ms-python.python",
        "ms-python.vscode-pylance",
        "ms-python.debugpy",
        "charliermarsh.ruff"
    )

    foreach ($Ext in $Extensions) {
        Write-Host "Installing extension: $Ext"

        try {
            & $CodeCmd --install-extension $Ext --force
        } catch {
            Write-Host "Warning: failed to install extension: $Ext"
        }
    }
} else {
    Write-Host "Warning: code.cmd was not found. Extension install skipped."
}

Write-Host "Setup completed."
