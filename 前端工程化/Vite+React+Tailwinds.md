
## 環境建立

### 建立專案

```
npm init vite
```

### 啟動專案

```
cd project-name

npm install

npm run dev
```



### 建立Linter和format
 
```
npm install --save-dev  eslint-plugin-prettier eslint prettier eslint-plugin-import eslint-plugin-react eslint-plugin-jsx-a11y eslint-plugin-react-hooks eslint-config-react-app @typescript-eslint/eslint-plugin @typescript-eslint/parser husky lint-staged commitizen commitlint cz-customizable commitlint-config-cz @commitlint/config-conventional tailwindcss@latest postcss@latest autoprefixer@latest 
```


``` json
,
	//package.json "type": "module"刪掉這行加入下面
  "lint-staged": {
    "*.{js,jsx,ts,tsx,vue,json}": [
      "eslint --fix ."
    ]
  },
  "config": {
    "commitizen": {
      "path": "node_modules/cz-customizable"
    }
  }
```
### 增加以下檔案

``` css
///src/index.css
@tailwind base;
@tailwind components;
@tailwind utilities;
```

``` javascript
//postcss.config.js
module.exports = {
  plugins: [
    require('tailwindcss'),
    require('autoprefixer'),
  ],
}
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

``` javascript
//.eslintrc.cjs
module.exports = {
  extends: [
    'react-app',
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
  ],
  plugins: ['prettier', 'react-hooks', '@typescript-eslint'],
  parser: '@typescript-eslint/parser',
  rules: {
    'prettier/prettier': 'warn',
    'react-hooks/rules-of-hooks': 'error',
    'react-hooks/exhaustive-deps': 'warn',
  },
}

```

```
//.eslintignore
dist/
node_modules/
src/serviceWorker.js
.cz-config.js
package.json
```

```javascript
//.prettierrc.cjs
module.exports = {
  singleQuote: true,
  trailingComma: 'es5',
  semi: false,
  endOfLine: 'auto',
}
```

```
//.prettierignore
package-lock.json
node_modules/
```

``` javscript
//tailwind.config.js
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {},
  },
  plugins: [],
}
```


## 執行以下指令

```
git init
git add .
git commit -m "init"
npm set-script prepare "husky install"
npm set-script commit "git-cz"
npm set-script commit:all "git add . && git-cz"
npm run prepare
npx husky add .husky/pre-commit "npx lint-staged --allow-empty"
npx husky add .husky/commit-msg 'npx --no-install commitlint --edit "$1"'
```

重開編輯器
修改App.tsx為以下
``` tsx
import React from 'react'
const App: React.FC = () => {

  return <h1 className="text-3xl font-bold underline">Hello world!</h1>
}
export default App
```

```
git add .
```

```
yarn commit
```

```
//如果要自動推送
npx husky add .husky/post-commit 'git push'
```



