\# V2 Test Checklist



This checklist is for testing the v2 catalog launcher workflow.



Branch:



```text

v2-catalog-redesign

```



Main entry point:



```text

Start.bat

```



\---



\## 1. Basic launcher



\- \[ ] `Start.bat` opens without errors

\- \[ ] The main menu is displayed

\- \[ ] `0. Exit` closes the launcher



Expected menu:



```text

1\. First setup

2\. Recommended setup

3\. AI / Tools catalog

4\. Open VS Code

5\. Open projects folder

6\. Health check

7\. Create report for AI support

8\. Organize files

9\. WinPython setup guide

0\. Exit

```



\---



\## 2. WinPython setup guide



Open:



```text

Start.bat -> 9. WinPython setup guide

```



Check:



\- \[ ] WinPython setup guide opens

\- \[ ] If WinPython is not installed, a clear warning is shown

\- \[ ] Expected layout is shown

\- \[ ] Download page option is shown

\- \[ ] winpython folder option is shown

\- \[ ] Check again option is shown



Expected layout:



```text

memil-python-env

&#x20; winpython

&#x20;   WPy64-xxxx

&#x20;     python

&#x20;       python.exe

```



Important behavior:



\- \[ ] `.exe` placed under `winpython/` without extraction is not treated as installed

\- \[ ] User is told to run or extract the WinPython installer



\---



\## 3. Health check



Open:



```text

Start.bat -> 6. Health check

```



Check:



\- \[ ] Health check starts

\- \[ ] Basic folders are checked

\- \[ ] WinPython detection result is shown

\- \[ ] VS Code detection result is shown

\- \[ ] Catalog files are checked

\- \[ ] Project folders are checked

\- \[ ] A log file is generated under `logs/`



Expected log pattern:



```text

logs/health-check-YYYYMMDD-HHMMSS.txt

```



\---



\## 4. AI / Tools catalog



Open:



```text

Start.bat -> 3. AI / Tools catalog

```



Check:



\- \[ ] Catalog menu opens

\- \[ ] Items from `catalog/index.json` are displayed

\- \[ ] Recommended items are marked

\- \[ ] Selecting `0. Back` returns safely



Expected examples:



```text

Common Python packages

Jupyter / JupyterLab

YOLO / Ultralytics

Whisper

Hugging Face Transformers

```



If WinPython is not installed:



\- \[ ] Install / Update shows WinPython guidance instead of crashing



\---



\## 5. Recommended setup



Open:



```text

Start.bat -> 2. Recommended setup

```



Check:



\- \[ ] Recommended setup menu opens

\- \[ ] Presets from `catalog/setup.json` are displayed

\- \[ ] Selecting `0. Back` returns safely

\- \[ ] Starting a preset checks WinPython first



Expected presets:



```text

1\. 最小セット

2\. 研究室おすすめセット

3\. 画像AIセット

4\. 音声AIセット

```



If WinPython is not installed:



\- \[ ] The setup stops safely

\- \[ ] WinPython setup guide is suggested



\---



\## 6. AI support report



Open:



```text

Start.bat -> 7. Create report for AI support

```



Check:



\- \[ ] Report is created

\- \[ ] Report is saved under `logs/`

\- \[ ] Report opens in Notepad

\- \[ ] Report includes environment information

\- \[ ] Report includes WinPython detection result

\- \[ ] Report includes VS Code detection result

\- \[ ] Report includes catalog files

\- \[ ] Report includes project summary

\- \[ ] Report includes Git status



Expected report pattern:



```text

logs/ai-support-report-YYYYMMDD-HHMMSS.txt

```



\---



\## 7. Workspace organizer



Open:



```text

Start.bat -> 8. Organize files

```



Check:



\- \[ ] Organizer opens

\- \[ ] Loose files in the repository root are listed

\- \[ ] Protected folders are not moved

\- \[ ] User confirmation is required before moving files

\- \[ ] Files are moved to `projects/\_inbox/YYYY-MM-DD/`

\- \[ ] No files are deleted

\- \[ ] Log file is created under `logs/`



Protected items should not be moved:



```text

.git

.github

.vscode

cache

catalog

docs

legacy

logs

projects

tools

vscode

winpython

README.md

Start.bat

.gitignore

```



\---



\## 8. First setup



Open:



```text

Start.bat -> 1. First setup

```



Check when WinPython is not installed:



\- \[ ] Setup stops safely

\- \[ ] WinPython guidance is shown

\- \[ ] No broken `.venv` is created



Check after WinPython is installed:



\- \[ ] `projects/hello-python/` is created

\- \[ ] `projects/hello-python/.venv/` is created

\- \[ ] `.vscode/settings.json` is created

\- \[ ] `.vscode/launch.json` is created

\- \[ ] `OPEN\_IN\_VSCODE.bat` is created

\- \[ ] `NEXT\_STEP.txt` is created



\---



\## 9. VS Code



Open:



```text

Start.bat -> 4. Open VS Code

```



Check:



\- \[ ] If `vscode/Code.exe` exists, VS Code opens

\- \[ ] If it does not exist, a clear warning is shown



Expected layout:



```text

vscode

&#x20; Code.exe

```



\---



\## 10. Legacy files



Check that old entry points are no longer in the repository root.



Root should mainly contain:



```text

Start.bat

README.md

```



Old entry points should be under:



```text

legacy/entrypoints/

```



Expected examples:



```text

legacy/entrypoints/AI\_CATALOG.bat

legacy/entrypoints/ORGANIZE\_FILES.bat

legacy/entrypoints/SHARE\_ENV\_TO\_AI.bat

legacy/entrypoints/WINPYTHON\_SETUP.bat

```



\---



\## 11. GitHub safety



Before committing, run:



```powershell

git status

```



Check:



\- \[ ] No `.venv` folders are staged

\- \[ ] No `winpython/` contents are staged

\- \[ ] No `vscode/` binaries are staged

\- \[ ] No large `.exe` files are staged

\- \[ ] No personal logs containing sensitive information are staged



\---



\## 12. Final check before pull request



Run:



```powershell

git status

```



Expected result:



```text

nothing to commit, working tree clean

```



Recommended final checks:



\- \[ ] README matches v2 workflow

\- \[ ] `Start.bat` is the main entry point

\- \[ ] `catalog/index.json` is valid JSON

\- \[ ] `catalog/setup.json` is valid JSON

\- \[ ] Main menu works

\- \[ ] Health check works

\- \[ ] AI support report works

\- \[ ] WinPython guide works

\- \[ ] Recommended setup menu works

\- \[ ] AI / Tools catalog menu works



\---



\## Notes



The v2 design is based on:



```text

WinPython only

No Conda

No uv

Start.bat as the single entry point

catalog/\*.json as catalog data

tools/\*.ps1 as implementation

One .venv per AI/tool project

```

