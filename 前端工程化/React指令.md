## 環境建立

### 建立專案

```
npx create-vite . --template react-ts
```

### 安裝配置

#### 修改 package.json

```json
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

```bash
npm install
npm install --save axios
npm install --save-dev eslint-plugin-prettier eslint prettier eslint-plugin-import eslint-plugin-react eslint-plugin-jsx-a11y eslint-plugin-react-hooks eslint-config-react-app @typescript-eslint/eslint-plugin @typescript-eslint/parser husky lint-staged commitizen commitlint cz-customizable commitlint-config-cz @commitlint/config-conventional tailwindcss@latest postcss@latest autoprefixer@latest sass mockjs @types/mockjs vite-plugin-pages

git init
git add .
git commit -m "init"
npm set-script mock "vite --mode mock"
npm set-script dev "vite --mode development"
npm set-script prod "vite --mode production"
npm set-script build "vite build --mode production && tsc"
npm set-script lint "eslint src --ext ts,tsx --report-unused-disable-directives --max-warnings 0"
npm set-script prepare "husky install"
npm set-script commit "git-cz"
npm set-script commit:all "git add . && git-cz"
npm run prepare
npx husky add .husky/pre-commit "npx lint-staged --allow-empty"
npx husky add .husky/commit-msg 'npx --no-install commitlint --edit "$1"'
echo '{
  "compilerOptions": {
    "target": "ESNext",
    "useDefineForClassFields": true,
    "lib": ["DOM", "DOM.Iterable", "ESNext"],
    "allowJs": false,
    "skipLibCheck": true,
    "esModuleInterop": false,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "module": "ESNext",
    "moduleResolution": "Node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",
    "baseUrl": "./",
    "paths": {
      "@/*": ["src/*"]
    }
  },
  "include": ["src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}' > tsconfig.json;

echo "import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './index.css'
;(async () => {
  if (import.meta.env.MODE === 'mock') {
    console.log('引入 mock')
    const modules = import.meta.glob('@/mock/api/*.ts')
    Object.keys(modules).forEach(async (key) => {
      await modules[key]()
    })
    return
  }
})()

ReactDOM.createRoot(document.getElementById('root') as HTMLElement).render(
  // <React.StrictMode>
  <App />
  // </React.StrictMode>
)" > src/main.tsx;

mkdir -p src/styles && touch src/styles/global.scss && echo '$primary: green;' >> src/styles/global.scss && echo '$secondary: blue;' >> src/styles/global.scss && echo '$danger: red;' >> src/styles/global.scss;
echo "@tailwind base;" > ./src/index.css && echo "@tailwind components;" >> ./src/index.css && echo "@tailwind utilities;" >> ./src/index.css;

echo "module.exports = {
  plugins: [require('tailwindcss'), require('autoprefixer')],
}" > postcss.config.js;

echo "module.exports = {
  extends: ['cz'],
  rules: {},
}" > commitlint.config.js;

echo $'module.exports = {
  types: [
    { value: "\U0001F680 新增", name: "新增: 新的內容" },
    { value: "\U0001F41B 修復", name: "修復: 修復一個錯誤" },
    { value: "\U0001F4DD 文檔", name: "文檔: 變更的只有文檔" },
    { value: "\U0001F3E0 格式", name: "格式: 空格, 分號等格式修復" },
    { value: "\u267B\ufe0f 重構", name: "重構: 代碼重構，注意和特性、修復區分開" },
    { value: "\u26A1\ufe0f 性能", name: "性能: 提升性能" },
    { value: "\u2705 測試", name: "測試: 添加一個測試" },
    { value: "\U0001F528 工具", name: "工具: 開發工具變動(構建、腳手架工具等)" },
    { value: "\u23EA 回滾", name: "回滾: 代碼回退" },
  ],
  scopes: [],
  messages: {
    type: "選擇一種你的提交類型: \\n",
    scope: "選擇一個 scope（可選）\\n：",
    customScope: "請輸入修改範圍(可選): \\n",
    subject: "短說明: \\n",
    body: "長說明，使用\"|\" 換行(可選)：\\n",
    breaking: "非兼容性說明(可選): \\n",
    footer: "關聯關閉的 issue，例如：#31, #34(可選): \\n",
    confirmCommit: "確定提交說明? \\n",
  },
  skipEmptyScopes: true,
  skipQuestions: ["scopes", "breaking", "body", "footer"],
  allowCustomScopes: true,
  allowBreakingChanges: ["feat", "fix"],
};' > .cz-config.js;

echo "module.exports = {
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
};" > .eslintrc.cjs;

echo "dist/
node_modules/
src/serviceWorker.js
.cz-config.js
tsconfig.json
package.json" > .eslintignore;

echo "module.exports = {
  singleQuote: true,
  trailingComma: 'es5',
  semi: false,
  endOfLine: 'auto',
}" > .prettierrc.cjs;

echo "package-lock.json
node_modules/" > .prettierignore;

echo "/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {},
  },
  plugins: [],
}" > tailwind.config.js;

echo "import axios from 'axios'
import React from 'react'
const App: React.FC = () => {



  console.log(import.meta.env)

  return (
    <h1
      onClick={() => {
        axios
          .post('/api/test', { name: 'test' })
          .then((res) => {
            console.log(res.data)
          })
          .catch((err) => console.log(err))
      }}
      className=\"text-3xl font-bold underline\"
    >
      Hello world!
    </h1>
  )
}
export default App" > src/App.tsx;

rm src/App.css

echo "import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'
import pages from 'vite-plugin-pages'
// https://vitejs.dev/config/
const baseConfig = {
  plugins: [react()],
  server: {
    port: 3000,
    host: '0.0.0.0',
    open: false,
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
  css: {
    preprocessorOptions: {
      scss: {
        additionalData: '@import \"@/styles/global.scss\";',
      },
    },
  },
}
const actions = {
  production: {
    build: {
      outDir: 'production',
    },
    base: './',
  },
  development: {
    server: {
      port: 3000,
      host: '0.0.0.0',
      open: false,
      proxy: {
        '/api': {
          target: 'http://localhost:3000',
          changeOrigin: true,
          rewrite: (path) => path.replace('/api', 'api'),
        },
      },
    },
  },
  mock: {
    plugins: [react(), pages()],
  },
  default: baseConfig,
}
export default defineConfig(({ mode = 'default' }) => {
  const extendConfig = actions[mode] ? actions[mode] : actions['development']
  return { ...baseConfig, ...extendConfig }
})" > vite.config.ts;

mkdir -p src/mock
echo "import Mock from 'mockjs'
Mock.mock('/api/test', 'post', (options) => {
  const data = JSON.parse(options.body)
  return {
    status: 'success',
    message: '測試成功',
    data,
  }
})" > src/mock/test.ts;

echo "import Mock from 'mockjs'
Mock.mock('/api/test2', 'get', {
  'users|10': [
    {
      'id|+1': 1,
      name: '@cname',
      'age|18-60': 1,
      email: '@email',
      avatar: '@image(100x100)',
    },
  ],
})" > src/mock/test2.ts;
```

```bash
git add .
```

```bash
npm run commit
```

```bash
npm run mock
```

```
//如果要自動推送
npx husky add .husky/post-commit 'git push'
```
