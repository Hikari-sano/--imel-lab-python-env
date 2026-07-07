# MEMIL Python / AI Environment

**日本語** | [English](#english)

---

# 日本語

## これは何ですか？

このリポジトリは、Mimel Lab の研究・開発で使うための **Python / VS Code / AI 環境セット** です。

Python をまだよく知らない人でも、できるだけ迷わず使えるように、基本操作は `.bat` ファイルをダブルクリックする形にしています。

最初に覚えるファイルは、基本的にこの3つだけです。

```text
Start.bat
AI_CATALOG.bat
SHARE_ENV_TO_AI.bat
```

| ファイル | 何をするもの？ |
|---|---|
| `Start.bat` | はじめに1回実行します。VS Code、Python、uv、基本プロジェクトを準備します。 |
| `AI_CATALOG.bat` | YOLO、Whisper、Transformers、SAM、Diffusers などのAI機能を選んで導入・実行します。 |
| `SHARE_ENV_TO_AI.bat` | エラーが出たときに、環境情報とファイル構造をAIや担当者に共有するためのレポートを作ります。 |

---

## 最初にやること：超初心者向け手順

### 手順1：GitHubからダウンロードする

Gitが分からない人は、以下の方法で大丈夫です。

1. GitHubのリポジトリページを開きます。
2. 緑色の `Code` ボタンを押します。
3. `Download ZIP` を押します。
4. ダウンロードされたZIPファイルを右クリックします。
5. `すべて展開` を押します。
6. 展開されたフォルダを開きます。

展開後、次のようなファイルが見えればOKです。

```text
Start.bat
AI_CATALOG.bat
SHARE_ENV_TO_AI.bat
README.md
```

---

### 手順2：基本環境を作る

まず、以下をダブルクリックしてください。

```text
Start.bat
```

初回は自動で以下を準備します。

```text
vscode/
python/
cache/
projects/hello-python/
```

初回は数分かかることがあります。黒い画面が出ても、閉じずに待ってください。

成功すると、VS Code が開きます。

---

### 手順3：AIカタログを開く

次に、以下をダブルクリックします。

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
6. Open projects folder
7. Exit
```

数字を入力して `Enter` を押します。

---

## YOLOを試す：最初のおすすめ

最初は YOLO を試すのがおすすめです。

### YOLOとは？

YOLO は、画像の中にある人・車・物などを見つけるためのAIです。

---

### YOLOの導入手順

1. `AI_CATALOG.bat` をダブルクリックします。
2. メニューで `1` を入力します。

```text
1. YOLO / Ultralytics
```

3. 次の画面で `1` を入力します。

```text
1. Install / Update
```

4. インストールが始まります。
5. 初回は時間がかかります。黒い画面を閉じずに待ってください。

---

### YOLOの実行手順

インストールが終わったら、同じYOLOメニューで `2` を入力します。

```text
2. Run sample
```

成功すると、以下のファイルが作られます。

```text
projects/yolo-sample/yolo_result.jpg
```

この画像ができていれば、YOLO の導入と実行は成功です。

---

## VS Codeを使うときの注意

VS Code の右上にある再生ボタンを押すと、違うPythonで実行される場合があります。

初心者は、まず **VS Codeの再生ボタンではなく**、`AI_CATALOG.bat` の `Run sample` を使ってください。

慣れてきたら、各プロジェクト内の `.vscode/settings.json` や `.venv` を使って、VS Codeから直接実行できます。

---

## 他のAI機能

### Whisper

音声ファイルを文字起こしするAIです。

`AI_CATALOG.bat` で以下を選びます。

```text
2. Whisper
```

注意：音声処理には `ffmpeg` が必要になる場合があります。

---

### Hugging Face Transformers

文章分類、要約、LLM、埋め込み、自然言語処理などに使う基本ライブラリです。

`AI_CATALOG.bat` で以下を選びます。

```text
3. Hugging Face Transformers
```

---

### SAM / Segment Anything

画像の中の対象をマスク化するAIです。

`AI_CATALOG.bat` で以下を選びます。

```text
4. SAM / Segment Anything
```

注意：SAMではモデル重みファイルを `models/sam/` に置く必要があります。

---

### Diffusers

画像生成AIやStable Diffusion系の実験に使います。

`AI_CATALOG.bat` で以下を選びます。

```text
5. Diffusers
```

注意：画像生成AIはGPUがあるPCを推奨します。CPUのみだと非常に遅くなる場合があります。

---

## エラーが出たとき

エラーが出ても、黒い画面をすぐ閉じないでください。

次の手順を行ってください。

1. 黒い画面のエラー文をコピーします。
2. 以下をダブルクリックします。

```text
SHARE_ENV_TO_AI.bat
```

3. `env_reports/` フォルダが開きます。
4. 以下のファイルが作られます。

```text
AI_prompt_日時.txt
env_report_日時.txt
file_tree_日時.txt
```

5. `AI_prompt_日時.txt` を開きます。
6. 困っている内容を書き足します。
7. AIや担当者に共有します。

---

## AIに共有される情報

`SHARE_ENV_TO_AI.bat` は、以下のような情報をまとめます。

```text
OS情報
PowerShell情報
Gitの状態
VS Codeの状態
Python / uv の状態
各プロジェクトのパッケージ一覧
YOLOの導入確認
GPU確認
ファイル構造
```

ファイルの中身は収集しません。
ただし、ファイル名やフォルダ名は含まれるため、外部に共有する前に確認してください。

---

## GitHubに上げないもの

以下はPC上に自動生成されるものなので、GitHubには上げません。

```text
vscode/
python/
cache/
models/
env_reports/
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

## 旧環境を使っている人

### Gitで入れた人

PowerShellで環境フォルダを開き、以下を実行します。

```powershell
git pull
```

その後、以下を順番に実行します。

```text
Start.bat
AI_CATALOG.bat
```

---

### Download ZIPで入れた人

1. GitHubから最新版ZIPをもう一度ダウンロードします。
2. ZIPを展開します。
3. `Start.bat` を実行します。
4. `AI_CATALOG.bat` を実行します。

古い環境で作業したファイルを残したい場合は、古いフォルダの `projects/` を新しいフォルダへコピーしてください。

---

## よくある質問

### Pythonを自分でインストールする必要はありますか？

基本的には不要です。`Start.bat` が自動で準備します。

### VS Codeを自分でインストールする必要はありますか？

不要です。ZIP版VS Codeを自動で準備します。

### どのファイルを押せばいいですか？

最初はこの順番です。

```text
Start.bat
AI_CATALOG.bat
```

エラーが出たら：

```text
SHARE_ENV_TO_AI.bat
```

### YOLOだけ使いたい場合は？

```text
Start.bat
AI_CATALOG.bat
```

を実行し、`AI_CATALOG.bat` の中で YOLO を選んでください。

---

# English

## What is this?

This repository provides a **portable Python / VS Code / AI development environment** for Mimel Lab.

It is designed so that beginners can set up and use the environment mostly by double-clicking `.bat` files.

The main files are:

```text
Start.bat
AI_CATALOG.bat
SHARE_ENV_TO_AI.bat
```

| File | Purpose |
|---|---|
| `Start.bat` | Sets up VS Code, Python, uv, and the basic project. Run this first. |
| `AI_CATALOG.bat` | Opens the AI catalog. You can install and run YOLO, Whisper, Transformers, SAM, and Diffusers. |
| `SHARE_ENV_TO_AI.bat` | Creates environment and file-tree reports for troubleshooting with AI or lab support. |

---

## Beginner Setup Steps

### Step 1: Download from GitHub

If you do not know Git, use Download ZIP.

1. Open the GitHub repository page.
2. Click the green `Code` button.
3. Click `Download ZIP`.
4. Right-click the downloaded ZIP file.
5. Click `Extract All`.
6. Open the extracted folder.

You should see files like this:

```text
Start.bat
AI_CATALOG.bat
SHARE_ENV_TO_AI.bat
README.md
```

---

### Step 2: Set up the base environment

Double-click:

```text
Start.bat
```

On the first run, the following folders are created automatically:

```text
vscode/
python/
cache/
projects/hello-python/
```

The first run may take several minutes. Do not close the black console window while it is running.

---

### Step 3: Open the AI catalog

Double-click:

```text
AI_CATALOG.bat
```

A menu appears:

```text
1. YOLO / Ultralytics
2. Whisper
3. Hugging Face Transformers
4. SAM / Segment Anything
5. Diffusers
6. Open projects folder
7. Exit
```

Enter a number and press `Enter`.

---

## Recommended First Test: YOLO

YOLO is an AI tool for detecting objects in images.

### Install YOLO

1. Double-click `AI_CATALOG.bat`.
2. Enter `1` for YOLO.
3. Enter `1` for `Install / Update`.
4. Wait until installation completes.

### Run YOLO

After installation, choose:

```text
2. Run sample
```

If successful, this file is created:

```text
projects/yolo-sample/yolo_result.jpg
```

---

## VS Code Note

The Run button in VS Code may use the wrong Python environment.

Beginners should use `Run sample` from `AI_CATALOG.bat` first.

---

## Other AI Tools

### Whisper

Used for audio transcription.

Choose this in `AI_CATALOG.bat`:

```text
2. Whisper
```

Note: Whisper may require `ffmpeg`.

---

### Hugging Face Transformers

Used for NLP, LLMs, embeddings, text classification, and multimodal model experiments.

Choose this in `AI_CATALOG.bat`:

```text
3. Hugging Face Transformers
```

---

### SAM / Segment Anything

Used for image segmentation and mask generation.

Choose this in `AI_CATALOG.bat`:

```text
4. SAM / Segment Anything
```

Note: SAM checkpoint files should be placed under `models/sam/`.

---

### Diffusers

Used for image generation and Stable Diffusion style experiments.

Choose this in `AI_CATALOG.bat`:

```text
5. Diffusers
```

Note: A GPU is recommended. CPU-only execution may be very slow.

---

## When an Error Occurs

Do not close the black console window immediately.

1. Copy the error message.
2. Double-click:

```text
SHARE_ENV_TO_AI.bat
```

3. Open the `env_reports/` folder.
4. The following files are created:

```text
AI_prompt_timestamp.txt
env_report_timestamp.txt
file_tree_timestamp.txt
```

5. Write your issue in `AI_prompt_timestamp.txt`.
6. Share the files with AI or lab support.

---

## Information Shared with AI

`SHARE_ENV_TO_AI.bat` collects information such as:

```text
OS information
PowerShell information
Git status
VS Code status
Python / uv status
Package lists for each project
YOLO check
GPU check
File tree
```

File contents are not collected.
However, file and folder names are included. Review the files before sharing externally.

---

## Files Not Committed to GitHub

The following are generated locally and should not be uploaded to GitHub:

```text
vscode/
python/
cache/
models/
env_reports/
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

## Updating an Old Environment

### If you used Git

Open PowerShell in the environment folder and run:

```powershell
git pull
```

Then run:

```text
Start.bat
AI_CATALOG.bat
```

### If you used Download ZIP

1. Download the latest ZIP from GitHub.
2. Extract the ZIP.
3. Run `Start.bat`.
4. Run `AI_CATALOG.bat`.

If you want to keep your work, copy the old `projects/` folder into the new environment.
