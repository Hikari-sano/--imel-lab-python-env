$ErrorActionPreference = "Continue"

. "$PSScriptRoot\common-winpython.ps1"

$Root = Get-MemilRoot
Set-Location $Root

$LogDir = Join-Path $Root "logs"

if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir | Out-Null
}

$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$LogFile = Join-Path $LogDir "health-check-$Timestamp.txt"

Start-Transcript -Path $LogFile -Force | Out-Null

Write-MemilTitle "MEMIL Environment Health Check"

Write-Host "Root:"
Write-Host $Root

Write-MemilTitle "Basic folders"

$folders = @(
    "winpython",
    "vscode",
    "projects",
    "tools",
    "docs",
    "catalog",
    "logs",
    "cache",
    "legacy"
)

foreach ($folder in $folders) {
    $path = Join-Path $Root $folder

    if (Test-Path $path) {
        Write-MemilOk "$folder exists"
    } else {
        Write-MemilWarn "$folder not found"
    }
}

Write-MemilTitle "WinPython"

$PythonExe = Find-MemilWinPython

if ($PythonExe) {
    Write-MemilOk "WinPython python.exe found"
    Write-Host $PythonExe
    & $PythonExe --version
    & $PythonExe -m pip --version
} else {
    Show-MemilWinPythonHelp
}

Write-MemilTitle "VS Code"

$CodeExe = Join-Path $Root "vscode\Code.exe"

if (Test-Path $CodeExe) {
    Write-MemilOk "VS Code found"
    Write-Host $CodeExe
    Write-Host "VS Code executable check only. Version check skipped."
} else {
    Write-MemilWarn "vscode\Code.exe not found"
}

Write-MemilTitle "Catalog files"

$catalogFiles = @(
    "catalog\index.json",
    "catalog\setup.json",
    "catalog\installed.json"
)

foreach ($file in $catalogFiles) {
    $path = Join-Path $Root $file

    if (Test-Path $path) {
        Write-MemilOk "$file found"
    } else {
        Write-MemilWarn "$file not found"
    }
}

Write-MemilTitle "Projects"

$ProjectsDir = Join-Path $Root "projects"

if (Test-Path $ProjectsDir) {
    $projects = Get-ChildItem -Path $ProjectsDir -Directory -ErrorAction SilentlyContinue

    if ($projects.Count -eq 0) {
        Write-MemilWarn "No project folders found"
    } else {
        foreach ($project in $projects) {
            Write-Host ""
            Write-Host "Project: $($project.Name)"

            $venvPython = Join-Path $project.FullName ".venv\Scripts\python.exe"
            $openBat = Join-Path $project.FullName "OPEN_IN_VSCODE.bat"
            $settingsJson = Join-Path $project.FullName ".vscode\settings.json"

            if (Test-Path $venvPython) {
                Write-MemilOk ".venv python found"
                & $venvPython --version
            } else {
                Write-MemilWarn ".venv python not found"
            }

            if (Test-Path $openBat) {
                Write-MemilOk "OPEN_IN_VSCODE.bat found"
            } else {
                Write-MemilWarn "OPEN_IN_VSCODE.bat not found"
            }

            if (Test-Path $settingsJson) {
                Write-MemilOk ".vscode/settings.json found"
            } else {
                Write-MemilWarn ".vscode/settings.json not found"
            }
        }
    }
}

Write-MemilTitle "Summary"

Write-Host "Health check completed."
Write-Host ""
Write-Host "Log file:"
Write-Host $LogFile
Write-Host ""
Write-Host "If you need help, run Start.bat and select:"
Write-Host "7. Create report for AI support"
Write-Host ""

Stop-Transcript | Out-Null
