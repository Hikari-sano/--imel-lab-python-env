# VS Code extensions auto install

`Start.bat` automatically runs:

```text
tools/install-vscode-extensions.ps1
```

This installs or checks the following extensions in the portable VS Code extension folder:

```text
ms-python.python
ms-python.vscode-pylance
ms-python.debugpy
ms-toolsai.jupyter
```

The extensions are installed into:

```text
vscode/data/extensions/
```

This helps the VS Code Run button appear when a Python file is opened.

If the installation fails, check the internet connection and run `Start.bat` again.
