. (Join-Path (Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)) "tools\common-winpython.ps1")
$ProjectDir = Join-Path $Root "projects\yolo-sample"
$PythonExe = New-ProjectVenv -ProjectDir $ProjectDir
Write-ProjectVscodeSettings -ProjectDir $ProjectDir
& $PythonExe -m pip install -U ultralytics
Set-Content -Path (Join-Path $ProjectDir "main.py") -Encoding UTF8 -Value @(
    'from ultralytics import YOLO',
    'model = YOLO("yolo11n.pt")',
    'results = model("https://ultralytics.com/images/bus.jpg")',
    'for result in results:',
    '    result.show()',
    '    result.save(filename="yolo_result.jpg")',
    'print("YOLO sample finished. Check yolo_result.jpg")'
)
Set-Content -Path (Join-Path $ProjectDir "RUN_YOLO.bat") -Encoding ASCII -Value @(
    '@echo off','setlocal','cd /d "%~dp0"','".\.venv\Scripts\python.exe" "main.py"','pause','endlocal'
)
Write-Host "YOLO environment is ready: $ProjectDir"
