# CLAUDE.md

このファイルは、Claude Code (claude.ai/code) がこのリポジトリで作業する際のガイダンスを提供します。

## 言語設定

**重要**: Claude Code は常に日本語で回答すること
**重要**: .kiro/steering があったら見ること
**重要**: このリポジトリの README は.github/README.md である

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

- **GCP** (`/gcp/`): Google Cloud Platform アイコン
- **AWS** (`/aws/`): Amazon Web Services アイコン
- **Kubernetes** (`/kubernetes/`): Kubernetes リソースアイコン
- **CNCF** (`/cncf/`): Cloud Native Computing Foundation プロジェクトアイコン

### 技術アーキテクチャ

#### 動的アイコン管理システム

- **GitHub Actions**: アイコンファイル変更を自動検知し、`icons.json`を生成
- **ファイル名ハードコーディング禁止**: 全アイコンはファイルシステムから動的に取得
- **自動デプロイ**: GitHub Pages での自動公開

#### フロントエンド

- **技術構成**: Pure HTML/CSS/JavaScript (フレームワークなし)
- **機能**: URL コピー、強制ダウンロード、レスポンシブ UI、リアルタイム検索
- **対応形式**: 全画像形式（PNG/SVG/JPG/JPEG/GIF）を自動で PNG 最適化
- **自動化**: フォルダ名からページタイトルを自動生成、テンプレートから各カテゴリページを生成
- **ダウンロード**: fetch + blob 方式で強制ダウンロード（ブラウザ表示回避）
- **検索機能**: トップページは全カテゴリ横断検索、各カテゴリページはカテゴリ内検索

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

1. 該当フォルダ（gcp/、aws/、kubernetes/、cncf/、logo/）に画像ファイル（PNG/SVG/JPG/JPEG/GIF）を配置
2. GitHub Actions が自動実行され、すべての画像を PNG に変換・最適化
3. `icons.json`を自動更新
4. GitHub Pages が自動デプロイし、新アイコンが表示される

**新カテゴリの場合:**

1. `cp -r template/ [カテゴリ名]/` でテンプレートをコピー
2. 画像ファイル（PNG/SVG/JPG/JPEG/GIF）を配置（GitHub Actions で自動処理）
3. `index.html`にカードを手動追加（メインページ更新）

### コード規約

- **言語**: JavaScript ES6+使用
- **CSS**: Vanilla CSS（プリプロセッサなし）
- **HTML**: セマンティック HTML5
- **エラーハンドリング**: 必須（ネットワークエラー、ファイル不存在など）

## ディレクトリ構造

```
icons-factory/
├── .gitignore                   # icons.json、search-index.json と各カテゴリのindex.htmlを除外（templateは保持）
├── index.html                   # メインページ（手動更新）
├── gcp/
│   └── *.png                    # GCPアイコン（最適化済み）
├── aws/
│   └── *.png                    # AWSアイコン（最適化済み）
├── kubernetes/
│   └── *.png                    # Kubernetesアイコン（最適化済み）
├── cncf/
│   ├── *.png                    # CNCFプロジェクトアイコン（最適化済み）
│   └── projects/                # 元のCNCF構造（参照用）
├── logo/
│   └── *.png                    # 各社ロゴアイコン（最適化済み）
├── template/                    # 新カテゴリ用テンプレート
│   ├── index.html               # マスターテンプレート（デプロイ時に各カテゴリにコピー）
│   └── README.md                # カテゴリ追加手順
└── .github/workflows/
    └── main.yml                 # 統合ワークフロー（変換・デプロイ）

注意: icons.json、search-index.json、index.html（各カテゴリ）はデプロイ時のみ生成される一時ファイルです
```

## GitHub Actions 仕様

### 統合ワークフロー (`main.yml`)

**トリガー条件:**

- `main`ブランチへのプッシュ（全ファイル）
- 手動実行（`workflow_dispatch`）

**処理フロー:**

1. **画像変換**

   - **SVG 変換**: Inkscape 使用、長辺 512px・アスペクト比維持・縮小のみ
   - **JPG/JPEG/GIF 変換**: ImageMagick 使用、長辺 512px・アスペクト比維持・縮小のみ
   - **元ファイル削除**: 変換成功後に元ファイル（SVG/JPG/JPEG/GIF）を自動削除

2. **アイコンリスト生成**

   - 各カテゴリフォルダの PNG ファイルを検出
   - `icons.json`を自動生成

