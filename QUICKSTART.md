# 🚀 クイックスタートガイド - 日本の古民家 謎解きと妖怪ゲーム

このガイドでは、「日本の古民家 - 謎解きと妖怪ゲーム」の開発環境のセットアップと基本的な開発ワークフローについて説明します。

## 📋 前提条件

- [Roblox Studio](https://www.roblox.com/create) がインストールされていること
- [Git](https://git-scm.com/) がインストールされていること
- [Rojo](https://rojo.space/) がインストールされていること（下記の手順で説明）

## 🛠️ 開発環境のセットアップ

### 1. リポジトリのクローン

```bash
git clone https://github.com/yourusername/horror-house-game.git
cd horror-house-game
```

### 2. Rojoのインストール

#### Windows
```bash
# Cargo (Rust パッケージマネージャー) を使用する場合
cargo install rojo

# または、GitHub リリースページからバイナリをダウンロード
# https://github.com/rojo-rbx/rojo/releases
```

#### macOS
```bash
# Homebrew を使用する場合
brew install rojo

# または、Cargo を使用する場合
cargo install rojo
```

#### Linux
```bash
# Cargo を使用する場合
cargo install rojo
```

### 3. Roblox Studio に Rojo プラグインをインストール

1. Roblox Studio を起動
2. プラグインタブを選択
3. 「Plugins Marketplace」をクリック
4. 検索バーに「Rojo」と入力
5. 公式の Rojo プラグインをインストール

## 🎮 開発ワークフロー

### 1. Rojo サーバーの起動

プロジェクトディレクトリで以下のコマンドを実行します：

```bash
cd rojo-project
rojo serve
```

デフォルトでは、Rojo は `localhost:34872` でサーバーを起動します。特定のポートを指定する場合：

```bash
rojo serve --port 56385
```

外部からのアクセスを許可する場合：

```bash
rojo serve --address 0.0.0.0 --port 56385
```

### 2. Roblox Studio との接続

1. Roblox Studio を起動
2. 新しいプレイスを作成するか、既存のプレイスを開く
3. Rojo プラグインを開く（プラグインタブから）
4. 「Connect」ボタンをクリック
5. ホスト名とポート番号を入力（デフォルト: `localhost:34872`）
6. 「Connect」ボタンをクリック

接続が成功すると、Rojo サーバーからプロジェクトファイルが Roblox Studio に同期されます。

### 3. 開発サイクル

1. コードを編集（任意のテキストエディタで）
2. 変更を保存
3. Rojo が自動的に変更を Roblox Studio に同期
4. Roblox Studio でテスト（Play ボタンをクリック）
5. 必要に応じて手順 1-4 を繰り返す

### 4. プロジェクトのビルド

完成したプロジェクトを `.rbxlx` ファイルとしてエクスポートするには：

```bash
cd rojo-project
rojo build -o game.rbxlx
```

## 📁 プロジェクト構造

```
horror-house-game/
├── rojo-project/              # Rojoプロジェクトフォルダ
│   ├── default.project.json   # Rojoプロジェクト設定
│   └── src/                   # ソースコード
│       ├── client/            # クライアント側スクリプト
│       │   ├── GameStartup.client.lua       # クライアント初期化
│       │   ├── ModernUI.client.lua          # モダンUI
│       │   ├── TimerUI.client.lua           # タイマーUI
│       │   └── GameIntroUI.client.lua       # ゲーム説明UI
│       ├── server/            # サーバー側スクリプト
│       │   ├── GameStartup.server.lua       # サーバー初期化
│       │   ├── PuzzleController.lua         # 謎解き管理
│       │   ├── YokaiController.lua          # 妖怪管理
│       │   └── GameTimer.lua                # タイマー管理
│       └── shared/            # 共有モジュール
│           ├── GameConfig.lua               # ゲーム設定
│           └── MonsterConfig.lua            # 妖怪設定
└── README.md                  # プロジェクト説明
```

## 🧩 主要コンポーネント

### クライアント側

- **GameStartup.client.lua**: クライアント側の初期化処理
- **ModernUI.client.lua**: モダンなUIシステム
- **TimerUI.client.lua**: タイマー表示
- **GameIntroUI.client.lua**: ゲーム説明画面

### サーバー側

- **GameStartup.server.lua**: サーバー側の初期化処理
- **PuzzleController.lua**: 謎解き要素の管理
- **YokaiController.lua**: 妖怪の動作制御
- **GameTimer.lua**: ゲームタイマーの管理

### 共有モジュール

- **GameConfig.lua**: ゲーム全体の設定
- **MonsterConfig.lua**: 妖怪の設定

## 🔍 デバッグのヒント

### コンソールログの確認

Roblox Studio の「Output」ウィンドウでログを確認できます。デバッグ情報を出力するには：

```lua
print("デバッグ情報: " .. someVariable)
```

### エラーの特定

エラーが発生した場合、「Output」ウィンドウに赤字でエラーメッセージが表示されます。エラーメッセージには、エラーが発生したスクリプトと行番号が含まれています。

### リモートイベントのデバッグ

リモートイベントのデバッグには、発火前後にログを出力すると効果的です：

```lua
-- サーバー側
print("RemoteEvent発火前: " .. eventName)
remoteEvent:FireClient(player, data)
print("RemoteEvent発火後")

-- クライアント側
remoteEvent.OnClientEvent:Connect(function(data)
    print("RemoteEventを受信: " .. tostring(data))
    -- 処理
end)
```

## 📚 参考リソース

- [Roblox Developer Hub](https://developer.roblox.com/)
- [Rojo Documentation](https://rojo.space/docs/)
- [Lua Documentation](https://www.lua.org/docs.html)

---

<div align="center">
  <p>🏮 日本の古民家 - 謎解きと妖怪ゲーム 🏮</p>
  <p>Developed with ❤️ by OpenHands Team</p>
</div>