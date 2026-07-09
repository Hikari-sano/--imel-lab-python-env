
# memil-python-env

**日本語** | [English](#english)

---

# 日本語

## これは何ですか？

`memil-python-env` は、Windows PCで研究・開発・AI実験を始めるための **ポータブル Python / VS Code / AI 開発環境** です。

Python、仮想環境、VS Code、AIライブラリの設定に詳しくない人でも使えるように、基本操作は `.bat` ファイルをダブルクリックする形にしています。

この環境の基本方針は次の通りです。

```text
WinPythonのみ + AI/ツールごとの専用 .venv
```

つまり、Python本体は `winpython/` に置いた WinPython を使い、YOLO、Whisper、Jupyter などはそれぞれ別々の `.venv` 環境に入れます。

この構成により、1つのAIライブラリの依存関係が壊れても、他のAI環境へ影響しにくくなります。

---

## 最初に覚えるファイル

初心者が主に使うファイルは、この5つです。

```text
WINPYTHON_SETUP.bat
Start.bat
AI_CATALOG.bat
ORGANIZE_FILES.bat
SHARE_ENV_TO_AI.bat
```

| ファイル | 役割 |
|---|---|
| `WINPYTHON_SETUP.bat` | WinPythonのダウンロードページを開き、配置確認をします。 |
| `Start.bat` | VS Code、基本Pythonプロジェクト、VS Code拡張機能を準備します。 |
| `AI_CATALOG.bat` | YOLO、Whisper、Transformers、SAM、Diffusers、Jupyter、numpy、FFmpegなどを導入・実行します。 |
| `ORGANIZE_FILES.bat` | 散らかったファイルを安全に整理します。削除はしません。 |
| `SHARE_ENV_TO_AI.bat` | エラー時に、AIや担当者へ共有する環境レポートとファイル構造レポートを作ります。 |

---

## 初心者向け：一番かんたんな導入手順

### 1. GitHubからZIPをダウンロードする

Gitが分からない人は、GitHubの `Download ZIP` を使ってください。

1. GitHubのリポジトリページを開きます。
2. 緑色の `Code` ボタンを押します。
3. `Download ZIP` を押します。
4. ダウンロードしたZIPを右クリックします。
5. `すべて展開` を押します。
6. 展開されたフォルダを開きます。

展開後、次のようなファイルが見えればOKです。

```text
WINPYTHON_SETUP.bat
Start.bat
AI_CATALOG.bat
ORGANIZE_FILES.bat
SHARE_ENV_TO_AI.bat
README.md
```

---

## 2. WinPythonを準備する

この環境では、通常のPythonインストーラー、Conda、uvは使いません。
Python本体として WinPython を使います。

まず、次をダブルクリックしてください。

```text
WINPYTHON_SETUP.bat
```

メニューが表示されます。

```text
1. Open recommended WinPython download page
2. Open winpython folder
3. Check WinPython placement
4. Exit
```

### 2-1. 推奨WinPythonページを開く

`1` を選ぶと、推奨するWinPythonのダウンロードページが開きます。

```text
https://sourceforge.net/projects/winpython/files/WinPython_3.12/3.12.10.1/
```

このページで、初心者は次のどちらかを選んでください。

```text
Winpython64-3.12.10.1dot.exe
```

または、ZIPで展開したい場合は：

```text
Winpython64-3.12.10.1dot.zip
```

迷った場合は、まず `Winpython64-3.12.10.1dot.exe` を選んでください。

### 2-2. WinPythonを `winpython/` に展開する

WinPythonを展開するときは、この環境フォルダ内の `winpython/` に入れてください。

正しい配置例：

```text
memil-python-env/
└─ winpython/
   └─ WPy64-3.12.10.1/
      └─ python/
         └─ python.exe
```

フォルダ名は多少違っていても大丈夫です。
重要なのは、最終的に次の形になっていることです。

```text
winpython\...\python\python.exe
```

間違った例：

```text
winpython/
└─ Winpython64-3.12.10.1dot.exe
```

これはまだ展開されていない状態です。
`exe` を置いただけでは使えません。

間違った例：

```text
winpython/
└─ Downloads/
   └─ WPy64-xxxx/
      └─ python/
         └─ python.exe
```

このように余計なフォルダが入ると、検出できない場合があります。

### 2-3. WinPythonの配置を確認する

WinPythonを展開したら、もう一度 `WINPYTHON_SETUP.bat` を開いて、`3` を選びます。

```text
3. Check WinPython placement
```

成功すると、次のような表示になります。

```text
[OK] WinPython found: ...\winpython\...\python\python.exe
Python 3.12.x
WinPython check completed.
```

---

## 3. 基本環境を起動する

WinPythonの確認が終わったら、次をダブルクリックします。

```text
Start.bat
```

`Start.bat` は次のことを行います。

```text
1. WinPythonを確認する
2. VS Code ZIP版を準備する
3. VS Code拡張機能を自動インストールする
4. projects/hello-python を作る
5. hello-python 用の .venv を作る
6. VS Codeを開く
```

初回はダウンロードや拡張機能の導入があるため、数分かかることがあります。
黒い画面が出ても、途中で閉じないでください。

---

## 4. VS Codeの実行ボタンについて

`Start.bat` は、VS CodeのPython開発に必要な拡張機能を自動で入れるようにしています。

自動で入れる主な拡張機能：

```text
ms-python.python
ms-python.vscode-pylance
ms-python.debugpy
ms-toolsai.jupyter
```

Pythonファイルを開いたときに、VS Code右上に実行ボタン `▶` が表示されやすくなります。

ただし、VS Codeは複数のPython環境があると、間違ったPythonを選ぶことがあります。
そのため、この環境では **各プロジェクトごとに VS Code 設定を自動生成**します。

各プロジェクトには、以下が作られます。

```text
.vscode/settings.json
.vscode/launch.json
OPEN_IN_VSCODE.bat
```

実行ボタンを使いたい場合は、各プロジェクト内の `OPEN_IN_VSCODE.bat` から開くのがおすすめです。

例：YOLOの場合

```text
projects/yolo-sample/OPEN_IN_VSCODE.bat
```

---

## 5. AIカタログを使う

AIや研究用ツールを使う場合は、次をダブルクリックします。

```text
AI_CATALOG.bat
```

メニューが表示されます。

```text
1. YOLO / Ultralytics
2. Whisper
3. Hugging Face Transformers
4. SAM / Segment Anything
5. Diffusers
6. Jupyter / JupyterLab
7. Common Python packages
8. FFmpeg
9. Open projects folder
10. Exit
```

---

## 6. YOLOを試す

最初の動作確認には YOLO がおすすめです。

### YOLOを導入する

1. `AI_CATALOG.bat` を開きます。
2. `1. YOLO / Ultralytics` を選びます。
3. `1. Install / Update` を選びます。
4. インストールが終わるまで待ちます。

YOLO用の環境は次に作られます。

```text
projects/yolo-sample/
```

### YOLOを実行する

一番簡単な方法：

```text
projects/yolo-sample/RUN_YOLO.bat
```

VS Codeの実行ボタンを使いたい場合：

```text
projects/yolo-sample/OPEN_IN_VSCODE.bat
```

を開いて、`main.py` を表示し、右上の `▶` を押します。

成功すると、次の画像が作られます。

```text
projects/yolo-sample/yolo_result.jpg
```

---

## 7. Jupyterを使う

JupyterLabを使う場合は、`AI_CATALOG.bat` で以下を選びます。

```text
6. Jupyter / JupyterLab
```

導入：

```text
1. Install / Update
```

起動：

```text
2. Start JupyterLab
```

ノートブック用フォルダ：

```text
projects/jupyter-sample/notebooks/
```

---

## 8. numpyなどの基本パッケージを入れる

`numpy`、`pandas`、`matplotlib` などをまとめて入れたい場合は、`AI_CATALOG.bat` で以下を選びます。

```text
7. Common Python packages
```

導入される主なパッケージ：

```text
numpy
pandas
matplotlib
scipy
scikit-learn
pillow
opencv-python
jupyter
ipykernel
openpyxl
tqdm
seaborn
```

導入後は、次のフォルダが使えます。

```text
projects/common-python-sample/
```

---

## 9. WhisperとFFmpeg

Whisperは音声ファイルの文字起こしに使います。

```text
2. Whisper
```

音声や動画を扱う場合、FFmpegが必要になることがあります。
FFmpegは `AI_CATALOG.bat` から導入できます。

```text
8. FFmpeg
```

---

## 10. ファイル整理をする

ファイル整理が苦手な人は、次をダブルクリックしてください。

```text
ORGANIZE_FILES.bat
```

このファイルは、研究用フォルダを自動で作り、ルート直下に置かれたファイルを安全に整理します。
ファイルは削除しません。

作られる主なフォルダ：

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

ルート直下に置かれたCSV、画像、PDF、ノートブック、音声ファイルなどは、以下に移動されます。

```text
projects/_inbox/YYYY-MM-DD/
```

重要な環境フォルダやスクリプトは動かしません。

---

## 11. エラーが出たとき

エラーが出ても、黒い画面をすぐ閉じないでください。

次をダブルクリックします。

```text
SHARE_ENV_TO_AI.bat
```

すると、次のフォルダにレポートが作られます。

```text
env_reports/
```

作られるファイル：

```text
AI_prompt_日時.txt
env_report_日時.txt
file_tree_日時.txt
```

AIや担当者に相談するときは、まず `AI_prompt_日時.txt` を開き、困っている内容を書き足してください。
必要に応じて、`env_report_日時.txt` と `file_tree_日時.txt` も共有してください。

注意：

```text
APIキー、パスワード、研究データの中身は共有しないでください。
```

---

## 12. GitHubに上げないもの

以下はPC上で自動生成されるものなので、GitHubには上げません。

```text
winpython/
vscode/
python/
cache/
models/
env_reports/
logs/
projects/*/.venv/
projects/**/runs/
*.pt
*.pth
*.onnx
*.safetensors
*.ckpt
*.bin
```

---

## 13. よくある質問

### Condaは使っていますか？

使っていません。

```text
Conda: 使わない
uv: 使わない
WinPython: 使う
```

### 普通のPythonをPCにインストールする必要はありますか？

必要ありません。
WinPythonを `winpython/` に展開して使います。

### VS Codeの実行ボタンが違うPythonを使います

対象プロジェクトの `OPEN_IN_VSCODE.bat` から開いてください。

例：

```text
projects/yolo-sample/OPEN_IN_VSCODE.bat
```

### YOLOで `ModuleNotFoundError: No module named 'ultralytics'` が出ます

別のPythonで実行している可能性が高いです。
YOLOの場合、正しいPythonは次です。

```text
projects/yolo-sample/.venv/Scripts/python.exe
```

簡単に実行する場合は、これを使ってください。

```text
projects/yolo-sample/RUN_YOLO.bat
```

---

# English

## What is this?

`memil-python-env` is a portable Python / VS Code / AI development environment for Windows.

It is designed so that beginners can set up and use Python, VS Code, and AI tools mostly by double-clicking `.bat` files.

This environment uses:

```text
WinPython only + one .venv per AI/tool project
```

It does not use Conda or uv.

---

## Main entry files

```text
WINPYTHON_SETUP.bat
Start.bat
AI_CATALOG.bat
ORGANIZE_FILES.bat
SHARE_ENV_TO_AI.bat
```

| File | Purpose |
|---|---|
| `WINPYTHON_SETUP.bat` | Opens the recommended WinPython download page and checks placement. |
| `Start.bat` | Sets up VS Code, basic Python project, and VS Code extensions. |
| `AI_CATALOG.bat` | Installs and runs YOLO, Whisper, Jupyter, numpy, FFmpeg, and other tools. |
| `ORGANIZE_FILES.bat` | Safely organizes loose files. It does not delete files. |
| `SHARE_ENV_TO_AI.bat` | Creates environment and file tree reports for troubleshooting. |

---

## Beginner setup

### 1. Download this repository

If you do not know Git, use GitHub `Download ZIP`.

### 2. Set up WinPython

Double-click:

```text
WINPYTHON_SETUP.bat
```

Choose:

```text
1. Open recommended WinPython download page
```

Recommended page:

```text
https://sourceforge.net/projects/winpython/files/WinPython_3.12/3.12.10.1/
```

Recommended file:

```text
Winpython64-3.12.10.1dot.exe
```

ZIP version is also OK:

```text
Winpython64-3.12.10.1dot.zip
```

Expected layout:

```text
memil-python-env/
└─ winpython/
   └─ WPy64-xxxx/
      └─ python/
         └─ python.exe
```

After extraction, run `WINPYTHON_SETUP.bat` again and choose:

```text
3. Check WinPython placement
```

### 3. Start the environment

Double-click:

```text
Start.bat
```

This checks WinPython, prepares VS Code, installs VS Code extensions, creates `projects/hello-python`, and opens VS Code.

### 4. Open the AI catalog

Double-click:

```text
AI_CATALOG.bat
```

Menu:

```text
1. YOLO / Ultralytics
2. Whisper
3. Hugging Face Transformers
4. SAM / Segment Anything
5. Diffusers
6. Jupyter / JupyterLab
7. Common Python packages
8. FFmpeg
9. Open projects folder
10. Exit
```

---

## Run button in VS Code

Each generated project includes:

```text
.vscode/settings.json
.vscode/launch.json
OPEN_IN_VSCODE.bat
```

To use the VS Code Run button safely, open the project using:

```text
projects/<project-name>/OPEN_IN_VSCODE.bat
```

Example:

```text
projects/yolo-sample/OPEN_IN_VSCODE.bat
```

---

## Recommended first test: YOLO

1. Open `AI_CATALOG.bat`.
2. Select `1. YOLO / Ultralytics`.
3. Select `1. Install / Update`.
4. Wait until installation completes.
5. Select `2. Run sample` or run:

```text
projects/yolo-sample/RUN_YOLO.bat
```

If successful, this file is created:

```text
projects/yolo-sample/yolo_result.jpg
```

---

## File organization

If files become messy, double-click:

```text
ORGANIZE_FILES.bat
```

Loose user files in the root folder are moved into:

```text
projects/_inbox/YYYY-MM-DD/
```

No files are deleted.

---

## Troubleshooting

If an error occurs, double-click:

```text
SHARE_ENV_TO_AI.bat
```

It creates:

```text
AI_prompt_timestamp.txt
env_report_timestamp.txt
file_tree_timestamp.txt
```

Share these files with AI or a support person if needed.

---

## Files not committed to GitHub

```text
winpython/
vscode/
python/
cache/
models/
env_reports/
logs/
projects/*/.venv/
projects/**/runs/
*.pt
*.pth
*.onnx
*.safetensors
*.ckpt
*.bin
```
