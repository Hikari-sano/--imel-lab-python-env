. (Join-Path (Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)) "tools\common-winpython.ps1")
$ProjectDir = Join-Path $Root "projects\diffusers-sample"
$PythonExe = New-ProjectVenv -ProjectDir $ProjectDir
Write-ProjectVscodeSettings -ProjectDir $ProjectDir
& $PythonExe -m pip install -U torch --index-url https://download.pytorch.org/whl/cpu
& $PythonExe -m pip install -U diffusers transformers accelerate safetensors pillow
Set-Content -Path (Join-Path $ProjectDir "main.py") -Encoding UTF8 -Value @('print("Diffusers environment is ready.")','print("GPU is recommended for large models.")')
Set-Content -Path (Join-Path $ProjectDir "RUN_DIFFUSERS.bat") -Encoding ASCII -Value @('@echo off','setlocal','cd /d "%~dp0"','".\.venv\Scripts\python.exe" "main.py"','pause','endlocal')
Write-Host "Diffusers environment is ready: $ProjectDir"
