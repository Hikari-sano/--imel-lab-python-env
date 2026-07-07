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

Ensure-Uv

$ProjectDir = Join-Path $Root "projects\yolo-sample"
$PythonExe = New-ProjectVenv -ProjectDir $ProjectDir

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

$Readme = Join-Path $ProjectDir "README.md"
Set-Content -Path $Readme -Encoding UTF8 -Value @(
    '# YOLO sample',
    '',
    'Run:',
    '',
    '```powershell',
    '.\.venv\Scripts\python.exe main.py',
    '```'
)

Write-Host "YOLO project created: $ProjectDir"
Write-Host "Done."
