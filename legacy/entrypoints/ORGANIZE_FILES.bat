@echo off
setlocal
cd /d "%~dp0"

echo ========================================
echo Memil file organizer
echo ========================================
echo This will organize loose files safely.
echo It will not delete files.
echo It will not move system folders such as tools, docs, projects, vscode, or winpython.
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\organize-workspace.ps1"
if errorlevel 1 (
  echo.
  echo [ERROR] File organization failed.
  echo Please check the messages above.
  pause
  exit /b 1
)
echo.
echo File organization completed.
echo Opening projects folder...
start "" ".\projects"
pause
endlocal
