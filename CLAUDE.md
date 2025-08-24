# CLAUDE.md

このファイルは、Claude Code (claude.ai/code) がこのリポジトリで作業する際のガイダンスを提供します。

## 言語設定

**重要**: Claude Code は常に日本語で回答すること  
**重要**: .kiro/steering があったら見ること  
**重要**: このリポジトリの README は.github/README.md である  
**重要**: git commit や push のタイトルやメッセージ は常に日本語にすること

## コントリビューターのメンバー

- 全員の共通は以下
  - 日本人(日本語が母国語)
  - インフラが得意なエンジニア
  - 手を動かすことが好き

## プロジェクト概要

開発・インフラで使うアイコンを集めたプライベートドキュメントサイトです。  
GitHub Pages で公開しますが、検索エンジンからは隠蔽されています。

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
- **表示改善**: アスペクト比保持表示、薄い灰色背景で視認性向上、アイコンサイズ表示

## 開発ルール

### ⚠️ 重要：命名規則

**カテゴリ名とファイル名では極力日本語を避けること**

- **推奨**: `database.png`, `cloud-storage.svg`, `load-balancer.jpg`
- **非推奨**: `データベース.png`, `クラウド ストレージ.svg`
- **理由**: GitHub Actions の自動処理で予期しない動作やファイル名の意図しない変換が発生する可能性がある
- **特に注意**: 日本語ファイル名はサニタイズ処理で `icon.png` などの汎用名に変換されることがある

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
├── .gitattributes               # GitHub言語検出・バイナリファイル制限
├── .gitignore                   # icons.json、search-index.json と各カテゴリのindex.htmlを除外（templateは保持）
├── .nojekyll                    # Jekyll処理無効化（GitHub Pages用）
├── CLAUDE.md                    # Claude Code用プロジェクト指示（このファイル）
├── index.html                   # メインページ（手動更新）
├── robots.txt                   # 検索エンジン除外設定（サイト・リポジトリ両方）
├── [カテゴリ名]/                # アイコンカテゴリフォルダ
│   └── *.png                    # アイコン（最適化済み）
├── [その他のカテゴリ]/          # 各アイコンカテゴリ（動的に追加可能）
├── template/                    # 新カテゴリ用テンプレート
│   ├── index.html               # マスターテンプレート（デプロイ時に各カテゴリにコピー）
│   └── README.md                # カテゴリ追加手順
└── .github/
    ├── README.md                # プロジェクト説明
    └── workflows/
        └── main.yml             # 統合ワークフロー（変換・デプロイ）

注意: icons.json、search-index.json、metadata.json、index.html（各カテゴリ）はデプロイ時のみ生成される一時ファイルです
```

## GitHub Actions 仕様

### 統合ワークフロー (`main.yml`)

**トリガー条件:**

- `main`ブランチへのプッシュ（全ファイル）
- 手動実行（`workflow_dispatch`）

**処理フロー:**

1. **ファイル名サニタイズ**

   - 全画像ファイル（SVG/JPG/JPEG/GIF/PNG）を一括で URL 安全な形式に変換
   - スペース → アンダースコア、特殊文字 → ハイフン、大文字保持

2. **画像変換（拡張子別独立処理）**

   - **SVG → PNG**: Inkscape 使用、長辺 512px・アスペクト比維持・拡大縮小両対応
   - **JPG → PNG**: ImageMagick 使用、長辺 512px・アスペクト比維持・縮小のみ
   - **JPEG → PNG**: ImageMagick 使用、長辺 512px・アスペクト比維持・縮小のみ
   - **GIF → PNG**: ImageMagick 使用、長辺 512px・アスペクト比維持・縮小のみ
   - **元ファイル削除**: 変換成功後に元ファイル（SVG/JPG/JPEG/GIF）を自動削除

3. **PNG 最適化**

   - **サイズチェック**: 長辺が 512px を超える PNG ファイルを検出
   - **自動縮小**: ImageMagick 使用、長辺 512px・アスペクト比維持

4. **変更コミット**

   - 変換された PNG ファイル
   - 削除された元ファイル（SVG/JPG/JPEG/GIF）
   - **注意**: icons.json や各カテゴリの index.html はコミットしない

5. **デプロイ準備**

   - `template/index.html`を各カテゴリにコピー（一時的）
   - 各フォルダの `icons.json`を自動生成

6. **検索インデックス・メタデータ生成**

   - 全カテゴリ統合検索用の`search-index.json`を自動生成
   - アイコン統計・カテゴリ情報の`metadata.json`を自動生成

7. **GitHub Pages デプロイ**
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

**GitHub Pages サイト隠蔽:**

robots.txt 設定:

```
User-agent: *
Disallow: /
```

HTML メタタグ設定（全ページ共通）:

```html
<meta name="robots" content="noindex, nofollow, noarchive, nosnippet" />
```

**GitHub リポジトリ隠蔽:**

.nojekyll ファイル:

```
（空ファイル - Jekyll処理を無効化）
```

.gitattributes 設定:

```
# GitHubでの言語検出を制限
*.html linguist-detectable=false
*.css linguist-detectable=false
*.js linguist-detectable=false
*.sh linguist-detectable=false
*.ps1 linguist-detectable=false
*.bat linguist-detectable=false
*.cmd linguist-detectable=false
*.md linguist-documentation

