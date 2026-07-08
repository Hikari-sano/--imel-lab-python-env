$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

function Ensure-Dir {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
    }
}

function Get-WinPythonBasePython {
    $WinPythonDir = Join-Path $Root "winpython"
    if (-not (Test-Path $WinPythonDir)) {
        throw "WinPython folder not found. Please put WinPython under: $WinPythonDir"
    }

    $candidates = Get-ChildItem -Path $WinPythonDir -Recurse -Filter "python.exe" -ErrorAction SilentlyContinue | Where-Object {
        $_.FullName -notlike "*.venv*" -and $_.FullName -like "*\python\python.exe"
    } | Sort-Object FullName

    if (-not $candidates -or $candidates.Count -eq 0) {
        throw "WinPython python.exe not found. Expected something like winpython\WPy64-*\python\python.exe"
    }

    return [string]$candidates[0].FullName
}

function New-ProjectVenv {
    param([string]$ProjectDir)

    Ensure-Dir $ProjectDir

    $BasePython = Get-WinPythonBasePython
    $VenvDir = Join-Path $ProjectDir ".venv"
    $PythonExe = Join-Path $VenvDir "Scripts\python.exe"

    if (-not (Test-Path $PythonExe)) {
        Write-Host "Creating virtual environment: $VenvDir"
        & $BasePython -m venv "$VenvDir"
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to create virtual environment: $VenvDir"
        }
    } else {
        Write-Host "Virtual environment already exists: $VenvDir"
    }

    Write-Host "Updating pip, setuptools, and wheel..."
    & $PythonExe -m pip install -U pip setuptools wheel | Out-Host
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to update pip/setuptools/wheel in: $VenvDir"
    }

    return [string]$PythonExe
}

function Write-ProjectVscodeSettings {
    param([string]$ProjectDir)

    $VsDir = Join-Path $ProjectDir ".vscode"
    Ensure-Dir $VsDir

    $SettingsPath = Join-Path $VsDir "settings.json"
    Set-Content -Path $SettingsPath -Encoding UTF8 -Value @(
        '{',
        '  "python.defaultInterpreterPath": "${workspaceFolder}\\.venv\\Scripts\\python.exe",',
        '  "python.terminal.activateEnvironment": true,',
        '  "python.useEnvironmentsExtension": false,',
        '  "terminal.integrated.defaultProfile.windows": "PowerShell"',
        '}'
    )

    $LaunchPath = Join-Path $VsDir "launch.json"
    Set-Content -Path $LaunchPath -Encoding UTF8 -Value @(
        '{',
        '  "version": "0.2.0",',
        '  "configurations": [',
        '    {',
        '      "name": "Run current Python file",',
        '      "type": "debugpy",',
        '      "request": "launch",',
        '      "program": "${file}",',
        '      "console": "integratedTerminal",',
        '      "cwd": "${workspaceFolder}",',
        '      "python": "${workspaceFolder}\\.venv\\Scripts\\python.exe"',
        '    }',
        '  ]',
        '}'
    )

    $OpenBat = Join-Path $ProjectDir "OPEN_IN_VSCODE.bat"
    Set-Content -Path $OpenBat -Encoding ASCII -Value @(
        '@echo off',
        'setlocal',
        'cd /d "%~dp0"',
        'set "ROOT=%~dp0..\.."',
        'if exist "%ROOT%\vscode\Code.exe" (',
        '  start "" "%ROOT%\vscode\Code.exe" "%~dp0"',
        ') else (',
        '  echo VS Code was not found. Please run Start.bat first.',
        '  pause',
        ')',
        'endlocal'
    )
}
