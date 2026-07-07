$ErrorActionPreference = "Continue"

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$ReportDir = Join-Path $Root "env_reports"
if (-not (Test-Path $ReportDir)) {
    New-Item -ItemType Directory -Path $ReportDir | Out-Null
}

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$ReportPath = Join-Path $ReportDir "env_report_$Stamp.txt"
$TreePath = Join-Path $ReportDir "file_tree_$Stamp.txt"
$PromptPath = Join-Path $ReportDir "AI_prompt_$Stamp.txt"

$ExcludeDirs = @(
    ".git",
    "vscode",
    "python",
    "cache",
    "env_reports",
    "node_modules",
    "__pycache__",
    ".mypy_cache",
    ".pytest_cache",
    ".ruff_cache",
    ".venv",
    "runs"
)

$ExcludeExtensions = @(
    ".pt", ".pth", ".onnx", ".safetensors", ".ckpt", ".bin",
    ".jpg", ".jpeg", ".png", ".gif", ".webp",
    ".mp4", ".avi", ".mov", ".mkv",
    ".wav", ".mp3", ".flac",
    ".zip", ".7z", ".rar"
)

function Safe-Text {
    param([string]$Text)
    if ($null -eq $Text) { return "" }
    $safe = $Text
    if ($env:USERPROFILE) {
        $escaped = [Regex]::Escape($env:USERPROFILE)
        $safe = [Regex]::Replace($safe, $escaped, "%USERPROFILE%", "IgnoreCase")
    }
    if ($env:USERNAME) {
        $escapedUser = [Regex]::Escape($env:USERNAME)
        $safe = [Regex]::Replace($safe, $escapedUser, "%USERNAME%", "IgnoreCase")
    }
    return $safe
}

function Add-Line {
    param([string]$Text = "")
    Add-Content -Path $ReportPath -Encoding UTF8 -Value (Safe-Text $Text)
}

function Add-TreeLine {
    param([string]$Text = "")
    Add-Content -Path $TreePath -Encoding UTF8 -Value (Safe-Text $Text)
}

function Add-Section {
    param([string]$Title)
    Add-Line ""
    Add-Line "============================================================"
    Add-Line $Title
    Add-Line "============================================================"
}

function Run-Cmd {
    param(
        [string]$Title,
        [string]$Command
    )
    Add-Section $Title
    Add-Line "> $Command"
    try {
        $out = cmd /c $Command 2>&1 | Out-String
        Add-Line $out
    } catch {
        Add-Line "ERROR: $($_.Exception.Message)"
    }
}

function Run-PS {
    param(
        [string]$Title,
        [scriptblock]$Block
    )
    Add-Section $Title
    try {
        $out = & $Block 2>&1 | Out-String
        Add-Line $out
    } catch {
        Add-Line "ERROR: $($_.Exception.Message)"
    }
}

function Test-SkipDirName {
    param([string]$Name)
    foreach ($d in $ExcludeDirs) {
        if ($Name -ieq $d) { return $true }
    }
    return $false
}

function Test-SkipFile {
    param([System.IO.FileInfo]$File)
    foreach ($ext in $ExcludeExtensions) {
        if ($File.Extension -ieq $ext) { return $true }
    }
    return $false
}

function Write-Tree {
    param(
        [string]$Path,
        [string]$Prefix = "",
        [int]$Depth = 0,
        [int]$MaxDepth = 8
    )

    if ($Depth -gt $MaxDepth) {
        Add-TreeLine ($Prefix + "... max depth omitted")
        return
    }

    $children = Get-ChildItem -LiteralPath $Path -Force -ErrorAction SilentlyContinue | Where-Object {
        if ($_.PSIsContainer) {
            -not (Test-SkipDirName $_.Name)
        } else {
            -not (Test-SkipFile $_)
        }
    } | Sort-Object @{Expression='PSIsContainer';Descending=$true}, Name

    foreach ($child in $children) {
        $label = $child.Name
        if ($child.PSIsContainer) {
            Add-TreeLine ($Prefix + "[D] " + $label + "/")
            Write-Tree -Path $child.FullName -Prefix ($Prefix + "    ") -Depth ($Depth + 1) -MaxDepth $MaxDepth
        } else {
            $size = $child.Length
            Add-TreeLine ($Prefix + "[F] " + $label + "  (" + $size + " bytes)")
        }
    }
}

# File tree report
Set-Content -Path $TreePath -Encoding UTF8 -Value "Mimel Lab File Tree"
Add-TreeLine "Created: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Add-TreeLine "Root: $Root"
Add-TreeLine ""
Add-TreeLine "Excluded folders: $($ExcludeDirs -join ', ')"
Add-TreeLine "Excluded extensions: $($ExcludeExtensions -join ', ')"
Add-TreeLine "Note: File contents are NOT included. Large model/media files are omitted."
Add-TreeLine ""
Write-Tree -Path $Root -Prefix "" -Depth 0 -MaxDepth 8

# Main report
Set-Content -Path $ReportPath -Encoding UTF8 -Value "Mimel Lab Environment Report"
Add-Line "Created: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Add-Line "Root: $Root"
Add-Line "File tree report: $TreePath"
Add-Line "Note: USERPROFILE and USERNAME are masked where possible."
Add-Line "Do not paste API keys, passwords, tokens, or private research data."
Add-Line "File contents are not collected. File tree excludes large model/media/runtime folders."

Add-Section "Quick Summary"
Add-Line "If you ask AI for help, paste the AI_prompt file first."
Add-Line "Then attach or paste env_report and file_tree if needed."

