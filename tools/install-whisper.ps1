$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$UvExe = Join-Path $Root "python\uv\uv.exe"

function Ensure-Dir {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
    }
}

function Ensure-Uv {
    if (-not (Test-Path $UvExe)) {
        throw "uv.exe not found. Please run Start.bat first. Expected: $UvExe"
    }
}

function New-ProjectVenv {
    param(
        [string]$ProjectDir,
        [string]$PythonVersion = "3.12"
    )

    Ensure-Dir $ProjectDir
    $VenvDir = Join-Path $ProjectDir ".venv"
    $PythonExe = Join-Path $VenvDir "Scripts\python.exe"

    if (-not (Test-Path $PythonExe)) {
        Write-Host "Creating virtual environment: $VenvDir"
        & $UvExe venv "$VenvDir" --python $PythonVersion
    } else {
        Write-Host "Virtual environment already exists: $VenvDir"
    }

    return $PythonExe
}

function Write-ProjectVscodeSettings {
    param([string]$ProjectDir)
    $VsDir = Join-Path $ProjectDir ".vscode"
    Ensure-Dir $VsDir
    $SettingsPath = Join-Path $VsDir "settings.json"
    Set-Content -Path $SettingsPath -Encoding UTF8 -Value @(
        '{',
        '  "python.defaultInterpreterPath": "${workspaceFolder}\\.venv\\Scripts\\python.exe",',
        '  "python.terminal.activateEnvironment": true,',
        '  "python.analysis.extraPaths": [',
        '    "${workspaceFolder}\\.venv\\Lib\\site-packages"',
        '  ]',
        '}'
    )
}

Ensure-Uv

$ProjectDir = Join-Path $Root "projects\whisper-sample"
$PythonExe = New-ProjectVenv -ProjectDir $ProjectDir
Write-ProjectVscodeSettings -ProjectDir $ProjectDir

Write-Host "Installing Whisper..."
& $UvExe pip install --python "$PythonExe" -U openai-whisper

$MainPy = Join-Path $ProjectDir "main.py"
Set-Content -Path $MainPy -Encoding UTF8 -Value @(
    'import sys',
    'import whisper',
    '',
    'if len(sys.argv) < 2:',
    '    print("Usage: python main.py path_to_audio_file")',
    '    print("Example: python main.py sample.mp3")',
    '    raise SystemExit(1)',
    '',
    'audio_path = sys.argv[1]',
    'model = whisper.load_model("base")',
    'result = model.transcribe(audio_path, language="ja")',
    'print(result["text"])'
)

$RunBat = Join-Path $ProjectDir "RUN_WHISPER.bat"
Set-Content -Path $RunBat -Encoding ASCII -Value @(
    '@echo off',
    'setlocal',
    'cd /d "%~dp0"',
    'echo Drag and drop an audio file onto this window, then press Enter.',
    'set /p AUDIO=Audio file path: ',
    'if "%AUDIO%"=="" (',
    '  echo No file selected.',
    '  pause',
    '  exit /b 1',
    ')',
    '".\.venv\Scripts\python.exe" "main.py" "%AUDIO%"',
    'pause',
    'endlocal'
)

$ReadmeFirst = Join-Path $ProjectDir "README_FIRST.txt"
Set-Content -Path $ReadmeFirst -Encoding UTF8 -Value @(
    'Whisper sample - beginner guide',
    '',
    '1. Run RUN_WHISPER.bat.',
    '2. Drag and drop an audio file into the window.',
    '3. Press Enter.',
    '',
    'Note: ffmpeg is required. If it fails, ask the lab support person to install ffmpeg.'
)

Write-Host "Whisper project created: $ProjectDir"
Write-Host "Beginner run file: $RunBat"
Write-Host "Note: ffmpeg is required for audio/video decoding."
Write-Host "Done."
