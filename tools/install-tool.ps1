param(
    [Parameter(Mandatory = $true)]
    [string]$ToolId
)

$ErrorActionPreference = "Stop"

. "$PSScriptRoot\common-winpython.ps1"

$Root = Get-MemilRoot
Set-Location $Root

$CatalogPath = Join-Path $Root "catalog\index.json"

if (-not (Test-Path $CatalogPath)) {
    Write-MemilNg "catalog\index.json was not found."
    exit 1
}

$tools = Get-Content $CatalogPath -Raw | ConvertFrom-Json
$tool = $tools | Where-Object { $_.id -eq $ToolId } | Select-Object -First 1

if (-not $tool) {
    Write-MemilNg "Tool not found: $ToolId"
    exit 1
}

Write-MemilTitle "Install: $($tool.name)"

$PythonExe = Find-MemilWinPython

if (-not $PythonExe) {
    Show-MemilWinPythonHelp
    exit 1
}

Write-MemilOk "Base Python found"
Write-Host $PythonExe

$ProjectDir = Join-Path $Root $tool.projectDir
Ensure-MemilDirectory $ProjectDir

$ReadmePath = Join-Path $ProjectDir "README.md"

$readmeLines = @(
    "# $($tool.name)",
    "",
    "$($tool.description)",
    "",
    "## Purpose",
    "",
    "$($tool.purpose)",
    "",
    "## Open in VS Code",
    "",
    "Use:",
    "",
    "OPEN_IN_VSCODE.bat"
)

$readmeLines | Set-Content -Path $ReadmePath -Encoding UTF8

$VenvPython = New-MemilProjectVenv -ProjectDir $ProjectDir -PythonExe $PythonExe

if ($tool.installType -eq "pip") {
    Write-MemilTitle "Install Python packages"

    foreach ($pkg in $tool.packages) {
        Write-Host ""
        Write-Host "Installing: $pkg"
        & $VenvPython -m pip install -U $pkg | Out-Host
    }
} else {
    Write-MemilWarn "Unsupported install type: $($tool.installType)"
}

Write-MemilVSCodeProjectFiles -ProjectDir $ProjectDir -DisplayName $tool.name

$SamplePy = Join-Path $ProjectDir "main.py"

if (-not (Test-Path $SamplePy)) {
    $sampleLines = @(
        'print("MEMIL tool environment is ready.")',
        "print('Tool: $($tool.name)')",
        "print('Purpose: $($tool.purpose)')"
    )

    $sampleLines | Set-Content -Path $SamplePy -Encoding UTF8
}

$RunBat = Join-Path $ProjectDir "RUN.bat"

$runLines = @(
    "@echo off",
    "chcp 65001 >nul",
    "cd /d ""%~dp0""",
    "if exist "".venv\Scripts\python.exe"" (",
    "    "".venv\Scripts\python.exe"" ""main.py""",
    ") else (",
    "    echo .venv was not found.",
    "    echo Please install this tool from Start.bat.",
    ")",
    "pause"
)

$runLines | Set-Content -Path $RunBat -Encoding ASCII

Update-MemilInstalledStatus -ToolId $tool.id -ProjectDir $ProjectDir -PythonExe $VenvPython

Write-MemilTitle "Install complete"

Write-MemilOk "$($tool.name) environment is ready."
Write-Host ""
Write-Host "Project:"
Write-Host $ProjectDir
Write-Host ""
Write-Host "Open in VS Code:"
Write-Host (Join-Path $ProjectDir "OPEN_IN_VSCODE.bat")
Write-Host ""
Write-Host "Run sample:"
Write-Host (Join-Path $ProjectDir "RUN.bat")
Write-Host ""