Run-PS "OS / PowerShell" {
    "OS: $([System.Environment]::OSVersion.VersionString)"
    "64-bit OS: $([System.Environment]::Is64BitOperatingSystem)"
    "PowerShell: $($PSVersionTable.PSVersion)"
    "Current directory: $(Get-Location)"
}

Run-Cmd "Git" "git --version && git status --short && git remote -v && git log --oneline -5"

Run-PS "Important Files" {
    $files = @(
        "Start.bat",
        "Install-AI.bat",
        "YOLO_INSTALL.bat",
        "YOLO_RUN.bat",
        "SHARE_ENV_TO_AI.bat",
        "tools\bootstrap.ps1",
        "tools\install-yolo.ps1",
        "tools\export-env-report.ps1",
        "catalog\ai-catalog.json",
        ".gitignore"
    )
    foreach ($f in $files) {
        $p = Join-Path $Root $f
        if (Test-Path $p) {
            $item = Get-Item $p
            "OK: $f  Size=$($item.Length)  Modified=$($item.LastWriteTime)"
        } else {
            "MISSING: $f"
        }
    }
}

Run-PS "Root Folder Layout" {
    Get-ChildItem -Path $Root -Force | Where-Object { -not (Test-SkipDirName $_.Name) } | Select-Object Mode, LastWriteTime, Length, Name | Format-Table -AutoSize
}

Run-PS "Projects" {
    $ProjectsDir = Join-Path $Root "projects"
    if (Test-Path $ProjectsDir) {
        Get-ChildItem -Path $ProjectsDir -Force | Select-Object Mode, LastWriteTime, Length, Name | Format-Table -AutoSize
    } else {
        "projects folder not found"
    }
}

Run-PS "File Tree Preview" {
    Get-Content -Path $TreePath -TotalCount 250
}

Run-PS "VS Code" {
    $CodeExe = Join-Path $Root "vscode\Code.exe"
    $CodeCmd = Join-Path $Root "vscode\bin\code.cmd"
    if (Test-Path $CodeExe) {
        "Code.exe: $CodeExe"
        & $CodeExe --version
    } else {
        "Code.exe not found"
    }
    if (Test-Path $CodeCmd) {
        "Installed extensions:"
        & $CodeCmd --list-extensions --show-versions
    } else {
        "code.cmd not found"
    }
}

Run-PS "uv / Python" {
    $LocalUvExe = Join-Path $Root "python\uv\uv.exe"
    if (Test-Path $LocalUvExe) {
        "uv.exe: $LocalUvExe"
        & $LocalUvExe --version
        "uv python list:"
        & $LocalUvExe python list
    } else {
        "uv.exe not found"
    }
}

Run-PS "Project Python Environments" {
    $ProjectsDir = Join-Path $Root "projects"
    if (Test-Path $ProjectsDir) {
        Get-ChildItem -Path $ProjectsDir -Directory | ForEach-Object {
            $proj = $_.FullName
            $py = Join-Path $proj ".venv\Scripts\python.exe"
            "--- Project: $($_.Name) ---"
            if (Test-Path $py) {
                "Python: $py"
                & $py --version
                "Packages:"
                & $py -m pip list
            } else {
                "No .venv Python found"
            }
            ""
        }
    } else {
        "projects folder not found"
    }
}

Run-PS "YOLO Check" {
    $py = Join-Path $Root "projects\yolo-sample\.venv\Scripts\python.exe"
    if (Test-Path $py) {
        & $py -c "import sys; print(sys.executable); import ultralytics; print('ultralytics', ultralytics.__version__)"
        $result = Join-Path $Root "projects\yolo-sample\yolo_result.jpg"
        if (Test-Path $result) {
            "YOLO result image exists: $result"
        } else {
            "YOLO result image not found yet."
        }
    } else {
        "YOLO venv not found. Run YOLO_INSTALL.bat first."
    }
}

Run-PS "GPU / NVIDIA" {
    $cmd = Get-Command nvidia-smi -ErrorAction SilentlyContinue
    if ($cmd) {
        nvidia-smi
    } else {
        "nvidia-smi not found. NVIDIA GPU driver may not be installed, or this PC may not have NVIDIA GPU."
    }
}

Run-PS "Disk Space" {
    Get-PSDrive -PSProvider FileSystem | Select-Object Name, Root, Used, Free | Format-Table -AutoSize
}

$PromptLines = @(
    "以下は Mimel Lab Python / AI 環境のトラブル相談です。",
    "私はPythonやVS Codeの環境に詳しくない可能性があります。",
    "下の環境レポートとファイル構造を前提に、原因と解決手順を初心者向けに説明してください。",
    "",
    "相談したい内容:",
    "- ここに困っていることを書いてください。",
    "- 例: YOLO_RUN.bat でエラーが出る / Start.bat が止まる / VS Codeで実行できない",
    "",
    "共有するファイル:",
    "1. $ReportPath",
    "2. $TreePath",
    "",
    "注意:",
    "- APIキー、パスワード、研究データの中身は貼りません。",
    "- ファイル構造にはファイル名やフォルダ名が含まれます。共有前に確認してください。",
    "- USERPROFILE と USERNAME は可能な範囲でマスクされています。"
)
Set-Content -Path $PromptPath -Encoding UTF8 -Value ($PromptLines | ForEach-Object { Safe-Text $_ })

Write-Host "Report created: $ReportPath"
Write-Host "File tree created: $TreePath"
Write-Host "Prompt created: $PromptPath"
try {
    Set-Clipboard -Value (Get-Content $PromptPath -Raw)
    Write-Host "AI prompt was copied to clipboard."
} catch {
    Write-Host "Clipboard copy skipped."
}
