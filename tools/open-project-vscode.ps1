param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectPath
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$CodeExe = Join-Path $Root "vscode\Code.exe"
$CodeCmd = Join-Path $Root "vscode\bin\code.cmd"
$ExtensionsDir = Join-Path $Root "vscode\data\extensions"
$FullProjectPath = Resolve-Path (Join-Path $Root $ProjectPath) -ErrorAction SilentlyContinue

if (-not $FullProjectPath) {
    New-Item -ItemType Directory -Path (Join-Path $Root $ProjectPath) | Out-Null
    $FullProjectPath = Resolve-Path (Join-Path $Root $ProjectPath)
}

if (Test-Path $CodeCmd) {
    & $CodeCmd --extensions-dir "$ExtensionsDir" "$FullProjectPath"
} elseif (Test-Path $CodeExe) {
    & $CodeExe --extensions-dir "$ExtensionsDir" "$FullProjectPath"
} else {
    Write-Host "VS Code was not found. Please run Start.bat first."
    exit 1
}
