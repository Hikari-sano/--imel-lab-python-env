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

while ($true) {
    Clear-Host
    Write-MemilTitle "AI / Tools Catalog"

    Write-Host "What do you want to do?"
    Write-Host ""

    for ($i = 0; $i -lt $tools.Count; $i++) {
        $n = $i + 1
        $tool = $tools[$i]
        $mark = ""

        if ($tool.recommended) {
            $mark = " [recommended]"
        }

        Write-Host "$n. $($tool.purpose)$mark"
        Write-Host "   -> $($tool.name)"
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

    if ($index -lt 1 -or $index -gt $tools.Count) {
        Write-Host "Invalid number."
        Read-Host "Press Enter to continue"
        continue
    }

    $selected = $tools[$index - 1]

    Clear-Host
    Write-MemilTitle $selected.name

    Write-Host "Purpose:"
    Write-Host $selected.purpose
    Write-Host ""
    Write-Host "Description:"
    Write-Host $selected.description
    Write-Host ""
    Write-Host "Project:"
    Write-Host $selected.projectDir
    Write-Host ""

    Write-Host "1. Install / Update"
    Write-Host "2. Open project folder"
    Write-Host "3. Back"
    Write-Host ""

    $action = Read-Host "Select number"

    if ($action -eq "1") {
        & powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\install-tool.ps1" -ToolId $selected.id
        Read-Host "Press Enter to continue"
    } elseif ($action -eq "2") {
        $projectPath = Join-Path $Root $selected.projectDir

        if (-not (Test-Path $projectPath)) {
            New-Item -ItemType Directory -Path $projectPath | Out-Null
        }

        Start-Process $projectPath
    }
}
