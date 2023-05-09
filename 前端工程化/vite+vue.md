```
npm init vite
or
yarn create vite
```

## Eslint

``` 
yarn add -D  eslint  eslint-plugin-vue eslint-plugin-import vue-eslint-parser eslint-config-airbnb-base @typescript-eslint/parser @typescript-eslint/eslint-plugin
```

``` json
// .eslintrc.cjs
module.exports = {
  root: true,
  globals: {
    defineProps: "readonly",
    defineExpose: "readonly",
    defineEmits: "readonly",
    withDefaults: "readonly",
  },
  extends: [
    "plugin:@typescript-eslint/recommended",
    "plugin:vue/vue3-recommended",
    "airbnb-base",
  ],
  parserOptions: {
    parser: "@typescript-eslint/parser",
    ecmaVersion: "latest",
  },
  rules: {
    "no-console": process.env.NODE_ENV === "production" ? "warn" : "off",
    "no-debugger": process.env.NODE_ENV === "production" ? "warn" : "off",
    // 关闭函数名后面必须有空格的验证
    "space-before-function-paren": 0,
    // 关闭强制不变的变量使用 const, 因为自动格式化 有时候会把 let 变成 const
    "perfer-const": 0,
    // 允许行尾分号
    semi: 0,
    // 允许尾后逗号
    "comma-dangle": 0,
    "linebreak-style": ["off", "windows"],
    quotes: "off",
  },
};

```

```
// .eslintignore
# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*
lerna-debug.log*

node_modules
dist
dist-ssr
*.local
.history

# Editor directories and files
.vscode/*
!.vscode/extensions.json
.idea
.DS_Store
*.suo
*.ntvs*
*.njsproj
*.sln
*.sw?

// 不加这两个会报错
.cz-config.js
package.json
```

```
git init
```

```
git add .
```

```
git commit -m "init"
```

## 自動格式化
```
yarn add -D husky lint-staged commitizen commitlint cz-customizable commitlint-config-cz @commitlint/config-conventional
```

```
npm set-script prepare "husky install"
```

```
npm run prepare
```

```
npx husky add .husky/pre-commit "npx lint-staged --allow-empty"
```

``` json
//package.json
"lint-staged": { "*.{js,jsx,ts,tsx,vue,json}": [ "eslint --fix" ] }
```

``` typescript
import { createApp } from 'vue'
import './style.css'
import App from './App.vue'

createApp(App).mount('#app')
//test
const a = 1;
if (a === 1) {
  // 拿掉以下註解跟沒拿掉分開測試
  console.log("!");
}
```

```
git commit -am "test:測試husky"
```

## 配置commitlint

```
npx husky add .husky/commit-msg 'npx --no-install commitlint --edit "$1"'
```

``` javascript!=
// commitlint.config.js
module.exports = {
  extends: ['cz'],
  rules: {
  },
};
```

``` javascript
// .cz-config.js
module.exports = {
  types: [
    { value: "🚀 新增", name: "新增: 新的內容" },
    { value: "🐛 修復", name: "修復: 修復一個錯誤" },
    { value: "📝 文檔", name: "文檔: 變更的只有文檔" },
    { value: "🏠 格式", name: "格式: 空格, 分號等格式修復" },
    { value: "♻️ 重構", name: "重構: 代碼重構，注意和特性、修復區分開" },
    { value: "⚡️ 性能", name: "性能: 提升性能" },
    { value: "✅ 測試", name: "測試: 添加一個測試" },
    { value: "🔨 工具", name: "工具: 開發工具變動(構建、腳手架工具等)" },
    { value: "⏪ 回滾", name: "回滾: 代碼回退" },
  ],

  // 指定你的專案的特定範圍
  scopes: [],
  messages: {
    type: "選擇一種你的提交類型: \n",
    cope: "選擇一個scope（可選）\n：",
    customScope: "請輸入修改範圍(可選): \n",
    subject: "短說明: \n",
    body: '長說明，使用"|" 換行(可選)：\n',
    breaking: "非兼容性說明(可選): \n",
    footer: "關聯關閉的issue，例如：#31, #34(可選): \n",
    confirmCommit: "確定提交說明? \n",
  },
  // 跳過空的scope
  skipEmptyScopes: true,
  skipQuestions: ["scopes", "breaking", "body", "footer"],
  // 設置為true，在scope 選擇的時候，會有empty 和custom 可以選擇
  // 顧名思義，選擇empty 表示scope 缺省，如果選擇custom，則可以自己輸入信息
  allowCustomScopes: true,
  // 只有我們type 選擇了feat 或者是fix，才會詢問我們breaking message.
  allowBreakingChanges: ["feat", "fix"],
};
```

``` json
// package.json
  "type": "module",//此行刪除
  "scripts": {
    "commit": "git-cz",
    "commit:all": "git add . && git-cz",
  },
  "config": {
    "commitizen": {
      "path": "node_modules/cz-customizable"
    }
  }
```

```
git add .
yarn commit
或者
yarn commit:all
```

```
//如果要自動推送
npx husky add .husky/post-commit 'git push'
```