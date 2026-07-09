. (Join-Path (Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)) "tools\common-winpython.ps1")
$ProjectDir = Join-Path $Root "projects\transformers-sample"
$PythonExe = New-ProjectVenv -ProjectDir $ProjectDir
Write-ProjectVscodeSettings -ProjectDir $ProjectDir
& $PythonExe -m pip install -U torch --index-url https://download.pytorch.org/whl/cpu
& $PythonExe -m pip install -U transformers accelerate sentencepiece
Set-Content -Path (Join-Path $ProjectDir "main.py") -Encoding UTF8 -Value @('from transformers import pipeline','classifier = pipeline("sentiment-analysis")','print(classifier("Transformers is ready."))')
Set-Content -Path (Join-Path $ProjectDir "RUN_TRANSFORMERS.bat") -Encoding ASCII -Value @('@echo off','setlocal','cd /d "%~dp0"','".\.venv\Scripts\python.exe" "main.py"','pause','endlocal')
Write-Host "Transformers environment is ready: $ProjectDir"
