$ErrorActionPreference = "Stop"

. "$PSScriptRoot\common-winpython.ps1"

$Root = Get-MemilRoot
Set-Location $Root

$LogDir = Join-Path $Root "logs"

if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir | Out-Null
}

$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$Today = Get-Date -Format "yyyy-MM-dd"
$InboxDir = Join-Path $Root "projects\_inbox\$Today"
$LogFile = Join-Path $LogDir "organize-workspace-$Timestamp.txt"

function Add-Log {
    param([string]$Text = "")

    Add-Content -Path $LogFile -Value $Text -Encoding UTF8
}

function Is-ProtectedRootItem {
    param([System.IO.FileSystemInfo]$Item)

    $protectedNames = @(
        ".git",
        ".github",
        ".vscode",
        "cache",
        "catalog",
        "docs",
        "legacy",
        "logs",
        "projects",
        "tools",
        "vscode",
        "winpython",
        ".gitignore",
        "README.md",
        "LICENSE",
        "Start.bat",
        "WINPYTHON_SETUP.bat",
        "SHARE_ENV_TO_AI.bat",
        "ORGANIZE_FILES.bat"
    )

    if ($protectedNames -contains $Item.Name) {
        return $true
    }

    if ($Item.Name.StartsWith(".")) {
        return $true
    }

    return $false
}

function Get-OrganizeTargets {
    $items = Get-ChildItem -Path $Root -Force -ErrorAction SilentlyContinue

    $targets = @()

    foreach ($item in $items) {
        if (Is-ProtectedRootItem -Item $item) {
            continue
        }

        if ($item.PSIsContainer) {
            continue
        }

        $targets += $item
    }

    return $targets
}

function Show-Targets {
    param($Targets)

    Write-MemilTitle "Workspace Organizer"

    Write-Host "This tool moves loose files in the repository root to:"
    Write-Host ""
    Write-Host "projects\_inbox\$Today"
    Write-Host ""
    Write-Host "It does not delete files."
    Write-Host ""

    if ($Targets.Count -eq 0) {
        Write-MemilOk "No loose root files found."
        return
    }

    Write-Host "Files to move:"
    Write-Host ""

    foreach ($target in $Targets) {
        Write-Host " - $($target.Name)"
    }

    Write-Host ""
}

"" | Set-Content -Path $LogFile -Encoding UTF8

Add-Log "MEMIL Workspace Organizer"
Add-Log "Created at: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Add-Log "Root: $Root"
Add-Log "Inbox: $InboxDir"
Add-Log ""

$targets = Get-OrganizeTargets

Show-Targets -Targets $targets

if ($targets.Count -eq 0) {
    Add-Log "No files to move."
    Write-Host ""
    Write-Host "Log file:"
    Write-Host $LogFile
    Write-Host ""
    exit 0
}

$answer = Read-Host "Move these files? [y/N]"

if ($answer -ne "y" -and $answer -ne "Y") {
    Write-MemilWarn "Canceled. No files were moved."
    Add-Log "Canceled by user. No files were moved."
    Write-Host ""
    Write-Host "Log file:"
    Write-Host $LogFile
    Write-Host ""
    exit 0
}

if (-not (Test-Path $InboxDir)) {
    New-Item -ItemType Directory -Path $InboxDir | Out-Null
}

Add-Log "Moved files:"
Add-Log ""

foreach ($target in $targets) {
    $destination = Join-Path $InboxDir $target.Name

    if (Test-Path $destination) {
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($target.Name)
        $extension = [System.IO.Path]::GetExtension($target.Name)
        $newName = "$baseName-$Timestamp$extension"
        $destination = Join-Path $InboxDir $newName
    }

    try {
        Move-Item -Path $target.FullName -Destination $destination -Force
        Write-MemilOk "Moved: $($target.Name)"
        Add-Log "$($target.FullName) -> $destination"
    } catch {
        Write-MemilWarn "Failed to move: $($target.Name)"
        Add-Log "[ERROR] $($target.FullName)"
        Add-Log $_.Exception.Message
    }
}

Write-MemilTitle "Organize complete"

Write-Host "Moved files to:"
Write-Host $InboxDir
Write-Host ""
Write-Host "Log file:"
Write-Host $LogFile
Write-Host ""

Add-Log ""
Add-Log "Done."
