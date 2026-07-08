# Automatic VS Code project opening and interpreter selection

This update makes each generated project easier to run with the VS Code Run button.

Each installer calls `Write-ProjectVscodeSettings`, which now creates:

```text
.vscode/settings.json
.vscode/launch.json
OPEN_IN_VSCODE.bat
```

The project settings point VS Code to:

```text
.venv/Scripts/python.exe
```

Recommended workflow:

```text
1. Install a tool from AI_CATALOG.bat
2. Open that project folder in VS Code
3. Open main.py
4. Press the Run button
```

If VS Code still uses the wrong Python, close VS Code and open the project using:

```text
projects/<project-name>/OPEN_IN_VSCODE.bat
```
