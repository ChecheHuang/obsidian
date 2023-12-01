``` typescript!
// vite.config.ts
import { defineConfig, loadEnv } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'
// https://vitejs.dev/config/
const baseConfig = {
  plugins: [react()],
  base: './',
  build: {
    outDir: 'dist',
    chunkSizeWarningLimit: 6000,
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
    port: 3001,
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
      outDir: 'dist',
    },
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

```

## tsconfig.json
```json 
{
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
    "isolatedModules": false,
    "noEmit": true,
    "jsx": "react-jsx",
    "baseUrl": "./",
    "paths": {
      "@/*": ["src/*"]
    }
  },
  "include": ["src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}

```