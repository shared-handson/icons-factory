# 新カテゴリ追加テンプレート

## 使用方法

### 1. フォルダの複製とアイコン配置
```bash
# 例：Azureカテゴリを追加する場合
cp -r template/ azure/
cd azure/
rm sample-icon.png .gitkeep

# アイコンファイルを配置
# *.png ファイルをここに置く
```

### 2. メインページの更新（手動）
`index.html` のプラットフォームカードセクションに新しいカードを追加：

```html
<a href="./azure/" class="platform-card azure">
    <div class="platform-icon">AZ</div>
    <h2 class="platform-name">Microsoft Azure</h2>
    <p class="platform-description">
        Azureサービスの公式アイコンCollection
    </p>
    <div class="platform-stats">
        <span class="icon-count">100+ アイコン</span>
        <span class="visit-button">探索する →</span>
    </div>
</a>
```

対応するCSSクラスも追加：
```css
.azure::before { background: #0078d4; }
.azure .platform-icon { background: linear-gradient(135deg, #0078d4, #106ebe); }
```

## 自動化された機能

✅ **HTML**: フォルダ名から自動でタイトル生成（編集不要）  
✅ **GitHub Actions**: 全フォルダを自動検知（追加不要）  
✅ **JSON生成**: アイコンリストを自動生成（設定不要）

## 完成後の確認事項

- [ ] フォルダ名が適切か
- [ ] アイコンファイルが配置されているか  
- [ ] メインページにカードを追加したか
- [ ] ローカルでHTMLが正しく表示されるか

これだけで新しいカテゴリが追加できます！