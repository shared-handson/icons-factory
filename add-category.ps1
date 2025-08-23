# カテゴリ追加自動化スクリプト (PowerShell版)
# 使用方法: .\add-category.ps1 [カテゴリ名] [表示名] [説明] [カラーコード]

param(
    [string]$CategoryName = "",
    [string]$DisplayName = "",
    [string]$Description = "",
    [string]$ColorCode = ""
)

# エラーで停止
$ErrorActionPreference = "Stop"

# 色定義（PowerShell用ANSIエスケープシーケンス）
$RED = "`e[0;31m"
$GREEN = "`e[0;32m"
$YELLOW = "`e[1;33m"
$BLUE = "`e[0;34m"
$NC = "`e[0m"  # No Color

# ヘルパー関数
function Write-Info {
    param([string]$Message)
    Write-Host "${BLUE}ℹ️  $Message${NC}"
}

function Write-Success {
    param([string]$Message)
    Write-Host "${GREEN}✅ $Message${NC}"
}

function Write-Warning {
    param([string]$Message)
    Write-Host "${YELLOW}⚠️  $Message${NC}"
}

function Write-Error {
    param([string]$Message)
    Write-Host "${RED}❌ $Message${NC}"
}

# 引数チェック
if ($args.Count -eq 0 -and [string]::IsNullOrEmpty($CategoryName)) {
    Write-Info "Icons Factory カテゴリ追加スクリプト"
    Write-Host ""
    Write-Info "使用方法:"
    Write-Host "  .\add-category.ps1 [カテゴリ名] [表示名] [説明] [カラーコード]"
    Write-Host ""
    Write-Info "例:"
    Write-Host '  .\add-category.ps1 azure "Microsoft Azure" "Azure サービスの公式アイコンコレクション" "#0078d4"'
    Write-Host ""
    Write-Info "インタラクティブモード:"
    Write-Host "  .\add-category.ps1"
    Write-Host ""
    
    # インタラクティブモード
    $CategoryName = Read-Host "カテゴリ名（フォルダ名）"
    $DisplayName = Read-Host "表示名"
    $Description = Read-Host "説明"
    $ColorCodeInput = Read-Host "カラーコード（例: #0078d4、未入力で #000000）"
    
    # カラーコードが未入力の場合はデフォルトを設定
    if ([string]::IsNullOrEmpty($ColorCodeInput)) {
        $ColorCode = "#000000"
        Write-Info "カラーコードが未入力のため、デフォルト値 #000000 (黒) を使用します"
    } else {
        $ColorCode = $ColorCodeInput
    }
} else {
    # コマンドライン引数モード
    if ([string]::IsNullOrEmpty($ColorCode)) {
        $ColorCode = "#000000"
        
        # コマンドライン引数でカラーコードが未指定の場合
        if ($args.Count -lt 4) {
            Write-Info "カラーコードが未指定のため、デフォルト値 #000000 (黒) を使用します"
        }
    }
}

# 入力値検証（カラーコードは既にデフォルト値が設定済み）
if ([string]::IsNullOrEmpty($CategoryName) -or [string]::IsNullOrEmpty($DisplayName) -or [string]::IsNullOrEmpty($Description)) {
    Write-Error "カテゴリ名、表示名、説明は必須です"
    exit 1
}

# カテゴリ名の妥当性チェック（英数字とハイフンのみ）
if ($CategoryName -notmatch '^[a-z0-9-]+$') {
    Write-Error "カテゴリ名は小文字の英数字とハイフンのみ使用できます"
    exit 1
}

# カラーコードの妥当性チェック
if ($ColorCode -notmatch '^#[0-9a-fA-F]{6}$') {
    Write-Error "カラーコードは #RRGGBB 形式で入力してください（例: #0078d4）"
    exit 1
}

# 既存カテゴリとの重複チェック
if (Test-Path $CategoryName) {
    Write-Error "カテゴリ「$CategoryName」は既に存在します"
    exit 1
}

Write-Info "新しいカテゴリを追加します:"
Write-Host "  カテゴリ名: $CategoryName"
Write-Host "  表示名: $DisplayName"
Write-Host "  説明: $Description"
Write-Host "  カラーコード: $ColorCode"
Write-Host ""

$confirm = Read-Host "続行しますか？ (y/N)"
if ($confirm -notmatch '^[yY]$') {
    Write-Warning "キャンセルしました"
    exit 0
}

# 1. カテゴリフォルダを作成
Write-Info "カテゴリフォルダを作成しています..."
New-Item -ItemType Directory -Path $CategoryName -Force | Out-Null
Write-Success "カテゴリフォルダを作成しました: $CategoryName/"

