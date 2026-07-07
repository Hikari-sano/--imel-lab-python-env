# Mimel Lab AI Catalog

`Install-AI.bat` から、AIモデル・AIライブラリを選択して導入できます。

## 使い方

1. 先に `Start.bat` を実行して、基本環境を構築します。
2. `Install-AI.bat` を実行します。
3. メニューから導入したい項目を選びます。

## 現在の項目

- YOLO / Ultralytics
- Whisper
- Hugging Face Transformers
- SAM / Segment Anything
- Diffusers

## 注意

- AI系パッケージは容量が大きく、初回インストールに時間がかかります。
- Whisperは音声処理のためにffmpegが必要です。
- SAMはモデル重みファイルを別途 `models/sam/` に配置してください。
- DiffusersやSAMなどはGPUがある方が快適です。
- SAM2はWindowsではWSL Ubuntu推奨のため、今後別ガイドとして追加予定です。
