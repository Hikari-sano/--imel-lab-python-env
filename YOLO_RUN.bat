@echo off
setlocal
cd /d "%~dp0"
if not exist ".\projects\yolo-sample\RUN_YOLO.bat" (
  echo YOLO is not installed yet.
  echo Please run YOLO_INSTALL.bat first.
  pause
  exit /b 1
)
call ".\projects\yolo-sample\RUN_YOLO.bat"
endlocal
