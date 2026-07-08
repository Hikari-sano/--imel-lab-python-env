$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$ProjectsDir = Join-Path $Root "projects"
$InboxDir = Join-Path $ProjectsDir "_inbox"
$SharedDir = Join-Path $ProjectsDir "_shared"
$DateStamp = Get-Date -Format "yyyy-MM-dd"
$TodayInbox = Join-Path $InboxDir $DateStamp
$LogDir = Join-Path $Root "logs"
$LogPath = Join-Path $LogDir ("organize_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".txt")

function Ensure-Dir {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
    }
}

function Write-Log {
    param([string]$Message)
    Write-Host $Message
    Add-Content -Path $LogPath -Encoding UTF8 -Value $Message
}

Ensure-Dir $ProjectsDir
Ensure-Dir $InboxDir
Ensure-Dir $TodayInbox
Ensure-Dir $SharedDir
Ensure-Dir $LogDir

# Common research workspace folders
$folders = @(
    "_shared\data\raw",
    "_shared\data\processed",
    "_shared\outputs",
    "_shared\notebooks",
    "_shared\scripts",
    "_shared\docs",
    "_shared\figures",
    "_shared\tables",
    "_shared\audio",
    "_shared\video",
    "_shared\images",
    "_archive",
    "_inbox"
)
foreach ($f in $folders) {
    Ensure-Dir (Join-Path $ProjectsDir $f)
}

Set-Content -Path $LogPath -Encoding UTF8 -Value "Memil file organization log"
Write-Log "Root: $Root"
Write-Log "Inbox: $TodayInbox"
Write-Log ""

# Files/folders that should stay in the repository root
$ProtectedNames = @(
    ".git",
    ".github",
    ".vscode",
    "catalog",
    "docs",
    "projects",
    "tools",
    "vscode",
    "winpython",
    "python",
    "cache",
    "models",
    "env_reports",
    "logs",
    "README.md",
    "README_WINPYTHON_MIGRATION.md",
    "README_FIRST_JA.txt",
    "README_WINPYTHON_SETUP_SNIPPET.md",
    "requirements-lab.txt",
    ".gitignore",
    "Start.bat",
    "AI_CATALOG.bat",
    "SHARE_ENV_TO_AI.bat",
    "WINPYTHON_SETUP.bat",
    "ORGANIZE_FILES.bat"
)

# Extensions likely created or downloaded by users. These are safe to move from root to inbox.
$MovableExtensions = @(
    ".csv", ".tsv", ".xlsx", ".xls", ".json", ".yaml", ".yml",
    ".txt", ".md", ".pdf", ".docx", ".pptx",
    ".ipynb", ".py", ".R", ".r",
    ".jpg", ".jpeg", ".png", ".gif", ".webp", ".tif", ".tiff",
    ".mp4", ".avi", ".mov", ".mkv",
    ".wav", ".mp3", ".flac",
    ".zip", ".7z", ".rar"
)

# Move loose files in repository root into dated inbox.
$rootItems = Get-ChildItem -Path $Root -Force -File -ErrorAction SilentlyContinue
foreach ($item in $rootItems) {
    if ($ProtectedNames -contains $item.Name) { continue }
    if ($item.Name -like "*.bat" -or $item.Name -like "*.ps1") { continue }
    if ($MovableExtensions -notcontains $item.Extension) { continue }

    $dest = Join-Path $TodayInbox $item.Name
    $base = [System.IO.Path]::GetFileNameWithoutExtension($item.Name)
    $ext = $item.Extension
    $i = 1
    while (Test-Path $dest) {
        $dest = Join-Path $TodayInbox ("$base-$i$ext")
        $i++
    }
    Move-Item -LiteralPath $item.FullName -Destination $dest
    Write-Log "Moved root file: $($item.Name) -> projects\_inbox\$DateStamp"
}

# Prepare standard folders inside each user/AI project but do not move files inside projects automatically.
$projectDirs = Get-ChildItem -Path $ProjectsDir -Directory -ErrorAction SilentlyContinue | Where-Object {
    $_.Name -notin @("_inbox", "_shared", "_archive")
}
foreach ($proj in $projectDirs) {
    $standard = @("data", "data\raw", "data\processed", "outputs", "notebooks", "scripts", "docs")
    foreach ($s in $standard) {
        Ensure-Dir (Join-Path $proj.FullName $s)
    }
    $readme = Join-Path $proj.FullName "README_PROJECT.md"
    if (-not (Test-Path $readme)) {
        Set-Content -Path $readme -Encoding UTF8 -Value @(
            "# $($proj.Name)",
            "",
            "Suggested folder layout:",
            "",
            "```text",
            "data/raw/        original input data",
            "data/processed/  cleaned or converted data",
            "outputs/         generated results",
            "notebooks/       Jupyter notebooks",
            "scripts/         Python scripts",
            "docs/            notes and documentation",
            "```"
        )
        Write-Log "Created project guide: projects\$($proj.Name)\README_PROJECT.md"
    }
}

Write-Log ""
Write-Log "Organization completed."
Write-Log "Log file: $LogPath"
