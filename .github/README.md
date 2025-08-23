# Icons Factory

開発・インフラで使うアイコンを集めたプライベートドキュメントサイト

## 🌟 概要

個人・身内利用向けの高品質なアイコンギャラリーです。GitHub Pages で公開し、ワンクリックでアイコンの URL コピーやダウンロードが可能です。検索エンジンからは隠蔽されています。

**🔗 サイト URL**: https://shared-handson.github.io/icons-factory/

## 📦 アイコンカテゴリ

| カテゴリ       | 説明                           |
| -------------- | ------------------------------ |
| **GCP**        | Google Cloud Platform サービス |
| **AWS**        | Amazon Web Services サービス   |
| **Kubernetes** | Kubernetes リソース            |
| **CNCF**       | Cloud Native プロジェクト      |
| **Commons**    | カテゴライズできない細かいアイコン |

## 📊 アイコンソース

| カテゴリ       | ソース                                                           |
| -------------- | ---------------------------------------------------------------- |
| **AWS**        | [AWS Icons](https://aws-icons.com/)                              |
| **GCP**        | [GCP Icons](https://gcpicons.com/)                               |
| **Kubernetes** | [Kubernetes Community](https://github.com/kubernetes/community/) |
| **CNCF**       | [CNCF Artwork](https://github.com/cncf/artwork/)                 |
| **Commons**    | 各種オープンソースプロジェクト・企業ロゴ                        |

## ✨ 特徴

- **🚀 高速**: GitHub Pages + 静的サイト生成
- **📋 簡単コピー**: ワンクリックで URL 取得
- **💾 強制ダウンロード**: 最適化 PNG 画像（ブラウザ表示なし）
- **🔄 自動変換**: 全画像形式（PNG/SVG/JPG/JPEG/GIF）を自動最適化
- **📏 サイズ最適化**: 長辺 512px・アスペクト比維持・縮小のみ
- **🖼️ アスペクト比保持**: 正方形以外のアイコンも歪まずに表示
- **👁️ 視認性改善**: 薄い灰色背景で白いアイコンも見やすく
- **📐 サイズ表示**: 各アイコンの実際のピクセルサイズを表示
- **📱 レスポンシブ**: モバイル対応 UI
- **🔍 リアルタイム検索**:
  - **トップページ**: 全カテゴリ横断検索（全アイコンを一括検索）
    - **検索結果アクション**: 各アイコンに URL コピー・ダウンロードボタン付き
    - **直接操作**: カテゴリページ経由なしで即座にアイコンを操作可能
  - **各カテゴリページ**: カテゴリ内絞り込み検索
  - **検索機能**: 300ms デバウンス、ハイライト表示、検索統計
  - **トースト通知**: 操作結果を視覚的にフィードバック
- **🚫 ハードコーディングなし**: 完全動的なアイコン管理
- **🎯 拡張可能**: 新しいカテゴリを簡単に追加可能
- **🔒 プライベート**: 検索エンジンからの隠蔽設定済み

## 🏗️ 技術構成

### フロントエンド

- **Pure HTML/CSS/JavaScript** - フレームワーク不使用
- **レスポンシブデザイン** - CSS Grid + Flexbox
- **モダンブラウザ対応** - ES6+、Clipboard API、Fetch API、Blob API
- **UI/UX 機能**:
  - トースト通知システム
  - 検索結果インタラクション
  - ダウンロードプログレス表示
  - アイコンサイズ表示（実ピクセル）
  - アスペクト比保持表示
  - 視認性最適化（薄い灰色背景）

### バックエンド（GitHub Actions）

- **自動アイコン検出** - フォルダ内の PNG ファイルを自動スキャン
- **JSON 生成** - 各フォルダに icons.json を自動生成
- **検索インデックス生成** - 全カテゴリ統合の search-index.json を自動生成
- **メタデータ生成** - アイコン統計・カテゴリ情報の metadata.json を自動生成
- **GitHub Pages 自動デプロイ** - プッシュ時に自動更新

## 🚀 新しいカテゴリの追加方法

### 🤖 自動化スクリプト使用（推奨）

**Unix/Linux/macOS の場合:**

```bash
# インタラクティブモード
./add-category.sh

# コマンドライン引数モード
./add-category.sh [カテゴリ名] [表示名] [説明] [カラーコード]

# 例：Azureカテゴリを追加
./add-category.sh azure "Microsoft Azure" "Azure サービスの公式アイコンコレクション" "#0078d4"
```

**Windows の場合:**

```cmd
# インタラクティブモード
add-category.bat

# コマンドライン引数モード
add-category.bat [カテゴリ名] [表示名] [説明] [カラーコード]

# 例：Azureカテゴリを追加
add-category.bat azure "Microsoft Azure" "Azure サービスの公式アイコンコレクション" "#0078d4"
```

**重要**: スクリプト実行後も `.github/README.md` のカテゴリ表とソース表に新カテゴリの説明とソースを手動で追加してください。

**スクリプトが自動実行する内容:**

- ✅ カテゴリフォルダ作成
- ✅ CSS スタイル追加（カラー指定）
- ✅ HTML カード追加
- ✅ 入力値検証とエラーハンドリング

### 📝 手動追加の場合

### 1. フォルダ作成とアイコン配置

```bash
# 例：Azureカテゴリを追加する場合
mkdir azure/

# アイコンファイルを配置（全形式対応）
# PNG/SVG/JPG/JPEG/GIF ファイルをここに置く
# GitHub Actionsが自動で最適化します
```

### 2. メインページの更新（手動）

`index.html`のプラットフォームカードセクションに新しいカードを追加：

**重要**: `.github/README.md` のカテゴリ表とソース表に新カテゴリの説明とソースも追加してください。

```html
<a href="./azure/" class="platform-card azure">
  <h2 class="platform-name">Microsoft Azure</h2>
  <p class="platform-description">Azureサービスの公式アイコンCollection</p>
  <div class="platform-stats">
    <span class="icon-count" data-category="azure">... アイコン</span>
    <span class="visit-button">探索する →</span>
  </div>
</a>
```

対応する CSS クラスも追加：

```css
.azure::before {
  background: #0078d4;
}
```

検索機能では自動的にフォルダ名が表示されます。

### 3. 自動化された機能

✅ **画像変換**: 全形式（PNG/SVG/JPG/JPEG/GIF）を最適化 PNG 変換  
✅ **サイズ最適化**: 長辺 512px・アスペクト比維持・縮小のみ  
✅ **HTML 配布**: template/index.html をデプロイ時に各カテゴリにコピー  
✅ **タイトル生成**: フォルダ名から自動でページタイトル生成  
✅ **GitHub Actions**: 全フォルダを自動検知（設定変更不要）  
✅ **JSON 生成**: アイコンリストを自動生成・更新  
✅ **検索インデックス**: 全カテゴリ統合検索用データを自動生成

### 4. 完成後の確認事項

- [ ] フォルダ名が適切か
- [ ] 画像ファイル（PNG/SVG/JPG/JPEG/GIF）が配置されているか
- [ ] メインページ（`/index.html`）にカードを追加したか
- [ ] GitHub Actions ワークフローが正常実行されたか
- [ ] デプロイ後にサイトが正しく表示されるか

### ⚠️ 重要な注意事項

#### template/index.html について

- このフォルダの`index.html`は**マスターテンプレート**です
- デプロイ時に自動で各カテゴリフォルダにコピーされます
- 各カテゴリで個別に index.html を編集する必要はありません
- UI を変更したい場合は`template/index.html`のみを編集してください

#### GitHub Actions ワークフロー

- `main.yml`が全処理を統合して実行します
- 画像変換・リスト生成・デプロイが一括で完了します
- ワークフローの設定変更は不要です

## 🔧 開発・運用

### ローカル開発

```bash
# リポジトリクローン
git clone https://github.com/icons-factory/icons-factory.git
cd icons-factory

# ローカルサーバー起動（例：Python）
python -m http.server 8000
# またはNode.js
npx serve
```

### GitHub Actions

#### 統合ワークフロー (`main.yml`)

- **トリガー**: main ブランチへのプッシュ（全ファイル）
- **画像変換**:
  - SVG: Inkscape 使用、長辺 512px・アスペクト比維持・縮小のみ
  - JPG/JPEG/GIF: ImageMagick 使用、長辺 512px・アスペクト比維持・縮小のみ
- **自動削除**: 変換成功後に元ファイル（SVG/JPG/JPEG/GIF）を削除
- **リスト生成**: 各フォルダの icons.json を自動生成
- **検索インデックス生成**: 全カテゴリ統合の search-index.json を自動生成
- **テンプレート配布**: デプロイ前に template/index.html を各カテゴリにコピー
- **自動デプロイ**: GitHub Pages 自動公開

## 📂 ディレクトリ構造

```
icons-factory/
├── .gitattributes               # GitHub言語検出・バイナリファイル制限
├── .gitignore                   # 中間ファイルを除外
├── .nojekyll                    # Jekyll処理無効化（GitHub Pages用）
├── CLAUDE.md                    # Claude Code用プロジェクト指示
├── add-category.sh              # カテゴリ追加自動化スクリプト（Unix/Linux/macOS）
├── add-category.bat             # カテゴリ追加自動化スクリプト（Windows）
├── index.html                   # メインページ（グローバル検索機能付き）
├── robots.txt                   # 検索エンジン除外設定（サイト・リポジトリ両方）
├── search-index.json            # 全カテゴリ統合検索用（自動生成）
├── metadata.json                # アイコン統計情報（自動生成）
├── [カテゴリ名]/                # アイコンカテゴリフォルダ
│   ├── *.png                    # 最適化済みアイコン
│   ├── icons.json               # 自動生成アイコンリスト
│   └── index.html               # カテゴリページ（カテゴリ内検索機能付き、自動生成）
├── [その他のカテゴリ]/          # 各アイコンカテゴリ（動的に追加可能）
├── template/                    # 新カテゴリ用テンプレート
│   ├── index.html               # マスターテンプレート（検索・URL・DL機能統合）
│   └── README.md                # カテゴリ追加手順
└── .github/
    ├── README.md                # プロジェクト説明（このファイル）
    └── workflows/
        └── main.yml             # 統合ワークフロー（画像変換・JSON生成・デプロイ）

注意: icons.json、search-index.json、metadata.json、*/index.html は
      デプロイ時のみ生成される中間ファイルです
```

## 📋 ルール・規約

### ファイル名規約

- **使用可能文字**: 英数字、ハイフン(`-`)、アンダースコア(`_`)、ドット(`.`)
- **対応形式**: PNG/SVG/JPG/JPEG/GIF（自動で PNG に最適化）
- **例**: `cloud-storage.svg`, `compute_engine.jpg`, `database.png`

### 開発ルール

- **ファイル名ハードコーディング禁止**: すべて動的に取得
- **レスポンシブデザイン必須**: モバイルファースト
- **エラーハンドリング必須**: ネットワークエラー対応

## 🤝 コントリビューション

1. **Fork** このリポジトリ
2. **Feature branch** を作成 (`git checkout -b feature/amazing-feature`)
3. **Commit** 変更内容 (`git commit -m 'Add some amazing feature'`)
4. **Push** to branch (`git push origin feature/amazing-feature`)
5. **Pull Request** を作成

## 🔒 プライバシー・SEO 設定

### 検索エンジン対策（プライベート利用向け）

**GitHub Pages サイト隠蔽:**

- **robots.txt**: 全ページアクセス禁止 (`Disallow: /`)
- **メタタグ**: `noindex, nofollow, noarchive, nosnippet` 設定
- **SEO メタ情報**: description、keywords、og:、twitter タグなし
- **sitemap.xml**: 存在しない（検索エンジンに構造を教えない）

**GitHub リポジトリ隠蔽:**

- **.nojekyll**: Jekyll 処理を無効化、静的ファイル扱い
- **.gitattributes**: 言語検出制限、バイナリファイル検索除外
- **robots.txt**: GitHub ページ用の追加隠蔽設定
  ```
  Disallow: /*.git*
  Disallow: /README.md
  Disallow: /.github/
  ```

### プライベート利用向け設計

- **二重隠蔽**: サイト + リポジトリ両方を検索から隠蔽
- **外部サービス連携なし**: トラッキング・解析なし
- **マーケティング要素なし**: 完全プライベート仕様

## 📝 ライセンス

個人・身内利用向けのプライベートプロジェクト

- 各アイコンは元のライセンスに従います
- 個人・商用利用可能なアイコンのみを収集
- 詳細は各プラットフォームの公式サイトをご確認ください

---

**🤖 Icons Factory - エンジニアのための、エンジニアによるアイコンギャラリー**