# 2. index.htmlにCSSクラスを追加
Write-Info "CSSスタイルを追加しています..."

# CSSマーカーコメントの行番号を動的に取得
$cssContent = Get-Content "index.html"
$cssMarkerLine = 0
for ($i = 0; $i -lt $cssContent.Count; $i++) {
    if ($cssContent[$i] -match "🚨 新しいカテゴリを追加する場合は下記の形式でCSS追加 🚨") {
        $cssMarkerLine = $i + 1  # PowerShellは0ベース、行番号は1ベース
        break
    }
}

if ($cssMarkerLine -eq 0) {
    Write-Error "CSSマーカーコメントが見つかりません"
    exit 1
}

# マーカーコメントの直前に挿入
$cssInsertLine = $cssMarkerLine - 1
$cssToInsert = @(
    "",
    "      .$($CategoryName)::before {",
    "        background: $ColorCode;",
    "      }"
)

# ファイルの内容を取得し、指定位置に挿入
$content = Get-Content "index.html"
$newContent = @()
$newContent += $content[0..($cssInsertLine-2)]  # マーカーコメントより前の行
$newContent += $cssToInsert  # 挿入するCSS
$newContent += $content[($cssInsertLine-1)..($content.Count-1)]  # マーカーコメント以降の行

# ファイルに書き戻し
$newContent | Set-Content "index.html" -Encoding UTF8

Write-Success "CSSスタイルを追加しました (行番号: $cssInsertLine)"

# 3. index.htmlにカテゴリカードを追加
Write-Info "カテゴリカードを追加しています..."

# HTMLマーカーコメントの行番号を動的に取得
$htmlContent = Get-Content "index.html"
$htmlMarkerLine = 0
for ($i = 0; $i -lt $htmlContent.Count; $i++) {
    if ($htmlContent[$i] -match "🚨 新しいカテゴリを追加する場合は下記の形式でHTML編集 🚨") {
        $htmlMarkerLine = $i + 1  # PowerShellは0ベース、行番号は1ベース
        break
    }
}

if ($htmlMarkerLine -eq 0) {
    Write-Error "HTMLマーカーコメントが見つかりません"
    exit 1
}

# マーカーコメントの直前に挿入
$htmlInsertLine = $htmlMarkerLine - 1
$htmlToInsert = @(
    "          <a href=`"./$CategoryName/`" class=`"platform-card $CategoryName`">",
    "            <h2 class=`"platform-name`">$DisplayName</h2>",
    "            <p class=`"platform-description`">",
    "              $Description",
    "            </p>",
    "            <div class=`"platform-stats`">",
    "              <span class=`"icon-count`" data-category=`"$CategoryName`"",
    "                >... アイコン</span",
    "              >",
    "              <span class=`"visit-button`">探索する →</span>",
    "            </div>",
    "          </a>",
    ""
)

# ファイルの内容を取得し、指定位置に挿入
$content = Get-Content "index.html"
$newContent = @()
$newContent += $content[0..($htmlInsertLine-2)]  # マーカーコメントより前の行
$newContent += $htmlToInsert  # 挿入するHTML
$newContent += $content[($htmlInsertLine-1)..($content.Count-1)]  # マーカーコメント以降の行

# ファイルに書き戻し
$newContent | Set-Content "index.html" -Encoding UTF8

Write-Success "カテゴリカードを追加しました (行番号: $htmlInsertLine)"

# 4. 完了メッセージとNext Steps
Write-Host ""
Write-Success "カテゴリ「$CategoryName」の追加が完了しました！"
Write-Host ""
Write-Info "Next Steps:"
Write-Host "1. $CategoryName/ フォルダに画像ファイル（PNG/SVG/JPG/JPEG/GIF）を配置してください"
Write-Host "2. Git でコミットしてプッシュしてください:"
Write-Host "   git add -A"
Write-Host "   git commit -m `"✨ Add $CategoryName category`""
Write-Host "   git push"
Write-Host "3. GitHub Actions が自動実行され、以下が自動的に行われます："
Write-Host "   - 画像ファイルを PNG に変換・最適化"
Write-Host "   - template/index.html を各カテゴリにコピー"
Write-Host "   - icons.json、metadata.json、search-index.json を生成"
Write-Host "   - GitHub Pages にデプロイ"
Write-Host ""
Write-Info "ファイル構造:"
Write-Host "  $CategoryName/"
Write-Host "  └── （ここに画像ファイルを配置）"