3. **変更コミット**

   - 変換された PNG ファイル
   - 生成された`icons.json`
   - **注意**: 各カテゴリの`index.html`はコミットしない

4. **デプロイ準備**

   - `template/index.html`を各カテゴリにコピー（一時的）
   - シンボリックリンクの代替実装

5. **GitHub Pages デプロイ**
   - 静的サイト自動アップロード・公開

### DRY 原則対応

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

## プライバシー・SEO 設定

### 検索エンジン対策（プライベート利用向け）

**robots.txt 設定:**

```
User-agent: *
Disallow: /
```

**HTML メタタグ設定（全ページ共通）:**

```html
<meta name="robots" content="noindex, nofollow, noarchive, nosnippet" />
```

**SEO 回避設定:**

- description、keywords、og:、twitter タグなし
- sitemap.xml なし
- Jekyll 設定ファイルなし
- 外部サービス連携なし

### 検索エンジンに発見されない理由

1. **robots.txt**: 全ページアクセス禁止
2. **メタタグ**: インデックス・フォロー・アーカイブ・スニペット禁止
3. **SEO メタ情報**: 意図的に削除済み
4. **sitemap**: 存在しない（検索エンジンに構造を教えない）

## よくある作業

### 画像ファイルの追加（全形式対応）

1. 任意の画像ファイル（PNG/SVG/JPG/JPEG/GIF）を該当フォルダに配置
2. `main.yml` ワークフローが自動実行:
   - **SVG**: Inkscape で最適なサイズの PNG に変換（長辺 512px 以下、縮小のみ）
   - **JPG/JPEG/GIF**: ImageMagick で PNG に変換（長辺 512px 以下、縮小のみ）
   - **PNG**: そのまま使用（必要に応じて縮小）
   - 元ファイル（SVG/JPG/JPEG/GIF）は変換成功後に自動削除
3. GitHub Pages デプロイ時にアイコンリスト（icons.json）を動的生成
4. GitHub Pages で自動デプロイ

**重要**: 元画像は変換後に自動削除され、リポジトリには最適化された PNG ファイルのみが残ります。

### 新しいカテゴリ追加

1. `cp -r template/ [カテゴリ名]/` でテンプレートコピー
2. template/README.md を参考にセットアップ
3. 画像ファイル（任意の形式）を配置
4. **重要**: メインページ（`index.html`）にカテゴリカードを手動追加
5. GitHub Actions が自動実行（ワークフロー設定変更不要）

### アイコン一括更新

1. 該当フォルダに新アイコンを配置（全形式対応）
2. 不要なアイコンを削除
3. GitHub Actions が自動実行:
   - 全画像を最適化・PNG 変換
   - デプロイ時に`icons.json`動的生成
   - 各カテゴリに`index.html`配置（デプロイ時のみ）
4. GitHub Pages で自動デプロイ完了

### ダウンロード機能の仕様

- **強制ダウンロード**: fetch + blob 方式でブラウザ表示を回避
- **相対パス使用**: CORS 制限を回避
- **エラーハンドリング**: 失敗時の適切な通知
- **メモリ管理**: オブジェクト URL の自動クリーンアップ

### 検索機能の仕様

#### トップページ（全カテゴリ横断検索）

- **データソース**: `search-index.json`（全カテゴリのアイコン情報を統合）
- **機能**:
  - リアルタイム検索（300ms デバウンス）
  - 部分一致・大文字小文字無視
  - 検索結果ハイライト表示
  - カテゴリ別表示
  - 検索結果から各カテゴリページへ直接リンク
- **UI**: 検索ボックス + ドロップダウン形式の結果表示

#### 各カテゴリページ（カテゴリ内検索）

- **データソース**: 各カテゴリの`icons.json`
- **機能**:
  - リアルタイム検索（300ms デバウンス）
  - 部分一致・大文字小文字無視
  - 検索結果ハイライト表示
  - 検索統計表示（「120 件中 15 件を表示」）
  - クリアボタン・ESC キーでリセット
- **UI**: 検索ボックス + グリッド表示でフィルタリング

#### 検索インデックス構造

```json
{
  "icons": [
    {
      "name": "BigQuery",
      "filename": "BigQuery.png",
      "category": "gcp",
      "path": "gcp/BigQuery.png"
    }
  ]
}
```

- to memorize