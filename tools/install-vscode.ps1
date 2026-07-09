$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot "common-winpython.ps1")

$Root = Get-MemilRoot

$VscodeDir = Join-Path $Root "vscode"
$CodeExe = Join-Path $VscodeDir "Code.exe"

$CacheDir = Join-Path $Root "cache\vscode"
$ZipPath = Join-Path $CacheDir "VSCode-win32-x64.zip"
$ExtractDir = Join-Path $CacheDir "extracted"

$Url = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-archive"

Write-MemilTitle "VS Code setup"

Ensure-MemilDirectory $VscodeDir
Ensure-MemilDirectory $CacheDir

if (Test-Path $CodeExe) {
    Write-MemilOk "VS Code already exists:"
    Write-Host $CodeExe

    $DataDir = Join-Path $VscodeDir "data"
    Ensure-MemilDirectory $DataDir

    return
}

Write-MemilWarn "VS Code was not found."
Write-Host "Downloading VS Code ZIP archive..."
Write-Host $Url
Write-Host ""

if (Test-Path $ZipPath) {
    Write-MemilOk "Using cached VS Code ZIP:"
    Write-Host $ZipPath
} else {
    Invoke-WebRequest -Uri $Url -OutFile $ZipPath
    Write-MemilOk "Downloaded VS Code ZIP:"
    Write-Host $ZipPath
}

if (Test-Path $ExtractDir) {
    Remove-Item $ExtractDir -Recurse -Force
}

Ensure-MemilDirectory $ExtractDir

Write-Host ""
Write-Host "Extracting VS Code..."
Expand-Archive -Path $ZipPath -DestinationPath $ExtractDir -Force

$FoundCodeExe = Get-ChildItem -Path $ExtractDir -Recurse -Filter "Code.exe" -File -ErrorAction SilentlyContinue |
    Select-Object -First 1

if ($null -eq $FoundCodeExe) {
    throw "Code.exe was not found after extracting VS Code ZIP."
}

$SourceDir = Split-Path $FoundCodeExe.FullName -Parent

Write-Host ""
Write-Host "Installing VS Code to:"
Write-Host $VscodeDir

Get-ChildItem -Path $SourceDir -Force | ForEach-Object {
    $Destination = Join-Path $VscodeDir $_.Name

    if (Test-Path $Destination) {
        Remove-Item $Destination -Recurse -Force
    }

    Copy-Item $_.FullName $Destination -Recurse -Force
}

$DataDir = Join-Path $VscodeDir "data"
Ensure-MemilDirectory $DataDir

if (-not (Test-Path $CodeExe)) {
    throw "VS Code setup failed. Code.exe was not created: $CodeExe"
}

Write-MemilOk "VS Code installed successfully:"
Write-Host $CodeExe

Write-MemilOk "VS Code portable data folder is ready:"
Write-Host $DataDir