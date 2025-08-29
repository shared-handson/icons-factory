# カテゴリ追加自動化スクリプト (PowerShell版)
# ⚠️ 注意: このスクリプトは現在デバッグ中で、正しく動作しない場合があります
# まずは add-category.sh (Bash版) をお試しください
# 使用方法: .\add-category.ps1 -CategoryName [カテゴリ名] -DisplayName [表示名] -Description [説明] -ColorCode [カラーコード]

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
    Write-Host "${BLUE}ℹ️  $Message${NC}" -NoNewline
    Write-Host ""
}

function Write-Success {
    param([string]$Message)
    Write-Host "${GREEN}✅ $Message${NC}" -NoNewline
    Write-Host ""
}

function Write-Warning {
    param([string]$Message)
    Write-Host "${YELLOW}⚠️  $Message${NC}" -NoNewline
    Write-Host ""
}

function Write-Error {
    param([string]$Message)
    Write-Host "${RED}❌ $Message${NC}" -NoNewline
    Write-Host ""
}

# 引数チェック（位置パラメータまたは名前付きパラメータの両方に対応）
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
} elseif ($args.Count -gt 0 -and [string]::IsNullOrEmpty($CategoryName)) {
    # 位置パラメータでの呼び出し
    $CategoryName = $args[0]
    $DisplayName = if ($args.Count -gt 1) { $args[1] } else { "" }
    $Description = if ($args.Count -gt 2) { $args[2] } else { "" }
    $ColorCode = if ($args.Count -gt 3) { $args[3] } else { "#000000" }
    
    # コマンドライン引数でカラーコードが未指定の場合
    if ($ColorCode -eq "#000000" -and $args.Count -lt 4) {
        Write-Info "カラーコードが未指定のため、デフォルト値 #000000 (黒) を使用します"
    }
} else {
    # 名前付きパラメータでの呼び出し
    if ([string]::IsNullOrEmpty($ColorCode)) {
        $ColorCode = "#000000"
        Write-Info "カラーコードが未指定のため、デフォルト値 #000000 (黒) を使用します"
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
$cssMarkerLine = -1
for ($i = 0; $i -lt $cssContent.Count; $i++) {
    if ($cssContent[$i] -match "🚨 新しいカテゴリを追加する場合は下記の形式でCSS追加 🚨") {
        $cssMarkerLine = $i + 1  # PowerShellは0ベース、行番号は1ベース
        break
    }
}

if ($cssMarkerLine -eq -1) {
    Write-Error "CSSマーカーコメントが見つかりません"
    exit 1
}

# マーカーコメントの直前に挿入（Bashスクリプトと同じ位置：marker - 2）
$cssInsertLine = $cssMarkerLine - 2

# CSSSスタイルを挿入
$cssToInsert = @(
    "      .$($CategoryName)::before {",
    "        background: $ColorCode;",
    "      }"
)

# ファイルの内容を取得し、指定位置に挿入
$content = Get-Content "index.html"
$newContent = @()

# 挿入位置より前の行
if ($cssInsertLine - 1 -ge 0) {
    $newContent += $content[0..($cssInsertLine - 1)]
}

# 挿入するCSS
$newContent += $cssToInsert

# 挿入位置以降の行
if ($cssInsertLine -lt $content.Count) {
    $newContent += $content[$cssInsertLine..($content.Count - 1)]
}

# ファイルに書き戻し（UTF8エンコーディング）
$newContent | Out-File "index.html" -Encoding utf8

Write-Success "CSSスタイルを追加しました (行番号: $cssInsertLine)"

# 3. index.htmlにカテゴリカードを追加
Write-Info "カテゴリカードを追加しています..."

# HTMLマーカーコメントの行番号を動的に取得
$htmlContent = Get-Content "index.html"
$htmlMarkerLine = -1
for ($i = 0; $i -lt $htmlContent.Count; $i++) {
    if ($htmlContent[$i] -match "🚨 新しいカテゴリを追加する場合は下記の形式でHTML編集 🚨") {
        $htmlMarkerLine = $i + 1  # PowerShellは0ベース、行番号は1ベース
        break
    }
}

if ($htmlMarkerLine -eq -1) {
    Write-Error "HTMLマーカーコメントが見つかりません"
    exit 1
}

# マーカーコメントの直前に挿入（Bashスクリプトと同じ位置：marker - 2）
$htmlInsertLine = $htmlMarkerLine - 2

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
    "          </a>"
)

# ファイルの内容を取得し、指定位置に挿入
$content = Get-Content "index.html"
$newContent = @()

# 挿入位置より前の行
if ($htmlInsertLine - 1 -ge 0) {
    $newContent += $content[0..($htmlInsertLine - 1)]
}

# 挿入するHTML
$newContent += $htmlToInsert

# 挿入位置以降の行
if ($htmlInsertLine -lt $content.Count) {
    $newContent += $content[$htmlInsertLine..($content.Count - 1)]
}

# ファイルに書き戻し（UTF8エンコーディング）
$newContent | Out-File "index.html" -Encoding utf8

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