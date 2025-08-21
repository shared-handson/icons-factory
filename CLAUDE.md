# CLAUDE.md

このファイルは、Claude Code (claude.ai/code) がこのリポジトリで作業する際のガイダンスを提供します。

## 言語設定

**重要**: Claude Code は常に日本語で回答すること
**重要**: .kiro/steering があったら見ること

## コントリビューターのメンバー

- 全員の共通は以下
  - 日本人(日本語が母国語)
  - インフラが得意なエンジニア
  - 手を動かすことが好き

## プロジェクト概要

開発・インフラで使うアイコンを集めたプライベートドキュメントサイトです。  
GitHub Pages で公開しますが、検索エンジンからは隠蔽されています。

### アイコンカテゴリ

以下のカテゴリのアイコンを提供:

- **GCP** (`/gcp/`): Google Cloud Platform アイコン (238 個)
- **AWS** (`/aws/`): Amazon Web Services アイコン (300 個+)
- **Kubernetes** (`/kubernetes/`): Kubernetes リソースアイコン (50 個+)
- **CNCF** (`/cncf/`): Cloud Native Computing Foundation プロジェクトアイコン (197 個)

### 技術アーキテクチャ

#### 動的アイコン管理システム

- **GitHub Actions**: アイコンファイル変更を自動検知し、`icons.json`を生成
- **ファイル名ハードコーディング禁止**: 全アイコンはファイルシステムから動的に取得
- **自動デプロイ**: GitHub Pages での自動公開

#### フロントエンド

- **技術構成**: Pure HTML/CSS/JavaScript (フレームワークなし)
- **機能**: URL コピー、ダウンロード、レスポンシブ UI
- **対応形式**: PNG 画像のみ（CNCF は color 版）
- **自動化**: フォルダ名からページタイトルを自動生成

## 開発ルール

### ファイル名ハードコーディング禁止

**絶対に守るべきルール**: どんな状況でも、ファイル名やファイル名の一部をコードに直接記述してはいけません。

```javascript
// ❌ 禁止: ファイル名のハードコーディング
const icons = ["BigQuery.png", "Cloud-Storage.png"];

// ✅ 正解: GitHub Actionsで生成されたJSONを使用
const response = await fetch("./icons.json");
const data = await response.json();
const icons = data.icons;
```

### アイコン追加手順

**既存カテゴリの場合:**

1. 該当フォルダ（gcp/、aws/、kubernetes/、cncf/）に PNG ファイルを配置
2. GitHub Actions が自動実行され、`icons.json`を更新
3. GitHub Pages が自動デプロイし、新アイコンが表示される

**新カテゴリの場合:**

1. `cp -r template/ [カテゴリ名]/` でテンプレートをコピー
2. PNG ファイルを配置（GitHub Actions で自動処理）
3. `index.html`にカードを手動追加（メインページ更新）

### コード規約

- **言語**: JavaScript ES6+使用
- **CSS**: Vanilla CSS（プリプロセッサなし）
- **HTML**: セマンティック HTML5
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

## GitHub Actions 仕様

### 1. SVG→PNG変換ワークフロー (`convert-svg-to-png.yml`)

**トリガー条件:**
- `main`ブランチへのプッシュ
- `*/*.svg` パスの変更検知
- 手動実行（`workflow_dispatch`）

**処理内容:**
- Inkscape使用でSVG→PNG変換（512x512px）
- **重要**: 変換成功後に元SVGファイルを自動削除
- 共通の除外フォルダ判定関数 `should_skip_folder()` 使用
- 統計表示（変換数・削除数）
- 次のアイコンリスト生成ワークフローを自動トリガー

### 2. アイコンリスト生成ワークフロー (`generate-icon-list.yml`)

**トリガー条件:**
- `main`ブランチへのプッシュ
- `*/*.png` パスの変更検知（SVG削除済みのためPNGのみ）
- 手動実行（`workflow_dispatch`）

**処理内容:**
- 自動フォルダ検知機能（template フォルダ等は除外）
- 共通の除外フォルダ判定関数 `should_skip_folder()` 使用
- PNGファイルのみ対象（SVGは変換済みのため除外）

### 3. GitHub Pagesデプロイワークフロー (`deploy-pages.yml`)

**トリガー条件:**
- `main`ブランチへのプッシュ
- 手動実行（`workflow_dispatch`）

**処理内容:**
- 静的サイト自動デプロイ
- デプロイ完了通知

### DRY原則対応

**共通化された要素:**
- 除外フォルダ設定: `EXCLUDE_FOLDERS=".git .github template"`
- 除外判定関数: `should_skip_folder()` 
- エラーハンドリングパターン

### 生成される JSON 形式

```json
{
  "icons": ["example-icon.png", "another-icon.png"]
}
```

## メンテナンス時の注意

- **新カテゴリ追加**: テンプレートをコピーし、メインページに手動でカード追加
- **アイコン形式変更**: PNG 形式のみサポート
- **UI 変更**: 全フォルダで汎用テンプレートを使用（自動的に一貫性が保たれる）
- **GitHub Actions**: 新フォルダは自動検知（設定変更不要）

## プライバシー・SEO設定

### 検索エンジン対策（プライベート利用向け）

**robots.txt設定:**
```
User-agent: *
Disallow: /
```

**HTML メタタグ設定（全ページ共通）:**
```html
<meta name="robots" content="noindex, nofollow, noarchive, nosnippet">
```

**SEO回避設定:**
- description、keywords、og:、twitterタグなし
- sitemap.xml なし
- Jekyll設定ファイルなし
- 外部サービス連携なし

### 検索エンジンに発見されない理由

1. **robots.txt**: 全ページアクセス禁止
2. **メタタグ**: インデックス・フォロー・アーカイブ・スニペット禁止
3. **SEOメタ情報**: 意図的に削除済み
4. **sitemap**: 存在しない（検索エンジンに構造を教えない）

## よくある作業

### SVGファイルの追加（自動変換）

1. SVGファイルを該当フォルダに配置
2. GitHub Actions が自動実行:
   - Inkscapeで512x512pxのPNGに変換
   - 変換成功後に元SVGファイルを削除
   - アイコンリスト（icons.json）を更新
3. GitHub Pages で自動デプロイ

### 新しいカテゴリ追加

1. `cp -r template/ [カテゴリ名]/` でテンプレートコピー
2. 不要ファイル削除（sample-icon.png 等）
3. PNG または SVG アイコンファイルを配置
4. メインページ（index.html）にカード手動追加
5. GitHub Actions が自動実行（設定変更不要）

### アイコン一括更新

1. 該当フォルダに新アイコンを配置（PNG/SVG両対応）
2. 不要なアイコンを削除
3. GitHub Actions が自動実行され`icons.json`更新
4. SVGは自動でPNGに変換後削除
5. GitHub Pages で自動デプロイ完了
