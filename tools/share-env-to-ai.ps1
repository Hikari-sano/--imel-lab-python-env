$ErrorActionPreference = "Continue"

. "$PSScriptRoot\common-winpython.ps1"

$Root = Get-MemilRoot
Set-Location $Root

$LogDir = Join-Path $Root "logs"

if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir | Out-Null
}

$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$ReportPath = Join-Path $LogDir "ai-support-report-$Timestamp.txt"

function Add-Line {
    param([string]$Text = "")
    Add-Content -Path $ReportPath -Value $Text -Encoding UTF8
}

function Add-Section {
    param([string]$Title)

    Add-Line ""
    Add-Line "========================================"
    Add-Line $Title
    Add-Line "========================================"
    Add-Line ""
}

function Add-CommandOutput {
    param(
        [string]$Title,
        [scriptblock]$Command
    )

    Add-Section $Title

    try {
        $output = & $Command 2>&1

        if ($null -eq $output) {
            Add-Line "(no output)"
        } else {
            $output | ForEach-Object {
                Add-Line ($_ | Out-String).TrimEnd()
            }
        }
    } catch {
        Add-Line "[ERROR]"
        Add-Line $_.Exception.Message
    }
}

function Add-FileIfExists {
    param(
        [string]$Title,
        [string]$Path
    )

    Add-Section $Title

    if (Test-Path $Path) {
        try {
            Get-Content $Path -Raw | Add-Content -Path $ReportPath -Encoding UTF8
        } catch {
            Add-Line "[ERROR] Failed to read file:"
            Add-Line $Path
            Add-Line $_.Exception.Message
        }
    } else {
        Add-Line "[MISSING] $Path"
    }
}

