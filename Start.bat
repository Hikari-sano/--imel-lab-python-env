@echo off
setlocal
cd /d "%~dp0"

echo ========================================
echo Mimel Lab Python / AI Environment
echo ========================================
echo Base mode: WinPython only
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\bootstrap.ps1"
if errorlevel 1 (
  echo.
  echo [ERROR] Setup failed.
  echo Please check the messages above.
  pause
  exit /b 1
)

echo.
echo Installing / checking VS Code extensions...
powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\install-vscode-extensions.ps1"
if errorlevel 1 (
  echo.
  echo [WARN] VS Code extension setup failed.
  echo You can still use BAT files, but the VS Code Run button may not appear.
  echo Please check your internet connection and try Start.bat again later.
  pause
)

if exist ".\vscode\Code.exe" (
  start "" ".\vscode\Code.exe" ".\projects"
) else (
  echo VS Code was not found. Please check setup messages.
  pause
  exit /b 1
)

endlocal
