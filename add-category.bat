@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

REM デバッグモード（問題解決後にコメントアウト）
echo デバッグ: スクリプト開始

REM 引数チェック
echo デバッグ: 引数1=[%~1]
echo デバッグ: 引数2=[%~2]
echo デバッグ: 引数3=[%~3]
echo デバッグ: 引数4=[%~4]

if "%~1"=="" (
    echo ℹ️  Icons Factory カテゴリ追加スクリプト
    echo.
    echo ℹ️  使用方法:
    echo   %~nx0 [カテゴリ名] [表示名] [説明] [カラーコード]
    echo.
    echo ℹ️  例:
    echo   %~nx0 azure "Microsoft Azure" "Azure サービスの公式アイコンコレクション" "#0078d4"
    echo.
    echo ℹ️  インタラクティブモード:
    echo   %~nx0
    echo.
    
    REM インタラクティブモード
    set /p "category_name=カテゴリ名（フォルダ名）: "
    set /p "display_name=表示名: "
    set /p "description=説明: "
    set /p "color_code=カラーコード（例: #0078d4）: "
    echo デバッグ: インタラクティブ入力完了
) else (
    set "category_name=%~1"
    set "display_name=%~2"
    set "description=%~3"
    set "color_code=%~4"
    echo デバッグ: コマンドライン引数使用
)

REM 入力値検証
echo デバッグ: 入力値検証開始
echo デバッグ: category_name=[%category_name%]
echo デバッグ: display_name=[%display_name%]
echo デバッグ: description=[%description%]
echo デバッグ: color_code=[%color_code%]

if "%category_name%"=="" (
    echo ❌ カテゴリ名を入力してください
    pause
    exit /b 1
)
if "%display_name%"=="" (
    echo ❌ 表示名を入力してください
    pause
    exit /b 1
)
if "%description%"=="" (
    echo ❌ 説明を入力してください
    pause
    exit /b 1
)
if "%color_code%"=="" (
    echo ❌ カラーコードを入力してください
    pause
    exit /b 1
)

REM PowerShellで妥当性チェック
powershell -NoProfile -ExecutionPolicy Bypass -Command "& { ^
    $categoryName = \"%category_name%\"; ^
    $colorCode = \"%color_code%\"; ^
    ^
    # カテゴリ名の妥当性チェック（英数字とハイフンのみ） ^
    if ($categoryName -notmatch '^[a-z0-9-]+$') { ^
        Write-Host 'エラー: カテゴリ名は小文字の英数字とハイフンのみ使用できます' -ForegroundColor Red; ^
        exit 1; ^
    } ^
    ^
    # カラーコードの妥当性チェック ^
    if ($colorCode -notmatch '^#[0-9a-fA-F]{6}$') { ^
        Write-Host 'エラー: カラーコードは #RRGGBB 形式で入力してください（例: #0078d4）' -ForegroundColor Red; ^
        exit 1; ^
    } ^
    Write-Host '入力値の検証に成功しました' -ForegroundColor Green; ^
}"

if errorlevel 1 (
    echo 入力値検証に失敗しました
    pause
    exit /b 1
)

echo デバッグ: PowerShell検証完了

REM 既存カテゴリとの重複チェック
if exist "%category_name%" (
    echo ❌ カテゴリ「%category_name%」は既に存在します
    exit /b 1
)

echo ℹ️  新しいカテゴリを追加します:
echo   カテゴリ名: %category_name%
echo   表示名: %display_name%
echo   説明: %description%
echo   カラーコード: %color_code%
echo.

set /p confirm="続行しますか？ (y/N): "
if not "%confirm%"=="y" if not "%confirm%"=="Y" (
    echo ⚠️  キャンセルしました
    exit /b 0
)

REM 1. カテゴリフォルダを作成
echo ℹ️  カテゴリフォルダを作成しています...
mkdir "%category_name%" 2>nul
if errorlevel 1 (
    echo ❌ カテゴリフォルダの作成に失敗しました
    exit /b 1
)
echo ✅ カテゴリフォルダを作成しました: %category_name%/

REM 2. index.htmlにCSSクラスを追加
echo ℹ️  CSSスタイルを追加しています...

powershell -NoProfile -ExecutionPolicy Bypass -Command "& { ^
    $categoryName = '%category_name%'; ^
    $colorCode = '%color_code%'; ^
    ^
    if (-not (Test-Path 'index.html')) { ^
        Write-Host '❌ index.htmlが見つかりません' -ForegroundColor Red; ^
        exit 1; ^
    } ^
    ^
    $content = Get-Content 'index.html' -Encoding UTF8; ^
    $newContent = @(); ^
    $inserted = $false; ^
    ^
    for ($i = 0; $i -lt $content.Length; $i++) { ^
        $newContent += $content[$i]; ^
        if ($content[$i] -match '^\s*/\*.*CSS.*\*/' -and -not $inserted) { ^
            $cssLines = @(); ^
            $cssLines += \"      .$categoryName::before {\"; ^
            $cssLines += \"        background: $colorCode;\"; ^
            $cssLines += \"      }\"; ^
            $newContent += $cssLines; ^
            $inserted = $true; ^
        } ^
    } ^
    ^
    if (-not $inserted) { ^
        # 172行目付近に挿入 ^
        $insertLine = 172; ^
        if ($content.Length -gt $insertLine) { ^
            $cssLines = @(); ^
            $cssLines += \"      .$categoryName::before {\"; ^
            $cssLines += \"        background: $colorCode;\"; ^
            $cssLines += \"      }\"; ^
            $newContent = $content[0..($insertLine-1)] + $cssLines + $content[$insertLine..($content.Length-1)]; ^
        } ^
    } ^
    ^
    $newContent | Set-Content 'index.html' -Encoding UTF8; ^
}"

