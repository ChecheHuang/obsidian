## init
```bash
npm init -y
```

```bash
npm install body-parser dotenv express http-errors jsonwebtoken mysql2

npm install -D @types/express @types/http-errors @types/jsonwebtoken @types/node @typescript-eslint/eslint-plugin @typescript-eslint/parser cross-env eslint eslint-config-prettier eslint-plugin-prettier prettier prisma ts-node-dev tsconfig-paths typescript

npx tsc --init
```

## package.json
```json
  "scripts": {
    "dev": "cross-env NODE_ENV=development ts-node-dev -r ./tsconfig-paths-bootstrap.js src/server.ts",
    "start": "npm run build && cross-env NODE_ENV=production node ./dist/src/server.js",
    "build": "npx tsc"
  },
```

## tsconfig.json
```json
{
  "compilerOptions": {
    "target": "es5",
    "module": "commonjs",
    "lib": ["es6"],
    "allowJs": true,
    "outDir": "dist",
    "rootDir": "src",
    "strict": true,
    "noImplicitAny": true,
    "esModuleInterop": true,
    "resolveJsonModule": true,
    "baseUrl": "./",
    "paths": {
      "@/*": ["src/*"]
    }
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

## tsconfig-paths-bootstrap.js
```javascript
const tsConfigPaths = require("tsconfig-paths");

const baseUrl = "./"; 
const { paths } = require("./tsconfig.json").compilerOptions;

tsConfigPaths.register({
  baseUrl,
  paths,
});

```

## .eslintrc
```json
{
  "root": true,
  "parser": "@typescript-eslint/parser",
  "plugins": ["@typescript-eslint", "prettier"],
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "prettier/@typescript-eslint",
    "plugin:prettier/recommended"
  ],
  "env": {
    "commonjs": true,
    "es6": true,
    "node": true
  },
  "parserOptions": {
    "ecmaVersion": 2020
  },
  "rules": {
    "prettier/prettier": "error"
  }
}
```

## .pretterrc
```json
{
    "singleQuote": true,
    "trailingComma": "es5",
    "printWidth": 130,
    "semi": false,
    "endOfLine": "auto"
}
```


## .eslintignore
```json
dist
node_modules
```