. (Join-Path (Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)) "tools\common-winpython.ps1")
$ProjectDir = Join-Path $Root "projects\whisper-sample"
$PythonExe = New-ProjectVenv -ProjectDir $ProjectDir
Write-ProjectVscodeSettings -ProjectDir $ProjectDir
& $PythonExe -m pip install -U openai-whisper
Set-Content -Path (Join-Path $ProjectDir "main.py") -Encoding UTF8 -Value @(
    'import sys, whisper',
    'if len(sys.argv) < 2:',
    '    print("Usage: python main.py audio_file")',
    '    raise SystemExit(1)',
    'model = whisper.load_model("base")',
    'result = model.transcribe(sys.argv[1], language="ja")',
    'print(result["text"])'
)
Set-Content -Path (Join-Path $ProjectDir "RUN_WHISPER.bat") -Encoding ASCII -Value @(
    '@echo off','setlocal','cd /d "%~dp0"','set /p AUDIO=Audio file path: ','".\.venv\Scripts\python.exe" "main.py" "%AUDIO%"','pause','endlocal'
)
Write-Host "Whisper environment is ready: $ProjectDir"
