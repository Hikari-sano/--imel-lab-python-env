$ErrorActionPreference = "Stop"

. "$PSScriptRoot\common-winpython.ps1"

$Root = Get-MemilRoot
Set-Location $Root

$SetupPath = Join-Path $Root "catalog\setup.json"
$CatalogPath = Join-Path $Root "catalog\index.json"

if (-not (Test-Path $SetupPath)) {
    Write-MemilNg "catalog\setup.json was not found."
    exit 1
}

if (-not (Test-Path $CatalogPath)) {
    Write-MemilNg "catalog\index.json was not found."
    exit 1
}

$setup = Get-Content $SetupPath -Raw | ConvertFrom-Json
$presets = @($setup.presets)
$catalogTools = @(Get-Content $CatalogPath -Raw | ConvertFrom-Json)

function Test-MemilWinPythonReady {
    $python = Find-MemilWinPython

    if ($python) {
        Write-MemilOk "WinPython found."
        Write-Host $python
        return $true
    }

    Write-MemilNg "WinPython is not ready."
    Write-Host ""
    Write-Host "Please open Start.bat and select:"
    Write-Host "9. WinPython setup guide"
    Write-Host ""
    Show-MemilWinPythonHelp
    return $false
}

function Invoke-MemilFirstSetup {
    $script = Join-Path $Root "tools\first-setup.ps1"

    if (Test-Path $script) {
        & powershell -NoProfile -ExecutionPolicy Bypass -File $script
    } else {
        Write-MemilWarn "tools\first-setup.ps1 was not found."
    }
}

function Invoke-MemilToolInstall {
    param([string]$ToolId)

    $installer = Join-Path $Root "tools\install-tool.ps1"

    if (-not (Test-Path $installer)) {
        Write-MemilNg "tools\install-tool.ps1 was not found."
        return
    }

    & powershell -NoProfile -ExecutionPolicy Bypass -File $installer -ToolId $ToolId
}

function Invoke-MemilVSCodeExtensions {
    $script = Join-Path $Root "tools\install-vscode-extensions.ps1"

    if (Test-Path $script) {
        & powershell -NoProfile -ExecutionPolicy Bypass -File $script
    } else {
        Write-MemilWarn "tools\install-vscode-extensions.ps1 was not found. Skipped."
    }
}

function Show-PresetDetail {
    param($Preset)

    Clear-Host
    Write-MemilTitle $Preset.name

    Write-Host $Preset.description
    Write-Host ""
    Write-Host "Items:"
    Write-Host ""

    foreach ($item in $Preset.items) {
        $tool = $catalogTools | Where-Object { $_.id -eq $item } | Select-Object -First 1

        if ($tool) {
            Write-Host " - $($tool.name)"
        } else {
            Write-Host " - $item"
        }
    }

    Write-Host ""
}

while ($true) {
    Clear-Host
    Write-MemilTitle "Recommended Setup"

    Write-Host "Choose a setup preset."
    Write-Host ""

    for ($i = 0; $i -lt $presets.Count; $i++) {
        $n = $i + 1
        $preset = $presets[$i]

        Write-Host "$n. $($preset.name)"
        Write-Host "   $($preset.description)"
        Write-Host ""
    }

    Write-Host "0. Back"
    Write-Host ""

    $choice = Read-Host "Select number"

    if ($choice -eq "0") {
        break
    }

    if ($choice -notmatch "^[0-9]+$") {
        Write-Host "Invalid input."
        Read-Host "Press Enter to continue"
        continue
    }

    $index = [int]$choice

    if ($index -lt 1 -or $index -gt $presets.Count) {
        Write-Host "Invalid number."
        Read-Host "Press Enter to continue"
        continue
    }

    $selected = $presets[$index - 1]

    Show-PresetDetail -Preset $selected

    $answer = Read-Host "Start this setup? [y/N]"

    if ($answer -ne "y" -and $answer -ne "Y") {
        continue
    }

    Write-MemilTitle "Pre-check"

    if (-not (Test-MemilWinPythonReady)) {
        Read-Host "Press Enter to continue"
        continue
    }

    Write-MemilTitle "Run preset: $($selected.name)"

    foreach ($item in $selected.items) {
        Write-Host ""
        Write-Host "Processing: $item"

        if ($item -eq "winpython") {
            if (-not (Test-MemilWinPythonReady)) {
                break
            }
        }
        elseif ($item -eq "vscode") {
            $codeExe = Join-Path $Root "vscode\Code.exe"

            if (Test-Path $codeExe) {
                Write-MemilOk "VS Code found."
            } else {
                Write-MemilWarn "VS Code was not found at vscode\Code.exe."
                Write-Host "This preset will continue, but VS Code may need to be prepared separately."
            }
        }
        elseif ($item -eq "vscode-extensions") {
            Invoke-MemilVSCodeExtensions
        }
        elseif ($item -eq "hello-python") {
            Invoke-MemilFirstSetup
        }
        else {
            $tool = $catalogTools | Where-Object { $_.id -eq $item } | Select-Object -First 1

            if ($tool) {
                Invoke-MemilToolInstall -ToolId $item
            } else {
                Write-MemilWarn "Unknown preset item: $item"
            }
        }
    }

    Write-MemilTitle "Preset setup finished"

    Write-Host "Preset:"
    Write-Host $selected.name
    Write-Host ""
    Write-Host "If something failed, run:"
    Write-Host "Start.bat -> 7. Create report for AI support"
    Write-Host ""

    Read-Host "Press Enter to continue"
}
