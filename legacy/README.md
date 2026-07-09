# legacy

This folder contains old entry points and installer scripts from the previous design.

The v2 design uses:

- Start.bat as the single entry point
- catalog/index.json as the AI / tools catalog database
- tools/show-catalog.ps1 as the catalog UI
- tools/install-tool.ps1 as the unified installer
- projects/<tool>/.venv as isolated Python environments

Files in this folder are kept for reference and migration.
They are not the main entry points for v2.
