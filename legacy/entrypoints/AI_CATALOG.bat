@echo off
setlocal
cd /d "%~dp0"

:main
cls
echo ========================================
echo Mimel Lab AI / Tools Catalog
echo ========================================
echo Base mode: WinPython only
echo.
echo 1. YOLO / Ultralytics
echo 2. Whisper
echo 3. Hugging Face Transformers
echo 4. SAM / Segment Anything
echo 5. Diffusers
echo 6. Jupyter / JupyterLab
echo 7. Common Python packages
echo 8. FFmpeg
echo 9. Open projects folder
echo 10. Exit
echo.
set /p CHOICE=Select number: 

if "%CHOICE%"=="1" goto yolo
if "%CHOICE%"=="2" goto whisper
if "%CHOICE%"=="3" goto transformers
if "%CHOICE%"=="4" goto sam
if "%CHOICE%"=="5" goto diffusers
if "%CHOICE%"=="6" goto jupyter
if "%CHOICE%"=="7" goto commonpackages
if "%CHOICE%"=="8" goto ffmpeg
if "%CHOICE%"=="9" goto openprojects
if "%CHOICE%"=="10" exit /b 0

echo Invalid choice.
pause
goto main

:yolo
cls
echo ========================================
echo YOLO / Ultralytics
echo ========================================
echo 1. Install / Update
echo 2. Run sample
echo 3. Open project folder
echo 4. Back
echo.
set /p Y=Select number: 
if "%Y%"=="1" (powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\install-yolo.ps1" & pause & goto yolo)
if "%Y%"=="2" (
  if not exist ".\projects\yolo-sample\RUN_YOLO.bat" (echo YOLO is not installed yet. & pause & goto yolo)
  call ".\projects\yolo-sample\RUN_YOLO.bat"
  goto yolo
)
if "%Y%"=="3" (if not exist ".\projects\yolo-sample" mkdir ".\projects\yolo-sample" & start "" ".\projects\yolo-sample" & goto yolo)
if "%Y%"=="4" goto main
goto yolo

:whisper
cls
echo ========================================
echo Whisper
echo ========================================
echo 1. Install / Update
echo 2. Run sample
echo 3. Open project folder
echo 4. Back
echo.
set /p W=Select number: 
if "%W%"=="1" (powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\install-whisper.ps1" & pause & goto whisper)
if "%W%"=="2" (
  if not exist ".\projects\whisper-sample\RUN_WHISPER.bat" (echo Whisper is not installed yet. & pause & goto whisper)
  call ".\projects\whisper-sample\RUN_WHISPER.bat"
  goto whisper
)
if "%W%"=="3" (if not exist ".\projects\whisper-sample" mkdir ".\projects\whisper-sample" & start "" ".\projects\whisper-sample" & goto whisper)
if "%W%"=="4" goto main
goto whisper

:transformers
cls
echo ========================================
echo Hugging Face Transformers
echo ========================================
echo 1. Install / Update
echo 2. Run sample
echo 3. Open project folder
echo 4. Back
echo.
set /p T=Select number: 
if "%T%"=="1" (powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\install-transformers.ps1" & pause & goto transformers)
if "%T%"=="2" (
  if not exist ".\projects\transformers-sample\RUN_TRANSFORMERS.bat" (echo Transformers is not installed yet. & pause & goto transformers)
  call ".\projects\transformers-sample\RUN_TRANSFORMERS.bat"
  goto transformers
)
if "%T%"=="3" (if not exist ".\projects\transformers-sample" mkdir ".\projects\transformers-sample" & start "" ".\projects\transformers-sample" & goto transformers)
if "%T%"=="4" goto main
goto transformers

:sam
cls
echo ========================================
echo SAM / Segment Anything
echo ========================================
echo 1. Install / Update
echo 2. Run environment check
echo 3. Open project folder
echo 4. Back
echo.
set /p S=Select number: 
if "%S%"=="1" (powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\install-sam.ps1" & pause & goto sam)
if "%S%"=="2" (
  if not exist ".\projects\sam-sample\RUN_SAM.bat" (echo SAM is not installed yet. & pause & goto sam)
  call ".\projects\sam-sample\RUN_SAM.bat"
  goto sam
)
if "%S%"=="3" (if not exist ".\projects\sam-sample" mkdir ".\projects\sam-sample" & start "" ".\projects\sam-sample" & goto sam)
if "%S%"=="4" goto main
goto sam

:diffusers
cls
echo ========================================
echo Diffusers
echo ========================================
echo 1. Install / Update
echo 2. Run environment check
echo 3. Open project folder
echo 4. Back
echo.
set /p D=Select number: 
if "%D%"=="1" (powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\install-diffusers.ps1" & pause & goto diffusers)
if "%D%"=="2" (
  if not exist ".\projects\diffusers-sample\RUN_DIFFUSERS.bat" (echo Diffusers is not installed yet. & pause & goto diffusers)
  call ".\projects\diffusers-sample\RUN_DIFFUSERS.bat"
  goto diffusers
)
if "%D%"=="3" (if not exist ".\projects\diffusers-sample" mkdir ".\projects\diffusers-sample" & start "" ".\projects\diffusers-sample" & goto diffusers)
if "%D%"=="4" goto main
goto diffusers

:jupyter
cls
echo ========================================
echo Jupyter / JupyterLab
echo ========================================
echo 1. Install / Update
echo 2. Start JupyterLab
echo 3. Open notebooks folder
echo 4. Back
echo.
set /p J=Select number: 
if "%J%"=="1" (powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\install-jupyter.ps1" & pause & goto jupyter)
if "%J%"=="2" (
  if not exist ".\projects\jupyter-sample\START_JUPYTER.bat" (echo Jupyter is not installed yet. & pause & goto jupyter)
  call ".\projects\jupyter-sample\START_JUPYTER.bat"
  goto jupyter
)
if "%J%"=="3" (if not exist ".\projects\jupyter-sample\notebooks" mkdir ".\projects\jupyter-sample\notebooks" & start "" ".\projects\jupyter-sample\notebooks" & goto jupyter)
if "%J%"=="4" goto main
goto jupyter

:commonpackages
cls
echo ========================================
echo Common Python packages
echo ========================================
echo 1. Install / Update common packages
echo 2. Run package check
echo 3. Open project folder
echo 4. Back
echo.
set /p C=Select number: 
if "%C%"=="1" (powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\install-common-python.ps1" & pause & goto commonpackages)
if "%C%"=="2" (
  if not exist ".\projects\common-python-sample\RUN_COMMON_PYTHON.bat" (echo Common Python packages are not installed yet. & pause & goto commonpackages)
  call ".\projects\common-python-sample\RUN_COMMON_PYTHON.bat"
  goto commonpackages
)
if "%C%"=="3" (if not exist ".\projects\common-python-sample" mkdir ".\projects\common-python-sample" & start "" ".\projects\common-python-sample" & goto commonpackages)
if "%C%"=="4" goto main
goto commonpackages

:ffmpeg
cls
echo ========================================
echo FFmpeg
echo ========================================
echo 1. Check / Install FFmpeg with winget
echo 2. Check FFmpeg version
echo 3. Back
echo.
set /p F=Select number: 
if "%F%"=="1" (powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\install-ffmpeg.ps1" & pause & goto ffmpeg)
if "%F%"=="2" (ffmpeg -version & pause & goto ffmpeg)
if "%F%"=="3" goto main
goto ffmpeg

:openprojects
if not exist ".\projects" mkdir ".\projects"
start "" ".\projects"
goto main
