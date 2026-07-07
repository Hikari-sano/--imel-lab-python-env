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

Ensure-Uv

$ProjectDir = Join-Path $Root "projects\whisper-sample"
$PythonExe = New-ProjectVenv -ProjectDir $ProjectDir

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

$Readme = Join-Path $ProjectDir "README.md"
Set-Content -Path $Readme -Encoding UTF8 -Value @(
    '# Whisper sample',
    '',
    'Whisper requires ffmpeg. If transcription fails, install ffmpeg first.',
    '',
    'Run:',
    '',
    '```powershell',
    '.\.venv\Scripts\python.exe main.py sample.mp3',
    '```'
)

Write-Host "Whisper project created: $ProjectDir"
Write-Host "Note: ffmpeg is required for audio/video decoding."
Write-Host "Done."
