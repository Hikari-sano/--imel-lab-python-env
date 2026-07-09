$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot "common-winpython.ps1")

$Root = Get-MemilRoot

$ProjectDir = Join-Path $Root "projects\sam-sample"
$VenvPython = Join-Path $ProjectDir ".venv\Scripts\python.exe"
$RunPy = Join-Path $ProjectDir "run_sam_sample.py"
$OutputPath = Join-Path $ProjectDir "sam_result.png"

Write-MemilTitle "Run SAM / Segment Anything sample"

if (-not (Test-Path $VenvPython)) {
    Write-MemilNg "SAM .venv was not found."
    Write-Host "Please run:"
    Write-Host "  .\tools\setup-sam.ps1"
    throw "SAM environment is not ready."
}

if (-not (Test-Path $RunPy)) {
    throw "SAM sample script was not found: $RunPy"
}

& $VenvPython $RunPy | Out-Host

if (Test-Path $OutputPath) {
    Write-MemilOk "SAM result created:"
    Write-Host $OutputPath
    Start-Process $OutputPath
} else {
    Write-MemilWarn "SAM result was not created."
}