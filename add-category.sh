#!/bin/bash

# カテゴリ追加自動化スクリプト
# 使用方法: ./add-category.sh [カテゴリ名] [表示名] [説明] [カラーコード]

set -e

# 色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ヘルパー関数
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 引数チェック
if [ "$#" -eq 0 ]; then
    print_info "Icons Factory カテゴリ追加スクリプト"
    echo
    print_info "使用方法:"
    echo "  $0 [カテゴリ名] [表示名] [説明] [カラーコード]"
    echo
    print_info "例:"
    echo "  $0 azure \"Microsoft Azure\" \"Azure サービスの公式アイコンコレクション\" \"#0078d4\""
    echo
    print_info "インタラクティブモード:"
    echo "  $0"
    echo
    
    # インタラクティブモード
    read -p "カテゴリ名（フォルダ名）: " category_name
    read -p "表示名: " display_name
    read -p "説明: " description
    read -p "カラーコード（例: #0078d4）: " color_code
else
    category_name=$1
    display_name=$2
    description=$3
    color_code=$4
fi

# 入力値検証
if [ -z "$category_name" ] || [ -z "$display_name" ] || [ -z "$description" ] || [ -z "$color_code" ]; then
    print_error "すべての値を入力してください"
    exit 1
fi

# カテゴリ名の妥当性チェック（英数字とハイフンのみ）
if [[ ! "$category_name" =~ ^[a-z0-9-]+$ ]]; then
    print_error "カテゴリ名は小文字の英数字とハイフンのみ使用できます"
    exit 1
fi

# カラーコードの妥当性チェック
if [[ ! "$color_code" =~ ^#[0-9a-fA-F]{6}$ ]]; then
    print_error "カラーコードは #RRGGBB 形式で入力してください（例: #0078d4）"
    exit 1
fi

# 既存カテゴリとの重複チェック
if [ -d "$category_name" ]; then
    print_error "カテゴリ「$category_name」は既に存在します"
    exit 1
fi

print_info "新しいカテゴリを追加します:"
echo "  カテゴリ名: $category_name"
echo "  表示名: $display_name"
echo "  説明: $description"
echo "  カラーコード: $color_code"
echo

read -p "続行しますか？ (y/N): " confirm
if [[ ! "$confirm" =~ ^[yY]$ ]]; then
    print_warning "キャンセルしました"
    exit 0
fi

# 1. カテゴリフォルダを作成
print_info "カテゴリフォルダを作成しています..."
mkdir -p "$category_name"
print_success "カテゴリフォルダを作成しました: $category_name/"

# 2. index.htmlにCSSクラスを追加
print_info "CSSスタイルを追加しています..."

# CSSコメントの前に挿入
sed -i "172a\\
      .$category_name::before {\\
        background: $color_code;\\
      }\\
" index.html

print_success "CSSスタイルを追加しました"

# 3. index.htmlにカテゴリカードを追加
print_info "カテゴリカードを追加しています..."

# HTMLコメントの前に挿入
sed -i "602a\\
          <a href=\"./$category_name/\" class=\"platform-card $category_name\">\\
            <h2 class=\"platform-name\">$display_name</h2>\\
            <p class=\"platform-description\">\\
              $description\\
            </p>\\
            <div class=\"platform-stats\">\\
              <span class=\"icon-count\" data-category=\"$category_name\"\\
                >... アイコン</span\\
              >\\
              <span class=\"visit-button\">探索する →</span>\\
            </div>\\
          </a>\\
" index.html

print_success "カテゴリカードを追加しました"

# 4. 完了メッセージとNext Steps
echo
print_success "カテゴリ「$category_name」の追加が完了しました！"
echo
print_info "Next Steps:"
echo "1. $category_name/ フォルダに画像ファイル（PNG/SVG/JPG/JPEG/GIF）を配置してください"
echo "2. Git でコミットしてプッシュしてください:"
echo "   git add -A"
echo "   git commit -m \"✨ Add $category_name category\""
echo "   git push"
echo "3. GitHub Actions が自動実行され、以下が自動的に行われます："
echo "   - 画像ファイルを PNG に変換・最適化"
echo "   - template/index.html を各カテゴリにコピー"
echo "   - icons.json、metadata.json、search-index.json を生成"
echo "   - GitHub Pages にデプロイ"
echo
print_info "ファイル構造:"
echo "  $category_name/"
echo "  └── （ここに画像ファイルを配置）"