# MEMIL Python / AI Environment Catalog

Windows 向けのポータブル Python / VS Code / AI 開発環境カタログです。

Python 初心者、研究室配布、学生の AI 実験向けに、WinPython、VS Code、Jupyter、YOLO、Whisper、研究用 Python パッケージなどを `Start.bat` から簡単に導入・確認・整理できるようにしています。

基本的には、最初に覚えるファイルはこれだけです。

```text
Start.bat
```

---

## これは何ですか？

このリポジトリは、Windows 上で Python / VS Code / AI 開発環境をできるだけ簡単に使うための環境セットです。

特徴は以下です。

- `Start.bat` からすべて操作できます
- Conda は使いません
- uv は使いません
- 基本 Python は WinPython を使います
- AI やツールごとに専用の `.venv` を作ります
- YOLO、Jupyter、Whisper、Transformers などをカタログから選べます
- エラー時に AI へ相談しやすい環境レポートを作れます
- ルート直下のファイルを整理する機能があります

---

## はじめての人

まず、このファイルをダブルクリックしてください。

```text
Start.bat
```

メニューが表示されます。

```text
1. First setup
2. Recommended setup
3. AI / Tools catalog
4. Open VS Code
5. Open projects folder
6. Health check
7. Create report for AI support
8. Organize files
9. WinPython setup guide
0. Exit
```

番号は半角数字で入力してください。

例:

```text
2
```

---

## 最初にやること

### 1. WinPython を準備する

`Start.bat` を開いて、次を選びます。

```text
9. WinPython setup guide
```

WinPython の配置を確認できます。

期待する配置は以下です。

```text
memil-python-env/
└─ winpython/
   └─ WPy64-xxxx/
      └─ python/
         └─ python.exe
```

注意:

```text
Winpython64-xxxx.exe を winpython フォルダに置くだけでは使えません。
.exe を実行して展開する必要があります。
```

推奨ページ:

```text
https://sourceforge.net/projects/winpython/files/WinPython_3.12/3.12.10.1/
```

推奨ファイル:

```text
Winpython64-3.12.10.1dot.exe
```

または:

```text
Winpython64-3.12.10.1dot.zip
```

---

### 2. First setup を実行する

WinPython を展開したら、`Start.bat` を開いて次を選びます。

```text
1. First setup
```

これにより、基本フォルダや `hello-python` プロジェクトが準備されます。

---

### 3. Recommended setup または AI / Tools catalog を使う

研究・授業・実験でよく使う環境をまとめて準備したい場合は、次を選びます。

```text
2. Recommended setup
```

個別に AI ツールを選びたい場合は、次を選びます。

```text
3. AI / Tools catalog
```

---

## Start.bat のメニュー

### 1. First setup

基本環境を準備します。

主に以下を確認・作成します。

- 基本フォルダ
- WinPython の検出
- `projects/hello-python`
- `.venv`
- VS Code 用設定
- `OPEN_IN_VSCODE.bat`

---

### 2. Recommended setup

目的別のおすすめセットアップを選べます。

現在のプリセット:

```text
1. 最小セット
2. 研究室おすすめセット
3. 画像AIセット
4. 音声AIセット
```

プリセット情報は以下で管理しています。

```text
catalog/setup.json
```

---

### 3. AI / Tools catalog

AI や研究用ツールを目的から選べます。

例:

```text
研究・データ分析の基本パッケージを入れたい
ノートブックで実験したい
画像の中の物体を検出したい
音声を文字起こししたい
文章AI・自然言語処理を試したい
```

カタログ情報は以下で管理しています。

```text
catalog/index.json
```

---

### 4. Open VS Code

ポータブル VS Code を開きます。

期待する配置:

```text
vscode/
└─ Code.exe
```

---

### 5. Open projects folder

作業用フォルダを開きます。

```text
projects/
```

---

### 6. Health check

環境チェックを行います。

確認内容の例:

- 基本フォルダがあるか
- WinPython があるか
- VS Code があるか
- カタログファイルがあるか
- 各プロジェクトに `.venv` があるか
- `OPEN_IN_VSCODE.bat` があるか

ログは以下に保存されます。

```text
logs/
```

---

### 7. Create report for AI support

AI や研究室担当者に相談するための環境レポートを作ります。

出力先:

```text
logs/ai-support-report-YYYYMMDD-HHMMSS.txt
```

このレポートには、以下のような情報が含まれます。

- OS 情報
- PowerShell 情報
- フォルダ構成
- WinPython 検出結果
- VS Code 検出結果
- カタログ情報
- プロジェクト一覧
- `.venv` の有無
- pip パッケージ一覧
- Git 状態

エラーが出たときは、まずこのメニューを使ってください。

```text
Start.bat -> 7. Create report for AI support
```

---

### 8. Organize files

ルート直下に置かれた作業ファイルを整理します。

移動先:

```text
projects/_inbox/YYYY-MM-DD/
```

削除はしません。

整理ログは以下に保存されます。

```text
logs/
```

---

### 9. WinPython setup guide

WinPython の導入状況を確認します。

できること:

