@echo off
setlocal
cd /d "%~dp0"

:main
cls
echo ========================================
echo  MEMIL Python / AI Environment Catalog
echo ========================================
echo.
echo 1. First setup
echo 2. Recommended setup
echo 3. AI / Tools catalog
echo 4. Open VS Code
echo 5. Open projects folder
echo 6. Health check
echo 7. Create report for AI support
echo 8. Organize files
echo 9. WinPython setup guide
echo 0. Exit
echo.
set /p CHOICE=Select number: 

if "%CHOICE%"=="1" goto firstsetup
if "%CHOICE%"=="2" goto preset
if "%CHOICE%"=="3" goto catalog
if "%CHOICE%"=="4" goto vscode
if "%CHOICE%"=="5" goto projects
if "%CHOICE%"=="6" goto health
if "%CHOICE%"=="7" goto share
if "%CHOICE%"=="8" goto organize
if "%CHOICE%"=="9" goto winpython
if "%CHOICE%"=="0" exit /b 0

echo.
echo Invalid number.
pause
goto main

:firstsetup
if exist ".\tools\first-setup.ps1" (
    powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\first-setup.ps1"
) else (
    echo tools\first-setup.ps1 was not found.
)
pause
goto main

:preset
echo.
echo Recommended setup is not implemented yet.
echo Please use First setup or AI / Tools catalog for now.
echo.
pause
goto main

:catalog
if exist ".\tools\show-catalog.ps1" (
    powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\show-catalog.ps1"
) else (
    echo tools\show-catalog.ps1 was not found.
)
pause
goto main

:vscode
if exist ".\vscode\Code.exe" (
    start "" ".\vscode\Code.exe" "."
) else (
    echo VS Code was not found.
    echo Please prepare vscode\Code.exe.
)
pause
goto main

:projects
if not exist ".\projects" mkdir ".\projects"
start "" ".\projects"
goto main

:health
if exist ".\tools\health-check.ps1" (
    powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\health-check.ps1"
) else (
    echo tools\health-check.ps1 was not found.
)
pause
goto main

:share
if exist ".\tools\share-env-to-ai.ps1" (
    powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\share-env-to-ai.ps1"
) else (
    if exist ".\SHARE_ENV_TO_AI.bat" (
        call ".\SHARE_ENV_TO_AI.bat"
    ) else (
        echo AI support report script was not found.
    )
)
pause
goto main

:organize
if exist ".\tools\organize-workspace.ps1" (
    powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\organize-workspace.ps1"
) else (
    if exist ".\ORGANIZE_FILES.bat" (
        call ".\ORGANIZE_FILES.bat"
    ) else (
        echo Organize script was not found.
    )
)
pause
goto main

:winpython
cls
echo ========================================
echo  WinPython setup guide
echo ========================================
echo.
echo Expected layout:
echo.
echo memil-python-env
echo   winpython
echo     WPy64-xxxx
echo       python
echo         python.exe
echo.
echo Important:
echo Do not only put Winpython64-xxxx.exe under winpython.
echo You need to run or extract it first.
echo.
echo Recommended page:
echo https://sourceforge.net/projects/winpython/files/WinPython_3.12/3.12.10.1/
echo.
pause
goto main
