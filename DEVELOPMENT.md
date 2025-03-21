# 開発ガイド：「誰もいないはずの家」

このドキュメントでは、Robloxホラーゲーム「誰もいないはずの家」の開発ワークフローについて説明します。

## 目次

1. [開発環境のセットアップ](#開発環境のセットアップ)
2. [プロジェクト構造](#プロジェクト構造)
3. [Roblox Open Cloud API連携](#roblox-open-cloud-api連携)
4. [開発ワークフロー](#開発ワークフロー)
5. [デプロイ方法](#デプロイ方法)
6. [トラブルシューティング](#トラブルシューティング)

## 開発環境のセットアップ

### 必要なツール

- **Roblox Studio**: ゲーム開発の主要ツール
- **Git**: バージョン管理
- **Python 3.6+**: スクリプト実行用
- **Rojo** (オプション): Roblox StudioとGitの連携ツール

### セットアップ手順

1. **リポジトリのクローン**:
   ```bash
   git clone https://github.com/yukihamada/horror-house-game.git
   cd horror-house-game
   ```

2. **Python依存関係のインストール**:
   ```bash
   pip install requests
   ```

3. **Rojo** (オプション):
   - [Rojo公式サイト](https://rojo.space/)からインストール
   - Roblox Studioにプラグインをインストール

## プロジェクト構造

```
horror-house-game/
├── .github/
│   └── workflows/          # GitHub Actions設定
├── src/
│   ├── ServerScriptService/ # サーバーサイドスクリプト
│   ├── ReplicatedStorage/   # 共有リソース
│   ├── StarterGui/          # UI関連
│   └── Workspace/           # 3Dモデル
├── build_rbxlx.py          # カスタムビルドスクリプト
├── roblox_sync.py          # Roblox同期スクリプト
├── default.project.json    # Rojoプロジェクト設定
└── README.md               # プロジェクト概要
```

## Roblox Open Cloud API連携

このプロジェクトはRoblox Open Cloud APIを使用して、GitHubリポジトリとRobloxプロジェクトを自動的に同期します。

### APIキーの設定

1. [Roblox Creator Dashboard](https://create.roblox.com/dashboard/credentials)にアクセス
2. 「API Keys」タブを選択
3. 「Create API Key」をクリック
4. 以下の権限を付与:
   - `opencloud.place.update`
   - `opencloud.place.read`

### GitHub Secretsの設定

1. GitHubリポジトリの「Settings」→「Secrets and variables」→「Actions」を開く
2. 以下のシークレットを追加:
   - `ROBLOX_API_KEY`: Roblox APIキー
   - `PLACE_ID`: RobloxプレイスID
   - `UNIVERSE_ID`: RobloxユニバースID

## 開発ワークフロー

### 基本的な開発フロー

1. **ローカルでの開発**:
   - Roblox Studioでゲームを開発
   - 変更をGitリポジトリに保存

2. **自動デプロイ**:
   - 変更をGitHubにプッシュ
   - GitHub Actionsが自動的にRobloxプロジェクトを更新

### Roblox Studioでの開発

1. **新規スクリプトの作成**:
   - 適切なフォルダ内にLuaスクリプトを作成
   - 例: `src/ServerScriptService/NewScript.lua`

2. **モデルの作成**:
   - JSONモデル定義を作成
   - 例: `src/Workspace/NewModel.model.json`

### ローカルでのテスト

1. **ビルドスクリプトの実行**:
   ```bash
   python build_rbxlx.py
   ```

2. **Robloxへの同期**:
   ```bash
   python roblox_sync.py
   ```

## デプロイ方法

### 自動デプロイ (推奨)

1. 変更をコミットしてGitHubにプッシュ:
   ```bash
   git add .
   git commit -m "変更内容の説明"
   git push origin main
   ```

2. GitHub Actionsが自動的にRobloxプロジェクトを更新

### 手動デプロイ

1. プロジェクトをビルド:
   ```bash
   python build_rbxlx.py
   ```

2. Roblox Studioで`game.rbxlx`を開く

3. 「File」→「Publish to Roblox」を選択

## トラブルシューティング

### APIキーの問題

- **エラー**: "APIキーが無効か、権限が不足しています"
- **解決策**: APIキーが正しく、必要な権限が付与されていることを確認

### ビルドの問題

- **エラー**: "Robloxプレイスファイルを生成できません"
- **解決策**: 
  1. Rojoがインストールされているか確認
  2. `build_rbxlx.py`が正しく動作するか確認
  3. プロジェクト構造が正しいか確認

### デプロイの問題

- **エラー**: "Robloxへのアップロードに失敗しました"
- **解決策**:
  1. プレイスIDとユニバースIDが正しいか確認
  2. APIキーに`opencloud.place.update`権限があるか確認

## 参考リンク

- [Roblox Developer Hub](https://developer.roblox.com/)
- [Roblox Open Cloud API](https://create.roblox.com/docs/cloud)
- [Rojo Documentation](https://rojo.space/docs)