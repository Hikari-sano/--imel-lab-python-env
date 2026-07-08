$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$WinPythonDir = Join-Path $Root "winpython"
if (-not (Test-Path $WinPythonDir)) { New-Item -ItemType Directory -Path $WinPythonDir | Out-Null }
Write-Host "WinPython setup helper"
Write-Host "Recommended download page:"
Write-Host "https://sourceforge.net/projects/winpython/files/WinPython_3.12/3.12.10.1/"
Write-Host ""
Write-Host "Recommended file:"
Write-Host "Winpython64-3.12.10.1dot.exe"
Write-Host "or"
Write-Host "Winpython64-3.12.10.1dot.zip"
Write-Host ""
Write-Host "Extract into: $WinPythonDir"
Write-Host "Expected layout: winpython\\WPy64-xxxx\\python\\python.exe"
Start-Process "https://sourceforge.net/projects/winpython/files/WinPython_3.12/3.12.10.1/"
Start-Process $WinPythonDir
