# Icons Factory

開発・インフラで使うアイコンを集めたドキュメントサイト

![GitHub Pages](https://img.shields.io/github/deployments/icons-factory/icons-factory/github-pages?label=GitHub%20Pages)
![Icons Count](https://img.shields.io/badge/icons-1000+-blue)
![License](https://img.shields.io/badge/license-Free%20to%20Use-green)

## 🌟 概要

作図やプレゼンテーションで使える高品質なアイコンギャラリーです。GitHub Pagesで公開し、ワンクリックでアイコンのURLコピーやダウンロードが可能です。

**🔗 サイトURL**: https://icons-factory.github.io/icons-factory/

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
- **💾 直接ダウンロード**: 高解像度PNG画像
- **🔄 自動更新**: GitHub Actions による動的管理
- **📱 レスポンシブ**: モバイル対応UI
- **🚫 ハードコーディングなし**: 完全動的なアイコン管理
- **🎯 拡張可能**: 新しいカテゴリを簡単に追加可能

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
- **トリガー**: `*/*.png`ファイルの変更を検知
- **処理**: 全フォルダをスキャンしてicons.jsonを生成
- **デプロイ**: GitHub Pagesに自動公開

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

## 📝 ライセンス

各アイコンは元のライセンスに従います。
- 個人・商用利用可能なアイコンのみを収集
- 詳細は各プラットフォームの公式サイトをご確認ください

## 🏷️ タグ

`icons` `gcp` `aws` `kubernetes` `cncf` `infrastructure` `devops` `github-pages` `free-icons` `development` `cloud-icons`

---

**🤖 Icons Factory - エンジニアのための、エンジニアによるアイコンギャラリー**
