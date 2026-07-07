# Root cleanup guide

## Why

The root folder should not contain many model-specific shortcut files.
For beginners, it is clearer to keep one AI entry point:

```text
AI_CATALOG.bat
```

Then each AI tool has its own submenu inside the catalog.

## Recommended root files

```text
Start.bat
AI_CATALOG.bat
SHARE_ENV_TO_AI.bat
README.md
```

## Files to remove from the root

These are replaced by `AI_CATALOG.bat`:

```text
Install-AI.bat
YOLO_INSTALL.bat
YOLO_RUN.bat
WHISPER_INSTALL.bat
TRANSFORMERS_INSTALL.bat
```

The actual installation scripts remain under `tools/`:

```text
tools/install-yolo.ps1
tools/install-whisper.ps1
tools/install-transformers.ps1
tools/install-sam.ps1
tools/install-diffusers.ps1
```

## Git commands

```powershell
git add AI_CATALOG.bat docs/ROOT_CLEANUP_GUIDE.md
git rm Install-AI.bat YOLO_INSTALL.bat YOLO_RUN.bat WHISPER_INSTALL.bat TRANSFORMERS_INSTALL.bat
git commit -m "Simplify root AI entry point"
git push
```
