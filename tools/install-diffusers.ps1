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

$ProjectDir = Join-Path $Root "projects\diffusers-sample"
$PythonExe = New-ProjectVenv -ProjectDir $ProjectDir

Write-Host "Installing Diffusers..."
& $UvExe pip install --python "$PythonExe" -U torch --index-url https://download.pytorch.org/whl/cpu
& $UvExe pip install --python "$PythonExe" -U diffusers transformers accelerate safetensors pillow

$MainPy = Join-Path $ProjectDir "main.py"
Set-Content -Path $MainPy -Encoding UTF8 -Value @(
    'print("Diffusers environment is ready.")',
    'print("CPU image generation can be very slow. GPU is recommended for large diffusion models.")'
)

$Readme = Join-Path $ProjectDir "README.md"
Set-Content -Path $Readme -Encoding UTF8 -Value @(
    '# Diffusers sample',
    '',
    'Diffusers is installed. Large image generation models may require a GPU and significant disk space.'
)

Write-Host "Diffusers project created: $ProjectDir"
Write-Host "Done."
