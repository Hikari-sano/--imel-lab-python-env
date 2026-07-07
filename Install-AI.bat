@echo off
setlocal

:menu
cls
echo ========================================
echo Mimel Lab AI Catalog
echo ========================================
echo 1. Install YOLO / Ultralytics
echo 2. Install Whisper
echo 3. Install Hugging Face Transformers
echo 4. Install SAM / Segment Anything
echo 5. Install Diffusers
echo 6. Open projects folder
echo 7. Exit
echo.
echo Tip: Beginners can use YOLO_INSTALL.bat and YOLO_RUN.bat instead.
echo.
set /p CHOICE=Select number: 

if "%CHOICE%"=="1" (
  powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\install-yolo.ps1"
  pause
  goto menu
)

if "%CHOICE%"=="2" (
  powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\install-whisper.ps1"
  pause
  goto menu
)

if "%CHOICE%"=="3" (
  powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\install-transformers.ps1"
  pause
  goto menu
)

if "%CHOICE%"=="4" (
  powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\install-sam.ps1"
  pause
  goto menu
)

if "%CHOICE%"=="5" (
  powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\install-diffusers.ps1"
  pause
  goto menu
)

if "%CHOICE%"=="6" (
  if not exist ".\projects" mkdir ".\projects"
  start "" ".\projects"
  goto menu
)

if "%CHOICE%"=="7" (
  exit /b 0
)

echo Invalid choice.
pause
goto menu
