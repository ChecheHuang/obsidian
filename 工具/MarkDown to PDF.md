# MarkDown to PDF
## vscode extensions
### Markdown Preview Enhanced
### MMarkdown PDF(z)
### Paste Image

## vscode setting
``` json
//setting.json
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
## snippets setting
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
## use 
```
// 產出pdf
>markdown PDF:Export(pdf)
// 產生目錄
> create toc
// 貼上圖片
>Paste Image
ctrl+alt+v
```
