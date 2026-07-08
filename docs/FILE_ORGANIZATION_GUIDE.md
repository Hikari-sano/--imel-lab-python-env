# File organization guide

## Goal

This project is designed so that even beginners can keep files organized naturally.

The main helper is:

```text
ORGANIZE_FILES.bat
```

## What it does

`ORGANIZE_FILES.bat` safely prepares a research-friendly folder layout.

It creates:

```text
projects/
├─ _inbox/
├─ _shared/
│  ├─ data/
│  │  ├─ raw/
│  │  └─ processed/
│  ├─ outputs/
│  ├─ notebooks/
│  ├─ scripts/
│  ├─ docs/
│  ├─ figures/
│  ├─ tables/
│  ├─ audio/
│  ├─ video/
│  └─ images/
└─ _archive/
```

For each project folder, it also prepares:

```text
data/raw/
data/processed/
outputs/
notebooks/
scripts/
docs/
README_PROJECT.md
```

## What it moves

Loose user files placed in the repository root are moved into:

```text
projects/_inbox/YYYY-MM-DD/
```

Examples:

```text
sample.csv
memo.txt
image.png
notebook.ipynb
recording.wav
```

## What it does not move

It does not move important environment folders or scripts such as:

```text
tools/
docs/
projects/
vscode/
winpython/
Start.bat
AI_CATALOG.bat
SHARE_ENV_TO_AI.bat
WINPYTHON_SETUP.bat
```

It also does not delete files.

## Recommended beginner rule

If you do not know where to put a file, put it anywhere and then double-click:

```text
ORGANIZE_FILES.bat
```

The file will be moved into the dated inbox when it is safe to move.
