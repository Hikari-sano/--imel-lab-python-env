@echo off
setlocal
cd /d "%~dp0"

:main
cls
echo ========================================
echo Mimel Lab AI Catalog
echo ========================================
echo Please select what you want to use.
echo.
echo 1. YOLO / Ultralytics
echo 2. Whisper
echo 3. Hugging Face Transformers
echo 4. SAM / Segment Anything
echo 5. Diffusers
echo 6. Open projects folder
echo 7. Exit
echo.
set /p CHOICE=Select number: 

if "%CHOICE%"=="1" goto yolo
if "%CHOICE%"=="2" goto whisper
if "%CHOICE%"=="3" goto transformers
if "%CHOICE%"=="4" goto sam
if "%CHOICE%"=="5" goto diffusers
if "%CHOICE%"=="6" goto openprojects
if "%CHOICE%"=="7" exit /b 0

echo Invalid choice.
pause
goto main

:yolo
cls
echo ========================================
echo YOLO / Ultralytics
echo ========================================
echo 1. Install / Update YOLO
echo 2. Run YOLO sample
echo 3. Open YOLO project folder
echo 4. Back
echo.
set /p Y=Select number: 
if "%Y%"=="1" (
  powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\install-yolo.ps1"
  pause
  goto yolo
)
if "%Y%"=="2" (
  if not exist ".\projects\yolo-sample\RUN_YOLO.bat" (
    echo YOLO is not installed yet.
    echo Please choose 1. Install / Update YOLO first.
    pause
    goto yolo
  )
  call ".\projects\yolo-sample\RUN_YOLO.bat"
  goto yolo
)
if "%Y%"=="3" (
  if not exist ".\projects\yolo-sample" mkdir ".\projects\yolo-sample"
  start "" ".\projects\yolo-sample"
  goto yolo
)
if "%Y%"=="4" goto main
goto yolo

:whisper
cls
echo ========================================
echo Whisper
echo ========================================
echo 1. Install / Update Whisper
echo 2. Run Whisper sample
echo 3. Open Whisper project folder
echo 4. Back
echo.
set /p W=Select number: 
if "%W%"=="1" (
  powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\install-whisper.ps1"
  pause
  goto whisper
)
if "%W%"=="2" (
  if not exist ".\projects\whisper-sample\RUN_WHISPER.bat" (
    echo Whisper is not installed yet.
    echo Please choose 1. Install / Update Whisper first.
    pause
    goto whisper
  )
  call ".\projects\whisper-sample\RUN_WHISPER.bat"
  goto whisper
)
if "%W%"=="3" (
  if not exist ".\projects\whisper-sample" mkdir ".\projects\whisper-sample"
  start "" ".\projects\whisper-sample"
  goto whisper
)
if "%W%"=="4" goto main
goto whisper

:transformers
cls
echo ========================================
echo Hugging Face Transformers
echo ========================================
echo 1. Install / Update Transformers
echo 2. Run Transformers sample
echo 3. Open Transformers project folder
echo 4. Back
echo.
set /p T=Select number: 
if "%T%"=="1" (
  powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\install-transformers.ps1"
  pause
  goto transformers
)
if "%T%"=="2" (
  if not exist ".\projects\transformers-sample\RUN_TRANSFORMERS.bat" (
    echo Transformers is not installed yet.
    echo Please choose 1. Install / Update Transformers first.
    pause
    goto transformers
  )
  call ".\projects\transformers-sample\RUN_TRANSFORMERS.bat"
  goto transformers
)
if "%T%"=="3" (
  if not exist ".\projects\transformers-sample" mkdir ".\projects\transformers-sample"
  start "" ".\projects\transformers-sample"
  goto transformers
)
if "%T%"=="4" goto main
goto transformers

:sam
cls
echo ========================================
echo SAM / Segment Anything
echo ========================================
echo 1. Install / Update SAM
echo 2. Run SAM environment check
echo 3. Open SAM project folder
echo 4. Back
echo.
set /p S=Select number: 
if "%S%"=="1" (
  powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\install-sam.ps1"
  pause
  goto sam
)
if "%S%"=="2" (
  if not exist ".\projects\sam-sample\RUN_SAM.bat" (
    echo SAM is not installed yet.
    echo Please choose 1. Install / Update SAM first.
    pause
    goto sam
  )
  call ".\projects\sam-sample\RUN_SAM.bat"
  goto sam
)
if "%S%"=="3" (
  if not exist ".\projects\sam-sample" mkdir ".\projects\sam-sample"
  start "" ".\projects\sam-sample"
  goto sam
)
if "%S%"=="4" goto main
goto sam

:diffusers
cls
echo ========================================
echo Diffusers
echo ========================================
echo 1. Install / Update Diffusers
echo 2. Run Diffusers environment check
echo 3. Open Diffusers project folder
echo 4. Back
echo.
set /p D=Select number: 
if "%D%"=="1" (
  powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\install-diffusers.ps1"
  pause
  goto diffusers
)
if "%D%"=="2" (
  if not exist ".\projects\diffusers-sample\RUN_DIFFUSERS.bat" (
    echo Diffusers is not installed yet.
    echo Please choose 1. Install / Update Diffusers first.
    pause
    goto diffusers
  )
  call ".\projects\diffusers-sample\RUN_DIFFUSERS.bat"
  goto diffusers
)
if "%D%"=="3" (
  if not exist ".\projects\diffusers-sample" mkdir ".\projects\diffusers-sample"
  start "" ".\projects\diffusers-sample"
  goto diffusers
)
if "%D%"=="4" goto main
goto diffusers

:openprojects
if not exist ".\projects" mkdir ".\projects"
start "" ".\projects"
goto main
