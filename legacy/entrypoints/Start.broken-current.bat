@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"

:main
cls
echo ========================================
echo  MEMIL Python / AI Environment Catalog
echo ========================================
echo.
echo この画面からすべて操作できます。
echo.
echo 1. はじめてのセットアップ
echo 2. おすすめセットアップ
echo 3. AI / Tools カタログ
echo 4. VS Code を開く
echo 5. projects フォルダを開く
echo 6. 環境チェック
echo 7. エラー相談用レポートを作る
echo 8. ファイルを整理する
echo 9. WinPython セットアップ案内
echo 10. 終了
echo.
set /p CHOICE=番号を入力してください: 

if "%CHOICE%"=="1" goto firstsetup
if "%CHOICE%"=="2" goto preset
if "%CHOICE%"=="3" goto catalog
if "%CHOICE%"=="4" goto vscode
if "%CHOICE%"=="5" goto projects
if "%CHOICE%"=="6" goto health
if "%CHOICE%"=="7" goto share
if "%CHOICE%"=="8" goto organize
if "%CHOICE%"=="9" goto winpython
if "%CHOICE%"=="10" exit /b 0

echo.
echo 無効な番号です。
pause
goto main

:firstsetup
if exist ".\tools\first-setup.ps1" (
    powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\first-setup.ps1"
) else (
    echo tools\first-setup.ps1 が見つかりません。
)
pause
goto main

:preset
echo.
echo おすすめセットアップは次の段階で実装します。
echo まずは「1. はじめてのセットアップ」または「3. AI / Tools カタログ」を使ってください。
echo.
pause
goto main

:catalog
if exist ".\tools\show-catalog.ps1" (
    powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\show-catalog.ps1"
) else if exist ".\AI_CATALOG.bat" (
    call ".\AI_CATALOG.bat"
) else (
    echo カタログを開くスクリプトが見つかりません。
)
pause
goto main

:vscode
if exist ".\vscode\Code.exe" (
    start "" ".\vscode\Code.exe" "."
) else (
    echo VS Code が見つかりません。
    echo 先に「1. はじめてのセットアップ」を実行してください。
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
    echo tools\health-check.ps1 が見つかりません。
)
pause
goto main

:share
if exist ".\tools\share-env-to-ai.ps1" (
    powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\share-env-to-ai.ps1"
) else if exist ".\SHARE_ENV_TO_AI.bat" (
    call ".\SHARE_ENV_TO_AI.bat"
) else (
    echo エラー相談用レポート作成スクリプトが見つかりません。
)
pause
goto main

:organize
if exist ".\tools\organize-workspace.ps1" (
    powershell -NoProfile -ExecutionPolicy Bypass -File ".\tools\organize-workspace.ps1"
) else if exist ".\ORGANIZE_FILES.bat" (
    call ".\ORGANIZE_FILES.bat"
) else (
    echo ファイル整理スクリプトが見つかりません。
)
pause
goto main

:winpython
if exist ".\WINPYTHON_SETUP.bat" (
    call ".\WINPYTHON_SETUP.bat"
) else (
    echo WinPython セットアップ案内
    echo.
    echo WinPython を以下のように配置してください。
    echo.
    echo memil-python-env\
    echo   winpython\
    echo     WPy64-xxxx\
    echo       python\
    echo         python.exe
    echo.
    echo 注意:
    echo Winpython64-3.12.10.1dot.exe を winpython フォルダに置くだけでは使えません。
    echo .exe を実行して展開してください。
    echo.
    echo 推奨ページ:
    echo https://sourceforge.net/projects/winpython/files/WinPython_3.12/3.12.10.1/
)
pause
goto main
