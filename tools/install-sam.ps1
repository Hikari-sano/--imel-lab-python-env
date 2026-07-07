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

$ProjectDir = Join-Path $Root "projects\sam-sample"
$ModelDir = Join-Path $Root "models\sam"
Ensure-Dir $ModelDir
$PythonExe = New-ProjectVenv -ProjectDir $ProjectDir

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

$Readme = Join-Path $ProjectDir "README.md"
Set-Content -Path $Readme -Encoding UTF8 -Value @(
    '# SAM sample',
    '',
    'This installer sets up the SAM Python package and creates a model folder:',
    '',
    '../../models/sam/',
    '',
    'Download a SAM checkpoint manually and place it there.',
    'Recommended small model: sam_vit_b_01ec64.pth'
)

Write-Host "SAM project created: $ProjectDir"
Write-Host "Model folder: $ModelDir"
Write-Host "Done."
