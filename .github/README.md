# Icons Factory

開発・インフラで使うアイコンを集めたプライベートドキュメントサイト

![GitHub Pages](https://img.shields.io/github/deployments/shared-handson/icons-factory/github-pages?label=GitHub%20Pages)
![Icons Count](https://img.shields.io/badge/icons-1000+-blue)
![Privacy](https://img.shields.io/badge/privacy-Private%20Use-red)

## 🌟 概要

個人・身内利用向けの高品質なアイコンギャラリーです。GitHub Pagesで公開し、ワンクリックでアイコンのURLコピーやダウンロードが可能です。検索エンジンからは隠蔽されています。

**🔗 サイトURL**: https://shared-handson.github.io/icons-factory/

## 📦 アイコンカテゴリ

| カテゴリ | アイコン数 | 説明 |
|---|---|---|
| **GCP** | 238+ | Google Cloud Platform サービス |
| **AWS** | 300+ | Amazon Web Services サービス |
| **Kubernetes** | 50+ | Kubernetes リソース |
| **CNCF** | 197+ | Cloud Native プロジェクト |

## ✨ 特徴

- **🚀 高速**: GitHub Pages + 静的サイト生成
- **📋 簡単コピー**: ワンクリックでURL取得
- **💾 強制ダウンロード**: 高解像度PNG画像（ブラウザ表示なし）
- **🔄 自動更新**: GitHub Actions による動的管理
- **📱 レスポンシブ**: モバイル対応UI
- **🚫 ハードコーディングなし**: 完全動的なアイコン管理
- **🎯 拡張可能**: 新しいカテゴリを簡単に追加可能
- **🔒 プライベート**: 検索エンジンからの隠蔽設定済み

## 🏗️ 技術構成

### フロントエンド
- **Pure HTML/CSS/JavaScript** - フレームワーク不使用
- **レスポンシブデザイン** - CSS Grid + Flexbox
- **モダンブラウザ対応** - ES6+

### バックエンド（GitHub Actions）
- **自動アイコン検出** - フォルダ内のPNGファイルを自動スキャン
- **JSON生成** - 各フォルダにicons.jsonを自動生成
- **GitHub Pages自動デプロイ** - プッシュ時に自動更新

## 🚀 新しいカテゴリの追加方法

### 1. フォルダ作成とアイコン配置
```bash
# テンプレートをコピー
cp -r template/ azure/
cd azure/

# 不要ファイルを削除
rm sample-icon.png .gitkeep

# アイコンファイル（*.png）を配置
# これだけでGitHub Actionsが自動実行されます
```

### 2. メインページの更新
`index.html`にカードを追加：
```html
<a href="./azure/" class="platform-card azure">
    <div class="platform-icon">AZ</div>
    <h2 class="platform-name">Microsoft Azure</h2>
    <p class="platform-description">Azureサービスの公式アイコンCollection</p>
    <div class="platform-stats">
        <span class="icon-count">100+ アイコン</span>
        <span class="visit-button">探索する →</span>
    </div>
</a>
```

対応するCSSも追加：
```css
.azure::before { background: #0078d4; }
.azure .platform-icon { background: linear-gradient(135deg, #0078d4, #106ebe); }
```

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
#### 1. SVG→PNG変換ワークフロー (`convert-svg-to-png.yml`)
- **トリガー**: `*/*.svg`ファイルの変更を検知
- **処理**: Inkscapeで512x512pxのPNGに変換
- **クリーンアップ**: 変換成功後に元SVGファイルを自動削除
- **DRY原則**: 共通の除外ロジック関数 `should_skip_folder()` 使用

#### 2. アイコンリスト生成ワークフロー (`generate-icon-list.yml`)
- **トリガー**: `*/*.png`ファイルの変更を検知
- **処理**: 全フォルダをスキャンしてicons.jsonを生成（PNGのみ対象）
- **DRY原則**: SVG変換ワークフローと共通の除外ロジック使用

#### 3. GitHub Pagesデプロイワークフロー (`deploy-pages.yml`)
- **トリガー**: mainブランチへのプッシュ
- **処理**: 静的サイトの自動デプロイ
- **通知**: デプロイ完了の自動通知

## 📂 ディレクトリ構造

```
icons-factory/
├── index.html                    # メインページ
├── gcp/                         # GCP アイコンカテゴリ
│   ├── *.png
│   ├── index.html               # 自動生成ページ
│   └── icons.json               # 自動生成リスト
├── aws/                         # AWS アイコンカテゴリ
├── kubernetes/                  # Kubernetes アイコンカテゴリ
├── cncf/                        # CNCF アイコンカテゴリ
├── template/                    # 新カテゴリ用テンプレート
└── .github/workflows/           # GitHub Actions
```

## 📋 ルール・規約

### ファイル名規約
- **使用可能文字**: 英数字、ハイフン(`-`)、アンダースコア(`_`)、ドット(`.`)
- **形式**: PNG画像のみ
- **例**: `cloud-storage.png`, `compute_engine.png`

### 開発ルール
- **ファイル名ハードコーディング禁止**: すべて動的に取得
- **レスポンシブデザイン必須**: モバイルファースト
- **エラーハンドリング必須**: ネットワークエラー対応

## 📊 アイコンソース

| カテゴリ | ソース |
|---|---|
| **AWS** | [AWS Icons](https://aws-icons.com/) |
| **GCP** | [GCP Icons](https://gcpicons.com/) |
| **Kubernetes** | [Kubernetes Community](https://github.com/kubernetes/community/tree/master/icons) |
| **CNCF** | [CNCF Artwork](https://github.com/cncf/artwork/tree/main) |

## 🤝 コントリビューション

1. **Fork** このリポジトリ
2. **Feature branch** を作成 (`git checkout -b feature/amazing-feature`)
3. **Commit** 変更内容 (`git commit -m 'Add some amazing feature'`)
4. **Push** to branch (`git push origin feature/amazing-feature`)
5. **Pull Request** を作成

## 🔒 プライバシー・SEO設定

### 検索エンジン対策（プライベート利用向け）
- **robots.txt**: 全ページアクセス禁止 (`Disallow: /`)
- **メタタグ**: `noindex, nofollow, noarchive, nosnippet` 設定
- **SEOメタ情報**: description、keywords、og:、twitterタグなし
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

## 🏷️ タグ

`icons` `gcp` `aws` `kubernetes` `cncf` `infrastructure` `devops` `github-pages` `free-icons` `development` `cloud-icons`

---

**🤖 Icons Factory - エンジニアのための、エンジニアによるアイコンギャラリー**