if errorlevel 1 (
    echo ❌ CSSスタイルの追加に失敗しました
    exit /b 1
)
echo ✅ CSSスタイルを追加しました

REM 3. index.htmlにカテゴリカードを追加
echo ℹ️  カテゴリカードを追加しています...

powershell -NoProfile -ExecutionPolicy Bypass -Command "& { ^
    $categoryName = '%category_name%'; ^
    $displayName = '%display_name%'; ^
    $description = '%description%'; ^
    ^
    $content = Get-Content 'index.html' -Encoding UTF8; ^
    $newContent = @(); ^
    $inserted = $false; ^
    ^
    for ($i = 0; $i -lt $content.Length; $i++) { ^
        $newContent += $content[$i]; ^
        if ($content[$i] -match '^\s*<!--.*カテゴリ.*-->' -and -not $inserted) { ^
            $cardLines = @(); ^
            $cardLines += \"          <a href=\"\"./$categoryName/\"\" class=\"\"platform-card $categoryName\"\">\"; ^
            $cardLines += \"            <h2 class=\"\"platform-name\"\">${displayName}</h2>\"; ^
            $cardLines += \"            <p class=\"\"platform-description\"\">\"; ^
            $cardLines += \"              $description\"; ^
            $cardLines += \"            </p>\"; ^
            $cardLines += \"            <div class=\"\"platform-stats\"\">\"; ^
            $cardLines += \"              <span class=\"\"icon-count\"\" data-category=\"\"$categoryName\"\"\"; ^
            $cardLines += \"                >... アイコン</span\"; ^
            $cardLines += \"              >\"; ^
            $cardLines += \"              <span class=\"\"visit-button\"\"探索する →</span>\"; ^
            $cardLines += \"            </div>\"; ^
            $cardLines += \"          </a>\"; ^
            $newContent += $cardLines; ^
            $inserted = $true; ^
        } ^
    } ^
    ^
    if (-not $inserted) { ^
        # 602行目付近に挿入 ^
        $insertLine = 602; ^
        if ($content.Length -gt $insertLine) { ^
            $cardLines = @(); ^
            $cardLines += \"          <a href=\"\"./$categoryName/\"\" class=\"\"platform-card $categoryName\"\">\"; ^
            $cardLines += \"            <h2 class=\"\"platform-name\"\">${displayName}</h2>\"; ^
            $cardLines += \"            <p class=\"\"platform-description\"\">\"; ^
            $cardLines += \"              $description\"; ^
            $cardLines += \"            </p>\"; ^
            $cardLines += \"            <div class=\"\"platform-stats\"\">\"; ^
            $cardLines += \"              <span class=\"\"icon-count\"\" data-category=\"\"$categoryName\"\"\"; ^
            $cardLines += \"                >... アイコン</span\"; ^
            $cardLines += \"              >\"; ^
            $cardLines += \"              <span class=\"\"visit-button\"\"探索する →</span>\"; ^
            $cardLines += \"            </div>\"; ^
            $cardLines += \"          </a>\"; ^
            $newContent = $content[0..($insertLine-1)] + $cardLines + $content[$insertLine..($content.Length-1)]; ^
        } ^
    } ^
    ^
    $newContent | Set-Content 'index.html' -Encoding UTF8; ^
}"

if errorlevel 1 (
    echo ❌ カテゴリカードの追加に失敗しました
    exit /b 1
)
echo ✅ カテゴリカードを追加しました

REM 4. 完了メッセージとNext Steps
echo.
echo ✅ カテゴリ「%category_name%」の追加が完了しました！
echo.
echo ℹ️  Next Steps:
echo 1. %category_name%/ フォルダに画像ファイル（PNG/SVG/JPG/JPEG/GIF）を配置してください
echo 2. Git でコミットしてプッシュしてください:
echo    git add -A
echo    git commit -m "✨ Add %category_name% category"
echo    git push
echo 3. GitHub Actions が自動実行され、以下が自動的に行われます：
echo    - 画像ファイルを PNG に変換・最適化
echo    - template/index.html を各カテゴリにコピー
echo    - icons.json、metadata.json、search-index.json を生成
echo    - GitHub Pages にデプロイ
echo.
echo ℹ️  ファイル構造:
echo   %category_name%/
echo   └── （ここに画像ファイルを配置）

endlocal
exit /b 0