@echo off
setlocal
cd /d "%~dp0"
echo ========================================
echo Whisper installer
echo ========================================
echo This will install Whisper into projects\whisper-sample.
echo Note: ffmpeg is required to transcribe audio/video files.
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\install-whisper.ps1"
if errorlevel 1 (
  echo.
  echo [ERROR] Whisper installation failed.
  pause
  exit /b 1
)
echo.
echo Whisper installation completed.
echo See projects\whisper-sample\README_FIRST.txt.
pause
endlocal
