## Pandoc

### 基本使用 
[安裝Paodnc](https://www.pandoc.org/installing.html)
[安裝MiKTeX](https://miktex.org/)
查看字體
```
fc-list :lang=zh
```
加入YAML metadata 區塊
```
---
title: 使用 Pandoc 將 Markdown 轉為 PDF 文件
author: Carl Huang
date: "2020-01-13"
CJKmainfont: "微軟正黑體"
---
```
以下指令產出pdf
```
pandoc 'MarkDown to PDF.md' -o 'example.pdf' --pdf-engine=xelatex --toc --toc-depth=4
```

### 使用 Eisvogel LaTeX template 樣式
[Eisvogel LaTex template](https://github.com/Wandmalfarbe/pandoc-latex-template/releases/latest)

移動eisvogel.tex到以下資料夾
```
C:\Users\LT10s\AppData\Roaming\pandoc\eisvogel.tex
```
整合使用
```
---
title: 使用 Pandoc 將 Markdown 轉為 PDF 文件
author: Carl Huang
date: "2020-01-13"
CJKmainfont: "微軟正黑體"
subject: "Pandoc 轉檔教學"
keywords: [Markdown, Pandoc]
titlepage: true,
titlepage-rule-color: "360049"
titlepage-background: "background.pdf"
---
```
產出pdf
```
pandoc "MarkDown to PDF.md" -o "example_with_template.pdf" --pdf-engine=xelatex --toc --toc-depth=4 --from markdown --template=eisvogel --listings
```

### 整理參數
YAML metadata可使用參數代替
example:
```
pandoc "MarkDown to PDF.md" -o "example_with_template.pdf" --pdf-engine=xelatex --toc --toc-depth=4 --from markdown --template=eisvogel --listings --variable CJKmainfont="微軟正黑體" --variable title="使用 Pandoc 將 Markdown 轉為 PDF 文件" --variable author="Carl Huang" 
```

#### 或使用lua-filter
步驟如下
產生filter.lua放在路徑
`C:\Users\LT10s\AppData\Roaming\pandoc\filter`
以及background.pdf放在路徑
`C:\Users\LT10s\AppData\Roaming\pandoc`
``` lua
function Meta(meta)
  meta.title = "使用 Pandoc 將 Markdown 轉為 PDF 文件"
  meta.author = "Carl Huang"
  meta.date = os.date("%Y-%m-%d")
  meta.CJKmainfont = "微軟正黑體"
  meta.subject = "Pandoc 轉檔教學"
  meta.keywords = { "Markdown", "Pandoc" }
  meta.titlepage = true
  meta["titlepage-rule-color"] = "360049"
  meta["titlepage-background"] = "C:/Users/LT10s/AppData/Roaming/pandoc/background.pdf"
  return meta
end
```
需要支援mermaid流程圖需要

```
npm install --global mermaid-filter
```

如果抓不到需要到環境變數設定

##### ![](files/Pasted%20image%2020230516161552.png)

執行以下
```
pandoc "MarkDown to PDF.md"  --pdf-engine=xelatex --toc --toc-depth=4 --from markdown --template=eisvogel --listings --lua-filter=C:\\Users\\LT10s\\AppData\\Roaming\\pandoc\\filter\\filter.lua -F  mermaid-filter.cmd -o "example_with_template.pdf"
```


#### 整合obsidian pandoc plugin 

##### ![](files/Pasted%20image%2020230516161648.png)


```
//執行以下plugin
Pandoc Plugin:Export as PDF(via LaTeX)
```

### 改用 WeasyPrint

[安裝Python]([https://www.python.org/downloads/](https://www.python.org/downloads/))
[安裝weasyprint](https://doc.courtbouillon.org/weasyprint/stable/first_steps.html#installation)
[安裝GTK](https://github.com/tschoonj/GTK-for-Windows-Runtime-Environment-Installer/releases)

```
pip install weasyprint
```
執行
```
weasyprint input.html output.pdf
```
pandoc使用weasyprint
```
pandoc 123.md --css=style-portrait.css --standalone --toc --toc-depth=4  --pdf-engine weasyprint --template=template  -o zzz.html
```

```
 pandoc 123.md --css=style-portrait.css --standalone --toc --toc-depth=4 --pdf-engine=C:/Users/LT10s/AppData/Local/Programs/Python/Python311/Scripts/weasyprint.exe -o zzz.html
```

### 客製化
準備 input.md lua css html
參照md轉pdf
寫一個bash markpdf.cmd
範例如下
```cmd 
pandoc input.md -o input.html --pdf-engine=C:/Users/LT10s/AppData/Local/Programs/Python/Python311/Scripts/weasyprint.exe --lua-filter=C:\\Users\\LT10s\\AppData\\Roaming\\pandoc\\filter\\weasyprint-filter.lua --css=./pandoc/mycss.css --standalone --toc --toc-depth=4 --template=./pandoc/myTemplate -F mermaid-filter.cmd 

node ./pandoc/changeHtml.js

weasyprint input.html output.pdf

rm input.html
rm mermaid-filter.err
```
執行
```
makepdf.cmd
```




## vscode extensions
<h1>Markdown Preview Enhanced</h1>
 <h1>Markdown PDF(z)</h1>
 <h1>Paste Image</h1>

<h1>Markdown Tables</h1>

### vscode setting
``` json
//setting.json
  "markdown-preview-enhanced.latexEngine": "xelatex",
  "markdown-pdf": {
    "headerTemplate": "<span style=\"font-size: 8pt;\">Page <span class=\"pageNumber\"></span> of <span class=\"totalPages\"></span></span>",
    "footerTemplate": "<div style='text-align: center; width:100vw'><span style='font-size: 8pt;'>第 <span class='pageNumber'></span> 頁</span></div>",
    "breaks": "false"
  },
  "[markdown]": {
    "editor.quickSuggestions": {
      "other": "on",
      "comments": "on",
      "strings": "on"
    }
  },
  "pasteImage.path": "${currentFileDir}/files",
  "pasteImage.autoFilename": true,
```
### snippets setting
``` json
//markdown.json
{
  "nextPage": {
    "prefix": "next",
    "body": [
      "<div style='page-break-after: always;'>",
      "<span style='color:white'>下一頁</span>&nbsp;",
      "</div>"
    ],
    "description": "換下一頁"
  },
  "table": {
    "prefix": "table",
    "body": [
      "<div class='title'>test</div>",
      "<table data-cols='3'>",
      "<tbody>",
      "    <tr>",
      "    <td>Row 1, Column 1</td>",
      "    <td>Row 1, Column 2</td>",
      "    <td>Row 1, Column 3</td>",
      "    </tr>",
      "    <tr>",
      "    <td>Row 2, Column 1</td>",
      "    <td>Row 2, Column 2</td>",
      "    <td>Row 2, Column 3</td>",
      "    </tr>",
      "</tbody>",
      "</table>"
    ],
    "description": "HTML表格"
  },
  "tableStyle": {
    "prefix": "tableStyle",
    "body": [
      "<style>",
      "table {",
      "    width: 100vw;",
      "    border: 1px solid black;",
      "    border-collapse: collapse;",
      "}",
      "tbody td {",
      "    border: 1px solid black;",
      "    padding: 8px;",
      "    text-align: center;",
      "    width: calc(100% / var(--cols));",
      "}",
      ".title {",
      "    width: 100%;",
      "    text-align: center;",
      "    font-size: 30px;",
      "    margin-bottom: 15px;",
      "}",
      "</style>"
    ],
    "description": "table的格式"
  }
}
```
### use 
```
// 產出pdf
>markdown PDF:Export(pdf)
// 產生目錄
> create toc
// 貼上圖片
>Paste Image
ctrl+alt+v
```

### 使用  Markdown Preview Enhanced pandoc須加上以下
```
---
title: "Habits"
author: John Doe
date: March 22, 2005
output:
  pdf_document:
    toc: true
    toc_depth: 4
    latex_engine: xelatex
---
```
其餘參考如下
[Markdown Preview Enhanced](https://shd101wyy.github.io/markdown-preview-enhanced/#/)


