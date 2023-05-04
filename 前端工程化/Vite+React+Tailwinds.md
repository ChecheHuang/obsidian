
## 環境建立

### 建立專案


```

npm init vite

```

### 啟動專案

```

cd learn-react

npm install

npm run dev

```

### 建立Linter和format

#### 安裝套件

1. `eslint-config-react-app`

使用eslint 需再.eslintrc內加入 "extends": ["react-app"]

2. `prettier`

Code formatter寫作風格

3. `eslint-plugin-prettier`

把prettier當作eslint規則

4. `eslint-plugin-react-hooks`  

檢查Hook

5. `eslint-plugin-jsx-a11y`  

accessibility的簡寫 無障礙網頁設計規範

6. `eslint-plugin-import`

檢查es6導入/導出語法

7. `eslint-plugin-react`

使用react特定的eslint規則

```

npm install --save-dev eslint-plugin-prettier prettier eslint-config-react-app eslint-plugin-import eslint-plugin-react eslint-plugin-jsx-a11y eslint-plugin-react-hooks

```

#### src下新增檔案

##### eslint規則

.eslintrc

```json

{

  "extends": ["react-app"],

  "plugins": ["prettier", "react-hooks"],

  "rules": {

    "prettier/prettier": "warn",

    "react-hooks/rules-of-hooks": "error",

    "react-hooks/exhaustive-deps": "warn"

  }

}

  

```

##### prettier規則

.prettierrc

```json

{

    "singleQuote": true,

    "trailingComma": "es5",

    "semi": false,

    "endOfLine": "auto"

}

```

##### eslint忽略檔案

.eslintignore

```

build/

node_modules/

src/serviceWorker.js

```

##### prettier忽略檔案

.prettierignore

```

package-lock.json

node_modules/

```

