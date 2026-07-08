@echo off
setlocal
cd /d "%~dp0"
echo ========================================
echo Environment report for AI support
echo ========================================
echo This will create reports in env_reports.
echo It does NOT collect passwords, API keys, or file contents.
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\export-env-report.ps1"
if errorlevel 1 (
  echo.
  echo [ERROR] Failed to create environment report.
  pause
  exit /b 1
)
echo.
echo Report created. Opening env_reports folder...
if not exist ".\env_reports" mkdir ".\env_reports"
start "" ".\env_reports"
pause
endlocal
