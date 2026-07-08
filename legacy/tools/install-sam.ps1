. (Join-Path (Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)) "tools\common-winpython.ps1")
$ProjectDir = Join-Path $Root "projects\sam-sample"
Ensure-Dir (Join-Path $Root "models\sam")
$PythonExe = New-ProjectVenv -ProjectDir $ProjectDir
Write-ProjectVscodeSettings -ProjectDir $ProjectDir
& $PythonExe -m pip install -U torch torchvision --index-url https://download.pytorch.org/whl/cpu
& $PythonExe -m pip install -U opencv-python matplotlib
& $PythonExe -m pip install git+https://github.com/facebookresearch/segment-anything.git
Set-Content -Path (Join-Path $ProjectDir "main.py") -Encoding UTF8 -Value @('print("SAM environment is ready.")','print("Put checkpoint files in ../../models/sam/")')
Set-Content -Path (Join-Path $ProjectDir "RUN_SAM.bat") -Encoding ASCII -Value @('@echo off','setlocal','cd /d "%~dp0"','".\.venv\Scripts\python.exe" "main.py"','pause','endlocal')
Write-Host "SAM environment is ready: $ProjectDir"