# バイナリファイルとして扱い、検索インデックスから除外
*.png binary
*.jpg binary
*.jpeg binary
*.gif binary
*.svg binary
```

robots.txt 追加設定:

```
# GitHubリポジトリページも隠蔽
User-agent: *
Disallow: /*.git*
Disallow: /README.md
Disallow: /.github/
```

**SEO 回避設定:**

- description、keywords、og:、twitter タグなし
- sitemap.xml なし
- Jekyll 設定ファイルなし
- 外部サービス連携なし

### 検索エンジンに発見されない理由

1. **robots.txt**: 全ページアクセス禁止 + GitHub ファイル除外
2. **メタタグ**: インデックス・フォロー・アーカイブ・スニペット禁止
3. **SEO メタ情報**: 意図的に削除済み
4. **sitemap**: 存在しない（検索エンジンに構造を教えない）
5. **.nojekyll**: 静的ファイル扱いで発見されにくく
6. **.gitattributes**: 言語検出・バイナリファイル検索を制限

## ファイル名サニタイズ機能

### URL 安全なファイル名への自動変換

GitHub Actions で画像変換時に、URL 安全でないファイル名を自動的にサニタイズします：

- **スペース → アンダースコア**: 「My Icon.svg」→「My_Icon.svg」
- **特殊文字 → ハイフン**: 「Icon@#$.svg」→「Icon---.svg」
- **連続文字の統一**: 「icon---\_\_\_.svg」→「icon-.svg」
- **前後の記号削除**: 「-icon-.svg」→「icon.svg」
- **空文字対策**: 特殊文字のみの場合「icon.png」を使用
- **大文字保持**: 大文字はそのまま保持

**サニタイズ例:**

- 「Big Query Service.svg」→「Big_Query_Service.png」
- 「Cloud Storage (Beta).jpg」→「Cloud_Storage-Beta-.png」
- 「データベース ★.gif」→「--.png」→「icon.png」

### 変更通知

ファイル名が変更された場合、GitHub Actions ログで通知されます：

```
🔧 Sanitized filename: My Special Icon!.svg -> My_Special_Icon-.png
```

## UI/UX 改善

### アイコン表示の最適化

- **アスペクト比保持**: `max-width: 64px; max-height: 64px; width: auto; height: auto; object-fit: contain;`で正方形以外のアイコンも歪まずに表示
- **視認性改善**: アイコンカード背景を薄い灰色（`#f8f9fa`）に変更し、白いアイコンも見やすく
- **サイズ表示**: 各アイコンに実際のピクセルサイズを小さい文字で表示（例：「512 × 512px」）
- **動的サイズ取得**: `img.naturalWidth`と`img.naturalHeight`で実際の画像サイズを取得・表示
- **ユーザビリティ**: アイコンの詳細情報を一目で確認可能

## 技術的トラブルシューティング履歴

### 2024 年 8 月：cisco フォルダ JPG 変換問題の解決

**問題の発見**

- cisco フォルダの 294 個の JPG ファイルがワークフローで処理されず PNG に変換されない
- サニタイズは実行されるが JPG→PNG 変換が失敗

**原因の特定**

1. **ファイル存在チェックの問題**: `ls "$folder"*.jpg`がスペース含むファイル名で正常動作しない
2. **処理順序の問題**: サニタイズと変換が別ステップで実行され、連携が不完全
3. **複数形式一括処理の複雑性**: JPG、JPEG、GIF を一つの関数で処理することによる制御の困難

**解決アプローチ**

1. **ワークフロー構造の根本的再設計**:

   - サニタイズ → 変換 → リサイズの明確な分離
   - 各拡張子を独立したステップに分割

2. **実装した修正**:

   ```yaml
   # 修正前：複数形式を一括処理
   - name: Convert other image formats to PNG

   # 修正後：拡張子別独立処理
   - name: Sanitize all image filenames # 最初に一括サニタイズ
   - name: Convert SVG to PNG
   - name: Convert JPG to PNG # 個別処理
   - name: Convert JPEG to PNG
   - name: Convert GIF to PNG
   - name: Optimize PNG files
   ```

3. **ファイル検索方法の改善**:

   ```bash
   # 修正前：スペースでエラー
   if ls "$folder"*.jpg 1> /dev/null 2>&1; then

   # 修正後：findコマンドでスペース対応
   if find "$folder" -maxdepth 1 -name "*.jpg" -type f | grep -q .; then
   ```

**テスト戦略**

- 包括的テストファイルの作成:
  - `"new test file with spaces.jpg"` (スペース含む JPG)
  - `"special@chars#test.jpeg"` (特殊文字含む JPEG)
  - `"animated test.gif"` (スペース含む GIF)
  - `"complex svg (test).svg"` (スペース+括弧含む SVG)
  - `"大きな画像ファイル.png"` (日本語含む PNG)

**結果**

- ✅ cisco フォルダ：107 個の JPG ファイル → 全て正常に PNG 変換
- ✅ test-images フォルダ：全形式・全ファイル名パターン → 正常処理
- ✅ ワークフロー安定性：拡張子別処理により明確なエラー追跡が可能

**学んだ教訓**

- 複雑な処理は単一ステップより個別ステップに分割する方が保守性が高い
- ファイル名にスペースや特殊文字を含む場合は`find`コマンドが`ls`より適切
- 自動処理では事前のファイル名サニタイズが重要

## よくある作業

### URL コピー機能の仕様

- **表示用 URL**: 相対パス（`./filename`）で CORS 制限を回避
- **コピー用 URL**: 絶対 URL（`https://domain/path/filename`）で外部利用可能
- **検索結果での直接操作**: カテゴリページ経由なしで即座に URL コピー・ダウンロード
- **トースト通知**: 操作成功・失敗のリアルタイムフィードバック
- **Clipboard API**: モダンブラウザ対応の安全なクリップボード操作

### 画像ファイルの追加（全形式対応）

1. 任意の画像ファイル（PNG/SVG/JPG/JPEG/GIF）を該当フォルダに配置
2. `main.yml` ワークフローが自動実行:
   - **SVG**: Inkscape で最適なサイズの PNG に変換（長辺 512px 以下、縮小のみ）
   - **JPG/JPEG/GIF**: ImageMagick で PNG に変換（長辺 512px 以下、縮小のみ）
   - **PNG 最適化**: 長辺 512px を超える PNG ファイルを自動縮小
   - **ファイル名自動サニタイズ**: 全形式で URL 安全な形式に変換（「My Icon.svg」→「My_Icon.png」）
   - 元ファイル（SVG/JPG/JPEG/GIF）は変換成功後に自動削除
3. GitHub Pages デプロイ時にアイコンリスト（icons.json）を動的生成
4. GitHub Pages で自動デプロイ

**重要**: 元画像は変換後に自動削除され、リポジトリには最適化された PNG ファイルのみが残ります。

### 新しいカテゴリ追加

**自動化スクリプト使用（推奨）**:

Unix/Linux/macOS の場合:

```bash
# インタラクティブモード
./add-category.sh

# コマンドライン引数モード
./add-category.sh [カテゴリ名] [表示名] [説明] [カラーコード]

# 例
./add-category.sh azure "Microsoft Azure" "Azure サービスの公式アイコンコレクション" "#0078d4"

# カラーコード省略（デフォルト #000000 黒）
./add-category.sh my-category "My Category" "説明文"
```

Windows PowerShell の場合:

**⚠️ 注意**: PowerShell スクリプトは現在デバッグ中で、正しく動作しない場合があります。まずは Unix/Linux/macOS の Bash スクリプトをお試しください。

```powershell
# インタラクティブモード
.\add-category.ps1

# コマンドライン引数モード（名前付きパラメータ）
.\add-category.ps1 -CategoryName "azure" -DisplayName "Microsoft Azure" -Description "Azure サービスの公式アイコンコレクション" -ColorCode "#0078d4"

# カラーコード省略（デフォルト #000000 黒）
.\add-category.ps1 -CategoryName "my-category" -DisplayName "My Category" -Description "説明文"
```

**スクリプトの特徴:**

- **動的挿入**: マーカーコメント（🚨）を検索して適切な位置に自動挿入
- **カラーコードデフォルト値**: 未入力時は自動的に #000000（黒）を設定
- **エラーハンドリング**: カテゴリ名・カラーコード・重複の完全チェック
- **クロスプラットフォーム**: Unix/Linux/macOS（Bash）・Windows（PowerShell）対応
- **行番号ハードコーディング回避**: index.html の構造変更に自動対応

**重要**: スクリプト実行後も `.github/README.md` のカテゴリ表とソース表に新カテゴリの説明とソースを手動で追加してください。

**手動追加の場合**:

1. `mkdir [カテゴリ名]` でフォルダ作成
2. 画像ファイル（任意の形式）を配置
3. **重要**: メインページ（`index.html`）にカテゴリカードと CSS を手動追加
4. **重要**: `.github/README.md` のカテゴリ表とソース表に新カテゴリの説明とソースを追加
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
  - **検索結果アクション**: 各アイコンに直接 URL コピー・ダウンロードボタン
  - **即座操作**: カテゴリページ経由なしでアイコンを操作可能
  - **トースト通知**: 操作結果をリアルタイムフィードバック
- **UI**: 検索ボックス + ドロップダウン形式の結果表示（アクションボタン付き）

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

## TODO（将来の改善項目）

### ディレクトリ構造の変更

リポジトリ内のディレクトリ構造を変更し、GitHub Pages デプロイを最適化する：

**新しい構造案：**

```
icons-factory/
├── .github/                     # 既存のままで保持
├── src/                        # 新規：ソースファイル用フォルダ
│   ├── CLAUDE.md               # 移動
│   ├── add-category.ps1        # 移動
│   ├── add-category.sh         # 移動
│   ├── aws/                    # アイコンフォルダを移動
│   ├── [その他のカテゴリ]/
│   └── template/               # 移動
└── dist/                       # 新規：GitHub Pages公開用フォルダ
    ├── index.html              # srcから自動コピー
    ├── robots.txt              # srcから自動コピー
    ├── .nojekyll               # srcから自動コピー
    └── [処理済みカテゴリフォルダ]/
```

**作業内容：**

1. `src/` と `dist/` ディレクトリの作成
2. 既存ファイルを `src/` に移動
3. GitHub Actions ワークフローを新構造に対応（`src/` で処理して `dist/` にデプロイ）
4. GitHub Pages 設定を `dist/` フォルダからのみ公開するよう変更
5. `.gitignore` の更新（`dist/` を無視）
6. カテゴリ追加スクリプトを変更する
7. 関連するドキュメントを変更する

**効果：**

- 開発用ファイルと公開用ファイルの分離
- GitHub Pages には必要なファイルのみデプロイ
- リポジトリの整理とクリーンな公開サイト

**注意点：**

- プライバシー・SEO 設定は維持すること
- CALUDE.md をちゃんと読み込めるようにすること

### PowerShell スクリプト関連

- **add-category.ps1 の修正**: 現在デバッグ中で正しく動作しない可能性がある
  - ファイル操作（配列範囲、ファイル書き込み）の問題を解決
  - Bash スクリプトと完全に同じ動作になるよう修正
  - 引数処理の改善（位置パラメータと名前付きパラメータの両対応）
  - エラーハンドリングの強化
