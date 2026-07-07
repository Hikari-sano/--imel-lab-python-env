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

$ProjectDir = Join-Path $Root "projects\yolo-sample"
$PythonExe = New-ProjectVenv -ProjectDir $ProjectDir
Write-ProjectVscodeSettings -ProjectDir $ProjectDir

Write-Host "Installing YOLO / Ultralytics..."
& $UvExe pip install --python "$PythonExe" -U ultralytics

$MainPy = Join-Path $ProjectDir "main.py"
Set-Content -Path $MainPy -Encoding UTF8 -Value @(
    'from ultralytics import YOLO',
    '',
    'model = YOLO("yolo11n.pt")',
    'results = model("https://ultralytics.com/images/bus.jpg")',
    'for result in results:',
    '    result.show()',
    '    result.save(filename="yolo_result.jpg")',
    '',
    'print("YOLO sample finished. Check yolo_result.jpg")'
)

$RunBat = Join-Path $ProjectDir "RUN_YOLO.bat"
Set-Content -Path $RunBat -Encoding ASCII -Value @(
    '@echo off',
    'setlocal',
    'cd /d "%~dp0"',
    'echo ========================================',
    'echo Running YOLO sample',
    'echo ========================================',
    'if not exist ".\.venv\Scripts\python.exe" (',
    '  echo [ERROR] Python environment not found.',
    '  echo Please run YOLO_INSTALL.bat again.',
    '  pause',
    '  exit /b 1',
    ')',
    '".\.venv\Scripts\python.exe" "main.py"',
    'echo.',
    'echo Finished. Check yolo_result.jpg in this folder.',
    'pause',
    'endlocal'
)

$ReadmeFirst = Join-Path $ProjectDir "README_FIRST.txt"
Set-Content -Path $ReadmeFirst -Encoding UTF8 -Value @(
    'YOLO sample - beginner guide',
    '',
    '1. Double-click RUN_YOLO.bat.',
    '2. The first run may download a YOLO model file and can take time.',
    '3. After completion, check yolo_result.jpg.',
    '',
    'Important:',
    'Do not use the VS Code Run button if you are not sure which Python interpreter is selected.',
    'Use RUN_YOLO.bat instead.'
)

$Readme = Join-Path $ProjectDir "README.md"
Set-Content -Path $Readme -Encoding UTF8 -Value @(
    '# YOLO sample',
    '',
    'Recommended for beginners:',
    '',
    'Double-click `RUN_YOLO.bat`.',
    '',
    'Manual run:',
    '',
    '```powershell',
    '.\.venv\Scripts\python.exe main.py',
    '```'
)

Write-Host "YOLO project created: $ProjectDir"
Write-Host "Beginner run file: $RunBat"
Write-Host "Done."