- WinPython が見つかるか確認
- `winpython/` フォルダを開く
- ダウンロードページを開く
- `.exe` や `.zip` が置かれているだけで未展開の場合に案内する

---

## AI / Tools catalog の内容

現在の主なカタログ項目です。

```text
Common Python packages
Jupyter / JupyterLab
YOLO / Ultralytics
Whisper
Hugging Face Transformers
```

それぞれのツールは、原則として専用の `.venv` に入ります。

例:

```text
projects/yolo-sample/.venv/
projects/jupyter-sample/.venv/
projects/common-python/.venv/
```

これにより、1つの環境が壊れても他の環境へ影響しにくくなります。

---

## Common Python packages

研究やデータ分析でよく使う基本パッケージです。

主な内容:

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

---

## VS Code の実行ボタンについて

VS Code の右上の実行ボタンを使うと、別の Python が選ばれてしまうことがあります。

その場合、次のようなエラーが出ることがあります。

```text
ModuleNotFoundError
```

各プロジェクトを VS Code で開くときは、プロジェクト内の以下を使うのが安全です。

```text
OPEN_IN_VSCODE.bat
```

例:

```text
projects/yolo-sample/OPEN_IN_VSCODE.bat
```

この方法で開くと、そのプロジェクト用の `.venv` が使われやすくなります。

---

## フォルダ構成

主な構成は以下です。

```text
memil-python-env/
├─ Start.bat
├─ README.md
├─ catalog/
│  ├─ index.json
│  ├─ setup.json
│  └─ installed.json
├─ tools/
│  ├─ common-winpython.ps1
│  ├─ first-setup.ps1
│  ├─ health-check.ps1
│  ├─ install-tool.ps1
│  ├─ organize-workspace.ps1
│  ├─ setup-preset.ps1
│  ├─ share-env-to-ai.ps1
│  ├─ show-catalog.ps1
│  └─ winpython-guide.ps1
├─ projects/
├─ winpython/
├─ vscode/
├─ logs/
├─ cache/
├─ docs/
└─ legacy/
```

---

## catalog について

`catalog/` には、カタログデータを置きます。

```text
catalog/index.json
```

AI / Tools catalog のツール一覧です。

```text
catalog/setup.json
```

Recommended setup のプリセット一覧です。

```text
catalog/installed.json
```

インストール済み状態を記録するためのファイルです。

---

## tools について

`tools/` には、実際の処理を行う PowerShell スクリプトを置きます。

主なファイル:

```text
tools/common-winpython.ps1
tools/first-setup.ps1
tools/show-catalog.ps1
tools/install-tool.ps1
tools/setup-preset.ps1
tools/health-check.ps1
tools/share-env-to-ai.ps1
tools/organize-workspace.ps1
tools/winpython-guide.ps1
```

---

## legacy について

`legacy/` には、v1 以前の古い入口ファイルやスクリプトを退避しています。

通常は使いません。

```text
legacy/entrypoints/
legacy/tools/
legacy/docs/
```

古い `.bat` はここにあります。

```text
legacy/entrypoints/AI_CATALOG.bat
legacy/entrypoints/ORGANIZE_FILES.bat
legacy/entrypoints/SHARE_ENV_TO_AI.bat
legacy/entrypoints/WINPYTHON_SETUP.bat
```

v2 では、基本的に `Start.bat` を使ってください。

---

## GitHub に上げないもの

以下は基本的に GitHub に上げません。

```text
winpython/
vscode/
projects/*/.venv/
logs/
cache/
python/
legacy/backup/python-old/
```

理由:

- ファイルサイズが大きい
- 環境依存
- 自動生成される
- 個人の環境情報を含む可能性がある

---

## よくあるトラブル

### Start.bat が PowerShell から実行できない

PowerShell では、現在のフォルダにあるファイルを実行するときに `.\` が必要です。

```powershell
.\Start.bat
```

---

### WinPython が見つからない

`Start.bat` を開いて、次を選んでください。

```text
9. WinPython setup guide
```

期待する配置:

```text
winpython/
└─ WPy64-xxxx/
   └─ python/
      └─ python.exe
```

---

### `.exe` を置いたのに認識されない

`.exe` を置くだけではまだ使えません。

```text
Winpython64-3.12.10.1dot.exe
```

を実行して展開してください。

---

### VS Code で ModuleNotFoundError が出る

VS Code が別の Python を使っている可能性があります。

プロジェクト内の以下から開いてください。

```text
OPEN_IN_VSCODE.bat
```

---

### エラーを AI に相談したい

次を実行してください。

```text
Start.bat -> 7. Create report for AI support
```

作成されたレポートを AI に貼り付けてください。

---

## 開発方針
*このリ*ジトリは、以下の方針で整理しています。

```text
WinPy*hon only
No Conda
No uv
One .*env per AI*tool project
Start.bat as the single entry point
catalog/*.json as catalog data
tools/*.ps1 as implementation
```

---

#* 現在のブランチ

v2*再設計は以下のブランチで進めています。

```text
*2-catalog-redesign
```

*--

## ライセンス

このリ*ジトリのライセンスは、リポジ*リ内のライセンスファイルを*認*てください。
