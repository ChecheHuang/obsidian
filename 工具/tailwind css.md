## 配置tailwindcss
``` bash

pnpm install -D tailwindcss@latest postcss@latest autoprefixer@latest 
npx tailwindcss init -p

echo '@tailwind base;
@tailwind components;
@tailwind utilities;' > src/index.css

echo "/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {},
  },
  plugins: [],
}" > tailwind.config.js;

rm src/App.css
echo "import React from 'react'

const App: React.FC = () => {
  return (
    <button className=\"shadow-md font-bold underline text-primary-dark\">
      Hello world!
    </button>
  )
}

export default App" > src/App.tsx
```


## 修改vite config及tsconfig.json

```bash
pnpm install -D @types/node

echo "import { defineConfig, loadEnv } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'
// https://vitejs.dev/config/
const baseConfig = {
  plugins: [react()],
  base: './',
  build: {
    outDir: 'dist',
    chunkSizeWarningLimit: 1500,
    rollupOptions: {
      output: {
        manualChunks(id) {
          if (id.includes('node_modules')) {
            return id
              .toString()
              .split('node_modules')[1]
              .split('/')[0]
              .toString()
          }
        },
      },
    },
  },
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
      proxy: {
        '/api': {
          target: loadEnv('development', process.cwd()).VITE_APP_BASE_API,
          changeOrigin: true,
          rewrite: (path) => path.replace('/api', 'api'),
        },
      },
    },
  },
  default: baseConfig,
}
export default defineConfig(({ mode = 'default' }) => {
  const extendConfig = actions[mode] ? actions[mode] : actions['development']
  return mergeObjects(baseConfig, extendConfig)
})
function mergeObjects(obj1, obj2) {
  const result = { ...obj1 }
  for (const key in obj2) {
    if (Object.prototype.hasOwnProperty.call(obj2, key)) {
      if (Array.isArray(obj2[key]) && Array.isArray(obj1[key])) {
        result[key] = obj1[key].concat(obj2[key])
      } else if (
        typeof obj2[key] === 'object' &&
        Object.prototype.hasOwnProperty.call(obj1, key)
      ) {
        result[key] = mergeObjects(obj1[key], obj2[key])
      } else {
        result[key] = obj2[key]
      }
    }
  }
  return result
}
" > vite.config.ts;

echo '{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,

    /* Bundler mode */
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",

    /* Linting */
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["src", "../createRouter.js"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
' > tsconfig.json;



```