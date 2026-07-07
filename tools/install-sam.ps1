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

$ProjectDir = Join-Path $Root "projects\sam-sample"
$ModelDir = Join-Path $Root "models\sam"
Ensure-Dir $ModelDir
$PythonExe = New-ProjectVenv -ProjectDir $ProjectDir
Write-ProjectVscodeSettings -ProjectDir $ProjectDir

Write-Host "Installing SAM dependencies..."
& $UvExe pip install --python "$PythonExe" -U torch torchvision --index-url https://download.pytorch.org/whl/cpu
& $UvExe pip install --python "$PythonExe" -U opencv-python matplotlib
& $UvExe pip install --python "$PythonExe" git+https://github.com/facebookresearch/segment-anything.git

$MainPy = Join-Path $ProjectDir "main.py"
Set-Content -Path $MainPy -Encoding UTF8 -Value @(
    'print("SAM environment is ready.")',
    'print("Put SAM checkpoint files in ../../models/sam/")',
    'print("Recommended small checkpoint: sam_vit_b_01ec64.pth")'
)

$RunBat = Join-Path $ProjectDir "RUN_SAM.bat"
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
    'SAM sample - beginner guide',
    '',
    '1. This installer prepares SAM Python packages.',
    '2. SAM model checkpoint files must be placed in ../../models/sam/.',
    '3. Double-click RUN_SAM.bat to check the environment.'
)

Write-Host "SAM project created: $ProjectDir"
Write-Host "Model folder: $ModelDir"
Write-Host "Beginner run file: $RunBat"
Write-Host "Done."
