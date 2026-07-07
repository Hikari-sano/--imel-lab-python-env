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

$ProjectDir = Join-Path $Root "projects\transformers-sample"
$PythonExe = New-ProjectVenv -ProjectDir $ProjectDir

Write-Host "Installing Hugging Face Transformers..."
& $UvExe pip install --python "$PythonExe" -U torch --index-url https://download.pytorch.org/whl/cpu
& $UvExe pip install --python "$PythonExe" -U transformers accelerate sentencepiece

$MainPy = Join-Path $ProjectDir "main.py"
Set-Content -Path $MainPy -Encoding UTF8 -Value @(
    'from transformers import pipeline',
    '',
    'classifier = pipeline("sentiment-analysis")',
    'result = classifier("Hugging Face Transformers is ready.")',
    'print(result)'
)

$Readme = Join-Path $ProjectDir "README.md"
Set-Content -Path $Readme -Encoding UTF8 -Value @(
    '# Transformers sample',
    '',
    'Run:',
    '',
    '```powershell',
    '.\.venv\Scripts\python.exe main.py',
    '```'
)

Write-Host "Transformers project created: $ProjectDir"
Write-Host "Done."
