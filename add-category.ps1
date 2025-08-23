#!/usr/bin/env pwsh

# カテゴリ追加自動化スクリプト（PowerShell版）
# 使用方法: .\add-category.ps1 [カテゴリ名] [表示名] [説明] [カラーコード]

param(
    [string]$CategoryName,
    [string]$DisplayName,
    [string]$Description,
    [string]$ColorCode
)

# エラー時に停止
$ErrorActionPreference = "Stop"

# ヘルパー関数
function Print-Info {
    param([string]$Message)
    Write-Host "ℹ️  $Message" -ForegroundColor Blue
}

function Print-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Print-Warning {
    param([string]$Message)
    Write-Host "⚠️  $Message" -ForegroundColor Yellow
}

function Print-Error {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor Red
}

# 引数チェック
if (-not $CategoryName -and -not $DisplayName -and -not $Description -and -not $ColorCode) {
    Print-Info "Icons Factory カテゴリ追加スクリプト"
    Write-Host ""
    Print-Info "使用方法:"
    Write-Host "  .\add-category.ps1 [カテゴリ名] [表示名] [説明] [カラーコード]"
    Write-Host ""
    Print-Info "例:"
    Write-Host '  .\add-category.ps1 azure "Microsoft Azure" "Azure サービスの公式アイコンコレクション" "#0078d4"'
    Write-Host ""
    Print-Info "インタラクティブモード:"
    Write-Host "  .\add-category.ps1"
    Write-Host ""
    
    # インタラクティブモード
    $CategoryName = Read-Host "カテゴリ名（フォルダ名）"
    $DisplayName = Read-Host "表示名"
    $Description = Read-Host "説明"
    $ColorCode = Read-Host "カラーコード（例: #0078d4）"
}

# 入力値検証
if (-not $CategoryName -or -not $DisplayName -or -not $Description -or -not $ColorCode) {
    Print-Error "すべての値を入力してください"
    exit 1
}

# カテゴリ名の妥当性チェック（英数字とハイフンのみ）
if ($CategoryName -notmatch "^[a-z0-9-]+$") {
    Print-Error "カテゴリ名は小文字の英数字とハイフンのみ使用できます"
    exit 1
}

# カラーコードの妥当性チェック
if ($ColorCode -notmatch "^#[0-9a-fA-F]{6}$") {
    Print-Error "カラーコードは #RRGGBB 形式で入力してください（例: #0078d4）"
    exit 1
}

# 既存カテゴリとの重複チェック
if (Test-Path $CategoryName) {
    Print-Error "カテゴリ「$CategoryName」は既に存在します"
    exit 1
}

Print-Info "新しいカテゴリを追加します:"
Write-Host "  カテゴリ名: $CategoryName"
Write-Host "  表示名: $DisplayName"
Write-Host "  説明: $Description"
Write-Host "  カラーコード: $ColorCode"
Write-Host ""

$confirm = Read-Host "続行しますか？ (y/N)"
if ($confirm -notmatch "^[yY]$") {
    Print-Warning "キャンセルしました"
    exit 0
}

# 1. カテゴリフォルダを作成
Print-Info "カテゴリフォルダを作成しています..."
New-Item -Path $CategoryName -ItemType Directory -Force | Out-Null
Print-Success "カテゴリフォルダを作成しました: $CategoryName/"

# 2. index.htmlにCSSクラスを追加
Print-Info "CSSスタイルを追加しています..."

# index.htmlの内容を読み込み
$indexContent = Get-Content "index.html" -Encoding UTF8

# 172行目の後にCSSを挿入
$newCssLines = @(
    "      .$CategoryName::before {",
    "        background: $ColorCode;",
    "      }"
)

$updatedContent = @()
for ($i = 0; $i -lt $indexContent.Length; $i++) {
    $updatedContent += $indexContent[$i]
    if ($i -eq 171) {  # 172行目の後（0ベースなので171）
        $updatedContent += $newCssLines
    }
}

# ファイルに書き戻し
$updatedContent | Out-File "index.html" -Encoding UTF8
Print-Success "CSSスタイルを追加しました"

# 3. index.htmlにカテゴリカードを追加
Print-Info "カテゴリカードを追加しています..."

# 再度index.htmlの内容を読み込み（CSSが追加されているため）
$indexContent = Get-Content "index.html" -Encoding UTF8

# 602行目の後にHTMLを挿入（CSS追加分を考慮して調整）
$newHtmlLines = @(
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

$updatedContent = @()
for ($i = 0; $i -lt $indexContent.Length; $i++) {
    $updatedContent += $indexContent[$i]
    # CSS追加分（3行）を考慮して602 + 3 = 605行目の後
    if ($i -eq 604) {
        $updatedContent += $newHtmlLines
    }
}

# ファイルに書き戻し
$updatedContent | Out-File "index.html" -Encoding UTF8
Print-Success "カテゴリカードを追加しました"

# 4. 完了メッセージとNext Steps
Write-Host ""
Print-Success "カテゴリ「$CategoryName」の追加が完了しました！"
Write-Host ""
Print-Info "Next Steps:"
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
Print-Info "ファイル構造:"
Write-Host "  $CategoryName/"
Write-Host "  └── （ここに画像ファイルを配置）"