@echo off
setlocal
cd /d "%~dp0"

:menu
cls
echo ========================================
echo WinPython setup helper
echo ========================================
echo This environment recommends:
echo.
echo   WinPython 3.12.10.1
 echo   Winpython64-3.12.10.1dot.exe
 echo.
echo Download page:
echo   https://sourceforge.net/projects/winpython/files/WinPython_3.12/3.12.10.1/
echo.
echo Expected layout after extraction:
echo   winpython\WPy64-xxxx\python\python.exe
echo.
echo 1. Open recommended WinPython download page
echo 2. Open winpython folder
echo 3. Check WinPython placement
echo 4. Exit
echo.
if not exist ".\winpython" mkdir ".\winpython"
set /p CHOICE=Select number: 

if "%CHOICE%"=="1" (
  start "" "https://sourceforge.net/projects/winpython/files/WinPython_3.12/3.12.10.1/"
  echo.
  echo Please download:
  echo   Winpython64-3.12.10.1dot.exe
  echo or:
  echo   Winpython64-3.12.10.1dot.zip
  echo.
  echo After extracting it into the winpython folder, come back and choose 3.
  pause
  goto menu
)

if "%CHOICE%"=="2" (
  start "" ".\winpython"
  goto menu
)

if "%CHOICE%"=="3" (
  powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\check-winpython.ps1"
  if errorlevel 1 (
    echo.
    echo [NG] WinPython was not detected.
    echo.
    echo Please check the folder layout:
    echo   winpython\WPy64-xxxx\python\python.exe
    echo.
    echo If you are unsure, choose 1 to open the download page,
    echo then download Winpython64-3.12.10.1dot.exe.
    echo.
    pause
    goto menu
  )
  echo.
  echo [OK] WinPython was detected successfully.
  echo Next step: run Start.bat
  pause
  goto menu
)

if "%CHOICE%"=="4" exit /b 0

echo Invalid choice.
pause
goto menu