function Add-Tree {
    param(
        [string]$Directory,
        [int]$MaxDepth = 3
    )

    Add-Section "File tree"

    if (-not (Test-Path $Directory)) {
        Add-Line "[MISSING] $Directory"
        return
    }

    $baseDepth = ($Directory.TrimEnd("\") -split "\\").Count

    Get-ChildItem -Path $Directory -Recurse -Force -ErrorAction SilentlyContinue |
        Where-Object {
            $relativeDepth = ($_.FullName -split "\\").Count - $baseDepth
            $relativeDepth -le $MaxDepth
        } |
        Where-Object {
            $_.FullName -notlike "*\.git\*" -and
            $_.FullName -notlike "*\.venv\Lib\*" -and
            $_.FullName -notlike "*\.venv\site-packages\*" -and
            $_.FullName -notlike "*\node_modules\*" -and
            $_.FullName -notlike "*\vscode\data\*" -and
            $_.FullName -notlike "*\cache\*" -and
            $_.FullName -notlike "*\logs\ai-support-report-*"
        } |
        ForEach-Object {
            $relative = $_.FullName.Substring($Directory.Length).TrimStart("\")
            if ($_.PSIsContainer) {
                Add-Line "[DIR]  $relative"
            } else {
                Add-Line "[FILE] $relative"
            }
        }
}

# Start report
"" | Set-Content -Path $ReportPath -Encoding UTF8

Add-Line "MEMIL Python / AI Environment Catalog"
Add-Line "AI Support Report"
Add-Line ""
Add-Line "Created at: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Add-Line "Root: $Root"
Add-Line ""

Add-Section "How to use this report"

Add-Line "Copy this report and paste it into an AI assistant or send it to the support person."
Add-Line ""
Add-Line "Recommended prompt:"
Add-Line ""
Add-Line "I am using MEMIL Python / AI Environment Catalog on Windows."
Add-Line "An error occurred. Please analyze the environment report below and tell me what to check next."
Add-Line ""

Add-Section "Basic environment"

Add-Line "Computer name: $env:COMPUTERNAME"
Add-Line "User name: $env:USERNAME"
Add-Line "OS: $([System.Environment]::OSVersion.VersionString)"
Add-Line "PowerShell version: $($PSVersionTable.PSVersion)"
Add-Line "Current directory: $(Get-Location)"

Add-Section "Important paths"

Add-Line "Root: $Root"
Add-Line "winpython: $(Join-Path $Root 'winpython')"
Add-Line "vscode: $(Join-Path $Root 'vscode')"
Add-Line "projects: $(Join-Path $Root 'projects')"
Add-Line "catalog: $(Join-Path $Root 'catalog')"
Add-Line "tools: $(Join-Path $Root 'tools')"
Add-Line "logs: $(Join-Path $Root 'logs')"

Add-Section "WinPython check"

$PythonExe = Find-MemilWinPython

if ($PythonExe) {
    Add-Line "[OK] WinPython python.exe found"
    Add-Line $PythonExe

    Add-CommandOutput "WinPython version" {
        & $PythonExe --version
    }

    Add-CommandOutput "WinPython pip version" {
        & $PythonExe -m pip --version
    }
} else {
    Add-Line "[NG] WinPython python.exe was not found."
    Add-Line ""
    Add-Line "Expected layout:"
    Add-Line "memil-python-env"
    Add-Line "  winpython"
    Add-Line "    WPy64-xxxx"
    Add-Line "      python"
    Add-Line "        python.exe"
    Add-Line ""
    Add-Line "Important:"
    Add-Line "Do not only put Winpython64-xxxx.exe under winpython."
    Add-Line "You need to run or extract it first."
}

Add-Section "VS Code check"

$CodeExe = Join-Path $Root "vscode\Code.exe"

if (Test-Path $CodeExe) {
    Add-Line "[OK] VS Code found"
    Add-Line $CodeExe
    Add-Line "Version check skipped to avoid noisy VS Code startup logs."
} else {
    Add-Line "[WARN] VS Code was not found."
    Add-Line "Expected: vscode\Code.exe"
}

Add-FileIfExists "catalog/index.json" (Join-Path $Root "catalog\index.json")
Add-FileIfExists "catalog/setup.json" (Join-Path $Root "catalog\setup.json")
Add-FileIfExists "catalog/installed.json" (Join-Path $Root "catalog\installed.json")

Add-Section "Projects summary"

$ProjectsDir = Join-Path $Root "projects"

if (Test-Path $ProjectsDir) {
    $projects = Get-ChildItem -Path $ProjectsDir -Directory -ErrorAction SilentlyContinue

    if ($projects.Count -eq 0) {
        Add-Line "[WARN] No project folders found."
    } else {
        foreach ($project in $projects) {
            Add-Line ""
            Add-Line "Project: $($project.Name)"
            Add-Line "Path: $($project.FullName)"

            $venvPython = Join-Path $project.FullName ".venv\Scripts\python.exe"
            $settingsJson = Join-Path $project.FullName ".vscode\settings.json"
            $launchJson = Join-Path $project.FullName ".vscode\launch.json"
            $openBat = Join-Path $project.FullName "OPEN_IN_VSCODE.bat"
            $runBat = Join-Path $project.FullName "RUN.bat"

            if (Test-Path $venvPython) {
                Add-Line "[OK] .venv python found"
                Add-Line $venvPython

                Add-CommandOutput "pip list for project $($project.Name)" {
                    & $venvPython -m pip list
                }
            } else {
                Add-Line "[WARN] .venv python not found"
            }

            if (Test-Path $settingsJson) {
                Add-Line "[OK] .vscode/settings.json found"
            } else {
                Add-Line "[WARN] .vscode/settings.json not found"
            }

            if (Test-Path $launchJson) {
                Add-Line "[OK] .vscode/launch.json found"
            } else {
                Add-Line "[WARN] .vscode/launch.json not found"
            }

            if (Test-Path $openBat) {
                Add-Line "[OK] OPEN_IN_VSCODE.bat found"
            } else {
                Add-Line "[WARN] OPEN_IN_VSCODE.bat not found"
            }

            if (Test-Path $runBat) {
                Add-Line "[OK] RUN.bat found"
            } else {
                Add-Line "[INFO] RUN.bat not found"
            }
        }
    }
} else {
    Add-Line "[WARN] projects folder was not found."
}

Add-Section "Recent health check logs"

$healthLogs = Get-ChildItem -Path $LogDir -Filter "health-check-*.txt" -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 3

if ($healthLogs.Count -eq 0) {
    Add-Line "[INFO] No health-check logs found."
} else {
    foreach ($log in $healthLogs) {
        Add-Line ""
        Add-Line "Log: $($log.Name)"
        Add-Line "Path: $($log.FullName)"
        Add-Line "LastWriteTime: $($log.LastWriteTime)"
    }
}

Add-Tree -Directory $Root -MaxDepth 3

Add-Section "Git status"

Add-CommandOutput "git status" {
    git status
}

Add-Section "Final note"

Add-Line "If you ask an AI assistant for help, include:"
Add-Line ""
Add-Line "1. What you tried to do"
Add-Line "2. The exact error message"
Add-Line "3. This report"
Add-Line ""
Add-Line "End of report."

Write-MemilTitle "AI support report created"

Write-MemilOk "Report created:"
Write-Host $ReportPath
Write-Host ""

Write-Host "Opening report with Notepad..."
notepad $ReportPath
