$ErrorActionPreference = "Stop"

. "$PSScriptRoot\common-winpython.ps1"

$Root = Get-MemilRoot
Set-Location $Root

Write-MemilTitle "MEMIL First Setup"

Write-Host "This setup prepares basic folders and hello-python project."
Write-Host ""

$folders = @(
    "winpython",
    "vscode",
    "projects",
    "tools",
    "docs",
    "logs",
    "catalog",
    "cache"
)

foreach ($folder in $folders) {
    Ensure-MemilDirectory (Join-Path $Root $folder)
}

Write-MemilTitle "Check VS Code"

& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot "install-vscode.ps1")
Write-MemilTitle "Check WinPython"

$PythonExe = Find-MemilWinPython

if (-not $PythonExe) {
    Show-MemilWinPythonHelp
    Write-Host "After extracting WinPython, run Start.bat -> 1 again."
    exit 1
}

Write-MemilOk "Found WinPython"
Write-Host $PythonExe

Write-MemilTitle "Create hello-python project"

$ProjectDir = Join-Path $Root "projects\hello-python"
Ensure-MemilDirectory $ProjectDir

$MainPy = Join-Path $ProjectDir "main.py"

$mainLines = @(
    'print("Hello, MEMIL Python!")',
    'print("This project was created by MEMIL Python / AI Environment Catalog.")'
)

if (-not (Test-Path $MainPy)) {
    $mainLines | Set-Content -Path $MainPy -Encoding UTF8
    Write-MemilOk "Created: projects\hello-python\main.py"
} else {
    Write-MemilOk "Exists: projects\hello-python\main.py"
}

$VenvPython = New-MemilProjectVenv -ProjectDir $ProjectDir -PythonExe $PythonExe
Write-MemilVSCodeProjectFiles -ProjectDir $ProjectDir -DisplayName "hello-python"

$NextStep = Join-Path $Root "NEXT_STEP.txt"

$nextLines = @(
    "MEMIL Python / AI Environment Catalog",
    "",
    "First setup is complete.",
    "",
    "Recommended next steps:",
    "",
    "1. Open Start.bat",
    "2. Select 3. AI / Tools catalog",
    "3. Try one of these:",
    "",
    "   - Common Python packages",
    "   - Jupyter / JupyterLab",
    "   - YOLO / Ultralytics",
    "",
    "To open hello-python in VS Code:",
    "",
    "projects\hello-python\OPEN_IN_VSCODE.bat",
    "",
    "If an error occurs:",
    "",
    "Open Start.bat and select:",
    "7. Create report for AI support"
)

$nextLines | Set-Content -Path $NextStep -Encoding UTF8

Write-MemilOk "Created: NEXT_STEP.txt"

Write-MemilTitle "Setup complete"

Write-MemilOk "First setup completed."
Write-Host ""
Write-Host "Next: Start.bat -> 3. AI / Tools catalog"
Write-Host ""

notepad $NextStep
