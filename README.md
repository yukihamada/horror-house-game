# 誰もいないはずの家 - Robloxホラーゲーム

## ゲーム概要
プレイヤーは夜、一人で家にお留守番をしている。突然、誰もいないはずの家の中で不可解な出来事が起こり始める。プレイヤーの目的は家の中を探索し、隠された謎を解き明かして脱出することである。

## 機能
- **探索要素**：家中の引き出しや戸棚、部屋を調べ、アイテムや手がかりを見つける
- **隠れる・逃げる要素**：物音や不気味な気配がしたら、クローゼットやベッドの下などに隠れる
- **SAN値システム**：恐怖体験をするとSAN値が低下し、幻覚が見えたり視界が狭くなる
- **パズルとアイテム収集**：家の謎を解く鍵となるアイテムを集めてパズルを解く
- **インタラクティブな環境**：家電や照明などがランダムに動作し、プレイヤーを驚かせる

## 開発環境
- Roblox Studio
- Lua言語
- Git/GitHub
- Python (自動デプロイ用)

## 特徴

### 継続的インテグレーション/デプロイ (CI/CD)
このプロジェクトはRoblox Open Cloud APIを使用して、GitHubリポジトリとRobloxプロジェクトを自動的に同期します。
変更をGitHubにプッシュするだけで、自動的にRobloxゲームが更新されます。

### モジュール化された設計
ゲームの各機能は独立したモジュールとして設計されており、拡張性と保守性に優れています。

## クイックスタート

### 開発者向け
1. リポジトリをクローン: `git clone https://github.com/yukihamada/horror-house-game.git`
2. 依存関係をインストール: `pip install requests`
3. 詳細は[開発ガイド](DEVELOPMENT.md)を参照

### プレイヤー向け
1. Robloxで「誰もいないはずの家」を検索
2. ゲームをプレイ

## ファイル構造
```
horror-house-game/
├── .github/workflows/     # GitHub Actions設定
├── src/
│   ├── ServerScriptService/  # サーバーサイドスクリプト
│   │   ├── GameManager.lua   # ゲーム全体の管理
│   │   ├── EnemyAI.lua       # 敵のAI制御
│   │   └── InteractiveObject.lua # インタラクティブなオブジェクト
│   ├── ReplicatedStorage/    # 共有リソース
│   │   ├── SanitySystem.lua  # SAN値システム
│   │   └── Events.model.json # イベント定義
│   ├── StarterGui/           # UI関連
│   │   ├── UIManager.lua     # UI管理
│   │   └── MainUI.model.json # UI定義
│   └── Workspace/            # 3Dモデルなど
│       └── House.model.json  # 家のモデル
├── build_rbxlx.py          # ビルドスクリプト
├── roblox_sync.py          # Roblox同期スクリプト
├── default.project.json    # Rojoプロジェクト設定
└── DEVELOPMENT.md          # 開発ガイド
```

## 主要コンポーネント
1. **GameManager**: ゲームの状態管理、プレイヤーの参加/退出処理
2. **EnemyAI**: 敵キャラクターの巡回、追跡、探索行動
3. **SanitySystem**: プレイヤーのSAN値管理と効果適用
4. **InteractiveObject**: 調査可能なオブジェクトの処理
5. **UIManager**: メッセージ表示、インベントリ、SAN値表示などのUI管理

## 自動デプロイ
このプロジェクトはGitHub Actionsを使用して、変更が`main`ブランチにプッシュされるたびに自動的にRobloxゲームを更新します。
詳細は[開発ガイド](DEVELOPMENT.md)の「Roblox Open Cloud API連携」セクションを参照してください。

## 貢献方法
1. このリポジトリをフォーク
2. 機能ブランチを作成: `git checkout -b my-new-feature`
3. 変更をコミット: `git commit -am 'Add some feature'`
4. ブランチにプッシュ: `git push origin my-new-feature`
5. プルリクエストを作成

## ライセンス
MIT License