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
| **Logo**       | 各社ロゴアイコン               |

## ✨ 特徴

- **🚀 高速**: GitHub Pages + 静的サイト生成
- **📋 簡単コピー**: ワンクリックで URL 取得
- **💾 強制ダウンロード**: 最適化 PNG 画像（ブラウザ表示なし）
- **🔄 自動変換**: 全画像形式（PNG/SVG/JPG/JPEG/GIF）を自動最適化
- **📏 サイズ最適化**: 長辺 512px・アスペクト比維持・縮小のみ
- **📱 レスポンシブ**: モバイル対応 UI
- **🔍 リアルタイム検索**:
  - **トップページ**: 全カテゴリ横断検索（全アイコンを一括検索）
    - **検索結果アクション**: 各アイコンにURLコピー・ダウンロードボタン付き
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
- **UI/UX機能**:
  - トースト通知システム
  - 検索結果インタラクション
  - ダウンロードプログレス表示

### バックエンド（GitHub Actions）

- **自動アイコン検出** - フォルダ内の PNG ファイルを自動スキャン
- **JSON 生成** - 各フォルダに icons.json を自動生成
- **検索インデックス生成** - 全カテゴリ統合の search-index.json を自動生成
- **メタデータ生成** - アイコン統計・カテゴリ情報の metadata.json を自動生成
- **GitHub Pages 自動デプロイ** - プッシュ時に自動更新

## 🚀 新しいカテゴリの追加方法

### 1. フォルダ作成とアイコン配置

```bash
# 例：Azureカテゴリを追加する場合
cp -r template/ azure/
cd azure/

# アイコンファイルを配置（全形式対応）
# PNG/SVG/JPG/JPEG/GIF ファイルをここに置く
# GitHub Actionsが自動で最適化します
```

### 2. メインページの更新（手動）

`index.html`のプラットフォームカードセクションに新しいカードを追加：

```html
<a href="./azure/" class="platform-card azure">
  <div class="platform-icon">AZ</div>
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
.azure .platform-icon {
  background: linear-gradient(135deg, #0078d4, #106ebe);
}
```

検索機能のカテゴリ表示名も更新：

```javascript
// getCategoryDisplayName 関数内に追加
'azure': 'Microsoft Azure'
```

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
├── .gitignore                   # 中間ファイルを除外
├── index.html                   # メインページ（グローバル検索機能付き）
├── search-index.json            # 全カテゴリ統合検索用（自動生成）
├── metadata.json                # アイコン統計情報（自動生成）
├── robots.txt                   # 検索エンジン除外設定
├── gcp/                         # GCP アイコンカテゴリ
│   ├── *.png                    # 最適化済みアイコン
│   ├── icons.json               # 自動生成アイコンリスト
│   └── index.html               # カテゴリページ（カテゴリ内検索機能付き、自動生成）
├── aws/                         # AWS アイコンカテゴリ
├── kubernetes/                  # Kubernetes アイコンカテゴリ
├── cncf/                        # CNCF アイコンカテゴリ
├── logo/                        # 各社ロゴカテゴリ
├── template/                    # 新カテゴリ用テンプレート
│   ├── index.html               # マスターテンプレート（検索・URL・DL機能統合）
│   └── README.md                # カテゴリ追加手順
└── .github/workflows/
    └── main.yml                 # 統合ワークフロー（画像変換・JSON生成・デプロイ）

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

## 📊 アイコンソース

| カテゴリ       | ソース                                                                            |
| -------------- | --------------------------------------------------------------------------------- |
| **AWS**        | [AWS Icons](https://aws-icons.com/)                                               |
| **GCP**        | [GCP Icons](https://gcpicons.com/)                                                |
| **Kubernetes** | [Kubernetes Community](https://github.com/kubernetes/community/tree/master/icons) |
| **CNCF**       | [CNCF Artwork](https://github.com/cncf/artwork/tree/main)                         |

## 🤝 コントリビューション

1. **Fork** このリポジトリ
2. **Feature branch** を作成 (`git checkout -b feature/amazing-feature`)
3. **Commit** 変更内容 (`git commit -m 'Add some amazing feature'`)
4. **Push** to branch (`git push origin feature/amazing-feature`)
5. **Pull Request** を作成

## 🔒 プライバシー・SEO 設定

### 検索エンジン対策（プライベート利用向け）

- **robots.txt**: 全ページアクセス禁止 (`Disallow: /`)
- **メタタグ**: `noindex, nofollow, noarchive, nosnippet` 設定
- **SEO メタ情報**: description、keywords、og:、twitter タグなし
- **sitemap.xml**: 存在しない（検索エンジンに構造を教えない）

### プライベート利用向け設計

- 検索エンジンに発見されない設定
- 外部サービス連携なし
- マーケティング要素なし

## 📝 ライセンス

個人・身内利用向けのプライベートプロジェクト

- 各アイコンは元のライセンスに従います
- 個人・商用利用可能なアイコンのみを収集
- 詳細は各プラットフォームの公式サイトをご確認ください

---

**🤖 Icons Factory - エンジニアのための、エンジニアによるアイコンギャラリー**
