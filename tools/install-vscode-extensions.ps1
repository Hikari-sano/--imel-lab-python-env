$ErrorActionPreference = "Continue"

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$CodeCmd = Join-Path $Root "vscode\bin\code.cmd"
$CodeExe = Join-Path $Root "vscode\Code.exe"
$ExtensionsDir = Join-Path $Root "vscode\data\extensions"

function Ensure-Dir {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
    }
}

Ensure-Dir $ExtensionsDir

if (Test-Path $CodeCmd) {
    $CodeTool = $CodeCmd
} elseif (Test-Path $CodeExe) {
    $CodeTool = $CodeExe
} else {
    Write-Host "[NG] VS Code command was not found. Run Start.bat once to download VS Code."
    exit 1
}

$Extensions = @(
    "ms-python.python",
    "ms-python.vscode-pylance",
    "ms-python.debugpy",
    "ms-toolsai.jupyter"
)

Write-Host "Using VS Code tool: $CodeTool"
Write-Host "Extensions folder: $ExtensionsDir"

foreach ($ext in $Extensions) {
    Write-Host "Installing/checking extension: $ext"
    & $CodeTool --extensions-dir "$ExtensionsDir" --install-extension $ext --force
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[WARN] Failed to install extension: $ext"
    }
}

Write-Host "Installed extensions:"
& $CodeTool --extensions-dir "$ExtensionsDir" --list-extensions
Write-Host "VS Code extension setup completed."
exit 0
