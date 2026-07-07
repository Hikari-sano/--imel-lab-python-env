@echo off
setlocal
cd /d "%~dp0"
echo ========================================
echo YOLO installer
echo ========================================
echo This will install YOLO into projects\yolo-sample.
echo Initial setup can take several minutes.
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\install-yolo.ps1"
if errorlevel 1 (
  echo.
  echo [ERROR] YOLO installation failed.
  echo Please show this window to the lab support person.
  pause
  exit /b 1
)
echo.
echo YOLO installation completed.
echo Next, run YOLO_RUN.bat.
pause
endlocal
