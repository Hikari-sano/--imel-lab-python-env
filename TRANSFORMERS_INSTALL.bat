@echo off
setlocal
cd /d "%~dp0"
echo ========================================
echo Transformers installer
echo ========================================
powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\install-transformers.ps1"
if errorlevel 1 (
  echo.
  echo [ERROR] Transformers installation failed.
  pause
  exit /b 1
)
echo.
echo Transformers installation completed.
pause
endlocal
