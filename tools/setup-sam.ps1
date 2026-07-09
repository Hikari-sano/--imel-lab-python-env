$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot "common-winpython.ps1")

$Root = Get-MemilRoot

$ProjectDir = Join-Path $Root "projects\sam-sample"
$CacheDir = Join-Path $Root "cache\sam"
$CheckpointPath = Join-Path $CacheDir "sam_vit_b_01ec64.pth"

Write-MemilTitle "SAM / Segment Anything setup"

Ensure-MemilDirectory $ProjectDir
Ensure-MemilDirectory $CacheDir

Write-MemilTitle "Check WinPython"

$PythonExe = Find-MemilWinPython

if (-not $PythonExe) {
    Show-MemilWinPythonHelp
    throw "WinPython python.exe was not found."
}

Write-MemilOk "Found WinPython"
Write-Host $PythonExe

Write-MemilTitle "Create SAM project environment"

$VenvPython = New-MemilProjectVenv -ProjectDir $ProjectDir -PythonExe $PythonExe

Write-MemilTitle "Install SAM dependencies"

Write-Host "Installing PyTorch CPU packages..."
& $VenvPython -m pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu | Out-Host

Write-Host ""
Write-Host "Installing image packages..."
& $VenvPython -m pip install opencv-python matplotlib pillow numpy | Out-Host

Write-Host ""
Write-Host "Installing Segment Anything from official repository ZIP..."
& $VenvPython -m pip install https://github.com/facebookresearch/segment-anything/archive/refs/heads/main.zip | Out-Host

Write-MemilTitle "Download SAM checkpoint"

$CheckpointUrl = "https://dl.fbaipublicfiles.com/segment_anything/sam_vit_b_01ec64.pth"

if (Test-Path $CheckpointPath) {
    Write-MemilOk "SAM checkpoint already exists:"
    Write-Host $CheckpointPath
} else {
    Write-Host "Downloading:"
    Write-Host $CheckpointUrl
    Invoke-WebRequest -Uri $CheckpointUrl -OutFile $CheckpointPath
    Write-MemilOk "Downloaded SAM checkpoint:"
    Write-Host $CheckpointPath
}

Write-MemilVSCodeProjectFiles -ProjectDir $ProjectDir -DisplayName "SAM / Segment Anything"

Update-MemilInstalledStatus -ToolId "sam-segment-anything" -ProjectDir $ProjectDir -PythonExe $VenvPython

Write-MemilOk "SAM setup completed."
Write-Host ""
Write-Host "Next:"
Write-Host "  .\tools\run-sam-sample.ps1"