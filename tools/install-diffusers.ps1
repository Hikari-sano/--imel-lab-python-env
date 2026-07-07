$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$UvExe = Join-Path $Root "python\uv\uv.exe"

function Ensure-Dir {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
    }
}

function Ensure-Uv {
    if (-not (Test-Path $UvExe)) {
        throw "uv.exe not found. Please run Start.bat first. Expected: $UvExe"
    }
}

function New-ProjectVenv {
    param(
        [string]$ProjectDir,
        [string]$PythonVersion = "3.12"
    )

    Ensure-Dir $ProjectDir
    $VenvDir = Join-Path $ProjectDir ".venv"
    $PythonExe = Join-Path $VenvDir "Scripts\python.exe"

    if (-not (Test-Path $PythonExe)) {
        Write-Host "Creating virtual environment: $VenvDir"
        & $UvExe venv "$VenvDir" --python $PythonVersion
    } else {
        Write-Host "Virtual environment already exists: $VenvDir"
    }

    return $PythonExe
}

function Write-ProjectVscodeSettings {
    param([string]$ProjectDir)
    $VsDir = Join-Path $ProjectDir ".vscode"
    Ensure-Dir $VsDir
    $SettingsPath = Join-Path $VsDir "settings.json"
    Set-Content -Path $SettingsPath -Encoding UTF8 -Value @(
        '{',
        '  "python.defaultInterpreterPath": "${workspaceFolder}\\.venv\\Scripts\\python.exe",',
        '  "python.terminal.activateEnvironment": true,',
        '  "python.analysis.extraPaths": [',
        '    "${workspaceFolder}\\.venv\\Lib\\site-packages"',
        '  ]',
        '}'
    )
}

Ensure-Uv

$ProjectDir = Join-Path $Root "projects\diffusers-sample"
$PythonExe = New-ProjectVenv -ProjectDir $ProjectDir
Write-ProjectVscodeSettings -ProjectDir $ProjectDir

Write-Host "Installing Diffusers..."
& $UvExe pip install --python "$PythonExe" -U torch --index-url https://download.pytorch.org/whl/cpu
& $UvExe pip install --python "$PythonExe" -U diffusers transformers accelerate safetensors pillow

$MainPy = Join-Path $ProjectDir "main.py"
Set-Content -Path $MainPy -Encoding UTF8 -Value @(
    'print("Diffusers environment is ready.")',
    'print("CPU image generation can be very slow. GPU is recommended for large diffusion models.")'
)

$RunBat = Join-Path $ProjectDir "RUN_DIFFUSERS.bat"
Set-Content -Path $RunBat -Encoding ASCII -Value @(
    '@echo off',
    'setlocal',
    'cd /d "%~dp0"',
    '".\.venv\Scripts\python.exe" "main.py"',
    'pause',
    'endlocal'
)

$ReadmeFirst = Join-Path $ProjectDir "README_FIRST.txt"
Set-Content -Path $ReadmeFirst -Encoding UTF8 -Value @(
    'Diffusers sample - beginner guide',
    '',
    'Double-click RUN_DIFFUSERS.bat to check the environment.',
    'Large image generation models usually require a GPU.'
)

Write-Host "Diffusers project created: $ProjectDir"
Write-Host "Beginner run file: $RunBat"
Write-Host "Done."
