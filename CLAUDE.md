# CLAUDE.md

このファイルは、Claude Code (claude.ai/code) がこのリポジトリで作業する際のガイダンスを提供します。

## 言語設定

**重要**: Claude Code は常に日本語で回答してください。このプロジェクトのメンバーは全員日本人であり、すべてのコミュニケーションは日本語で行われます。
**重要**: .kiro/steering があったら見ること

## コントリビューターのメンバー

- 全員の共通は以下
  - 日本人(日本語が母国語)
  - インフラが得意なエンジニア
  - 手を動かすことが好き

## プロジェクト概要

開発・インフラで使うアイコンを集めたドキュメントサイトです。  
GitHub Pages で公開します。

### アイコンカテゴリ

以下のカテゴリのアイコンを提供:

- **GCP** (`/gcp/`): Google Cloud Platform アイコン (238個)
- **AWS** (`/aws/`): Amazon Web Services アイコン (300個+)
- **Kubernetes** (`/kubernetes/`): Kubernetes リソースアイコン (50個+)
- **CNCF** (`/cncf/`): Cloud Native Computing Foundation プロジェクトアイコン (197個)

### 技術アーキテクチャ

#### 動的アイコン管理システム
- **GitHub Actions**: アイコンファイル変更を自動検知し、`icons.json`を生成
- **ファイル名ハードコーディング禁止**: 全アイコンはファイルシステムから動的に取得
- **自動デプロイ**: GitHub Pagesでの自動公開

#### フロントエンド
- **技術構成**: Pure HTML/CSS/JavaScript (フレームワークなし)
- **機能**: URLコピー、ダウンロード、レスポンシブUI
- **対応形式**: PNG画像のみ（CNCFはcolor版）
- **自動化**: フォルダ名からページタイトルを自動生成

## 開発ルール

### ファイル名ハードコーディング禁止

**絶対に守るべきルール**: どんな状況でも、ファイル名やファイル名の一部をコードに直接記述してはいけません。

```javascript
// ❌ 禁止: ファイル名のハードコーディング
const icons = ['BigQuery.png', 'Cloud-Storage.png'];

// ✅ 正解: GitHub Actionsで生成されたJSONを使用
const response = await fetch('./icons.json');
const data = await response.json();
const icons = data.icons;
```

### アイコン追加手順

**既存カテゴリの場合:**
1. 該当フォルダ（gcp/、aws/、kubernetes/、cncf/）にPNGファイルを配置
2. GitHub Actionsが自動実行され、`icons.json`を更新
3. GitHub Pagesが自動デプロイし、新アイコンが表示される

**新カテゴリの場合:**
1. `cp -r template/ [カテゴリ名]/` でテンプレートをコピー
2. PNGファイルを配置（GitHub Actionsで自動処理）
3. `index.html`にカードを手動追加（メインページ更新）

### コード規約

- **言語**: JavaScript ES6+使用
- **CSS**: Vanilla CSS（プリプロセッサなし）
- **HTML**: セマンティックHTML5
- **エラーハンドリング**: 必須（ネットワークエラー、ファイル不存在など）

## ディレクトリ構造

```
icons-factory/
├── index.html                   # メインページ（手動更新）
├── gcp/
│   ├── *.png                    # GCPアイコン
│   ├── index.html               # 汎用テンプレート（自動タイトル生成）
│   └── icons.json               # GitHub Actions生成
├── aws/
│   ├── *.png                    # AWSアイコン
│   ├── index.html               # 汎用テンプレート（自動タイトル生成）
│   └── icons.json               # GitHub Actions生成
├── kubernetes/
│   ├── *.png                    # Kubernetesアイコン
│   ├── index.html               # 汎用テンプレート（自動タイトル生成）
│   └── icons.json               # GitHub Actions生成
├── cncf/
│   ├── *.png                    # CNCFプロジェクトアイコン
│   ├── index.html               # 汎用テンプレート（自動タイトル生成）
│   ├── icons.json               # GitHub Actions生成
│   └── projects/                # 元のCNCF構造（参照用）
├── template/                    # 新カテゴリ用テンプレート
│   ├── index.html               # 汎用テンプレート
│   ├── README.md                # 使用方法
│   └── sample-icon.png          # プレースホルダー
└── .github/workflows/
    ├── generate-icon-list.yml   # アイコンリスト自動生成
    └── deploy-pages.yml         # GitHub Pages自動デプロイ
```

## GitHub Actions仕様

### トリガー条件
- `main`ブランチへのプッシュ
- 以下パスの変更検知:
  - `*/*.png` (全フォルダのPNGファイル)
  - `*/**/*.png` (サブフォルダを含む)
- 手動実行（`workflow_dispatch`）
- 自動フォルダ検知機能（templateフォルダ等は除外）

### 生成されるJSON形式
```json
{
  "icons": [
    "example-icon.png",
    "another-icon.png"
  ]
}
```

## メンテナンス時の注意

- **新カテゴリ追加**: テンプレートをコピーし、メインページに手動でカード追加
- **アイコン形式変更**: PNG形式のみサポート
- **UI変更**: 全フォルダで汎用テンプレートを使用（自動的に一貫性が保たれる）
- **GitHub Actions**: 新フォルダは自動検知（設定変更不要）

## よくある作業

### 新しいカテゴリ追加
1. `cp -r template/ [カテゴリ名]/` でテンプレートコピー
2. 不要ファイル削除（sample-icon.png等）
3. PNGアイコンファイルを配置
4. メインページ（index.html）にカード手動追加
5. GitHub Actionsが自動実行（設定変更不要）

### アイコン一括更新
1. 該当フォルダに新アイコンを配置
2. 不要なアイコンを削除
3. GitHub Actionsが自動実行され`icons.json`更新
4. GitHub Pagesで自動デプロイ完了
